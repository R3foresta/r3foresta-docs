# PA-S03 — Gestión de acceso por subcampaña

**Estado:** borrador para revisión humana; no aprobado para implementación. **Actualización:** 10 de octubre de 2026. **Prioridad de elaboración:** P1 para la interfaz completa; identidad, autorización y revocación son dependencias críticas de PA-S01, no trabajo aplazable hasta después del registro.

## 1. Resultado y ámbito

Una persona registrada recibe capacidad para plantar en subcampañas concretas. Un administrador contextual gestiona plantadores únicamente dentro de su ámbito. R3Foresta conserva la designación, cambio y retiro de administradores, con protección del último. Crear una cuenta, afiliarse a una organización o aparecer en un registro histórico no concede permisos operativos.

La unidad de autorización es **persona + subcampaña**. PLANTADOR y ADMINISTRADOR DE SUBCAMPAÑA son responsabilidades contextuales del incremento; no amplían el catálogo global `ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`. Una persona puede administrar Palca Norte y plantar en Palca Sur, sin permiso en Palca Este. Administrar incluye plantar: no se presupone un permiso paralelo de plantador en el mismo ámbito.

[PA-S00](../00-experiencia-participante/spec.md) define ingreso y experiencia del participante. Revisión del 11 de octubre: PA-DI08 confirma consulta pública sin sesión; PA-DI10 excluye pedir wallet/documento y deja afiliación opcional; PA-DI09 orienta VOLUNTARIO + permiso contextual con transición técnica pendiente. [PA-S02](../02-consulta-impacto-y-registros/spec.md) define campos públicos/privados. Consultar no autoriza a operar. Esta spec tampoco elimina el JWT del contrato GET /plan de ADR-PLA-05.

## 2. Historias de usuario

| ID | Historia | Resultado verificable |
|---|---|---|
| PA-S03-US01 | Como persona recién registrada, quiero que me habiliten en la subcampaña donde colaboraré sin tener que ingresar a una organización artificialmente. | Un administrador autorizado encuentra mi cuenta registrada y me incorpora directamente; el permiso no incluye Recolección, Vivero ni gestión global. |
| PA-S03-US02 | Como administrador contextual, quiero incorporar o retirar plantadores de mis subcampañas para mantener correcto el acceso operativo. | Solo modifico plantadores en ámbitos propios y conozco el resultado confirmado de la acción; no nombro ni retiro administradores. |
| PA-S03-US03 | Como administración central de R3Foresta, quiero designar varios administradores y cambiar sus responsabilidades para mantener continuidad de gestión. | Puedo nombrar, cambiar a plantador o retirar a una persona administradora, conservando al menos otra cuando corresponde. |
| PA-S03-US04 | Como gestor autorizado en varias subcampañas, quiero seleccionarlas juntas para evitar repetir una asignación persona por persona y ámbito por ámbito. | Confirmo una lista de IDs actuales dentro de mi autoridad; las futuras subcampañas no heredan el permiso. |
| PA-S03-US05 | Como persona a quien retiraron acceso, quiero entender que ya no puedo registrar allí y seguir consultando mis registros guardados. | No se guardan nuevos envíos aún no autorizados; se preservan autoría, historia y detalle propio, sin reabrir equipo/stock. |
| PA-S03-US06 | Como personal interno ya autorizado, quiero conservar mis operaciones legítimas al incorporar la experiencia participante. | La transición identifica mis facultades actuales y las verifica; no convierte a todos los usuarios actuales en participantes ni amplía facultades por un renombrado de roles. |

## 3. Autoridad y acciones

| Acción | Sin permiso contextual / plantador | Administrador contextual | Administración central de R3Foresta |
|---|---|---|---|
| Consultar impacto | Según PA-S00/PA-S02, no por el título de rol. | Igual, con funciones adicionales autorizadas. | Según la política de consulta y sus funciones propias. |
| Registrar plantación inicial | Sin permiso: no. Plantador: sí, solo en su ámbito y con validaciones de PA-S01. | Sí, en sus ámbitos y con las mismas validaciones. | Su acceso operativo interno debe precisarse en PA-DI03; designar administradores no demuestra por sí solo autorización para registrar en todo ámbito. |
| Incorporar/retirar plantador registrado | No. | Sí, solo en sus subcampañas. | Sí, según ADR-PLA-03 y autoridad central verificada. |
| Designar administrador | No. | No, aunque administre ese ámbito. | Sí. Puede designar varios; no hay límite superior acordado. |
| Cambiar administrador a plantador | No. | No, tampoco sobre sí mismo. | Sí, si queda otra persona administrando. Conserva la capacidad de plantar. |
| Retirar todo acceso de un administrador | No. | No. | Sí, si queda otra persona administrando; es una acción distinta a cambiarlo a plantador. |
| Crear campañas, editar plan, cerrar o gestionar entregas | No por estos permisos. | No por ser administrador contextual. | Conforme a los permisos globales/específicos vigentes; no se redefine aquí su conjunto. |
| Editar un registro ya guardado o aprobar cada envío | No. | No. Puede revisar un error para PA-S04, sin edición general ni cola de aprobación. | La corrección excepcional sigue PA-S04; no se convierte en editor general. |

El usuario confirma ADMIN global como representación de la administración central de R3Foresta. No es un rol nuevo ni el administrador contextual. PA-DI03 aún debe concretar identidad/política verificables y acceso operativo interno; la confirmación no otorga automáticamente permiso para plantar en cualquier ámbito ni aprueba los casos de corrección de PA-DI07. La interfaz nunca decide la autoridad final ni acepta un rol declarado libremente por el cliente.

## 4. Recorridos y estados

### Incorporar un plantador

1. El administrador abre la gestión de una subcampaña autorizada o selecciona ámbitos actuales donde puede gestionar.
2. Busca una persona **ya registrada**, mediante una búsqueda autenticada con datos mínimos por definir. No se necesita compartir organización. No se expone por defecto el directorio completo de perfiles/contactos.
3. Revisa persona, responsabilidad y subcampañas exactas; confirma.
4. El backend verifica identidad, autoridad vigente y estado actual de la asignación. Al confirmar el resultado, el permiso queda activo directamente, sin solicitud pendiente ni invitación con aceptación.
5. La experiencia participante actualiza sus capacidades. La nueva autorización no garantiza stock, estado ACTIVA ni elegibilidad de una plantación: PA-S01 vuelve a validarlos al guardar.

Si no existe la persona registrada, la acción termina sin crear cuenta ni invitación. El equipo coordina su registro por el canal conocido del piloto. La propuesta ante una incorporación repetida idéntica es informar «ya habilitado», sin duplicar acceso ni notificar un cambio inexistente; el contrato de repetición debe revisarse.

### Retirar o cambiar responsabilidad

Antes de confirmar, mostrar persona, subcampañas y consecuencia: retirar plantador elimina la capacidad de operar; cambiar administrador a plantador conserva la capacidad de registrar; retirar administrador elimina todo acceso operativo de ese contexto. En todos los casos se conservan los registros históricos. R3Foresta ejecuta las dos últimas acciones y la validación del último administrador ocurre en servidor/base de datos.

| Estado conceptual | Transición | Condición |
|---|---|---|
| Sin acceso operativo | → Plantador | Persona registrada; gestor autorizado en el ámbito. |
| Sin acceso operativo / Plantador | → Administrador | Solo autoridad central. |
| Administrador | → Plantador | Solo autoridad central; debe quedar otro administrador. |
| Plantador | → Sin acceso operativo | Administrador autorizado o autoridad central. |
| Administrador | → Sin acceso operativo | Solo autoridad central; debe quedar otro administrador. |

Son estados del permiso contextual, no estados nuevos de campaña, cuenta o registro de plantación. El diseño de la primera designación y la transición de subcampañas legadas que aún no tienen estos permisos debe cerrarse antes de habilitar el nuevo recorrido; no se considera que ya satisfacen el invariante por tener un COORDINADOR.

La pantalla distingue cargando, selección lista, guardando, éxito confirmado, rechazo por autoridad/conflicto y resultado no confirmado por pérdida de respuesta. En el último caso consulta el estado vigente antes de afirmar éxito o reenviar una modificación distinta. Nunca muestra «acceso retirado» solo porque se pulsó confirmar.

### Selección de varias subcampañas

La campaña facilita seleccionar una, varias o todas las subcampañas **actuales**. «Todas» se concreta en una lista de IDs que la persona revisa; no es un permiso de campaña ni un comodín. El servidor comprueba cada ámbito de nuevo. Si una subcampaña se crea después, no recibe la asignación.

**Propuesta pendiente:** para el volumen del piloto, aplicar toda la selección o rechazarla sin cambios parciales, con orden estable de bloqueos. Debe confirmarse esa atomicidad frente a resultados parciales explícitos antes de implementar; nunca aceptar un resultado parcial silencioso ni ampliar la selección en ejecución.

## 5. Revocación y guardado de plantaciones

- Abrir el formulario, subir fotos y pulsar Enviar no reserva permiso ni stock.
- Si el retiro precede a la autorización válida de la operación, se rechaza el nuevo registro sin crearlo ni consumir stock. La UI explica el retiro y permite consultar lo ya guardado, conforme a PA-S02.
- Si la operación fue válidamente autorizada antes del retiro, puede terminar con su resultado normal; otras validaciones todavía pueden rechazarla. Retirar permiso no borra ni cancela automáticamente esa operación ya autorizada.
- Backend/base de datos deben establecer un orden consistente entre autorización, escritura y retiro. Una comprobación aislada antes de la transacción no acredita esa garantía.
- Después del retiro no se permiten nuevos envíos. Recuperar un recibo ya guardado no es un nuevo envío; la consulta propia se conserva sin volver a conceder acceso a stock/equipo.
- Los registros y snapshots previos no se borran ni reasignan. Salir de una organización no equivale a revocación; afiliarse no concede acceso. La política para inactivación de cuentas/organizaciones y efectos sobre el último administrador requiere decisión explícita.

## 6. Escenarios de aceptación para revisión

| ID | Dado / cuando | Entonces |
|---|---|---|
| PA-S03-CA01 | Una cuenta nueva o un perfil actualizado sin asignaciones intenta operar. | El alta/perfil no concede capacidades de Recolección, Vivero, gestión ni plantación. Backend no admite autoasignación de rol/permisos mediante payload o headers. La transición global se define en PA-DI09. |
| PA-S03-CA02 | Un administrador de Palca Norte incorpora a una persona registrada independiente o de otra organización. | Puede habilitarla como plantador en Norte sin cambiar afiliación ni rol global; Sur permanece sin permiso. No hay aceptación de invitación ni aprobación de sus posteriores registros. |
| PA-S03-CA03 | Ese administrador cambia el ID por una subcampaña ajena o intenta otorgar administración. | El servidor rechaza sin mutación; ocultar botones no es la única defensa. No se expone equipo ajeno al resolver el error. |
| PA-S03-CA04 | Una persona global VOLUNTARIO recibe autorización contextual para plantar. | El nuevo recorrido debe permitir plantar en su ámbito sin ascenderla a GENERAL ni conceder operaciones de M1/M2. Exige adaptar y probar las restricciones legadas, no presumir compatibilidad actual. |
| PA-S03-CA05 | R3Foresta designa dos administradores y luego cambia uno a plantador. | Se conserva otro administrador; el cambiado puede plantar pero ya no gestiona. Retirarle todo acceso es una acción separada. |
| PA-S03-CA06 | R3Foresta intenta retirar o degradar al único administrador. | Se rechaza sin dejar el ámbito sin administración. Con dos administradores y dos retiros concurrentes, el resultado final mantiene al menos uno. |
| PA-S03-CA07 | Se asigna sobre Norte y Sur y después se crea Este. | Solo Norte y Sur quedan asignadas. Repetir la misma asignación no crea duplicados. La opción «todas» no otorga autoridad en ámbitos ajenos ni futuros. |
| PA-S03-CA08 | Una selección contiene un ámbito cuya autoridad cambió antes de ejecutar. | Se revalida cada ID. La respuesta y persistencia coinciden con la atomicidad aprobada; bajo la propuesta todo-o-nada, no se aplica ningún cambio. |
| PA-S03-CA09 | Se retira permiso con un formulario abierto, fotos cargadas o envío todavía no autorizado. | Al intentar autorizar después del retiro se rechaza sin registro ni consumo. Esas acciones previas no reservan permiso. |
| PA-S03-CA10 | El registro obtiene autorización válida y luego ocurre el retiro concurrente. | Termina conforme a las demás validaciones, sin cancelación retroactiva automática. La prueba demuestra el orden transaccional; nuevos envíos posteriores se rechazan. |
| PA-S03-CA11 | La persona revocada recupera su registro/recibo guardado. | Conserva identidad, cantidades e historial propios; no recibe stock/equipo ni puede gestionar. Una lectura propia no ejecuta otra plantación. |
| PA-S03-CA12 | Un administrador contextual intenta editar plan/cerrar/entregar plantas sin la facultad adicional correspondiente. | Se rechaza la operación. Su lectura autenticada del plan mantiene ADR-PLA-05; ser administrador contextual no lo convierte en ADMIN global ni COORDINADOR legado. |
| PA-S03-CA13 | Se migra a usuarios internos con operaciones existentes y a nuevos participantes. | Se verifican facultades legítimas de cada conjunto. No hay equiparación automática COORDINADOR → administrador contextual ni pérdida/ampliación silenciosa de permisos internos. |
| PA-S03-CA14 | Una mutación de acceso pierde la respuesta o se ejecuta dos veces. | No se muestra éxito sin comprobación ni se duplican asignaciones; se recupera estado vigente y se informa el resultado conforme al contrato de repetición/concurrencia aprobado. |

Estos casos definen evidencia esperada, no resultados de pruebas ya ejecutadas. Las propuestas indicadas se cierran con revisión humana antes de construir el comportamiento afectado.

## 7. Datos, compatibilidad y decisiones pendientes

El modelo vigente utiliza `SUBCAMPANIA_EQUIPO` con `COORDINADOR | OPERARIO`, exactamente un COORDINADOR y restricciones globales de membresía. COORDINADOR participa además en activación y operaciones de entregas/devoluciones. Cambiarle el nombre no implementa los permisos de esta spec y podría ampliar indebidamente facultades.

PA-DI01/02 deben decidir adaptación o tabla contextual separada, transición de usuarios y una fuente única de autorización para el nuevo recorrido, sin un «permiso nuevo O permiso legado» permanente que permita eludir retiros. Conservar referencias históricas, snapshots y responsabilidades internas necesarias. La autorización por organización y un FK directo `coordinador_id` en SUBCAMPANIA no son alternativas válidas.

Quedan pendientes: representación verificable de autoridad central y acceso operativo interno (PA-DI03); campos mínimos de búsqueda/visibilidad del equipo (PA-DI05); contrato de alta y transición del personal (PA-DI09), aplicando los mínimos ya confirmados en PA-DI10; primera designación y ámbitos legados; atomicidad/repetición masiva; efectos de inactivaciones. La [propuesta de roles con fuentes](../revision-humana-2026-10-11.md#2-pa-di09-y-autoridad-propuesta-trazada-para-revisar) distingue ADMIN global, administrador de subcampaña, GENERAL, VALIDADOR, VOLUNTARIO y equipo legado. No crea un rol de campaña. El [diseño técnico compartido](../diseno-tecnico-compartido.md) desarrolla frontend/backend/datos; no crea tablas ni aplica migraciones.

## 8. Trazabilidad

- [ADR-PLA-03 y ADR-PLA-05](../../../../decisiones/02_decisiones_plantacion.md): autoridad contextual, selección, retiro, historial y límites de lectura/edición del plan.
- [RN-PLA-08/20/21/22/35](../../../../03-plantacion-module/01_reglas_de_negocio_plantacion.md): base legada que requiere adaptación explícita, no implementación demostrada del incremento.
- [Ficha LCO](../../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md), [plan de integración](../plan-reutilizacion-integracion.md), [plan de esta unidad](plan.md) y [tareas](tasks.md).
