# PA-T-INT05 — Impacto público y Mis registros

**Cerrada en alcance técnico local:** BE01–BE06 y FE01–FE06. Consolidación del 19 de octubre de 2026; backend en commit local `8dc8efc` y PWA `a3a4b28`. Push pendiente. [Tablero](README.md).

## Resultado y fuentes

Consulta pública global → campaña → subcampaña → registro/foto, sin sesión; «Mis registros» por autoría/participación histórica, indicadores grupales deduplicados, snapshots y preferencia por campaña. Conserva registro INT04 y gestión INT06. El [encargo archivado](../archivo/pa-t-int05.md) mantiene los criterios, tareas y fuentes originales.

## Backend/DB — `Backend-r3foresta`

BE01–BE06 completadas; [tareas archivadas](../archivo/pa-t-int05.md#backenddb--backend-r3foresta). SQL 081, build, 65 suites/816 unitarios y 16 casos HTTP/SQL/Storage acreditados en el corte original del 17. Revisión de consolidación sin defectos bloqueantes, huellas cotejadas y OpenAPI reproducible; comprobación adicional de 3 suites/40 pruebas aprobada. [Cierre/versiones](../archivo/cierre-pa-t-int05-backend.md), [contrato/entorno y evidencia](../../../../../Backend-r3foresta/docs/pa-int05-entrega-local.md).

## Frontend — `pwa-r3foresta`

FE01–FE06 completadas; [tareas archivadas](../archivo/pa-t-int05.md#frontend--pwa-r3foresta). Corte original del 18: 48 suites/691 pruebas, lint/build y 111 comprobaciones integradas/SQL, incluidas nuevas regresiones INT04/INT06. Revisión de consolidación sin defectos bloqueantes y huellas cotejadas. [Cierre/versiones](../archivo/cierre-pa-t-int05-frontend.md), [informe/capturas y reproducción](../../../../../pwa-r3foresta/docs/QA_IMPACTO_INT05.md).

## Evidencia, cierre y límites

Las bases originales `10e5dc5`/`6a2c955` y sus manifests se conservan. Los ajustes posteriores al cotejo de fuentes son documentales; los commits de entrega no representan una repetición de todas las pruebas. Esta ruta mantiene los enlaces y anchors anteriores.

Push, aplicación/cotejo remotos 081 y antecedentes pendientes, transición B/C, Storage/URLs/CDN históricos, revisión humana, WebAuthn real, entorno externo, QA completo, corte/despliegue y piloto mantienen evidencia separada. INT06-FE06 sigue parcial; PA-S00/02/03, tareas padre de QA y PA-F01 no se declaran completas.

La siguiente preparación funcional es INT07/PA-S04: concretar sus casos/efectos/contratos pendientes antes de implementar. INT08 conserva QA/corte/despliegue/piloto. El orden y los pendientes se mantienen en el [tablero único](README.md).
