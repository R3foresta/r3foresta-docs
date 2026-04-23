# Reglas de Negocio (RN) — Módulo 2: Vivero — Versión MVP

## 1. Propósito

Estas reglas definen el comportamiento mínimo del sistema para el Módulo 2: Vivero, priorizando un MVP que preserve el núcleo del proyecto:

* trazabilidad fuerte desde un lote origen único,
* coherencia temporal y de cantidades,
* control confiable del saldo vivo,
* historial auditable de eventos,
* y una base técnica simple que luego pueda crecer.

Cada regla incluye:

* **Severidad:** `BLOQUEANTE | ADVERTENCIA`
* **Aplica en MVP:** `Sí | No`
* **Relevancia carbono:** `Alta | Media | Baja`

---

## 2. Definiciones base

* **Lote origen:** registro de Recolección (Módulo 1) que abastece al vivero.
* **Lote de vivero:** lote iniciado en Módulo 2 a partir de un único lote origen.
* **Cantidad consumida del origen:** cantidad descontada en Módulo 1 usando la unidad canónica del lote origen.
* **Cantidad inicial en proceso:** lectura operativa del material que entra a vivero en `INICIO`, usando la misma unidad del origen en el MVP.
* **Plantas vivas:** saldo operativo que nace en el evento `EMBOLSADO`.
* **Saldo vivo:** cantidad actual de plantas vivas disponibles en el lote.
* **Persistencia oficial de unidades:** `ENUM(unidad_medida) = [UNIDAD, G]`.
* **Normalización de entrada:** el frontend puede aceptar `kg`, `g` y `unidad`; el backend normaliza `kg -> G`, `g -> G` y `unidad -> UNIDAD`. `kg` no se persiste.
* **Material en proceso:** material consumido desde Recolección y registrado en `INICIO`; puede estar en `G` o `UNIDAD`, y no representa todavía plantas vivas.
* **Adaptabilidad:** etapa operativa en la que la planta se fortalece en ambientes controlados antes de plantarse. En el MVP se registra como evento opcional de seguimiento, no como requisito bloqueante del flujo.
* **Estado del lote:** `ACTIVO | FINALIZADO`.
* **Eventos de vivero:** se registran como append-only y se consideran definitivos una vez insertados.
* **Evidencia de trazabilidad:** soporte asociado al evento, almacenado en `evidencia_trazabilidad`.
* **Motivo de cierre:** clasificación del cierre del lote: `DESPACHO_TOTAL | PERDIDA_TOTAL | MIXTO`.
* **Snapshot heredado:** copia congelada de la identidad oficial recibida desde Recolección para que el lote de vivero no cambie si luego cambia `PLANTA` u otra tabla maestra.

---

## 3. Identidad y trazabilidad del lote

### RN-VIV-01 — Identificador único del lote de vivero

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Todo lote de vivero debe poseer un identificador único e inmutable generado por el sistema.

### RN-VIV-02 — Origen único del lote

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Todo lote de vivero debe estar vinculado a **un solo lote origen**.

No se permite mezclar múltiples lotes origen en un mismo lote de vivero.

### RN-VIV-03 — Prohibida la división y fusión en vivero

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

En el MVP:

* no se permite dividir un lote en sublotes,
* no se permite fusionar dos lotes en uno.

### RN-VIV-04 — Elegibilidad del origen para iniciar vivero

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Solo se puede iniciar un lote de vivero desde una recolección que esté:

* con `estado_registro = VALIDADO`,
* operativamente habilitada para consumo,
* con `estado_recoleccion` no incompatible con consumo,
* con saldo suficiente para el consumo,
* y con identidad de planta disponible.

### RN-VIV-05 — Atomicidad entre Módulo 1 y Módulo 2

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

La creación del lote de vivero y el descuento del saldo del lote origen en Módulo 1 deben ejecutarse en **una sola transacción atómica**.

Si falla una parte, falla toda la operación.

### RN-VIV-06 — Múltiples lotes de vivero desde un mismo origen

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

Un mismo lote origen puede abastecer a múltiples lotes de vivero, siempre que cada consumo quede registrado individualmente y el saldo se recalcule correctamente.

### RN-VIV-07 — Herencia y snapshot de la planta

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Al crear el lote de vivero se debe heredar y congelar la identidad oficial desde Módulo 1. La fuente oficial del snapshot es `RECOLECCION` ya validada, no una lectura viva de `PLANTA`.

Debe incluir, como mínimo:

* `planta_id`
* `nombre_cientifico_snapshot`
* `nombre_comercial_snapshot`
* `tipo_material_snapshot`
* `variedad_snapshot`
* `nombre_comunidad_origen_snapshot`
* `nombre_responsable_snapshot`

El objetivo es congelar el historial del lote de vivero desde su nacimiento.

---

## 4. Flujo operativo y hitos

### RN-VIV-08 — Hitos estructurales del ciclo mínimo

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Todo lote de vivero debe iniciar con:

1. `INICIO`
2. `EMBOLSADO`

`DESPACHO` es obligatorio solo cuando exista salida hacia plantación o destino equivalente. Un lote también puede finalizar por pérdida total del saldo vivo.

### RN-VIV-09 — Adaptabilidad como seguimiento operativo

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Baja

La **adaptabilidad** representa el periodo en el que la planta se fortalece en ambientes controlados antes de plantarse. Puede registrarse múltiples veces como evento de seguimiento durante el ciclo del lote.

En el MVP:

* puede registrarse como evento operativo,
* puede incluir subetapas como `SOMBRA`, `MEDIA_SOMBRA` y `SOL_DIRECTO`,
* no exige permanencia mínima,
* no exige una secuencia rígida,
* y **no bloquea el despacho**.

Su objetivo en el MVP es aportar contexto operativo e historial, sin volver compleja la lógica central del sistema.

### RN-VIV-10 — Secuencialidad mínima por hitos

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

No se permite registrar:

* `EMBOLSADO` sin `INICIO` previo,
* `MERMA` sin `EMBOLSADO` previo,
* `DESPACHO` sin `EMBOLSADO` previo,
* `ADAPTABILIDAD` sin `EMBOLSADO` previo.

`ADAPTABILIDAD` no es requisito para registrar `MERMA` ni `DESPACHO`.

### RN-VIV-11 — Embolsado como nacimiento del saldo vivo

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

El saldo de plantas vivas nace en el evento `EMBOLSADO`. Antes de ese hito solo existe material en proceso. El evento `EMBOLSADO` solo puede registrarse una vez por lote.

---

## 5. Estados y validación

### RN-VIV-12 — Estados del lote

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

El lote de vivero solo puede tener estos estados:

* `ACTIVO`
* `FINALIZADO`

### RN-VIV-13 — Eventos append-only en el MVP

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

En el MVP, todo evento insertado en `EVENTO_LOTE_VIVERO` se considera definitivo y se gobierna por el modelo append-only.

### RN-VIV-14 — Sin validación adicional por evento

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

En el MVP no existe flujo de validación, aprobación o rechazo por evento. Todo registro append-only se toma como verdadero al momento de guardarse.

### RN-VIV-15 — Edición posterior del evento

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Una vez registrado un evento, no debe editarse ni sobrescribirse.

Si más adelante se requiere ajuste, deberá resolverse con eventos correctivos en una siguiente fase del producto.

---

## 6. Cantidades, saldos y cierres

### RN-VIV-16 — Doble lectura de cantidad en Inicio

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

El inicio del lote debe registrar simultáneamente:

* `LOTE_VIVERO.cantidad_inicial_en_proceso`,
* `LOTE_VIVERO.unidad_medida_inicial`,
* `EVENTO_LOTE_VIVERO.cantidad_afectada` para el `INICIO`,
* `EVENTO_LOTE_VIVERO.unidad_medida_evento` para el `INICIO`.

En el MVP, `cantidad_inicial_en_proceso` refleja el consumo realizado sobre el lote origen y debe quedar alineada con el movimiento `CONSUMO_A_VIVERO` registrado en Módulo 1.

### RN-VIV-16A — Contrato de herencia de snapshots en INICIO

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Al iniciar un lote de vivero, los snapshots heredados deben quedar alineados con el snapshot oficial de la recolección validada.

Invariantes mínimas:

* `LOTE_VIVERO.nombre_cientifico_snapshot = RECOLECCION.nombre_cientifico_snapshot`
* `LOTE_VIVERO.nombre_comercial_snapshot = RECOLECCION.nombre_comercial_snapshot`
* `LOTE_VIVERO.tipo_material_snapshot = RECOLECCION.tipo_material`
* `LOTE_VIVERO.variedad_snapshot = RECOLECCION.variedad_snapshot`

En el MVP estos datos quedan congelados al crear el lote y no deben recalcularse después.

### RN-VIV-17 — La unidad del inicio respeta la unidad canónica del origen

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

Para `SEMILLA`, el consumo del origen puede mantenerse en `G` o `UNIDAD` según la unidad canónica del lote origen y las reglas funcionales definidas para la especie/material.

Para `ESQUEJE`, la unidad es siempre `UNIDAD`, con entero estricto y sin decimales.

Desde `EMBOLSADO`, el saldo vivo se maneja siempre en `UNIDAD`.

Si `tipo_material_snapshot = OTRO`, el flujo queda fuera del estándar del MVP y requiere definición adicional.

### RN-VIV-17A — Contrato estricto entre Recolección y Vivero en `INICIO`

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Cuando se crea un `LOTE_VIVERO` desde una `RECOLECCION`, el movimiento `CONSUMO_A_VIVERO`, el lote y el evento `INICIO` deben quedar estrictamente alineados.

Invariantes obligatorias:

* `abs(RECOLECCION_MOVIMIENTO.delta) = LOTE_VIVERO.cantidad_inicial_en_proceso`
* `LOTE_VIVERO.cantidad_inicial_en_proceso = EVENTO_LOTE_VIVERO.cantidad_afectada`
* `RECOLECCION_MOVIMIENTO.unidad_medida_movimiento = LOTE_VIVERO.unidad_medida_inicial`
* `LOTE_VIVERO.unidad_medida_inicial = EVENTO_LOTE_VIVERO.unidad_medida_evento`

### RN-VIV-17B — Convención oficial de unidades y reglas numéricas

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

La convención oficial del sistema en DB, backend, frontend y documentación es:

* `UNIDAD`
* `G`

Reglas obligatorias:

* No se deben mezclar `G` y `GR`.
* `G` permite decimales.
* `UNIDAD` no permite decimales.
* `kg` solo existe como input del frontend y nunca se persiste.
* No se aceptan otras unidades en el MVP.

### RN-VIV-17C — El sistema no convierte masa en plantas vivas

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

El sistema no convierte automáticamente gramos en plantas vivas.

`EMBOLSADO` registra un nuevo dato observado del proceso: cuántas plantas vivas resultaron del material que entró al lote.

### RN-VIV-18 — Todo evento que afecte saldo vivo registra saldo antes y después

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Los eventos `EMBOLSADO`, `MERMA` y `DESPACHO` deben registrar:

* `saldo_vivo_antes`
* `saldo_vivo_despues`

Reglas específicas:

* en `EMBOLSADO`, `saldo_vivo_antes = 0`,
* en `EMBOLSADO`, `saldo_vivo_despues = plantas_vivas_iniciales`,
* en `MERMA` y `DESPACHO`, el saldo lo calcula el sistema.

### RN-VIV-18A — Reglas de unidad por evento

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Reglas obligatorias por evento:

* `INICIO`: `cantidad_afectada` usa la misma cantidad que el consumo de Recolección y `unidad_medida_evento` usa la misma unidad del origen.
* `EMBOLSADO`: `cantidad_afectada = plantas_vivas_iniciales` y `unidad_medida_evento = UNIDAD`.
* `ADAPTABILIDAD`, `MERMA`, `DESPACHO` y `CIERRE_AUTOMATICO`: operan sobre saldo vivo en `UNIDAD`.

Para `ADAPTABILIDAD`, si el modelo persiste `cantidad_afectada`, esta debe expresarse en `UNIDAD` y referir al saldo vivo observado; no modifica el saldo.

### RN-VIV-19 — MERMA representa pérdida explícita

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Toda pérdida operativa debe registrarse mediante un evento `MERMA` con causa, cantidad y responsable.

### RN-VIV-20 — Despachos y mermas no pueden exceder el saldo

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

La cantidad perdida o despachada no puede superar el saldo vivo disponible al momento del evento.

### RN-VIV-21 — El saldo vivo no puede ser negativo

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Ningún evento puede dejar el saldo vivo en un valor negativo.

### RN-VIV-22 — El saldo vivo no aumenta en el MVP

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

En el MVP, el saldo vivo solo puede mantenerse o disminuir.

No se permiten incrementos de saldo vivo una vez nacido en `EMBOLSADO`.

### RN-VIV-23 — Cierre automático por saldo vivo 0

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Cuando el saldo vivo llegue a `0`, el lote debe pasar automáticamente a estado `FINALIZADO`.

### RN-VIV-24 — Motivo de cierre obligatorio

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Todo cierre automático debe calcular y guardar un `motivo_cierre`:

* `DESPACHO_TOTAL`
* `PERDIDA_TOTAL`
* `MIXTO`

### RN-VIV-25 — Lote finalizado no admite eventos operativos nuevos

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Una vez que el lote pase a `FINALIZADO`, no se permiten nuevos eventos operativos normales.

---

## 7. Evidencia de trazabilidad

### RN-VIV-26 — Evidencia mínima por evento crítico

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

En el MVP:

* `INICIO` requiere evidencia,
* `EMBOLSADO` requiere evidencia,
* `ADAPTABILIDAD` requiere evidencia,
* `MERMA` requiere evidencia,
* `DESPACHO` requiere evidencia.

La evidencia debe almacenarse y vincularse directamente al evento que la origina.

En el esquema, esto implica:

* `EVIDENCIAS_TRAZABILIDAD.tipo_entidad_id` asociado al tipo de entidad evento de vivero,
* `EVIDENCIAS_TRAZABILIDAD.entidad_id = EVENTO_LOTE_VIVERO.id`.

### RN-VIV-27 — No se permite completar un evento crítico sin evidencia requerida

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Si un evento que exige evidencia no tiene soporte válido, no debe registrarse.

### RN-VIV-28 — No se aceptan excepciones de evidencia en el MVP

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

En el MVP no se aceptan excepciones de evidencia ni aprobaciones especiales para omitirla.

### RN-VIV-29 — No se acepta evidencia tardía en el MVP

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

En el MVP, la evidencia debe registrarse junto con el evento cuando sea obligatoria.

### RN-VIV-30 — Umbral de merma puede exigir observación reforzada

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

Cuando una merma supere el umbral operativo configurado, el sistema debe exigir observación obligatoria y puede exigir evidencia adicional.

---

## 8. Reglas temporales

### RN-VIV-31 — Doble fecha obligatoria

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Todo evento debe registrar:

* `fecha_evento`
* `created_at`

### RN-VIV-32 — No se permiten fechas futuras

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

No se permite registrar eventos con `fecha_evento` futura.

### RN-VIV-33 — Ventana retroactiva máxima de 10 días

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

Se permite registrar eventos hasta 10 días en el pasado respecto de la fecha actual del sistema. Este valor debe ser configurable por el sistema.

### RN-VIV-34 — Coherencia temporal por hitos

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

No se permite registrar un evento con fecha anterior al hito que lo habilita.

---

## 9. Modelo de eventos y blockchain

### RN-VIV-35 — Eventos append-only

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Los eventos del vivero se agregan al historial y no pueden sobrescribirse ni eliminarse.

### RN-VIV-36 — Tipos de evento del MVP

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

Los tipos de evento mínimos del MVP son:

* `INICIO`
* `EMBOLSADO`
* `ADAPTABILIDAD`
* `MERMA`
* `DESPACHO`
* `CIERRE_AUTOMATICO`

### RN-VIV-37 — Blockchain no bloquea el núcleo operativo

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

El historial operativo del MVP vive primero en base de datos.

La estrategia blockchain no debe bloquear el registro, consulta ni cierre confiable del lote.

### RN-VIV-38 — Anclaje blockchain mínimo del MVP

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Si se implementa anclaje blockchain en el MVP, solo el evento `DESPACHO` será candidato a anclaje.

En el esquema actual, ese anclaje se almacena como `EVENTO_LOTE_VIVERO.metadata_blockchain`.

Este anclaje debe considerarse complementario y no indispensable para el funcionamiento base del módulo.

---

## 10. Consulta operativa y cadena de custodia

### RN-VIV-39 — Listado operativo obligatorio

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

El módulo debe permitir listar y consultar lotes por:

* estado,
* vivero,
* planta o especie,
* `recoleccion_id`,
* `lote_vivero_id`,
* motivo de cierre.

### RN-VIV-40 — Cadena de custodia visible

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

La consulta del lote debe hacer visible la secuencia:

`recolección origen -> consumo -> inicio -> embolsado -> adaptabilidad -> mermas -> despachos -> cierre`

### RN-VIV-41 — Reportes distinguen tipos de cierre

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Los reportes deben diferenciar claramente los lotes cerrados por:

* `DESPACHO_TOTAL`
* `PERDIDA_TOTAL`
* `MIXTO`

---

## 11. Roles mínimos del MVP

### RN-VIV-42 — Roles mínimos

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

Para el MVP se debe trabajar sobre los roles existentes en `rol_usuario`:

* `ADMIN`
* `GENERAL`
* `VALIDADOR`
* `VOLUNTARIO`

### RN-VIV-43 — Alcance operativo por rol

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

* `ADMIN`: parametriza, consulta y administra.
* `GENERAL`: registra eventos permitidos y consulta lotes.
* `VALIDADOR`: existe como rol global, pero en este módulo no activa un flujo especial en el MVP.
* `VOLUNTARIO`: no debería registrar eventos críticos del módulo salvo parametrización explícita.

---

## 12. Alcance real del MVP

### RN-VIV-44 — Lo que sí protege el núcleo del MVP

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

El MVP prioriza:

* trazabilidad del origen,
* creación del lote desde un único origen,
* consumo atómico Módulo 1 -> Módulo 2,
* snapshots de planta,
* control de saldo vivo,
* registro auditable de eventos clave,
* evidencia mínima,
* y cierre confiable del lote.

### RN-VIV-45 — Lo que queda fuera del MVP

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** No
* **Relevancia carbono:** Media

Quedan fuera del MVP:

* correcciones posteriores por eventos compensatorios,
* reapertura de lotes,
* excepciones de evidencia,
* evidencia tardía,
* blockchain multi-hito,
* anclaje por cada evento,
* modelado agronómico avanzado por especie,
* división y fusión de lotes,
* y flujos complejos offline-first.

### RN-VIV-46 — Principio de crecimiento posterior

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

El diseño del MVP debe dejar preparada una evolución futura para incorporar, sin romper el núcleo:

* subflujos más ricos de adaptabilidad,
* correcciones auditadas,
* blockchain ampliada,
* y mayor profundidad operativa.
