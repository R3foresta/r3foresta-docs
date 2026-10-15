# PA-F01 — Participación aliada en Plantación

Incremento para consultar y compartir impacto sin cuenta, registrar con identidad y permiso vigentes y gestionar acceso por subcampaña. Reutiliza las campañas, registros y stock existentes.

**Situación al 15 de octubre de 2026:** implementación parcial. INT02-A está cerrada en identidad/perfil y desarrollo; INT02-B tiene base técnica local ensayada, con 068–071 confirmadas y SQL compacto/REST cotejados; catálogo complementario y correspondencias reales pendientes. [Informe B](../../../../Backend-r3foresta/docs/pa-int02b-entrega-local.md). INT02-C tiene BE01–BE06 verificados para integración local de INT06: 14 APIs, comandos sin fotos y rol/baja; 072/073 confirmadas y superficie REST de desarrollo comprobada. Entorno sintético local con ocho perfiles y 30 pruebas HTTP disponible; arranque completo con Supabase pasó 18 probes y cotejador SQL pasó 26 pruebas. Cuerpos SQL remotos/despliegue e INT03-A/D siguen pendientes. [Informe C](../../../../Backend-r3foresta/docs/pa-int02c-entrega-local.md). [Tablero único de ejecución y cobertura](implementacion/README.md) · [Estado y evidencia](../../../ESTADO.md).

## Lectura mínima para continuar

1. [Tablero de ejecución](implementacion/README.md): orden de entregas, avance y relación con las specs.
2. [PA-T-INT02-C](implementacion/pa-t-int02-c.md): entrega local y cotejo remoto pendiente; [PA-T-INT02-B](implementacion/pa-t-int02-b.md) conserva catálogo/transición real pendientes. Continuar INT03-A para el registro participante.
3. Spec/tareas de la capacidad afectada y secciones citadas del [contrato backend aceptado](contrato-identidad-permisos-backend-propuesta.md).

**Dónde pertenece INT02-B:** es una entrega de PA-F01, principalmente de PA-S03 (acceso), que habilita entrada PA-S00 y registro PA-S01. La organización es una afiliación opcional del perfil; el permiso se concede a una persona en una subcampaña. El nombre histórico «plantación-organización» del LCO no crea un módulo ni otro backlog de permisos.

## Capacidades funcionales

| Capacidad | Comportamiento y aceptación | Responsabilidades | Trabajo verificable |
|---|---|---|---|
| PA-S00 · Entrada y perfil | [spec](00-experiencia-participante/spec.md) | [plan](00-experiencia-participante/plan.md) | [tareas](00-experiencia-participante/tasks.md) |
| PA-S01 · Registro inicial | [spec](01-registro-plantacion-inicial/spec.md) | [plan](01-registro-plantacion-inicial/plan.md) | [tareas](01-registro-plantacion-inicial/tasks.md) |
| PA-S02 · Consulta de impacto y registros | [spec](02-consulta-impacto-y-registros/spec.md) | [plan](02-consulta-impacto-y-registros/plan.md) | [tareas](02-consulta-impacto-y-registros/tasks.md) |
| PA-S03 · Gestión de acceso | [spec](03-gestion-acceso-subcampania/spec.md) | [plan](03-gestion-acceso-subcampania/plan.md) | [tareas](03-gestion-acceso-subcampania/tasks.md) |
| PA-S04 · Corrección excepcional | [spec](04-correccion-excepcional/spec.md) | [plan](04-correccion-excepcional/plan.md) | [tareas](04-correccion-excepcional/tasks.md) |

PA-S00/01/02/03 están aprobadas en comportamiento; PA-S04 conserva acuerdos confirmados y cierre integral propio pendiente. El [tablero](implementacion/README.md#qué-parte-de-las-specs-está-implementada) distingue lo implementado de lo que falta por capacidad. Una revisión funcional cerrada no completa su implementación.

## Contratos y reglas vigentes

| Fuente | Consultar para |
|---|---|
| [Contrato backend D01–D12](contrato-identidad-permisos-backend-propuesta.md) | DTO/errores, identidad, permisos, comandos, cargas, retención, locks y transición. Diseño aceptado el 13; «propuesta» se conserva en el nombre para mantener sus enlaces. |
| [Acuerdo de roles y permisos](acuerdo-roles-y-permisos-2026-10-12.md) | Alta VOLUNTARIO, rol interno separado del perfil y autoridad contextual/global. |
| [Contratos funcionales PA-S03](03-gestion-acceso-subcampania/contratos.md) | Acciones y consecuencias de gestión; los mecanismos concretos se ajustan al contrato backend posterior. |
| [ADR y reglas de Plantación](../../../decisiones/02_decisiones_plantacion.md) | Invariantes y decisiones transversales. |
| [Vivero → Plantación](../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md) | Entrega física previa, consumo por asignación y devolución. |

Acuerdos que guían la implementación: Impacto público sin login; alta VOLUNTARIO y perfil sin mutación de autoridad; permisos por persona/subcampaña; afiliación opcional catálogo/Otra/ausencia; inicial LIFO sobre stock ya disponible, sin otra recepción ni débito de Vivero; recuperación del mismo comando; correcciones con original e historial, sin reapertura. Los detalles y límites están en sus specs/contratos.

## Material de apoyo y archivo

- [Inventario de endpoints y regresión](inventario-endpoints-y-regresion-participacion.md): lectura estática del 13 de octubre; mapa para contrastar el código actual.
- [Boceto de registro y resultado](boceto-registro-resultado.md): apoyo al recorrido funcional aprobado.
- [Diagramas y dependencias](diagramas/README.md): cinco vistas actualizadas al 14; incluyen LIFO en servidor, comandos/recuperación, correcciones y la secuencia vigente desde INT02-B. La versión anterior se conserva en el archivo.
- [Archivo](archivo/README.md): actas de aceptación, planes anteriores y [cierre de INT02-A](archivo/cierre-pa-t-int02-a.md).
- [LCO y alcance inicial](../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md) y [handoff del registro interno](../../../03-plantacion-module/05_handoff_registro_plantacion_inicial.md): antecedentes y base reutilizada.

Mantener una sola lista de entregas vigentes en `implementacion/README.md`. La fecha de campo original era un objetivo condicionado; despliegue y habilitación del piloto requieren su evidencia posterior en INT08.
