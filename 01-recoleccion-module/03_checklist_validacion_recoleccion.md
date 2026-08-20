# Checklist de Validacion - Modulo 1: Recoleccion

## 1. Creacion de BORRADOR

- [ ] Permite crear una recoleccion en estado `BORRADOR`.
- [ ] Exige fecha de recoleccion.
- [ ] Rechaza fecha futura.
- [ ] Rechaza fecha retroactiva mayor a 45 dias.
- [ ] Exige tipo de material: `SEMILLA` o `ESQUEJE`.
- [ ] Exige especie desde catalogo.
- [ ] Exige metodo de recoleccion desde catalogo.
- [ ] Exige cantidad inicial mayor a 0.
- [ ] Exige recolector.
- [ ] Exige vivero de almacenamiento.
- [ ] Exige latitud valida.
- [ ] Exige longitud valida.
- [ ] Exige comunidad/localidad/zona valida por catalogo o valor controlado permitido.
- [ ] Exige minimo 1 foto de Lugar.
- [ ] Exige minimo 1 foto de Total recolectado.
- [ ] No permite guardar borrador sin evidencia minima.

## 2. Unidades y cantidades

- [ ] Para `SEMILLA`, permite persistir solo `G` o `UNIDAD`.
- [ ] Para `SEMILLA`, no persiste `kg`.
- [ ] Para `ESQUEJE`, permite solo `UNIDAD`.
- [ ] Para `ESQUEJE`, exige entero estricto.
- [ ] Para `ESQUEJE`, rechaza decimales.
- [ ] No mezcla `G` y `GR`.

## 3. Edicion por estado

- [ ] Permite editar en `BORRADOR`.
- [ ] Permite soft delete solo en `BORRADOR`.
- [ ] Bloquea edicion en `PENDIENTE_VALIDACION`.
- [ ] Permite corregir y reenviar desde `RECHAZADO`.
- [ ] Bloquea edicion directa en `VALIDADO`.

## 4. Validacion

- [ ] Permite pasar de `BORRADOR` a `PENDIENTE_VALIDACION` si cumple reglas minimas.
- [ ] Permite pasar de `RECHAZADO` a `PENDIENTE_VALIDACION` si fue corregido.
- [ ] Rechaza solicitud de validacion sin latitud valida.
- [ ] Rechaza solicitud de validacion sin longitud valida.
- [ ] Rechaza solicitud de validacion sin comunidad/localidad/zona valida.
- [ ] Registra `SOLICITUD_VALIDACION` en historial.
- [ ] Permite al `VALIDADOR` aprobar.
- [ ] Permite al `VALIDADOR` rechazar.
- [ ] Registra `VALIDACION_APROBADA` en historial.
- [ ] Registra `VALIDACION_RECHAZADA` en historial.
- [ ] Congela snapshots oficiales al aprobar.
- [ ] No recalcula snapshots despues de `VALIDADO`.

## 5. Consumo hacia Vivero

- [ ] Solo permite consumo si la recoleccion esta `VALIDADO`.
- [ ] Solo permite consumo si `estado_operativo = ABIERTO`.
- [ ] Rechaza consumo si saldo es insuficiente.
- [ ] Registra movimiento `CONSUMO_A_VIVERO`.
- [ ] Usa delta negativo.
- [ ] Mantiene unidad del movimiento igual a la unidad canonica de la recoleccion.
- [ ] La creacion del lote de vivero y el consumo son atomicos.
- [ ] Si falla el lote de vivero, no descuenta saldo.
- [ ] Si falla el descuento, no crea lote de vivero.

## 6. Desecho

- [x] Permite registrar `DESECHO` desde una recoleccion `VALIDADO` y `ABIERTO`.
- [x] Permite registrar descartes parciales repetidos.
- [x] Permite descartar hasta el saldo disponible, sin excederlo.
- [x] Usa delta negativo.
- [x] Conserva la unidad canonica de la recoleccion.
- [x] Registra automaticamente el motivo tecnico `DESECHO_OTRO`.
- [x] No exige fotos, evidencias ni motivo capturado por el usuario.
- [x] Rechaza saldo negativo.
- [x] Si saldo llega a 0, cambia estado operativo a `CERRADO`.
- [x] Permite la accion al creador de la recoleccion o a `ADMIN`.
- [x] Rechaza la accion para `BORRADOR`, `PENDIENTE_VALIDACION`, `RECHAZADO` y `CERRADO`.

## 7. Historial y movimientos

- [ ] `RECOLECCION_HISTORIAL` registra ciclo de vida del registro.
- [ ] `RECOLECCION_MOVIMIENTO` registra solo operaciones que afectan saldo.
- [ ] No usa `RECOLECCION_MOVIMIENTO` como historial general de edicion.
- [ ] El historial no se borra.
- [ ] Los movimientos no se editan ni se borran.

## 8. Roles

- [ ] `GENERAL` puede crear y editar borradores.
- [ ] `GENERAL` puede solicitar validacion.
- [ ] `VALIDADOR` puede aprobar o rechazar.
- [ ] `ADMIN` administra catalogos y permisos segun configuracion del sistema.
- [ ] `VOLUNTARIO` no tiene permisos criticos por defecto.
- [ ] La consulta de historial se resuelve con permisos asignables a roles existentes, no con un rol separado.

## 9. Fuera del MVP

- [ ] `CORRECCION` no esta habilitado como accion del MVP.
- [ ] `CORRECCION` no aparece como flujo operativo activo.
- [ ] `CORRECCION` no habilita edicion de registros validados.
- [ ] El MVP documenta como movimientos activos solo `CONSUMO_A_VIVERO` y `DESECHO`.
