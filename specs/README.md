# Especificaciones del incremento MVP

Esta carpeta contiene especificaciones pequeñas, planes y tareas del repositorio documental. No acredita implementación ni aprobación humana: cada `spec.md` requiere revisión propia antes de convertirse en base de construcción.

## Convenciones

- `feature`: resultado observable para la persona usuaria.
- `capability`: comportamiento verificable que contribuye a una feature.
- `component spec`: solo cuando existe un contrato técnico propio; no se crea por cada widget.
- Estados: **confirmado** (decisión humana), **propuesto** (alternativa de diseño), **pendiente** (requiere decisión o contraste).
- IDs existentes se conservan: `PA-F01` feature; `PA-S00`–`PA-S04` specs; `PA-C01`–`PA-C08` criterios iniciales; `PA-Sxx-USnn` historias y `PA-Sxx-CAnn` escenarios nuevos; `PA-T*` tareas; `PA-R*` riesgos; `PA-DI*` decisiones técnicas. `PA-D01`–`PA-D05` identifican diagramas, no decisiones.

## Feature

[PA-F01 Participación aliada en Plantación](plantacion/participacion-aliada/README.md): desde una cuenta nueva con experiencia enfocada hasta una plantación guardada por una persona autorizada, con consulta, acceso y corrección trazables. Conserva las herramientas del personal interno según sus facultades.

## Mapa de revisión

| Artefacto | Revisión humana | Estado documental |
|---|---|---|
| [PA-S00](plantacion/participacion-aliada/00-experiencia-participante/spec.md) | Primero: cuenta nueva y experiencia enfocada | Borrador para revisión |
| [PA-S02](plantacion/participacion-aliada/02-consulta-impacto-y-registros/spec.md) | Después: consulta y visibilidad | Borrador para revisión |
| [PA-S03](plantacion/participacion-aliada/03-gestion-acceso-subcampania/spec.md) | Acceso y revocación | Borrador para revisión |
| [PA-S01](plantacion/participacion-aliada/01-registro-plantacion-inicial/spec.md) | Registro inicial | Borrador para revisión |
| [PA-S04](plantacion/participacion-aliada/04-correccion-excepcional/spec.md) | Corrección excepcional | Borrador condicionado a diseño previo al campo |

Cada carpeta contiene `spec.md`, `plan.md` y `tasks.md`. Consulta el [plan general](plantacion/participacion-aliada/plan-inicial.md), el [diseño de frontend/backend/datos](plantacion/participacion-aliada/diseno-tecnico-compartido.md), el [boceto](plantacion/participacion-aliada/boceto-registro-resultado.md) y los [diagramas](plantacion/participacion-aliada/diagramas/README.md).
