# PA-S00 — Entrada y experiencia del participante

**Estado:** comportamiento de producto aprobado, con aclaraciones confirmadas el 11 de octubre de 2026; lista para preparación técnica y boceto, no para implementación integrada ni campo hasta resolver las dependencias indicadas en el plan. **Prioridad:** P0, previa a habilitar nuevas cuentas en el piloto. Feature: PA-F01. Evidencia: [acta de revisión](../revision-humana-2026-10-11.md).

## 1. Resultado y alcance

Cualquier persona que abre el enlace encuentra una consulta pública de impacto de campañas/subcampañas, sin cuenta ni datos de perfil. Si quiere registrar una plantación, entiende que necesita autenticarse y estar habilitada en una subcampaña, sin recorrer Recolección, Vivero o administración interna. Crear una cuenta no concede permiso para registrar plantaciones.

**Límite de alcance confirmado:** hay dos experiencias sobre el mismo modelo de Plantación. La sección interna existente conserva su estructura, datos y herramientas especializadas para administradores y operativos autorizados de R3Foresta; no se reemplaza ni se simplifica globalmente. La nueva sección **Impacto y participación** ofrece información reducida y progresiva: impacto global público → campaña → subcampaña → registro, con posibilidad de cambiar de campaña y abrir enlaces directos.

El visitante y el plantador usan esta misma experiencia de Impacto. Tener permiso para plantar añade únicamente las acciones y el contexto necesarios en sus subcampañas, no acceso general a las pantallas internas. Un administrador contextual tampoco recibe ese acceso por su nombramiento. Profundizar en la consulta pública mantiene la presentación reducida y los campos permitidos. «Participante» describe una experiencia; no añade un rol al catálogo global. Ubicación visual de acciones, rutas y representación técnica siguen en diseño; la separación de experiencias ya está confirmada.

Esta spec cubre enlace → consulta pública → intención de registrar → autenticación y comprobación del permiso → acceso al registro. La captura/guardado pertenece a [PA-S01](../01-registro-plantacion-inicial/spec.md); los datos visibles a [PA-S02](../02-consulta-impacto-y-registros/spec.md); otorgar/retirar permiso a [PA-S03](../03-gestion-acceso-subcampania/spec.md).

## 2. Historias de usuario

| ID | Historia | Resultado que revisaremos |
|---|---|---|
| PA-S00-US01 | Como visitante con el enlace, quiero entender el impacto de las campañas sin crear una cuenta ni conocer la operación de viveros o semillas. | Consulta pública, información progresiva y ausencia de herramientas internas. |
| PA-S00-US02 | Como participante de una sola campaña, quiero encontrar dónde me corresponde plantar sin configurar una organización. | Lista de subcampañas habilitadas, agrupable por campaña; la afiliación no es requisito. |
| PA-S00-US03 | Como persona aún sin permiso operativo, quiero saber por qué no puedo registrar y qué hacer. | Estado vacío comprensible y orientación de contacto; no se promete acceso por completar el perfil. |
| PA-S00-US04 | Como plantador habilitado en varias subcampañas, quiero elegir la correcta antes de registrar. | Solo opciones operativas autorizadas; campaña y subcampaña visibles durante el recorrido. |
| PA-S00-US05 | Como persona a quien retiraron permiso, quiero conservar mis registros sin seguir operando. | Lectura propia autorizada y recuperación del comprobante; ya no hay contexto operativo ni escritura. |
| PA-S00-US06 | Como integrante del equipo interno, quiero conservar mis herramientas de trabajo cuando se habilite la experiencia participante. | Acceso según facultades reales; sin degradación masiva de usuarios ni permisos nuevos implícitos. |
| PA-S00-US07 | Como visitante que quiere registrar, quiero saber qué me falta para hacerlo. | Primero iniciar sesión; después, comprobar habilitación en una subcampaña. No se promete permiso automático por registrarse. |

## 3. Navegación propuesta

- **Impacto:** entrada principal pública sin redirección al login; campañas y datos públicos acordados en PA-S02, con resumen antes del detalle.
- **Mi participación:** área personalizada autenticada con subcampañas donde puede operar y registros propios según PA-S02. Estos conjuntos son distintos: un registro histórico puede seguir visible aunque ya no pueda plantar allí.
- **Perfil:** datos propios y sesión, sin selección de rol/permisos. No pedir wallet ni documento de identidad en el piloto; afiliación a organización/comunidad/empresa opcional. El visitante no necesita completar un perfil para consultar.
- **Registrar plantación:** al expresar esta intención sin sesión, explicar «Para registrar una plantación necesitas iniciar sesión y estar habilitado en una subcampaña». Con sesión sin permiso, explicar la habilitación por un responsable. Con permiso, ofrecer subcampañas habilitadas; con varias, elegir una. Con una, acceso directo con nombre visible sigue siendo propuesta de UX. La ubicación exacta de esta entrada pública se boceta; no mostrar el formulario/stock privado antes de autorizar.
- **Gestión de plantadores:** entrada contextual solamente para quien administra esa subcampaña. No muestra automáticamente la administración interna completa.

El personal con facultades internas conserva su entrada, navegación y herramientas de gestión existentes. Se puede proponer un enlace entre experiencias para esas personas, pero no obligarlas a pasar por Impacto ni sustituir su inicio por el del participante. No se añade un segundo inicio de sesión ni se exige cambiar de rol para plantar. La ubicación visual exacta se valida con un boceto antes de construirla; el acceso interno responde a facultades reales, no solo a estar autenticado.

**PA-DI08 cerrada en producto:** consulta común significa pública, sin autenticación ni asignación, no solo campañas propias. Ver impacto no autoriza a operar. Mantener elegibilidad de estados de RN-PLA-34; no introducir un estado persistido `PUBLICADA` ni proceso de aprobación de campañas. No retirar por esta decisión el JWT del GET /plan técnico: exponer los campos públicos por el contrato de consulta correspondiente.

## 4. Estados y criterios de aceptación

| ID | Dado / cuando | Entonces |
|---|---|---|
| PA-S00-CA01 | Una cuenta nueva completa el alta. | Entra a la experiencia participante; no recibe permisos operativos por registrarse, indicar organización o completar perfil. |
| PA-S00-CA02 | La persona autenticada no tiene subcampañas habilitadas. | Ve «Aún no tienes subcampañas habilitadas para registrar» y orientación para contactar al responsable por el canal acordado. No ve una solicitud/invitación ficticia ni un error de stock. Conserva toda la consulta pública. |
| PA-S00-CA03 | Tiene permiso en Palca Norte y no en Palca Sur. | «Dónde puedo plantar» contiene Norte, no Sur. Un enlace directo o petición a contexto/registro de Sur también se rechaza sin exponer equipo o stock. |
| PA-S00-CA04 | Tiene permiso en una subcampaña de una campaña con varias hijas. | Ver la campaña no habilita sus otras subcampañas ni las que se creen después. |
| PA-S00-CA05 | Es participante sin facultades internas y abre menú, buscador o acción rápida. | No encuentra gestión de Recolección, Vivero, entregas, catálogos o planificación. Esos datos internos tampoco se descargan en segundo plano ni se habilitan usando su URL/API directamente. |
| PA-S00-CA06 | Modifica el formulario de perfil o envía un campo de rol/capacidad inventado. | El servidor conserva su autoridad real; el flujo de perfil no concede roles ni membresías. La identidad proviene de sesión verificada. |
| PA-S00-CA07 | Se retira un permiso mientras el formulario está abierto. | La UI actualiza su disponibilidad al revalidar; el servidor decide el resultado según el orden de autorización definido en PA-S01/03. Abrir la pantalla no reserva permiso. |
| PA-S00-CA08 | Ya guardó una plantación y luego pierde acceso operativo. | Puede recuperar su comprobante y lectura propia permitida. No recupera por ello el listado de equipo, stock ni permiso para otro registro. |
| PA-S00-CA09 | La sesión vence o falla la carga de capacidades. | Operación/áreas privadas muestran recuperación o error; no se confunde con «sin subcampañas» ni se habilitan acciones por defecto. Se conservan datos del borrador conforme a PA-S01. La consulta pública no exige recuperar sesión para continuar. |
| PA-S00-CA10 | Cierra sesión y entra otra persona en el mismo dispositivo. | No se reutilizan capacidades, borradores sensibles o respuestas privadas de la cuenta anterior. Volver atrás no revela su información. |
| PA-S00-CA11 | Un usuario interno ya autorizado accede tras la transición. | Conserva las operaciones verificadas en su matriz de migración; no se convierte en participante limitado solo por esta nueva navegación. |
| PA-S00-CA12 | Pertenece a una organización, a varias o a ninguna. | La autorización operativa sigue dependiendo de persona + subcampaña. La UI no obliga a crear/seleccionar organización para registrar. |
| PA-S00-CA13 | Una persona abre un enlace público en navegador sin sesión, directamente al detalle o mapa. | Puede consultar los datos públicos sin cuenta, perfil, wallet, documento de identidad ni asignación. No se descargan datos internos ni capacidades de otra persona. |
| PA-S00-CA14 | Un visitante intenta registrar. | Recibe explicación y acceso a iniciar sesión/alta; tras autenticarse se revalida permiso. Sin habilitación no accede al formulario/contexto privado ni guarda. |
| PA-S00-CA15 | Una cuenta confiable autorizada completa los datos necesarios para plantar sin wallet, documento ni afiliación. | Esas ausencias no bloquean por sí solas el registro. Conserva identidad autenticada y nombre identificable según contrato de alta; afiliación es opcional y no equivale a verificación. |
| PA-S00-CA16 | Un visitante inicia sesión como plantador o administrador contextual sin facultades internas. | Conserva la misma experiencia reducida de Impacto; solo se añaden sus acciones/contextos autorizados. No se redirige a la gestión interna ni se amplían indiscriminadamente los datos descargados. |
| PA-S00-CA17 | Se habilita Impacto y un operativo interno vuelve a su entrada habitual. | Conserva estructura y herramientas de gestión autorizadas; no se sustituyen sus pantallas por la versión reducida ni se le obliga a atravesar Impacto. Verificar regresión de sus recorridos existentes. |

«No acceso interno» incluye backend y datos; ocultar una pantalla solo satisface la parte de UX. La consulta pública legítima existente debe clasificarse por campos y audiencia, sin tratar automáticamente todo GET de Vivero como información pública.

## 5. Decisiones confirmadas y pendientes técnicos

| ID | Decisión de producto del 11 de octubre | Qué sigue pendiente |
|---|---|---|
| PA-DI08 | Cerrada: consulta pública sin sesión/perfil/asignación; escritura autenticada y autorizada por subcampaña. | Contrato/proyección, campos detallados de PA-S02 y protección de rutas internas; conservar regla de estados públicos. |
| PA-DI09 | Orientación aceptada: VOLUNTARIO como base de participante, con plantador/administrador contextual asignado por subcampaña; no permiso automático ni ascenso a GENERAL. | Compatibilidad del catálogo, alta/perfil, restricciones actuales y migración del personal interno. ADMIN global confirmado como autoridad central; mecanismos verificables y matriz operativa de PA-DI03 pendientes. |
| PA-DI10 | Consulta sin datos de perfil; para el piloto no pedir wallet ni documento de identidad. Organización/comunidad/empresa opcional y declarada, con cuentas confiables habilitadas por responsables. | Contrato de alta/nombre identificable y representación actual/histórica de afiliación, sin añadir verificación documental ni borrar datos existentes. |

No incluye gestión completa de afiliaciones, solicitudes de acceso, invitaciones pendientes, administración de organizaciones, personalización completa del panel ni una app separada. La afiliación opcional para dar contexto sí forma parte del perfil; su representación se diseña con PA-S02. Nombres, participantes, fotos y GPS están confirmados como datos públicos; observaciones libres/metadatos y otros campos no se añaden automáticamente.

## 6. Revisión y evidencia

Probar primero visitante sin sesión y cuenta sin permisos; después, Palca Norte habilitada y Palca Sur no habilitada. Validar también una cuenta interna real de prueba. La evidencia técnica debe cubrir navegador → API → datos y rutas directas; una captura del menú no demuestra autorización.

**Revisión registrada:** usuario responsable del producto, 11 de octubre de 2026, conformidad explícita con PA-S00 y aclaraciones incorporadas aquí; ver [acta](../revision-humana-2026-10-11.md). Aceptar el comportamiento no aprueba un esquema SQL, una migración, los mecanismos técnicos ni la salida a campo. La representación visual final y los contratos aún deben verificarse.

Fuentes: [ADR-PLA-03/05](../../../../decisiones/02_decisiones_plantacion.md), [LCO](../../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md), dirección humana de este chat del 10 de octubre y [diseño técnico compartido](../diseno-tecnico-compartido.md).
