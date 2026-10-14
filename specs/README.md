# Specs y ejecución del incremento

Las specs expresan el comportamiento que debe cumplir el producto. En PA-F01 **se están implementando por partes**: INT02-A cubre identidad/perfil y su integración; acceso contextual, registro recuperable, consulta completa y correcciones continúan pendientes según su alcance. [Estado acreditado](../ESTADO.md).

## Entrada activa

[PA-F01 — Participación aliada en Plantación](plantacion/participacion-aliada/README.md) → [tablero de ejecución](plantacion/participacion-aliada/implementacion/README.md) → [siguiente entrega INT02-B](plantacion/participacion-aliada/implementacion/pa-t-int02-b.md).

| Capacidad | Fuente funcional |
|---|---|
| PA-S00 · Entrada y experiencia participante | [spec](plantacion/participacion-aliada/00-experiencia-participante/spec.md) · [tareas](plantacion/participacion-aliada/00-experiencia-participante/tasks.md) |
| PA-S01 · Registro inicial | [spec](plantacion/participacion-aliada/01-registro-plantacion-inicial/spec.md) · [tareas](plantacion/participacion-aliada/01-registro-plantacion-inicial/tasks.md) |
| PA-S02 · Consulta de impacto y registros | [spec](plantacion/participacion-aliada/02-consulta-impacto-y-registros/spec.md) · [tareas](plantacion/participacion-aliada/02-consulta-impacto-y-registros/tasks.md) |
| PA-S03 · Gestión de acceso por subcampaña | [spec](plantacion/participacion-aliada/03-gestion-acceso-subcampania/spec.md) · [tareas](plantacion/participacion-aliada/03-gestion-acceso-subcampania/tasks.md) |
| PA-S04 · Corrección excepcional | [spec](plantacion/participacion-aliada/04-correccion-excepcional/spec.md) · [tareas](plantacion/participacion-aliada/04-correccion-excepcional/tasks.md) |

## Una cadena de consulta

`spec (qué debe pasar) → plan (responsabilidades) → tareas por capacidad → entrega INT → cambio y prueba → evidencia de cierre`.

Cada carpeta de capacidad mantiene `spec.md`, `plan.md` y `tasks.md`. Las entregas INT cruzan capacidades y capas de aplicación; el [tablero](plantacion/participacion-aliada/implementacion/README.md) enlaza sus tareas sin crear otra spec ni duplicar implementaciones. INT02-B desarrolla la base de PA-S03 que también necesitan PA-S00 y PA-S01.

## Fuentes y estados

- **Producto:** specs y ADR. PA-S00/01/02/03 tienen comportamiento aprobado; PA-S04 conserva revisión integral propia pendiente.
- **Mecanismos técnicos:** contrato backend D01–D12 aceptado el 13 de octubre. Su aceptación no completa código, SQL ni pruebas.
- **Ejecución:** tablero y tareas, con alcance parcial explícito. El siguiente trabajo se actualiza allí.
- **Evidencia:** ESTADO y cierres enlazados, con versión/entorno. Código, prueba, SQL aplicado, publicación Git, despliegue y piloto se acreditan por separado.
- **Historia:** archivo del incremento. Las actas acreditan decisiones; los planes previos conservan contexto y se consultan con su fecha.

IDs estables: PA-F01, PA-S00–04, PA-Sxx-USnn/CAnn y PA-T*. D01–D12 son decisiones del contrato; PA-DI* son cuestiones de diseño trazadas; PA-D01–05 identifican diagramas. La numeración de carpetas no impone el orden de implementación.

Al terminar una entrega, actualizar las tareas afectadas y el tablero, enlazar el cierre desde ESTADO y archivar el encargo concluido. Una tarea parcialmente cubierta conserva sus componentes pendientes; no se marca toda la spec completada.
