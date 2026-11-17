# Checklist de Validacion - Modulo 1 - Recoleccion

Criterios funcionales actualizados al 16 de noviembre de 2026. Cada cierre requiere version, entorno y evidencia. Los criterios nuevos permanecen abiertos para su comprobacion.

## 1. Creacion de BORRADOR

- [ ] Permite crear una recoleccion en estado `BORRADOR`.
- [ ] Exige fecha de recoleccion.
- [ ] Rechaza fecha futura.
- [ ] Al crear o cambiar explicitamente la fecha, rechaza retroactividad mayor a 45 dias en America/La_Paz.
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
- [ ] Permite corregir RECHAZADO, guardar BORRADOR de la misma ficha/codigo y volver a enviar.
- [ ] Omitir o conservar fecha mantiene el dia original aunque la ficha luego supere 45 dias.
- [ ] Omitir o conservar ubicacion mantiene ID y datos. Cambiarla explicitamente crea referencia nueva.
- [ ] Corregir cantidad, notas o fotos conserva GPS sin exigir recaptura.
- [ ] Bloquea edicion directa en `VALIDADO`.

## 4. Recepcion fisica y validacion

- [ ] Permite pasar de `BORRADOR` a `PENDIENTE_VALIDACION` si cumple reglas minimas.
- [ ] Reenvia la ficha corregida despues de guardarla en BORRADOR.
- [ ] Rechaza solicitud de validacion sin latitud valida.
- [ ] Rechaza solicitud de validacion sin longitud valida.
- [ ] Rechaza solicitud de validacion sin comunidad/localidad/zona valida.
- [ ] Registra `SOLICITUD_VALIDACION` en historial.
- [ ] ADMIN global o VALIDADOR con M2 vigente al almacenamiento puede recibir-validar o rechazar una ficha ajena.
- [ ] GENERAL con M2 recibe denegacion al intentar recibir-validar.
- [ ] Prohibe autorrecepcion tambien a ADMIN.
- [ ] La bandeja, detalle y fotos comparten autoridad de recepcion sin exigir M1.
- [ ] Compara cantidad y unidad normalizadas exactas y rechaza diferencias sin ajuste ni recepcion parcial.
- [ ] Exige fecha_recoleccion <= fecha_recepcion <= hoy en America/La_Paz.
- [ ] Recibir exige 1 a 5 fotos propias del origen, vivero y revision actual.
- [ ] Rechazar exige motivo de 10 a 500 caracteres y no exige foto.
- [ ] Revision obsoleta o foto de una revision anterior impiden decidir.
- [ ] Recepcion conforme, snapshot oficial, historia, vinculos y recibo son atomicos.
- [ ] Registra `VALIDACION_APROBADA` en historial.
- [ ] Registra `VALIDACION_RECHAZADA` en historial.
- [ ] Congela snapshots oficiales al aprobar.
- [ ] No recalcula snapshots despues de `VALIDADO`.

## 5. Consumo hacia Vivero

- [ ] Solo permite consumo si la recoleccion esta VALIDADO y tiene hecho de recepcion conforme.
- [ ] Exige autoridad M2 vigente, mismo vivero para el operario y excepcion ADMIN explicita para otro destino recibido.
- [ ] INICIO no puede preceder la recepcion fisica.
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
- [ ] Exige ADMIN global o GENERAL/VALIDADOR con acceso M2 vigente al almacenamiento y recepcion conforme.
- [ ] La autoria de la ficha por si misma no concede DESECHO.
- [x] Rechaza la accion para `BORRADOR`, `PENDIENTE_VALIDACION`, `RECHAZADO` y `CERRADO`.

## 7. Historial y movimientos

- [ ] `RECOLECCION_HISTORIAL` registra ciclo de vida del registro.
- [ ] `RECOLECCION_MOVIMIENTO` registra solo operaciones que afectan saldo.
- [ ] No usa `RECOLECCION_MOVIMIENTO` como historial general de edicion.
- [ ] El historial no se borra.
- [ ] Los movimientos no se editan ni se borran.

## 8. Roles

- [ ] GENERAL/VALIDADOR con M1 vigente pueden crear, mantener y enviar sus propias fichas.
- [ ] ADMIN deriva autoridad M1.
- [ ] VALIDADOR con acceso vigente al vivero puede recibir-validar o rechazar fichas ajenas.
- [ ] Organizacion, afiliacion y equipo no conceden autoridad M1/M2.
- [ ] `ADMIN` administra catalogos y permisos segun configuracion del sistema.
- [ ] `VOLUNTARIO` no tiene permisos criticos por defecto.
- [ ] La consulta de historial se resuelve con permisos asignables a roles existentes, no con un rol separado.

## 9. Fuera del MVP

- [ ] `CORRECCION` no esta habilitado como accion del MVP.
- [ ] `CORRECCION` no aparece como flujo operativo activo.
- [ ] `CORRECCION` no habilita edicion de registros validados.
- [ ] El MVP documenta como movimientos activos solo `CONSUMO_A_VIVERO` y `DESECHO`.

## 10. Recuperacion, evidencia y limites pendientes

- [ ] Misma clave, actor e intencion devuelve el hecho original sin repetir recepcion ni mint.
- [ ] Misma clave con otra intencion da conflicto.
- [ ] Timeout, 503 o 202 SIN_RESULTADO conserva clave, intencion y fotos y consulta el mismo comando.
- [ ] La recuperacion propia funciona con cuenta activa tras perder rol o asignacion.
- [ ] Cada rechazo conserva snapshot previo, motivo, actor y comando aunque se corrija la ficha.
- [ ] El anclaje posterior informa su resultado externo y un fallo no revierte la recepcion SQL.
- [ ] Admite originales JPG/JPEG/PNG/WEBP/HEIC/HEIF hasta 15 MiB por archivo y 100 MiB acumulados por carga.
- [ ] Preserva original, SHA256, tamano y MIME y usa multipart.
- [ ] Verifica 1 a 5 fotos por seccion Lugar y Total recolectado en toda la frontera backend. La brecha permanece abierta.
- [ ] Verifica el recorrido PWA completo de una ficha que supera 45 dias conservando fecha.
- [ ] Verifica el alcance completo de historial propio por su audiencia.

## 11. Banco publico de semillas — RF-REC-06

- [ ] Resumen, filtros, listado paginado y detalle funcionan sin cuenta.
- [ ] Incluye SEMILLA no eliminada en todos los estados y excluye ESQUEJE.
- [ ] Mantiene G y UNIDAD separados en cantidades y agregados.
- [ ] Solo publica fotos sanitizadas de VALIDADO y revalida estado y pertenencia en cada descarga.
- [ ] Excluye credenciales, correo, contacto, identidad de cuenta, observaciones y captions libres.
- [ ] La visibilidad de fichas no recibidas no habilita consumo.
- [ ] Fallos de lectura o imagen declaran indisponibilidad y permiten reintento.
