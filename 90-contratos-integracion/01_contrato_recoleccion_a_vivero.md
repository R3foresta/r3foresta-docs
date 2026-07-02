# Contrato de integracion - Recoleccion -> Vivero

## 1. Proposito

Este contrato responde:

> Bajo que condiciones Vivero puede consumir un lote de Recoleccion y crear un lote de vivero?

El contrato define la frontera entre Modulo 1 y Modulo 2. No reemplaza las reglas internas de Recoleccion ni el core de Vivero.

Reglas movidas desde Vivero y conservadas con ID original:

- `RN-VIV-04` - Elegibilidad del origen para iniciar vivero.
- `RN-VIV-05` - Atomicidad entre Modulo 1 y Modulo 2.
- `RN-VIV-07` - Herencia y snapshot de la planta.
- `RN-VIV-16A` - Contrato de herencia de snapshots en `INICIO`.
- `RN-VIV-17A` - Contrato estricto entre Recoleccion y Vivero en `INICIO`.

## 2. Modulos involucrados

- **Modulo iniciador:** Vivero, al registrar `INICIO`.
- **Modulo proveedor:** Recoleccion, como lote origen validado.
- **Modulo receptor:** Vivero, como nuevo lote de vivero.

## 3. Entidades involucradas

- `RECOLECCION`
- `RECOLECCION_MOVIMIENTO`
- `LOTE_VIVERO`
- `EVENTO_LOTE_VIVERO`
- `EVIDENCIAS_TRAZABILIDAD`

## 4. Precondiciones del lote origen

### RN-VIV-04 - Elegibilidad del origen para iniciar vivero

Solo se puede iniciar un lote de vivero desde una recoleccion que cumpla todas estas condiciones:

- `estado_registro = VALIDADO`,
- saldo suficiente para la cantidad a consumir,
- habilitada operativamente para consumo,
- snapshot oficial congelado,
- identidad de planta disponible,
- ubicacion de origen valida.

La fuente oficial para validar identidad y snapshots es la `RECOLECCION` validada, no una lectura viva de `PLANTA`.

## 5. Datos heredados desde Recoleccion

### RN-VIV-07 - Herencia y snapshot de la planta

Al crear `LOTE_VIVERO`, Vivero debe copiar desde la recoleccion validada los snapshots minimos:

- `planta_id`
- `nombre_cientifico_snapshot`
- `nombre_comercial_snapshot`
- `tipo_material_snapshot`
- `variedad_snapshot`
- `nombre_comunidad_origen_snapshot` esto representa la division administrativa de origen.
- `nombre_responsable_snapshot`

El `vivero_id` del lote de vivero no se hereda desde `RECOLECCION.vivero_id`. Debe seleccionarse como el vivero operativo donde se gestiona ese lote.

### RN-VIV-16A - Contrato de herencia de snapshots en INICIO

Invariantes minimas:

```text
LOTE_VIVERO.nombre_cientifico_snapshot = RECOLECCION.nombre_cientifico_snapshot
LOTE_VIVERO.nombre_comercial_snapshot = RECOLECCION.nombre_comercial_snapshot
LOTE_VIVERO.tipo_material_snapshot = RECOLECCION.tipo_material
LOTE_VIVERO.variedad_snapshot = RECOLECCION.variedad_snapshot
```

Estos datos quedan congelados al crear el lote y no deben recalcularse despues.

## 6. Invariantes de cantidad y unidad

### RN-VIV-17A - Contrato estricto entre Recoleccion y Vivero en INICIO

Cuando se crea un `LOTE_VIVERO` desde una `RECOLECCION`, el movimiento `CONSUMO_A_VIVERO`, el lote y el evento `INICIO` deben quedar estrictamente alineados.

Invariantes obligatorias:

```text
abs(RECOLECCION_MOVIMIENTO.delta)
= LOTE_VIVERO.cantidad_inicial_en_proceso

LOTE_VIVERO.cantidad_inicial_en_proceso
= EVENTO_LOTE_VIVERO.cantidad_afectada

RECOLECCION_MOVIMIENTO.unidad_medida_movimiento
= LOTE_VIVERO.unidad_medida_inicial

LOTE_VIVERO.unidad_medida_inicial
= EVENTO_LOTE_VIVERO.unidad_medida_evento
```

`CONSUMO_A_VIVERO` usa `delta` negativo.

`INICIO` no crea saldo vivo. En el evento:

```text
saldo_vivo_antes = null
saldo_vivo_despues = null
```

## 7. Transaccion atomica

### RN-VIV-05 - Atomicidad entre Modulo 1 y Modulo 2

La creacion del lote de vivero y el descuento del saldo del lote origen en Recoleccion deben ejecutarse en una sola transaccion atomica.

La transaccion incluye, como minimo:

- insertar `LOTE_VIVERO`,
- insertar `EVENTO_LOTE_VIVERO` tipo `INICIO`,
- insertar `RECOLECCION_MOVIMIENTO` tipo `CONSUMO_A_VIVERO` con delta negativo,
- vincular la evidencia requerida,
- congelar snapshots heredados.

Si falla una parte, falla toda la operacion.

## 8. Evidencia requerida

`INICIO` requiere evidencia propia asociada al evento de Vivero.

La evidencia se registra en `EVIDENCIAS_TRAZABILIDAD` y debe vincularse al `EVENTO_LOTE_VIVERO.id` correspondiente.

La evidencia del lote de Recoleccion puede mostrarse como contexto de origen, pero no reemplaza la evidencia del evento `INICIO` en Vivero.

## 9. Fechas y consistencia temporal

- `fecha_inicio` de `LOTE_VIVERO` debe coincidir con `fecha_evento` del evento `INICIO`, salvo excepcion explicita documentada.
- No se permiten fechas futuras.
- La ventana retroactiva maxima sigue la regla operativa de Vivero core.
- `created_at` refleja el momento real de persistencia.

## 10. Errores de negocio esperados

La operacion debe fallar si:

- la recoleccion no esta `VALIDADO`,
- la recoleccion no esta habilitada para consumo,
- el saldo disponible es insuficiente,
- falta snapshot oficial congelado,
- falta identidad de planta,
- falta ubicacion valida de origen,
- la cantidad a consumir no es positiva,
- la unidad no coincide con la unidad canonica del origen,
- alguna de las cuatro invariantes de cantidad/unidad no se cumple,
- falta evidencia obligatoria del evento `INICIO`,
- la persistencia parcial de cualquiera de las entidades falla.

## 11. Responsabilidad de cada modulo

**Recoleccion es responsable de:**

- validar el lote origen,
- conservar el snapshot oficial de identidad y origen,
- exponer saldo suficiente,
- registrar el movimiento `CONSUMO_A_VIVERO` con delta negativo dentro de la transaccion.

**Vivero es responsable de:**

- seleccionar el vivero operativo,
- crear `LOTE_VIVERO`,
- crear `EVENTO_LOTE_VIVERO` tipo `INICIO`,
- guardar snapshots heredados,
- vincular evidencia propia,
- no crear saldo vivo en `INICIO`.

**El contrato es responsable de:**

- exigir atomicidad,
- exigir alineacion de cantidad y unidad,
- definir errores de negocio de la frontera.

## 12. Estado de implementacion

Contrato definido para el MVP.

La documentacion de Vivero Core referencia este contrato como fuente canonica de la operacion de entrada desde Recoleccion. El estado real de implementacion debe confirmarse en [`../ESTADO.md`](../ESTADO.md) cuando se registren piezas aplicadas en backend/BD/frontend.
