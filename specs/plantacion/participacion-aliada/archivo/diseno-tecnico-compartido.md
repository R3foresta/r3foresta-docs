# PA-F01 — Diseño compartido: frontend, backend y datos

> **Planificación anterior archivada.** Conserva trazabilidad y propuestas de su fecha. Para ejecutar, leer el [tablero actual](../implementacion/README.md) y el [contrato D01–D12 aceptado](../contrato-identidad-permisos-backend-propuesta.md). Las propuestas de PA-S04 conservan su revisión propia.

**Fecha:** 10 de octubre de 2026. **Estado:** diseño concretado por D01–D12 del contrato backend aceptado el 13; cotejo de catálogo, manifest, implementación y pruebas pendientes. No se ha creado ninguna tabla, ejecutado migraciones ni modificado los repositorios de aplicación en esta tarea.

**Actualización de producto, 11 de octubre:** [revisión humana](revision-humana-2026-10-11.md) confirma consulta pública sin sesión, perfil sin wallet/documento y afiliación opcional, y orienta VOLUNTARIO + permiso contextual. La arquitectura debe servir lectura pública separada de capacidades/datos privados; solo registro y áreas privadas requieren sesión. ADMIN global queda confirmado como autoridad central y puede registrar directamente en cualquier subcampaña ACTIVA, sin permiso contextual adicional y con las validaciones de PA-S01. De PA-DI03 siguen pendientes los mecanismos de identidad/autorización y la correspondencia de facultades internas. La revisión de PA-S00 no aprueba automáticamente las tablas propuestas aquí.

**Preparación técnica del 12 de octubre:** [instrucciones implementables](instrucciones-implementacion.md) concreta contratos/datos/pruebas para revisión del usuario. PA-S01 cerrado en comportamiento; nuevos casos de PA-S04 incorporados con compensaciones propuestas. No se aprueban mecanismos ni implementación por preparar ese documento.

**Acuerdo posterior del 12 de octubre:** [alta, roles y permisos](../acuerdo-roles-y-permisos-2026-10-12.md) confirma VOLUNTARIO para toda cuenta nueva y asignación de roles internos solo por ADMIN global, separada del perfil y de permisos contextuales. Backend/DB implementan la autorización. ADMIN global tiene acceso a todas las subcampañas y presencia derivada en su lista administrativa de miembros, sin filas por ámbito ni participación histórica automática. Usuario solicita documentar primero; implementación pendiente.

**Revisión técnica aceptada el 13 de octubre:** D01–D12 del [contrato backend](../contrato-identidad-permisos-backend-propuesta.md) quedan aceptadas por Pablo, con ajustes D02/D07. D02 define organización del catálogo/«Otra»/ausencia y D08 snapshots históricos. D07 establece LIFO sobre stock ya disponible de la subcampaña, sin nuevo flujo de recepción por organizaciones o administradores. Esa versión concreta prevalece sobre los nombres/candidatos anteriores; la aceptación de diseño no marca implementación, migraciones o pruebas como completadas.

## 1. Cómo se divide el trabajo

**Frontera pública/privada reafirmada el 13 de octubre:** Impacto global/campaña/subcampaña/registro/mapa/fotos públicas es accesible y compartible sin cuenta, registro ni login. Visitante y VOLUNTARIO sin asignación consumen la misma proyección pública. Guard JWT protege registro, gestión, lectura propia y contexto privados; no se aplica a esas consultas públicas. Frontend conserva rutas públicas fuera del guard de sesión y separa cargas privadas opcionales de capacidades: su fallo o vencimiento no cierra el contenido público ni redirige a login. Compartir usa detalle público, no `detalle-propio` ni pantallas internas. Se mantienen campos/estados PA-S02 y ADR-PLA-05 para el plan técnico autenticado.

La spec describe un resultado observable de principio a fin. Su plan distribuye responsabilidades: UX define el recorrido; frontend lo presenta y ayuda a completar datos; backend valida identidad, permisos y reglas; PostgreSQL garantiza integridad, concurrencia y persistencia. Una misma historia necesita varias capas.

Ejemplo: «Carlos puede registrar en Palca Norte». Frontend ofrece esa opción; backend rechaza un intento en Palca Sur; la transacción comprueba que el permiso sigue vigente y que hay stock antes de guardar. Ninguna capa por sí sola demuestra la historia completa.

**Separación de producto confirmada:** conservar la experiencia interna existente para administradores y operativos autorizados de R3Foresta y crear una sección distinta de Impacto y participación, reducida y progresiva. Visitante y plantador comparten esta última; solo sus acciones/contextos autorizados difieren. No se reemplaza el módulo interno ni se le recortan funciones para acomodar al participante.

**Propuesta técnica para cumplirla:** una capa frontend `participacion` compone Impacto, Mi participación, perfil y componentes del registro existente, con navegación y estructura de páginas diferenciadas de la gestión interna. Nombres de carpetas/rutas aún por revisar. Reutilizar componentes no significa reutilizar la ficha interna completa ni descargar todos sus datos para ocultarlos visualmente. Se conservan las entradas internas; cualquier enlace entre experiencias respeta facultades verificadas.

Backend entrega proyecciones públicas reducidas para resumen global, campañas, subcampañas y registros; identidad/capacidades y contexto operativo viajan por contratos privados separados. Profundizar no cambia la audiencia ni abre endpoints internos. Los agregados globales, filtros, mapas y detalles usan el mismo alcance público elegible y hechos deduplicados. Se reutilizan el backend y un único modelo de Plantación: no se crea otro conjunto de campañas/plantaciones/stock, una base por organización ni roles globales nuevos. Esta separación de interfaz no requiere por sí sola migraciones de dominio o aplicaciones desplegadas por separado.

| Spec | Frontend / UX | Backend | Persistencia |
|---|---|---|---|
| [PA-S00 Entrada](../00-experiencia-participante/spec.md) | Inicio enfocado, navegación y estados de sesión/contexto. | Alta de mínimo privilegio, perfil propio sin elevar autoridad, capacidades y protección de datos internos. | Usuario existente, permisos de PA-S03 y privilegios de acceso. |
| [PA-S02 Consulta](../02-consulta-impacto-y-registros/spec.md) | Resumen global → campaña → subcampaña → registro, mapa y campos progresivos; registros propios autorizados. | Proyección reducida por audiencia y alcance; reutilizar módulo `impact`. | Consultas sobre registros existentes, sin copiar plantaciones a tablas de un portal. |
| [PA-S03 Acceso](../03-gestion-acceso-subcampania/spec.md) | Gestión contextual y selección de subcampañas actuales. | Autoridad central/contextual; alta/retiro de facultades y búsqueda mínima de personas. | Permiso contextual, auditoría y operaciones serializadas por subcampaña. |
| [PA-S01 Registro](../01-registro-plantacion-inicial/spec.md) | Formulario de tres pasos, revisión, recuperación y comprobante. | Contexto autorizado, evidencias propias, errores identificables, consulta del intento. | Registro/detalles/consumo existentes + idempotencia y comprobante atómicos. |
| [PA-S04 Corrección](../04-correccion-excepcional/spec.md) | Orientación ante error y lectura del resultado autorizado. | Cantidades/participantes y reversión de duplicados/eliminación lógica de errores por ADMIN global o administrador del ámbito en ACTIVA; observaciones central. | Corrección vinculada al original, historial y efectos explícitos; límites del acuerdo del 12 de octubre. |

## 2. Base local y riesgos concretos

Inventario detallado de archivos, revisiones y evidencia: [plan de reutilización e integración](plan-reutilizacion-integracion.md). Las observaciones son de código local, no una auditoría del entorno desplegado.

| Observado | Consecuencia para el diseño |
|---|---|
| `ProtectedRoute` verifica sesión; menú y acciones rápidas comparten navegación interna. | Revisar landing, layout, rutas, menú lateral, navegación inferior, acciones rápidas y cargas de datos. Una vista reducida no se obtiene solo borrando dos botones. |
| Alta en `users.service.ts` asigna `GENERAL`; perfil actualiza `rol` desde DTO, con fallback `GENERAL`. | Separar datos de perfil de asignación de autoridad. El alta limitada debe resolverse en servidor; no aceptar que completar perfil promueva privilegios. |
| Recolección permite crear a `GENERAL`; Vivero permite escribir a `GENERAL`/`VALIDADOR`/`ADMIN`. | No usar `GENERAL` como sinónimo inocuo de participante. Inventariar facultades internas existentes antes de cambiar la política. |
| Parte de las rutas usa `x-auth-id` como identidad y hay lecturas de Vivero sin actor. | Establecer JWT verificado y clasificar/proteger endpoints internos, incluyendo caminos legados o directos. No basta con un JWT en una ruta nueva si la misma operación sigue expuesta por otra. |
| GET/PUT del plan ya verifican JWT; GET permite a cualquier usuario autenticado existente, PUT solo ADMIN global. | Conservar ADR-PLA-05; exponer campos de impacto públicos mediante su proyección de lectura. PA-DI08 no equivale a quitar JWT indiscriminadamente a endpoints existentes. |
| `subcampania_equipo` distingue un COORDINADOR y OPERARIO; la coordinación participa en entrega/devolución/activación. | No convertir COORDINADOR automáticamente en administrador contextual ni conceder gestión física al nuevo administrador. |
| Registro vigente local usa RPC 061; impacto ya tiene consultas y geometrías. | Adaptar lo existente; 053 es antecedente. Meta orientativa, especies del plan, consumo físico y cierre explícito deben mantenerse. |

Referencias directas: [alta y perfil](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/users/users.service.ts), [DTO de perfil](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/users/dto/register-form.dto.ts), [reglas de Recolección](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/recolecciones/application/recoleccion-auth.service.ts), [reglas de Vivero](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/lotes-vivero/application/vivero-auth.service.ts), [rutas frontend](/Users/pabloandresfernandezcari/Projects/R3foresta/pwa-r3foresta/src/App.tsx), [impacto backend](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/impact/impact.controller.ts).

## 3. Contratos que deben acordarse entre frontend y backend

**Contraste de repositorios, 12 de octubre:** [revisión de contratos, tipos y diferencias](revision-contratos-2026-10-12.md) documenta el SQL local, los DTO y sus consumidores, permisos, errores y ausencia de consulta durable del mismo intento; incorpora consultas a los chats de backend/frontend. Distingue lo implementado de PA-F01 propuesto y deja preparada la comprobación de catálogo de solo lectura, pendiente de ejecutar en el entorno destino.

**Decisiones posteriores de producto de PA-S02:** el global muestra total inicial, mapa y campañas; el plantador abre la última campaña con habilitación vigente o el global si no hay anterior utilizable. «Mis registros» incluye autoría y participación históricas, deduplicadas; la afiliación visible es la conservada al plantar. Diseñar recuerdo por cuenta y captura histórica con PA-S01, distinguiendo no declarada de histórica no disponible. No reconstruir desde el perfil actual ni ampliar campos privados del participante por incluirlo en la lista. Ver [acta](revision-humana-2026-10-11.md#revisión-posterior-de-pa-s02-en-llamada); estas decisiones no aprueban mecanismos ni migraciones.

Son necesidades lógicas, no nombres de endpoints ya implementados. Partir de rutas existentes y fijar DTO/Swagger/cliente/pruebas juntos antes de construir la parte afectada.

| Contrato | Contenido mínimo y regla |
|---|---|
| Identidad y capacidades del actor | Identidad propia, capacidades internas permitidas y contextos operativos accesibles. Se calculan en servidor. El cliente las usa para presentar acciones; cada petición vuelve a autorizarse. Caché privada por cuenta, invalidación al cambiar sesión/acceso. |
| Impacto público reducido | Campañas/subcampañas y campos confirmados de PA-S02, sin token ni perfil. Separar lectura pública de detalle privado/capacidades. No devolver equipos, stock o perfiles completos para filtrarlos luego en navegador. |
| Subcampañas donde puedo plantar | Lista filtrada por actor con campaña, subcampaña y disponibilidad operativa. Una subcampaña sin stock no equivale a una persona sin permiso. No traer equipos ajenos para decidir localmente. |
| Contexto del registro | Especies planificadas, stock elegible, reglas y participantes seleccionables de ese ámbito. Leer no reserva stock/permiso. Revalidar al guardar. |
| Otorgar/retirar acceso | Actor verificado, persona destino registrada, subcampañas explícitas y acción permitida. No aceptar `campania_id` como permiso comodín ni heredar a futuras hijas. Auditoría obligatoria. |
| Guardar / recuperar intento | Identificador estable, huella de contenido, resultado durable y errores distinguibles. Un resultado guardado se recupera incluso tras revocación mediante lectura propia; no se autoriza otra escritura por esa lectura. |
| Detalle persistido | Comprobante/registro real, visibilidad por audiencia y correcciones aplicables, sin alterar el original ni contar dos veces. |
| Corrección acotada | Identificación del original, revisión, motivo, autoridad por caso/ámbito y efectos aprobados en PA-S04. Sin endpoint genérico para editar cualquier campo. |

El cliente debe diferenciar sesión inválida, permiso insuficiente, contexto modificado, validación, rechazo confirmado y resultado desconocido. Una desconexión no demuestra que no se guardó. El contrato de intento precisa cómo reintentar la misma operación y cuándo puede comenzar una distinta.

El portal de impacto actual tiene respuestas públicas cacheadas: no introducir capacidades personales ni stock en ese mismo payload/cache. Revisar URLs de evidencias y privilegios de Storage además de endpoints; ocultar un enlace no retira acceso al recurso.

## 4. Base de datos: qué se conserva y qué podría añadirse

### Entidades existentes que se reutilizan

`usuario`, `campania`, `subcampania`, `subcampania_meta_especie`, `registro_plantacion`, `registro_plantacion_detalle`, `registro_plantacion_coresponsable`, evidencias y `asignacion_vivero_subcampania` siguen siendo la base. `subcampania_historial` ya ofrece un lugar de auditoría que debe evaluarse para nuevos eventos. Ver [esquema actual documentado](../../../../database/00_database_schema.md).

No se necesita una tabla de «plantación participante» ni «stock de organización». La referencia opcional usuario–organización aceptada en D02 describe afiliación de perfil; no resuelve ni concede el permiso del piloto. «Otra» conserva texto, sin crear una organización maestra. Un punto del mapa representa un registro grupal; la lectura de impacto es una proyección de esos datos.

### Diseño candidato para PA-DI01: permiso por persona y subcampaña

**Separación de responsabilidades aceptada en llamada:** conservar coordinación/logística existente y separar los permisos de participación por persona/subcampaña. **Persistencia aceptada en D04 el 13:** `subcampania_permiso` por vigencias y fila estable `subcampania_permiso_revision`, con historial existente. Antes del SQL se contrasta el esquema real y todos sus consumidores; el contrato backend concreta columnas/revisiones y no se sustituye silenciosamente por otra representación. La [propuesta de contratos de PA-S03](../03-gestion-acceso-subcampania/contratos.md) conecta UX, backend y persistencia; no acredita implementación.

| Campo lógico propuesto | Para qué sirve |
|---|---|
| `id`, `usuario_id`, `subcampania_id` | Identificar permiso y referencias existentes. |
| `rol_contextual` | Catálogo contextual cerrado PLANTADOR / ADMINISTRADOR_SUBCAMPANIA; administrador incluye plantar. No modifica `rol_usuario`. |
| `otorgado_at`, `otorgado_por` | Actor y fecha del otorgamiento. |
| `revocado_at`, `revocado_por` | Fin de vigencia conservando historia, sin borrar la fila. |

Restricciones propuestas: un permiso vigente por persona/subcampaña; referencias válidas; cambios y auditoría en una transacción. Al cambiar responsabilidad, cerrar la vigencia anterior y crear la nueva con evento asociado. Evitar dos filas vigentes «plantador + administrador» que dejen facultades residuales tras retirar una.

Solo R3Foresta designa/cambia/retira administradores; el administrador contextual gestiona plantadores dentro de su alcance. Un comando de plantador no puede degradar ni retirar a un administrador. La inicialización central crea el primer administrador; después, cambios concurrentes no dejan sin administrador un ámbito ya gestionado. PA-S03 confirma preparación en BORRADOR, cambios masivos todo-o-nada y reemplazo previo a la baja administrativa del último administrador. La matriz de producto permite nuevos plantadores solo en BORRADOR/ACTIVA; cerradas/canceladas admiten retiros y reemplazo central protegido. Cerrar conserva las asignaciones y las facultades internas de mantenimiento, sin nueva autorización automática por título contextual. Los mecanismos de persistencia/concurrencia y la transición legada siguen pendientes técnicos.

La política de registro admite autoridad ADMIN global verificada sin asignación contextual, o permiso contextual vigente para los demás participantes. Es una regla central explícita, distinta de una alternativa permanente entre permiso nuevo y equipo legado. Registro, retiro y protección del último administrador, incluida su baja administrativa de cuenta, se ordenan mediante la misma disciplina transaccional por subcampaña. Para varias subcampañas, bloquear en orden estable. La autorización sucede dentro de esa transacción; no en el clic del navegador. Reutilizar/extender `subcampania_historial` con actor, persona afectada, antes/después y motivo cuando corresponda, si sus restricciones permiten la auditoría requerida; no crear otra tabla de auditoría por defecto.

`subcampania_equipo` sigue explicando responsabilidades legadas mientras se migren sus consumidores. Definir una sola fuente de autoridad del nuevo registro al hacer el corte. Una condición permanente «permiso nuevo O equipo legado» podría devolver acceso revocado y no es el diseño propuesto. Inventariar por separado activación, entrega, devolución, participantes y registro. No traducir automáticamente todos los COORDINADOR ni todos los GENERAL.

### Diseño candidato para PA-DI06: intento recuperable

**Enfoque elegido por el usuario el 12 de octubre:** tabla compartida de comandos para plantación, permisos y correcciones; implementar primero plantación. `participacion_comando` concretado en D09–D11 aceptadas el 13; la propuesta previa de intento dedicado queda como alternativa evaluada histórica. Se necesita unicidad de actor + operación + clave, huella del contenido, referencia al registro/recibo y fechas. Respetar privacidad/retención del contenido; no copiar innecesariamente fotos o datos personales. [Explicación paso a paso](diseno-comandos-compartidos.md). Enfoque y diseño concreto D09–D11 aceptados el 13; cotejo de catálogo/implementación/verificación pendientes.

La creación del registro, vínculo de fotos, consumo y comprobante deben quedar confirmados atómicamente. Dos envíos equivalentes concurrentes devuelven un único resultado; misma clave con contenido diferente da conflicto. Resolver explícitamente peticiones en curso, rechazo confirmado y pérdida de respuesta. La ausencia momentánea de un recibo no prueba que otro proceso no vaya a confirmar.

D09–D11 aceptadas fijan cargas recuperables, cancelación/clausura transaccional, claves/recibos sin vencimiento durante el piloto y retención de cargas de 30 días. Cotejar/implementar antes del SQL de ejecución; eliminar una clave y aceptar su reuso podría duplicar una operación antigua. Los estados técnicos de un intento no crean una aprobación administrativa pendiente de la plantación.

### Diseño candidato para PA-DI07: corrección excepcional

Una corrección necesita vincular original, caso/revisión, ejecutor autorizado según PA-S04, fecha, motivo, datos anteriores/nuevos y efectos. Cantidades y participantes admiten ambos administradores en ACTIVA, con sus límites; observaciones permanece central. La ampliación posterior del 12 autoriza reversión de duplicados y eliminación lógica de plantación/baja/reposición erróneas por esos administradores, sin cascada de hechos reales; conservar originales y auditar compensaciones por asignación/grupo. CT09/10 en instrucciones implementables propone la representación y pruebas. Puede representarse con un evento dedicado o una tabla, nombre provisional `registro_plantacion_correccion`; el contrato físico sigue pendiente. No implica un editor universal ni tres tablas obligatorias desde el primer día.

Corregir participantes no consume ni devuelve plantas. Cambiar cantidades exige establecer los hechos físicos, dependencias posteriores, saldos afectados y la representación autorizada. Ninguna corrección devuelve automáticamente plantas al Vivero. Original y correcciones son trazables; la consulta presenta la versión efectiva aprobada sin multiplicar el total.

### Qué no cambiar por este diseño

- El catálogo global sigue `ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`. PA-DI09 confirma el 12 VOLUNTARIO para toda cuenta nueva; solo ADMIN global asigna roles internos, mediante operación separada de perfil/permisos contextuales. Compatibilidad técnica/migración aún pendientes. No crear rol «administrador de campaña» ni conceder permiso por alta; conservar roles legítimos al actualizar perfil y al migrar personas existentes.
- El estado de campaña se deriva; no se añade columna persistida ni estado de publicación nuevo.
- `cantidad_asignada` y los hechos físicos se preservan. Plantar consume asignación una vez, sin un segundo débito de Vivero.
- La meta es orientativa y la especie inicial debe pertenecer al plan. El cierre permanece explícito por ADMIN global, no automático ni concedido al administrador contextual.
- Los registros y snapshots históricos no se recalculan por cambio de afiliación, perfil o permiso.

## 5. Decisiones y responsabilidades

PA-DI01–07 se mantienen como trazabilidad en [plan de reutilización, §4](plan-reutilizacion-integracion.md#4-diseño-aceptado-y-cotejos-antes-del-código-afectado), con D01–D12 del contrato backend aceptadas el 13; PA-S04 conserva sus efectos/contratos específicos y catálogo/manifest/implementación siguen pendientes. PA-DI08–10 y sus estados se definen en [PA-S00, §5](../00-experiencia-participante/spec.md#5-decisiones-confirmadas-y-pendientes-técnicos). El contrato backend y el acta del 13 acreditan la aceptación técnica; redactar un diseño por sí solo no acredita implementación.

| Revisión | Qué se acepta | Qué no implica |
|---|---|---|
| Usuario / responsable de producto | Historias, audiencias, facultades, mensajes/recorrido y límites del piloto. | Que una migración o endpoint ya exista. |
| Revisión técnica | Contratos, representación de permisos, transición, concurrencia, seguridad y pruebas. | Que el comportamiento desplegado haya sido verificado. |
| Verificación integrada y aceptación humana | Evidencias de los escenarios sobre versiones y entorno identificados. | Permiso para ampliar roles, campos o correcciones fuera de lo revisado. |

Registrar revisor, fecha, decisión, pendientes y evidencia por spec. El LCO cerrado permite elaborar estos artefactos; no los aprueba automáticamente.

## 6. Cómo se llevaría este diseño a la base de datos

1. **Inventariar:** versión real del esquema, migraciones aplicadas, enums, FK, políticas RLS, grants de RPC/Storage y personas con roles actuales. Código local y confirmación humana no sustituyen la verificación del entorno destino.
2. **Acordar:** PA-DI01/02/03/06/07/09 según entrega, contrato API y correspondencia de usuarios. La política de audiencia debe incluir los accesos directos existentes.
3. **Crear migraciones nuevas:** en el repositorio backend, con numeración libre al momento de implementar; añadir estructuras/índices/auditoría y cambiar funciones mediante migración nueva. No editar 027–063 para simular que siempre existió este modelo.
4. **Ensayar en base aislada:** PostGIS y datos representativos; migración, restricciones, permisos, dos retiros simultáneos, retiro frente a guardado, doble envío y competencia por stock. Preparar recuperación sin borrar hechos físicos.
5. **Migrar personas con revisión:** conservar autoridad interna legítima e historial; no convertir todos los GENERAL ni COORDINADOR en un nuevo perfil automáticamente. Reconciliar conteos y excepciones antes del corte.
6. **Integrar backend y frontend:** contrato estable, pruebas negativas y recorrido real. Comprobar que una PWA antigua no eluda autorización/idempotencia. Definir compatibilidad o actualización requerida.
7. **Publicar con autorización y verificar:** fijar versiones, respaldo/recuperación, secuencia de despliegue y pruebas de humo. Solo entonces registrar evidencia en ESTADO.md y decidir habilitación de campo.

No se ejecuta SQL productivo para revisar una spec. En esta etapa el entregable es el diseño y sus preguntas; el código/migraciones se preparan por entrega una vez revisados sus requisitos y dependencias.
