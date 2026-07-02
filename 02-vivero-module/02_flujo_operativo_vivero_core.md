# Flujo operativo - Modulo 2: Vivero Core

## 1. Proposito

Esta guia describe solamente el flujo operativo del nucleo de Vivero.

El contrato por el cual Recoleccion habilita el inicio de un lote vive en:

[`../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md`](../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md)

La integracion con Plantacion mediante asignaciones, devoluciones y despachos automaticos se documenta en:

[`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md)

## 2. Flujo core

```text
Recoleccion validada
-> INICIO
-> EMBOLSADO
-> ADAPTABILIDAD opcional
-> MERMA y/o DESPACHO MANUAL
-> CIERRE_AUTOMATICO
```

## 3. Lectura de cada hito

### 3.1 INICIO

`INICIO` crea el lote de vivero y el primer evento append-only.

Reglas clave:

- no crea saldo vivo,
- registra material en proceso,
- registra `cantidad_inicial_en_proceso`,
- registra evidencia obligatoria,
- conserva el vinculo con una unica recoleccion origen,
- y ejecuta el consumo de origen segun el contrato Recoleccion -> Vivero.

En este punto:

- `plantas_vivas_iniciales = null`
- `saldo_vivo_actual = null`
- `saldo_vivo_antes = null`
- `saldo_vivo_despues = null`

`fecha_inicio` del lote debe coincidir con `fecha_evento` del evento `INICIO`, salvo excepcion explicita documentada.

### 3.2 EMBOLSADO

`EMBOLSADO` marca el nacimiento del saldo vivo.

Reglas clave:

- solo puede registrarse una vez por lote,
- requiere `INICIO` previo,
- `plantas_vivas_iniciales > 0`,
- `cantidad_afectada = plantas_vivas_iniciales`,
- `unidad_medida_evento = UNIDAD`,
- `saldo_vivo_antes = null`,
- `saldo_vivo_despues = plantas_vivas_iniciales`,
- requiere evidencia obligatoria,
- y el sistema calcula `LOTE_VIVERO.saldo_vivo_actual`.

El sistema no convierte automaticamente gramos en plantas vivas. El embolsado registra un conteo observado.

### 3.3 ADAPTABILIDAD opcional

`ADAPTABILIDAD` registra seguimiento operativo del fortalecimiento del lote.

Reglas clave:

- requiere `EMBOLSADO` previo,
- puede ocurrir multiples veces,
- admite subetapas como `SOMBRA`, `MEDIA_SOMBRA` y `SOL_DIRECTO`,
- no cambia saldo vivo,
- no bloquea `MERMA`,
- no bloquea `DESPACHO MANUAL`,
- y la evidencia es opcional.

Si el modelo guarda saldos en este evento:

```text
saldo_vivo_antes = saldo_vivo_despues = saldo_vivo_actual
```

### 3.4 MERMA

`MERMA` registra una perdida real del saldo vivo.

Reglas clave:

- requiere `EMBOLSADO` previo,
- `cantidad_afectada > 0`,
- `unidad_medida_evento = UNIDAD`,
- `cantidad_afectada <= saldo_vivo_actual`,
- debe registrar `causa_merma`,
- requiere evidencia obligatoria,
- baja `saldo_vivo_actual`,
- y no puede dejar saldo negativo.

Si `saldo_vivo_actual` llega a `0`, se dispara `CIERRE_AUTOMATICO`.

La politica de mermas sobre asignaciones activas pertenece al contrato Vivero -> Plantacion.

### 3.5 DESPACHO MANUAL

`DESPACHO MANUAL` registra una salida real desde Vivero hacia un destino que no es despacho automatico de Plantacion.

Reglas clave:

- requiere `EMBOLSADO` previo,
- `cantidad_afectada > 0`,
- `unidad_medida_evento = UNIDAD`,
- requiere destino estructurado,
- requiere evidencia propia obligatoria,
- baja `saldo_vivo_actual`,
- no puede dejar saldo negativo,
- `ADAPTABILIDAD` no es requisito para despachar.

En core puro valida contra `saldo_vivo_actual`.

Cuando el contrato Vivero -> Plantacion esta activo, el despacho manual debe respetar saldo reservado y validar contra `saldo_vivo_disponible_asignacion`; esa regla no vive en este core, sino en el contrato.

### 3.6 CIERRE_AUTOMATICO

`CIERRE_AUTOMATICO` ocurre cuando:

```text
saldo_vivo_actual = 0
```

Reglas clave:

- el lote pasa a `FINALIZADO`,
- se calcula `motivo_cierre`,
- se registra `ref_evento_trigger_id`,
- y se bloquean nuevos eventos operativos normales.

Motivos de cierre:

- `DESPACHO_TOTAL`
- `PERDIDA_TOTAL`
- `MIXTO`

## 4. Secuencia valida

```text
INICIO
  -> EMBOLSADO
      -> ADAPTABILIDAD*
      -> MERMA*
      -> DESPACHO MANUAL*
      -> CIERRE_AUTOMATICO cuando saldo_vivo_actual = 0
```

`ADAPTABILIDAD`, `MERMA` y `DESPACHO MANUAL` pueden intercalarse despues de `EMBOLSADO`, respetando fechas y saldo.

## 5. Evidencia

Eventos con evidencia obligatoria en core:

- `INICIO`
- `EMBOLSADO`
- `MERMA`
- `DESPACHO`

Evento con evidencia opcional:

- `ADAPTABILIDAD`

La evidencia se vincula al `EVENTO_LOTE_VIVERO.id` mediante `EVIDENCIAS_TRAZABILIDAD`.

## 6. Fuera del core

No forman parte de esta guia operativa:

- asignacion de lote a subcampania,
- devolucion de saldo asignado,
- saldo asignado,
- saldo libre por asignaciones,
- despacho automatico desde Plantacion,
- consumo de asignaciones por `PLANTACION_INICIAL` o `REPOSICION`,
- mermas distribuidas sobre asignaciones activas.

Estos puntos son contrato entre modulos y viven en [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md).

## 7. TODO / Decision pendiente

Evaluar evento `FALLO_PRE_EMBOLSADO` o `DESCARTE_PRE_EMBOLSADO` para lotes que llegan a `INICIO` pero nunca alcanzan `EMBOLSADO`.
