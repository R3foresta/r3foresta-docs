# PA-F01 — Revisión humana del 11 de octubre de 2026

**Revisor:** usuario responsable del producto, en este chat. **Evidencia:** revisión explícita de PA-S00 («Todo está excelente»), respuestas a PA-DI08/09/10, datos públicos, GPS y autoridad central, cierre de la primera versión de producto de PA-S02 y cierre funcional/orquestación de PA-S03 en llamada. Este registro acepta esos comportamientos en sus alcances revisados; no aprueba automáticamente mecanismos técnicos ni acredita implementación, migraciones o pruebas. PA-S01/04 conservan su revisión pendiente.

## 1. Confirmado

| Tema | Decisión humana | Alcance / pendiente |
|---|---|---|
| PA-S00 | Revisión favorable del recorrido del participante, incorporando las aclaraciones de esta fecha. | Boceto actualizado, contrato técnico, migración y verificación aún pendientes. |
| PA-S03 | Primera versión de comportamiento y orquestación funcional cerrada para posterior backend, frontend y diseño. | Spec/plan/tareas y propuesta de contratos preparados. Rutas, persistencia, concurrencia, transición y detalles UX/recuperación siguen revisión técnica antes de construir la parte afectada; no acredita implementación. |
| PA-DI08 | Consulta pública de campañas/subcampañas y su impacto, sin autenticación, alta ni asignación. Cualquier persona puede abrir el enlace. | Cerrada la elección común frente a solo asignadas. No es un enlace secreto ni una invitación. Conservar elegibilidad de estados públicos de RN-PLA-34; la conversación no decide publicar borradores/canceladas. |
| PA-DI05, campos | Mostrar nombres, participantes reales, fotos de plantación, ubicación/GPS/mapa, fechas, cantidades plantadas, faltantes, reposiciones, bajas y organización/comunidad de referencia. | La selección principal está confirmada. Contratos, fórmulas/presentación y origen histórico de afiliación por concretar. No extiende publicación a contactos, perfiles completos, credenciales, observaciones libres o metadatos completos de fotos. |
| Registro | Autenticación y permiso operativo en una subcampaña obligatorios. | Si intenta registrar sin sesión, explicar que debe iniciar sesión; si ya está autenticado sin permiso, explicar que un responsable debe habilitarlo. No añadir solicitud/invitación pendiente ni prometer permiso por crear cuenta. |
| PA-DI09 | El usuario considera bien encaminada la base VOLUNTARIO con facultades contextuales de plantador o administrador de subcampaña. | Orientación de producto aceptada; aún no es compatibilidad implementada ni migración aprobada. No todo VOLUNTARIO puede plantar; necesita permiso. Otros roles internos conservan sus facultades revisadas. |
| PA-DI10 | Consultar no exige datos de perfil. Para el piloto no pedir wallet ni documento de identidad; organización/comunidad/empresa opcional, sin verificación documental de identidad. | La autenticación sigue siendo necesaria para escribir y la asignación se hace a cuentas confiables. Precisar contrato de alta/nombre identificable y representación de afiliación, sin añadir requisitos de identidad no acordados ni borrar datos históricos. |
| PA-DI04, GPS | Permitir ubicación fuera del polígono en este piloto y permitir indicarla manualmente si falla la captura automática. | Conservar coordenada, resultado de evaluación y advertencia; no fingir punto interior. «Permitir manualmente» no equivale a autorizar un registro sin coordenadas válidas. Un fallo técnico del evaluador requiere tratamiento explícito, no una bandera GPS inventada. |
| Autoridad central | Diferenciar administración de R3Foresta de administración contextual y de los otros roles existentes. | Propuesta trazada en §2; no se aprobó un rol nuevo de campaña. |

### Separación confirmada de experiencias

El usuario aclara expresamente que conservar la gestión interna existente es un límite del incremento, no una alternativa pendiente de elección.

| Experiencia | Audiencia y alcance confirmado | Límite |
|---|---|---|
| Gestión interna de R3Foresta | Administradores y operativos internos autorizados; conservar estructura, datos y herramientas especializadas, y seguir mejorándolas para su operación. | No sustituirla por vistas reducidas ni retirar sus funciones para acomodar al participante. |
| Impacto y participación | Cualquier visitante puede consultar una vista reducida de impacto global, cambiar campañas y profundizar en subcampañas y registros. El plantador utiliza esta misma experiencia y suma acciones/contexto autorizados, como registrar en su subcampaña. | Ni autenticarse ni ser administrador contextual habilita la gestión interna completa. El detalle progresivo sigue siendo una vista pública reducida. |

Son dos experiencias sobre los mismos hechos, no dos modelos de Plantación ni un tercer portal para plantadores. El agregado global usa solo datos públicos elegibles y cuenta cada hecho una vez. El detalle visual, las rutas y los contratos aún deben diseñarse/verificarse; no se declara implementado ni se aprueba íntegramente PA-S02 por esta aclaración. Fuente canónica: [ADR-PLA-03](../../../decisiones/02_decisiones_plantacion.md); comportamiento en [PA-S00](00-experiencia-participante/spec.md) y [PA-S02](02-consulta-impacto-y-registros/spec.md).

## 2. PA-DI09 y autoridad: propuesta trazada para revisar

La separación de experiencias anterior no cambia por sí misma las facultades internas del catálogo vigente.

El **rol global** describe facultades de la plataforma. El **permiso contextual** indica qué puede hacer esa persona en una subcampaña concreta. Son dos dimensiones, no una escala de ascensos. Un VOLUNTARIO puede administrar Norte y plantar en Sur sin convertirse en ADMIN de R3Foresta.

| Nivel | Base / propuesta | Fuente y estado |
|---|---|---|
| Visitante sin cuenta | Consulta pública; no opera ni administra. No necesita fila de usuario ni rol «observador». | RN-PLA-34 + confirmación PA-DI08 de esta fecha. |
| ADMIN global | Administración central de R3Foresta: gestiona acceso y registra plantaciones iniciales directamente en cualquier subcampaña ACTIVA sin asignación contextual; ejecuta correcciones excepcionales que se aprueben. | Catálogo RN-GEN-03, RN-PLA-35 y ADR-PLA-03. Registro directo confirmado en esta llamada; identidad verificable, contratos y correspondencia interna pendientes. Mantiene validaciones de PA-S01 y no cierra PA-DI07. |
| GENERAL | Personal con facultades operativas internas según las reglas de cada módulo. | Catálogo RN-GEN-03 y código local de Recolección/Vivero; conservar matriz real al migrar. No es el valor de alta adecuado para un participante limitado solo porque se llame «general». |
| VALIDADOR | Mantener facultades específicas vigentes; no transformarlo en administrador de campañas ni asumir que todos los módulos le conceden lo mismo. | RN-GEN-03, RN-PLA-35 y reglas por módulo. No se redefine en esta revisión. |
| VOLUNTARIO | Base recomendada para nuevas cuentas participantes, sin operación interna por el alta. | Orientación PA-DI09 aceptada; requiere cambiar alta/perfil y la exclusión actual del backend de Plantación. |
| Plantador contextual | Puede registrar donde está habilitado, con las validaciones del registro. | ADR-PLA-03; necesita sesión + permiso, no basta rol VOLUNTARIO ni afiliación. |
| Administrador de subcampaña | Puede plantar y gestionar plantadores en sus subcampañas. No nombra administradores ni recibe plan/cierre/entregas por este permiso. | ADR-PLA-03 y PA-S03. R3Foresta designa administradores, varios permitidos, protección del último. |
| COORDINADOR / OPERARIO legado | Conservar como responsabilidades técnicas actuales mientras se resuelve su transición; no son nuevos nombres de los permisos anteriores. | RN-PLA-20/21/22/35; COORDINADOR interviene además en activación/entregas/devoluciones. |

Cuando se diga informalmente «administrador de campaña», usar **administrador de subcampaña** para este incremento. Una campaña puede facilitar asignarlo sobre varias hijas actuales; no existe autorización de campaña con herencia a futuras subcampañas. Cambiar ese ámbito requeriría otra decisión.

**Fuentes verificables:** [RN-GEN-03](../../../00-general-module/01_reglas_de_negocio_general.md#rn-gen-03---el-rol-es-controlado-por-catalogo), [RN-PLA-20/35](../../../03-plantacion-module/01_reglas_de_negocio_plantacion.md), [ADR-PLA-03](../../../decisiones/02_decisiones_plantacion.md), [restricción local de Plantación](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/plantaciones/application/plantacion-auth.service.ts), [Recolección](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/recolecciones/application/recoleccion-auth.service.ts), [Vivero](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/lotes-vivero/application/vivero-auth.service.ts).

## 3. Información pública: precisiones propuestas

- «Faltan» debe explicarse: propuesta **faltan para la meta inicial = máximo(meta vigente − plantación inicial, 0)**. No es stock disponible ni árboles muertos. Reposiciones y bajas se muestran separadas; si se expone necesidad de reposición, debe tener su propia etiqueta y regla. La meta sigue siendo orientativa.
- «Bajas» significa mortandad reportada de plantas ya plantadas; no mezclar merma de vivero/stock previo a plantar. Mostrar conteos reportados, no prometer supervivencia comprobada por una inspección que no ocurrió. La consulta de estos indicadores no amplía la escritura del piloto a nuevos flujos de seguimiento.
- Distinguir organización de la campaña y afiliación declarada de cada participante. Una plantación puede reunir personas de varias organizaciones; no atribuir toda la cantidad a una ni inferir financiación. Proponer afiliación histórica congelada al registrar o, si solo existe el perfil actual, etiquetarla como actual; decidir el dato antes de prometer historia que no existe.
- Mostrar fotos de evidencia y GPS del registro no implica compartir el bucket completo, rutas de archivos pendientes, datos de contacto ni metadatos ajenos al contrato. Proponer un aviso claro al registrar de que nombres, afiliación declarada, fotos y ubicación se consultarán públicamente; las personas deben conocer esa visibilidad.
- Observaciones libres, campos completos del perfil, roster operativo, contacto, wallet y documento no forman parte de lo aprobado para publicación en esta respuesta. No ampliar la lista por conveniencia técnica.

Estas precisiones son recomendaciones de presentación/diseño; no inventan nuevas decisiones humanas. La política pública debe materializarse en backend/Storage y en los enlaces compartidos, además de la pantalla.

### Confirmación adicional sobre autoridad, datos y PA-S00

En un mensaje posterior de esta misma fecha el usuario confirma ADMIN global como autoridad central; stock disponible fuera de la consulta pública; separación entre organizaciones de campaña y afiliaciones de participantes; y exclusión pública de contactos, perfiles completos y metadatos de fotos. Estas decisiones dejan de ser meras propuestas de §2/3. Pueden coexistir varias organizaciones de campaña y participantes de distintas afiliaciones: no se hereda una relación de la otra ni se atribuyen automáticamente todas las plantas a cada organización.

Los indicadores públicos permanecen diferenciados de stock y bajas; «Ver más» es una opción de UX por revisar, no apertura de stock privado. GPS público del registro y metadatos del archivo fotográfico son distintos: estos últimos no se publican. La fórmula de faltantes, el tratamiento histórico/actual de afiliación, el aviso de visibilidad y el mecanismo de entrega de imágenes siguen en diseño.

### Revisión posterior de PA-S02 en llamada

**Evidencia:** el usuario revisó progresivamente la entrada, resúmenes y detalle; confirmó «Mis registros» con lo que registró y donde figura como participante, afiliación de entonces y retorno al global si no hay una última campaña utilizable. Son decisiones de producto de esta misma fecha; sustituyen los pendientes de presentación principal, fórmula individual, afiliación histórica/actual y alcance de la lista personalizada mencionados antes.

| Tema | Confirmación | Límite técnico / pendiente |
|---|---|---|
| Resumen global compartido | Total inicialmente plantado, mapa de zonas y lista/selección de campañas. Visitante entra aquí; plantador puede acceder al mismo global. | Disposición y textos finales en boceto; mismo alcance público en mapa/totales/lista. Las aclaraciones sobre el mapa no se imponen como textos largos. |
| Inicio del plantador | Última campaña utilizada mientras conserva habilitación contextual allí; puede cambiar a otras o al global. Sin campaña anterior utilizable, sin historial de uso o tras perder habilitación en ella, abre directamente el global. | Recuerdo por cuenta, revalidación y error de capacidades por diseñar. No elegir campaña por afiliación ni restituir permisos desde la preferencia. |
| Resumen de campaña/subcampaña | Campaña: nombre, total inicial, mapa y subcampañas públicas. Subcampaña: estado, ubicación, avance inicial respecto de meta, faltantes y acceso a registros. | Proyección pública reducida; no copiar herramientas internas, borradores o meta interna agregada. |
| Indicadores y profundidad | Faltan para meta inicial = máximo(meta vigente − plantación inicial, 0) por subcampaña. Bajas no aumentan ese faltante; reposiciones no lo reducen. Resumen con inicial/faltantes; bajas y reposiciones al ampliar. Avance puede superar 100%, sin cierre automático. | Fuentes/contratos de seguimiento y etiquetas finales por precisar. Faltantes de campaña/global solo si se acuerda agregación; no están en los tres elementos iniciales del global. |
| Acciones rápidas | «Registrar plantación» y «Mis registros», con cambio de campaña y acceso al global como navegación. Elegir subcampaña si hay varias habilitadas. | Permiso vigente por subcampaña para escribir; gestionar plantadores conserva la capacidad separada de PA-S03. |
| Detalle de registro | Fecha, referencia, ubicación/GPS, cantidad inicial y especies, responsable/participantes, fotos y contexto de organizaciones/afiliaciones separado; bajas/reposiciones vinculadas con fechas. | Cantidad grupal una vez; no prometer composición viva por especie. Historial profundo hacia M2/M1 reservado para otra vista/entrega, sin retirar trazabilidad pública existente. |
| Mis registros | Incluye lo que la persona registró y los registros donde consta como participante histórico. | Deduplicar por registro y distinguir relaciones. Esto no aprueba nuevos campos privados del corresponsable ni reparto de crédito individual. |
| Afiliación histórica | Mostrar la afiliación de la persona al plantar, no su perfil actual. | Diseñar captura/persistencia con PA-S01. En legado sin dato histórico mostrar no disponible; distinguirlo de ausencia declarada. No reconstruir desde perfil actual/campaña. |

La presentación principal y estas tres últimas decisiones quedan confirmadas; contratos, boceto definitivo, manejo técnico de evidencia/cachés/datos históricos y correcciones siguen pendientes. Esta llamada no acredita aprobación de mecanismos, implementación, pruebas ni habilitación de campo. No se marca PA-S02 íntegramente implementable.

**Cierre explícito de la revisión:** el usuario confirma terminada PA-S02 y acepta dejar contratos, boceto definitivo e implementación como trabajo posterior. Aprueba una primera versión sólida del comportamiento como base para preparar un boceto y probar recorridos. Se registra aprobación de producto del alcance revisado; las pruebas con datos simulados y la integración posterior deben aportar su evidencia propia. No se declaran realizadas por este cierre.

PA-S00 queda aprobada en comportamiento de producto y lista para preparar boceto y plan técnico. Su integración real depende de contratos y autorización según su [plan](00-experiencia-participante/plan.md); no requiere aprobar íntegramente todas las demás specs para avanzar en trabajos independientes. No se declaran implementadas ni probadas estas decisiones.

## 4. Correcciones: todavía por decidir

El usuario expresó que aún no sabe qué casos incluir. Mantener PA-DI07 abierto. Propuesta para discutir primero: correcciones documentales acotadas y, si se confirma, participantes omitidos, ejecutadas por R3Foresta con motivo/historial y sin cambiar stock. Cantidad incorrecta, duplicado y reposiciones dependientes necesitan casos de negocio específicos; una cifra corregida no demuestra devolución física.

Revisar ejemplos concretos antes de elegir el mecanismo. No dar por resuelta la salida ante errores con un mensaje al administrador ni habilitar campo si un caso crítico carece de resolución segura. Ver [PA-S04](04-correccion-excepcional/spec.md).

## 5. Próxima revisión

1. Concretar contratos y boceto de PA-S02 con las decisiones de producto de §3; conservar los pendientes técnicos y de corrección sin volver a abrir las tres elecciones resueltas en la llamada.
2. Aplicar la elección confirmada de ADMIN global en los contratos de autoridad central; inventariar usuarios existentes antes de diseñar la migración PA-DI01/02/09.
3. Resolver con ejemplos PA-DI07 y cerrar contratos de GPS/intento, alta y perfil. Las decisiones de producto aceptadas no eliminan esas dependencias técnicas.

Esta revisión no autoriza publicación de datos reales, ejecución de SQL, despliegue ni push de los commits anteriores. Actualiza el diseño documental y deja trazabilidad de lo confirmado y lo propuesto.

## 6. PA-S03 — decisiones sobre gestión de acceso

### Preparación en BORRADOR

**Evidencia:** durante la llamada, el usuario acepta la primera alternativa de preparar asignaciones en borrador y confirma expresamente la asignación de un administrador en ese estado.

Se permite preparar acceso desde `BORRADOR`: ADMIN global puede designar al primer administrador y este puede incorporar personas ya registradas como plantadores en el ámbito que administra. El permiso contextual vigente no permite registrar una plantación inicial hasta que la subcampaña esté `ACTIVA` y cumpla PA-S01.

Esta decisión cierra la alternativa BORRADOR frente a solo ACTIVA para preparar asignaciones. La primera designación conserva la autoridad central ya acordada; no añade una nueva condición de activación ni convierte automáticamente al COORDINADOR legado. En este punto de la revisión quedaban pendientes la matriz de gestión de acceso en los demás estados, los efectos de inactivaciones, atomicidad masiva, búsqueda mínima, acceso operativo central y transición técnica; las siguientes secciones recogen los acuerdos posteriores. PA-S03 sigue en revisión; esta confirmación no acredita implementación ni aprobación integral.

### Selección masiva todo-o-nada

**Evidencia:** después de revisar el ejemplo de incorporar una persona a varias subcampañas, el usuario acepta todo-o-nada para los cambios masivos de permisos.

Se aplica toda la selección o se rechaza el comando completo: un fallo de validación o ejecución en algún ámbito no deja cambios de ese comando en los demás. Los permisos previos se conservan. Esto afecta al acceso de la persona, no a modificar las subcampañas. La atomicidad deja de ser una elección pendiente de producto; siguen pendientes su mecanismo transaccional, el contrato de repetición/conflicto y la recuperación ante respuesta perdida. La revisión integral de PA-S03 continúa.

### Reemplazo previo a baja administrativa

El usuario exige que, antes de inactivar administrativamente la cuenta del último administrador contextual, R3Foresta designe un reemplazo. Debe quedar otro administrador vigente con cuenta activa en cada subcampaña donde esa persona sea la última; sin reemplazo en alguna, se rechaza la baja. El mecanismo concurrente y otros supuestos de inactivación siguen por diseñar.

### Registro directo por ADMIN global

El usuario confirma que el administrador global de R3Foresta puede registrar directamente en cualquier subcampaña ACTIVA, sin una asignación contextual adicional. Debe cumplir las mismas validaciones de registro; su autoridad no reabre estados cerrados ni reemplaza al administrador contextual designado. La elección de acceso central deja de estar pendiente en producto, mientras identidad, contratos y transición siguen pendientes.

### Búsqueda de personas registradas

El usuario acepta ambas formas de búsqueda: por nombre y por correo exacto. Mostrar nombre y afiliación declarada opcional para distinguir resultados; el correo sirve para localizar una cuenta sin mostrar listados de contactos. No se exige organización compartida. Contrato de coincidencias, normalización, paginación y alcance verificable por diseñar.

### Reapertura explorada, decisión pendiente

El usuario plantea reabrir subcampañas cerradas mediante R3Foresta y consulta qué hacer con las canceladas. Esta exploración no aprueba una transición nueva. RN-PLA-07/37 mantienen la ausencia de reapertura; cerradas conservan mantenimiento y canceladas conservan historia con devolución física del stock pendiente. La política de cambios de acceso en esos estados y una eventual nueva capacidad de reapertura siguen por revisar.

El usuario identifica después el cierre hecho por error como motivo principal para considerar reapertura; también plantea flexibilidad para añadir plantaciones, sin cerrar aún ese alcance. Reconoce la distinción entre fechas flexibles y estado operativo. El servicio local de cierre guarda fechas explícitas, cambia a mantenimiento y conserva el stock sobrante; esto no acredita una reapertura existente. Corregir el cierre requeriría definir transición, autoridad, motivo/historial y tratamiento de fechas sin deshacer hechos físicos. El reinicio de una cancelada mediante nueva campaña o nueva subcampaña todavía requiere aclaración.

### Reapertura excepcional por cierre erróneo — acuerdo previo sustituido

En este punto de la conversación, el usuario acepta la propuesta y confirma ADMIN global como único ejecutor, con motivo/historial y sin deshacer plantaciones o movimientos físicos. El acuerdo no acreditaba implementación y dejaba fechas/fase por diseñar. La revisión posterior de requerimientos sustituye esta aprobación; no es una regla vigente ni una tarea pendiente de reapertura.

### Cierre definitivo — decisión vigente tras revisar requerimientos

El usuario solicita revisar la compatibilidad de la excepción antes de continuar. El contraste identifica:

- RF-PLA-07/08 definen cierre desde ACTIVA, impiden nuevas plantaciones iniciales en cerradas y no contemplan reapertura. La política local `TransicionEstadoPolicy` rechaza cerrada → ACTIVA.
- RF-PLA-07/08 exigen fecha de cierre y fin de mantenimiento; RF-PLA-11 usa la segunda para pasar de mantenimiento activo a monitoreo histórico, manteniendo el estado cerrado. Una reapertura exigiría un tratamiento propio de fechas/fase; el job de transición sigue pendiente según ESTADO.md.
- RF-PLA-07/08 ya registran como pendiente la escritura de los eventos de cierre en el historial. Esto es un pendiente existente, independiente de la propuesta de reapertura; no debe presentarse como un requisito nuevo ni una bitácora ya completa.
- Cerrar conserva el saldo sobrante asignado. Una devolución física al vivero es una operación separada; el cierre no devuelve automáticamente, no duplica stock y no deshace consumos. Por ejemplo, si se entregaron 100 plantas y se consumieron 80, sin otros movimientos quedan 20 asignadas.
- RF-PLA-12 conserva la gestión del equipo interno en COMPLETADA/FINALIZADA_PARCIAL porque hay mantenimiento. La futura matriz de acceso contextual debe preservar esas facultades; no equiparar ambos modelos ni congelar toda gestión del equipo.

Con esta evidencia, el usuario descarta la reapertura del alcance actual y después confirma mantener el cierre definitivo y avanzar con las mejoras de acceso acordadas. Se conservan los requerimientos y el backend existentes; no se añade transición, comando, contrato de fechas ni tarea de reapertura. ADR-PLA-06 conserva el antecedente sustituido, RN-PLA-07 vuelve a ausencia de reapertura y PA-T13-CIERRE-REV queda retirada del alcance.

Las mejoras confirmadas siguen vigentes: preparar acceso desde BORRADOR, incluido administrador; cambios sobre varias subcampañas todo-o-nada; reemplazo previo a baja administrativa del último administrador; registro inicial directo de ADMIN global solo en ACTIVA; búsqueda por nombre y correo exacto con datos mínimos. No es autorización para implementarlas antes de cerrar los contratos y la transición técnica.

La meta sigue siendo orientativa y no provoca cierre automático. Mientras esté ACTIVA puede continuar con plantaciones válidas aunque supere la meta; comunicar el carácter definitivo del cierre antes de confirmarlo ayuda a evitar cierres prematuros. Para continuar una cerrada parcialmente, RF-PLA-08 prevé otra subcampaña de la misma campaña. La discusión sobre una cancelada no decidió entre nueva campaña o nueva subcampaña; no altera RN-PLA-37.

**Pendiente en este punto de la conversación:** cambios de acceso contextual en cerradas/canceladas. La decisión siguiente resuelve esta elección; la ausencia de reapertura no la resolvía por sí sola.

### Gestión contextual por estado y continuidad del equipo — confirmadas

El usuario acepta la propuesta para el MVP: nuevas habilitaciones de plantadores en BORRADOR/ACTIVA; retiros según la autoridad de cada responsabilidad y reemplazo de administradores por ADMIN global en cerradas/canceladas, protegiendo al último. Al preguntar si se mantienen los mismos administradores y plantadores durante mantenimiento, confirma conservar personas y asignaciones al cerrar, sin revocación automática. Las operaciones de mantenimiento siguen los permisos que correspondan y se conserva la gestión interna existente de RF-PLA-12. El título contextual no concede por sí mismo una nueva facultad de mantenimiento ni transforma COORDINADOR/OPERARIO.

La matriz queda incorporada a PA-S03 y CA21/22. No permite nuevos plantadores contextuales en cerradas/canceladas ni altera estado, fechas, plantaciones, stock o historia. La nueva designación administrativa en esos estados sirve al reemplazo protegido, no a ampliar el equipo sin sustitución.

### Contratos y cierre de la orquestación de PA-S03

El usuario solicita explicación de los contratos, confirma que conectan UX, backend y persistencia y autoriza preparar la propuesta. Acepta conservar el equipo actual de coordinación/logística y separar los permisos de participación por persona/subcampaña. Esto orienta PA-DI01/02; no aprueba columnas, SQL ni una migración ya diseñada.

Se prepara [contratos de PA-S03](03-gestion-acceso-subcampania/contratos.md) con lecturas/búsqueda, habilitación/retiro, designación/cambio/reemplazo, entradas, respuestas, versiones, todo-o-nada, recuperación y ejemplos. Son candidatos técnicos y UX sobre las reglas ya confirmadas. La semántica propuesta de «sin cambios» y el formato de recuperación quedan por revisar con la implementación afectada.

El usuario da por terminada la spec en orquestación, aclarando que es para posterior implementación en backend, frontend y diseño, y no una implementación terminada. Se cierra la primera versión funcional de PA-S03: spec, plan, tareas y propuesta de contratos quedan como base de entrega. Antes del código afectado se concretan persistencia/corte de autorización, correspondencia interna, rutas/DTO y concurrencia real. No se declaran pruebas, migraciones, permisos aplicados ni despliegue.
