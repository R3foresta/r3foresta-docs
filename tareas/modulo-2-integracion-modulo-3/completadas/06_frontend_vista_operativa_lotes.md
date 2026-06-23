# Tarea 06 — Vista operativa de lotes con columnas derivadas

**Área:** Frontend (Módulo Vivero)
**Severidad:** Mejora
**Depende de:** 05
**Referencias:** Addendum sección 10

---

## 1. Contexto

La pantalla actual de lotes en el panel de vivero solo muestra `saldo_vivo_actual`. Eso ya no alcanza: el admin y el coordinador necesitan ver cuánto del stock está comprometido con subcampañas, cuánto queda libre, y desglose por asignación.

---

## 2. Cambio requerido

### 2.1. Columnas nuevas en la tabla principal

| Columna | Fuente | Comportamiento |
|---------|--------|----------------|
| `Saldo vivo` | `saldo_vivo_actual` | Lo que ya se muestra. Sin cambio. |
| `Saldo reservado` | `saldo_asignado_total` | Suma de saldos disponibles de asignaciones activas. |
| `Saldo libre` | `saldo_vivo_disponible_asignacion` | Diferencia. Es el único saldo que se puede reasignar o despachar manualmente. |
| `Asignaciones activas` | count + chevron expand | Cuántas asignaciones tiene el lote. Click expande el desglose. |

### 2.2. Fila expandible — desglose por asignación

Al expandir un lote, mostrar tabla anidada con una fila por asignación activa:

| Subcampaña | Campaña | Propósito | Cant. asignada | Consumida | Devuelta | Mermada | Saldo disp. | Coordinador | Fecha asignación |

Donde:

- **Subcampaña** y **Campaña**: nombre con link al detalle en M3.
- **Propósito**: badge `PLANTACION_INICIAL` (verde) o `REPOSICION` (naranja).
- **Mermada**: si `> 0`, mostrar en rojo con tooltip "Stock perdido por merma del lote".
- **Saldo disp.**: si `= 0`, fila grisada.

### 2.3. Indicador visual de compromiso

En la fila del lote, si `saldo_asignado_total > 0`, mostrar un badge `RESERVADO` al lado del nombre.

Si `saldo_vivo_disponible_asignacion = 0` (todo reservado), mostrar badge rojo `SIN STOCK LIBRE`.

### 2.4. Filtros

Añadir filtros sobre la tabla:

- "Solo lotes con stock libre" (toggle).
- "Solo lotes con asignaciones activas" (toggle).
- "Por subcampaña" (selector, requiere endpoint que devuelva lotes que contribuyen a una subcampaña dada).

---

## 3. Criterios de aceptación

- [ ] Un lote sin asignaciones muestra `Saldo reservado = 0` y `Saldo libre = Saldo vivo`.
- [ ] Un lote completamente reservado muestra badge `SIN STOCK LIBRE` y bloquea el botón "Despachar manual" desde esa fila.
- [ ] Expandir un lote muestra el desglose con datos consistentes (la suma de saldos disponibles + lo ya consumido por despachos debe cuadrar).
- [ ] Click en subcampaña navega al detalle de la subcampaña en M3.
- [ ] Las cantidades se refrescan sin recargar tras una nueva asignación o devolución (revalidación de query).

---

## 4. Choques con el sistema actual

- **El listado actual** probablemente cachea o solo lee `saldo_vivo_actual`. Hay que conectar al nuevo endpoint `GET /api/lotes-vivero/:id/saldos` (tarea 05) y al endpoint de listado que ahora devuelve los tres saldos por lote.
- **Botón "Despachar"** debe quedar deshabilitado o con tooltip claro si no hay stock libre, en lugar de fallar en backend tras el click.

---

## 5. Archivos a tocar

- Frontend M2: componente de listado de lotes (panel de vivero).
- Frontend M2: componente expandible de asignaciones por lote (nuevo).
- Frontend M2: tipos/queries para los nuevos campos.
