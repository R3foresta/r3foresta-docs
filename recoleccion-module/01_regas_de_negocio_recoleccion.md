# Reglas de Negocio (RN) — Módulo 1 Recolección

## 1. Propósito

Estas reglas definen **cómo debe comportarse el sistema frente a la realidad operativa de la recolección**, independientemente de la interfaz o tecnología.

Buscan garantizar:

* **Trazabilidad fuerte** (origen claro del material biológico).
* **Coherencia temporal y de cantidades** (no magia, no “inventos”).
* Registro fiel de evidencia (fotos) y ubicación.
* Compatibilidad con el flujo del **Módulo 2 (Vivero)** y con una futura estrategia de **validación/anclaje blockchain** (MVP).

Estas reglas gobiernan el ciclo de vida del **Lote Origen / Recolección**.

---

## 2. Definiciones básicas

* **Recolección (Lote Origen):** registro que representa material biológico recolectado (semillas o esquejes) con evidencia y ubicación.
* **Tipo de material:** `SEMILLA` o `ESQUEJE`.
* **Cantidad:**

  * Persistencia oficial del sistema: `ENUM(unidad_medida) = [UNIDAD, G]`.
  * Para `ESQUEJE`: solo `UNIDAD`, entero estricto, sin decimales.
  * Para `SEMILLA`: puede capturarse por peso o por conteo, pero solo se persiste en `G` o `UNIDAD`.
  * El frontend puede aceptar `kg`, `g` y `unidad`; el backend normaliza `kg -> G`, `g -> G` y `unidad -> UNIDAD`.
  * `kg` no se persiste en base de datos.
* **Estados:** `BORRADOR/VALIDADO` (registro) y `ABIERTO/CERRADO` (operativo, derivado del saldo).
* **Ubicación estructurada:** latitud/longitud obligatorias **para validar** + datos administrativos opcionales (catálogos).
* **Evidencia:** fotos obligatorias **para validar** (mínimo 2), formato JPG/PNG.
* **Historial:** bitácora inmutable de cambios (quién/cuándo/antes-después).
* **Snapshot:** copia congelada de datos oficiales de identidad en un momento formal del proceso, para que cambios posteriores en tablas maestras no alteren el historial ya validado.

---

## 3. Reglas de identidad, propiedad y trazabilidad

### RN-REC-01 — Identificador único

Toda recolección tiene un **identificador único** generado automáticamente por el sistema. No se puede editar.

### RN-REC-02 — Propiedad del registro (recolector)

Cada recolección debe estar asociada a un **Recolector** (RF-GEN-01) y a una **Ubicación**.
En el MVP: por defecto el recolector es **el usuario autenticado**, salvo roles con permiso para registrar en nombre de otro.

### RN-REC-03 — Recolección como “Lote Origen”

Una recolección **es** un “lote origen” para los módulos siguientes. Por tanto:

* Debe poder **ser referenciada** desde Vivero (M2).
* Debe poder **cambiar de estado** por uso/consumo (manual o automático según reglas).

### RN-REC-03A — Snapshot oficial de identidad en validación

El sistema debe guardar en `RECOLECCION` un snapshot oficial de identidad al momento de aprobar la validación.

Ese snapshot debe incluir, como mínimo:

- `nombre_cientifico_snapshot`
- `nombre_comercial_snapshot`
- `variedad_snapshot`
- `nombre_comunidad_snapshot`
- `nombre_recolector_snapshot`

Su propósito es congelar el dato oficial validado para que cambios posteriores en `PLANTA`, comunidad o usuario no reescriban retrospectivamente la historia del lote origen.

---

## 4. Reglas de captura y campos mínimos

### RN-REC-04 — Fecha de recolección obligatoria y acotada

La **fecha de recolección** es obligatoria y debe cumplir:

* No puede ser futura.
* Puede ser retroactiva hasta **45 días** como máximo.

Además, el sistema registra automáticamente:

* `fecha_registro` (timestamp del sistema),
* `usuario_registro`.


### RN-REC-06 — Método de recolección desde catálogo cerrado

El método de recolección se selecciona de un **catálogo de métodos de recolección predefinidos**.

### RN-REC-07 — Lugar de almacenamiento (vivero) desde catálogo

El lugar de almacenamiento se selecciona de la lista de **viveros (RF-GEN-02)**.
Para añadir un nuevo vivero, debe registrarse primero en el módulo general correspondiente.

---

## 5. Reglas de estado del registro e inventario (saldo)

### RN-REC-08 — Estados válidos (registro + operativo)

Cada recolección maneja **dos estados**:

1) **Estado del registro (Web2 / calidad de datos):**
- `BORRADOR` (editable)
- `PENDIENTE_VALIDACION` (congelado mientras revisa el validador)
- `VALIDADO` (sellado)
- `RECHAZADO` (no consumible; puede corregirse y reenviarse a validación)

2) **Estado operativo (inventario):**
- `ABIERTO` (saldo disponible > 0)
- `CERRADO` (saldo disponible = 0)

> Nota: `ABIERTO/CERRADO` **no se elige manualmente**; se deriva del saldo.

### RN-REC-09 — Estados por defecto

Al crear una recolección:

- `estado_registro = BORRADOR`
- `saldo_actual = cantidad_inicial` (normalizada a unidad canónica gramos o unidades de semillas)
- `estado_operativo = ABIERTO` (porque cantidad_inicial debe ser > 0)

### RN-REC-09A — Soft delete solo para borradores

En el MVP, un registro solo puede eliminarse si está en `BORRADOR`.

La eliminación debe resolverse como **soft delete**, preservando trazabilidad mínima del registro creado.

### RN-REC-10 — Restricción de uso por estado (consumo a vivero)

Para que una recolección pueda alimentar lotes del Módulo 2 (Vivero) debe cumplir:

- `estado_registro = VALIDADO`
- `estado_operativo = ABIERTO`
- `saldo_actual >= cantidad_a_consumir`

Si está en `BORRADOR`, `PENDIENTE_VALIDACION`, `RECHAZADO` o `CERRADO`, **no puede** consumirse.

### RN-REC-10D — El snapshot oficial se fija solo al validar

- En `BORRADOR` y `RECHAZADO`, los datos derivados para snapshot pueden recalcularse libremente.
- En `PENDIENTE_VALIDACION`, la ficha queda congelada mientras se revisa.
- El snapshot oficial se fija recién al aprobar la validación.
- Una vez `VALIDADO`, el snapshot oficial no debe recalcularse ni sobrescribirse por cambios posteriores en tablas maestras.
- El naming oficial del campo comercial congelado es `nombre_comercial_snapshot`; no se usa `nombre_comun_snapshot`.

### RN-REC-10A — Movimientos permitidos (append-only) y efecto en saldo

Post-validación, el saldo solo cambia mediante **movimientos** (no edición directa):

- `CONSUMO_A_VIVERO` (automático desde M2) → delta negativo + referencia al lote de vivero
- `DESECHO` (manual) → delta negativo + **motivo obligatorio**

Fuera del MVP:

- `CORRECCION` (controlado) → delta positivo/negativo + **motivo obligatorio** + rol autorizado

Los movimientos son **append-only**: no se editan ni se borran. Si más adelante se incorpora `CORRECCION`, deberá registrarse como un movimiento nuevo y auditable, no como edición del pasado.

### RN-REC-10C — Separación entre historial del registro y movimientos

En Recolección deben separarse dos responsabilidades:

- `RECOLECCION_HISTORIAL`: historial del ciclo de vida del registro y sus transiciones de estado.
- `RECOLECCION_MOVIMIENTO`: ledger operativo de inventario, usado solo cuando cambia el saldo o cuando en el futuro exista una corrección técnica/auditada.

`RECOLECCION_MOVIMIENTO` no debe reutilizarse como historial general de edición de la ficha.

### RN-REC-10B — Conservación del saldo (no magia)

- `saldo_actual = cantidad_inicial + SUM(delta_movimientos)`
- Regla dura: el sistema **no permite** que `saldo_actual` quede por debajo de 0.
- Cuando `saldo_actual = 0` ⇒ `estado_operativo = CERRADO`.
- En el MVP, todos los `delta_movimientos` persistidos son negativos porque `CORRECCION` queda fuera de alcance.

## 6. Reglas de cantidades y unidades

### RN-REC-11 — Cantidad obligatoria y > 0

La cantidad de recolección es obligatoria y debe ser **mayor a 0**.

### RN-REC-12 — Semillas: conversión a unidad canónica

Para `SEMILLA`:

* El frontend puede ingresar en `kg`, `g` o `unidad`, según las reglas funcionales definidas para la especie/material.
* El sistema debe persistir solo `G` o `UNIDAD`.
* Si la captura es por peso, la unidad persistida es `G`.
* Si la captura es por conteo, la unidad persistida es `UNIDAD`.
* `kg` existe solo como input del frontend y nunca se persiste.
* No se deben mezclar `G` y `GR` en documentación, backend, frontend ni base de datos.

### RN-REC-12A — Convención oficial de persistencia de unidades

La convención oficial del sistema para `RECOLECCION.unidad_canonica` y `RECOLECCION_MOVIMIENTO.unidad_medida_movimiento` es:

* `UNIDAD`
* `G`

No se aceptan otras unidades en el MVP.

### RN-REC-13 — Esquejes: entero estricto

Para `ESQUEJE`:

* La cantidad usa siempre `UNIDAD`.
* La cantidad es **entera** y **sin decimales**.
* Debe ser ≥ 1.

---

## 7. Reglas de evidencia fotográfica

### RN-REC-14 — Evidencia mínima obligatoria

- En `BORRADOR`: su porposito es evitar subir registros errados a blockchain si no se esta seguro de los datos ya que es editable, fotos y ubicación son obligatorias para crear un borrador y evitar huecos de trazabilidad.
- Para pasar a `PENDIENTE_VALIDACION`: se exige **mínimo 2 fotografías**:
  - 1 foto que evidencie la especie,
  - 1 foto que evidencie la cantidad/volumen recolectado (o su contenedor/medición).

Se pueden agregar más.


(Futuro: La validación también se hará por la comunidad, no solo el recolector, se puede proponer que más de una persona valide la recolección y quede registrado en blockchain quienes validaron y cuando.)

### RN-REC-15 — Formato y tamaño por foto

Cada foto debe cumplir:

- Formato: **JPG o PNG**.
- Tamaño máximo: **5 MB**.

Si excede: procesar la imagen para reducir tamaño o rechazar con error claro.

## 8. Reglas de observaciones

### RN-REC-16 — Observaciones acotadas

Observaciones:

* Máximo **1000 caracteres**.
* Sin emojis (validación técnica; si esto trae problemas reales en campo, lo revisamos).

---

## 9. Reglas de ubicación estructurada (RF-REC-02)

### RN-REC-17 — Latitud y longitud obligatorias

- En `BORRADOR`: `latitud/longitud` son **obligatorias**.
- Para pasar a `PENDIENTE_VALIDACION`: también son **obligatorias** y deben cumplir:
  - `latitud` en rango **[-90, 90]** con **6 decimales**.
  - `longitud` en rango **[-180, 180]** con **6 decimales**.

Si faltan al validar: error indicando exactamente el campo faltante.

### RN-REC-18 — Campos administrativos opcionales por catálogo

País/Departamento/Provincia/Comunidad-Zona:

- Son opcionales,
- Se seleccionan de catálogos (cuando existan),
- Si un dato no existe en catálogo, el sistema debe impedir “inventar” valores.
  - Alternativa MVP: permitir por defualt “SIN ESPECIFICAR” en niveles administrativos.

### RN-REC-19 — Coherencia mínima de estructura

Si se envían valores administrativos, deben estar “bien formados” (IDs válidos / pertenecen al catálogo correspondiente). Si no: error.

## 10. Reglas de edición + historial (RF-REC-03)

### RN-REC-20 — Historial mínimo del MVP y preparación para evolución

En el MVP **no es obligatorio auditar cada edición del borrador campo por campo**.

Para no sobrecargar el producto, se deja preparada una tabla `RECOLECCION_HISTORIAL` append-only para registrar solo el ciclo de vida del registro.

Eventos mínimos recomendados:

- `BORRADOR_CREADO`
- `SOLICITUD_VALIDACION`
- `VALIDACION_APROBADA`
- `VALIDACION_RECHAZADA`
- `BORRADOR_ELIMINADO`

Este historial:

- se guarda separado del ledger operativo,
- no reemplaza `RECOLECCION_MOVIMIENTO`,
- y **no se puede borrar**.

### RN-REC-21 — Reglas de edición por estado

- En `BORRADOR`: se permite editar los campos del registro (incluyendo fotos y ubicación).
- En `BORRADOR`: se permite eliminar mediante soft delete.
- En `BORRADOR`: `created_at` no se edita; `updated_at` y `updated_by` deben reflejar la última edición.
- En `PENDIENTE_VALIDACION`: la ficha queda congelada mientras el validador decide.
- En `RECHAZADO`: el registro no es consumible, pero puede corregirse y reenviarse a validación.
- En `RECHAZADO`: `created_at` no se edita; `updated_at` y `updated_by` deben reflejar la última corrección.
- En `VALIDADO`: **no se permite editar la ficha**. Solo se permiten movimientos append-only:
  - `CONSUMO_A_VIVERO`
  - `DESECHO`

No hay correcciones operativas en el MVP una vez validado/subido el registro. El borrador sí se puede modificar antes de validar.

### RN-REC-22 — Qué cambios deben registrar historial

En el MVP se busca **trazabilidad razonable**, no auditoría exhaustiva de cada cambio en borrador.

Por eso, el historial mínimo recomendado debe registrar:

- creación del borrador,
- solicitud de validación,
- aprobación del validador,
- rechazo del validador,
- eliminación de borrador,
- y creación de movimientos (`CONSUMO_A_VIVERO`, `DESECHO`).

La edición del borrador se resuelve con campos de auditoría de la ficha (`updated_at`, `updated_by`) y no con eventos por cada cambio de campo.

### RN-REC-22A — Datos automáticos en auditoría

Los datos de auditoría (usuario, timestamps) se toman automáticamente del sistema.

### RN-REC-22B — Cómo se construye el timeline mínimo del MVP

El timeline mínimo de una recolección puede construirse combinando:

- `RECOLECCION.created_at` para “se creó borrador”,
- `RECOLECCION_HISTORIAL` para `SOLICITUD_VALIDACION`, `VALIDACION_APROBADA`, `VALIDACION_RECHAZADA` y `BORRADOR_ELIMINADO`,
- `RECOLECCION.fecha_validacion` como dato materializado del momento en que quedó validada,
- y `RECOLECCION_MOVIMIENTO.created_at` para consumos y desechos.

## 11. Reglas de integración con Módulo 2 (Vivero)

### RN-REC-23 — Elegibilidad para iniciar vivero

Solo se puede iniciar un lote de vivero desde una recolección que esté:

- `estado_registro = VALIDADO`
- `estado_operativo = ABIERTO`
- con evidencia mínima completa (≥ 2 fotos)
- con ubicación válida (lat/long)
- con tipo_material definido
- con `saldo_actual` suficiente para el consumo

El evento de `INICIO` de vivero consume el material recolectado con transacción atómica.

### RN-REC-24 — Movimiento de consumo por creación de lote (consumo parcial)

Cuando se crea un lote de vivero desde una recolección, el sistema debe:

- registrar el vínculo (recolección → lote_vivero),
- generar el `LOTE_VIVERO.codigo_trazabilidad` con formato `VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`,
- usar el `vivero_id` seleccionado para el lote de vivero, no heredarlo automáticamente desde `RECOLECCION.vivero_id`,
- registrar un movimiento `CONSUMO_A_VIVERO` con delta negativo en la recoleccion_movimiento,
- persistir `RECOLECCION_MOVIMIENTO.unidad_medida_movimiento` con la misma unidad que `RECOLECCION.unidad_canonica`,
- recalcular `saldo_actual` y el estado operativo:
  - `ABIERTO` si saldo > 0
  - `CERRADO` si saldo = 0

> No existe “cambio a USADO” como estado absoluto: el consumo se modela como movimiento.

### RN-REC-24A — Contrato estricto con Vivero en el evento `INICIO`

Cuando se crea un `LOTE_VIVERO` desde una `RECOLECCION`, el movimiento `CONSUMO_A_VIVERO`, el lote y el evento `INICIO` deben quedar estrictamente alineados.

Invariantes obligatorias:

- `abs(RECOLECCION_MOVIMIENTO.delta) = LOTE_VIVERO.cantidad_inicial_en_proceso`
- `LOTE_VIVERO.cantidad_inicial_en_proceso = EVENTO_LOTE_VIVERO.cantidad_afectada`
- `RECOLECCION_MOVIMIENTO.unidad_medida_movimiento = LOTE_VIVERO.unidad_medida_inicial`
- `LOTE_VIVERO.unidad_medida_inicial = EVENTO_LOTE_VIVERO.unidad_medida_evento`

Restricciones:

- No se puede consumir más de lo disponible en la recolección.
- La unidad del movimiento debe coincidir con la unidad canónica de la recolección.
- La unidad del evento `INICIO` debe coincidir con la del movimiento de consumo.
- `CONSUMO_A_VIVERO` usa `delta` negativo.
- `DESECHO` usa `delta` negativo.

Fuera del MVP:

- `CORRECCION` podrá usar `delta` positivo o negativo según corresponda.

## 12. Roles y estrategia blockchain (MVP)

### RN-REC-25 — Roles mínimos (MVP)

* **Recolector:** crea borradores, edita borradores y envía a validación.
* **VALIDADOR/Validador:** revisa registros en `PENDIENTE_VALIDACION` y los aprueba o rechaza.
* **Auditor:** consulta historial completo.

(Futuro: se pueden agregar roles de “comunidad” para validación colaborativa, con registro de quién validó qué y cuándo.)

### RN-REC-26 — Para registrar recolecciones nuevas solo se usan las plantas del catalog

No se permite registrar una recolección con un nombre científico que no exista en el catálogo de plantas (RF-GEN-03). Esto garantiza que cada recolección esté vinculada a una planta con identidad oficial.

### RN-REC-27 — Anclaje blockchain (MVP)

Para mantener **confianza sin complicarnos**, el anclaje se considera “oficial” desde `VALIDADO`.

MVP recomendado:

- Anclar a blockchain el **snapshot** al pasar a `VALIDADO`.
- Anclar también cada **movimiento post-validación**:
  - `CONSUMO_A_VIVERO`
  - `DESECHO`

`BORRADOR` no se considera historia oficial (no requiere anclaje).
`PENDIENTE_VALIDACION` y `RECHAZADO` forman parte del ciclo Web2 del registro, pero tampoco se consideran historia oficial anclada.
