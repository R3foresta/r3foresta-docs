# Contrato de integracion - Vivero -> Plantacion

## 1. Proposito

Este contrato responde:

> Como Plantacion reserva, consume o devuelve saldo vivo de Vivero?

El contrato define la frontera entre Modulo 2 y Modulo 3. No convierte a Vivero Core en Plantacion ni duplica las reglas internas de Plantacion.

Requerimientos movidos desde Vivero Core:

- `RF-VIV-11` - Asignacion de lote a subcampania.
- `RF-VIV-12` - Devolucion de saldo asignado.
- `RF-VIV-13` - Saldos derivados con asignaciones.
- `RF-VIV-14` - Politica de urgencia de mermas sobre asignaciones.

Reglas movidas desde Vivero Core y conservadas con ID original:

- `RN-VIV-47` a `RN-VIV-60`.

## 2. Modulos involucrados

- **Vivero (M2):** mantiene `LOTE_VIVERO`, saldo vivo real y eventos `EVENTO_LOTE_VIVERO`.
- **Plantacion (M3):** gestiona `CAMPANIA`, `SUBCAMPANIA`, registros de plantacion, reposiciones, devoluciones y consumo de asignaciones.
- **General:** aporta usuarios, territorios y evidencias transversales.

## 3. Entidades involucradas

- `LOTE_VIVERO`
- `EVENTO_LOTE_VIVERO`
- `ASIGNACION_VIVERO_SUBCAMPANIA`
- `SUBCAMPANIA`
- `CAMPANIA`
- `REGISTRO_PLANTACION`
- `EVENTO_PLANTACION`
- `EVIDENCIAS_TRAZABILIDAD`

## 4. Conceptos base

- **Saldo vivo real:** plantas fisicamente vivas en vivero (`LOTE_VIVERO.saldo_vivo_actual`).
- **Asignacion:** reserva logica de saldo vivo para una subcampania. No mueve plantas fisicamente.
- **Devolucion:** liberacion total o parcial de una reserva logica.
- **Despacho automatico:** salida real emitida por el handler de M3 al registrar `PLANTACION_INICIAL` o `REPOSICION`.
- **Despacho manual:** salida real emitida desde Vivero hacia un destino distinto de `PLANTACION_CAMPANIA`.
- **Proposito de asignacion:** `PLANTACION_INICIAL` o `REPOSICION`.

## 5. Los tres saldos del lote

### RF-VIV-13 - Saldos derivados del lote con asignaciones activas

El contrato expone tres saldos:

- `saldo_vivo_actual`: persistido en `LOTE_VIVERO`.
- `saldo_asignado_total`: derivado de asignaciones activas.
- `saldo_vivo_disponible_asignacion`: derivado, libre para nuevas asignaciones o despachos manuales.

Identidad fundamental:

```text
saldo_vivo_actual
= saldo_vivo_disponible_asignacion + saldo_asignado_total
```

Saldo por asignacion:

```text
saldo_asignado_disponible
= cantidad_asignada
- cantidad_consumida
- cantidad_devuelta
- cantidad_mermada
```

`cantidad_asignada` es inmutable. Si esta identidad se rompe, hay un bug critico.

## 6. Operaciones del contrato

### 6.1 Asignacion

### RF-VIV-11 - Asignacion de lote a subcampania

La asignacion reserva parte del saldo vivo de un lote para una subcampania de Plantacion.

Datos minimos:

- `subcampania_id`
- `lote_vivero_id`
- `proposito` (`PLANTACION_INICIAL | REPOSICION`)
- `cantidad_asignada` en `UNIDAD`, entero positivo
- `usuario_asignacion_id`
- `fecha_asignacion`

Validaciones:

- `cantidad_asignada > 0`.
- `cantidad_asignada <= saldo_vivo_disponible_asignacion`.
- El lote debe estar `ACTIVO`.
- `PLANTACION_INICIAL` solo se acepta si la subcampania esta `ACTIVA`.
- `REPOSICION` se acepta en subcampania `ACTIVA`, `COMPLETADA` o `FINALIZADA_PARCIAL`.
- La asignacion tiene proposito tipado y no puede consumirse para otro proposito.

Efectos:

- Crea una fila en `ASIGNACION_VIVERO_SUBCAMPANIA`.
- No modifica `LOTE_VIVERO.saldo_vivo_actual`.
- No genera evento en `EVENTO_LOTE_VIVERO`.
- Disminuye de forma derivada `saldo_vivo_disponible_asignacion`.

### 6.2 Devolucion

### RF-VIV-12 - Devolucion de saldo asignado al lote

La devolucion libera saldo reservado que no se consumira.

Datos minimos:

- `asignacion_id`
- `cantidad_devuelta > 0`
- `motivo_devolucion`
- `usuario_devolucion_id`
- `fecha_devolucion`

Validaciones:

- `cantidad_devuelta <= saldo_asignado_disponible`.
- La asignacion no puede estar `DEVUELTA`.
- `cantidad_asignada` no se modifica.

Efectos:

- Aumenta `ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_devuelta`.
- Recalcula de forma derivada `saldo_asignado_disponible`.
- Aumenta de forma derivada `saldo_vivo_disponible_asignacion`.
- No modifica `LOTE_VIVERO.saldo_vivo_actual`.
- No genera evento en `EVENTO_LOTE_VIVERO`.
- En M3 se registra `DEVOLUCION_A_VIVERO` en `EVENTO_PLANTACION`.

### 6.3 Despacho automatico desde Plantacion

El despacho automatico es una salida real desde Vivero disparada por M3.

Datos del evento `DESPACHO`:

```text
tipo_evento = DESPACHO
origen_despacho = AUTOMATICO_PLANTACION
destino_tipo = PLANTACION_CAMPANIA
subcampania_id = <id>
campania_id = <id>
registro_plantacion_id = <id>
comunidad_destino_id = subcampania.zona_id
unidad_medida_evento = UNIDAD
cantidad_afectada = <cantidad del lote consumida>
responsable_id = registro_plantacion.responsable_id
fecha_evento = registro_plantacion.fecha_plantacion
```

Reglas:

- Solo puede crearlo el handler de M3.
- No se acepta crear directamente por API de M2.
- Debe validar contra `saldo_asignado_disponible`.
- Aumenta `cantidad_consumida` de la asignacion correspondiente.
- Genera evento `DESPACHO` en M2.
- Baja `LOTE_VIVERO.saldo_vivo_actual`.
- Requiere evidencia propia asociada al evento de Vivero.

### 6.4 Despacho manual desde Vivero

El despacho manual es una salida real registrada por Vivero hacia un destino distinto de una subcampania de Plantacion.

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
- No puede tocar saldo reservado.
- Valida contra `saldo_vivo_disponible_asignacion`.
- Genera evento `DESPACHO` en M2.
- Baja `LOTE_VIVERO.saldo_vivo_actual`.
- Requiere evidencia propia asociada al evento de Vivero.

## 7. Invariantes

### RN-VIV-47 - Asignacion de lote a subcampania es reserva logica

Asignar saldo de un lote a una subcampania de Plantacion es una reserva logica: queda registrada en `ASIGNACION_VIVERO_SUBCAMPANIA` pero no genera evento en `EVENTO_LOTE_VIVERO` y no modifica `LOTE_VIVERO.saldo_vivo_actual`. Los arboles siguen fisicamente en el vivero.

### RN-VIV-48 - Devolucion de saldo asignado al vivero no genera evento en M2

Cuando el Modulo 3 procesa una `DEVOLUCION_A_VIVERO`, el Modulo 2 no genera evento alguno. Los arboles nunca salieron fisicamente. Solo cambia `cantidad_devuelta` en la asignacion y, por derivacion, `saldo_asignado_disponible` y `saldo_vivo_disponible_asignacion` del lote.

### RN-VIV-49 - `cantidad_asignada` es inmutable

`ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_asignada` representa la reserva original y no debe modificarse despues de creada. Los consumos, devoluciones y afectaciones por merma se registran en campos separados (`cantidad_consumida`, `cantidad_devuelta`, `cantidad_mermada`).

Modificar `cantidad_asignada` para compensar una merma o devolucion borra historia y dificulta auditoria.

### RN-VIV-52 - Despacho automatico heredado desde Plantacion

Cada `PLANTACION_INICIAL` y cada `REPOSICION` registrada en Modulo 3 genera atomicamente uno o mas eventos `DESPACHO` en `EVENTO_LOTE_VIVERO`, uno por cada lote afectado, con:

- `origen_despacho = AUTOMATICO_PLANTACION`,
- `destino_tipo = PLANTACION_CAMPANIA`,
- `subcampania_id`, `campania_id`, `registro_plantacion_id` poblados,
- `comunidad_destino_id` heredada de la subcampania,
- `unidad_medida_evento = UNIDAD`.

El despacho automatico nunca se crea por API directa de Vivero; solo lo emite el handler de Modulo 3.

### RN-VIV-53 - Invariante de conservacion por registro de plantacion

Para todo `REGISTRO_PLANTACION` se cumple:

```text
SUM(DESPACHO.cantidad_afectada
    where registro_plantacion_id = X
      and origen_despacho = AUTOMATICO_PLANTACION)
= REGISTRO_PLANTACION.cantidad_total_plantada
```

Si esa identidad no se cumple, el registro y sus despachos estan inconsistentes.

### RN-VIV-54 - Evidencia propia obligatoria en despacho automatico

Un `DESPACHO` con `origen_despacho = AUTOMATICO_PLANTACION` requiere evidencia propia en `EVIDENCIAS_TRAZABILIDAD`, vinculada directamente al `EVENTO_LOTE_VIVERO.id`.

La evidencia del `REGISTRO_PLANTACION` asociado puede mostrarse como contexto cruzado, pero no reemplaza la evidencia del despacho. La transaccion atomica no debe llegar al commit si el evento `DESPACHO` automatico no trae al menos una foto valida del material despachado.

### RN-VIV-55 - Despacho manual no puede tener destino `PLANTACION_CAMPANIA`

Un `DESPACHO` con `origen_despacho = MANUAL` no puede tener `destino_tipo = PLANTACION_CAMPANIA`, ni traer `subcampania_id`, `campania_id` ni `registro_plantacion_id` poblados.

Cualquier salida hacia subcampanias tiene que originarse en un registro de plantacion de M3.

### RN-VIV-56 - Despacho manual valida contra saldo libre, no saldo vivo

Un `DESPACHO` con `origen_despacho = MANUAL` valida su cantidad contra `saldo_vivo_disponible_asignacion` del lote, no contra `saldo_vivo_actual`.

Esto significa que el operario de vivero no puede tocar stock reservado por subcampanias activas.

### RN-VIV-57 - Saldos derivados del lote

El contrato debe exponer tres saldos para cada lote:

- `saldo_vivo_actual` persistido en `LOTE_VIVERO`,
- `saldo_asignado_total` derivado de asignaciones activas,
- `saldo_vivo_disponible_asignacion` derivado.

Identidad invariante:

```text
saldo_vivo_actual = saldo_vivo_disponible_asignacion + saldo_asignado_total
```

### RN-VIV-58 - Asignacion con proposito tipado

Toda asignacion tiene un `proposito_asignacion` obligatorio:

- `PLANTACION_INICIAL`: solo puede consumirse en plantaciones iniciales.
- `REPOSICION`: solo puede consumirse en reposiciones.

Una asignacion con un proposito no puede consumirse para el otro.

### RN-VIV-59 - `AFECTADA_POR_MERMA` no es estado del enum

El enum `estado_asignacion_vivero` contiene unicamente `ACTIVA | AGOTADA | DEVUELTA`. El hecho de que una asignacion tenga `cantidad_mermada > 0` se muestra como badge visual en la UI, no como estado logico.

### RN-VIV-60 - Reposicion no exige misma especie que el grupo origen

Una reposicion puede usar stock de cualquier especie disponible en una asignacion con proposito `REPOSICION`. No se exige que coincida con la especie del grupo plantado origen. El sistema registra la especie real en el evento `REPOSICION` y el grupo plantado puede quedar con composicion mixta. Esta politica es revisable post-MVP si la certificacion de carbono exige homogeneidad por grupo.

## 8. Politica de mermas sobre asignaciones

### RF-VIV-14 - Politica de urgencia de mermas sobre asignaciones activas

### RN-VIV-50 - Politica de mermas sobre asignaciones por urgencia de subcampania

Cuando una `MERMA` excede el saldo no asignado del lote, el excedente se distribuye sobre las asignaciones activas ordenando por:

```text
subcampania.fecha_estimada_inicio DESC NULLS FIRST,
asignacion.id DESC
```

La subcampania con `fecha_estimada_inicio` mas lejana absorbe primero porque tiene mayor margen operativo. La subcampania mas proxima queda protegida porque es mas urgente. Las subcampanias sin fecha (`NULL`) se tratan como no urgentes y absorben antes que cualquier fecha concreta.

Formula:

```text
saldo_no_asignado = saldo_vivo_actual - saldo_asignado_total

si cantidad_merma <= saldo_no_asignado:
    no se tocan asignaciones

si cantidad_merma > saldo_no_asignado:
    excedente = cantidad_merma - saldo_no_asignado
    distribuir excedente sobre asignaciones activas por urgencia
    cada asignacion afectada aumenta cantidad_mermada
```

Reglas:

- `cantidad_asignada` nunca se modifica.
- La merma no puede dejar `saldo_asignado_disponible < 0`.
- La merma no puede dejar `saldo_vivo_actual < 0`.
- El evento `MERMA` en M2 puede guardar `metadata.afectacion_asignaciones`.

### RN-VIV-51 - Notificacion al coordinador por merma sobre asignacion

Si una merma del vivero afecta la asignacion de una subcampania, el sistema debe notificar al coordinador de esa subcampania con los datos minimos:

- subcampania,
- lote,
- cantidad mermada sobre su asignacion,
- nuevo saldo asignado disponible,
- fecha,
- causa,
- responsable de la merma.

El canal exacto se define operativamente.

## 9. Evidencia requerida

Todo despacho, manual o automatico, requiere evidencia propia asociada al evento de Vivero.

Reglas:

- La evidencia vive en `EVIDENCIAS_TRAZABILIDAD`.
- La evidencia se vincula a `EVENTO_LOTE_VIVERO.id`.
- La evidencia de `REGISTRO_PLANTACION` puede mostrarse como contexto, pero no reemplaza la evidencia propia del despacho automatico.
- La asignacion y la devolucion no generan evento en M2 y no requieren evidencia de Vivero.

## 10. Concurrencia y transacciones

La transaccion de despacho automatico debe incluir:

- insertar `REGISTRO_PLANTACION`,
- actualizar `ASIGNACION_VIVERO_SUBCAMPANIA.cantidad_consumida`,
- insertar uno o mas `EVENTO_LOTE_VIVERO` tipo `DESPACHO`,
- vincular evidencia propia de cada despacho,
- recalcular o proyectar saldos correspondientes.

Si una parte falla, falla toda la operacion.

El handler debe bloquear las filas involucradas con estrategia equivalente a `SELECT ... FOR UPDATE` sobre lote/asignaciones afectadas para evitar carreras entre:

- dos plantaciones simultaneas sobre la misma asignacion,
- devolucion y plantacion simultaneas,
- merma y plantacion simultaneas,
- despacho manual y nuevas asignaciones.

## 11. Responsabilidad de cada modulo

**Vivero es responsable de:**

- mantener `LOTE_VIVERO.saldo_vivo_actual`,
- registrar eventos `MERMA` y `DESPACHO`,
- exigir evidencia propia del despacho,
- impedir que un despacho manual use `PLANTACION_CAMPANIA`,
- impedir que un despacho manual toque saldo reservado.

**Plantacion es responsable de:**

- crear y consumir asignaciones segun subcampania y proposito,
- registrar `REGISTRO_PLANTACION`,
- registrar `EVENTO_PLANTACION` para devoluciones y eventos propios de M3,
- disparar el despacho automatico mediante handler de M3,
- validar que el consumo respete `saldo_asignado_disponible`.

**El contrato es responsable de:**

- definir saldos derivados,
- definir atomicidad,
- definir invariantes entre M2 y M3,
- definir errores de negocio de la frontera.

## 12. Estado de implementacion

Contrato definido para el MVP.

La implementacion puede estar parcial o diferida hasta Modulo 3. No asumir que asignaciones, devoluciones, despacho automatico, mermas sobre asignaciones o saldos derivados estan activos en produccion sin confirmarlo en [`../ESTADO.md`](../ESTADO.md).

## 13. TODO / Decision pendiente

### Coordinador

Aclarar si `COORDINADOR` sera:

- rol global en `rol_usuario`, o
- responsabilidad funcional dentro de una subcampania.

Recomendacion documental actual: `COORDINADOR` no deberia ser rol global si ya existen `ADMIN` y `GENERAL`. Debe modelarse como usuario responsable/coordinador asociado a `SUBCAMPANIA`.
