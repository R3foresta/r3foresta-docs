# Plan — PA-S00

**Seguimiento de implementación:** [entregas, tareas y cobertura actual](../implementacion/README.md). El estado funcional/de diseño de este documento se distingue de la ejecución.

**Estado:** preparación técnica entregada, con diseño backend D01–D12 aceptado el 13. Implementación y pruebas pendientes. Leer primero [spec](spec.md).

**Revisión técnica aceptada el 13 de octubre:** D01–D12 del [contrato backend](../contrato-identidad-permisos-backend-propuesta.md) quedan aceptadas por Pablo, con ajustes D02/D07. La afiliación del perfil es opcional: se puede escoger una organización registrada, «Otra» con nombre libre o ninguna. No crea organizaciones ni permisos; D08 congela nombre/origen/ID de procedencia cuando corresponda. D07 consume LIFO del stock de la misma subcampaña, sin recepción adicional por organización/administradores. Impacto sigue público sin cuenta/login. Esa versión concreta prevalece sobre los nombres/candidatos anteriores; la aceptación de diseño no marca implementación, migraciones o pruebas como completadas.

## Entrega mínima

**Reafirmación del 13 de octubre:** global y enlaces públicos de Impacto a campaña/subcampaña/plantación/fotos elegibles funcionan sin cuenta, registro ni login, también para VOLUNTARIO sin asignación. Frontend los coloca fuera de `ProtectedRoute`/redirect de sesión y backend los exceptúa del guard privado. La consulta pública no espera perfil/capacidades; su fallo o vencimiento no cierra Impacto. Compartir conserva el destino público del enlace. Verificar CA23/24 de [spec](spec.md) junto con los casos existentes.

Enlace → Impacto público sin sesión → intención de registrar → autenticación → sin permiso / subcampaña habilitada → formulario existente. Se conserva la entrada, estructura y herramientas de la experiencia interna existente para personal autorizado. Se reutilizan autenticación, perfil, Plantación e impacto; se propone una capa frontend `participacion` con navegación propia que compone estas capacidades. El plantador comparte el Impacto reducido del visitante, sumando solo acciones/contextos autorizados; no se lo redirige a la administración interna.

La [revisión del 11 de octubre](../archivo/revision-humana-2026-10-11.md) cierra consulta pública PA-DI08 y criterios de perfil PA-DI10, y acepta la orientación VOLUNTARIO + permiso contextual PA-DI09. D01–D12 del contrato backend están aceptadas el 13; catálogo, manifest de transición, implementación y pruebas siguen pendientes. No pedir wallet/documento en el piloto ni perfil para consultar; afiliación opcional.

El [acuerdo del 12 de octubre](../acuerdo-roles-y-permisos-2026-10-12.md) concreta PA-DI09: toda cuenta nueva VOLUNTARIO; roles internos solo por ADMIN global, mediante operación distinta de perfil; permisos contextuales implementados en backend/DB. Presentar ADMIN global en miembros con autoridad derivada, sin nuevas filas por ámbito. Añadir CA20–22 y pruebas de perfil que conserva rol legítimo, cambio de rol no autorizado y subcampaña nueva con acceso global. Contratos del diseño backend aceptados el 13; cotejo de catálogo, migraciones y ejecución pendientes; preservar cuentas existentes.

La revisión posterior de PA-S02 confirma última campaña utilizada con habilitación vigente como entrada del plantador; sin anterior utilizable o sin historial de uso, global. Bocetar cambio de campaña/global, «Registrar plantación» y «Mis registros» por autoría/participación. Diseñar recuerdo separado por cuenta y revalidación sin tratar un error de capacidades como revocación; respetar el destino de enlaces públicos directos. Verificar CA18/19 además de los escenarios anteriores. La afiliación visible del registro es la del momento de plantar; captura/persistencia histórica definida en D08; cotejo de catálogo, implementación e integración con PA-S01 pendientes.

| Capa | Trabajo | Contrato o dependencia | Evidencia de salida |
|---|---|---|---|
| UX | Bocetar cuenta sin permisos, una/múltiples subcampañas, permiso retirado y acceso interno. | PA-DI08/10 y campos PA-S02. | Revisión humana de nombres, estados y acceso rápido. |
| Frontend | Separar navegación/layout de Impacto y participación de la gestión interna conservada; adaptar rutas, acciones y caché por usuario sin recortar el menú interno para todos ni duplicar formulario. | Consulta pública y respuesta privada de capacidades/contextos. | Pruebas de navegación, enlaces directos, sesión vencida, cambio de cuenta y regresión de entradas/herramientas internas. |
| Backend | Derivar actor del JWT; alta de mínimo privilegio; perfil no cambia autoridad; respuesta limitada al actor; proteger lecturas/escrituras internas y rutas legadas alcanzables. | PA-DI03/09 y matriz de endpoints. | Una cuenta nueva no consigue información/acciones internas mediante API ni alterando headers/perfil. |
| Base de datos | Reutilizar usuario; preparar permisos contextuales de PA-S03 y privilegios/RLS acordes al acceso real. | PA-DI01/02/09, inventario de usuarios y esquema destino. | Migración ensayada sin pérdida de historial ni degradación de personal autorizado. |

El detalle de tablas candidatas, contratos y secuencia está en [diseño técnico compartido](../archivo/diseno-tecnico-compartido.md). El inventario de código existente está en [plan de reutilización](../archivo/plan-reutilizacion-integracion.md). El código local de alta usa `GENERAL` y el perfil acepta `rol`; ambos necesitan tratamiento explícito antes de habilitar participantes limitados.

## Orden y puerta de implementación

**Preparación habilitada por la aprobación funcional de PA-S00:** boceto con datos simulados, diseño de rutas/layout diferenciados, inventario de endpoints/usuarios y definición de contratos. No hace falta esperar a la aprobación integral de PA-S01–04. Este documento no declara implementada la funcionalidad ni autoriza despliegue.

**Antes de implementar cada integración:** cerrar la respuesta pública y privada necesaria con PA-S02 (campos y exclusiones), identidad/capacidades y permiso por subcampaña con PA-S03 (PA-DI01/02/09), y alta/perfil sin elevación de autoridad. ADMIN global ya está confirmado como autoridad central; quedan mecanismos y matriz operativa de PA-DI03. Las fórmulas o correcciones aún abiertas no bloquean un boceto de entrada, pero sí la implementación de esos comportamientos y la preparación de campo cuando corresponda. Revisión visual del boceto, contratos acordados y casos de regresión interna son evidencia previa al código conectado.

1. Aplicar las decisiones PA-DI08/10 y concretar contratos/permisos/afiliación con PA-DI05/09; inventariar usuarios existentes sin reclasificarlos automáticamente.
2. Acordar contrato de capacidades y de consulta reducida; se puede revisar un boceto con datos simulados mientras tanto.
3. Preparar migraciones y backend en un entorno aislado, con pruebas negativas además del caso permitido.
4. Integrar navegación y selector con esos contratos. Frontend puede preparar componentes con mocks acordados en paralelo; eso no acredita seguridad ni integración real.
5. Probar visitante sin sesión (incluido enlace profundo y sesión vencida), cuenta nueva sin permisos, plantador, administrador contextual y personal interno; verificar por URL, HTTP y accesos DB expuestos. Login protege escritura y datos privados, no el mapa/detalle públicos. Un error de capacidades no debe cerrar la consulta pública.

No se habilita el nuevo recorrido en campo mientras las restricciones solo existan en frontend. Eliminar del menú interno funcionalidades para todos los usuarios tampoco satisface esta spec.

Verificar explícitamente PA-S00-CA16/17: la misma vista de Impacto antes/después del login de un plantador, acciones limitadas a su contexto y conservación de los recorridos internos autorizados. No interpretar la separación como una revocación masiva de roles internos; PA-DI03/09 resuelven su correspondencia técnica.
