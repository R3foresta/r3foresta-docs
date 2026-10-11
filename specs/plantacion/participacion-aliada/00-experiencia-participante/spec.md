# PA-S00 — Entrada y experiencia del participante

**Estado:** borrador para revisión humana. **Fecha:** 10 de octubre de 2026. **Prioridad:** P0, previa a habilitar nuevas cuentas en el piloto. Feature: PA-F01.

## 1. Resultado y alcance

Una persona que crea su cuenta para participar en una campaña encuentra una experiencia sencilla de impacto y participación. Entiende dónde puede plantar, sin tener que recorrer Recolección, Vivero o administración interna. Crear una cuenta no concede permiso para registrar plantaciones.

La dirección acordada es una experiencia enfocada para participantes, conservando las herramientas del personal autorizado y el modelo existente de Plantación. Los nombres de navegación, el alcance exacto de consulta y la representación técnica descritos aquí son propuestas por revisar. «Participante» describe una experiencia; no añade un rol al catálogo global.

Esta spec cubre cuenta → entrada → consulta → descubrimiento del permiso → acceso al registro. La captura/guardado pertenece a [PA-S01](../01-registro-plantacion-inicial/spec.md); los datos visibles a [PA-S02](../02-consulta-impacto-y-registros/spec.md); otorgar/retirar permiso a [PA-S03](../03-gestion-acceso-subcampania/spec.md).

## 2. Historias de usuario

| ID | Historia | Resultado que revisaremos |
|---|---|---|
| PA-S00-US01 | Como persona recién registrada, quiero entender el impacto de las campañas sin conocer la operación de viveros o semillas. | Inicio enfocado, información progresiva y ausencia de herramientas internas. |
| PA-S00-US02 | Como participante de una sola campaña, quiero encontrar dónde me corresponde plantar sin configurar una organización. | Lista de subcampañas habilitadas, agrupable por campaña; la afiliación no es requisito. |
| PA-S00-US03 | Como persona aún sin permiso operativo, quiero saber por qué no puedo registrar y qué hacer. | Estado vacío comprensible y orientación de contacto; no se promete acceso por completar el perfil. |
| PA-S00-US04 | Como plantador habilitado en varias subcampañas, quiero elegir la correcta antes de registrar. | Solo opciones operativas autorizadas; campaña y subcampaña visibles durante el recorrido. |
| PA-S00-US05 | Como persona a quien retiraron permiso, quiero conservar mis registros sin seguir operando. | Lectura propia autorizada y recuperación del comprobante; ya no hay contexto operativo ni escritura. |
| PA-S00-US06 | Como integrante del equipo interno, quiero conservar mis herramientas de trabajo cuando se habilite la experiencia participante. | Acceso según facultades reales; sin degradación masiva de usuarios ni permisos nuevos implícitos. |

## 3. Navegación propuesta

- **Impacto:** entrada principal; campañas y datos de consulta permitidos para esa audiencia, con resumen antes del detalle.
- **Mi participación:** subcampañas donde puede operar y acceso a registros propios según PA-S02. Estos conjuntos son distintos: un registro histórico puede seguir visible aunque ya no pueda plantar allí.
- **Perfil:** datos propios y sesión, sin selección de rol, permisos u organización obligatoria para obtener acceso.
- **Registrar plantación:** acción visible cuando existe alguna subcampaña habilitada; con varias, se elige una. Con una, se puede proponer acceso directo mostrando claramente su nombre. La selección única automática es propuesta de UX.
- **Gestión de plantadores:** entrada contextual solamente para quien administra esa subcampaña. No muestra automáticamente la administración interna completa.

Para personal con facultades internas se propone una entrada explícita «Gestión interna», con módulos filtrados por sus capacidades. No se añade un segundo inicio de sesión ni se exige cambiar de rol para plantar. La ubicación visual exacta se valida con un boceto antes de construirla.

La consulta común acordada anteriormente se conserva como referencia de trabajo: ver impacto no autoriza a operar. Está abierta **PA-DI08**: confirmar esa consulta común o restringir también la consulta a campañas con una subcampaña asignada. La restricción operativa por subcampaña está cerrada en ambos casos. «Contenido autorizado para consulta» no significa introducir un estado persistido `PUBLICADA` ni un proceso de aprobación de campañas.

## 4. Estados y criterios de aceptación

| ID | Dado / cuando | Entonces |
|---|---|---|
| PA-S00-CA01 | Una cuenta nueva completa el alta. | Entra a la experiencia participante; no recibe permisos operativos por registrarse, indicar organización o completar perfil. |
| PA-S00-CA02 | La persona no tiene subcampañas habilitadas. | Ve «Aún no tienes subcampañas habilitadas para registrar» y orientación para contactar al responsable por el canal acordado. No ve una solicitud/invitación ficticia ni un error de stock. La consulta disponible depende de PA-DI08. |
| PA-S00-CA03 | Tiene permiso en Palca Norte y no en Palca Sur. | «Dónde puedo plantar» contiene Norte, no Sur. Un enlace directo o petición a contexto/registro de Sur también se rechaza sin exponer equipo o stock. |
| PA-S00-CA04 | Tiene permiso en una subcampaña de una campaña con varias hijas. | Ver la campaña no habilita sus otras subcampañas ni las que se creen después. |
| PA-S00-CA05 | Es participante sin facultades internas y abre menú, buscador o acción rápida. | No encuentra gestión de Recolección, Vivero, entregas, catálogos o planificación. Esos datos internos tampoco se descargan en segundo plano ni se habilitan usando su URL/API directamente. |
| PA-S00-CA06 | Modifica el formulario de perfil o envía un campo de rol/capacidad inventado. | El servidor conserva su autoridad real; el flujo de perfil no concede roles ni membresías. La identidad proviene de sesión verificada. |
| PA-S00-CA07 | Se retira un permiso mientras el formulario está abierto. | La UI actualiza su disponibilidad al revalidar; el servidor decide el resultado según el orden de autorización definido en PA-S01/03. Abrir la pantalla no reserva permiso. |
| PA-S00-CA08 | Ya guardó una plantación y luego pierde acceso operativo. | Puede recuperar su comprobante y lectura propia permitida. No recupera por ello el listado de equipo, stock ni permiso para otro registro. |
| PA-S00-CA09 | La sesión vence o falla la carga de capacidades. | Se muestra recuperación de sesión o error de conexión; no se confunde con «sin subcampañas» ni se habilitan acciones por defecto. Se conservan datos del borrador conforme a PA-S01. |
| PA-S00-CA10 | Cierra sesión y entra otra persona en el mismo dispositivo. | No se reutilizan capacidades, borradores sensibles o respuestas privadas de la cuenta anterior. Volver atrás no revela su información. |
| PA-S00-CA11 | Un usuario interno ya autorizado accede tras la transición. | Conserva las operaciones verificadas en su matriz de migración; no se convierte en participante limitado solo por esta nueva navegación. |
| PA-S00-CA12 | Pertenece a una organización, a varias o a ninguna. | La autorización operativa sigue dependiendo de persona + subcampaña. La UI no obliga a crear/seleccionar organización para registrar. |

«No acceso interno» incluye backend y datos; ocultar una pantalla solo satisface la parte de UX. La consulta pública legítima existente debe clasificarse por campos y audiencia, sin tratar automáticamente todo GET de Vivero como información pública.

## 5. Decisiones pendientes y límites

| ID | Qué falta decidir | Propuesta inicial |
|---|---|---|
| PA-DI08 | Campañas visibles para quien no tiene asignación o pertenece a una sola. | Mantener consulta común de impacto autorizada; limitar las operaciones a subcampañas habilitadas. Si se elige consulta restringida, revisar también rutas directas y el alcance de lectura de plan acordado en ADR-PLA-05. |
| PA-DI09 | Rol base del alta y transición del personal existente. | Evaluar `VOLUNTARIO`, ya existente, como rol base sin facultades internas; el permiso contextual permite plantar. Confirmar contra todos los consumidores antes de cambiar el alta. No ascender a `GENERAL` para que pueda plantar. |
| PA-DI10 | Datos de perfil mínimos antes de consultar y antes de plantar. | No añadir organización/wallet obligatoria a este recorrido. Revisar si documento de identidad y otros campos actuales son necesarios para cada acción; no retirarlos de contratos vigentes sin decisión. |

No incluye nuevas afiliaciones, solicitudes de acceso, invitaciones pendientes, administración de organizaciones, personalización completa del panel ni una app separada. Sigue pendiente concretar nombres/fotos/GPS visibles en PA-S02.

## 6. Revisión y evidencia

Revisar primero US01–US03 y un ejemplo de cuenta sin permisos; después, Palca Norte habilitada y Palca Sur no habilitada. Validar también una cuenta interna real de prueba. La evidencia técnica debe cubrir navegador → API → datos y rutas directas; una captura del menú no demuestra autorización.

La revisión de producto acepta el recorrido y los criterios, no un esquema SQL ni un despliegue. Registrar quién revisó, fecha, decisiones y pendientes al aprobar; este borrador no registra esa aprobación anticipadamente.

Fuentes: [ADR-PLA-03/05](../../../../decisiones/02_decisiones_plantacion.md), [LCO](../../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md), dirección humana de este chat del 10 de octubre y [diseño técnico compartido](../diseno-tecnico-compartido.md).
