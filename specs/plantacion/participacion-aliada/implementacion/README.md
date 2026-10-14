# Ejecución de PA-F01

**Corte:** 14 de octubre de 2026. **Siguiente entrega:** [PA-T-INT02-B](pa-t-int02-b.md), preparada documentalmente y pendiente de implementación. [Evidencia general](../../../../ESTADO.md).

## Cómo se conectan specs y entregas

`PA-F01` es el incremento Participación aliada en Plantación. `PA-S00`–`PA-S04` describen capacidades del producto. Los IDs `PA-T-ENT*` y `PA-T01`–`PA-T21`, con sus sufijos, son tareas por capacidad. `PA-T-INT*` agrupa esas tareas en entregas que se pueden integrar y verificar. Se conserva cada ID.

**INT02-B pertenece principalmente a PA-S03 (acceso)** y prepara la autorización que necesitan PA-S00 (entrada) y PA-S01 (registro). El usuario y su perfil son transversales, pero su uso en este incremento sigue bajo PA-F01. La afiliación a una organización es opcional; no es el ámbito que otorga permisos.

## Orden y avance

| Entrega | Qué integra / tareas relacionadas | Estado al corte |
|---|---|---|
| PA-T-INT01 | Preparación técnica de todas las specs; PA-T-ENT02, PA-T12-REV/PA-T15. | Contrato D01–D12 e inventario estático completados. Catálogo y transición concretos se comprueban por entrega. |
| PA-T-INT02-A | PA-S00: parte de ENT04-BE/DB y ENT05-FE/ENT06-QA; PA-S03: base de identidad de PA-T12-BE. | **Completada** en identidad/alta/perfil, privacidad e integración de desarrollo. [Cierre y límites](../archivo/cierre-pa-t-int02-a.md). |
| [PA-T-INT02-B](pa-t-int02-b.md) | PA-S03: PA-T12-DB, cotejo PA-T12-REV/PA-T15 y preparación de PA-T13-DB. PA-S00: parte pendiente de ENT02/ENT04-DB. | **Siguiente.** Persistencia de permisos, revisiones, auditoría y ensayo de transición. Sin implementación acreditada. |
| PA-T-INT03-A | PA-S01: PA-T02/03-BE y PA-T04-BE/DB; coordinación con PA-T16 de PA-S03. | Pendiente. Motor común de comandos, cargas, registro inicial LIFO, snapshots y recibo; primer consumidor del motor. |
| PA-T-INT02-C | PA-S03: PA-T12-BE, PA-T13-BE/DB y PA-T14-BE; PA-S00: roles/baja administrativa pendientes de ENT04-BE. | Pendiente. Gestión contextual, capacidades, búsqueda y cambios de autoridad sobre el motor de comandos probado. |
| PA-T-INT02-D | Políticas, rutas equivalentes y locks compartidos de PA-S00/01/03; PA-T16-QA y parte de INT08. | Pendiente en alcance completo. INT02-A adelantó el cierre de privacidad; falta autorización por objeto y concurrencia con plan/stock/logística/cierre. |
| PA-T-INT04 | PA-S01: PA-T06-FE y entrada pendiente de PA-S00: ENT05-FE. | Pendiente. Formulario participante con recuperación y contratos v1. El registro interno anterior se reutiliza. |
| PA-T-INT05 | PA-S02: PA-T07-BE/DB, PA-T08/09-FE, PA-T10/11; navegación pública de PA-S00. | Pendiente como entrega participante completa. Las regresiones públicas existentes de INT02-A no completan Impacto/Mis registros. |
| PA-T-INT06 | PA-S03: PA-T13/14-FE. | Pendiente. Interfaz de gestión sobre capacidades y comandos verificados. |
| PA-T-INT07 | PA-S04: PA-T17–21 y sus desgloses. | Pendiente. Casos de corrección y efectos propios por cerrar/verificar; D01–D12 no los aprueban en bloque. |
| PA-T-INT08 | ENT06-QA, PA-T05-QA, PA-T11-QA, PA-T16-QA y QA de PA-S04. | Pendiente para PA-F01 completo. Ensayo de corte, QA integrada, despliegue y decisión de piloto. |

INT02 agrupa A/B/C/D: cerrar A no completa INT02. El orden aceptado es **B → INT03-A → C → D**, con preparación de frontend y correcciones en paralelo cuando sus contratos lo permitan. Las garantías críticas de autorización, retirada, último administrador y recuperación deben estar verificadas antes de habilitar el registro participante real.

## Qué parte de las specs está implementada

| Spec / tareas | Cobertura acreditada | Qué falta para cumplirla |
|---|---|---|
| [PA-S00 · Entrada y perfil](../00-experiencia-participante/tasks.md) | INT02-A: identidad, alta VOLUNTARIO, perfil/afiliación y adaptación de acceso/navegación. QA de desarrollo GENERAL; mejora visual posterior con pruebas sintéticas. | Capacidades contextuales, entrada pública completa de Impacto, roles/baja administrativa y QA del recorrido completo. |
| [PA-S01 · Registro inicial](../01-registro-plantacion-inicial/tasks.md) | Recorrido funcional aprobado y registro interno anterior reutilizable. | Registro participante con permisos, comandos, cargas, LIFO, snapshots y recuperación; INT03-A/INT04 y regresiones D. |
| [PA-S02 · Consulta](../02-consulta-impacto-y-registros/tasks.md) | Comportamiento aprobado; APIs públicas existentes conservadas en el QA de INT02-A. | Proyección completa por audiencia, snapshots, Mis registros y pantallas/enlaces públicos PWA; INT05. |
| [PA-S03 · Acceso](../03-gestion-acceso-subcampania/tasks.md) | Diseño aceptado; base JWT/actividad y frontera interna reforzadas en A. | Modelo contextual/transición B, gestión/capacidades C, regresiones D e interfaz INT06. |
| [PA-S04 · Correcciones](../04-correccion-excepcional/tasks.md) | Acuerdos parciales confirmados. | Cierre de casos/contratos propios e implementación INT07 con evidencia de efectos e historial. |

La implementación sigue las specs por partes. El seguimiento anterior hace explícita la cobertura; ninguna spec se declara completada por tener un plan o por cerrar INT02-A.

## Fuentes para ejecutar

1. Ficha de la entrega: alcance, dependencias, tareas y salida verificable.
2. `spec.md` y `tasks.md` de las capacidades indicadas; `plan.md` para responsabilidades.
3. [Contrato backend aceptado](../contrato-identidad-permisos-backend-propuesta.md): §3–5 identidad/permisos, §6–8 registro/comandos/locks, §9 transición, §10 aceptación, §11 secuencia.
4. [Inventario de endpoints](../inventario-endpoints-y-regresion-participacion.md): mapa estático del 13 de octubre; contrastar contra el código actual antes de modificar rutas.

El [archivo](../archivo/README.md) conserva las actas y el plan técnico anterior con referencias a código, PA-DI, PA-CT y PA-Q. Se consulta para el detalle citado; el siguiente trabajo se mantiene en este tablero.

Al cerrar una entrega, actualizar esta tabla y las tareas afectadas, enlazar código/pruebas/SQL con su versión y entorno desde `ESTADO.md`, y archivar su encargo/cierre. La publicación Git, el despliegue y el piloto conservan evidencias separadas.
