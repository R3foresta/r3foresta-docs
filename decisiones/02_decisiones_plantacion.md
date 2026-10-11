# ADR-PLA — Decisiones cerradas — Modulo Plantacion (MVP)

Las decisiones distinguen el MVP documentado vigente de los incrementos nuevos. ADR-PLA-03 es una decisión de producto aprobada para participación aliada, con implementación pendiente; no declara reemplazados los permisos desplegados.

## ADR-PLA-01 — Edicion basica y desactivacion de campaña en MVP

Fecha: 2026-07-03
Actualizacion: 2026-07-23

### Contexto

La campaña es un contenedor estrategico y su estado se deriva desde las subcampañas. Se evaluo una regla estricta que bloqueaba toda edicion y eliminacion al existir cualquier subcampaña, pero resulto demasiado dura para el flujo real: impide corregir datos generales y desactivar campañas que solo contienen subcampañas canceladas.

Para MVP se permiten correcciones que no rompen snapshots ni trazabilidad operativa. La operación real también requiere retirar de forma segura una campaña cuyas subcampañas todavía no plantaron, sin obligar al administrador a cancelar cada hija manualmente ni dividir una operación que debe ser atómica.

### Decision

En el MVP:

- `nombre`, `descripcion`, `fecha_estimada_inicio`, `fecha_estimada_fin` y organizaciones asociadas son editables como datos generales.
- `tipo` solo se edita mientras no exista ninguna `SUBCAMPANIA` asociada.
- La desactivación estricta puede aplicarse si no hay subcampañas vivas no canceladas; no produce efectos implícitos sobre hijas.
- Existe una acción explícita de desactivación con cancelación masiva, solo para `ADMIN`, con preview y motivo obligatorio.
- La acción masiva admite hijas `BORRADOR`/`ACTIVA` únicamente con `total_plantado_inicial = 0`, considera `CANCELADA` como postcondición satisfecha, devuelve físicamente el stock disponible y aplica soft-delete a la campaña en una sola transacción.
- Una hija con plantaciones o en `COMPLETADA`, `FINALIZADA_PARCIAL` o `PAUSADA` bloquea toda la operación masiva.
- El borrado fisico (`DELETE`) solo se permite si no existe ninguna subcampaña asociada.

### Consecuencias

- Permite corregir datos visibles de campaña sin tocar registros operativos.
- Las organizaciones pueden cambiar: las subcampañas ya activadas conservan `nombres_organizaciones_snapshot`; las futuras activaciones usan la relacion actual.
- No se implementa propagacion de `tipo` a subcampañas.
- La cancelación desde campaña reutiliza la semántica canónica de `RN-PLA-37`, registra `origen = DESACTIVACION_CAMPANIA`, devuelve stock y hace rollback completo ante cualquier fallo.
- Preview y ejecución son contratos separados: el preview no reserva ni autoriza; la ejecución vuelve a validar dentro de la transacción.

### Referencias

- `RN-PLA-38`
- `database/migrations/050_m3_campania_edicion_eliminacion_estricta_mvp.sql`
- `database/migrations/056_fix_devolucion_saldo_constraint.sql`
- `database/migrations/057_m3_campania_desactivacion_masiva.sql`
- `post-mvp/03-plantacion.md`

## ADR-PLA-02 — Registro de plantacion inicial en MVP

Fecha: 2026-07-08

**Estado:** histórico en cuanto al tope por especie; sustituido por ADR-PLA-04 el 2026-10-09. La ventana retroactiva de 10 días se mantiene. Las referencias a bloqueo y excedentes fuera del MVP describen el contrato anterior.

### Contexto

El registro inicial de plantacion consume el contrato vigente de backend para `POST /registros-plantacion` y el contexto operativo de subcampaña. El objetivo del MVP es registrar sin duplicar reglas complejas en frontend.

### Decision

En el MVP:

- La plantacion inicial no puede exceder `cantidad_objetivo` por especie, porque la RPC actual lo bloquea.
- La fecha de plantacion conserva la ventana retroactiva vigente de backend: 10 dias.
- No se implementa configuracion especial en frontend para estas reglas.

### Consecuencias

- El frontend debe respetar el limite por especie mientras backend no cambie el contrato.
- Los excedentes operativos por especie quedan fuera del MVP.
- La ventana retroactiva configurable queda fuera del MVP.

### Referencias

- `POST /registros-plantacion`
- `Backend-r3foresta/documentacion/postman/plantacion-context.md` (contexto de plantacion inicial)
- `post-mvp/03-plantacion.md`

## ADR-PLA-03 — Autorizacion operativa por persona y subcampana para participacion aliada

Fecha: 2026-10-07

**Estado:** decisión de producto aprobada por el usuario en conversación humana del 7 de octubre de 2026; especificación, correspondencia técnica, migración e implementación pendientes.

**Alcance:** nuevo incremento MVP de participación aliada en Plantación. Conserva el contrato de stock y las condiciones operativas vigentes. La revisión humana del 8 de octubre cierra LCO de este incremento y autoriza Elaboración según su ficha; no acredita aprobación de una spec completa, LCA, despliegue ni cierre LCO del proyecto global.

### Contexto

La operación puede reunir miembros de R3Foresta, organizaciones aliadas, comunidades y personas independientes. Una empresa puede financiar antes o después sin operar en campo ni procesar dinero mediante esta capacidad. Limitar permisos por afiliación organizacional exige pertenencias artificiales e impide representar equipos mixtos.

Se requiere separar autorización operativa, afiliación/contexto de consulta y crédito/financiación. El encuadre operativo inicial por organización queda sustituido para este incremento. La subcampaña ya es el ámbito del equipo y del stock en el modelo vigente, pero los permisos actuales utilizan roles globales y COORDINADOR/OPERARIO, con una restricción de exactamente un coordinador.

### Decision

1. La **SUBCAMPAÑA** es la única unidad de autorización operativa. Se habilita a cada persona con **PLANTADOR** o **ADMINISTRADOR DE SUBCAMPAÑA**. Son responsabilidades contextuales del nuevo diseño, no nuevos roles globales declarados implementados.
2. Solo la administración central de R3Foresta designa, cambia o retira administradores. Se permiten varios por subcampaña, sin límite superior acordado, y no se puede dejarla sin administradores. R3Foresta puede cambiar un administrador a plantador si queda otro administrador; conserva así capacidad de registrar y deja de administrar. Retirar todo acceso operativo a una persona que administra es una acción distinta, solo de R3Foresta, y requiere que quede otro administrador. El administrador contextual también puede plantar y gestionar acceso de plantadores en sus subcampañas autorizadas, pero no otorgar ni retirar administradores. La delegación de nombramientos entre administradores queda fuera del MVP; podrá evaluarse como mejora posterior si la operación lo justifica. No obtiene facultades para crear campañas, modificar entregas, operar Vivero/Recolección ni ejercer poderes globales de R3Foresta.
3. Una acción permite seleccionar una, varias o todas las subcampañas **actuales** de una campaña y asignar permisos en ellas. La campaña facilita agrupación y selección: no se crea rol de campaña, permiso comodín ni herencia. Toda subcampaña futura necesita asignación expresa. La comodidad de selección no amplía la autoridad de quien administra.
4. Una persona puede administrar una subcampaña y ser plantador en otra. Pertenencia a organizaciones, ausencia de afiliación y participación voluntaria son independientes del permiso. Un usuario de Scouts puede operar en Palca con autorización sin hacerse miembro de Palca. Financiar no concede permiso de plantación.
5. El equipo puede mezclar organizaciones y personas independientes. El stock permanece en la subcampaña por especie/asignación y propósito conforme al contrato M2→M3; sus personas autorizadas utilizan ese stock elegible compartido, con límites de disponibilidad, meta y condiciones operativas.
6. Cada registro conserva al usuario real responsable/autenticado, subcampaña, fecha, cantidades y evidencia; una plantación grupal se registra una vez y conserva corresponsables identificados según la base actual. No se multiplica el total por participantes, organizaciones ni financiadores.
7. La atribución organizacional detallada no es requisito para registrar en el MVP. No se obliga a atribuir crédito desconocido. Tampoco se infieren aportes desde todas las afiliaciones actuales ni se cambia automáticamente el significado histórico por una afiliación posterior. Autoría y stock correctos preceden al reparto de crédito.
8. La consulta común de impacto permite ver quién plantó qué según las personas responsables y participantes que consten realmente en cada registro. No se presume que quien registró plantó físicamente solo, ni se multiplican cantidades de un registro grupal. “Observador” describe esa experiencia de consulta común y no es un tercer rol asignable. Los campos exactos de las vistas y cómo mostrar participantes siguen pendientes; esta decisión no publica automáticamente todos los campos, fotos o GPS ni concede acceso interno a equipo/stock por historial propio.
9. El piloto trabaja con personas conocidas, sin captación espontánea de voluntarios. El administrador incorpora directamente como plantadores a usuarios ya registrados en las subcampañas que tiene autorizadas; la incorporación activa el permiso, sin solicitud pendiente ni flujo de invitación con aceptación. Esto también permite incorporar directamente a una persona independiente o voluntaria. Las solicitudes de acceso quedan para evolución posterior si se justifican.
10. En la subcampaña elegida, R3Foresta o un administrador autorizado puede retirar el permiso de plantador. La persona pasa a consulta común de impacto (“observador” como experiencia, no rol asignable) y conserva consulta del detalle de sus propias plantaciones guardadas, sin permiso operativo ni acceso al equipo/stock por historial propio. Si el formulario aún no se envió, no puede guardarse; si el usuario inició el envío pero el sistema aún no autorizó la operación, debe comprobarse el permiso vigente y rechazar sin registro ni consumo de stock si ya fue retirado. Pulsar «Enviar», abrir el formulario o cargar fotos no reserva permiso. Una operación autorizada por el sistema con permiso válido antes del retiro termina con su resultado normal, aunque puede fallar por otras validaciones; el retiro no habilita nuevos envíos ni cancela automáticamente operaciones ya autorizadas. Los registros ya guardados se conservan con autoría e historial, sin borrarlos ni reasignarlos. La implementación/plan técnico debe garantizar un orden consistente entre autorización/guardado y retiro; esta decisión no declara ese mecanismo implementado ni garantiza el éxito de una operación autorizada.

### Aclaración confirmada el 8 de octubre de 2026

La consulta común del MVP incluye un mapa con el polígono de la subcampaña y puntos GPS de las plantaciones. Cada punto representa un registro de plantación grupal, no cada árbol; una misma plantación grupal no se duplica por sus participantes. El polígono delimita el ámbito/zona de trabajo y no demuestra que toda su superficie esté plantada. Estos datos no permiten derivar la superficie realmente plantada. Si se requiere mostrar esa superficie, su alcance y método quedan pendientes. Esta aclaración no cierra otros campos o vistas de consulta ni acredita implementación. El plan frontend histórico que dejó la vista pública/mapa público fuera del MVP operativo anterior conserva ese alcance; esta decisión incorpora el mapa en la consulta común del nuevo incremento y no actualiza dicho plan.

La entrada a la consulta común es directamente el mapa con el impacto/total plantado. Tocar el polígono de una subcampaña abre su resumen en la misma vista, desde donde se accede progresivamente a detalles y registros. Organización y campaña dan contexto o sirven como filtros, sin recorrido obligatorio organización→campaña→subcampaña. El mapa puede abrir con una organización de referencia como filtro cambiable; la elección de referencia predeterminada cuando haya varias o ninguna afiliación sigue pendiente. Ese filtro no concede ni limita permisos, no atribuye automáticamente crédito organizacional y no debe ocultar opciones de registro autorizadas en otras organizaciones. En el resumen, quien solo consulta ve impacto y registros; una persona autorizada también puede consultar stock relevante y registrar sujeta a condiciones operativas; un administrador puede además gestionar plantadores, sin nombrar administradores. El mapa es una consulta común, no un paso operativo obligatorio para registrar. Una vía rápida desde Inicio para el plantador se prioriza como propuesta a explorar; no quedan aprobados su botón, pantalla ni selector. Esta navegación pertenece al nuevo incremento, no actualiza el plan frontend histórico ni declara implementación. Siguen pendientes la publicación de fotos y otros campos, el roster público frente a colaboradores históricos, “mis contribuciones” por responsable y corresponsable, y la presentación de stock e indicadores.

### Acuerdos del primer piloto — continuación del 8 de octubre de 2026

El usuario confirma mantener sencillo el primer piloto, basado en personas conocidas y de confianza, con registro directo de plantación. No se añade una aprobación previa del administrador ni un estado pendiente de esa aprobación. Antes de confirmar, la persona revisa y puede corregir el formulario; el guardado conserva las comprobaciones de autorización vigente, evidencia/GPS, cantidades, meta y stock. El administrador contextual mantiene su capacidad de plantar y gestionar acceso de plantadores; no se convierte en aprobador de cada plantación por este acuerdo.

La lista de participantes se revisa antes de confirmar y no se edita después de guardar en la primera unidad. Una posible corrección posterior con historial queda para el recorrido de correcciones, preservando original y responsable. La facultad de anular reportes de mortandad por un administrador y su posible límite ante reposiciones fueron propuestas en la conversación, pero no aprobadas. No se otorgan facultades generales de edición o reversión ni se define un retorno automático de stock. Estos acuerdos no constituyen una spec implementable, evidencia de despliegue ni cierre LCO.

**Acuerdo posterior de la misma revisión:** el usuario acepta una salida excepcional ante errores del piloto: el administrador revisa el caso y R3Foresta realiza una corrección vinculada al original, con historial de quién la hizo, cuándo y por qué. La operación debe diseñarse y verificarse antes de la prueba de campo. Se mantienen el registro directo y la ausencia de editor general para plantador/administrador. La autoridad central para esta excepción queda acordada; casos, campos, límites y efectos sobre cantidades, saldos y estados se precisarán en la spec y el plan. Corregir un dato no deshace una plantación física ni devuelve stock automáticamente. La edición general y correcciones de seguimiento conservan sus pendientes. Este acuerdo no concede al administrador facultad para anular mortandad ni declara implementada la corrección.

### Cierre del encuadre — revisión humana del 8 de octubre de 2026

Tras revisar los acuerdos y aceptar el plan inicial, el usuario autoriza iniciar el trabajo y confirma el cierre de Lifecycle Objectives (LCO) de este incremento. Se autoriza Elaboración: boceto prioritario, contraste técnico de riesgos en paralelo, specs/planes pequeños y cuatro diagramas. Se conserva la evidencia y el balance de revisión en la [ficha LCO, §10](../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md#10-revision-del-encuadre).

Las condiciones aceptadas son resolver los P0 antes de construir el comportamiento afectado, precisar esfuerzo/iteración y verificar preparación antes de campo. La fecha objetivo del 15 de octubre se revisa si faltan condiciones críticas, incluida la corrección excepcional. Este cierre no convierte las propuestas de interfaz o mecanismos técnicos en decisiones aprobadas, no aprueba specs completas ni acredita implementación o cierre del proyecto global.

### Consecuencias y limites de implementacion

- Debe diseñarse la correspondencia o migración frente a ADMIN/GENERAL/VALIDADOR/VOLUNTARIO y COORDINADOR/OPERARIO. No se equipara automáticamente administrador contextual con ADMIN global ni con COORDINADOR. La restricción vigente de exactamente un COORDINADOR requiere adaptación para admitir varios administradores contextuales y proteger al último; la decisión nueva no define cómo se implementa esa adaptación.
- Las transiciones de acceso quedan definidas: R3Foresta puede cambiar administrador a plantador si queda otra persona administrando, lo que conserva la capacidad de registrar; retirar todo acceso operativo a un administrador requiere acción central y también protege al último. R3Foresta o un administrador autorizado puede retirar permiso de plantador; entonces la persona pasa a consulta común y conserva lectura del detalle propio, sin operación ni acceso al equipo/stock por historial. No se presume un permiso de plantador paralelo e independiente en la misma subcampaña: administrar incluye capacidad de plantar. La consulta común muestra responsables y participantes realmente registrados, sin asumir plantación individual ni multiplicar cantidades grupales. Campos y presentación de vistas siguen pendientes. Los resultados por etapa y la necesidad de orden técnico entre autorización/guardado y retiro siguen según el punto 10; no se declara resuelto el mecanismo ni se cancelan automáticamente operaciones ya autorizadas. El retiro de afiliación no se convierte en revocación automática. Solo R3Foresta designa o retira administradores; se permiten varios por subcampaña y no se puede retirar al último. Inactivación de organizaciones y cambios de asociación de campañas requieren políticas explícitas.
- R3Foresta conserva entregas registradas y control interno. Solicitudes de plantas quedan fuera del alcance actual; correcciones de entregas corresponden a R3Foresta y a una capacidad separada, respetando cantidad asignada inmutable y distinguiendo devolución física de corrección documental.
- Mortandad posterior a plantar no devuelve disponibilidad; merma de stock antes de plantar es un concepto distinto. Reposición conserva la muerte histórica y consume stock elegible. Actores, revisión y detalle de adaptación siguen pendientes.
- El esquema documentado permite mostrar la cantidad inicialmente plantada por especie y el saldo vivo total reportado. No permite prometer composición viva actual por especie: `cantidad_muerta_delta` se registra por grupo sin `planta_id` y la reposición puede usar otra especie. Un desglose de mortandad por especie/método requiere definir una capacidad de datos.
- Anulación lógica es la intención acordada, conservando original, autor, fecha y motivo. Para la salida excepcional del primer piloto se acordó revisión del administrador y corrección a cargo de R3Foresta, con mecanismo y efectos pendientes antes de campo. Autoridad de los demás recorridos, límites, edición general y efectos sobre saldos/seguimientos requieren otra definición; anular datos no devuelve stock automáticamente.
- La autoridad de R3Foresta para designar/cambiar/retirar administradores y las transiciones de acceso descritas están resueltas por decisión humana del 7 de octubre de 2026. Puede haber varios administradores por subcampaña, sin límite superior acordado, y no se puede retirar al último. El piloto no necesita delegar nombramientos entre administradores. La adaptación técnica de la restricción vigente de un COORDINADOR y de las transiciones queda pendiente. También siguen pendientes acceso operativo interno de R3Foresta y representación posterior de contribuciones/financiación sin duplicar cantidades. Una administración de perfiles organizacionales puede ser capacidad aparte.
- Se conserva el orden de trabajo: registro/consulta y luego muerte/reposición; gestión de acceso; anulaciones/correcciones. La primera unidad reutiliza foto, GPS, fecha, cantidades por grupo/especie, resumen y confirmación con una persona ya habilitada.

### Caso ilustrativo

Una campaña contiene Palca Norte y Palca Sur. La administración central de R3Foresta designa a Ana como administradora en ambas mediante selección masiva; Carlos, afiliado a Scouts, recibe plantador solo en Palca Norte. Ana puede plantar y gestionar plantadores, pero no nombrar otros administradores. Palca Este, creada después, no recibe ninguno de esos permisos automáticamente.

R3Foresta entrega 100 plantas a Palca Norte. Dos registros independientes por 30 y 20 árboles realmente distintos dejan 50 disponibles y 50 plantados. Una plantación grupal se registra una vez. Vincular financiación empresarial no altera por sí solo stock ni totales físicos. Estos datos son una simulación, no hechos reales ni prueba ejecutada.

### Referencias

- [Ficha de Inicio de la capacidad](../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md), decisión y pendientes del 7 de octubre de 2026.
- [Reglas de Plantación](../03-plantacion-module/01_reglas_de_negocio_plantacion.md), modelo vigente de equipo, registro, mortandad y reposición.
- [Handoff inicial](../03-plantacion-module/05_handoff_registro_plantacion_inicial.md), permisos/campos actuales y aclaración GPS de §12.
- [Contrato Vivero → Plantación](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md), stock físico por subcampaña/asignación/propósito.
- [Migración 053](../database/migrations/053_m3_registrar_plantacion_sin_despacho.sql), comprobación actual del equipo y GPS. Su revisión local no acredita los permisos nuevos ni una aplicación productiva actual.


## ADR-PLA-04 — Metas orientativas, cierre manual y edicion del plan

Fecha: 2026-10-09. Alineación solicitada por el usuario con el backend local; el registro de cambio del backend fecha la decisión de metas/cierre el 2026-10-08.

**Vigencia:** la restricción de edición a BORRADOR describe el backend revisado el 9 de octubre antes de implementar ADR-PLA-05. ADR-PLA-05 la sustituye y ya tiene soporte en el backend local para ADMIN en BORRADOR o ACTIVA; frontend implementado localmente; QA integrado y despliegue verificado siguen pendientes. Metas orientativas y cierre manual conservan su vigencia.

### Contexto

El contrato anterior ya permitía entregar 50 plantas frente a un objetivo de 40, pero limitaba la plantación a 40 por especie y preveía cierre automático. El backend local incorpora migraciones 060/061 y anuncia `permite_exceder_meta_especie=true`. Además, sus servicios de plan y edición solo permiten ADMIN/BORRADOR; la documentación anterior prometía ajustes del plan en ACTIVA por admin/coordinador.

### Decision

- La meta total y los objetivos por especie son referencias de planificación. Se conserva su valor original y se registra el total físico real, incluso por encima del 100%.
- Asignar puede superar el objetivo dentro del saldo físico del vivero. Plantar puede superar el objetivo dentro del stock asignado disponible de propósito PLANTACION_INICIAL. Objetivo 40 y stock 50 permiten 50 de una vez o 40 + 10; 51 sin más stock se rechaza.
- La especie debe estar en el plan tanto al asignar como al plantar inicialmente. No se permite «cualquier especie» por tener stock. Reposición conserva especie libre, propósito REPOSICION y límite de muertas menos repuestas; no avanza la meta.
- Solo ADMIN edita meta total y plan en BORRADOR. En ACTIVA no se extienden metas ni se agregan especies; el coordinador no obtiene esa facultad. Editar un plan activo queda para evaluación futura.
- Alcanzar o superar la meta no cierra: permanece ACTIVA y admite más plantación inicial elegible. Solo ADMIN ejecuta `POST /subcampanias/:id/cerrar`, con estado final y fechas explícitas de cierre y fin de mantenimiento. La UI propone tres años, editables; fin no puede preceder al cierre.
- La UI elige COMPLETADA con meta alcanzada/superada y FINALIZADA_PARCIAL por debajo, con motivo de catálogo obligatorio. El endpoint actual acepta ambos estados y no compara el total plantado con la meta; no documentar esa comparación como validación de backend.
- Tras cerrar se bloquean plantaciones/asignaciones iniciales y comienza mantenimiento. El saldo no utilizado sigue asignado hasta devolución física separada. El servicio de cierre actualiza la subcampaña; la escritura de eventos de cierre en historial sigue pendiente.

### Consecuencias y verificacion

Sustituye el tope de ADR-PLA-02/RN-PLA-18 y el cierre automático previsto por RN-PLA-10/RF-PLA-07. Alinea RN-PLA-17/RF-PLA-18 con los permisos/estados de edición realmente expuestos. No cambia el incremento de permisos contextuales de ADR-PLA-03 ni declara su implementación.

Esta revisión documental no aplicó migraciones ni verificó la base compartida. Antes de utilizar el flujo en un entorno, confirmar migraciones 060/061 y versiones de backend/contexto/PWA coordinadas. Los SQL anteriores de este repositorio se conservan como históricos; la migración 053 contiene el tope anterior.

### Referencias de la evidencia local

- [Registro de cambio y límites de verificación del backend](../../Backend-r3foresta/documentacion/tareas/plantacion-metas-orientativas.md).
- [060: asignación exige especie del plan](../../Backend-r3foresta/migrations/060_vivero_asignacion_validar_plan_especie.sql).
- [061: metas orientativas en registro](../../Backend-r3foresta/migrations/061_plantacion_meta_especie_orientativa.sql).
- [Política de contexto](../../Backend-r3foresta/src/subcampanias/domain/policies/reglas-plantacion.policy.ts).
- [Servicio de plan](../../Backend-r3foresta/src/subcampanias/application/subcampanias-plan.service.ts) y [campos editables por estado](../../Backend-r3foresta/src/subcampanias/domain/policies/edicion-por-estado.policy.ts).
- [Servicio de cierre](../../Backend-r3foresta/src/subcampanias/application/subcampanias-cierre.service.ts) y [política de cierre](../../Backend-r3foresta/src/subcampanias/domain/policies/cierre.policy.ts).


## ADR-PLA-05 — Edicion de meta y especies en ACTIVA solo ADMIN

Fecha: 2026-10-09.

**Estado actualizado 2026-10-10:** decisión aprobada por el usuario, con confirmación explícita «ADMIN only», e implementada en el backend local mediante la migración 062 y revisión atómica. El usuario confirmó en el chat de implementación la aplicación en Supabase hasta 062 y posteriormente de 063. El frontend está implementado localmente y los ajustes JWT/063 están comprometidos en backend. La publicación de los últimos ajustes frontend, el QA integrado y la verificación del despliegue siguen pendientes; la confirmación humana de las migraciones no equivale a una inspección remota de esta revisión.

### Decision

La planificación vive en SUBCAMPAÑA: ADMIN puede modificar `meta_total_arboles`, objetivos/porcentajes por especie y agregar especies del catálogo en BORRADOR o ACTIVA. La campaña conserva su meta agregada derivada; no obtiene una meta editable propia. Ser coordinador o administrador contextual de participación aliada no concede este permiso global.

Los ajustes conservan un plan coherente: al menos una especie, sin duplicados, objetivos positivos, porcentajes sumando 100 y cantidades sumando la meta total. Se guardan meta y plan como una revisión coherente con quién/cuándo y valores anteriores/nuevos. Los registros de plantación, autorías y cantidades reales permanecen intactos. Editar el plan no crea ni devuelve stock; no se elimina una especie con plantación inicial registrada o stock inicial disponible.

Las asignaciones/plantaciones iniciales siguen limitadas a especies del plan vigente: una especie nueva se incorpora antes de asignarla. Las metas siguen siendo orientativas; superar objetivos no obliga a editarlos y no los modifica automáticamente. El progreso se recalcula contra la meta vigente. Ajustar metas no cierra la subcampaña; el cierre manual por ADMIN se mantiene. Los estados cerrados/cancelados no admiten esta edición ni reapertura.

Ejemplo: una subcampaña ACTIVA tenía meta 40 y registra 50 árboles reales. ADMIN puede revisar su meta a 60 y ajustar el plan por especie; quedan 50 plantados y el saldo físico no cambia. También puede incorporar otra especie al plan antes de recibir stock de ella.

### Contrato implementado y límites

`GET /api/subcampanias/:id/plan` devuelve meta total, especies y `plan_revision` en un único snapshot. Cualquier usuario autenticado existente en `USUARIO` puede leerlo, sin pertenecer al equipo. `PUT /api/subcampanias/:id/plan` exige ADMIN global y permite BORRADOR o ACTIVA. Ambas rutas verifican `Authorization: Bearer <token>` con el JWT del login WebAuthn; `x-auth-id` es opcional y, si se envía, debe coincidir con `sub` del JWT. La lectura del plan no concede acceso operativo a equipo/stock ni permisos para plantar o gestionar participantes; El incremento de participación aliada conserva su alcance separado.

El guardado completo envía `meta_total_arboles`, `metas` y `revision_esperada` obtenida de `plan_revision`. En ACTIVA son obligatorios; en BORRADOR una meta explícita también exige versión. Se conserva el cuerpo histórico `{metas}` en BORRADOR usando la meta vigente y fijando la versión al inicio de la petición; los clientes nuevos deben enviar siempre la versión leída en el editor. Todo guardado exige un plan coherente, también en BORRADOR. `PATCH /subcampanias/:id` rechaza `meta_total_arboles`: usar PUT /plan.

La RPC `fn_subcampania_revisar_plan` comparte el bloqueo de subcampaña con asignación/plantación, comprueba estado y versión, guarda meta/especies e incrementa `plan_revision` junto con `PLAN_REVISADO` en una misma transacción. El historial contiene actor, fecha y snapshots `metadata.anterior`/`metadata.nuevo`; si falla, se revierte todo. Una versión obsoleta devuelve `409`: leer y conciliar antes de reenviar, sin reintento automático que sobrescriba cambios ajenos. Stock de REPOSICION no impide por sí solo retirar una especie del plan inicial.

La migración 063 restringe la RPC de lectura a `service_role`, igual que la escritura: los usuarios leen a través del backend autenticado, no ejecutando directamente la RPC como `anon`/`authenticated`. `JWT_SECRET` y `SUPABASE_SERVICE_ROLE_KEY` permanecen en el backend; la clave administrativa no convierte al usuario en ADMIN ni se envía al frontend. La edición de plantaciones y otros permisos no se amplían.

### Evidencia y cierre de implementacion local

La revisión del [chat de implementación](codex://threads/01a12288-904e-7061-8dd0-2b80f916a157) y del código local confirma el contrato. El chat reporta 531 pruebas unitarias/HTTP y 46 verificaciones PostgreSQL aisladas, compilación, tipos y estilo; esta actualización documental no vuelve a ejecutarlas ni acredita producción. La aplicación de 063 fue confirmada posteriormente por el usuario en ese chat.

El frontend local ya bloquea solicitudes sin JWT, trata sesión vencida/permisos y revisiones 409, y envía meta/plan/versión en un solo PUT. El editor conserva propuestas, exige nueva lectura/revisión ante conflicto o guardado incierto y comparte el formulario con el asistente, sin fallback de PATCH separado. Backend tiene los ajustes JWT/063 comprometidos (37f9d44) y evidencia de acceso local resuelto (ae19480). Frontend tiene el editor/formulario en main (2c8c29a), con ajustes adicionales aún sin commit en su árbol de trabajo. No se modifica ni compromete código de esos repositorios en esta revisión.

Las dos tareas de implementación quedan cerradas documentalmente según el código local y la confirmación del usuario. La guía/auditoría frontend reporta 284 pruebas/19 suites, lint y build aprobados; aquí no se repiten. Quedan publicación coordinada y QA integrado en el entorno objetivo (AUD-015), junto al hallazgo de encabezado exterior tras rechazo por cambio de estado (AUD-016); no se declara producción verificada. Ver [ESTADO.md](../ESTADO.md) y [revisión de cierre](../03-plantacion-module/07_revision_meta_especies_cierre.md).

### Referencias

- [RF-PLA-18](../03-plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json).
- [RN-PLA-17](../03-plantacion-module/01_reglas_de_negocio_plantacion.md#rn-pla-17---edicion-del-plan-segun-estado).
- [Proceso de ajuste en ACTIVA](../03-plantacion-module/02_Procesos_Modulo_3_Plantacion.md#ajuste-del-plan-mientras-activa-solo-admin).
- [Servicio local de plan](../../Backend-r3foresta/src/subcampanias/application/subcampanias-plan.service.ts) y [política local de edición](../../Backend-r3foresta/src/subcampanias/domain/policies/edicion-por-estado.policy.ts).
- [062 — revisión atómica](../../Backend-r3foresta/migrations/062_subcampania_revision_plan_atomica.sql) y [063 — lectura mediante backend](../../Backend-r3foresta/migrations/063_subcampania_plan_lectura_backend.sql).
- [Contrato API de planes](../../Backend-r3foresta/documentacion/frontend/modulos/subcampanias.md#get-subcampaniasidplan) y [guía de verificación 062–063](../../Backend-r3foresta/documentacion/tareas/verificacion-supabase-plan-062-063.md).
