# Estado de implementación

**Corte documental:** 14 de octubre de 2026. Registra hechos acreditados y pendientes; las reglas viven en los módulos, specs y contratos. El [registro acumulado](archivo/estado-2026-10-14.md) conserva las comprobaciones y cierres previos con sus fechas.

## Trabajo actual — PA-F01

Participación aliada está **parcialmente implementada**. La siguiente entrega es [PA-T-INT02-B — permisos, revisiones y transición](specs/plantacion/participacion-aliada/implementacion/pa-t-int02-b.md), preparada documentalmente y pendiente de implementación. El [tablero de ejecución](specs/plantacion/participacion-aliada/implementacion/README.md) mantiene el orden y la cobertura de PA-S00–04; no se completa INT02 ni PA-F01 al cerrar INT02-A.

## Cierre de PA-T-INT02-A — 14 de octubre de 2026

**Completado** para identidad JWT, alta VOLUNTARIO, perfil/afiliación, privacidad e integración de desarrollo. [Cierre con versiones, pruebas y límites](specs/plantacion/participacion-aliada/archivo/cierre-pa-t-int02-a.md).

| Capa | Evidencia acreditada |
|---|---|
| Código / Git | Backend `57e5b71` y PWA `cf13036` publicados en main. |
| SQL en desarrollo | 064–067 aplicadas y verificadas en `vyrjlehkhabydkhjxagx`, identificado por Pablo. 39 cuentas y roles conservados. Privacidad y timeouts PostgREST verificados. |
| Integración | Passkey real y cuenta GENERAL en localhost: perfil, catálogo/Otra/ausencia, recargas, identidad/autoridad, plan e Impacto. |
| Mejora visual posterior | Pruebas/capturas con HTTP sintético. Pendiente repetir passkey/persistencia sobre esa mejora y probar la foto real. |
| Despliegue / piloto de PA-F01 | **No acreditados.** Publicación Git y aplicación SQL de desarrollo no los sustituyen. |

La gestión contextual, el registro participante recuperable, LIFO y los snapshots nuevos se completan en las entregas posteriores. Impacto público conserva APIs existentes; faltan las pantallas/rutas PWA del incremento. El QA GENERAL de A no acredita un registro participante real.

## Base existente y pendientes conservados

| Área | Última evidencia conservada | Pendiente material |
|---|---|---|
| Integración física M2↔M3 y desactivación de campaña | Código 051–057, contrato físico y despliegue coordinado confirmados el 23 de julio; 056/057 confirmadas en producción. [Detalle](archivo/estado-2026-10-14.md#integración-módulo-2-vivero--módulo-3-plantación). | Mantener consumo de asignación sin otro débito de Vivero. El nuevo registro participante no queda acreditado por este cierre interno. |
| Plan de meta/especies (ADR-PLA-05) | 062/063 confirmadas aplicadas; editor/backend y pruebas locales. GET de GENERAL y rechazo de PUT comprobados en desarrollo durante A. [Cierre del plan](03-plantacion-module/07_revision_meta_especies_cierre.md). | QA integrado completo de edición ADMIN, concurrencia, cierre y operación desplegada; la lectura probada no completa ese recorrido. |
| Descarte pre-embolsado | Backend/frontend y pruebas documentados. [Detalle](archivo/estado-2026-10-14.md#vivero-core--descarte-pre-embolsado). | La confirmación específica de aplicación remota de 046 sigue sin acreditarse en ese registro. |
| Despacho manual y reproducibilidad SQL | [Hallazgos de julio](archivo/estado-2026-10-14.md#hallazgos-de-auditoría-backend--2026-07-23). | Alinear RF-VIV-05 (comunidad/referencia); resolver replay del enum de destino y drift de TIPO_PLANTA. Sin cierre posterior acreditado. |
| Ciclo de vida de Plantación | Plan/cancelación/historial existentes. [Detalle M3](archivo/estado-2026-10-14.md#módulo-3-plantación--creaciónplaneación-de-subcampaña). | Eventos de cierre/equipo, job nocturno a MONITOREO_HISTORICO y vista/uso público de campania_estado por confirmar. Merma de stock de campo y mantenimiento avanzado conservan su alcance fuera de este cierre. |
| Seguridad y regresión restantes | A reforzó JWT/actividad, fronteras privadas y grants. [Detalle de A](specs/plantacion/participacion-aliada/archivo/cierre-pa-t-int02-a.md). | Permisos por objeto, locks/rutas equivalentes y regresión completa en B/C/D; la auditoría antigua no describe por sí sola el código actual. Deuda de lint global backend pendiente. |
| Ramas de trabajo anteriores | [Auditoría del 14 de octubre](../Backend-r3foresta/docs/revision-ramas-2026-10-14.md). | Impacto backend; dev/auditoría locales PWA; proyección/carbono y flujo de recolección remoto en docs. No se fusionaron ni eliminaron las ramas pendientes en ese cierre. |

## Cómo registrar el siguiente cierre

Actualizar la entrega y las tareas de las specs afectadas; enlazar su evidencia aquí con revisión y entorno. Distinguir código, pruebas, SQL aplicado, Git y despliegue. El [archivo](archivo/README.md) conserva el detalle histórico; los pendientes sin cierre siguen visibles en este estado y en el tablero correspondiente.
