# Contrato de integracion - Vivero -> Plantacion

## 1. Proposito

Este contrato responde:

> Como Plantacion recibe, consume y devuelve plantas fisicamente entregadas desde Vivero?

El contrato define la frontera entre Modulo 2 y Modulo 3. No convierte a Vivero Core en Plantacion ni duplica las reglas internas de Plantacion.

Cambio estrategico vigente:

- `ASIGNACION_VIVERO_SUBCAMPANIA` deja de significar "reserva logica".
- `ASIGNACION_VIVERO_SUBCAMPANIA` pasa a significar **entrega fisica de plantas desde Vivero a una subcampania**.
- Esas plantas son **stock de consumo de la subcampania**.
- El registro de plantacion consume ese stock asignado; ya no genera un despacho automatico hacia Vivero.
- `AUTOMATICO_PLANTACION` no debe usarse para el nuevo flujo de plantacion. Si existe en BD por migraciones anteriores, queda como legado a migrar/deprecar.

Requerimientos cubiertos:

- `RF-VIV-11` - Asignacion fisica de lote a subcampania.
- `RF-VIV-12` - Devolucion fisica de saldo asignado al vivero.
- `RF-VIV-13` - Saldos derivados de stock de vivero y stock de subcampania.
- `RF-VIV-14` - Mermas: separacion entre merma en vivero y merma de stock ya entregado.

Reglas movidas desde Vivero Core y conservadas con ID original cuando aplica:

- `RN-VIV-47` a `RN-VIV-61`.

## 2. Modulos involucrados

- **Vivero (M2):** mantiene `LOTE_VIVERO`, saldo vivo fisico que permanece en vivero y eventos `EVENTO_LOTE_VIVERO`.
- **Plantacion (M3):** gestiona `CAMPANIA`, `SUBCAMPANIA`, stock asignado a subcampania, registros de plantacion, reposiciones, devoluciones y consumo de asignaciones.
- **General:** aporta usuarios, territorios y evidencias transversales.

## 3. Entidades involucradas

- `LOTE_VIVERO`
- `EVENTO_LOTE_VIVERO`
- `ASIGNACION_VIVERO_SUBCAMPANIA`
- `SUBCAMPANIA`
- `CAMPANIA`
- `REGISTRO_PLANTACION`
- `REGISTRO_PLANTACION_DETALLE`
- `EVENTO_PLANTACION`
- `EVIDENCIAS_TRAZABILIDAD`

## 4. Conceptos base

- **Saldo vivo en vivero:** plantas fisicamente vivas que aun permanecen en el vivero (`LOTE_VIVERO.saldo_vivo_actual`).
- **Asignacion fisica:** entrega real de una cantidad de plantas de un lote de vivero a una subcampania. Crea stock disponible para que esa subcampania lo consuma al registrar plantaciones o reposiciones.
- **Stock de consumo de subcampania:** saldo disponible de una asignacion (`saldo_asignado_disponible`). Es el limite duro contra el que se valida cualquier plantacion o reposicion.
- **Despacho por asignacion a subcampania:** salida real desde Vivero que ocurre al crear la asignacion fisica. Debe quedar registrada en `EVENTO_LOTE_VIVERO` con evidencia propia.
- **Plantacion:** consumo de stock ya asignado fisicamente a la subcampania. No baja directamente `LOTE_VIVERO.saldo_vivo_actual`; solo aumenta `ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_consumida`.
- **Devolucion fisica:** retorno al vivero de plantas ya asignadas a una subcampania y aun no consumidas. En MVP se registra cantidad y motivo; la evidencia fotografica queda post-MVP.
- **Proposito de asignacion:** `PLANTACION_INICIAL` o `REPOSICION`.

## 5. Saldos

### 5.1 Saldo del lote de vivero

`LOTE_VIVERO.saldo_vivo_actual` representa un saldo fisico en vivero:

```text
saldo_vivo_actual_lote
= plantas vivas que siguen fisicamente en vivero
```

Por tanto, cuando se asignan fisicamente plantas a una subcampania, el saldo del lote baja en ese momento.

Validacion para una nueva asignacion fisica:

```text
cantidad_asignada <= LOTE_VIVERO.saldo_vivo_actual
```

Ya no se resta `saldo_asignado_total` al validar una nueva asignacion, porque las asignaciones fisicas anteriores ya descontaron el saldo del lote.

### 5.2 Saldo de la asignacion/subcampania

La asignacion mantiene el stock entregado a la subcampania:

```text
saldo_asignado_disponible
= cantidad_asignada
- cantidad_consumida
- cantidad_devuelta
- cantidad_mermada
```

Interpretacion de columnas:

- `cantidad_asignada`: cantidad fisicamente entregada a la subcampania. Es inmutable.
- `cantidad_consumida`: cantidad plantada o repuesta desde esa asignacion.
- `cantidad_devuelta`: cantidad fisicamente devuelta al vivero.
- `cantidad_mermada`: cantidad perdida del stock de campo antes de ser plantada. En MVP puede quedar sin flujo operativo si no se implementa merma de campo.
- `saldo_asignado_disponible`: stock disponible para consumir en una plantacion o reposicion.

Si esta identidad se rompe, hay un bug critico.

## 6. Operaciones del contrato

### 6.1 Asignacion fisica a subcampania

### RF-VIV-11 - Asignacion de lote a subcampania

La asignacion representa que una cantidad concreta de plantas sale del vivero y queda fisicamente disponible para una subcampania.

Datos minimos:

- `campania_id` derivado desde la subcampania o seleccionado como contexto de UI.
- `subcampania_id`
- `lote_vivero_id`
- `proposito` (`PLANTACION_INICIAL | REPOSICION`)
- `cantidad_asignada` en `UNIDAD`, entero positivo
- `usuario_asignacion_id`
- `fecha_asignacion`
- evidencia fotografica del despacho/entrega

Validaciones:

- `cantidad_asignada > 0`.
- `cantidad_asignada <= LOTE_VIVERO.saldo_vivo_actual`.
- El lote debe estar `ACTIVO`.
- El lote debe tener un evento `EMBOLSADO` registrado. Sin esto solo existe material en proceso, no plantas vivas para entregar.
- `saldo_vivo_actual > 0` y `saldo_vivo_actual` no es `NULL`.
- La subcampania debe existir y no estar eliminada.
- `PLANTACION_INICIAL` solo se acepta si la subcampania esta `ACTIVA`.
- `REPOSICION` se acepta en subcampania `ACTIVA`, `COMPLETADA` o `FINALIZADA_PARCIAL`.
- La asignacion tiene proposito tipado y no puede consumirse para otro proposito.
- Solo `ADMIN` o `COORDINADOR` de la subcampania pueden registrar la asignacion.

Efectos atomicos:

- Crea una fila en `ASIGNACION_VIVERO_SUBCAMPANIA`.
- Registra un `EVENTO_LOTE_VIVERO` de salida fisica por asignacion.
- Baja `LOTE_VIVERO.saldo_vivo_actual` en `cantidad_asignada`.
- Vincula evidencia propia al evento de salida desde vivero.
- Registra `ASIGNACION_VIVERO` en `EVENTO_PLANTACION` para la linea de tiempo de M3.

Datos esperados del evento de salida en M2:

```text
tipo_evento = DESPACHO
origen_despacho = ASIGNACION_SUBCAMPANIA
destino_tipo = PLANTACION_CAMPANIA
subcampania_id = <id>
campania_id = <id>
registro_plantacion_id = NULL
destino_referencia = <referencia de la asignacion>
comunidad_destino_id = subcampania.zona_id
unidad_medida_evento = UNIDAD
cantidad_afectada = cantidad_asignada
responsable_id = usuario_asignacion_id
fecha_evento = fecha_asignacion
```

Nota de implementacion: `ASIGNACION_SUBCAMPANIA` es el origen de despacho que debe reemplazar el uso anterior de `AUTOMATICO_PLANTACION` para este caso. El CHECK de `EVENTO_LOTE_VIVERO` debe permitir `PLANTACION_CAMPANIA` con `registro_plantacion_id = NULL` cuando el origen sea `ASIGNACION_SUBCAMPANIA`.

### 6.2 Registro de plantacion o reposicion

La plantacion consume stock ya entregado a la subcampania. No genera despacho en Vivero.

Datos relevantes:

- `subcampania_id`
- `responsable_id`
- fecha
- GPS
- fotos de plantacion
- detalles por especie/asignacion/lote
- notas de campo

Validaciones:

- La subcampania debe estar en un estado permitido para el tipo de registro.
- Cada cantidad por especie/asignacion debe ser mayor a 0.
- La asignacion debe pertenecer a la subcampania.
- La asignacion debe estar `ACTIVA`.
- El proposito de la asignacion debe coincidir con el tipo de registro:
  - `PLANTACION_INICIAL` consume asignaciones `PLANTACION_INICIAL`.
  - `REPOSICION` consume asignaciones `REPOSICION`.
- La cantidad a plantar no puede exceder `saldo_asignado_disponible`.
- En plantacion inicial, la especie debe existir en `SUBCAMPANIA_META_ESPECIE` y no puede exceder la meta por especie.

Efectos atomicos:

- Crea `REGISTRO_PLANTACION`.
- Crea `REGISTRO_PLANTACION_DETALLE`.
- Aumenta `ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_consumida`.
- Vincula evidencia al `REGISTRO_PLANTACION`.
- Actualiza contadores de subcampania/grupo cuando aplique.
- No inserta `EVENTO_LOTE_VIVERO` tipo `DESPACHO`.
- No modifica `LOTE_VIVERO.saldo_vivo_actual`.

Invariante por registro:

```text
SUM(REGISTRO_PLANTACION_DETALLE.cantidad where registro_plantacion_id = X)
= REGISTRO_PLANTACION.cantidad_total_plantada
```

Invariante contra asignacion:

```text
SUM(REGISTRO_PLANTACION_DETALLE.cantidad where asignacion_id = A)
<= ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_asignada
   - cantidad_devuelta
   - cantidad_mermada
```

### 6.3 Devolucion fisica al vivero

### RF-VIV-12 - Devolucion de saldo asignado al lote

La devolucion fisica retorna al vivero plantas asignadas a una subcampania que no fueron consumidas.

Datos minimos MVP:

- `asignacion_id`
- `cantidad_devuelta > 0`
- `motivo_devolucion`
- `usuario_devolucion_id`
- `fecha_devolucion`
- `observaciones` opcional

Validaciones:

- `cantidad_devuelta <= saldo_asignado_disponible`.
- La asignacion no puede estar `DEVUELTA`.
- `cantidad_asignada` no se modifica.
- Solo `ADMIN` o `COORDINADOR` de la subcampania pueden devolver.

Efectos atomicos:

- Aumenta `ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_devuelta`.
- Aumenta `LOTE_VIVERO.saldo_vivo_actual` del lote origen en `cantidad_devuelta`.
- Registra `DEVOLUCION_A_VIVERO` en `EVENTO_PLANTACION`.
- Registra, cuando el esquema lo soporte, un evento de entrada fisica en `EVENTO_LOTE_VIVERO` para que el historial del lote explique el aumento de saldo.
- En MVP no exige evidencia fotografica de devolucion.

Nota de implementacion: si `EVENTO_LOTE_VIVERO` aun no tiene un tipo de evento para devolucion fisica desde plantacion, debe agregarse uno antes de implementar el ajuste de saldo de forma productiva. Nombre sugerido: `DEVOLUCION_PLANTACION`.

### 6.4 Despacho manual desde Vivero

El despacho manual sigue siendo una salida real registrada por Vivero hacia un destino distinto de una subcampania de Plantacion.

Datos minimos:

```text
tipo_evento = DESPACHO
origen_despacho = MANUAL
destino_tipo <> PLANTACION_CAMPANIA
destino_referencia = <texto libre>
subcampania_id = NULL
campania_id = NULL
registro_plantacion_id = NULL
unidad_medida_evento = UNIDAD
cantidad_afectada = <cantidad despachada>
```

Reglas:

- No puede usar `PLANTACION_CAMPANIA`.
- Valida contra `LOTE_VIVERO.saldo_vivo_actual`.
- Genera evento `DESPACHO` en M2.
- Baja `LOTE_VIVERO.saldo_vivo_actual`.
- Requiere evidencia propia asociada al evento de Vivero.

## 7. Invariantes

### RN-VIV-47 - Asignacion de lote a subcampania es entrega fisica

Asignar plantas de un lote a una subcampania de Plantacion significa entrega fisica. La asignacion crea stock de consumo para la subcampania y descuenta el saldo vivo del lote en vivero.

No se debe modelar como reserva logica en el MVP vigente.

### RN-VIV-48 - Devolucion de saldo asignado al vivero es fisica

Cuando Plantacion procesa una `DEVOLUCION_A_VIVERO`, las plantas vuelven fisicamente al vivero. La operacion aumenta `cantidad_devuelta` en la asignacion y aumenta `LOTE_VIVERO.saldo_vivo_actual` del lote origen.

En MVP la devolucion no exige fotos. La evidencia de devolucion queda post-MVP.

### RN-VIV-49 - `cantidad_asignada` es inmutable

`ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_asignada` representa la cantidad entregada originalmente a la subcampania y no debe modificarse despues de creada. Los consumos, devoluciones y mermas viven en columnas separadas (`cantidad_consumida`, `cantidad_devuelta`, `cantidad_mermada`).

Modificar `cantidad_asignada` para compensar una merma, devolucion o error borra historia y dificulta auditoria.

### RN-VIV-52 - Plantacion no genera despacho automatico en M2

Cada `PLANTACION_INICIAL` y cada `REPOSICION` consume stock ya asignado a la subcampania. Por tanto, no genera `EVENTO_LOTE_VIVERO` tipo `DESPACHO` ni usa `origen_despacho = AUTOMATICO_PLANTACION`.

El evento de salida desde vivero ya ocurrio al crear la asignacion fisica (`ASIGNACION_SUBCAMPANIA`).

### RN-VIV-53 - Conservacion por registro de plantacion

Para todo `REGISTRO_PLANTACION` se cumple:

```text
SUM(REGISTRO_PLANTACION_DETALLE.cantidad
    where registro_plantacion_id = X)
= REGISTRO_PLANTACION.cantidad_total_plantada
```

Si esa identidad no se cumple, el registro y sus detalles estan inconsistentes.

### RN-VIV-54 - Evidencia obligatoria en la asignacion/despacho a subcampania

La salida fisica desde vivero hacia una subcampania requiere evidencia propia asociada al evento de Vivero que respalda la asignacion fisica.

La evidencia de la plantacion posterior no reemplaza la evidencia de entrega/asignacion. Son dos hechos distintos:

- entrega fisica de plantas a la subcampania,
- plantacion efectiva en campo.

### RN-VIV-55 - `AUTOMATICO_PLANTACION` no se usa en el flujo vigente

El origen `AUTOMATICO_PLANTACION` queda obsoleto para el nuevo flujo. No debe emitirse al guardar `REGISTRO_PLANTACION`.

Para salidas hacia subcampania se debe usar un origen especifico de asignacion fisica, sugerido: `ASIGNACION_SUBCAMPANIA`.

### RN-VIV-56 - Despacho manual valida contra saldo fisico en vivero

Como las asignaciones fisicas ya descuentan el saldo del lote, un despacho manual valida contra `LOTE_VIVERO.saldo_vivo_actual`. No existe stock "reservado pero aun dentro del vivero" que deba restarse.

### RN-VIV-57 - Saldos derivados

El contrato expone dos familias de saldo:

- Saldo del lote en vivero: `LOTE_VIVERO.saldo_vivo_actual`.
- Saldo de stock asignado a subcampania: `ASIGNACION_VIVERO_SUBCAMPANIA.saldo_asignado_disponible`.

La identidad antigua:

```text
saldo_vivo_actual = saldo_vivo_disponible_asignacion + saldo_asignado_total
```

ya no aplica al flujo vigente porque la asignacion es fisica y descuenta el saldo del lote.

### RN-VIV-58 - Asignacion con proposito tipado

Toda asignacion tiene un `proposito_asignacion` obligatorio:

- `PLANTACION_INICIAL`: solo puede consumirse en plantaciones iniciales.
- `REPOSICION`: solo puede consumirse en reposiciones.

Una asignacion con un proposito no puede consumirse para el otro.

### RN-VIV-59 - `AFECTADA_POR_MERMA` no es estado del enum

El enum `estado_asignacion_vivero` contiene unicamente `ACTIVA | AGOTADA | DEVUELTA`. El hecho de que una asignacion tenga `cantidad_mermada > 0` se muestra como badge visual en la UI, no como estado logico.

### RN-VIV-60 - Reposicion no exige misma especie que el grupo origen

Una reposicion puede usar stock de cualquier especie disponible en una asignacion con proposito `REPOSICION`. No se exige que coincida con la especie del grupo plantado origen. El sistema registra la especie real en el evento `REPOSICION` y el grupo plantado puede quedar con composicion mixta. Esta politica es revisable post-MVP si la certificacion de carbono exige homogeneidad por grupo.

### RN-VIV-61 - Asignacion requiere lote con EMBOLSADO y saldo vivo positivo

Una asignacion solo puede crearse si el lote cumple todas estas condiciones:

- Lote esta `ACTIVO`.
- Existe evento `EMBOLSADO` registrado en el lote.
- `saldo_vivo_actual > 0`.
- `saldo_vivo_actual` no es `NULL`.

Esta regla previene entregar material no viable (semillas, material pre-embolsado, etc.) como si fueran plantines listos para plantar.

## 8. Politica de mermas

### 8.1 Merma en vivero

Una `MERMA` registrada en M2 solo afecta plantas que siguen fisicamente en vivero. Como las asignaciones a subcampania ya descontaron `LOTE_VIVERO.saldo_vivo_actual`, una merma posterior del lote no puede reducir asignaciones ya entregadas.

### 8.2 Merma de stock asignado en campo

Si se necesita registrar perdida de plantas ya entregadas a una subcampania pero aun no plantadas, debe afectar `ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_mermada`.

En MVP este flujo puede quedar fuera de alcance. Si se implementa, debe:

- exigir cantidad > 0,
- validar `cantidad_mermada <= saldo_asignado_disponible`,
- registrar evento append-only en M3,
- no modificar `LOTE_VIVERO.saldo_vivo_actual`,
- diferenciarse de mortandad de plantas ya plantadas.

## 9. Evidencia requerida

Reglas:

- La salida fisica de vivero hacia subcampania requiere evidencia propia.
- La evidencia vive en `EVIDENCIAS_TRAZABILIDAD`.
- La evidencia de asignacion se vincula al evento de Vivero que respalda el despacho por asignacion.
- La plantacion requiere evidencia propia vinculada a `REGISTRO_PLANTACION`.
- La devolucion fisica al vivero no exige evidencia en MVP; evidencia de devolucion queda post-MVP.

## 10. Concurrencia y transacciones

La transaccion de asignacion fisica debe incluir:

- bloquear el lote de vivero,
- validar saldo vivo actual,
- insertar `ASIGNACION_VIVERO_SUBCAMPANIA`,
- insertar `EVENTO_LOTE_VIVERO` de salida hacia subcampania,
- descontar `LOTE_VIVERO.saldo_vivo_actual`,
- vincular evidencia del despacho/asignacion,
- registrar `ASIGNACION_VIVERO` en `EVENTO_PLANTACION`.

La transaccion de plantacion debe incluir:

- bloquear asignaciones afectadas,
- validar `saldo_asignado_disponible`,
- insertar `REGISTRO_PLANTACION`,
- insertar `REGISTRO_PLANTACION_DETALLE`,
- actualizar `ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_consumida`,
- vincular evidencia de plantacion,
- actualizar contadores de subcampania/grupo cuando aplique.

La transaccion de devolucion fisica debe incluir:

- bloquear la asignacion,
- bloquear el lote de vivero,
- validar `cantidad_devuelta <= saldo_asignado_disponible`,
- aumentar `cantidad_devuelta`,
- aumentar `LOTE_VIVERO.saldo_vivo_actual`,
- registrar `DEVOLUCION_A_VIVERO` en `EVENTO_PLANTACION`,
- registrar evento de entrada fisica en M2 cuando el esquema lo soporte.

Si una parte falla, falla toda la operacion.

## 11. Responsabilidad de cada modulo

**Vivero es responsable de:**

- mantener `LOTE_VIVERO.saldo_vivo_actual` como saldo fisico que permanece en vivero,
- registrar eventos de salida fisica por asignacion a subcampania,
- exigir evidencia propia para la salida hacia subcampania,
- registrar mermas solo sobre stock que sigue en vivero,
- impedir que un despacho manual use `PLANTACION_CAMPANIA`.

**Plantacion es responsable de:**

- crear y consumir asignaciones segun subcampania y proposito,
- tratar la asignacion como stock fisico disponible para la subcampania,
- registrar `REGISTRO_PLANTACION`,
- registrar `EVENTO_PLANTACION` para asignaciones, devoluciones y eventos propios de M3,
- validar que la plantacion respete `saldo_asignado_disponible`,
- no generar despachos automaticos al plantar.

**El contrato es responsable de:**

- definir saldos derivados,
- definir atomicidad,
- definir invariantes entre M2 y M3,
- definir errores de negocio de la frontera.

## 12. Estado de implementacion

Contrato actualizado para el MVP bajo el enfoque de asignacion fisica.

La implementacion puede estar parcial o diferida hasta Modulo 3. No asumir que el backend ya refleja este contrato sin confirmarlo en [`../ESTADO.md`](../ESTADO.md).

Cambios de backend esperados respecto a la implementacion anterior:

- agregar o reemplazar el origen de despacho `ASIGNACION_SUBCAMPANIA`,
- ajustar CHECKs de `EVENTO_LOTE_VIVERO` para permitir `PLANTACION_CAMPANIA` sin `registro_plantacion_id` cuando el origen sea asignacion a subcampania,
- dejar de generar `DESPACHO AUTOMATICO_PLANTACION` desde `fn_m3_registrar_plantacion`,
- hacer que la creacion de asignacion descuente `LOTE_VIVERO.saldo_vivo_actual`,
- hacer que la devolucion fisica aumente `LOTE_VIVERO.saldo_vivo_actual`,
- agregar soporte de evento M2 para devolucion fisica o documentar explicitamente el ajuste transaccional hasta que exista.

## 13. TODO / Decision pendiente

### Evento M2 para devolucion fisica

Definir el nombre definitivo del evento de entrada fisica al vivero para devoluciones desde Plantacion. Nombre sugerido: `DEVOLUCION_PLANTACION`.

### Evidencia de devolucion

En MVP la devolucion se registra solo con cantidad y motivo, sin fotos. La evidencia fotografica de devolucion queda para una fase posterior.
