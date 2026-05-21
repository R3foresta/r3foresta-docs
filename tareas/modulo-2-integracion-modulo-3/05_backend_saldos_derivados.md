# Tarea 05 — Cálculo de saldos derivados

**Área:** Backend
**Severidad:** Importante
**Depende de:** 01, 02
**Bloquea a:** 06
**Referencias:** Addendum sección 6

---

## 1. Contexto

Hoy el sistema solo expone `LOTE_VIVERO.saldo_vivo_actual`, que cuenta plantas físicas en el vivero. Con la entrada de M3, hay dos saldos nuevos que deben quedar disponibles para la UI y para validar nuevas asignaciones / despachos:

- `saldo_asignado_disponible` por asignación.
- `saldo_vivo_disponible_asignacion` por lote.

El primero ya se calcula automáticamente como columna `GENERATED` en la tarea 02. El segundo necesita una vista o endpoint.

---

## 2. Cambio requerido

### 2.1. `saldo_asignado_disponible`

Ya es columna `GENERATED ALWAYS AS ... STORED` en `asignacion_vivero_subcampania` (ver tarea 02). No requiere trabajo adicional aquí.

### 2.2. `saldo_vivo_disponible_asignacion` (por lote)

**Decisión abierta:** ¿vista, query en endpoint, o columna materializada con trigger?

Recomendación para MVP: **vista SQL**. Simple, sin riesgo de desync.

```sql
create or replace view v_lote_vivero_saldos as
select
  lv.id as lote_id,
  lv.saldo_vivo_actual,
  coalesce(sum(a.saldo_asignado_disponible) filter (where a.estado = 'ACTIVA'), 0)
    as saldo_asignado_total,
  lv.saldo_vivo_actual
    - coalesce(sum(a.saldo_asignado_disponible) filter (where a.estado = 'ACTIVA'), 0)
    as saldo_vivo_disponible_asignacion
from lote_vivero lv
left join asignacion_vivero_subcampania a on a.lote_vivero_id = lv.id
group by lv.id, lv.saldo_vivo_actual;
```

### 2.3. Endpoint expuesto

`GET /api/lotes-vivero/:id/saldos` devuelve:

```json
{
  "lote_id": 42,
  "saldo_vivo_actual": 500,
  "saldo_asignado_total": 230,
  "saldo_vivo_disponible_asignacion": 270,
  "asignaciones_activas": [
    {
      "id": 12,
      "subcampania_id": 3,
      "subcampania_nombre": "Cota Cota",
      "proposito": "PLANTACION_INICIAL",
      "cantidad_asignada": 100,
      "cantidad_consumida": 0,
      "cantidad_devuelta": 20,
      "cantidad_mermada": 0,
      "saldo_asignado_disponible": 80
    }
  ]
}
```

El desglose de asignaciones se usa en la vista operativa (tarea 06).

### 2.4. Validación de nueva asignación

Cuando un admin/coordinador crea una `ASIGNACION_VIVERO_SUBCAMPANIA`:

```
cantidad_asignada_solicitada <= saldo_vivo_disponible_asignacion del lote
```

El backend valida esto leyendo de la vista. Si falla, devuelve 422 con mensaje claro.

### 2.5. Validación de nuevo despacho manual

Cuando un operario de vivero crea un `DESPACHO` manual:

```
cantidad_despachada <= saldo_vivo_disponible_asignacion del lote
```

**No puede tocar stock reservado por subcampañas.** Si quiere despachar más, primero debe devolverse la reserva (acción del coordinador, no del operario de vivero).

---

## 3. Criterios de aceptación

- [ ] La vista `v_lote_vivero_saldos` devuelve datos consistentes para todos los lotes activos.
- [ ] Para un lote sin asignaciones, `saldo_vivo_disponible_asignacion = saldo_vivo_actual`.
- [ ] Para un lote con asignaciones, `saldo_vivo_actual = saldo_asignado_total + saldo_vivo_disponible_asignacion + (consumido por DESPACHO)`.

  > Nota: estrictamente, `saldo_asignado_total` solo cuenta lo *disponible* de las asignaciones; lo ya consumido descontó el `saldo_vivo_actual` vía DESPACHO. La identidad correcta es:
  >
  > `saldo_vivo_actual = saldo_vivo_disponible_asignacion + saldo_asignado_total`
- [ ] Un despacho manual que exceda `saldo_vivo_disponible_asignacion` devuelve 422.
- [ ] Una asignación nueva que exceda `saldo_vivo_disponible_asignacion` devuelve 422.

---

## 4. Choques con el sistema actual

- **API de despacho manual** valida hoy contra `saldo_vivo_actual`. Cambiar a `saldo_vivo_disponible_asignacion`. **Impacto:** despachos manuales que antes pasaban ahora pueden fallar si el lote tiene reservas activas. Ese es el comportamiento deseado, pero hay que comunicarlo al equipo de operación.
- **Performance:** la vista hace un `GROUP BY` por lote. Para listas largas, validar con `EXPLAIN`. Si el costo es alto, considerar materializar `saldo_asignado_total` como columna en `LOTE_VIVERO` con trigger desde `asignacion_vivero_subcampania`. Mantener decisión abierta hasta ver datos reales.

---

## 5. Archivos a tocar

- `database/supabase/04_create_view_lote_vivero_saldos.sql` (nuevo).
- Backend M2: endpoint `GET /api/lotes-vivero/:id/saldos`.
- Backend M2: validación en handler de despacho manual.
- Backend M3: validación en handler de creación de asignación.
