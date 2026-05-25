# Consumo del Vivero — Cómo salen los árboles hacia Plantación

> Documento operativo y técnico que explica **cómo se consume un lote de vivero**: desde que el árbol está vivo en bolsa hasta que sale efectivamente del inventario.
>
> Cubre los cuatro caminos posibles: **asignación**, **devolución**, **despacho automático** (desde Plantación) y **despacho manual** (otras salidas). Incluye reglas de saldos, choques entre caminos y diferencias con el flujo anterior al Módulo 3.
>
> Audiencia: equipo operativo de vivero, coordinadores de subcampaña, admin y desarrollo (backend + frontend).

---

## 1. Idea central

El **saldo vivo de un lote** (`LOTE_VIVERO.saldo_vivo_actual`) cuenta plantas físicamente presentes en el vivero. Ese saldo solo **disminuye** por dos eventos:

1. **`MERMA`** — pérdida real registrada por el operario de vivero.
2. **`DESPACHO`** — salida real hacia un destino (plantación, donación, venta, etc.).

Todo lo demás (asignaciones, devoluciones, reservas) es **contabilidad lógica** que vive en la tabla `ASIGNACION_VIVERO_SUBCAMPANIA`. No toca el saldo vivo del lote hasta que la planta sale físicamente.

```
                                ┌──────────────────────────┐
                                │   LOTE_VIVERO            │
                                │   saldo_vivo_actual = N  │
                                └────────────┬─────────────┘
                                             │
                  ┌──────────────────────────┼──────────────────────────┐
                  │                          │                          │
            (reserva lógica)            (salida real)              (pérdida real)
                  │                          │                          │
                  ▼                          ▼                          ▼
      ASIGNACION_VIVERO_         EVENTO_LOTE_VIVERO          EVENTO_LOTE_VIVERO
      SUBCAMPANIA                tipo = DESPACHO             tipo = MERMA
      (sin evento en M2)         (M2 disminuye saldo)        (M2 disminuye saldo)
```

---

## 2. Los tres saldos que conviven

| Saldo | Qué cuenta | Dónde vive | Cuándo cambia |
|-------|------------|------------|---------------|
| `saldo_vivo_actual` | Plantas físicamente vivas en el vivero | `LOTE_VIVERO` | Sube en `EMBOLSADO`; baja en `MERMA` y `DESPACHO` |
| `saldo_asignado_total` | Plantas vivas **reservadas** por subcampañas pero todavía no despachadas | Derivado de `ASIGNACION_VIVERO_SUBCAMPANIA` activas | Sube al asignar; baja al consumir, devolver o por merma LIFO |
| `saldo_vivo_disponible_asignacion` | Plantas vivas **libres** para asignar a nuevas subcampañas o despachar manualmente | Derivado: `saldo_vivo_actual − saldo_asignado_total` | Cambia indirectamente cuando cualquiera de los dos anteriores cambia |

Identidad fundamental:

```
saldo_vivo_actual = saldo_vivo_disponible_asignacion + saldo_asignado_total
```

Esa identidad debe mantenerse después de cada operación. Si se rompe, hay un bug.

A nivel de cada asignación:

```
saldo_asignado_disponible
  = cantidad_asignada
  − cantidad_consumida
  − cantidad_devuelta
  − cantidad_mermada
```

Donde `cantidad_asignada` es **inmutable** una vez creada la asignación. Los cuatro contadores se ajustan con cada evento; el quinto es columna `GENERATED`.

---

## 3. Los cuatro caminos de consumo

### 3.1. Camino A — Asignación (reserva lógica)

**Quién:** `ADMIN` o `COORDINADOR` de la subcampaña destino.
**Qué hace:** reserva una cantidad del saldo vivo del lote para una subcampaña específica, con un **propósito** explícito.
**Efecto en M2:** ninguno. El saldo vivo del lote **no cambia**.

#### Datos mínimos

- `lote_vivero_id` (lote de origen).
- `subcampania_id` (destino).
- `cantidad_asignada` (en `UNIDAD`, entero positivo).
- `proposito_asignacion`: `PLANTACION_INICIAL` o `REPOSICION`.

#### Validaciones

- `cantidad_asignada > 0`.
- `cantidad_asignada <= saldo_vivo_disponible_asignacion` del lote.
- El lote debe estar en estado `ACTIVO` (no `FINALIZADO`).
- La subcampaña debe estar en estado operativo compatible con el propósito:
  - `PLANTACION_INICIAL` solo se acepta si la subcampaña está `ACTIVA`.
  - `REPOSICION` se acepta en `ACTIVA`, `COMPLETADA` o `FINALIZADA_PARCIAL`.

#### Por qué no hay evento en M2

La asignación es una **promesa contable**: estos árboles están reservados para esa subcampaña, pero todavía están físicamente en el vivero. No hay salida real, así que no hay evento operativo en `EVENTO_LOTE_VIVERO`.

#### Múltiples asignaciones por lote

- Un lote puede tener varias asignaciones activas a subcampañas distintas.
- La suma de saldos disponibles de las asignaciones activas no puede superar el `saldo_vivo_actual` del lote.

#### Catálogo de propósitos

- **`PLANTACION_INICIAL`** — se consume para plantar árboles nuevos que **avanzan la meta** de la subcampaña.
- **`REPOSICION`** — se consume **exclusivamente** para reponer árboles muertos previamente reportados; **no avanza la meta**.

Una asignación con un propósito **no puede** consumirse para el otro. Es una restricción de tipo, no de saldo.

---

### 3.2. Camino B — Devolución (liberación de reserva)

**Quién:** `ADMIN` o `COORDINADOR` de la subcampaña.
**Qué hace:** libera total o parcialmente una asignación que ya no se va a consumir, devolviendo el saldo al lote.
**Efecto en M2:** ninguno. El saldo vivo del lote **no cambia**.

#### Por qué no hay evento en M2

Los árboles **nunca salieron físicamente** del vivero. Solo cambia la contabilidad lógica: aumenta `cantidad_devuelta` en la asignación, y por lo tanto baja `saldo_asignado_disponible` y sube `saldo_vivo_disponible_asignacion` del lote.

#### Datos mínimos

- `asignacion_id`.
- `cantidad_devuelta` (en `UNIDAD`, entero positivo).
- `motivo_devolucion` (enum `motivo_devolucion_plantacion`).
- Observación opcional.

#### Validaciones

- `cantidad_devuelta <= saldo_asignado_disponible` de la asignación.
- La asignación no puede estar ya `DEVUELTA`.

#### Donde sí se registra

En el lado de M3 se registra el evento `DEVOLUCION_A_VIVERO` en `EVENTO_PLANTACION` (append-only). Pero **no hay contraparte** en `EVENTO_LOTE_VIVERO` porque la operación es lógica, no física.

---

### 3.3. Camino C — Despacho automático (salida real desde Plantación)

**Quién:** el sistema, en respuesta a una `PLANTACION_INICIAL` o `REPOSICION` registrada por un operario de M3 en campo.
**Qué hace:** descuenta saldo vivo del lote y consume el saldo asignado correspondiente, en una sola transacción atómica con el registro de plantación.
**Efecto en M2:** **el saldo vivo del lote disminuye.**

#### Datos del evento `DESPACHO` automático

```
tipo_evento = DESPACHO
origen_despacho = AUTOMATICO_PLANTACION
destino_tipo = PLANTACION_CAMPANIA
subcampania_id = <id>
campania_id = <id>
registro_plantacion_id = <id>
comunidad_destino_id = subcampania.zona_id
unidad_medida_evento = UNIDAD
cantidad_afectada = <cantidad del lote consumida en ese registro>
responsable_id = registro_plantacion.responsable_id
fecha_evento = registro_plantacion.fecha_plantacion
```

#### Atomicidad

Un solo `REGISTRO_PLANTACION` puede tocar varios lotes (una especie por lote). En ese caso se generan **N eventos `DESPACHO`**, uno por lote, **todos en la misma transacción** que el registro. Si algo falla, todo se revierte.

Invariante por registro:

```
SUM(DESPACHO.cantidad_afectada) por registro_plantacion = REGISTRO_PLANTACION.cantidad_total_plantada
```

#### Validaciones (en orden de la transacción)

1. Subcampaña activa (o aceptando reposiciones).
2. GPS dentro del polígono (con tolerancia configurable).
3. Especies dentro del mix permitido.
4. Cada lote elegido tiene asignación activa con propósito coherente (`PLANTACION_INICIAL` para plantación inicial; `REPOSICION` para reposición).
5. `cantidad_solicitada_del_lote <= saldo_asignado_disponible` de esa asignación.
6. El registro tiene al menos 1 foto válida y GPS válido (sin esto, no se inserta nada).

Si todas pasan, dentro de la misma transacción:

- Se inserta `REGISTRO_PLANTACION`.
- Por cada lote afectado: `update asignacion set cantidad_consumida = cantidad_consumida + N`.
- Por cada lote afectado: `insert into evento_lote_vivero` con los campos de despacho automático.
- El trigger existente de M2 descuenta `saldo_vivo_actual`.
- Commit.

#### Evidencia heredada

Un `DESPACHO` automático **no tiene fotos propias** en `EVIDENCIAS_TRAZABILIDAD`. Su evidencia es la del `REGISTRO_PLANTACION` asociado. Esto es una excepción explícita a la regla general de Módulo 2 de "todo despacho requiere evidencia propia". La validez de la excepción depende de que el registro de plantación tenga evidencia válida; sin ella, la transacción no llega al commit.

#### Concurrencia

El handler debe lockear con `SELECT ... FOR UPDATE` las filas de `asignacion_vivero_subcampania` involucradas, para evitar que dos plantaciones simultáneas sobre el mismo lote se pasen del saldo disponible.

---

### 3.4. Camino D — Despacho manual (salida real fuera de campañas)

**Quién:** operario de vivero autorizado (rol `GENERAL` típicamente, con permiso explícito) o `ADMIN`.
**Qué hace:** registra una salida del lote hacia un destino que **no es una subcampaña** (donación a comunidad, venta, plantación propia, etc.).
**Efecto en M2:** **el saldo vivo del lote disminuye.**

#### Datos del evento `DESPACHO` manual

```
tipo_evento = DESPACHO
origen_despacho = MANUAL
destino_tipo = (PLANTACION_PROPIA | PLANTACION_COMUNIDAD | DONACION | VENTA | OTRO)
                ← NO puede ser PLANTACION_CAMPANIA
destino_referencia = <texto libre con contexto>
subcampania_id = NULL
campania_id = NULL
registro_plantacion_id = NULL
comunidad_destino_id = <opcional según destino>
unidad_medida_evento = UNIDAD
cantidad_afectada = <cantidad despachada>
responsable_id = <usuario que registra>
fecha_evento = <fecha del despacho>
```

#### Validaciones

- `cantidad_afectada > 0`.
- `cantidad_afectada <= saldo_vivo_disponible_asignacion` del lote (**no `saldo_vivo_actual`**).
- El lote debe estar `ACTIVO`.
- Evidencia propia obligatoria (mínimo 1 foto en `EVIDENCIAS_TRAZABILIDAD`).
- `destino_tipo <> PLANTACION_CAMPANIA` (restricción de tipo del CHECK constraint).

#### Por qué validar contra `saldo_vivo_disponible_asignacion`

Si un lote tiene saldo reservado por subcampañas activas, ese saldo está **comprometido**. Un despacho manual no puede tocar stock reservado. Si el operario de vivero quiere despachar más, primero hay que devolver la reserva (acción del coordinador, no del operario de vivero).

Esto es un **cambio respecto al comportamiento anterior** al Módulo 3: antes, el operario de vivero validaba contra el saldo vivo total. Ahora debe respetar las reservas.

---

## 4. Política de mermas sobre saldo asignado (por urgencia de subcampaña)

Una `MERMA` en un lote con asignaciones activas requiere decidir quién absorbe la pérdida.

### 4.1. Regla

1. La merma afecta primero el **saldo no asignado** del lote.
2. Si la merma excede el saldo no asignado, el excedente se distribuye sobre las asignaciones activas ordenando por **`subcampania.fecha_estimada_inicio DESC NULLS FIRST`**: la subcampaña con inicio más lejano absorbe primero (mayor margen temporal); la más próxima queda protegida (más urgente). Las subcampañas sin fecha (`NULL`) se tratan como no urgentes y absorben antes que cualquier fecha concreta.
3. Cada asignación afectada aumenta su `cantidad_mermada`.
4. `cantidad_asignada` **nunca se modifica**.

**Por qué `fecha_estimada_inicio` y no `fecha_asignacion`:** `fecha_asignacion` solo dice cuándo se hizo la reserva. `fecha_estimada_inicio` de la subcampaña dice cuándo se va a plantar — esa es la fuente de verdad sobre la urgencia operativa.

### 4.2. Fórmula

```
saldo_no_asignado = saldo_vivo_actual − saldo_asignado_total

si cantidad_merma <= saldo_no_asignado:
    no se tocan asignaciones
    saldo_vivo_actual baja en cantidad_merma

si cantidad_merma > saldo_no_asignado:
    excedente = cantidad_merma − saldo_no_asignado
    distribuir excedente:
      JOIN subcampania ORDER BY fecha_estimada_inicio DESC NULLS FIRST, asignacion.id DESC
    cada asignacion afectada: cantidad_mermada += su_parte
    saldo_vivo_actual baja en cantidad_merma
```

### 4.3. Notificación al coordinador

Cuando una merma afecta una asignación activa, el coordinador de la subcampaña dueña de esa asignación debe ser notificado. Datos mínimos de la notificación: subcampaña afectada, lote, cantidad mermada sobre la asignación, nuevo saldo asignado disponible, fecha, causa, responsable de la merma.

### 4.4. Por qué no se reduce `cantidad_asignada`

`cantidad_asignada` representa el **compromiso original**. Modificarla borra historia y dificulta auditoría. Por eso la merma va a un campo separado (`cantidad_mermada`) y `saldo_asignado_disponible` se recalcula.

---

## 5. Matriz consolidada de operaciones

| Operación | Quién | Origen del evento | `EVENTO_LOTE_VIVERO` | `saldo_vivo_actual` | `cantidad_asignada` | `cantidad_consumida` | `cantidad_devuelta` | `cantidad_mermada` | Evidencia |
|-----------|-------|-------------------|----------------------|---------------------|---------------------|----------------------|---------------------|--------------------|-----------|
| Asignación | ADMIN / COORDINADOR | M3 (admin/coord. de subcampaña) | No genera | Sin cambio | Se crea fija | — | — | — | No requiere |
| Devolución | ADMIN / COORDINADOR | M3 | No genera | Sin cambio | Sin cambio | — | +N | — | No requiere |
| Plantación inicial / reposición (M3) | Operario M3 | M3 (atómico) | Sí: `DESPACHO` con `origen_despacho = AUTOMATICO_PLANTACION` | Baja en N | Sin cambio | +N | — | — | Heredada del `REGISTRO_PLANTACION` |
| Despacho manual | Operario vivero / ADMIN | M2 | Sí: `DESPACHO` con `origen_despacho = MANUAL` | Baja en N | Sin cambio (no toca asignaciones) | — | — | — | Obligatoria propia |
| Merma (sin afectar asignaciones) | Operario vivero / ADMIN | M2 | Sí: `MERMA` | Baja en N | Sin cambio | — | — | — | Obligatoria propia |
| Merma (con desborde a asignaciones por LIFO) | Operario vivero / ADMIN | M2 | Sí: `MERMA` con metadata de afectación | Baja en N | Sin cambio | — | — | +N (distribuido LIFO) | Obligatoria propia |
| Mortandad en M3 | Operario M3 | M3 | No genera | Sin cambio | Sin cambio | — | — | — | Propia en M3, no en M2 |

---

## 6. Estados de la asignación

Una `ASIGNACION_VIVERO_SUBCAMPANIA` pasa por estos estados:

| Estado | Significado | Cuándo entra |
|--------|-------------|--------------|
| `ACTIVA` | Tiene saldo disponible para consumir | Al crearse, o mientras `saldo_asignado_disponible > 0` |
| `AGOTADA` | Saldo disponible llegó a 0 por consumos | Cuando `cantidad_consumida + cantidad_mermada >= cantidad_asignada` y hubo consumo |
| `DEVUELTA` | Toda la cantidad asignada se devolvió sin consumir | Cuando `cantidad_devuelta = cantidad_asignada` y `cantidad_consumida = 0` |

El estado lo deriva el trigger del backend al actualizar los conteos. No se escribe a mano.

> **Nota:** `AFECTADA_POR_MERMA` no es un estado del enum; es un **badge visual** que la UI muestra cuando `cantidad_mermada > 0`, sin importar el estado lógico.

---

## 7. Choques con el flujo anterior al Módulo 3

Tres cambios de comportamiento que el equipo de vivero debe internalizar:

1. **El operario de vivero ya no ve "saldo vivo total" como saldo disponible para despachar.** Ahora ve "saldo libre" (`saldo_vivo_disponible_asignacion`). Si un lote está totalmente reservado, no puede despacharlo manualmente.
2. **Aparecen despachos automáticos en el historial del lote.** No los hace el operario de vivero; los hace el sistema cuando un operario de M3 registra una plantación. Estos despachos tienen una identidad visual diferente (badge `POR PLANTACIÓN`) y enlazan a la subcampaña y al registro de plantación.
3. **Las mermas pueden afectar reservas.** Antes una merma solo bajaba el saldo del lote. Ahora, si el lote tiene reservas y la merma desborda el saldo no asignado, alguna(s) asignación(es) van a recibir parte de esa pérdida y se va a notificar al coordinador.

---

## 8. Reglas de negocio que sostienen este flujo

Las reglas formales viven en [01_regas_de_negocio_vivero.md](./01_regas_de_negocio_vivero.md), sección de integración con Plantación (`RN-VIV-47` en adelante). En resumen, los invariantes innegociables son:

- Asignación es reserva lógica; no genera evento en M2.
- Devolución no genera evento en M2.
- `cantidad_asignada` es inmutable.
- Mermas afectan asignaciones por LIFO (más nueva primero); no reescriben `cantidad_asignada`.
- Despacho automático hereda evidencia del registro de plantación; despacho manual exige evidencia propia.
- Despacho manual no puede tener `destino_tipo = PLANTACION_CAMPANIA`.
- Despacho automático solo puede tener `destino_tipo = PLANTACION_CAMPANIA`.
- Cualquier despacho automático debe traer `subcampania_id`, `campania_id` y `registro_plantacion_id` no nulos.
- Cualquier despacho manual debe traer esos tres campos en `NULL`.

Estas restricciones se materializan como CHECK constraints en `EVENTO_LOTE_VIVERO` y como triggers en `ASIGNACION_VIVERO_SUBCAMPANIA`.

---

## 9. Ejemplo end-to-end

**Setup:**

- Lote `VIV-007-REC-12345`, `saldo_vivo_actual = 500`.
- Subcampaña `Cota Cota`, meta `1000`, coordinadora María.
- Subcampaña `San Miguel`, meta `1000`, coordinador Pedro.

**Paso 1 — Asignación.** Admin asigna 200 a Cota Cota con propósito `PLANTACION_INICIAL` y 100 a San Miguel con propósito `PLANTACION_INICIAL`. Resultado:

```
LOTE: saldo_vivo_actual = 500 (sin cambio)
       saldo_asignado_total = 300
       saldo_vivo_disponible_asignacion = 200

Asignación Cota Cota: cantidad_asignada=200, saldo_asignado_disponible=200
Asignación San Miguel: cantidad_asignada=100, saldo_asignado_disponible=100
```

**Paso 2 — Plantación.** Un operario en Cota Cota planta 40 árboles del lote. M3 genera atómicamente un `DESPACHO` automático con `cantidad_afectada=40`. Resultado:

```
LOTE: saldo_vivo_actual = 460
       saldo_asignado_total = 260
       saldo_vivo_disponible_asignacion = 200

Asignación Cota Cota: cantidad_consumida=40, saldo_asignado_disponible=160
Asignación San Miguel: sin cambio
```

**Paso 3 — Merma de 250 en el lote.** El operario de vivero registra una merma por sequía. Saldo no asignado del lote = 200; excedente = 50. El sistema ordena por `subcampania.fecha_estimada_inicio DESC NULLS FIRST`: asumiendo que Cota Cota empieza antes (fecha más próxima), San Miguel absorbe el excedente primero (fecha más lejana = mayor margen). Resultado:

```
LOTE: saldo_vivo_actual = 210
       saldo_asignado_total = 210
       saldo_vivo_disponible_asignacion = 0

Asignación Cota Cota: sin cambio, saldo_asignado_disponible=160  (protegida — su subcampaña empieza antes)
Asignación San Miguel: cantidad_mermada=50, saldo_asignado_disponible=50
Notificación enviada a Pedro (coordinador de San Miguel).
```

**Paso 4 — Devolución parcial.** María decide devolver 20 de su asignación porque ya no los va a usar. Resultado:

```
LOTE: saldo_vivo_actual = 210 (sin cambio)
       saldo_asignado_total = 190
       saldo_vivo_disponible_asignacion = 20

Asignación Cota Cota: cantidad_devuelta=20, saldo_asignado_disponible=90
```

**Paso 5 — Despacho manual.** El operario de vivero quiere donar 30 a una comunidad externa. Pero solo hay 20 libres. La operación falla con `cantidad despachada (30) > saldo libre (20)`. Tendría que esperar más devoluciones o el admin tendría que negociarlas.

Esto es exactamente el comportamiento deseado: las reservas están protegidas.

---

## 10. Glosario rápido

- **Reserva lógica:** asignar saldo a una subcampaña sin que el árbol salga físicamente.
- **Salida real:** despacho (manual o automático) o merma; baja `saldo_vivo_actual`.
- **Despacho automático:** generado por el sistema al registrar una plantación en M3. `origen_despacho = AUTOMATICO_PLANTACION`.
- **Despacho manual:** registrado directamente por un usuario de vivero. `origen_despacho = MANUAL`.
- **Evidencia heredada:** las fotos del `REGISTRO_PLANTACION` cuentan como evidencia del `DESPACHO` automático asociado.
- **Merma por urgencia:** cuando una merma desborda el saldo no asignado, la asignación cuya subcampaña tiene `fecha_estimada_inicio` más lejana se afecta primero; la más próxima queda protegida.
- **Saldo asignado disponible:** `cantidad_asignada − cantidad_consumida − cantidad_devuelta − cantidad_mermada`. Es el saldo realmente comprometido y todavía consumible.

---

## 11. Referencias

- [Addendum del Módulo 2 (fuente canónica del contrato M2 ↔ M3)](./03_Addendum_Modulo_2_por_Modulo_3.md)
- [Reglas de negocio Vivero](./01_regas_de_negocio_vivero.md)
- [Procesos del Módulo 3 — Plantación](../plantacion-module/02_Procesos_Modulo_3_Plantacion.md)
- [Esquema ER](../database/00_database_schema.md)
- [Tareas pendientes de implementación](../tareas/modulo-2-integracion-modulo-3/README.md)
