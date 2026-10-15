# PA-T-INT06 — Interfaz de gestión de acceso

**Estado al 15 de octubre de 2026:** FE01–FE05 implementadas y verificadas localmente en PWA sobre las APIs de C; FE06 parcial, con QA integrado y habilitación del recorrido pendientes. La UI es revisable; no se acredita revisión humana de UX. **Responsable:** frontend, en `pwa-r3foresta`. **Capacidad:** PA-S03; coordina entrada/capacidades de PA-S00. [Tablero](README.md).

## Resultado y orden

Una persona administradora gestiona plantadores en sus subcampañas; ADMIN global dispone además de acciones explícitas sobre administradores. La pantalla identifica persona, responsabilidad, ámbitos y consecuencias, y muestra éxito solo tras validar el recibo del servidor. Usa el mismo dominio/sesión y conserva las herramientas internas autorizadas.

**Primero backend:** [INT02-B](pa-t-int02-b.md) prepara DB; INT03-A prueba el motor común; [INT02-C](pa-t-int02-c.md) entrega APIs. **Después frontend:** integrar estas APIs tras el cierre verificable de C. INT02-D debe estar comprobada antes de habilitar el recorrido participante y cerrar el QA integrado. La entrada/selector para registrar sigue en PA-T-ENT05-FE/INT04; formulario y consulta pública conservan INT04/INT05.

Leer [PA-S03: spec](../03-gestion-acceso-subcampania/spec.md), [plan](../03-gestion-acceso-subcampania/plan.md), [tareas](../03-gestion-acceso-subcampania/tasks.md), [PA-S00: spec](../00-experiencia-participante/spec.md) y [tareas](../00-experiencia-participante/tasks.md); [contrato backend aceptado](../contrato-identidad-permisos-backend-propuesta.md) §2, §4.3, §5 y §7.3–7.4. Usar el informe/OpenAPI/ejemplos del cierre de C y comprobar las versiones actuales de ambos repositorios antes de integrar.

## Tareas para frontend

Los sufijos FE01–FE06 desglosan INT06; no reemplazan PA-T13-UX/FE ni PA-T14-FE. FE01 puede prepararse con ejemplos del contrato mientras avanza backend; sus mocks no acreditan integración. FE02–FE06 se conectan a la API verificada.

| Estado | ID de ejecución | Trabajo | Tarea de capacidad | Depende de | Salida verificable |
|---|---|---|---|---|---|
| [x] | PA-T-INT06-FE01 | Preparar boceto de acciones, estados y consecuencias. | PA-T13-UX | Spec/contrato aceptados. | Confirmaciones de plantador y administrador, selección múltiple, errores y resultado no confirmado revisables. |
| [x] | PA-T-INT06-FE02 | Implementar cliente v1 y entrada autorizada a gestión. | Parte de PA-T13-FE; coordinación con PA-T-ENT05-FE | PA-T-INT02-C-BE06 + FE01. | DTO validados en runtime, IDs/revisiones como cadenas; sesión/capacidades y caché por cuenta. |
| [x] | PA-T-INT06-FE03 | Implementar miembros, búsqueda y revisión de persona. | PA-T13-FE | FE02. | Nombre/correo exacto, afiliación opcional, homónimos y paginación; sin directorio ni cuentas nuevas. |
| [x] | PA-T-INT06-FE04 | Implementar selector y confirmación de acciones C04–C09. | PA-T13-FE / PA-T14-FE | FE03. | Persona y consecuencias claras, IDs actuales/revisiones fijados; un comando por selección. |
| [x] | PA-T-INT06-FE05 | Implementar envío, recuperación y actualización del estado vigente. | PA-T13-FE / PA-T14-FE | FE04 + recibos/GET de C. | Identidad del comando conservada; éxito/rechazo/inconcluso distinguidos, sin reenvío con clave nueva por timeout. |
| [ ] · parcial | PA-T-INT06-FE06 | Verificar recorridos reales y registrar cierre frontend. | Parte de PA-T16-QA / PA-T-ENT06-QA | FE02–FE05 + backend C/D verificados. | Navegador → API → DB con roles/estados, respuesta perdida, recarga/cambio de cuenta y regresión interna/pública. |

Las casillas FE01–FE05 acreditan implementación y verificación local; la revisión humana del boceto y la aceptación integrada conservan sus evidencias separadas. FE06 tiene recorridos locales navegador → API → DB documentados, pero no se marca completa.

### FE01–FE02 — Experiencia y cliente compartido

Reutilizar componentes útiles de equipo/búsqueda y la capa API/sesión existente tras cotejar el código actual. Conservar separados los permisos de participación y la logística COORDINADOR/OPERARIO. Una responsabilidad contextual no abre la administración interna ni cambia el rol global. Coordinar el cliente de capacidades con ENT05-FE para implementarlo una sola vez; INT06 no completa por sí sola la navegación de INT04/INT05.

La entrada de gestión usa acciones del DTO de capacidades. Distinguir cargando, respuesta vacía válida, error y sesión vencida; no tratar un error como pérdida de todos los permisos. Las consultas/recibos privados quedan fuera de caché pública/service worker y se aíslan por cuenta. Impacto público sigue disponible sin esperar sesión ni capacidades. Un permiso/código ausente de este DTO no revoca otras facultades internas legítimas.

### FE03–FE04 — Persona, ámbitos y acciones

- Listar miembros autorizados con permiso contextual, logística mínima y etiqueta «Administrador · Acceso global» sin duplicar personas. Si se retira un permiso contextual a ADMIN global, explicar que conserva acceso global; la pantalla no promete revocación total.
- Buscar personas ya registradas por nombre o correo exacto usando §5.2. Mostrar nombre/afiliación opcional; el correo sirve para localizar y no se publica en resultados. Si no hay cuenta, terminar con orientación de registro por el canal acordado, sin crear invitación/cuenta.
- Ofrecer una/varias/todas las subcampañas actuales administrables, hasta el límite contractual. «Todas» fija los IDs revisados, sin ámbitos futuros. Cambiar persona, acción o selección obliga a revisar de nuevo permisos/revisiones antes de confirmar.
- Usar la revisión de accesos para construir la confirmación: persona, ámbitos y responsabilidad anterior/nueva. Separar retirar plantador, administrador → plantador, retirar administrador y reemplazarlo. Reemplazo muestra ambas personas y tratamiento del saliente. Las acciones centrales requieren capacidad global; respetar BORRADOR/ACTIVA y la matriz de cerradas/canceladas, sin reapertura.

La selección masiva se envía como un comando todo-o-nada; no ejecutar un bucle de POST por subcampaña. Una revisión obsoleta exige nueva lectura y confirmación; no refrescar versiones y reenviar silenciosamente.

### FE05 — Guardado y recuperación

Generar `comando_id` una vez al confirmar y conservar actor/operación/payload/IDs/revisiones para recuperar ese envío. No depender solo de deshabilitar el botón para evitar duplicados. Reutilizar el mecanismo compartido de comandos/borradores de INT04 cuando esté disponible, sin construir otro motor de recuperación.

| Respuesta/situación | Comportamiento de pantalla |
|---|---|
| Recibo CONFIRMADO válido | Mostrar cambios o SIN_CAMBIOS; refrescar miembros/capacidades/revisiones. El recibo dice qué ocurrió entonces; la nueva lectura determina capacidades actuales. |
| Recibo RECHAZADO válido | Informar rechazo de toda la selección y conservar datos para revisar. Si se confirma una intención nueva, usar otra clave conforme al contrato. |
| Timeout, 5xx, recibo inválido o GET 202/404 inconcluso | Mostrar «resultado no confirmado», consultar/reenviar la misma clave y contenido conforme a §7.3; no afirmar éxito ni ausencia de efectos. |
| Sesión vencida durante recuperación | Recuperar sesión del actor original para consultar su comando. Impacto sigue público. |
| Recarga, cierre de pantalla o pérdida de respuesta | Reanudar conciliación del comando original antes de permitir una nueva confirmación del mismo cambio. |
| Cambio de cuenta | No exponer ni recuperar comandos/caché privados del actor anterior desde la nueva cuenta. |

Mostrar errores estables de autoridad, estado, revisión y último administrador conforme a §7.4, sin deducir comportamiento del texto del mensaje. Un retiro no borra registros propios ni cancela retroactivamente lo guardado; la consulta propia se coordina con INT05.

### FE06 — Verificación y evidencia

Probar en el entorno identificado de C/D con cuentas sintéticas: sin permiso, plantador, administrador contextual propio/ajeno y ADMIN global. Incluir una persona sin afiliación y otra de distinta organización, dos administradores, BORRADOR/ACTIVA/cerrada/cancelada, selección múltiple con rechazo completo y retiro que conserva acceso global.

Verificar PA-S03-CA02/03/05–08/11/14/15/18/21/22 y PA-S00-CA09/10/16/17/23/24 en lo que afecta a esta interfaz. Simular pérdida de respuesta tras commit y comprobar el resultado persistido: misma clave, un cambio/historial, recuperación tras recarga. Comprobar navegación y datos privados tras cambio de cuenta, enlace público en incógnito/sesión vencida y conservación de herramientas internas. Los casos concurrentes de DB se enlazan a C/D; las capturas o mocks no los sustituyen.

## Implementación local y evidencia — 15 de octubre de 2026

- PWA `cf130365` más árbol de trabajo; backend `57e5b715` más árbol de C; documentación `89dfdb2` más árbol. No se acredita publicación Git ni despliegue de esta continuación.
- Implementados cliente v1/validación runtime, capacidades compartidas por cuenta, miembros/búsqueda/revisión, selección/confirmación C04–C09 y conservación/recuperación del comando. IDs/revisiones como cadenas, un UUID por intención, Web Locks y almacenamiento privado por actor; un resultado incierto bloquea una nueva confirmación.
- La interfaz y los casos locales se registran en el [informe PWA de INT06](../../../../../pwa-r3foresta/docs/QA_GESTION_ACCESOS_INT06.md), con entorno, resultados automatizados, evidencia de navegador → API → DB y límites. La revisión humana de acciones/consecuencias sigue sin acreditarse.
- FE06 permanece parcial: faltan INT02-D y las carreras/regresiones compartidas, el recorrido de registro/cargas de INT03-A/INT04, Impacto/Mis registros de INT05, WebAuthn real y un entorno externo identificado. La evidencia local de acceso no completa esas entregas ni habilita el piloto.
- PA-T13-FE/PA-T14-FE registran únicamente el alcance de gestión implementado/verificado localmente. PA-T16-QA, ENT06-QA, INT08 y las capacidades completas conservan sus pendientes.

## Criterio de cierre

FE01–FE06 acreditadas, acciones y datos coincidentes con servidor, contratos validados y recuperación real comprobada. Entregar revisión PWA/backend, entorno, resultados de checks pertinentes, casos/capturas y límites. Actualizar PA-T13-FE/PA-T14-FE y QA en su parte comprobada, el [tablero](README.md) y [ESTADO.md](../../../../ESTADO.md).

La preparación del boceto, la implementación con mocks, el QA integrado, la publicación Git y el despliegue son estados distintos. INT06 no completa PA-S00/PA-S03 ni habilita el piloto sin el resto de sus tareas y la evidencia de INT08. El formulario de registro, Impacto/Mis registros y la interfaz de roles/baja global no forman parte de estas tareas de gestión contextual.
