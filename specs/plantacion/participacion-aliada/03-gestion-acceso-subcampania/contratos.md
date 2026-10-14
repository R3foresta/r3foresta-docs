# PA-S03 — Propuesta de contratos de gestión de acceso

**Estado:** contratos lógicos preparados el 11 de octubre y concretados en el contrato backend D01–D12 aceptado por Pablo el 13, con ajustes D02/D07. Rutas v1/DTO, vigencias/revisiones, comandos y locks se toman de esa versión. No acredita funciones implementadas, migraciones ni cambios de acceso ejecutados.

Un contrato conecta la experiencia de uso, la solicitud del cliente, las validaciones del servidor y el resultado persistido. Se concreta antes de programar cada acción. Fuente de producto: [spec](spec.md) y [acta](../archivo/revision-humana-2026-10-11.md).

**Revisión técnica aceptada el 13 de octubre:** D01–D12 del [contrato backend](../contrato-identidad-permisos-backend-propuesta.md) quedan aceptadas por Pablo, con ajustes D02/D07. La afiliación del perfil es opcional: se puede escoger una organización registrada, «Otra» con nombre libre o ninguna. No crea organizaciones ni permisos; D08 congela nombre/origen/ID de procedencia cuando corresponda. D07 consume LIFO del stock de la misma subcampaña, sin recepción adicional por organización/administradores. Impacto sigue público sin cuenta/login. Esa versión concreta prevalece sobre los nombres/candidatos anteriores; la aceptación de diseño no marca implementación, migraciones o pruebas como completadas.

## 1. Base confirmada y adaptación propuesta

- [Acuerdo del 12 de octubre](../acuerdo-roles-y-permisos-2026-10-12.md): nuevas cuentas VOLUNTARIO; solo ADMIN global cambia roles internos por operación separada del perfil. Permisos contextuales en backend/DB. La lista administrativa de miembros identifica acceso global de ADMIN y deduplica por persona, sin crear permisos por subcampaña ni convertir esa presencia en designación contextual o participación histórica. Fijar su proyección junto con capacidades; no conceder a la gestión contextual un campo editable de rol global.
- Los permisos contextuales son por persona y subcampaña. Administrar incluye plantar; el administrador contextual gestiona plantadores de sus ámbitos, mientras ADMIN global designa/cambia/retira administradores.
- Nuevos plantadores solo en BORRADOR/ACTIVA. Cerradas/canceladas permiten retirar accesos y reemplazar administradores con protección del último. Cerrar conserva personas/asignaciones y no habilita nuevas plantaciones iniciales. El mantenimiento interno vigente se conserva.
- ADMIN global registra directamente en cualquier ACTIVA sin permiso contextual adicional y con las validaciones de PA-S01. No sustituye al administrador contextual designado ni puede reabrir.
- La búsqueda usa nombre o correo exacto, sin organización compartida, mostrando nombre y afiliación declarada opcional. Los cambios sobre varias subcampañas son todo-o-nada.
- La baja administrativa de una cuenta requiere reemplazo previo en cada ámbito donde sea la última administradora contextual. Los registros anteriores se conservan.

**Orientación aceptada en llamada:** conservar el equipo actual de coordinación/logística y separar los permisos de participación por persona y subcampaña. La tabla contextual candidata y su historia se describen en [diseño compartido](../archivo/diseno-tecnico-compartido.md#diseño-candidato-para-pa-di01-permiso-por-persona-y-subcampaña). D04/D12 aceptadas el 13 fijan persistencia y corte de autorización en el contrato backend; cotejar el esquema real y revisar el manifest concreto antes de migrar. Aprobación del diseño no crea tablas ni aplica permisos.

Las rutas locales `GET/POST /subcampanias/:id/equipo` y `DELETE /subcampanias/:id/equipo/:usuarioId` son antecedente interno, no los comandos contextuales nuevos. Usan COORDINADOR/OPERARIO y tienen consumidores de activación/logística. No basta renombrar su DTO. Referencias: [controlador local](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/subcampanias/api/subcampanias.controller.ts), [servicio de equipo](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/subcampanias/application/subcampanias-equipo.service.ts), [plan de integración](../archivo/plan-reutilizacion-integracion.md).

## 2. Identidad, lecturas y datos mínimos

La identidad se obtiene de la sesión/JWT verificado y se resuelve al usuario existente. El cliente no envía un rol o actor para obtener autoridad. Un encabezado de identidad libre no basta. El catálogo global permanece ADMIN/GENERAL/VALIDADOR/VOLUNTARIO.

| Contrato lógico | Solicitud y audiencia | Respuesta y uso en UX |
|---|---|---|
| PA-S03-C01 — Capacidades propias | Cuenta autenticada; filtros de campaña opcionales solo para navegación. | Ámbitos accesibles con acciones permitidas según identidad, permiso y estado: preparar/incorporar, retirar, gestionar administradores, registrar inicial. Distinguir asignación vigente de operación actualmente permitida. Se calcula en servidor; no devuelve equipo/stock completo. |
| PA-S03-C02 — Buscar cuenta registrada | Gestor con una acción legítima de incorporación/designación/reemplazo; modo nombre o correo exacto, consulta no vacía y ámbitos de destino. | Resultados paginados con referencia de usuario, nombre y afiliación declarada opcional. Sin correo, contactos, rol global ni perfil completo. Cero resultados no crea cuenta ni invitación. |
| PA-S03-C03 — Revisar acceso de la persona | Gestor autorizado en cada ámbito seleccionado; persona registrada y subcampañas actuales explícitas. | Permiso contextual vigente o ausencia, revisión para confirmar cambios y capacidades efectivas relevantes de la persona en esos ámbitos. No expone facultades ni equipos ajenos. Permite mostrar que retirar contexto no revoca autoridad global. |

Propuesta de búsqueda: nombre mediante coincidencia parcial normalizada; correo mediante coincidencia completa con la normalización del catálogo actual de cuentas. Nunca convertir correo en búsqueda parcial. La paginación propuesta tiene 20 resultados por página y cursor; tamaño final, índices y normalización se fijan con el catálogo real en PA-DI05. Consultar no habilita, reserva ni modifica datos. Cancelar una búsqueda anterior evita presentar resultados de una consulta obsoleta.

Los campos privados adicionales de C03 necesitan el contraste de audiencia de PA-DI05. Su objetivo es mostrar el efecto real del cambio, no entregar perfiles completos o el catálogo de roles internos. Ante fallo de capacidades se muestra error/reintento; no se declara ausencia de permiso.

## 3. Entrada común de los comandos

Nombres lógicos propuestos, no endpoints existentes. Cada tipo de acción tendrá su contrato explícito; no se acepta una edición libre del rol desde el perfil ni un comando genérico que permita retirar administradores como si fueran plantadores.

| Campo candidato | Regla |
|---|---|
| `comando_id` | Clave estable creada al confirmar. Identifica un intento del actor para repetir/recuperar la misma operación sin duplicarla. |
| `usuario_destino_id` | Referencia del usuario existente, con el tipo del catálogo vigente; en las rutas locales actuales es un entero positivo. No es correo ni afiliación. |
| `ambitos` | Lista no vacía, sin duplicados, de `{subcampania_id, revision_esperada}`. Son las subcampañas que la persona revisó; no hay comodín de campaña ni herencia futura. |
| `revision_esperada` | Versión del permiso de esa persona en ese ámbito leída en C03. Candidata a empezar en 0 sin historia y avanzar en cada cambio; una revocación no reinicia la versión. Persistencia exacta pendiente de PA-DI01/02. |
| Campos de reemplazo | Solo en ese comando: cuenta de reemplazo y tratamiento del administrador saliente, definidos en §4. |

El actor y su autoridad se resuelven en servidor. Se valida identidad, cuenta vigente, acción, ámbito, estado de subcampaña y versión al ejecutar; leer C03 o pulsar confirmar no reserva permisos. Las listas y versiones se normalizan de forma estable para detectar la repetición idéntica, sin ampliar la selección. El límite técnico de tamaño se revisa sin dividir silenciosamente una selección todo-o-nada.

Una cuenta destino inactiva no puede recibir una nueva habilitación/designación. Retirar un permiso o reemplazar una responsabilidad no exige reactivar a la persona saliente. La política de otros supuestos de inactivación sigue separada de la baja administrativa ya acordada.

## 4. Fichas por acción

| Contrato lógico | UX y efecto solicitado | Validación y resultado |
|---|---|---|
| PA-S03-C04 — Habilitar plantador | Seleccionar cuenta y ámbitos; mostrar «podrá plantar cuando la subcampaña esté activa y cumpla las validaciones». Confirmar la lista. | ADMIN global o administrador de cada ámbito; solo BORRADOR/ACTIVA. Activa permiso PLANTADOR directamente. Si ya es administrador, no lo degrada mediante este comando: rechaza la incompatibilidad. |
| PA-S03-C05 — Retirar plantador | Mostrar persona y ámbitos, pérdida del permiso contextual y conservación de registros. | Gestor autorizado; retiro permitido también en cerradas/canceladas. Solo actúa sobre PLANTADOR; si es administrador, rechaza y exige el comando central correspondiente. No revoca ADMIN global. |
| PA-S03-C06 — Designar administrador | Solo acción central. Explicar que administrar incluye plantar en ACTIVA y gestionar plantadores según estado, sin gestión física de stock por ese título. | ADMIN global, cuenta destino activa. Primera designación y ampliación ordinaria en BORRADOR/ACTIVA. En cerradas/canceladas, nueva designación solo dentro de reemplazo C09. Administrador existente no se duplica. |
| PA-S03-C07 — Cambiar administrador a plantador | Explicar que se retira administración y se conserva la asignación de participación de la misma persona. | Solo ADMIN global; comprobar otro administrador con cuenta activa y permiso vigente. No incorpora una persona nueva en cerradas/canceladas ni habilita operaciones bloqueadas por estado. |
| PA-S03-C08 — Retirar todo acceso contextual de administrador | Diferenciar de C07; mostrar que pierde la asignación contextual de administración y plantador. | Solo ADMIN global; otro administrador vigente con cuenta activa debe permanecer. Conserva registros e historia; no elimina autoridad global independiente. |
| PA-S03-C09 — Reemplazar administrador | Elegir saliente, reemplazo registrado y ámbitos. Para el saliente, elegir retirar todo acceso contextual o conservarlo como plantador, las dos consecuencias de §3 de la spec. | Solo ADMIN global. Verificar al saliente como administrador en cada ámbito, cuenta activa del reemplazo y revisiones de ambos permisos. Designar/verificar reemplazo antes de retirar administración al saliente, en la misma operación atómica. Admisible en cerradas/canceladas sin nuevos permisos de plantador para otras personas. |

C09 necesita en cada ámbito la revisión esperada del permiso saliente y del reemplazo. Son personas distintas. Si el reemplazo ya administra ese ámbito, se conserva su permiso y se registra el retiro/cambio del saliente; no se duplica la designación. Ningún comando modifica COORDINADOR automáticamente, el cierre, fechas, plan, plantaciones o stock.

**Repetición sin cambios propuesta:** en un comando nuevo, tras autorizar y comprobar estado/versiones, habilitar a quien ya tiene PLANTADOR o retirar un PLANTADOR ya retirado devuelve «sin cambios» y no crea un evento falso de otorgamiento/retiro. En estados que no permiten habilitación, el comando de alta se rechaza aunque el permiso exista; consultar o recuperar el resultado anterior son acciones distintas. Una revisión obsoleta provoca conflicto, no sobrescritura. Esta semántica es propuesta técnica/UX para revisión, no una aprobación ya dada por el usuario.

**Baja administrativa de cuenta:** coordinar con el servicio de usuarios existente. Antes de inactivar, comprobar en todos los ámbitos afectados que hay otra cuenta activa con permiso ADMINISTRADOR vigente. El reemplazo debe estar confirmado previamente; C09 no incorpora la baja de cuenta como efecto adicional. Si falta continuidad en algún ámbito, no inactivar la cuenta. No crear una segunda fuente de `activo` ni sustituir esa validación por un aviso de pantalla.

## 5. Persistencia, autoridad y concurrencia

Propuesta de operación para todos los comandos:

1. Verificar identidad y huella del comando; una repetición idéntica recupera el resultado durable antes de intentar un cambio nuevo.
2. Ordenar los ámbitos explícitos y serializar la ejecución con permiso/registro, cierre, plan y estado de cuentas. Revalidar autoridad y estado dentro de la transacción. El orden concreto de bloqueos debe contrastarse con las RPC vigentes de registro/plan y el servicio de usuarios en PA-DI02; no se presume resuelto.
3. Validar **todos** los ámbitos, versiones, cuentas y protección del último administrador antes de aplicar el efecto completo. Un fallo conserva todos los permisos anteriores de la selección.
4. Guardar permisos, versiones, historial y resultado confirmado en la misma transacción. Reutilizar/extender historial existente si lo permite su contrato; no añadir un registro duplicado por cada lectura/reintento.
5. Devolver el resultado persistido e invalidar lecturas privadas afectadas. La pantalla actualiza capacidades desde servidor, no mediante un cambio optimista de rol presentado como definitivo.

Auditoría mínima por cambio: comando, actor verificado, fecha del servidor, persona afectada, subcampaña, responsabilidad/vigencia anterior y posterior. En reemplazo se vinculan saliente y entrante. Motivo libre obligatorio no forma parte de la decisión de producto; su necesidad debe revisarse por acción. No registrar correos de búsqueda o fotos en el historial de permisos.

La garantía del último administrador considera cuenta activa y permiso vigente, no ADMIN global sin designación contextual. La inactivación de cuenta y los comandos de designación/retiro comparten la disciplina de concurrencia; una consulta previa de conteo no es suficiente. Inventariar roles internos y consumidores antes del corte: el nuevo registro no puede recuperar un permiso revocado por una alternativa permanente «permiso nuevo O equipo legado».

## 6. Respuesta, errores y recuperación

| Situación | Respuesta lógica propuesta | Presentación |
|---|---|---|
| Cambio completo confirmado | `CONFIRMADO`, comando, ámbitos exactos, resultado por ámbito `CAMBIO_APLICADO` o `SIN_CAMBIOS`, revisiones nuevas y capacidades relevantes permitidas. | «Acceso actualizado» o «Ya tenía ese permiso / sin cambios». Ningún ámbito figura como fallido junto con cambios aplicados. |
| Rechazo validado de la selección | `RECHAZADO`, motivo identificable y ámbitos causantes que el actor puede conocer. Ninguna modificación de permisos. | «No se aplicó ningún cambio» y explicación accionable: estado, autoridad, cuenta, versión o último administrador. |
| Respuesta perdida | El cliente conserva el mismo comando; consulta su resultado o repite **la misma** solicitud. | «Resultado pendiente de confirmar». No afirmar éxito, retiro ni fallo definitivo por un corte de conexión. |
| Mismo comando con contenido distinto | Conflicto de identidad/huella del intento. | Recuperar el resultado previo; una acción distinta necesita nueva confirmación y comando. |

Propuesta de códigos HTTP para el nuevo contrato: 401 sin sesión válida; 403 sin autoridad; 404 para recurso inexistente o no visible sin enumerar ámbitos ajenos; 409 por versión obsoleta, estado incompatible, último administrador o intento reutilizado con otro contenido; 422 por entrada inválida. Los errores de infraestructura conservan resultado desconocido hasta recuperarlo. Adaptar el formato de error del backend al fijar rutas/DTO; no propagar consultas SQL ni datos internos al cliente.

PA-S03-C10 — Recuperar comando: lectura autenticada del resultado mínimo de un comando propio, aun si el actor perdió después el permiso contextual. No recupera equipo/stock ni autoriza otra modificación. Un resultado guardado es histórico: la pantalla reconsulta capacidades actuales antes de permitir una acción nueva. Si no se encuentra un resultado todavía, no se deduce que la operación falló; se conserva/reintenta la misma clave. Retención y límites técnicos se concretan junto con idempotencia de PA-S01, sin borrar la auditoría del permiso.

Tras recuperación de un éxito anterior a un cierre o retiro, se muestra lo que ocurrió entonces y el estado actual. No se vuelve a aplicar el comando ni se restaura un permiso revocado posteriormente.

## 7. Ejemplos para revisión

| Caso | Resultado esperado |
|---|---|
| Ana no tiene acceso; Norte está en BORRADOR y Sur en ACTIVA; el gestor administra ambas. | Habilitarla en las dos confirma todos los permisos. Puede registrar inicial en Sur; Norte sigue sin permitir plantar. |
| Norte está ACTIVA y Sur cerrada cuando se ejecuta el alta. | Rechazo completo por estado; Ana no recibe un permiso nuevo en ninguna. |
| Ana ya tiene PLANTADOR en Norte y no tiene en Sur; ambas admiten alta y las versiones son actuales. | Propuesta: Norte sin cambios y Sur habilitada, con confirmación completa; si Sur falla, tampoco se cambia Norte ni su historia. |
| Un administrador contextual intenta retirar a otro administrador como plantador. | Rechazo sin efectos; no hay degradación por una ruta de plantadores. |
| R3Foresta sustituye al último administrador de una cerrada. | Designa/verifica al reemplazo antes de retirar al saliente, preserva continuidad y las otras asignaciones; no reabre ni altera mantenimiento/stock. |
| Dos solicitudes intentan retirar a los dos administradores simultáneamente. | La ejecución serializada no permite que desaparezcan ambos. El segundo resultado depende del estado/versiones confirmados; no basta ocultar el botón. |
| Se pierde la respuesta después de una habilitación confirmada y luego otro gestor retira el permiso. | Recuperar devuelve el resultado histórico del comando; reconsultar refleja el retiro actual. Repetir la misma clave no vuelve a habilitar. |
| La subcampaña cierra con las mismas personas habilitadas. | Conserva asignaciones, bloquea inicial y mantiene las operaciones internas de mantenimiento ya autorizadas; no concede mantenimiento nuevo por el título contextual. |

## 8. Diseño aceptado y trabajo previo a implementación

D01–D12 aceptadas el 13 concretan PA-DI01/02/03/05/09 para el alcance de identidad/acceso: rutas/DTO/errores, búsqueda/capacidades, vigencias/revisiones, autoridad/alta, selección masiva, SIN_CAMBIOS y recuperación. [Acta del 13](../archivo/revision-tecnica-2026-10-13.md). Los nombres de contratos lógicos de este documento se conservan; implementación sigue las rutas/campos de la versión backend aceptada.

- Cotejar catálogo real, restricciones, grants/RLS/Storage y RPC consumidoras; preparar migraciones nuevas sin reescribir históricas.
- Completar y revisar manifest concreto de personas/ámbitos y responsabilidades internas; diseño aceptado no autoriza filas de transición desconocidas.
- Integrar boceto/UI con mensajes/capacidades del contrato y comprobar la semántica en ejecución; revisión de diseño de PA-T14-REV cerrada, PA-T14-BE y QA pendientes.
- Implementar/verificar orden real con usuarios/plan/stock/cierre y protección de administradores mediante PostgreSQL aislado y llamadas directas.

La verificación se apoya en PA-S03-CA01..22 y [tareas](tasks.md); el contrato aceptado amplía casos transversales. La documentación no ejecuta funciones, SQL, llamadas productivas ni cambios de usuarios.
