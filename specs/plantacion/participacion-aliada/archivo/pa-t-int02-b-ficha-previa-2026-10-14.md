> Ficha previa conservada el 14 de octubre de 2026, antes del desglose por equipos. Para ejecutar, consultar la [ficha vigente de INT02-B](../implementacion/pa-t-int02-b.md) y el [tablero](../implementacion/README.md). Esta copia no acredita implementación.

# PA-T-INT02-B — Permisos, revisiones y transición

**Estado al 14 de octubre de 2026:** ficha preparada; implementación pendiente. Organizar esta entrega no aplica SQL ni asigna permisos. **Padre:** PA-T-INT02, dentro de [PA-F01](../README.md). **Capacidad principal:** [PA-S03 · Gestión de acceso](../03-gestion-acceso-subcampania/spec.md). **Consumidores:** PA-S00 y PA-S01.

## Resultado esperado

Preparar y verificar la persistencia de permisos por persona/subcampaña, con vigencias, revisión estable e historial, y ensayar la transición de usuarios existentes. Entregar migraciones aditivas revisables, una propuesta explícita de correspondencia de personas/ámbitos y pruebas aisladas. Preservar roles, equipo, perfiles e historia existentes.

Esta es la base de acceso de PA-S03; la afiliación a una organización no otorga autoridad. La gestión HTTP de permisos/roles corresponde a INT02-C; el registro participante recuperable empieza en INT03-A.

## Entradas mínimas

- [Cierre de INT02-A](cierre-pa-t-int02-a.md): backend `57e5b71`, PWA `cf13036` y 064–067 confirmadas en desarrollo. Comprobar el estado actual de los repositorios antes de editar; esas revisiones son evidencia, no una orden de reset.
- [Contrato D01–D12 aceptado](../contrato-identidad-permisos-backend-propuesta.md), especialmente §5.1, §8, §9, §10 y §11. D04 acepta vigencias/revisión estable e historial; D03/D05/D06 definen autoridad y continuidad. No se repite su aprobación.
- [PA-S03: tareas](../03-gestion-acceso-subcampania/tasks.md) PA-T12-DB, PA-T12-REV/PA-T15 y preparación de PA-T13-DB; [PA-S00](../00-experiencia-participante/tasks.md) ENT02/ENT04-DB.
- [Inventario estático](../inventario-endpoints-y-regresion-participacion.md) y [consulta preparada](../sql/inventario-contratos-solo-lectura.sql). El cotejo realizado para identidad no acredita el catálogo contextual completo.

## Trabajo verificable

- [ ] Identificar entorno y revisiones. Cotejar en lectura `usuario`, `subcampania`, equipo e historial: tipos, FKs, enums, índices, grants/RLS y consumidores. Registrar las diferencias respecto al contrato.
- [ ] Preparar migración aditiva de `subcampania_permiso_revision`, `subcampania_permiso`, extensión de `subcampania_historial` y marca de inicialización conforme a §5.1. Coordinar las FKs de comando con INT03-A; si requieren una base compartida, documentar esa dependencia sin crear una vía operativa provisional.
- [ ] Verificar PK/FK, unicidad de vigencia, catálogo contextual cerrado, retiro consistente, revisión conservada y privilegios. ADMINISTRADOR_SUBCAMPANIA incluye plantar; ADMIN global se reconoce de forma derivada.
- [ ] Preparar la correspondencia `{usuario_id, subcampania_id, permiso_propuesto, justificacion, fuente_legada, decision_revisor}` con sus excepciones. GENERAL o COORDINADOR existentes no se convierten automáticamente en permisos contextuales. Pablo revisa las personas/ámbitos concretos antes de aplicar la transición, como establece §9.
- [ ] Ensayar inicialización/transición en PostgreSQL aislado con datos sintéticos: ámbitos activos y cerrados, cuentas activas/inactivas, administración inicializada y todavía no inicializada. Conservar roles/equipo/historia y registrar rechazo sin cambios ante inconsistencias.
- [ ] Verificar que la base representa la continuidad del último administrador contextual efectivo y los casos de dos administradores. La garantía operativa y sus carreras con retiro/baja se completan con los comandos y locks de C/D; no acreditarlas solo con un índice.
- [ ] Entregar evidencia por comando/resultado, límites y dependencias pendientes. Actualizar el [tablero](../implementacion/README.md), las tareas afectadas y [ESTADO.md](../../../../ESTADO.md) según lo efectivamente ejecutado.

## Criterio de salida y siguiente consumidor

Migración y ensayo reproducibles, esquema cotejado, permisos del cliente cerrados y propuesta de transición revisable. Cualquier aplicación remota y la revisión concreta de personas deben quedar acreditadas por separado. El bootstrap legado cerrado es acotado y auditable; no abre designaciones ordinarias en estados cerrados.

INT03-A consume esta base para revalidar permisos y registrar de forma atómica. INT02-C integra la gestión administrativa sobre el motor común; INT02-D completa el corte y las regresiones compartidas. Esta ficha no habilita el piloto.
