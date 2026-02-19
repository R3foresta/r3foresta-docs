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

  * Para `ESQUEJE`: unidades enteras.
  * Para `SEMILLA`: peso (kg/gr), almacenado en una unidad canónica.
* **Estado de stock:** `ALMACENADO`, `USADO`, `DESECHADO`.
* **Ubicación estructurada:** latitud/longitud obligatorias + datos administrativos opcionales (catálogos).
* **Evidencia:** fotos obligatorias (mínimo 2), formato JPG/PNG.
* **Historial:** bitácora inmutable de cambios (quién/cuándo/antes-después).

---

## 3. Reglas de identidad, propiedad y trazabilidad

### RN-REC-01 — Identificador único

Toda recolección tiene un **identificador único** generado automáticamente por el sistema. No se puede editar.

### RN-REC-02 — Propiedad del registro (recolector)

Cada recolección debe estar asociada a un **Recolector** (RF-GEN-01).
En el MVP: por defecto el recolector es **el usuario autenticado**, salvo roles con permiso para registrar en nombre de otro.

### RN-REC-03 — Recolección como “Lote Origen”

Una recolección **es** un “lote origen” para los módulos siguientes. Por tanto:

* Debe poder **ser referenciada** desde Vivero (M2).
* Debe poder **cambiar de estado** por uso/consumo (manual o automático según reglas).

---

## 4. Reglas de captura y campos mínimos

### RN-REC-04 — Fecha de recolección obligatoria y acotada

La **fecha de recolección** es obligatoria y debe cumplir:

* No puede ser futura.
* Puede ser retroactiva hasta **45 días** como máximo.

Además, el sistema registra automáticamente:

* `fecha_registro` (timestamp del sistema),
* `usuario_registro`.

### RN-REC-05 — Especie: nombre científico + nombre comercial

Se debe registrar **nombre científico** y **nombre comercial**.

MVP (práctico, compatible con lo que ya tienen):

* Se guardan como texto.
* Si existe un catálogo de especies, se recomienda guardar también una referencia (`especie_id`) **sin perder el snapshot textual**.

### RN-REC-06 — Método de recolección desde catálogo extensible

El método de recolección se selecciona de un **catálogo**.
Se permite ampliar el catálogo, pero **no “a lo loco”**:

* Regla sugerida: solo usuarios con rol “Administrador/Operador” pueden crear nuevos métodos (o quedan como “pendientes de aprobación”).

### RN-REC-07 — Lugar de almacenamiento (vivero) desde catálogo

El lugar de almacenamiento se selecciona de la lista de **viveros (RF-GEN-02)**.
Para añadir un nuevo vivero, debe registrarse primero en el módulo general correspondiente.

---

## 5. Reglas de estado del material (stock)

### RN-REC-08 — Estados válidos y obligatorios

Toda recolección debe estar en exactamente uno de estos estados:

* `ALMACENADO` (default),
* `USADO`,
* `DESECHADO`.

### RN-REC-09 — Estado por defecto

Al crear una recolección, el estado por defecto es **ALMACENADO**.
El usuario puede cambiarlo a `USADO` o `DESECHADO` según permisos y reglas.

### RN-REC-10 — Restricción de uso por estado

* Si una recolección está `DESECHADO`, **no puede** usarse para iniciar vivero (M2).
* Si una recolección está `USADO`, **no puede** volver a usarse (ver pregunta crítica sobre uso parcial).

---

## 6. Reglas de cantidades y unidades

### RN-REC-11 — Cantidad obligatoria y > 0

La cantidad de recolección es obligatoria y debe ser **mayor a 0**.

### RN-REC-12 — Semillas: conversión a unidad canónica

Para `SEMILLA`:

* El usuario puede ingresar en **kg** o **gr**,
* El sistema debe almacenar en una unidad canónica (recomendado: **gramos** como decimal),
* Mantener (si se quiere) el “input original” solo para UI, pero la lógica usa la unidad canónica.

### RN-REC-13 — Esquejes: entero estricto

Para `ESQUEJE`:

* La cantidad es **entera** y **sin decimales**.
* Debe ser ≥ 1.

---

## 7. Reglas de evidencia fotográfica

### RN-REC-14 — Evidencia mínima obligatoria

Toda recolección debe incluir **mínimo 2 fotografías**:

* 1 foto que evidencie la especie,
* 1 foto que evidencie la cantidad/volumen recolectado (o su contenedor/medición).

Se pueden agregar más.

### RN-REC-15 — Formato y tamaño por foto

Cada foto debe cumplir:

* Formato: **JPG o PNG**.
* Tamaño máximo: **5 MB**.
  Si excede: se rechaza esa imagen con mensaje claro, sin tumbar todo el registro (ideal UX).

---

## 8. Reglas de observaciones

### RN-REC-16 — Observaciones acotadas

Observaciones:

* Máximo **1000 caracteres**.
* Sin emojis (validación técnica; si esto trae problemas reales en campo, lo revisamos).

---

## 9. Reglas de ubicación estructurada (RF-REC-02)

### RN-REC-17 — Latitud y longitud obligatorias

Toda recolección debe tener:

* `latitud` obligatoria: rango **[-90, 90]** con **6 decimales**.
* `longitud` obligatoria: rango **[-180, 180]** con **6 decimales**.

Si faltan: error indicando exactamente el campo faltante.

### RN-REC-18 — Campos administrativos opcionales por catálogo

País/Departamento/Provincia/Comunidad/Zona:

* Son opcionales,
* Se seleccionan de catálogos (cuando existan),
* Si un dato no existe en catálogo, el sistema debe impedir inventar valores (o manejar “pendiente” — ver preguntas críticas).

### RN-REC-19 — Coherencia mínima de estructura

Si se envían valores administrativos, deben estar “bien formados” (IDs válidos / pertenecen al catálogo correspondiente). Si no: error.

---

## 10. Reglas de edición + historial (RF-REC-03)

### RN-REC-20 — Historial obligatorio e inmutable

Cualquier modificación a una recolección debe generar un registro en historial con:

* usuario que modificó,
* fecha/hora,
* versión anterior y nueva (o diff por campos),
* motivo (recomendado, aunque no esté en RF todavía).

El historial:

* se guarda en tablas separadas,
* **no se puede borrar**.

### RN-REC-21 — Qué cambios deben registrar historial

Se registra **cualquier cambio**, especialmente:

* estado (ALMACENADO/USADO/DESECHADO),
* cantidad,
* fotos (altas/bajas),
* ubicación,
* especie/método/vivero/observaciones.

### RN-REC-22 — Datos automáticos en auditoría

Los datos de auditoría (usuario, timestamps) se toman automáticamente del sistema.

---

## 11. Reglas de integración con Módulo 2 (Vivero)

### RN-REC-23 — Elegibilidad para iniciar vivero

Solo se puede iniciar un lote de vivero desde una recolección que esté:

* en estado `ALMACENADO`,
* con evidencia mínima completa,
* con ubicación válida,
* con tipo_material definido.

### RN-REC-24 — Cambio de estado por consumo (si aplica)

Cuando una recolección se usa para crear un lote de vivero, el sistema debe:

* registrar el vínculo (recolección → lote_vivero),
* cambiar estado a `USADO` **si el modelo es 1:1** (ver preguntas críticas),
* generar historial automático.

---

## 12. Roles y estrategia blockchain (MVP)

### RN-REC-25 — Roles mínimos (MVP)

* **Recolector:** crea registros, adjunta evidencia.
* **Supervisor/Validador (opcional en v1):** valida calidad / aprueba especie nueva / aprueba métodos nuevos.
* **Auditor:** consulta historial completo.

### RN-REC-26 — “Especie nueva” como bandera de control

Si `es_especie_nueva = true`:

* el registro debe quedar marcado para revisión (cola de validación),
* se sugiere requerir más evidencia o una nota técnica (pregunta crítica).

### RN-REC-27 — Anclaje blockchain (propuesta)

MVP recomendado:

* Solo anclar a blockchain recolecciones “validadas” (si añadimos esa capa) **o**
* anclar cuando la recolección se usa para iniciar vivero (porque ya entra al flujo “sellado”).

