# Reglas de Negocio (RN) - Modulo 2: Vivero Core - Version MVP

## 1. Proposito

Estas reglas definen el nucleo operativo de Vivero sin mezclar contratos de integracion. El core cubre:

- trazabilidad fuerte de un lote de vivero,
- origen unico,
- eventos append-only,
- nacimiento y control del saldo vivo,
- descarte pre-embolsado,
- merma,
- despacho manual,
- evidencia obligatoria,
- cierre automatico,
- roles operativos reales,
- y blockchain como metadata opcional.

Los contratos entre modulos viven fuera de este directorio:

- Recoleccion -> Vivero: [`../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md`](../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md)
- Vivero -> Plantacion: [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md)

## 2. Definiciones base

- **Lote origen:** registro de Recoleccion que abastece al vivero. Sus condiciones de consumo pertenecen al contrato Recoleccion -> Vivero.
- **Lote de vivero:** lote iniciado en Modulo 2 a partir de un unico lote origen.
- **Material en proceso:** material registrado en `INICIO`; todavia no representa plantas vivas.
- **Plantas vivas:** saldo operativo que nace en `EMBOLSADO`.
- **Saldo vivo:** cantidad actual de plantas vivas disponibles en el lote.
- **Persistencia oficial de unidades:** `ENUM(unidad_medida) = [UNIDAD, G]`.
- **Normalizacion de entrada:** el frontend puede aceptar `kg`, `g` y `unidad`; el backend normaliza `kg -> G`, `g -> G` y `unidad -> UNIDAD`. `kg` no se persiste.
- **Adaptabilidad:** seguimiento opcional del fortalecimiento en ambientes controlados; no bloquea despacho.
- **Estado del lote:** `ACTIVO | FINALIZADO`.
- **Eventos de vivero:** registros append-only y definitivos una vez insertados.
- **Motivo de cierre:** `DESPACHO_TOTAL | PERDIDA_TOTAL | MIXTO | DESCARTE_PRE_EMBOLSADO`.

## 3. Identidad y trazabilidad del lote

### RN-VIV-01 - Identificador unico del lote de vivero

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Todo lote de vivero debe poseer un identificador unico e inmutable generado por el sistema.

El `codigo_trazabilidad` del lote de vivero debe construirse con el formato:

`VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`

El codigo de vivero es propio del lote y no reemplaza el codigo de la recoleccion; lo concatena para conservar el vinculo visible con el origen.

### RN-VIV-02 - Origen unico del lote

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Todo lote de vivero debe estar vinculado a un solo lote origen.

No se permite mezclar multiples lotes origen en un mismo lote de vivero.

### RN-VIV-03 - Prohibida la division y fusion en vivero

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

En el MVP:

- no se permite dividir un lote en sublotes,
- no se permite fusionar dos lotes en uno.

### Reglas movidas al contrato Recoleccion -> Vivero

Las reglas originales `RN-VIV-04`, `RN-VIV-05`, `RN-VIV-07`, `RN-VIV-16A` y `RN-VIV-17A` se conservan con su ID original en el contrato Recoleccion -> Vivero porque definen elegibilidad del origen, atomicidad M1 -> M2, herencia de snapshots e invariantes entre entidades de ambos modulos.

## 4. Flujo operativo y hitos

### RN-VIV-06 - Multiples lotes de vivero desde un mismo origen

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

Un mismo lote origen puede abastecer a multiples lotes de vivero, siempre que cada consumo quede registrado individualmente y el contrato Recoleccion -> Vivero mantenga saldos, cantidades y unidades consistentes.

### RN-VIV-08 - Hitos estructurales del ciclo minimo

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Todo lote de vivero debe iniciar con:

1. `INICIO`
2. `EMBOLSADO` o `DESCARTE_PRE_EMBOLSADO`

Si sigue el camino de `EMBOLSADO`, luego puede registrar `ADAPTABILIDAD`, `MERMA` y `DESPACHO` manual, hasta cerrar automaticamente cuando `saldo_vivo_actual = 0`.

Si el lote nunca produce plantas vivas, debe cerrarse con `DESCARTE_PRE_EMBOLSADO` y no quedar activo indefinidamente.

### RN-VIV-09 - Adaptabilidad como seguimiento operativo

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Baja

La adaptabilidad representa el periodo en el que la planta se fortalece en ambientes controlados antes de plantarse. Puede registrarse multiples veces como evento de seguimiento durante el ciclo del lote.

En el MVP:

- puede incluir subetapas como `SOMBRA`, `MEDIA_SOMBRA` y `SOL_DIRECTO`,
- no exige permanencia minima,
- no exige una secuencia rigida,
- no cambia saldo vivo,
- y no bloquea `MERMA` ni `DESPACHO` manual.

### RN-VIV-10 - Secuencialidad minima por hitos

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

No se permite registrar:

- `EMBOLSADO` sin `INICIO` previo,
- `DESCARTE_PRE_EMBOLSADO` sin `INICIO` previo,
- `DESCARTE_PRE_EMBOLSADO` si ya existe `EMBOLSADO`,
- `MERMA` sin `EMBOLSADO` previo,
- `DESPACHO` manual sin `EMBOLSADO` previo,
- `ADAPTABILIDAD` sin `EMBOLSADO` previo.

`ADAPTABILIDAD` no es requisito para registrar `MERMA` ni `DESPACHO` manual.

### RN-VIV-11 - Embolsado como nacimiento del saldo vivo

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

El saldo de plantas vivas nace unicamente en el evento `EMBOLSADO`. Antes de ese hito solo existe material en proceso.

El evento `EMBOLSADO` solo puede registrarse una vez por lote.

### RN-VIV-11A - Descarte pre-embolsado cierra lotes sin plantas vivas

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Cuando un lote ya tuvo `INICIO`, todavia no tuvo `EMBOLSADO` y se determina que no producira plantas vivas, debe registrarse `DESCARTE_PRE_EMBOLSADO`.

Este evento aplica, entre otros, a:

- semilla que no germino,
- esqueje que no enraizo,
- contaminacion,
- perdida total del material,
- material no viable,
- dano antes de formar plantas vivas.

Reglas obligatorias:

- requiere `INICIO` previo,
- no puede registrarse si ya existe `EMBOLSADO`,
- no opera sobre `saldo_vivo_actual`, porque el saldo vivo todavia no existe,
- debe cerrar el lote inmediatamente,
- debe exigir evidencia obligatoria,
- debe registrar causa mediante `causa_descarte_pre_embolsado`,
- debe registrar `cantidad_material_afectado` y `unidad_medida_evento`,
- debe registrar `motivo_cierre = DESCARTE_PRE_EMBOLSADO`,
- debe dejar `plantas_vivas_iniciales = null` y `saldo_vivo_actual = null`.

El descarte pre-embolsado es total sobre el material en proceso del lote. No se permite usar este evento para descartes parciales.

## 5. Estados y validacion

### RN-VIV-12 - Estados del lote

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

El lote de vivero solo puede tener estos estados:

- `ACTIVO`
- `FINALIZADO`

### RN-VIV-13 - Eventos append-only en el MVP

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

En el MVP, todo evento insertado en `EVENTO_LOTE_VIVERO` se considera definitivo y se gobierna por el modelo append-only.

### RN-VIV-14 - Sin validacion adicional por evento

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

En el MVP no existe flujo de validacion, aprobacion o rechazo por evento. Todo registro append-only se toma como verdadero al momento de guardarse.

### RN-VIV-15 - Edicion posterior del evento

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Una vez registrado un evento, no debe editarse ni sobrescribirse.

Si mas adelante se requiere ajuste, debera resolverse con eventos correctivos en una fase posterior.

## 6. Cantidades, saldos y cierres

### RN-VIV-16 - Doble lectura de cantidad en Inicio

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

El inicio del lote debe registrar simultaneamente:

- `LOTE_VIVERO.cantidad_inicial_en_proceso`,
- `LOTE_VIVERO.unidad_medida_inicial`,
- `EVENTO_LOTE_VIVERO.cantidad_afectada` para el `INICIO`,
- `EVENTO_LOTE_VIVERO.unidad_medida_evento` para el `INICIO`.

En el MVP, `cantidad_inicial_en_proceso` refleja el material que entra al proceso de vivero. La alineacion estricta con el movimiento de Recoleccion vive en el contrato Recoleccion -> Vivero.

### RN-VIV-17 - La unidad del inicio respeta la unidad canonica del origen

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

Para `SEMILLA`, el consumo del origen puede mantenerse en `G` o `UNIDAD` segun la unidad canonica del lote origen y las reglas funcionales definidas para la especie/material.

Para `ESQUEJE`, la unidad es siempre `UNIDAD`, con entero estricto y sin decimales.

Desde `EMBOLSADO`, el saldo vivo se maneja siempre en `UNIDAD`.

Si `tipo_material_snapshot = OTRO`, el flujo queda fuera del estandar del MVP y requiere definicion adicional.

### RN-VIV-17B - Convencion oficial de unidades y reglas numericas

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

La convencion oficial del sistema en DB, backend, frontend y documentacion es:

- `UNIDAD`
- `G`

Reglas obligatorias:

- No se deben mezclar `G` y `GR`.
- `G` permite decimales.
- `UNIDAD` no permite decimales.
- `kg` solo existe como input del frontend y nunca se persiste.
- No se aceptan otras unidades en el MVP.

### RN-VIV-17C - El sistema no convierte masa en plantas vivas

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

El sistema no convierte automaticamente gramos en plantas vivas.

`EMBOLSADO` registra un nuevo dato observado del proceso: cuantas plantas vivas resultaron del material que entro al lote.

### RN-VIV-18 - Todo evento que afecte saldo vivo registra saldo antes y despues

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Los eventos `EMBOLSADO`, `MERMA` y `DESPACHO` manual deben registrar:

- `saldo_vivo_antes`
- `saldo_vivo_despues`

Reglas especificas:

- en `EMBOLSADO`, `saldo_vivo_antes = null`,
- en `EMBOLSADO`, `saldo_vivo_despues = plantas_vivas_iniciales`,
- en `MERMA` y `DESPACHO` manual, el saldo lo calcula el sistema.

### RN-VIV-18A - Reglas de unidad por evento

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Reglas obligatorias por evento:

- `INICIO`: usa la misma unidad definida por el contrato Recoleccion -> Vivero.
- `EMBOLSADO`: `cantidad_afectada = plantas_vivas_iniciales` y `unidad_medida_evento = UNIDAD`.
- `DESCARTE_PRE_EMBOLSADO`: usa la unidad del material en proceso (`UNIDAD` o `G`) y no crea saldo vivo.
- `ADAPTABILIDAD`, `MERMA` y `DESPACHO` manual operan sobre saldo vivo en `UNIDAD`.
- `CIERRE_AUTOMATICO` hereda la semantica del evento que lo dispara: saldo vivo `0` si viene de `MERMA`/`DESPACHO`, o saldo vivo nulo si viene de `DESCARTE_PRE_EMBOLSADO`.

Para `ADAPTABILIDAD`, si el modelo persiste `cantidad_afectada`, esta debe expresarse en `UNIDAD` y referir al saldo vivo observado; no modifica el saldo.

### RN-VIV-19 - MERMA representa perdida explicita

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Toda perdida operativa debe registrarse mediante un evento `MERMA` con causa, cantidad y responsable.

Excepcion semantica: si la perdida ocurre antes de `EMBOLSADO`, no es `MERMA`; debe registrarse como `DESCARTE_PRE_EMBOLSADO`.

### RN-VIV-20 - Despachos manuales y mermas no pueden exceder el saldo aplicable

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

La cantidad perdida o despachada no puede superar el saldo aplicable al momento del evento.

Reglas por tipo:

- `MERMA`: `cantidad_afectada <= saldo_vivo_actual`.
- `DESPACHO` manual en core puro: `cantidad_afectada <= saldo_vivo_actual`.
- `DESPACHO` manual con contrato Vivero -> Plantacion activo: valida contra `saldo_vivo_disponible_asignacion`; esa regla vive en el contrato, no en el core.

### RN-VIV-21 - El saldo vivo no puede ser negativo

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Ningun evento puede dejar el saldo vivo en un valor negativo.

### RN-VIV-22 - El saldo vivo no aumenta en el MVP

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

En el MVP, el saldo vivo solo puede mantenerse o disminuir.

No se permiten incrementos de saldo vivo una vez nacido en `EMBOLSADO`.

### RN-VIV-23 - Cierre automatico por saldo vivo 0

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Cuando el saldo vivo llegue a `0`, el lote debe pasar automaticamente a estado `FINALIZADO`.

Si el lote nunca llega a `EMBOLSADO`, el cierre ocurre por `DESCARTE_PRE_EMBOLSADO` y no por saldo vivo `0`.

### RN-VIV-24 - Motivo de cierre obligatorio

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Todo cierre automatico debe calcular y guardar un `motivo_cierre`:

- `DESPACHO_TOTAL`
- `PERDIDA_TOTAL`
- `MIXTO`
- `DESCARTE_PRE_EMBOLSADO`

`PERDIDA_TOTAL` solo aplica cuando ya existio saldo vivo y se perdio todo por `MERMA`. Si nunca hubo plantas vivas, el motivo correcto es `DESCARTE_PRE_EMBOLSADO`.

### RN-VIV-25 - Lote finalizado no admite eventos operativos nuevos

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Una vez que el lote pase a `FINALIZADO`, no se permiten nuevos eventos operativos normales.

## 7. Evidencia de trazabilidad

### RN-VIV-26 - Evidencia minima por evento critico

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

En el MVP, cada evento principal requiere minimo 1 foto como evidencia:

- `INICIO` requiere evidencia,
- `EMBOLSADO` requiere evidencia,
- `DESCARTE_PRE_EMBOLSADO` requiere evidencia,
- `MERMA` requiere evidencia,
- `DESPACHO` manual requiere evidencia.

`ADAPTABILIDAD` puede registrar evidencia, pero no es obligatoria. Sus subetapas (`SOMBRA`, `MEDIA_SOMBRA`, `SOL_DIRECTO`) pueden registrarse sin foto.

La evidencia debe almacenarse y vincularse directamente al evento que la origina.

### RN-VIV-27 - No se permite completar un evento critico sin evidencia requerida

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Si un evento que exige evidencia no tiene soporte valido, no debe registrarse.

### RN-VIV-28 - No se aceptan excepciones de evidencia en el MVP

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

En el MVP no se aceptan excepciones de evidencia ni aprobaciones especiales para omitirla.

### RN-VIV-29 - No se acepta evidencia tardia en el MVP

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

En el MVP, la evidencia debe registrarse junto con el evento cuando sea obligatoria.

### RN-VIV-30 - Umbral de merma puede exigir observacion reforzada

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

Cuando una merma supere el umbral operativo configurado, el sistema debe exigir observacion obligatoria y puede exigir evidencia adicional.

## 8. Reglas temporales

### RN-VIV-31 - Doble fecha obligatoria

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Todo evento debe registrar:

- `fecha_evento`
- `created_at`

### RN-VIV-32 - No se permiten fechas futuras

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

No se permite registrar eventos con `fecha_evento` futura.

### RN-VIV-33 - Ventana retroactiva maxima de 10 dias

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

Se permite registrar eventos hasta 10 dias en el pasado respecto de la fecha actual del sistema. Este valor debe ser configurable.

### RN-VIV-34 - Coherencia temporal por hitos

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

No se permite registrar un evento con fecha anterior al hito que lo habilita.

## 9. Modelo de eventos y blockchain

### RN-VIV-35 - Eventos append-only

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Los eventos del vivero se agregan al historial y no pueden sobrescribirse ni eliminarse.

### RN-VIV-36 - Tipos de evento del MVP

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

Los tipos de evento minimos del core MVP son:

- `INICIO`
- `EMBOLSADO`
- `DESCARTE_PRE_EMBOLSADO`
- `ADAPTABILIDAD`
- `MERMA`
- `DESPACHO`
- `CIERRE_AUTOMATICO`

En core, `DESPACHO` significa despacho manual. El despacho automatico desde Plantacion se documenta en el contrato Vivero -> Plantacion.

### RN-VIV-37 - Blockchain no bloquea el nucleo operativo

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

El historial operativo del MVP vive primero en base de datos.

La estrategia blockchain no debe bloquear el registro, consulta ni cierre confiable del lote.

### RN-VIV-38 - Anclaje blockchain minimo del MVP

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Si se implementa anclaje blockchain en el MVP, solo el evento `DESPACHO` sera candidato a anclaje.

En el esquema actual, ese anclaje se almacena como `EVENTO_LOTE_VIVERO.metadata_blockchain`.

Este anclaje debe considerarse complementario y no indispensable para el funcionamiento base del modulo.

## 10. Consulta operativa y cadena de custodia

### RN-VIV-39 - Listado operativo obligatorio

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

El modulo debe permitir listar y consultar lotes por:

- estado,
- vivero,
- planta o especie,
- `recoleccion_id`,
- `lote_vivero_id`,
- motivo de cierre.

Los saldos derivados por asignaciones pertenecen al contrato Vivero -> Plantacion.

### RN-VIV-40 - Cadena de custodia visible

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

La consulta del lote debe hacer visible la secuencia:

`recoleccion origen -> contrato de consumo -> INICIO -> (DESCARTE_PRE_EMBOLSADO -> CIERRE_AUTOMATICO | EMBOLSADO -> ADAPTABILIDAD -> MERMA/DESPACHO MANUAL -> CIERRE_AUTOMATICO)`

### RN-VIV-41 - Reportes distinguen tipos de cierre

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Los reportes deben diferenciar claramente los lotes cerrados por:

- `DESPACHO_TOTAL`
- `PERDIDA_TOTAL`
- `MIXTO`
- `DESCARTE_PRE_EMBOLSADO`

## 11. Roles minimos del MVP

### RN-VIV-42 - Roles minimos

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

Para el MVP se debe trabajar sobre los roles existentes en `rol_usuario`:

- `ADMIN`
- `GENERAL`
- `VALIDADOR`
- `VOLUNTARIO`

No se introduce el rol `AUDITOR`.

### RN-VIV-43 - Alcance operativo por rol

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

- `ADMIN`: parametriza, consulta y administra.
- `GENERAL`: registra eventos permitidos y consulta lotes.
- `VALIDADOR`: existe como rol global, pero en este modulo no activa un flujo especial en el MVP.
- `VOLUNTARIO`: no deberia registrar eventos criticos del modulo salvo parametrizacion explicita.

`COORDINADOR` no debe asumirse como rol global de Vivero. Si aparece en contratos con Plantacion, debe tratarse como responsabilidad asociada a subcampania o quedar como decision pendiente del contrato.

## 12. Alcance real del MVP

### RN-VIV-44 - Lo que si protege el nucleo del MVP

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

El MVP core prioriza:

- trazabilidad del origen mediante contrato de entrada,
- creacion del lote desde un unico origen,
- control de saldo vivo,
- registro auditable de eventos clave,
- evidencia minima,
- y cierre confiable del lote.

### RN-VIV-45 - Lo que queda fuera del MVP

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** No
- **Relevancia carbono:** Media

Quedan fuera del core MVP:

- correcciones posteriores por eventos compensatorios,
- reapertura de lotes,
- excepciones de evidencia,
- evidencia tardia,
- blockchain multi-hito,
- anclaje por cada evento,
- modelado agronomico avanzado por especie,
- division y fusion de lotes,
- flujos complejos offline-first,
- asignaciones, devoluciones y despacho automatico hacia Plantacion.

### RN-VIV-46 - Principio de crecimiento posterior

- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

El diseno del MVP debe dejar preparada una evolucion futura para incorporar, sin romper el nucleo:

- subflujos mas ricos de adaptabilidad,
- correcciones auditadas,
- blockchain ampliada,
- y contratos de integracion con otros modulos.

## 13. Reglas movidas al contrato Vivero -> Plantacion

Las reglas originales `RN-VIV-47` a `RN-VIV-60` ya no pertenecen al core puro de Vivero. Se conservan con su ID original en [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md).

## 14. TODO / Decision pendiente

- **Snapshot geografico de origen:** evaluar si Vivero debe guardar snapshot directo de division administrativa de origen, latitud de origen y longitud de origen. La recomendacion vive en el contrato Recoleccion -> Vivero.
