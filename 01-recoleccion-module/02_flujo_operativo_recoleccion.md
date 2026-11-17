# Flujo Operativo - Modulo 1: Recoleccion

## 1. Proposito operativo

El modulo Recoleccion registra el origen del material biologico y crea el lote origen que alimenta al Modulo 2 - Vivero.

El objetivo operativo es:

- crear un lote origen confiable,
- registrar evidencia fotografica y ubicacion estructurada,
- recibir fisicamente y confirmar conformidad antes de habilitar consumo,
- controlar el saldo disponible del lote origen,
- mantener trazabilidad entre Recoleccion y Vivero.

En este modulo no se gestionan plantas vivas; eso empieza en Vivero.

## 2. Conceptos minimos

### Recoleccion como lote origen

Una recoleccion representa el lote origen de semillas o esquejes. Puede abastecer uno o varios lotes de Vivero siempre que cada consumo quede registrado como movimiento de saldo.

### Estado del registro vs estado operativo

El modulo separa dos estados:

- Estado del registro: `BORRADOR`, `PENDIENTE_VALIDACION`, `VALIDADO`, `RECHAZADO`.
- Estado operativo: `ABIERTO` o `CERRADO`, derivado del saldo.

`ABIERTO` y `CERRADO` no se eligen manualmente.

### Snapshot oficial

Los snapshots de identidad existen desde `BORRADOR`. En `BORRADOR` y `RECHAZADO` pueden recalcularse desde fuentes vivas. Al confirmar la recepcion fisica conforme quedan congelados como identidad oficial y no se recalculan.

Snapshots minimos:

- `nombre_cientifico_snapshot`
- `nombre_comercial_snapshot`
- `variedad_snapshot`
- `nombre_comunidad_snapshot`
- `nombre_recolector_snapshot`

### Saldo

El saldo se conserva con la regla:

```text
saldo_actual = cantidad_inicial + SUM(delta_movimientos)
```

El sistema no permite saldo negativo. Si el saldo llega a 0, el estado operativo pasa a `CERRADO`.

### Movimiento de inventario

`RECOLECCION_MOVIMIENTO` registra solo operaciones que afectan saldo.

Movimientos activos en MVP:

- `CONSUMO_A_VIVERO`
- `DESECHO`

Fuera del MVP:

- `CORRECCION`

`CORRECCION` puede evaluarse como posibilidad futura, pero no es una accion disponible del MVP y no habilita edicion de recolecciones validadas.

### Integracion con Vivero

Vivero solo puede consumir una recoleccion VALIDADO, ABIERTO, recibida conforme y con saldo suficiente. La creacion del lote de vivero y el descuento del saldo se confirman en una sola transaccion atomica.

## 3. Flujo principal del modulo

### 3.1 Crear BORRADOR

Una recoleccion nace siempre en BORRADOR. Captura y mantenimiento propio requieren GENERAL o VALIDADOR con acceso M1 vigente, o autoridad global ADMIN.

Datos minimos para guardar:

- fecha de recoleccion obligatoria, no futura y maximo 45 dias retroactiva,
- tipo de material: `SEMILLA` o `ESQUEJE`,
- especie desde catalogo,
- metodo de recoleccion desde catalogo,
- cantidad inicial mayor a 0,
- unidad canonica derivada: `G` o `UNIDAD`,
- recolector,
- vivero de almacenamiento,
- latitud valida,
- longitud valida,
- comunidad/localidad/zona valida por catalogo o valor controlado permitido,
- minimo 1 foto de Lugar,
- minimo 1 foto de Total recolectado.

No se permite guardar un borrador sin evidencia minima ni ubicacion minima. Pais puede tener valor por defecto `BOLIVIA`; departamento y provincia pueden existir como estructura administrativa si estan en catalogo.

### 3.2 Completar evidencia y ubicacion

Mientras la ficha esta en BORRADOR o RECHAZADO, el recolector autorizado puede corregir datos, fotos y ubicacion. Omitir o conservar ubicacion mantiene su referencia y datos. Un cambio explicito crea referencia nueva y conserva la anterior. Cambiar notas, cantidad o fotos no exige recapturar GPS.

La ventana de 45 dias se aplica al crear o cambiar explicitamente la fecha. Conservarla permite corregir, reenviar y recibir la ficha al envejecer. La verificacion completa del recorrido PWA para ese caso permanece pendiente.

Reglas de evidencia:

- Lugar: minimo 1 foto, maximo 5.
- Total recolectado: minimo 1 foto, maximo 5.
- Formatos JPG/JPEG/PNG/WEBP/HEIC/HEIF.
- Originales hasta 15 MiB por archivo y 100 MiB acumulados por carga, con hash y metadatos tecnicos.
- La distribucion 1 a 5 por seccion se mantiene y su validacion backend por seccion permanece pendiente.

Reglas de ubicacion:

- `latitud` en rango `[-90, 90]` con 6 decimales.
- `longitud` en rango `[-180, 180]` con 6 decimales.
- `comunidad`, `localidad` o `zona` es obligatoria.
- Si comunidad/localidad/zona no existe en catalogo, no se inventa como texto libre; se resuelve por catalogo o por valor controlado permitido por el sistema.

### 3.3 Solicitar validacion

El recolector autorizado envia un BORRADOR completo. Para una ficha RECHAZADO, primero corrige y guarda BORRADOR de la misma identidad y despues vuelve a enviar.

Al solicitar validacion:

- el estado pasa a `PENDIENTE_VALIDACION`,
- se registra `SOLICITUD_VALIDACION` en `RECOLECCION_HISTORIAL`,
- la ficha queda congelada mientras se revisa.

### 3.4 Recibir y validar conformidad fisica o rechazar

ADMIN global o VALIDADOR con acceso vigente al vivero de almacenamiento revisa una ficha pendiente ajena. Esa autoridad habilita bandeja, detalle, fotos y decision, sin exigir M1 al receptor. Tambien ADMIN tiene prohibida la autorrecepcion.

Para confirmar recibe la revision actual, compara cantidad y unidad normalizadas y carga entre 1 y 5 fotos de recepcion. Debe cumplirse `fecha_recoleccion <= fecha_recepcion <= hoy` en America/La_Paz. Cantidad diferente impide confirmar y permite rechazo motivado para corregir la ficha.

Al confirmar se producen juntos estos hechos.

- Hecho inmutable RECOLECCION_RECEPCION con dia fisico, recibido_por y registrado_en real.
- Estado VALIDADO y snapshots oficiales congelados.
- VALIDACION_APROBADA, vinculos de evidencia y recibo del comando.

El rechazo exige motivo de 10 a 500 caracteres y no exige foto. Conserva snapshot de la ficha revisada y VALIDACION_RECHAZADA. El recolector corrige la misma ficha y codigo, guarda BORRADOR y vuelve a enviar. La decision usa una revision esperada y fotos de otra revision no sirven.

Se conserva UUID e intencion ante timeout, 503 o 202 SIN_RESULTADO y se consulta el mismo comando. Misma clave e intencion devuelve el resultado inicial y otra intencion produce conflicto. La recuperacion propia exige cuenta activa aun tras perder autoridad.

Pinata/blockchain se ejecuta despues de confirmar SQL. El replay evita repetir el mint y una caida posterior al commit puede dejar anclaje pendiente. Storage y anclaje conservan verificacion externa propia.

### 3.5 Consumo automatico desde Vivero

El consumo hacia Vivero no es una accion manual del modulo Recoleccion. Ocurre cuando el Modulo 2 crea un lote de vivero usando una recoleccion como origen.

Condiciones:

- `estado_registro = VALIDADO`,
- `estado_operativo = ABIERTO`,
- saldo suficiente,
- unidad del consumo igual a la unidad canonica de la recoleccion,
- snapshots oficiales ya congelados,
- hecho de recepcion conforme y autoridad vigente,
- fecha de INICIO igual o posterior al dia fisico de recepcion.

Efecto:

- se crea el lote de vivero,
- se registra `CONSUMO_A_VIVERO` con delta negativo,
- se descuenta saldo,
- se enlaza `recoleccion_id -> lote_vivero_id`,
- el lote de vivero hereda los snapshots oficiales de Recoleccion.

Almacenamiento M1 y destino M2 conservan campos distintos. El operario consume en el mismo vivero de custodia y ADMIN conserva la excepcion explicita de otro destino si el origen esta recibido conforme.

### 3.6 Desecho parcial o total bajo custodia

DESECHO registra perdida real sobre una recoleccion VALIDADO, ABIERTO y recibida conforme. Requiere ADMIN global o GENERAL/VALIDADOR con acceso M2 vigente al vivero de almacenamiento. La autoria por si misma no autoriza.

El movimiento conserva cantidad positiva hasta el saldo disponible, delta negativo y unidad canonica. Puede repetirse de forma parcial o agotar el saldo. Al llegar a cero, el estado operativo pasa a CERRADO.

El servidor fija actor, fecha y motivo tecnico DESECHO_OTRO. El formulario solicita cantidad y no exige foto, motivo libre ni fecha. El movimiento es append-only.

## 4. Diagrama del flujo principal

```mermaid
flowchart TD
  start([Inicio]) --> draft[Crear BORRADOR<br/>Fotos obligatorias<br/>GPS obligatorio<br/>Comunidad/localidad/zona obligatoria]

  draft --> ready{Cumple reglas para validacion}
  ready -- No --> edit[Editar BORRADOR]
  edit --> draft

  ready -- Si --> pending[PENDIENTE_VALIDACION<br/>Ficha congelada]
  pending --> review{Receptor autorizado confirma conformidad fisica}

  review -- No --> rejected[RECHAZADO<br/>No consumible<br/>Corregible]
  rejected --> fixRejected[Corregir RECHAZADO]
  fixRejected --> draft

  review -- Si --> validated[VALIDADO<br/>Snapshot oficial congelado<br/>Ficha no editable]

  validated --> consume[Modulo 2 crea lote vivero<br/>CONSUMO_A_VIVERO automatico]
  consume --> atomic{Transaccion lote + consumo}
  atomic -- Falla --> consumeError[Rechazar operacion<br/>No crear lote<br/>No descontar saldo]
  atomic -- OK --> recalc1[Recalcular saldo]

  validated --> waste[DESECHO bajo custodia M2<br/>Cantidad<br/>Motivo tecnico automatico]
  waste --> recalc2[Recalcular saldo]

  recalc1 --> balance{Saldo = 0}
  recalc2 --> balance
  balance -- Si --> closedState[CERRADO]
  balance -- No --> openState[ABIERTO]
```

## 5. Maquina de estados

```mermaid
flowchart LR
  subgraph registro[Estado del registro]
    draft[BORRADOR<br/>Editable<br/>Fotos, GPS y ubicacion operativa obligatorias<br/>Soft delete permitido] --> pending[PENDIENTE_VALIDACION<br/>Ficha congelada]
    pending -- Recepcion conforme --> validated[VALIDADO<br/>Recepcion fisica registrada<br/>Snapshot congelado]
    pending --> rejected[RECHAZADO<br/>No consumible<br/>Editable para corregir]
    rejected -- Corregir y guardar --> draft
  end

  subgraph operativo[Estado operativo]
    opOpen[ABIERTO<br/>saldo > 0] --> opClosed[CERRADO<br/>saldo = 0]
  end

  validated --> movement[Movimientos append-only<br/>CONSUMO_A_VIVERO<br/>DESECHO]
  movement --> recalc[Saldo = cantidad_inicial + suma de deltas]
  recalc --> opOpen
  recalc --> opClosed

  note1[Recepcion conforme y autoridad vigente habilitan consumo]:::note
  note2[CERRADO no borra el registro; solo indica saldo agotado]:::note

  note1 --- validated
  note2 --- opClosed

  classDef note fill:#f5f5f5,stroke:#999,stroke-width:1px,color:#111;
```

## 6. Reglas bloqueantes para implementacion

- Toda recoleccion nace en `BORRADOR`.
- `BORRADOR` requiere evidencia minima, latitud, longitud y comunidad/localidad/zona desde la creacion.
- VALIDADO con recepcion conforme, saldo y autoridad vigente puede alimentar Vivero.
- `PENDIENTE_VALIDACION` congela la ficha.
- `RECHAZADO` no habilita consumo, pero permite corregir y reenviar.
- `VALIDADO` no permite editar la ficha.
- Soft delete solo se permite en `BORRADOR`.
- La persistencia oficial de unidades es solo `UNIDAD` y `G`.
- `kg` solo puede existir como input; nunca se persiste.
- `ESQUEJE` solo admite `UNIDAD`, entero estricto y sin decimales.
- `SEMILLA` puede persistirse en `G` o `UNIDAD`.
- El saldo nunca puede quedar negativo.
- `CONSUMO_A_VIVERO` y `DESECHO` usan delta negativo.
- DESECHO exige ADMIN global o GENERAL/VALIDADOR con acceso M2 al almacenamiento y material recibido conforme.
- `DESECHO` no solicita evidencia fotografica.
- La creacion del lote de vivero y el consumo de recoleccion deben ser atomicos.

## 7. Acciones minimas del modulo

- Crear borrador.
- Editar borrador.
- Eliminar borrador con soft delete.
- Consultar detalle.
- Listar por estado.
- Solicitar validacion.
- Recibir y validar conformidad fisica ajena.
- Rechazar con motivo y snapshot de la ficha revisada.
- Registrar desecho.
- Consultar historial.
- Consultar movimientos de saldo con la autoridad correspondiente.
- Recuperar el comando propio ante resultado incierto.
- Consultar el banco publico de semillas.

## 8. Enums funcionales del modulo

- `estado_registro_recoleccion = [BORRADOR, PENDIENTE_VALIDACION, VALIDADO, RECHAZADO]`
- `estado_operativo_recoleccion = [ABIERTO, CERRADO]`
- `tipo_material_origen = [SEMILLA, ESQUEJE]`
- `unidad_medida = [UNIDAD, G]`
- `tipo_historial_recoleccion = [BORRADOR_CREADO, SOLICITUD_VALIDACION, VALIDACION_APROBADA, VALIDACION_RECHAZADA, BORRADOR_ELIMINADO]`
- `tipo_movimiento_recoleccion = [CONSUMO_A_VIVERO, DESECHO]`

Movimientos activos en MVP:

- `CONSUMO_A_VIVERO`
- `DESECHO`

Fuera del MVP:

- `CORRECCION`

No documentar otros movimientos como acciones operativas del modulo.

## 9. Casos borde operativos

- Intentar consumir una recoleccion no validada: rechazar.
- Intentar consumir una recoleccion cerrada: rechazar.
- Intentar consumir mas saldo del disponible: rechazar.
- Intentar editar una recoleccion validada: rechazar.
- Intentar eliminar una recoleccion que no esta en `BORRADOR`: rechazar.
- Intentar solicitar validacion sin fotos minimas: rechazar.
- Intentar solicitar validacion sin latitud o longitud: rechazar.
- Intentar solicitar validacion sin comunidad/localidad/zona valida: rechazar.
- Intentar registrar `ESQUEJE` con decimal: rechazar.
- Intentar persistir `kg`: rechazar.
- Intentar mezclar `G` y `GR`: rechazar.
- Intentar registrar movimiento con unidad distinta a la unidad canonica: rechazar.
- Si falla la creacion del lote de vivero: no descontar saldo.
- Si falla el descuento de saldo: no crear lote de vivero.

## 10. Lectura rapida del historial

Las fuentes del historial requerido se interpretan asi. La pantalla de historial propio completo conserva su pendiente de verificacion.

- `RECOLECCION.created_at`: momento de creacion del borrador.
- `RECOLECCION_HISTORIAL`: ciclo de vida del registro, incluyendo solicitud, aprobacion, rechazo y soft delete.
- `RECOLECCION_RECEPCION` conserva fecha_recepcion fisica, recibido_por y registrado_en real.
- `RECOLECCION_MOVIMIENTO.created_at`: consumos hacia Vivero y desechos.

`RECOLECCION_HISTORIAL` no reemplaza los movimientos de saldo, y `RECOLECCION_MOVIMIENTO` no debe usarse como historial general de edicion.

## 11. Consulta publica del banco de semillas

RF-REC-06 permite explorar resumen, especies, ubicaciones, fechas, listado paginado y detalle de SEMILLA no eliminada sin cuenta. Incluye BORRADOR, PENDIENTE_VALIDACION, VALIDADO y RECHAZADO, con cantidades separadas por G y UNIDAD. La consulta no habilita consumo.

Solo VALIDADO ofrece fotos sanitizadas. Cada descarga revalida estado, pertenencia y ausencia de eliminacion. La proyeccion excluye datos de cuenta, credenciales, correo, contacto, observaciones y captions libres. Un fallo de lectura o imagen declara indisponibilidad y permite reintento.

El [contrato backend de recepcion unica](../../Backend-r3foresta/docs/t4-recepcion-semillas.md) y el [contrato M1-M2](../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md) complementan este flujo. Su actualizacion funcional no acredita un nuevo corte, SQL aplicado ni despliegue.
