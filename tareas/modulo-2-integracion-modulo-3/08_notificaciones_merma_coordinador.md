# Tarea 08 — Notificación al coordinador por merma sobre asignación

**Área:** Backend + Frontend
**Severidad:** Importante
**Depende de:** 04
**Referencias:** Addendum sección 14.4

---

## 1. Contexto

Cuando una merma en un lote afecta una asignación activa de una subcampaña, el coordinador de esa subcampaña debe enterarse sin tener que monitorear el vivero. La política FIFO de mermas (tarea 04) ya identifica qué asignaciones se afectan; falta la pieza de notificación.

---

## 2. Cambio requerido

### 2.1. Disparador

Al final de la transacción de merma (tarea 04), si `afectacion_asignaciones` no está vacío:

```
para cada asignacion_id en afectaciones:
  obtener subcampania = asignacion.subcampania
  obtener coordinador = subcampania.coordinador
  encolar_notificacion(coordinador, payload)
```

### 2.2. Payload de la notificación

```json
{
  "tipo": "MERMA_AFECTA_ASIGNACION",
  "subcampania_id": 17,
  "subcampania_nombre": "Cota Cota",
  "lote_vivero_id": 42,
  "lote_codigo_trazabilidad": "VIV-LOTE-007-REC-12345",
  "cantidad_mermada": 35,
  "nuevo_saldo_asignado_disponible": 65,
  "fecha_merma": "2026-05-21T14:32:11Z",
  "causa_merma": "SEQUIA",
  "responsable_merma_id": 8,
  "responsable_merma_nombre": "Juan Mamani"
}
```

### 2.3. Canal

**Decisión abierta:** ¿in-app (panel de notificaciones), email, push, o todos?

Recomendación MVP: **in-app + email**. La urgencia es media (no bloquea operativa inmediata), pero el coordinador necesita reasignar stock.

### 2.4. Sistema de notificaciones

**Decisión abierta:** ¿existe ya un sistema de notificaciones en el proyecto, o hay que crearlo?

Antes de implementar:

1. Verificar si M1 o M2 ya tienen un mecanismo de notificaciones (revisar [vivero-module/02_doc_guia_viviero.md](../../vivero-module/02_doc_guia_viviero.md) y código del backend).
2. Si existe, reutilizar.
3. Si no existe, **considerar diferirlo del MVP** y reemplazarlo por una vista de "Alertas" en el dashboard del coordinador que muestre estas afectaciones (alternativa pull en lugar de push).

### 2.5. Vista de alertas (alternativa pull)

Si se difiere el sistema de notificaciones formal, agregar al dashboard del coordinador una tab "Alertas" con:

- Asignaciones de sus subcampañas con `cantidad_mermada > 0`.
- Última merma que las afectó (fecha, causa, responsable).
- CTA "Ver lote afectado" → navega al historial del lote en M2.

Esto cumple el objetivo de informar sin requerir infraestructura push.

---

## 3. Criterios de aceptación

- [ ] Al ocurrir una merma con afectación, el coordinador de cada subcampaña afectada recibe una notificación (o ve la alerta en su dashboard según el canal elegido).
- [ ] La notificación contiene los datos suficientes para que el coordinador entienda qué pasó sin tener que cazar la info.
- [ ] Coordinadores con varias subcampañas afectadas por la misma merma reciben una notificación por subcampaña (no se agrupan).
- [ ] La notificación / alerta se marca como leída cuando el coordinador la abre.

---

## 4. Choques con el sistema actual

- **Falta de sistema de notificaciones:** si no existe, esta tarea bloquea hasta tener una decisión de arquitectura. La alternativa pull (sección 2.5) es viable como puente.
- **Identificación del coordinador:** depende de la tabla `SUBCAMPANIA` con campo `coordinador_id`, que aún no existe (Módulo 3). Hasta que esa tabla esté creada, esta tarea no puede ejecutarse.

---

## 5. Archivos a tocar

- Backend M2 / M3: handler de merma (extensión de la tarea 04) para encolar notificaciones.
- Backend: módulo de notificaciones (si no existe, scope separado).
- Frontend M3: tab "Alertas" en dashboard del coordinador (si se opta por la alternativa pull).
