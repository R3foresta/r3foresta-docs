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
* **Unidades en proceso:** semillas sembradas estimadas o esquejes iniciados; aún no son plantas vivas.
* **Plantas vivas:** saldo operativo que nace en el evento `EMBOLSADO`.
* **Saldo vivo:** cantidad actual de plantas vivas disponibles en el lote.
* **Adaptabilidad:** etapa operativa en la que la planta se fortalece en ambientes controlados antes de plantarse. En el MVP se registra como evento opcional de seguimiento, no como requisito bloqueante del flujo.
* **Estado del lote:** `ACTIVO | FINALIZADO`.
* **Estado del evento:** en el MVP todo evento se registra directamente como `COMPLETO`.
* **Evidencia de trazabilidad:** soporte asociado al evento, almacenado en `evidencia_trazabilidad`.
* **Motivo de cierre:** clasificación del cierre del lote: `DESPACHO_TOTAL | PERDIDA_TOTAL | MIXTO`.

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

* no se permite dividir un lote en sub-lotes,
* no se permite fusionar dos lotes en uno.

### RN-VIV-04 — Elegibilidad del origen para iniciar vivero

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Solo se puede iniciar un lote de vivero desde una recolección que esté:

* en estado **VERIFICADO** o equivalente formal del Módulo 1,
* operativamente habilitada para consumo,
* con saldo suficiente,
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

Al crear el lote de vivero se debe heredar y congelar la identidad de la planta o especie desde Módulo 1, incluyendo como mínimo:

* `planta_id`
* `nombre_cientifico_snapshot`
* `nombre_comercial_snapshot`
* `tipo_material_snapshot`

---

## 4. Flujo operativo y hitos

### RN-VIV-08 — Hitos obligatorios del ciclo mínimo

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

El flujo mínimo del lote en MVP incluye estos hitos obligatorios:

1. `INICIO`
2. `EMBOLSADO`
3. `DESPACHO`

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

El saldo de plantas vivas nace en el evento `EMBOLSADO`. Antes de ese hito solo existen unidades en proceso. El evento EMBOLSADO solo puede registrarse una vez por lote.

---

## 5. Estados y validación

### RN-VIV-12 — Estados del lote

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

El lote de vivero solo puede tener estos estados:

* `ACTIVO`
* `FINALIZADO`

### RN-VIV-13 — Estado del evento en el MVP

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

En el MVP, todo evento se registra directamente como `COMPLETO`.

No se utilizarán flujos operativos de `BORRADOR`, `PENDIENTE_VALIDACION` o `RECHAZADO`. De todas formas debemos dejar preparada la evolución futura para incorporar validación formal por evento sin romper el núcleo del MVP.

### RN-VIV-14 — Validación formal por evento

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** No
* **Relevancia carbono:** Media

La validación formal por evento con estados intermedios queda reservada para una fase posterior.

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

* `cantidad_consumida_origen` en la unidad canónica de Módulo 1,
* `unidades_iniciales_en_proceso` como lectura operativa del vivero.

En el MVP, el evento `INICIO` se registra directamente como `COMPLETO` y, en esa misma transacción atómica, se descuenta el saldo oficial del lote origen verificando disponibilidad suficiente.

### RN-VIV-17 — Semilla puede consumir en gramos y operar en unidades estimadas

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

Para semilla, el consumo del origen puede mantenerse en gramos o unidades según la unidad canónica del lote origen, mientras vivero puede registrar una cantidad estimada de semillas sembradas.

### RN-VIV-18 — Todo evento que afecte saldo vivo registra saldo antes y después

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

Los eventos `EMBOLSADO`, `MERMA` y `DESPACHO` que afecten saldo vivo deben registrar:

* `saldo_vivo_antes`
* `saldo_vivo_despues`

El saldo vivo debe ser calculado por el sistema y no provisto por el usuario.

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
* `DESPACHO` requiere evidencia,
* `EMBOLSADO`, `MERMA` y `ADAPTABILIDAD` requieren evidencia.

La evidencia debe almacenarse y vincularse directamente al evento que la origina.

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
* lote origen,
* lote de vivero,
* motivo de cierre.

### RN-VIV-40 — Cadena de custodia visible

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

La consulta del lote debe hacer visible la secuencia:

`recolección origen → consumo → inicio → embolsado → adaptabilidad → mermas → despachos → cierre`

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

Para el MVP bastan estos roles mínimos:

* `ADMIN`
* `OPERADOR`
* `CONSULTA`

Roles futuros:
* `VALIDADOR`

### RN-VIV-43 — Alcance operativo por rol

* **Severidad:** ADVERTENCIA

* **Aplica en MVP:** Sí

* **Relevancia carbono:** Media

* `ADMIN`: parametriza, consulta y administra.

* `OPERADOR`: registra eventos permitidos y consulta lotes.

* `CONSULTA`: visualiza historial, cadena de custodia y reportes.

Roles futuros:
* `VALIDADOR`: valida eventos.

---

## 12. Alcance real del MVP

### RN-VIV-44 — Lo que sí protege el núcleo del MVP

* **Severidad:** BLOQUEANTE
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Alta

El MVP prioriza:

* trazabilidad del origen,
* creación del lote desde un único origen,
* consumo atómico Módulo 1 → Módulo 2,
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

* validación formal por evento,
* estados `BORRADOR`, `PENDIENTE_VALIDACION` y `RECHAZADO` en operación,
* correcciones post-validación,
* reapertura de lotes,
* excepciones de evidencia,
* evidencia tardía,
* multi-aprobación,
* blockchain multi-hito,
* anclaje por cada evento,
* modelado agronómico avanzado por especie,
* y flujos complejos offline-first.

### RN-VIV-46 — Principio de crecimiento posterior

* **Severidad:** ADVERTENCIA
* **Aplica en MVP:** Sí
* **Relevancia carbono:** Media

El diseño del MVP debe dejar preparada una evolución futura para incorporar, sin romper el núcleo:

* validaciones más complejas,
* subflujos más ricos de adaptabilidad,
* correcciones auditadas,
* blockchain ampliada,
* y mayor profundidad operativa.
