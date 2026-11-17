# Reglas de Negocio (RN) - Modulo 2: Vivero Core - Version MVP

Actualización de requisitos aprobada el 16 de noviembre de 2026. Incorpora acceso por vivero, recepción única de Recolección y plantas vivas con procedencia. La evidencia por versión y entorno se consulta en [ESTADO.md](../ESTADO.md) y en los contratos enlazados.

## 1. Proposito

Estas reglas definen el nucleo operativo de Vivero sin mezclar contratos de integracion. El core cubre:

- trazabilidad fuerte de un lote de vivero,
- origen unico,
- eventos append-only,
- nacimiento y control del saldo vivo,
- incorporación de plantas vivas por recepción o conteo inicial,
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
- **Lote de vivero:** lote homogéneo con un único origen registrado, mediante Recolección o incorporación de plantas vivas.
- **Base viva:** nacimiento único del saldo mediante `EMBOLSADO` en propagación o `INCORPORACION` para plantas ya vivas.
- **Incorporación:** recepción de compra/donación o conteo inicial de existencias, con un lote nuevo y procedencia declarada conforme a `RF-VIV-15`.
- **Material en proceso:** material registrado en `INICIO`; todavia no representa plantas vivas.
- **Plantas vivas:** saldo operativo que nace en `EMBOLSADO` o `INCORPORACION`, según el camino del lote.
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

Para el camino de propagación, el `codigo_trazabilidad` del lote de vivero debe construirse con el formato:

`VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`

El codigo de vivero es propio del lote y no reemplaza el codigo de la recoleccion; lo concatena para conservar el vinculo visible con el origen.

El camino incorporado utiliza un código independiente `VIV-INC-` generado por el sistema. Las relaciones del lote y del evento conservan la procedencia consultable.

### RN-VIV-02 - Origen unico del lote

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Todo lote conserva un único origen registrado. El camino de propagación referencia una Recolección recibida y validada. El camino incorporado referencia su evento `INCORPORACION` y su procedencia, con `recoleccion_id` nulo.

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

El lote de propagación inicia con:

1. `INICIO`
2. `EMBOLSADO` o `DESCARTE_PRE_EMBOLSADO`

Si sigue el camino de `EMBOLSADO`, luego puede registrar `ADAPTABILIDAD`, `MERMA` y `DESPACHO` manual, hasta cerrar automaticamente cuando `saldo_vivo_actual = 0`.

Si el lote nunca produce plantas vivas, debe cerrarse con `DESCARTE_PRE_EMBOLSADO` y no quedar activo indefinidamente.

El lote incorporado nace con `INCORPORACION` y saldo vivo en `UNIDAD`. Ese lote puede continuar con adaptabilidad, merma, despacho y operaciones del contrato con Plantación. Cada lote admite una sola base viva.

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
- `MERMA`, `DESPACHO` manual o `ADAPTABILIDAD` sin base viva confirmada mediante `EMBOLSADO` o `INCORPORACION`,
- `INICIO`, `EMBOLSADO` o `DESCARTE_PRE_EMBOLSADO` en un lote incorporado,
- una segunda base viva en el mismo lote.

`ADAPTABILIDAD` no es requisito para registrar `MERMA` ni `DESPACHO` manual.

### RN-VIV-11 - Nacimiento único del saldo vivo

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

En propagación, el saldo de plantas vivas nace en `EMBOLSADO`. Antes de ese hito solo existe material en proceso. En el camino incorporado nace en `INCORPORACION` conforme a `RF-VIV-15`.

Cada lote admite una única base viva, mediante uno de esos eventos.

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

Desde `EMBOLSADO` o `INCORPORACION`, el saldo vivo se maneja siempre en `UNIDAD`.

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

Los eventos `EMBOLSADO`, `INCORPORACION`, `MERMA` y `DESPACHO` manual deben registrar:

- `saldo_vivo_antes`
- `saldo_vivo_despues`

Reglas especificas:

- en `EMBOLSADO`, `saldo_vivo_antes = null`,
- en `EMBOLSADO`, `saldo_vivo_despues = plantas_vivas_iniciales`,
- en `INCORPORACION`, `saldo_vivo_antes = 0` y `saldo_vivo_despues = cantidad` recibida o contada,
- en `MERMA` y `DESPACHO` manual, el saldo lo calcula el sistema.

### RN-VIV-18A - Reglas de unidad por evento

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Reglas obligatorias por evento:

- `INICIO`: usa la misma unidad definida por el contrato Recoleccion -> Vivero.
- `EMBOLSADO`: `cantidad_afectada = plantas_vivas_iniciales` y `unidad_medida_evento = UNIDAD`.
- `INCORPORACION`: `cantidad_afectada = plantas_vivas_iniciales` y `unidad_medida_evento = UNIDAD`.
- `DESCARTE_PRE_EMBOLSADO`: usa la unidad del material en proceso (`UNIDAD` o `G`) y no crea saldo vivo.
- `ADAPTABILIDAD`, `MERMA` y `DESPACHO` manual operan sobre saldo vivo en `UNIDAD`.
- `CIERRE_AUTOMATICO` hereda la semantica del evento que lo dispara: saldo vivo `0` si viene de `MERMA`/`DESPACHO`, o saldo vivo nulo si viene de `DESCARTE_PRE_EMBOLSADO`.

Para `ADAPTABILIDAD`, si el modelo persiste `cantidad_afectada`, esta debe expresarse en `UNIDAD` y referir al saldo vivo observado; no modifica el saldo.

### RN-VIV-19 - MERMA representa perdida explicita

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Toda perdida operativa debe registrarse mediante un evento `MERMA` con causa, cantidad y responsable.

En propagación, la pérdida total del material en proceso anterior a `EMBOLSADO` se registra como `DESCARTE_PRE_EMBOLSADO`. Las pérdidas posteriores al nacimiento vivo por `EMBOLSADO` o `INCORPORACION` se registran como `MERMA`.

### RN-VIV-20 - Despachos manuales y mermas no pueden exceder el saldo aplicable

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

La cantidad perdida o despachada no puede superar el saldo aplicable al momento del evento.

Reglas por tipo:

- `MERMA`: `cantidad_afectada <= saldo_vivo_actual`.
- `DESPACHO` manual en core puro: `cantidad_afectada <= saldo_vivo_actual`.
- `DESPACHO` manual con contrato Vivero -> Plantacion activo: valida contra `saldo_vivo_actual`, porque las asignaciones fisicas a subcampania ya descontaron el saldo del lote. La regla completa vive en el contrato, no en el core.

### RN-VIV-21 - El saldo vivo no puede ser negativo

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Ningun evento puede dejar el saldo vivo en un valor negativo.

### RN-VIV-22 - Aumentos de saldo vivo y devoluciones

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

El nacimiento vivo fija la cantidad inicial del lote mediante `EMBOLSADO` o `INCORPORACION`. Cada ingreso incorporado crea un lote nuevo. Los aumentos posteriores del saldo físico se limitan a las devoluciones autorizadas al mismo lote de origen según el contrato Vivero → Plantación. La cantidad inicial y la cantidad entregada se conservan.

### RN-VIV-23 - Cierre automatico por saldo vivo 0

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

Cuando el saldo vivo llegue a `0`, el lote debe pasar automaticamente a estado `FINALIZADO`.

Si el lote de propagación tuvo `INICIO` y nunca produjo saldo vivo, el cierre ocurre por `DESCARTE_PRE_EMBOLSADO`.

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

La devolución autorizada al lote de origen es la excepción operativa del contrato con Plantación. Si el lote estaba `FINALIZADO`, el retorno de plantas lo deja `ACTIVO` con el saldo restituido y `motivo_cierre` actual nulo. Los eventos de cierre anteriores permanecen en el historial y la subcampaña conserva su estado.

## 7. Evidencia de trazabilidad

### RN-VIV-26 - Evidencia minima por evento critico

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Alta

En el MVP, cada evento principal requiere minimo 1 foto como evidencia:

- `INICIO` requiere evidencia,
- `EMBOLSADO` requiere evidencia,
- `INCORPORACION` requiere evidencia privada de recepción o conteo,
- `DESCARTE_PRE_EMBOLSADO` requiere evidencia,
- `MERMA` requiere evidencia,
- `DESPACHO` manual requiere evidencia.

`ADAPTABILIDAD` puede registrar evidencia, pero no es obligatoria. Sus subetapas (`SOMBRA`, `MEDIA_SOMBRA`, `SOL_DIRECTO`) pueden registrarse sin foto.

La evidencia debe almacenarse y vincularse directamente al evento que la origina.

Las fotos T5 se preparan bajo solicitud propia y contexto de vivero, con ADMIN actual. El alta vincula esas fotos al evento en la misma transacción. Su consulta utiliza el historial autorizado del lote y URLs firmadas temporales. Un fallo de consulta o firma conserva los metadatos disponibles e informa la parte pendiente.

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

La fecha física y la fecha de persistencia se muestran con la precisión disponible. En la estructura legada, `created_at` es `DATE`. Las incorporaciones nuevas conservan además `registrado_en` como sello temporal de confirmación.

### RN-VIV-32 - No se permiten fechas futuras

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

No se permite registrar eventos con `fecha_evento` futura.

### RN-VIV-33 - Ventana retroactiva maxima de 10 dias

- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Si
- **Relevancia carbono:** Media

Se permite registrar eventos dentro de diez días inclusivos respecto del día operativo en `America/La_Paz`. La incorporación utiliza esa ventana también para `SALDO_INICIAL`, con la fecha del conteo actual. Las fechas antiguas de adquisición pueden conservarse como antecedentes.

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
- `INCORPORACION`
- `DESCARTE_PRE_EMBOLSADO`
- `ADAPTABILIDAD`
- `MERMA`
- `DESPACHO`
- `CIERRE_AUTOMATICO`

En core, `DESPACHO` significa despacho manual u otra salida propia de Vivero. La salida fisica hacia subcampanias de Plantacion y su origen de despacho se documentan en el contrato Vivero -> Plantacion.

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

Para plantas incorporadas, la secuencia comienza en recepción o conteo → `INCORPORACION` → movimientos y cierre. Conservar los antecedentes disponibles y los vacíos de historia previa. El listado y el historial distinguen la modalidad, procedencia y base viva del lote.

El historial recorre todas las páginas del mismo corte antes de declararse completo y revalida acceso en cada página. Comunica las páginas pendientes y los errores de lectura o firma de fotos. El saldo actual procede de la lectura autorizada del servidor, incluso cuando existen eventos retroactivos.

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

- `ADMIN` activo administra asignaciones de acceso y opera con alcance global.
- `GENERAL` y `VALIDADOR` activos requieren asignación vigente a cada vivero para consultar y operar sus lotes, evidencias y material permitido. Listas, totales y filtros se limitan al ámbito autorizado antes de paginar.
- Recibir y validar Recolección exige `ADMIN` activo o `VALIDADOR` con asignación vigente al vivero de almacenamiento. La persona receptora debe ser distinta de quien recolectó, incluido ADMIN.
- Nuevas incorporaciones y sus fotos pendientes requieren `ADMIN` global actual. El resultado propio confirmado sigue siendo recuperable por una cuenta activa después de perder ese rol.
- `VOLUNTARIO` conserva las capacidades expresamente definidas para participación y los resultados propios recuperables que correspondan.

`COORDINADOR` no debe asumirse como rol global de Vivero. Si aparece en contratos con Plantacion, debe tratarse como responsabilidad asociada a subcampania o quedar como decision pendiente del contrato.

La entrega y devolución explícitas requieren ADMIN activo o la intersección de asignación vigente al vivero y coordinación de la subcampaña. El retiro de un ámbito conserva los demás, la historia y los recibos propios definidos por contrato. La autoridad se revalida en servidor y se coordina con su retiro o cambio de rol. [Contrato de acceso M2](../../Backend-r3foresta/docs/t2-acceso-viveros.md).

### Incorporación de plantas vivas — RF-VIV-15

ADMIN registra `RECEPCION` de `COMPRA` o `DONACION`, o `SALDO_INICIAL` de existencias contadas. Saldo inicial admite además `PRODUCCION_PROPIA` y `DESCONOCIDA`, con observaciones obligatorias para esta última. Especie activa, vivero, cantidad entera positiva, fecha física, responsable y foto privada son obligatorios. Tercero y referencia documental son opcionales.

Lote, evento, procedencia, evidencia y resultado de solicitud se confirman juntos. La misma solicitud propia con intención idéntica recupera el hecho confirmado. Otra intención con la misma clave produce conflicto. Ante respuesta perdida o resultado inconcluso se conserva la solicitud y se consulta antes de decidir el reintento explícito.

El conteo inicial requiere excluir existencias ya representadas en otros lotes. Una compra antigua de 300 plantas con 210 contadas actualmente se registra por 210 como saldo inicial, conservando las 300 como antecedente. Compra y saldo inicial se distinguen de la producción del período registrada por `EMBOLSADO`.

El [requisito funcional](00_requerimientos_vivero_core.json) mantiene los criterios de aceptación y el [contrato T5](../../Backend-r3foresta/docs/t5-incorporacion-plantas.md) precisa validaciones, recuperación y privacidad. La [integración backend del 15 de noviembre](../../Backend-r3foresta/docs/t5-integracion-backend-2026-11-15.md) fija la autoridad ADMIN mediante 109 y la procedencia administrativa mediante 110.

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
- reapertura discrecional de lotes, con la excepción de la devolución autorizada al origen definida en `RN-VIV-25` y el contrato con Plantación,
- excepciones de evidencia,
- evidencia tardia,
- blockchain multi-hito,
- anclaje por cada evento,
- modelado agronomico avanzado por especie,
- division y fusion de lotes,
- flujos complejos offline-first,
- asignaciones fisicas, devoluciones fisicas y consumo de stock hacia Plantacion.

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

Las reglas originales `RN-VIV-47` a `RN-VIV-61` ya no pertenecen al core puro de Vivero. Se conservan con su ID original en [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md).

## 14. TODO / Decision pendiente

- **Snapshot geografico de origen:** evaluar si Vivero debe guardar snapshot directo de division administrativa de origen, latitud de origen y longitud de origen. La recomendacion vive en el contrato Recoleccion -> Vivero.
