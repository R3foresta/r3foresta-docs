# Boceto de baja fidelidad — registro y resultado

**Revisión técnica aceptada el 13 de octubre:** D01–D12 del [contrato backend](contrato-identidad-permisos-backend-propuesta.md) quedan aceptadas por Pablo, con ajustes D02/D07. La inicial consume LIFO del stock disponible de su subcampaña (`fecha_asignacion DESC, id DESC`), sin nueva recepción por organización/administradores ni segundo débito de Vivero. Afiliación opcional: organización existente del catálogo o «Otra»; snapshots históricos conservados. Esa versión concreta prevalece sobre los nombres/candidatos anteriores; la aceptación de diseño no marca implementación, migraciones o pruebas como completadas.


Datos simulados: Carlos (Scouts), subcampaña Palca Norte. Comportamiento de PA-S01 cerrado por el usuario el 12 de octubre: fotos y ubicación → especies y cantidades, con fecha «Hoy» modificable y observaciones → participantes, con resumen compacto y confirmación al final del tercero. Sustituye la propuesta del 10 de octubre que dedicaba el tercer paso a revisión. Es boceto de comportamiento aprobado, no diseño visual final ni aprobación de contratos técnicos. La afiliación da contexto, no permiso. Para la cuenta nueva y navegación previa, revisar [PA-S00](00-experiencia-participante/spec.md).

```text
MI PARTICIPACIÓN / PALCA NORTE               [Registrar plantación]
Contexto: campaña Bosque 2026 · permiso: PLANTADOR

1. FOTOS Y UBICACIÓN
   Fotos [Tomar foto] · 1–10 (acción principal)
   GPS [capturar con permiso] · estado de captura
   Si no hay permiso o falla: [Introducir coordenadas]
   Latitud [............] · Longitud [............]
   Alternativa: [Seleccionar / corregir punto en el mapa]
   Ubicación de la plantación [punto y estado]
   [Reajustar] [Confirmar ubicación y continuar]

2. ESPECIES Y CANTIDADES
   Especie             A registrar       Disponible para plantación inicial
   Queñua                [ 30 ]                      70
   Meta orientativa: 80 · Plantadas antes de este registro: 30
   Si se guarda: 60 plantadas · 40 disponibles (sujeto a validación)
   Stock compartido de Palca Norte; sin selección de vivero ni lote.
   Fecha del trabajo [Hoy] [Cambiar fecha dentro de la ventana vigente]
   Observaciones (opcional, hasta 2000 caracteres)
   [Se plantó junto al sendero..............................]
   [Atrás] [Continuar]

3. PARTICIPANTES
   Responsable: Carlos (tu cuenta, ya visible; no editable)
   Otras personas participantes [Ana] [revisar lista] · opcionales
   Solo personas registradas y habilitadas en Palca Norte.

   Resumen compacto al final de este mismo paso:
   Bosque 2026 · Palca Norte · ubicación indicada
   Queñua: 30 · Total: 30 · Responsable: Carlos · Participante: Ana
   Fecha y evidencia revisables: Hoy · 2 fotos
   Observaciones: Se plantó junto al sendero (solo si hay contenido)
   [Volver / corregir] [Confirmar plantación]

   Estado al pulsar: Guardando…
   Si confirma rechazo por saldo o participante sin habilitación:
   No se guardó. Explicar qué cambió. [Revisar datos]
   No reducir cantidades ni quitar participantes automáticamente.
   Si perdió permiso el responsable antes de autorización válida:
   No se guardó. No habilitar otro envío sin autorización vigente.
   Si confirma fallo técnico del evaluador, sin efecto:
   No se pudo evaluar ubicación; no se guardó. [Reintentar]
   Conservar el formulario permitido; no fingir evaluación.
   Si se corta conexión o vence la espera del envío:
   Resultado pendiente de confirmar. [Comprobar guardado]
   Al recuperar conexión, consultar el MISMO intento:
   si persistió, mismo comprobante; si procede, mismo intento al reintentar.
   Sin éxito/fracaso supuesto ni nueva plantación por respuesta perdida.

RESULTADO POSTERIOR AL GUARDADO
   ✓ Plantación guardada
   Registro: [código devuelto por servidor] · 30 plantines de Queñua
   Palca Norte · Responsable: Carlos · Otras personas: Ana
   [Ver detalle] [Volver a mi participación]
```

La fecha obligatoria aparece en el segundo paso con «Hoy» por defecto y puede cambiarse para trabajo anterior dentro de la ventana vigente, sin fecha futura ni paso adicional. Límites exactos, zona horaria y relación con asignaciones se concretan técnicamente. Observaciones opcionales hasta 2000 caracteres aparecen después de la fecha y antes de «Continuar». Cuando hay contenido se muestran en el resumen del paso 3; volver al paso 2 permite corregirlas conservando los demás datos. La aprobación del usuario del 12 de octubre cierra esta ubicación y la revisión de comportamiento de PA-S01. Mostrar observaciones en este resumen privado no autoriza publicarlas en Impacto. No hay cuarta pantalla de revisión; seleccionar participantes no guarda. El comprobante solo aparece tras confirmación verificable del servidor.

**Ubicación confirmada en llamada:** la persona confirma la ubicación en el primer paso y puede reajustarla. Ante permiso GPS denegado o cualquier fallo de captura, puede introducir coordenadas o seleccionar/corregir el punto; los campos de coordenadas son alternativa accesible al mapa, sin exigir arrastrar un marcador. Coordenada válida obligatoria y exterior permitido con evaluación/advertencia. Tomar una foto no demuestra la ubicación física. El 12 de octubre se confirma que fallo técnico del evaluador PostGIS rechaza sin registro/consumo, conserva formulario y ofrece reintentar; no se inventa evaluación. Respuesta perdida de un envío aplica resultado incierto, sin anunciar rechazo por inferencia.

**Cantidades confirmadas en llamada:** el plantador elige especies/cantidades, sin vivero/lote. El límite es el saldo elegible restante por especie de PLANTACION_INICIAL asignado a la subcampaña, compartido entre sus personas autorizadas; no la entrega original, un stock personal o la meta. El servidor distribuye LIFO y revalida/consume atómicamente al guardar, sin nuevo despacho ni segundo débito de Vivero; el mecanismo sigue pendiente de implementación/verificación. Las cantidades proyectadas son ayuda. Superar la meta no bloquea dentro del stock elegible y con las demás reglas.

**Participantes y cambios durante captura confirmados:** adicionales opcionales, solo personas registradas y habilitadas en esa subcampaña, sin nombres libres ni otros ámbitos. Al confirmar se revalidan permisos y saldo. Si falta saldo o un participante perdió habilitación antes de la validación correspondiente, rechazo confirmado con explicación y borrador conservado bajo reglas de sesión/privacidad, sin cambiar cantidades/lista automáticamente. El responsable revisa explícitamente. Si pierde autorización efectiva antes de autorizar, no se guarda; una operación válidamente autorizada antes del retiro puede terminar según las demás validaciones. No entregar contexto privado nuevo tras revocación ni invalidar retroactivamente un registro persistido: se recupera su resultado.

**Conexión perdida confirmada el 12 de octubre:** cada envío se identifica; corte/timeout no prueba fallo ni éxito. Conservar datos/identidad del intento bajo reglas de sesión/privacidad y consultar resultado al recuperar conexión. Si persistió, mismo comprobante; si procede reintentar, mismo intento y un único registro/consumo. No crear otro registro ni anunciar éxito incierto. No es modo offline completo. Contrato de consulta, idempotencia, retención y concurrencia pendientes.

**Aviso de visibilidad pública descartado el 12 de octubre:** el usuario decide continuar sin esa aclaración adicional antes de «Confirmar plantación»; no se incorpora al boceto. Se conservan campos públicos/privados y mensajes de ubicación, validación y recuperación acordados.

Producto/UX cerrado el 12 de octubre: observaciones al final del paso 2, visibles en el resumen si hay contenido y corregibles antes de confirmar; comprobante con «Ver detalle» y «Volver a mi participación». Detalle visual accesible y textos finales se afinan al implementar sin reabrir el comportamiento aprobado. La consulta por mapa no es paso obligatorio.

La recuperación de intento y el enlace a detalle tienen comportamiento confirmado, con implementación/verificación pendientes; este boceto no acredita capacidades existentes. Un rechazo por permiso retirado no ofrece otra escritura sin autorización vigente; permite salir y conservar el borrador según contrato. Recuperar un resultado histórico no restituye permiso ni abre stock/equipo.
