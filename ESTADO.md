# Estado de implementación

**Corte documental:** 15 de octubre de 2026. Registra hechos acreditados y pendientes; las reglas viven en los módulos, specs y contratos. El [registro acumulado](archivo/estado-2026-10-14.md) conserva las comprobaciones y cierres previos con sus fechas.

## Trabajo actual — PA-F01

[PA-T-INT02-C](specs/plantacion/participacion-aliada/implementacion/pa-t-int02-c.md) tiene **BE01–BE06 verificados localmente; listo para integración local de INT06**. [Entrega reproducible](../Backend-r3foresta/docs/pa-int02c-entrega-local.md): 14 rutas v1, OpenAPI/ejemplos HTTP reales, build, 58 suites/636 pruebas unitarias, 22 grupos PostgreSQL/8 carreras y 13 pruebas HTTP aprobadas. HEAD backend `57e5b715` más árbol B/C sin commit publicado; PostgreSQL local 14.17 C.UTF-8 aislado. Pablo confirma 072/073 aplicadas sin errores en desarrollo `vyrjlehkhabydkhjxagx`; REST confirma 35 probes/19 denegaciones anon. Continuación del 15: entorno sintético persistente en `127.0.0.1:3302` con ocho perfiles y 30 comprobaciones HTTP; aplicación completa con Supabase de desarrollo, 18 probes sin personas/comandos válidos; cotejador SQL con 26 pruebas y 18 huellas locales coincidentes. CORS expone Retry-After para recuperación 202. Igualdad de cuerpos SQL remotos/catálogo y despliegue externo aún por acreditar; el entorno local ya es consumible por frontend. C anticipó el motor común sin fotos porque INT03-A estaba ausente; no implementa registro/cargas/LIFO/stock ni acredita las carreras de D. La continuidad probada es cooperativa entre RPC; el servicio SQL privilegiado conserva el límite de §8.3. No se completa INT02, ninguna spec ni el piloto.

Participación aliada está **parcialmente implementada**. [PA-T-INT02-B — permisos, revisiones y transición](specs/plantacion/participacion-aliada/implementacion/pa-t-int02-b.md) tiene cierre técnico local parcial: 068–071, DDL compartido, vigencias/revisiones/historial/privilegios y bootstrap sintético ensayados. [Informe reproducible](../Backend-r3foresta/docs/pa-int02b-entrega-local.md): build, 594 pruebas backend y 53 casos PostgreSQL/78 denegaciones aprobados. Pablo confirma 068–071 sin errores en desarrollo `vyrjlehkhabydkhjxagx`; REST y estado SQL compacto PG17.6 cotejados (41 restricciones, 17 FKs RESTRICT, 12 combinaciones ACL y seis huellas de funciones coincidentes). Catálogo complementario, foto previa y manifest real revisado pendientes. No hay commit/push/despliegue acreditados en B. INT03-A recibe la base local para implementar el motor. [INT02-C — APIs/comandos backend](specs/plantacion/participacion-aliada/implementacion/pa-t-int02-c.md) adelantó el motor sin fotos y verificó gestión local; [INT06 — gestión frontend](specs/plantacion/participacion-aliada/implementacion/pa-t-int06.md) implementó/verificó localmente FE01–FE05 sobre C y conserva FE06 parcial, con revisión humana y QA integrado pendientes. El cotejo compacto SQL/REST de B acredita esquema y privilegios observados; catálogo complementario y transición de personas reales siguen pendientes. El [tablero de ejecución](specs/plantacion/participacion-aliada/implementacion/README.md) mantiene el orden y la cobertura de PA-S00–04; no se completa INT02 ni PA-F01 al cerrar INT02-A.

## Avance local de PA-T-INT06 — 15 de octubre de 2026

**FE01–FE05 implementadas/verificadas localmente; FE06 parcial.** La PWA integra gestión contextual C04–C09, capacidades por cuenta, miembros/búsqueda/revisión, selección múltiple y confirmación; conserva actor/operación/payload y el mismo UUID ante pérdida de respuesta. El cliente valida recibos y distingue terminal histórico de capacidades vigentes; Web Locks y almacenamiento por actor bloquean confirmaciones nuevas mientras exista incertidumbre. La UI queda revisable; no se acredita revisión humana de UX.

Revisiones de trabajo: PWA `cf130365` más árbol, backend `57e5b715` más árbol C y documentación `89dfdb2` más árbol. El [informe PWA de INT06](../pwa-r3foresta/docs/QA_GESTION_ACCESOS_INT06.md) registra comprobaciones automatizadas y evidencia local navegador → API → DB en el entorno sintético persistente de C; no equivale a un despliegue externo ni a una sesión WebAuthn real del nuevo recorrido.

PA-T13-FE/PA-T14-FE actualizan sólo su alcance local implementado. FE06, PA-T16-QA/ENT06-QA e INT08 siguen abiertos: faltan D y las carreras/regresiones compartidas, registro/cargas INT03-A/INT04, Impacto/Mis registros INT05, WebAuthn y un entorno externo identificado. Tampoco se acreditan publicación Git ni despliegue de esta continuación. Este avance no completa PA-S00/PA-S03, INT02 o PA-F01 ni habilita el piloto.

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
