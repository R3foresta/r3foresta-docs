# Tarea 04 — Política FIFO de mermas sobre asignaciones

**Área:** Backend
**Severidad:** Importante
**Depende de:** 01, 02
**Bloquea a:** 08
**Referencias:** Addendum sección 7

---

## 1. Contexto

Cuando ocurre una `MERMA` en un lote que tiene asignaciones activas en M3, el sistema debe decidir cómo absorbe esa pérdida sin romper saldos. La política aprobada es:

1. La merma afecta primero el **saldo no asignado** del lote.
2. Si excede el saldo no asignado, el remanente se distribuye sobre **asignaciones activas en orden FIFO** (asignación más antigua primero).
3. `cantidad_asignada` **nunca se modifica**: se aumenta `cantidad_mermada`.

Hoy el flujo de `MERMA` en M2 no sabe nada de asignaciones, así que afecta el `saldo_vivo_actual` global del lote sin contemplar reservas.

---

## 2. Cambio requerido

### 2.1. Algoritmo

Pseudocódigo del handler de `MERMA` (extiende el existente):

```
crear_merma(lote_id, cantidad_merma, causa, responsable_id):
  begin transaction
    lock_filas_asignacion_activa(lote_id) for update

    saldo_no_asignado = lote.saldo_vivo_actual
                      - sum(asignacion.saldo_asignado_disponible
                            where lote = lote_id and estado = 'ACTIVA')

    if cantidad_merma <= saldo_no_asignado:
      // caso simple: no toca asignaciones
      insertar evento MERMA con afectacion_asignaciones = []
    else:
      excedente = cantidad_merma - saldo_no_asignado
      asignaciones_fifo = asignaciones activas del lote ordenadas por fecha_asignacion asc
      afectaciones = []

      for asig in asignaciones_fifo:
        if excedente <= 0: break
        a_mermar = min(asig.saldo_asignado_disponible, excedente)
        update asignacion set cantidad_mermada = cantidad_mermada + a_mermar
        afectaciones.append({asignacion_id: asig.id, cantidad: a_mermar})
        excedente -= a_mermar

      if excedente > 0:
        rollback // merma mayor que saldo total del lote → inválido

      insertar evento MERMA con metadata.afectacion_asignaciones = afectaciones

    el trigger existente de MERMA descuenta lote.saldo_vivo_actual
  commit
```

### 2.2. Almacenamiento de afectaciones

Hay dos opciones para registrar qué asignaciones fueron afectadas:

- **Opción A (recomendada):** usar `metadata jsonb` en el evento `MERMA` con un array de `{asignacion_id, cantidad}`. No requiere tabla nueva. Fácil de leer en auditoría.
- **Opción B:** crear una tabla `merma_afectacion_asignacion (evento_id, asignacion_id, cantidad)`. Más normalizada, requiere migración.

**Decisión recomendada:** Opción A para el MVP. Migrar a tabla relacional si la auditoría granular lo demanda.

### 2.3. Validaciones

- `cantidad_merma > 0`.
- `cantidad_merma <= lote.saldo_vivo_actual` (no se puede mermar más de lo que hay físicamente).
- La merma puede dejar `saldo_asignado_disponible = 0` en una asignación pero **no negativo** (el `min()` del algoritmo lo garantiza).

### 2.4. Notificaciones

Al final del commit exitoso, si `afectaciones` no está vacío:

- Encolar una notificación por cada `subcampania_id` distinta afectada, dirigida al coordinador de esa subcampaña.
- Ver tarea **08** para el contrato de notificación.

---

## 3. Criterios de aceptación

- [ ] Merma menor que saldo no asignado: ninguna asignación cambia.
- [ ] Merma que excede el saldo no asignado: la asignación más antigua se afecta primero, hasta agotarse, luego la siguiente.
- [ ] `cantidad_asignada` nunca se modifica.
- [ ] Si la merma supera el saldo vivo del lote, la operación falla completa (rollback).
- [ ] El evento `MERMA` queda con `metadata.afectacion_asignaciones` poblado correctamente cuando hubo afectación.
- [ ] Concurrencia: dos mermas paralelas sobre el mismo lote no producen saldos inconsistentes (lock pesimista).
- [ ] Tras la merma, la suma de todos los saldos de las asignaciones + saldo no asignado = `saldo_vivo_actual` del lote.

---

## 4. Choques con el sistema actual

- **Handler actual de `MERMA`:** asume que solo afecta saldo vivo del lote, sin contemplar reservas. Hay que extenderlo. **No introducir un endpoint nuevo**: la operación de merma sigue siendo una sola desde la perspectiva del usuario de vivero.
- **Lectura de saldos en UI:** cualquier vista del operario de vivero que muestre "saldo disponible" debe pasar a usar `saldo_vivo_disponible_asignacion` (tarea 05), no `saldo_vivo_actual`. Hasta que esa tarea esté lista, el operario podría tratar de despachar manualmente lo que está reservado. **Mitigación temporal:** la API de despacho manual debe validar contra `saldo_vivo_disponible_asignacion`.

---

## 5. Archivos a tocar

- Backend M2: handler de creación de evento `MERMA`.
- Backend M2: validación de despacho manual contra saldo disponible (mitigación).
- Tests de integración: `merma_fifo.spec.ts`.
