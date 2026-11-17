# Contrato de integracion - Recoleccion -> Vivero

Actualización de requisitos aprobada el 16 de noviembre de 2026. La política T2 elegida el 5 de noviembre conserva acceso vigente al vivero y consumo ordinario en el mismo establecimiento de almacenamiento M1. La recepción única100 confirma el hecho físico y la validación juntos. Almacenamiento y destino M2 siguen siendo campos distintos, con compatibilidad explícita de destino diferente para ADMIN. [Acceso M2](../../Backend-r3foresta/docs/t2-acceso-viveros.md) y [recepción única](../../Backend-r3foresta/docs/t4-recepcion-semillas.md) precisan contratos, versiones y límites de entorno.

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
- `RECOLECCION_RECEPCION`
- `RECOLECCION_MOVIMIENTO`
- `LOTE_VIVERO`
- `EVENTO_LOTE_VIVERO`
- `EVIDENCIAS_TRAZABILIDAD`

## 4. Precondiciones del lote origen

### Recepción conforme y autoridad

El recolector envía la ficha a `PENDIENTE_VALIDACION`. Otra persona confirma recibir y validar la revisión cargada o la rechaza con motivo. La confirmación conforme produce `VALIDADO` y un hecho de recepción inmutable con fecha física y responsable. El rechazo conserva la versión revisada y permite corregir y reenviar la misma ficha.

La bandeja, ficha, fotos y decisiones de recepción exigen cuenta activa ADMIN o VALIDADOR con asignación vigente al vivero de almacenamiento. La persona receptora debe ser distinta de quien recolectó, incluido ADMIN. GENERAL con acceso M2 conserva las operaciones autorizadas sobre material recibido.

La persona receptora confirma cantidad y unidad conformes con la versión cargada. G/KG se comparan normalizados a G con la precisión canónica admitida, y UNIDAD exige entero. Confirmar requiere evidencia propia de recepción y revisión vigente. Una diferencia se resuelve mediante rechazo motivado y corrección de la ficha por su responsable.

Recepción, revisión, snapshots, historial, evidencia vinculada y resultado del comando se confirman juntos. Repetir la misma clave propia con la misma intención devuelve su resultado. La recuperación exige cuenta activa aun después de perder rol o vivero. Ante un resultado inconcluso se conservan clave e intención y se consulta el mismo comando. Storage y anclaje externo conservan su frontera fuera de SQL.

### RN-VIV-04 - Elegibilidad del origen para iniciar vivero

Solo se puede iniciar un lote de vivero desde una recoleccion que cumpla todas estas condiciones:

- `estado_registro = VALIDADO`,
- recepción conforme registrada,
- saldo suficiente para la cantidad a consumir,
- habilitada operativamente para consumo,
- snapshot oficial congelado,
- identidad de planta disponible,
- ubicacion de origen valida.

La fuente oficial para validar identidad y snapshots es la `RECOLECCION` validada, no una lectura viva de `PLANTA`.

ADMIN activo puede iniciar con alcance global. GENERAL/VALIDADOR activos requieren asignación vigente al vivero operativo y el camino ordinario exige destino igual al almacenamiento M1, comprobado bajo lock del origen. El operario puede consumir material recibido de otro recolector del mismo vivero sin acceso M1. ADMIN conserva selección explícita de destino diferente. El consumo y desecho del ledger requieren recepción conforme.

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

El `vivero_id` del lote de vivero se selecciona como destino operativo. La selección respeta la igualdad de custodia del camino ordinario o la compatibilidad explícita de ADMIN indicada en RN-VIV-04.

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
- `fecha_recoleccion <= fecha_recepcion <= hoy`, según el día operativo en `America/La_Paz`. INICIO debe ser igual o posterior a la recepción física.
- No se permiten fechas futuras.
- La ventana retroactiva maxima sigue la regla operativa de Vivero core.
- La fecha de persistencia se muestra con la precisión disponible. Los campos `created_at` legados de Vivero son `DATE`; la recepción conserva `registrado_en` como sello temporal real.

La ventana de captura de Recolección se aplica al crear o cambiar explícitamente su fecha. Una captura válida puede corregirse, reenviarse y recibirse al envejecer conservando esa fecha. La recepción conforme se mantiene como antecedente del material disponible.

## 10. Errores de negocio esperados

La operacion debe fallar si:

- la recoleccion no esta `VALIDADO`,
- falta recepción conforme, autoridad vigente o igualdad de custodia exigida al operario,
- la recoleccion no esta habilitada para consumo,
- el saldo disponible es insuficiente,
- falta snapshot oficial congelado,
- falta identidad de planta,
- falta ubicacion valida de origen,
- la cantidad a consumir no es positiva,
- la unidad no coincide con la unidad canonica del origen,
- alguna de las cuatro invariantes de cantidad/unidad no se cumple,
- falta evidencia obligatoria del evento `INICIO`,
- INICIO precede a la recepción física,
- la persistencia parcial de cualquiera de las entidades falla.

## 11. Responsabilidad de cada modulo

**Recoleccion es responsable de:**

- conservar el hecho de recepción conforme, validación y revisión del lote origen,
- conservar el snapshot oficial de identidad y origen,
- exponer saldo suficiente,
- registrar el movimiento `CONSUMO_A_VIVERO` con delta negativo dentro de la transaccion.

**Vivero es responsable de:**

- seleccionar el vivero operativo dentro del ámbito y custodia autorizados,
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

La actualización incorpora recepción única100 y acceso por vivero094/095 como comportamiento requerido. Los cortes anteriores de recepción096 y conciliación097–099 conservan su evidencia fechada en las fuentes backend. La [guía de recepción vigente](../../Backend-r3foresta/docs/t4-recepcion-semillas.md) declara el corte cliente-servidor y los límites de aplicación y cotejo.

La documentacion de Vivero Core referencia este contrato como fuente canonica de la operacion de entrada desde Recoleccion. El estado real de implementacion debe confirmarse en [`../ESTADO.md`](../ESTADO.md) cuando se registren piezas aplicadas en backend/BD/frontend.
