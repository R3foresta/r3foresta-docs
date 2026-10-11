# Registro de plantaciones con autorización por persona y subcampaña

**Fecha de preparación:** 6 de octubre de 2026.<br>
**Última actualización:** 11 de octubre de 2026.<br>
**Estado:** Inicio revisado y LCO de este incremento cerrado por decisión humana del 8 de octubre de 2026; paso a Elaboración autorizado con las condiciones de §10. PA-S00 recibe revisión favorable de producto el 11 de octubre; contratos, demás revisiones e implementación pendientes. No acredita cierre LCO del proyecto global, LCA ni preparación del piloto.<br>
**Capacidad de referencia:** registro y consulta de plantaciones por personas habilitadas en subcampañas, independientemente de su afiliación organizacional.

## Cómo utilizarla

Este documento encuadra la capacidad dentro del ciclo RUP + SDD existente y alimentará specs pequeñas. Mantiene su ruta para conservar continuidad con el borrador inicial.

**Revisión posterior en Elaboración, 11 de octubre:** consulta pública sin autenticación/perfil, registro autenticado y habilitado por subcampaña, perfil del piloto sin pedir wallet/documento y afiliación opcional; orientación VOLUNTARIO + permiso contextual; GPS exterior permitido y entrada manual válida. PA-DI08 queda cerrada en producto; PA-DI07 (casos de corrección) sigue abierta. La conformidad con PA-S00 no aprueba mecanismos técnicos ni otras specs. Los estados de revisión históricos de esta ficha se conservan como evidencia de cada momento; la actualización y propuesta de roles con fuentes están en [acta de revisión](../specs/plantacion/participacion-aliada/revision-humana-2026-10-11.md) y ADR-PLA-03.

**Material de Elaboración, 9 de octubre de 2026:** [diagramas de contexto, casos de uso, actividades, modelo conceptual y dependencias](../specs/plantacion/participacion-aliada/diagramas/README.md). El [análisis de dependencias](../specs/plantacion/participacion-aliada/diagramas/DEPENDENCIAS.md) contrasta la base documental con código local y señala discrepancias de identidad, permisos, reintentos y reglas GPS/metas/cierre. Es material para revisión; no modifica por sí solo decisiones, aprobación de specs ni estado de despliegue.

**Alineación documental posterior, 9 de octubre de 2026:** por solicitud humana se adopta para metas/especies/cierre el contrato local descrito en [ADR-PLA-04](../decisiones/02_decisiones_plantacion.md#adr-pla-04--metas-orientativas-cierre-manual-y-edicion-del-plan): cantidades objetivo orientativas, especies iniciales limitadas al plan, consumo limitado por stock, cierre manual por ADMIN y edición de meta/plan solo ADMIN en BORRADOR como estado del backend revisado. La decisión posterior [ADR-PLA-05](../decisiones/02_decisiones_plantacion.md#adr-pla-05--edicion-de-meta-y-especies-en-activa-solo-admin) aprueba ADMIN también en ACTIVA, con implementación pendiente. No se interpreta «meta» como tope de consumo en las condiciones operativas de este incremento. Esta alineación no altera los acuerdos históricos de acceso, no aprueba specs completas y no confirma migraciones/despliegue ni preparación de campo.

**Actualización de evidencia, 10 de octubre de 2026:** el backend local ya implementa ADR-PLA-05 para ADMIN en BORRADOR o ACTIVA, con revisión atómica/versionada (062) y JWT en GET/PUT /plan (refuerzo y 063). El usuario confirmó aplicación hasta 062 y posteriormente de 063; integración frontend y despliegue verificado siguen pendientes en [ESTADO.md](../ESTADO.md). Esta evidencia posterior sustituye la nota de implementación pendiente del párrafo anterior, sin alterar el cierre LCO histórico, permisos contextuales, aprobación de specs ni preparación de campo.


- **Confirmado:** intención o decisión humana expresamente indicada. La decisión de producto del 7 de octubre de 2026 se registra en [ADR-PLA-03](../decisiones/02_decisiones_plantacion.md#adr-pla-03--autorizacion-operativa-por-persona-y-subcampana-para-participacion-aliada).
- **Propuesto:** alternativa o detalle que requiere revisión.
- **Pendiente:** pregunta abierta antes de especificar el comportamiento afectado.

Las referencias del repo describen la base vigente documentada. La revisión de la migración 053 y del handoff aporta evidencia local sobre el registro actual, no verifica un despliegue ni los nuevos permisos. No se han auditado otros repos, realizado entrevistas nuevas ni ejecutado validaciones operativas. La aclaración de consulta cartográfica del 8 de octubre es una decisión de producto, no una auditoría nueva de la app ni del despliegue.

## 1. Necesidad y situación actual

Según el usuario, una persona incorporada para plantar puede acceder a recolección, vivero y otras áreas internas que exceden su responsabilidad como participante externo. Esto genera riesgo de acceso indebido y confusión; el alcance efectivo de los permisos actuales todavía debe contrastarse en frontend y backend.

Además, los equipos reales pueden mezclar miembros de R3Foresta, organizaciones como Scouts, comunidades como Palca y personas independientes. Las empresas pueden financiar actividades antes o después de la plantación, sin que esta capacidad procese dinero. La afiliación de una persona, el ámbito donde opera y el crédito o financiación de una actividad representan relaciones distintas.

**Necesidad confirmada:** habilitar a cada persona en las subcampañas donde trabaja, con responsabilidades limitadas, stock correctamente consumido y autoría individual. Una persona de Scouts puede plantar en Palca con autorización, sin adquirir una membresía artificial en Palca.

**Base vigente:** el modelo actual utiliza roles globales y equipo de subcampaña con coordinador/operario. La decisión nueva mantiene la subcampaña como ámbito, pero sus dos roles contextuales todavía requieren diseño de correspondencia y adaptación; no se consideran ya soportados por el código.

## 2. Objetivo, valor y éxito esperado

**Objetivo:** permitir que una persona habilitada como **PLANTADOR** o **ADMINISTRADOR DE SUBCAMPAÑA** acceda rápidamente al registro, informe una plantación real en pocos pasos y reconozca que quedó guardada correctamente, en sus subcampañas autorizadas. También puede consultar el trabajo colectivo relevante. El administrador contextual también puede plantar y gestionar acceso de plantadores dentro de su ámbito; R3Foresta designa los administradores. La consulta común de impacto es otra entrada de la capacidad, no un paso obligatorio para llegar al registro.

**Valor:** facilitar equipos mixtos, limitar poderes ajenos a la operación y conservar la relación entre usuario responsable, subcampaña, plantas entregadas, cantidades registradas y evidencia.

**Éxito observable esperado — todavía no validado:**

- **Criterio prioritario del piloto, confirmado el 8 de octubre:** una persona autorizada encuentra cómo acceder al registro, completa el recorrido sin que alguien le indique cada paso y reconoce el resultado guardado. La prueba de campo observará dificultades y necesidad de ayuda; también comprobará que el registro y las cantidades quedaron correctos una sola vez. No se ha fijado un umbral numérico de tiempo ni ejecutado esta prueba.
- Se puede registrar en una subcampaña autorizada sin exigir pertenencia a su organización aliada.
- Se habilita a una persona en una, varias o todas las subcampañas actuales seleccionadas de una campaña; las futuras requieren otra asignación expresa.
- Un administrador planta y gestiona acceso de plantadores en sus subcampañas autorizadas, sin nombrar otros administradores ni recibir facultades globales de R3Foresta.
- Las plantaciones consumen stock elegible y respetan disponibilidad y meta por especie, incluso con operaciones simultáneas.
- Una plantación grupal se registra una vez, conservando responsable real y corresponsables identificados según la base actual.
- La consulta común de impacto permite ver quién plantó qué según las personas responsables y participantes que consten realmente en cada registro. No se presume que el usuario que registró plantó físicamente sin otras personas, ni se multiplican las cantidades de un registro grupal. Los campos exactos y cómo mostrar participantes siguen por definir.
- La consulta común tiene como entrada un mapa con impacto/total plantado. Cada polígono es la zona de trabajo de una subcampaña, no superficie ya plantada; cada punto GPS representa un registro grupal, no cada árbol. Tocar un área abre un resumen en la misma vista y permite avanzar a detalles y registros.
- El retiro del permiso de plantador en la subcampaña elegida es inmediato; conserva registros ya guardados, su autoría e historial, y permite a la persona consultar el detalle de sus propias plantaciones. Esa lectura no devuelve permiso para registrar ni operar, ni concede acceso interno a equipo/stock por historial propio. Los resultados para formularios y operaciones en curso se detallan en el cuadro siguiente. Cambiar afiliación no modifica automáticamente el permiso ni el significado histórico del registro.

**Retiro de permiso y registros en curso:**

| Situación al retirar el permiso en la subcampaña | Resultado confirmado |
|---|---|
| Formulario aún sin enviar | La persona ya no puede guardarlo. El formulario abierto no reserva el permiso. |
| La persona inició el envío, pero el sistema aún no autorizó la operación | Se comprueba el permiso vigente. Si ya fue retirado, se rechaza el envío sin crear registro ni consumir stock. Pulsar «Enviar» no reserva el permiso. |
| El sistema autorizó la operación cuando el permiso seguía vigente, antes del retiro | La operación termina con su resultado normal; todavía puede fallar por otras validaciones. No se cancelan automáticamente operaciones ya autorizadas y esto no habilita nuevos envíos. |
| El registro ya fue guardado | Se conserva con su autoría e historial; no se borra ni reasigna. |

La implementación y el plan técnico deben garantizar un orden consistente entre autorización/guardado y retiro. Esta regla de producto no declara que ese mecanismo ya esté implementado ni garantiza el éxito de una operación autorizada.

**Estado:** unidad de autorización, roles, transiciones de acceso y cardinalidad mínima de administradores confirmados por decisión humana del 7 de octubre. Visibilidad concreta y adaptación técnica permanecen pendientes. No se presentan métricas de mejora ni pruebas ejecutadas.

## 3. Alcance y límites

| Categoría | Contenido | Estado |
|---|---|---|
| Primer recorrido | Acceso al registro en una subcampaña autorizada → formulario → confirmación → detalle, con persona ya habilitada. | Confirmado como primera unidad; se prioriza el registro rápido. Una vía directa desde Inicio es propuesta para el mockup, no una pantalla aprobada. |
| Consulta común de impacto | Mapa con impacto/total plantado → resumen de zona en la misma vista → detalles y registros progresivos. | Confirmado para el nuevo incremento; no es paso operativo obligatorio ni implementación acreditada. |
| Autorización | Permiso por persona/subcampaña; plantador y administrador de subcampaña. R3Foresta designa administradores; estos también plantan y gestionan acceso de plantadores en su ámbito. | Confirmado para el nuevo incremento; implementación pendiente. |
| Asignación masiva | Selección de una, varias o todas las subcampañas actuales de una campaña para otorgar permisos contextuales. | Confirmado; cada subcampaña sigue siendo la unidad autorizada. |
| Seguimiento posterior | Mortandad y reposición vinculada con historial y stock elegible; merma de plantas entregadas antes de plantar como concepto separado. | Mortandad y reposición previstas; actor/revisión/detalle y alcance de merma pendientes. |
| Gestión de acceso | Incorporación directa de usuarios ya registrados como plantadores; cambio de administrador a plantador; retiro de acceso operativo según autoridad. | R3Foresta puede cambiar administrador a plantador si queda otro administrador. R3Foresta o un administrador autorizado en la subcampaña puede retirar permiso de plantador. Solo R3Foresta puede retirar todo acceso operativo de un administrador, protegiendo al último. La incorporación directa no requiere solicitud ni aceptación de invitación. |
| Anulación/corrección | Anulación lógica conservando original, autor, fecha y motivo; evaluación de edición y efectos sobre seguimientos/saldos. | Anulación deseada confirmada; autoridad, límites, edición y consecuencias pendientes. |
| Salida excepcional ante errores del primer piloto | El administrador revisa el caso; R3Foresta realiza una corrección vinculada al original, con historial. | Autoridad confirmada en la revisión por voz del 8 de octubre. Campos, límites, mecanismo y efectos por especificar; preparar y verificar la operación antes del piloto. No incorpora edición general ni aprobación previa de cada registro. |
| Dependencias | Campañas/subcampañas, equipo vigente, asignaciones físicas, plan por especie y flujo actual con foto, GPS, fecha y cantidades. | Documentado; correspondencia de roles requiere adaptación. |
| Fuera del alcance operativo actual | Solicitudes de plantas; nombramiento de otros administradores, creación de campañas, modificación de entregas y facultades de vivero/recolección por el administrador contextual. | Confirmado como exclusión. R3Foresta conserva entrega registrada, designación de administradores y control interno. |
| Capacidad separada | Corrección de entregas por R3Foresta; posible administración de perfiles/membresías organizacionales. | Corrección fuera del flujo aliado; gestión organizacional por definir aparte. |
| Evolución posterior | Crédito/financiación detallados entre organizaciones, aportes externos, superficie realmente plantada/por plantar si se requiriese y solicitudes de acceso contextual si se justifican. | Pendiente de alcance; solicitudes no forman parte del MVP. La incorporación directa puede incluir personas independientes o voluntarias. El mapa aprobado muestra zona de trabajo y registros, no superficie efectivamente plantada. |

El stock permanece en la **subcampaña**, por especie, asignación y propósito. El equipo autorizado puede compartirlo entre personas de distintas organizaciones e independientes. La campaña agrupa y facilita selección masiva; no crea un rol de campaña, permiso comodín ni herencia a subcampañas futuras.

La afiliación organizacional y la consulta de impacto son contextos independientes del permiso operativo. Campañas y organizaciones contextualizan o filtran; no forman una jerarquía obligatoria ni conceden permisos o crédito. Un filtro inicial por organización de referencia es posible y cambiable; su valor predeterminado con varias o ninguna afiliación sigue pendiente. El mapa filtrado por una organización no debe ocultar opciones de registro autorizadas en otras organizaciones. Financiar una actividad no habilita a una empresa ni a sus personas para plantar. La consulta colectiva y la atribución de crédito no deben multiplicar el total físico.

## 4. Participantes, responsabilidades y ámbito

| Actor o experiencia | Responsabilidad | Límite y estado |
|---|---|---|
| Plantador | Consultar stock/trabajo colectivo relevante y registrar plantaciones en la subcampaña autorizada. | Rol contextual confirmado; puede tener otro rol en otra subcampaña. |
| Administrador de subcampaña | Plantar y gestionar acceso de plantadores en las subcampañas que administra. | No otorga ni retira el rol de administrador. Puede retirar permisos de plantador en su subcampaña autorizada. |
| Administración central de R3Foresta | Designar o retirar administradores, cambiar un administrador a plantador y ejercer facultades internas correspondientes. | Solo R3Foresta puede cambiar un administrador a plantador o retirar todo su acceso operativo; en ambos casos debe quedar otro administrador. Puede haber varios administradores y no se puede dejar la subcampaña sin administradores. |
| Personas que consultan impacto | Navegar organizaciones e información disponible, incluyendo quién plantó qué según responsables y participantes que consten en registros. | Consulta común, no un tercer rol asignable llamado “observador”. Los campos exactos y la presentación de participantes están pendientes; no implica publicar todos los campos/fotos/GPS. |

**Confirmaciones de autorización — fuente: conversación humana del 7 de octubre de 2026:**

- La subcampaña es la única unidad de autorización operativa del MVP de participación aliada.
- Una persona puede administrar una subcampaña y ser plantador en otra.
- Una acción masiva concede permisos sobre las subcampañas actuales seleccionadas. Las futuras necesitan asignación expresa.
- Un administrador solo gestiona las subcampañas que tiene autorizadas; la acción masiva tampoco amplía su ámbito.
- En el MVP, solo la administración central de R3Foresta designa o retira el rol de administrador de subcampaña. Puede haber varios administradores por subcampaña y no se puede retirar al último ni dejar la subcampaña sin administradores; no se acordó un límite superior. R3Foresta puede cambiar un administrador a plantador si queda otro administrador. Los administradores contextuales gestionan plantadores, pero no otorgan ni retiran administradores. La delegación de nombramientos queda para una posible mejora posterior.
- El permiso de plantador puede retirarlo R3Foresta o un administrador autorizado en esa subcampaña; la persona pasa a la consulta común de impacto (“observador” como experiencia, no rol asignable) y conserva el detalle propio ya guardado. Si se retira todo acceso operativo a alguien que actualmente administra, solo R3Foresta puede hacerlo y debe quedar otro administrador. Esta acción es distinta de cambiarlo a plantador, que conserva capacidad de registrar. El rol de administrador ya incluye capacidad de plantar; no se presume un permiso paralelo e independiente de plantador en la misma subcampaña.
- Para el piloto se trabajará con personas conocidas, sin captación espontánea de voluntarios. El administrador incorpora directamente como plantadores a usuarios ya registrados en sus subcampañas autorizadas; la incorporación activa el permiso, sin solicitud pendiente ni invitación que requiera aceptación. Una persona independiente o voluntaria puede ser incorporada de este mismo modo. Las solicitudes quedan para una evolución posterior si se justifican.
- Pertenecer a una o varias organizaciones no concede permiso ni impide trabajar con otros aliados. Retirar afiliación no es una revocación operativa implícita.
- Personas internas de R3Foresta necesitan el acceso operativo que se defina; pertenencia interna no implica permiso universal para plantar.
- “Voluntario” describe una forma de participación. No supone afiliación ni determina automáticamente un rol técnico.
- Retirar permiso de plantador tiene efecto inmediato y los registros ya guardados conservan autoría e historial; la persona conserva lectura del detalle de sus propias plantaciones en esa subcampaña, sin recuperar permiso operativo ni acceso al equipo/stock por esa vía. El cuadro de §2 define los resultados de las cuatro situaciones; la implementación debe ordenar consistentemente autorización/guardado y retiro. R3Foresta puede cambiar administrador a plantador si queda otro administrador, conservando la capacidad de registrar. Retirar todo acceso operativo a un administrador es otra acción, solo de R3Foresta, y también requiere que quede otro administrador.

La gestión de perfiles organizacionales es una posible capacidad aparte. El administrador contextual no se hace equivalente al `ADMIN` global ni al `COORDINADOR` vigente sin validar el diseño y las restricciones existentes.

## 5. Vocabulario y conceptos de negocio

| Término | Significado y precisión |
|---|---|
| Afiliación / membresía organizacional | Vínculo opcional con una o varias organizaciones; independiente de la autorización operativa. |
| Organización seleccionada | Contexto o filtro cambiable de navegación/consulta; no otorga membresía, permisos ni crédito, ni debe ocultar otras subcampañas autorizadas para registrar. |
| Permiso contextual | Habilitación de una persona en una subcampaña con uno de los dos roles aprobados. |
| Asignación masiva de permisos | Otorgamiento sobre subcampañas actuales expresamente seleccionadas; no herencia ni permiso de campaña. |
| Campaña | Agrupación estratégica que puede asociar varias organizaciones y contener subcampañas. |
| Subcampaña | Unidad operativa de permisos, equipo, territorio, plan y stock. |
| Stock disponible | Plantas entregadas todavía elegibles para consumo por especie/asignación y propósito en esa subcampaña; compartidas por su equipo autorizado. |
| Asignación física | Entrega registrada por R3Foresta desde Vivero a una subcampaña. Su cantidad original permanece inmutable según contrato. |
| Registro de plantación | Un hecho físico registrado por cantidades de grupo/especie, con usuario responsable real, fecha y evidencia; puede incluir corresponsables identificados. El punto GPS corresponde al registro grupal, no a cada árbol. |
| Autoría / crédito | El registro conserva a su responsable real y las personas participantes que efectivamente consten; consulta común muestra quién plantó qué según esos datos, sin asumir que el registrante actuó solo ni multiplicar las cantidades grupales. Crédito, contribución o financiación organizacional es otra relación. No inferir todas las afiliaciones actuales del usuario como aportantes. |
| Mortandad | Pérdida de plantas ya plantadas; afecta vivos del grupo y no devuelve stock disponible. |
| Merma de stock de campo | Pérdida de plantas entregadas antes de plantar; concepto distinto, cuyo flujo y actor están pendientes. |
| Reposición | Nueva plantación vinculada que consume stock elegible y conserva la muerte histórica; adaptación de actor/revisión pendiente. |
| Anulación lógica / edición | Anulación conserva original y trazabilidad; edición sigue bajo evaluación con copia previa. Ninguna acción documental deshace por sí sola actividad física. |

**Propuesta mínima:** cantidades por grupo/especie, reutilizando el registro actual. Se priorizan plantaciones reales y cantidades correctas; un inventario individual de árboles y el reparto detallado de crédito no forman parte de la primera unidad. El modelo documentado permite mostrar plantado inicialmente por especie y saldo vivo total reportado, pero no derivar composición viva actual por especie: las muertes guardan una cantidad delta por registro/grupo sin identificar especie y la reposición puede usar otra especie. La vista por especie de sobrevivientes y el detalle de mortandad por especie/método quedan pendientes de una capacidad de datos adecuada.

## 6. Casos de uso y recorrido general

### 6.1. Primer recorrido: consultar stock, registrar y consultar plantación

| Campo | Contenido |
|---|---|
| Actor principal | Persona ya habilitada como plantador o administrador de la subcampaña. |
| Disparador | Necesita registrar lo realmente plantado en campo. |
| Condiciones generales | Permiso contextual y condiciones operativas vigentes; disponibilidad elegible por especie/asignación/propósito y meta suficiente. Afiliación organizacional detallada no es requisito. |
| Recorrido | 1. Acceder directamente al registro o elegir una subcampaña autorizada; una vía rápida desde Inicio con selector de subcampañas autorizadas es propuesta para explorar en el mockup. 2. Consultar el stock/objetivos pertinentes. 3. Ingresar los campos del registro acordados usando el flujo existente como referencia. 4. Revisar resumen. 5. Confirmar una vez. 6. Consultar detalle, responsable, evidencia y saldo actualizado. |
| Resultado | Registro con usuario real autenticado y subcampaña; consumo exacto del stock elegible y consulta del trabajo colectivo relevante. |
| Alternativas | Permiso inexistente o revocado; subcampaña no operativa; stock/meta insuficiente; datos/evidencia inválidos; contexto/GPS no evaluable; disponibilidad cambiante; reintento de guardado. |
| Por precisar | Campos comunes, fotos y participantes; presentación de stock/indicadores; consistencia técnica de autorización, guardado e idempotencia; correspondencia de roles y contrato técnico reutilizado. |

El mapa común es un recorrido de consulta separado: muestra el impacto/total plantado, el polígono como zona de trabajo y puntos por registro grupal. Tocar un área abre un resumen en la misma vista y permite avanzar a detalles y registros. Organización y campaña pueden servir de contexto o filtros cambiables; no son pasos obligatorios. El mapa no debe ser requisito para registrar ni un filtro organizacional debe esconder otras opciones autorizadas.

**Base reutilizada:** el [handoff inicial](05_handoff_registro_plantacion_inicial.md) describe evidencia/GPS, fecha, cantidades por especie, resumen y confirmación; observaciones y corresponsables opcionales del mismo equipo. El responsable es el usuario autenticado. Una plantación grupal se registra una vez, no una vez por participante.

**Modo del primer piloto, confirmado en la continuación de la revisión del 8 de octubre:** se trabaja con personas conocidas y de confianza, con registro directo. No se incorpora una aprobación previa del administrador ni un estado pendiente de esa aprobación. Antes de confirmar, quien llena el formulario puede revisar y corregir sus datos. El guardado mantiene las comprobaciones de autorización vigente, evidencia/GPS, cantidades, meta y stock; la confianza en el equipo no sustituye esas validaciones ni garantiza el guardado ante un error.

**Participantes y correcciones:** para el primer piloto se revisa la lista de participantes antes de confirmar y no se ofrece edición posterior de esa lista a quien registró ni al administrador. El responsable original se conserva. La revisión posterior del 8 de octubre confirma una salida excepcional: el administrador revisa el error y R3Foresta realiza una corrección vinculada al original, conservando quién la hizo, cuándo y por qué. Esta operación debe diseñarse y verificarse antes del piloto; sus campos y límites no se dan por definidos y no habilita un editor general. Los ajustes de cantidades requieren comprobar el hecho físico y sus efectos en saldos; no hay retorno automático de stock. La edición general y los recorridos de corrección de seguimiento siguen posteriores. La propuesta de que un administrador anule reportes de mortandad, incluida la restricción ante reposiciones, fue explorada pero no aprobada.

**Referencia GPS:** el handoff, §12, aclara advertencia y conservación de bandera/distancia fuera del polígono; la [migración 053](../database/migrations/053_m3_registrar_plantacion_sin_despacho.sql), bloque 4, no aborta por ese resultado y sí cuando no puede evaluar el GPS. La regla conceptual anterior RN-PLA-32 conserva un bloqueo fuera de tolerancia que debe alinearse con esa evidencia y verificarse contra la versión que se vaya a implementar. No se declara una comprobación nueva de producción.

### 6.2. Recorridos siguientes

| Recorrido | Flujo breve | Estado |
|---|---|---|
| Reportar muerte | Consultar grupo → registrar pérdida/evidencia → revisar vivos e historial. | Previsto; actor, revisión, conteo y correcciones pendientes. |
| Registrar reposición | Consultar pérdida pendiente → verificar stock elegible → registrar nueva plantación vinculada → consultar historial/vivos. | Relación y consumo confirmados; adaptación pendiente. |
| Gestionar plantadores | Seleccionar subcampañas actuales dentro de la autoridad propia → elegir usuarios ya registrados e incorporarlos directamente como plantadores → retirar permisos cuando corresponda. | Incorporación directa activa confirmada; sin solicitud pendiente ni aceptación de invitación en el MVP. Solicitudes podrían evaluarse después. |
| Designar, cambiar o retirar administradores | R3Foresta selecciona persona y subcampañas actuales para otorgar el rol, cambiar administrador a plantador o retirar todo acceso operativo. | Solo R3Foresta realiza estas acciones; cambio a plantador y retiro total requieren que quede otro administrador. Puede haber varios; no se puede retirar al último. No se acordó límite superior ni delegación entre administradores. |
| Anular/corregir | Consultar registro → cambio autorizado → motivo y efectos acordados → conservación de original/historial. | Anulación lógica deseada; autoridad, edición y efectos pendientes. |

Las pantallas pueden compartirse según acciones permitidas. No se requiere una organización única responsable del seguimiento para definir el equipo; esa exclusividad no fue aprobada.

### 6.3. Caso mínimo: equipo mixto y asignación masiva

Simulación con una campaña que contiene **Palca Norte** y **Palca Sur**:

| Persona | Palca Norte | Palca Sur | Palca Este, creada después |
|---|---|---|---|
| Ana | Administradora: planta y gestiona acceso del equipo. | Administradora, asignada junto con Norte en una acción masiva. | Sin acceso automático; necesita asignación expresa. |
| Carlos, afiliado a Scouts | Plantador autorizado, sin hacerse miembro de Palca. | Sin permiso operativo asignado. | Sin acceso automático. |

La administración central de R3Foresta designa a Ana en ambas subcampañas; Ana puede gestionar plantadores, pero no nombrar otros administradores. Una persona puede recibir administrador en una subcampaña y plantador en otra.

R3Foresta entrega **100 plantas** de una especie a Palca Norte. Dos registros independientes sobre árboles realmente distintos, por **30** y **20**, dejan **50 disponibles y 50 plantados**. Un registro grupal conserva un responsable y sus corresponsables, sin replicarse por cada integrante.

Una empresa financiadora puede vincularse con la actividad posteriormente; ese vínculo por sí solo no cambia stock ni total físico ni concede permiso de plantación. Tampoco obliga a atribuir crédito desconocido al guardar el registro. Los nombres y cantidades son ilustrativos, no hechos ejecutados.

### 6.4. Ejemplo conservado: stock y mortandad

Para una subcampaña autorizada, con una sola especie y sin devoluciones, mermas ni reposiciones:

| Momento | Disponibles | Plantados inicialmente | Vivos reportados | Muertos acumulados |
|---|---:|---:|---:|---:|
| Entrega de 10 plantas | 10 | 0 | 0 | 0 |
| Registro de 3 árboles | 7 | 3 | 3 | 0 |
| Reporte de 1 muerte | 7 | 3 | 2 | 1 |

Los 3 árboles pueden corresponder a un registro. La muerte no libera disponibilidad; una reposición requiere stock elegible y conserva el evento de muerte. Es una simulación.

## 7. Requisitos y restricciones de alto nivel

**Fuente de las confirmaciones del nuevo incremento:** decisión humana del 7 de octubre y aclaraciones del 8 de octubre de 2026, ADR-PLA-03. El estado documentado actual se distingue cuando corresponda.

| Comportamiento esperado | Estado |
|---|---|
| Autorizar por persona/subcampaña con plantador o administrador contextual; solo R3Foresta designa, cambia o retira administradores. R3Foresta o un administrador autorizado puede retirar permiso de plantador en su ámbito. | Confirmado; cambiar administrador a plantador conserva capacidad de registrar y requiere que quede otro administrador. Retirar todo acceso operativo a un administrador solo corresponde a R3Foresta y también protege al último. Varios administradores permitidos; adaptación técnica de la restricción vigente de un COORDINADOR pendiente. |
| En el piloto, permitir que el administrador incorpore directamente usuarios ya registrados como plantadores en sus subcampañas autorizadas; activar el permiso al incorporarlos. | Confirmado; sin captación espontánea, solicitud pendiente ni invitación con aceptación. Puede incluir personas independientes o voluntarias; solicitudes quedan para evolución posterior si se justifican. |
| Conceder permisos sobre subcampañas actuales seleccionadas en una acción; futuras requieren asignación expresa. | Confirmado; no rol de campaña ni herencia. |
| Separar permiso, afiliación/navegación y crédito/financiación. La consulta común de impacto muestra quién plantó qué según responsables y participantes realmente registrados, sin asumir plantación individual ni multiplicar cantidades grupales; “observador” describe esa experiencia, no un rol asignable. | Confirmado; campos de vistas y presentación de participantes pendientes. Mapa y puntos GPS aprobados son parte de esa vista; las demás fotos/campos y su publicación siguen pendientes. |
| Tener mapa común como entrada de consulta con impacto/total plantado; polígono de subcampaña como zona de trabajo y punto GPS por registro grupal. Tocar el área abre resumen en la misma vista y acceso progresivo a detalles/registros. | Confirmado para el nuevo incremento; no constituye paso obligatorio para registrar ni declara implementación. Campañas/organizaciones son contexto o filtros cambiables, no jerarquía obligatoria ni fuente de permisos/crédito. El default de organización de referencia sigue pendiente. |
| Permitir equipos mixtos e independientes, con stock compartido elegible de la misma subcampaña; financiar no concede permiso. | Confirmado. |
| Conservar usuario real responsable, subcampaña, fecha, cantidades y evidencia, además de corresponsables identificados según la base actual. | Confirmado y compatible con el registro documentado; adaptación por revisar. |
| Registrar una plantación física grupal una vez; no multiplicar el total por participantes, organizaciones o financiadores. | Confirmado. |
| Usar registro directo para el primer piloto de personas conocidas, con revisión antes de confirmar y sin aprobación previa del administrador. | Confirmado el 8 de octubre; mantiene las validaciones y el consumo de stock documentados. No incorpora un estado pendiente de aprobación ni habilita edición de participantes después de guardar. |
| Contar con una corrección excepcional a cargo de R3Foresta, con revisión del administrador y conservación del original, responsable e historial. | Autoridad confirmada el 8 de octubre; operación por diseñar y verificar antes del piloto. Campos, límites y efectos en saldos se precisan en la spec y el plan. No es edición libre ni una operación ya disponible. |
| No exigir atribución organizacional detallada para registrar ni inferir aportes desde todas las afiliaciones actuales; cambios de afiliación no reescriben el significado histórico. | Confirmado; correlación/crédito posterior pendiente. |
| Consumir stock elegible por especie/asignación/propósito sin excederlo ni producir negativo, también con usuarios simultáneos; mantener meta y condiciones operativas vigentes. | Confirmado; coherente con contrato y RN-PLA-18/24. Mecanismos en el plan técnico. |
| Retirar permiso de plantador inmediatamente, conservando registros ya guardados, autoría e historial y consulta del detalle de sus propias plantaciones; aplicar los resultados por estado del formulario, envío pendiente de autorización, operación ya autorizada y registro guardado. | Confirmado según el cuadro de retiro y guardados en curso; la lectura propia no restaura operación ni acceso interno al equipo/stock. La implementación/plan técnico debe ordenar consistentemente autorización/guardado y retiro. Retiro de afiliación no revoca automáticamente. |
| Distinguir disponible, plantado, vivo, muerto y repuesto. Muerte posterior a plantar no devuelve stock; merma anterior a plantar es un hecho diferente. | Confirmado; flujo de merma pendiente. |
| Reponer conservando muerte histórica y consumiendo disponibilidad elegible. | Confirmado; actor, revisión y detalle pendientes; base RN-PLA-28..31. |
| Anular lógicamente conservando original/autor/fecha/motivo; no devolver stock automáticamente. Si se habilita edición, conservar versión previa. | Anulación deseada confirmada; autoridad, efectos y edición pendientes. |
| Mantener entregas y su corrección bajo responsabilidad de R3Foresta. Solicitudes de plantas fuera del alcance actual. | Confirmado; cantidad asignada inmutable conforme al contrato vigente. |
| Mostrar composición inicial por especie y saldo vivo total reportado; no afirmar composición viva actual por especie con los datos documentados. | La capacidad actual de mortandad guarda cantidad_muerta_delta por registro/grupo sin planta_id y reposición permite otra especie. Mortandad por especie/método y composición viva derivable quedan pendientes. |

El stock limita cantidades consumidas, pero no identifica por sí solo árboles físicos diferentes. La propuesta de grupos/especies requiere tratamiento de reintentos y duplicados, preservando el hecho físico y los límites de cantidades.

## 8. Riesgos, decisiones abiertas y viabilidad

La unidad de autorización, los dos roles, el stock compartido de subcampaña, la ausencia de herencia, la designación y el retiro central del rol de administrador, la incorporación directa de usuarios ya registrados como plantadores y la navegación del mapa común ya están resueltos como decisiones de producto. La delegación de nombramientos y las solicitudes de acceso no forman parte del MVP. No se aprueba con ello el detalle visual, los campos publicados, la implementación ni el cierre LCO.

Los pendientes se agrupan por decisión práctica. Varios aspectos visuales pueden explorarse en el primer boceto sin convertirse por ello en requisitos aprobados. P0 condiciona la primera spec/código; P1 los recorridos siguientes; P2 las ampliaciones. Responsable de reglas: usuario/dominio; contraste técnico: responsable de implementación por asignar.

**A. Para el primer mockup (no bloquea dibujar):**

| Tema | Propuesta o pendiente concreto |
|---|---|
| Vía rápida del plantador | Probar desde Inicio un botón «Registrar» y selector de subcampañas autorizadas. Es propuesta priorizada; no está aprobada la pantalla, selector ni ruta exacta. Debe seguir accesible el registro autorizado en otra organización aunque el mapa tenga un filtro organizacional. |
| «Mis» aportes y participantes | Explorar listado «Todas/Mis contribuciones» y si «mis» incluye responsable y corresponsable. Decidir cómo distinguir participantes históricos del equipo actualmente habilitado; ninguno de estos comportamientos está confirmado. |
| Campos comunes y evidencia | Definir qué se ve en mapa/resumen/detalle, si hay fotos públicas y cómo se muestran responsables y participantes registrados. El mapa/polígono/puntos y progresión están confirmados; publicación de fotos y roster no. |
| Stock e indicadores | Explorar presentación por especie y propósito inicial o reposición. El desglose por asignación/lote queda como trazabilidad interna fuera de la vista principal, según el handoff. El dato permite mostrar plantado inicialmente por especie y saldo vivo total reportado; no afirmar vivos por especie. La presentación concreta de indicadores sigue pendiente. |

**B. Antes de la primera spec/código:**

| Prioridad | Tema pendiente | Tratamiento |
|---|---|---|
| P0 | Correspondencia de PLANTADOR/ADMINISTRADOR DE SUBCAMPAÑA frente a roles globales y COORDINADOR/OPERARIO; adaptación de la restricción de un coordinador para permitir varios administradores y proteger al último. | Diseñar esquema/transiciones; no equiparar administrador contextual con ADMIN global ni con COORDINADOR. Definir también el acceso interno de R3Foresta y participación voluntaria sin presumir permiso universal. |
| P0 | Autorización backend, revocación y guardado. | Especificar comprobación vigente y orden consistente para los cuatro casos de retiro de §2; incluir idempotencia y reintentos. |
| P0 | Contrato GPS y campos exactos de unidad. | Alinear RN-PLA-32 con handoff/migración 053 y precisar foto, GPS, fecha, cantidades por especie, observaciones/corresponsables, resumen y errores con la evidencia vigente. |
| P0 | Corrección excepcional de registros del piloto por R3Foresta, con revisión del administrador. | Precisar casos cubiertos y límites, original e historial, campos corregibles, efectos sobre cantidades/saldos/estados y mecanismo autorizado. Preparar y verificar antes del piloto; no presumir que un contacto humano repara los datos ni que anular devuelve stock. |

**C. Para recorridos posteriores:**

| Prioridad | Tema pendiente | Tratamiento |
|---|---|---|
| P1 | Mortandad/reposición: actor, revisión, límites y detalle por grupo/especie/método. | No derivar composición viva por especie del modelo actual: `cantidad_muerta_delta` no identifica `planta_id`, y reposición puede ser de otra especie. Definir capacidad de datos si ese desglose es necesario. |
| P1 | Merma de stock entregado antes de plantar. | Separar de mortandad y merma de Vivero; decidir actor y alcance. |
| P1 | Anulación, correcciones y edición generales; efectos sobre seguimientos y saldos. | Conservar el original y definir autoridad, límites y efectos de los recorridos posteriores. La excepción central del primer piloto se trata en P0; no habilita correcciones de mortandad/reposiciones por el administrador. Anular no devuelve stock automáticamente. Corrección de entrega es capacidad separada de R3Foresta. |
| P1 | Afiliación organizacional histórica e inactivación de organización/asociación de campaña. | Definir presentación de atribución sin inferir aportes, revocar permisos ni multiplicar totales. |
| P2 | Aportes externos de plantas, superficie realmente plantada y gestión de perfiles/membresías. | Delimitar cuando exista necesidad; el mapa actual no deriva superficie plantada y no cambia el plan frontend histórico del MVP operativo. |

**Tratamiento de riesgos ligado al plan inicial aceptado:**

| Riesgo | Tratamiento y evidencia esperada |
|---|---|
| Desorientación o error involuntario al registrar. | Bocetar acceso rápido, cantidades claras y resumen revisable. Observar si una persona completa el recorrido sin guía y reconoce el guardado. |
| Permisos mal aplicados o revocación inconsistente. | Matriz contextual y adaptación de roles/restricciones; definir el orden de autorización, guardado y retiro. Verificar usuarios autorizados, no autorizados, retiro en curso y protección del último administrador. |
| Reenvíos, doble registro del mismo trabajo grupal o consumo incorrecto con simultaneidad. | Definir idempotencia y consumo consistente. Verificar reintentos y operaciones concurrentes. Acordar quién registra cada trabajo grupal: dos envíos independientes sobre el mismo hecho físico no quedan resueltos únicamente por idempotencia. |
| Advertencias/bloqueos de GPS incoherentes. | Alinear el contrato y probar punto dentro, fuera y no evaluable sobre la versión del piloto. |
| Error guardado sin una salida real de corrección. | Preparar la excepción de R3Foresta con original, motivo e historial; verificar sus efectos según el hecho físico. La autoridad está confirmada y la solución aún debe concretarse. |

**Viabilidad:** existe una base documental y una migración local para el flujo inicial. La nueva política requiere correspondencia/migración de roles y restricciones, comprobación de permisos en backend e interfaz, responsables y estimación. No se declara implementación terminada ni compatibilidad automática del esquema actual.

## 9. Prioridad y plan inicial

El usuario acepta el siguiente orden como plan inicial en la revisión por voz del 8 de octubre de 2026. Prioriza el valor del registro y el tratamiento temprano de riesgos; no aprueba specs ni declara implementación. Las ventanas intermedias y el esfuerzo se refinan tras el contraste técnico; la fecha de campo es un objetivo sujeto a preparación.

| Orden | Qué abordar y por qué | Qué resolver antes | Evidencia para revisar el avance |
|---|---|---|---|
| 1 | Bocetar acceso → formulario → confirmación → detalle con persona ya habilitada. Es el objetivo principal y reutiliza el registro existente. | Subcampaña de ejemplo, stock/meta y campos de referencia. El botón/selector concreto se decide en el boceto. | Recorrido simulado con equipo mixto, resumen revisable y registro grupal único; dificultades y decisiones anotadas. |
| 2, en paralelo con 1 | Contrastar los P0: roles/restricciones, autorización y retiro, GPS, reintentos, consumo y corrección excepcional. Pueden cambiar viabilidad y esfuerzo. | Acuerdos de producto y evidencia técnica vigente, diferenciada de propuestas. | Matriz de permisos, discrepancias documentales, decisiones técnicas, esfuerzo inicial y casos de prueba previstos. |
| 3 | Redactar la primera spec de registro inicial y su plan. Convierte el recorrido en comportamiento verificable. | Para aprobarla como implementable: campos, precondiciones, resultados, rechazos y P0 del comportamiento definidos. Un borrador puede señalar preguntas pendientes. | Spec revisada por el usuario, plan técnico y tareas vinculadas a criterios de aceptación. |
| 4 | Concretar consulta del mapa, gestión básica de acceso y corrección excepcional en unidades pequeñas. Completan el alcance mínimo y la salida ante errores. | Campos de consulta/visibilidad adoptados; adaptación de varios administradores y protección del último; mecanismo y límites de corrección. | Bocetos/specs necesarios y casos de permisos, consulta y corrección con original e historial. |
| 5 | Implementar, integrar y revisar la preparación. Comprueba que el alcance funciona sobre datos consistentes. | Comportamientos y planes revisados; no implementar decisiones pendientes por inferencia. | Versión identificada y resultados de permisos/revocación, GPS, reintentos, concurrencia, cantidades/stock y corrección excepcional. |
| 6 | Prueba de campo objetivo del 15 de octubre. Evalúa utilidad y facilidad reales. | Alcance mínimo y controles preparados; revisión previa de viabilidad y preparación. | Observación sin guía paso a paso, registro correcto, dificultades, errores y acciones siguientes documentados. |

Mortandad, reposición y después merma y edición/correcciones generales mantienen sus recorridos posteriores. La gestión de acceso y la excepción central son condiciones del primer piloto; no se posponen por el orden de los recorridos de seguimiento.

**Siguiente paso:** simular en cuaderno el caso de Carlos habilitado en Palca Norte, consultando stock, registrando una plantación por grupo/especie y revisando el detalle colectivo. Usar campos existentes y mantener crédito organizacional fuera del requisito de guardar.

**Paso al diseño:** recorrer esa unidad sin pasos faltantes y con resultados/rechazos comprensibles. **Paso a spec implementable:** actor/permisos, campos, efecto sobre stock, resultado y errores definidos; correspondencia técnica de roles explicitada en el plan. No es necesario diseñar todo ni cerrar estética para avanzar.

### 9.1. Fecha objetivo y ventanas semanales tentativas

**Fecha objetivo confirmada por el usuario:** primera prueba en campo el jueves 15 de octubre de 2026, una semana después de esta revisión. Es una meta de preparación; no acredita que el sistema esté listo ni que el esfuerzo haya sido estimado técnicamente.

| Ventana propuesta | Trabajo | Producto o comprobación |
|---|---|---|
| 8–9 de octubre | Elaboración: recorrer y bocetar registro/consulta; contrastar la base técnica y precisar la excepción de corrección. | Recorrido revisado, dudas decisivas y primera valoración de esfuerzo/viabilidad para la semana. |
| 10–11 de octubre | Elaboración: primera spec y plan técnico de permisos, roles, GPS, stock, reintentos y corrección excepcional. | Reglas verificables, casos de error, mecanismo y tareas priorizadas. |
| 12–14 de octubre | Construcción y preparación del piloto, solo sobre comportamientos definidos y revisados. | Adaptaciones necesarias y verificaciones sobre una versión identificada; revisión de preparación antes de campo. |
| 15 de octubre | Prueba de campo objetivo, sujeta a preparación. | Observar acceso y registro sin guía; comprobar guardado, cantidades, stock y dificultades reales. |

**Responsabilidades del plan inicial:** el usuario valida reglas y boceto, asume la implementación técnica según el modo de trabajo del repositorio y coordina la prueba de campo. La IA apoya revisión y documentación, sin autoridad de aprobación. En operación, el administrador revisa errores y R3Foresta ejerce la corrección excepcional mediante el procedimiento definido.

**Condición de viabilidad del plazo:** la primera valoración técnica debe confirmar qué adaptaciones faltan y su esfuerzo. Si el recorrido mínimo acordado o sus controles críticos y corrección excepcional no están preparados y verificados, se revisa la fecha del piloto operativo; no se declara completado por llegar al día previsto. El identificador de iteración y la estimación técnica se concretan en el plan; esta ventana propuesta no modifica por inferencia el cronograma global del proyecto.

## 10. Revisión del encuadre

La revisión LCO de este incremento usa los criterios de Inicio y control de hitos de la [metodología de desarrollo](../documentacion-grado/04_metodologia/metodologia_desarrollo.md#35-control-de-los-hitos): acordar alcance, objetivos, riesgos, viabilidad y planificación para autorizar el paso a Elaboración. Su aprobación requiere una decisión humana registrada. No acredita el cierre LCO del proyecto completo.

### 10.1. Revisión de cierre de Inicio

- [x] Decisión humana del 7 de octubre registrada: subcampaña, dos roles, asignación masiva actual sin herencia y designación central de administradores sin delegación en el MVP.
- [x] Confirmar el alcance mínimo del primer piloto: registro de plantación inicial, consulta común mediante mapa y gestión básica de acceso. Corrección excepcional central aceptada como salida ante errores; seguimiento y edición general en recorridos posteriores.
- [x] Acordar el objetivo y la evidencia esperada de éxito del piloto: acceso rápido, registro en pocos pasos, recorrido sin guía paso a paso y reconocimiento del guardado correcto; comprobar cantidades y ausencia de duplicación (§2 y §6).
- [x] Acordar el tratamiento temprano de riesgos mediante boceto, contraste técnico, specs y verificaciones del plan inicial. La viabilidad documental se condiciona a confirmar adaptaciones y esfuerzo en Elaboración; no se declaran riesgos técnicos resueltos.
- [x] Acordar responsabilidades, secuencia, productos y fecha objetivo de campo del plan inicial. Ventanas intermedias tentativas; estimación técnica e identificador de iteración se refinan durante el contraste, sin modificar por inferencia el cronograma global.
- [x] Registrar decisión de salida, persona que revisa, evidencia y condiciones aceptadas: revisión humana del 8 de octubre y autorización de Elaboración en §10.3–10.4.

**Alcance mínimo acordado del primer piloto — LCO del incremento cerrado:** registro de plantación inicial y consulta del resultado colectivo, con autorización contextual y gestión básica de acceso. Incluye designación/cambio/retiro de administradores por R3Foresta, incorporación/retiro de plantadores en su ámbito y selección masiva sobre subcampañas actuales. La primera unidad se especifica con una persona ya habilitada; el orden documental de los recorridos no elimina la necesidad de gestionar y comprobar permisos antes de habilitar el piloto.

La consulta común conserva el mapa y su progresión ya acordados. Acceso rápido, «Mis contribuciones», participantes históricos, publicación de fotos, campos de resumen/detalle e indicadores se exploran durante Elaboración; el comportamiento y la visibilidad necesarios se acuerdan antes de implementar cada unidad. La salida excepcional ante errores del piloto corresponde a R3Foresta, con revisión del administrador y operación por definir antes de campo. Mortandad, reposición, merma y edición/correcciones generales se revisan en sus recorridos posteriores. Este límite de la primera unidad no los declara descartados del producto ni aprueba sus detalles.

**Viabilidad inicial de referencia:** reutilizar el registro, las entregas físicas y el consumo de stock documentados. Los riesgos principales son la adaptación de roles y cardinalidad de administradores, la autorización/revocación consistente, los reintentos y duplicados, y la alineación del contrato GPS. El plan aceptado empieza contrastando la base técnica y su esfuerzo para confirmar la viabilidad del plazo. La limitación de composición viva por especie se conserva como restricción de consulta y pendiente de los recorridos de seguimiento. Esta valoración se basa en documentos y SQL locales; no aporta una auditoría nueva de despliegue ni una estimación de esfuerzo validada.

**Plan inicial aceptado:** recorrer y bocetar registro/consulta con contraste técnico de riesgos en paralelo; preparar la primera spec y el plan técnico de los P0, incluida la corrección excepcional; concretar consulta y gestión de acceso mediante unidades pequeñas. Fecha objetivo de campo confirmada para el 15 de octubre; responsabilidades y ventanas tentativas en §9.1. Productos esperados: recorrido revisado, spec prioritaria, correspondencia de permisos/roles y plan de verificación de riesgos. El paso a Construcción del comportamiento afectado requiere sus reglas y mecanismos definidos. La estimación técnica y el encaje de iteración se refinan con el contraste de la base actual.

### 10.2. Evidencias posteriores al cierre de Inicio

Estas evidencias mantienen su carácter pendiente, pero su finalización corresponde a Elaboración, Construcción o validación del piloto:

- [ ] P0 resueltos para aprobar la primera spec implementable y su plan.
- [ ] Correspondencia/migración de roles y restricciones diseñada y contrastada.
- [ ] Bocetos y diagramas necesarios alineados con las decisiones y revisados.
- [ ] Pruebas de permisos, revocación, reintentos, concurrencia, GPS y consumo de stock registradas sobre una versión identificada.
- [ ] Validación operativa y revisión de entrega registradas.

### 10.3. Balance de la revisión y paso a specs

**Quién revisó:** el usuario tomó las decisiones humanas en conversaciones del 7 y 8 de octubre, incluida la revisión por voz. La IA apoyó el contraste documental, las propuestas y su registro; no ejerce autoridad de aprobación. No se acredita una revisión técnica independiente, un despliegue nuevo ni una prueba de campo realizada.

**Acordado:** autorización por persona/subcampaña; alcance mínimo de registro inicial, mapa y gestión de acceso; objetivo de acceso rápido y registro sencillo, con recorrido sin guía y reconocimiento del guardado; piloto de personas conocidas con registro directo; revisión de participantes antes de confirmar; excepción de corrección por R3Foresta con revisión del administrador, original e historial; fecha objetivo de campo del 15 de octubre; orden, responsabilidades y productos del plan inicial, con tratamiento temprano de riesgos y plazo sujeto a preparación.

**Salida LCO registrada:** tras revisar el encuadre, el usuario expresa conformidad y autoriza iniciar el trabajo acordado en la conversación por voz del 8 de octubre; a continuación confirma el cierre de Lifecycle Objectives. El plan inicial está aceptado; la estimación técnica y el identificador de iteración se concretan al contrastar la base durante Elaboración, con revisión del plazo si no resulta viable. La decisión no exige mecanismos implementados ni todas las pantallas terminadas.

**Primera spec propuesta:** «Registrar una plantación inicial en una subcampaña autorizada». Se puede redactar su borrador con el actor ya habilitado, campos existentes como referencia, recorrido, resultado, alternativas, consumo único y criterios de aceptación. Debe señalar las preguntas técnicas y de producto aún abiertas. Aprobarla como implementable requiere resolver los P0 que afecten su comportamiento; comenzar un borrador no constituye por sí solo aprobación LCO, LCA o autorización de despliegue. Consulta, gestión de acceso y excepción de corrección requieren sus unidades específicas antes del piloto, sin integrarlas por defecto en una spec única de todo el módulo.

**Decisión de salida aprobada por el usuario el 8 de octubre de 2026:** cerrar LCO de este incremento y autorizar Elaboración con el alcance, objetivo y acuerdos registrados; adoptar el tratamiento de riesgos y el plan inicial aceptado. El usuario valida reglas y bocetos, asume implementación y coordina campo; la IA apoya análisis y documentación. Elaboración contrasta la base técnica, precisa esfuerzo/iteración, redacta specs y planes y resuelve los P0 antes de construir el comportamiento afectado. La prueba del 15 de octubre es objetivo sujeto a preparación y verificación, incluida la corrección excepcional; se revisa el plazo si faltan condiciones críticas. La decisión no aprueba una spec completa, una entrega, LCA ni el cierre LCO del proyecto global. Se autoriza preparar el boceto, las specs en borrador y los cuatro diagramas mediante agentes paralelos; esos artefactos requieren su propia revisión.

### 10.4. Registro de decisiones

| Fecha | Persona que revisa | Decisión | Condiciones o pendientes | Evidencia |
|---|---|---|---|---|
| 7 de octubre de 2026 | Usuario, decisión humana | Aprobar autorización por persona/subcampaña, designación/cambio/retiro de administradores por R3Foresta, varios administradores sin retirar al último, incorporación directa de usuarios registrados como plantadores y retiro inmediato de permiso operativo. Al cambiar administrador a plantador se conserva registro y debe quedar otro administrador; al retirar permiso de plantador queda consulta común y detalle propio guardado. | Adaptación técnica de la restricción vigente de un COORDINADOR y de transiciones pendiente; campos y presentación de consulta por definir. Consistencia técnica del guardado por especificar; sin aprobación global de spec ni cierre LCO. | Conversación humana del 7 de octubre de 2026 y ADR-PLA-03. |
| 8 de octubre de 2026 | Usuario, decisión humana | Confirmar mapa común del nuevo incremento MVP con impacto/total plantado como entrada; tocar el polígono abre resumen en la misma vista, con acceso progresivo a detalles/registros. Organización y campaña contextualizan o filtran, sin recorrido obligatorio organización→campaña→subcampaña. En el resumen, consulta ve impacto/registros; persona autorizada también stock relevante y registro sujeto a condiciones operativas; administrador gestiona plantadores, sin nombrar administradores. El acceso rápido al registro desde Inicio se apoya como propuesta priorizada, sin aprobar pantalla/selector. | Un punto GPS por registro grupal; polígono indica zona de trabajo, no superficie efectivamente plantada. El filtro no da permisos/crédito ni oculta otras opciones de registro autorizadas. Default de organización, fotos, roster frente a participantes históricos, “mis contribuciones” (incluida corresponsabilidad) y presentación de stock/indicadores siguen pendientes. Los datos no derivan vivos por especie. Sin auditoría nueva de app/despliegue, implementación acreditada ni cierre LCO; no cambia el plan frontend histórico. | Conversación humana del 8 de octubre de 2026 y aclaración de ADR-PLA-03. |
| 8 de octubre de 2026, continuación de la revisión LCO | Usuario, decisión humana | Confirmar como objetivo prioritario acceso rápido y registro sencillo con reconocimiento del guardado correcto; evaluar que la persona complete el recorrido sin guía paso a paso. Mantener el primer piloto sencillo, con personas conocidas y registro directo, sin aprobación previa del administrador. Revisar participantes antes de confirmar y conservar la lista sin edición posterior en esa primera unidad. | La confianza mantiene las comprobaciones de permisos, evidencia/GPS, cantidades, meta y stock. Correcciones con historial, facultades del administrador para anular bajas y efectos ante reposiciones siguen pendientes de sus recorridos; no se aprueban por la discusión exploratoria. Tratamiento completo de riesgos, viabilidad, responsables, estimación, iteración y decisión formal de paso a Elaboración siguen en revisión. Sin prueba de campo ejecutada ni cierre LCO. | Conversación humana de revisión por voz del 8 de octubre de 2026 y acuerdos de piloto de ADR-PLA-03. |
| 8 de octubre de 2026, confirmación del alcance sencillo | Usuario, decisión humana | Mantener el alcance mínimo del primer piloto: registro inicial, consulta común del mapa y gestión básica de acceso, con registro directo y revisión antes de confirmar. Continuar con tratamiento de riesgos y planificación; trabajar las correcciones en su recorrido posterior. | La propuesta de corrección excepcional a cargo de R3Foresta requiere concretar alcance, autoridad y efectos antes de habilitarla; no se declara una operación de mantenimiento disponible ni una reparación automática de saldos. Sin cierre LCO ni aprobación de spec. | Conversación humana de continuación: conformidad con el piloto sencillo y solicitud de continuar con las siguientes partes. |
| 8 de octubre de 2026, acuerdo de salida ante errores y fecha objetivo | Usuario, decisión humana | Aceptar la corrección excepcional a cargo de R3Foresta, vinculada al original y con historial, con el administrador revisando el caso; preparar y verificar la operación antes del piloto, sin editor general. Fijar primera prueba de campo objetivo dentro de una semana: 15 de octubre de 2026. | Se precisa en Elaboración qué casos/campos cubre y cómo afecta saldos y estados. No autoriza anular mortandad por el administrador ni un retorno automático de stock. Calendario detallado, responsabilidades propuestas, viabilidad del plazo y decisión de paso a Elaboración pendientes de revisión formal. | Transcripción por voz: propuesta de corrección excepcional de R3Foresta, respuesta humana «Sí»; respuesta a fecha de campo «dentro de una semana». |
| 8 de octubre de 2026, aceptación del plan inicial | Usuario, decisión humana | Aceptar el orden de trabajo presentado: boceto de registro y resultado; contraste técnico de permisos, roles, stock, GPS y corrección excepcional en paralelo; specs y planes pequeños; implementación/integración y preparación de la prueba de campo del 15 de octubre con controles críticos. | Mantener responsabilidades del plan inicial. Ventanas intermedias tentativas; esfuerzo e iteración por precisar en el contraste técnico. Specs, mecanismos y resultados de pruebas no se consideran aprobados o ejecutados por aceptar el plan. Sigue pendiente la decisión formal LCO de paso a Elaboración. | Conversación por voz y plan presentado en la ficha; confirmación humana «podemos ir con este plan». |
| 8 de octubre de 2026, cierre de la revisión humana | Usuario, decisión humana | Tras revisar lo anterior, confirmar conformidad con el encuadre y autorizar el inicio del plan acordado: cierre LCO del incremento y paso a Elaboración. Autorizar boceto, specs y cuatro diagramas con agentes paralelos y organización de carpetas por criterio del proyecto. | Resolver los P0 antes de aprobar como implementable o construir el comportamiento afectado; precisar esfuerzo e iteración. La prueba del 15 de octubre sigue sujeta a preparación y verificación. No aprueba una spec completa, LCA, despliegue ni cierre LCO del proyecto global. | Conversación por voz del 8 de octubre de 2026, después de la pausa de revisión: conformidad explícita con lo revisado, autorización de iniciar todo el plan y continuación sobre el cierre de Lifecycle Objectives. |

Las filas anteriores conservan el estado de cada momento de revisión. La decisión final cierra Inicio únicamente para este incremento; la aprobación de política y encuadre no sustituye revisión técnica, pruebas ni aceptación de entrega.

## Diagramas para este encuadre

La siguiente selección es una recomendación práctica para esta capacidad. RUP adaptado conserva el modelo inicial de casos de uso, pero no obliga a producir todos los tipos de diagramas para cada capacidad.

### D1. Contexto y límites — recomendado en Inicio

**Pregunta:** ¿quién interactúa con esta capacidad y con qué procesos intercambia información?

**Mostrar:** sistema como una caja; actores externos; fuentes de información o procesos relacionados; entradas y resultados principales. Marcar el límite del alcance seleccionado.

**En esta capacidad:** plantador, administrador de subcampaña y administración central de R3Foresta; consulta común de impacto, entrega de plantas y registro/seguimiento. Separar permiso operativo, afiliación/navegación y financiación/crédito. Las fuentes pueden ser capacidades internas existentes; indicarlas como tales para evitar presentarlas como sistemas externos.

**Nivel:** negocio. Una caja por participante o sistema/proceso relevante; dejar para el diseño las tecnologías y servicios internos.

### D2. Casos de uso de alto nivel — producto de Inicio

**Pregunta:** ¿qué objetivos alcanza cada actor al interactuar con el sistema?

**Mostrar:** actores fuera del límite del sistema y casos de uso dentro. Usar nombres con verbo y objetivo. Asociar cada actor con los casos en los que interviene.

**En esta capacidad:** consultar stock/trabajo colectivo y registrar plantación por plantador o administrador contextual. Mostrar designación, cambio y retiro de administradores por R3Foresta, y gestión contextual de plantadores, con selección de subcampañas actuales. Consulta de impacto es experiencia común, sin rol observador asignable; muerte/reposición, anulación y adaptación técnica de transiciones conservan sus pendientes.

**Notación sugerida:** UML de casos de uso. Agregar relaciones `include` o `extend` únicamente cuando su significado aporte claridad y el comportamiento esté definido.

### D3. Actividades o flujo de negocio — recomendado en Inicio

**Pregunta:** ¿cómo se realiza el recorrido, quién responde por cada paso y cómo termina?

**Mostrar:** inicio, actividades principales, participantes, decisiones de negocio y finales: completado, rechazado o abandonado cuando corresponda. Usar carriles para distinguir responsabilidades si ayuda a entenderlo.

**En esta capacidad:** acceso al registro en una subcampaña autorizada → stock → registro → confirmación → detalle; en el recorrido de consulta, mapa → resumen en la misma vista → detalles/registros. Después, mortandad/reposición, acceso y correcciones. La selección masiva termina en permisos para subcampañas actuales, sin herencia futura. Distinguir actividad física de registro y no hacer del mapa un paso operativo obligatorio.

**Nivel:** recorrido general. Las respuestas a cada validación y los fallos técnicos se detallarán en la spec.

### D4. Modelo conceptual del dominio — útil para esta capacidad

**Pregunta:** ¿qué conceptos se relacionan y qué responsabilidad representa cada relación?

**Mostrar:** persona, permiso por subcampaña, campaña agrupadora, equipo mixto, stock por asignación/especie/propósito, registro, corresponsables y seguimiento. Afiliación organizacional y financiación/crédito se representan como relaciones distintas, sin herencia de permisos ni obligatoriedad de crédito al registrar.

**Motivo en este caso:** mostrar que Carlos puede operar en Palca por permiso contextual aunque esté afiliado a Scouts, y que la empresa financiadora no obtiene permiso ni multiplica cantidades. La autorización por subcampaña está confirmada; el detalle de atribución se desarrollará después.

**Nivel:** conceptos de negocio. Incorporar cardinalidades solo cuando estén acordadas. Puede iniciarse en este encuadre y profundizarse durante Elaboración.

### Diagramas a desarrollar después, según el riesgo

| Diagrama | Cuándo aporta valor | Momento habitual en este proyecto |
|---|---|---|
| Estados | Para precisar vigencia/revocación del permiso contextual y estados de operaciones o recursos. | Spec y Elaboración. |
| Secuencia | Para comprobar la interacción entre autorización, registro y consumo, especialmente ante errores o concurrencia. | Plan técnico y Elaboración. |
| Entidad-relación | Para precisar persistencia, relaciones y restricciones. | Diseño en Elaboración; refinamiento en Construcción. |
| Componentes o despliegue | Cuando la capacidad cambia responsabilidades técnicas o infraestructura. | Plan técnico; actualizar arquitectura existente. |
| Mockups | Para revisar comprensión, datos y recorrido con usuarios. | Cuando ayuden a aclarar requisitos; desde Inicio y durante Elaboración. |

Los mockups complementan la revisión del flujo. La matriz de responsabilidades complementa los diagramas cuando es necesario describir permisos; puede bastar una tabla para evitar otro dibujo.

**Ficha que debe acompañar cada diagrama:** nombre, pregunta que responde, fuente, estado de revisión y decisiones pendientes. Los cuatro dibujos deben utilizar el mismo vocabulario y representar el mismo alcance.

## Cómo alimentar las specs posteriores

| Material de este encuadre | Uso posterior |
|---|---|
| Problema, objetivo y valor | Propósito de la feature y de sus capacidades. |
| Alcance y exclusiones | Límites de las specs. |
| Actores y responsabilidades | Permisos por persona/subcampaña, con dos roles y selección masiva actual sin herencia. |
| Caso de uso y actividades | Escenarios, precondiciones, alternativas y postcondiciones. |
| Glosario y modelo conceptual | Conceptos y relaciones consistentes entre specs. |
| Requisitos y restricciones | Reglas, invariantes y criterios de aceptación. |
| Riesgos y decisiones | Clarificaciones prioritarias y comprobaciones del plan técnico. |
| Plan inicial | Selección de capacidades para la iteración correspondiente. |

La feature describe el resultado amplio; cada capability spec concreta un comportamiento verificable. Las component specs se utilizarán cuando una responsabilidad o contrato técnico necesite una definición propia. El detalle habitual puede permanecer en el plan técnico.

Cada afirmación propuesta debe revisarse antes de adoptarse como regla. Conservar referencias a este documento y a las fuentes canónicas para evitar copiar contenido que luego pueda divergir.

## Contraste específico con R3Foresta

- **Base documentada actual:** roles globales cerrados y equipo de subcampaña con COORDINADOR/OPERARIO, exactamente un coordinador y restricciones de participación. El handoff exige rol global operativo y pertenencia al equipo; la migración 053 comprueba pertenencia con esos nombres.
- **Nuevo incremento aprobado, pendiente de implementación:** PLANTADOR y ADMINISTRADOR DE SUBCAMPAÑA por persona/subcampaña. R3Foresta designa administradores; el administrador contextual planta y gestiona plantadores sin otorgar rol de administrador. Su correspondencia con roles globales/equipo y los cambios de restricciones/migración están pendientes; no se equipara directamente con ADMIN o COORDINADOR. El acceso rápido desde Inicio es propuesta, no navegación aprobada en detalle.
- **Mapa común del nuevo incremento:** entrada de consulta con impacto/total plantado; polígono de zona de trabajo por subcampaña y un punto GPS por registro grupal. Tocar área abre resumen en la misma vista y detalles/registros progresivos. No es paso obligatorio de registro; campaña/organización son contexto/filtros cambiables, y el filtro no oculta registros autorizados en otras organizaciones.
- **Límite de conteos por especie:** puede presentarse cantidad inicial plantada por especie y saldo vivo total reportado. El modelo documentado de mortandad guarda `cantidad_muerta_delta` por registro/grupo sin `planta_id`, mientras reposición puede usar otra especie; no se debe prometer composición viva actual por especie. Detalle de mortandad por especie/método requiere definir datos/capacidad.
- **Stock vigente conservado:** asignaciones físicas a subcampaña, especie y propósito; plantación consume ese stock sin descontar otra vez el lote de Vivero. La participación mixta no divide automáticamente el stock por organización.
- **Organizaciones y crédito:** asociación de organizaciones con campañas permanece como contexto; no es fuente de permisos ni propiedad exclusiva. Se separa afiliación de participación/financiación histórica, sin inferir aportes ni duplicar plantaciones.
- **GPS con evidencia local:** handoff y migración 053 coinciden en conservar el resultado fuera del polígono y bloquear GPS no evaluable. RN-PLA-32 contiene la regla conceptual anterior; corresponde alinear su vigencia al preparar la implementación, no tratar el comportamiento como desconocido sin referencias.
- **Historial:** el registro vigente es append-only. Anulación lógica deseada y eventual edición necesitan una spec propia con autoridad y efectos; no están ya implementadas por esta decisión.

**Fuentes:**

- [Metodología rectora](../documentacion-grado/04_metodologia/metodologia_desarrollo.md), Inicio y relación RUP–SDD.
- [Decisiones de Plantación](../decisiones/02_decisiones_plantacion.md), ADR-PLA-03 para el nuevo incremento y ADR-PLA-02 para límites actuales.
- [Reglas generales](../00-general-module/01_reglas_de_negocio_general.md), RN-GEN-27..29.
- [Reglas de Plantación](01_reglas_de_negocio_plantacion.md), RN-PLA-05, 18, 20..35.
- [Requerimientos de Plantación](00_Requerimientos_Modulo_3_Plantacion.json), mortandad/reposición y equipo.
- [Handoff inicial](05_handoff_registro_plantacion_inicial.md), permisos, campos y aclaración GPS de §12.
- [Migración 053](../database/migrations/053_m3_registrar_plantacion_sin_despacho.sql), bloques de GPS y responsable.
- [Plan frontend](04_plan_frontend_m3.md), recorrido y estado documentado.
- [Contrato Vivero → Plantación](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md), stock por asignación y propósito.
- [Mapa del sistema trazable](../documentacion-grado/03_investigacion/mapa_sistema_trazable_2026-09-10.md), §8.6 sobre impacto asociado.

La política aprobada sustituye el encuadre operativo inicial por organización. Las fuentes que describen implementación vigente se modificarán con la spec/plan y evidencia correspondientes; no se actualiza el estado real del backend mediante esta ficha.
