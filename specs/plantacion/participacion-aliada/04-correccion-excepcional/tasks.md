# Tareas — PA-S04

**Estado:** pendientes para revisión/ejecución. Se conservan PA-T17–21; no se acredita ningún caso corregido.

- `PA-T20` Redactar matriz de efectos por campo corregible.
- `PA-T21` Preparar escenario de corrección sin retorno automático de stock.

La matriz está propuesta en [spec](spec.md); PA-T20 requiere revisarla y cerrar efectos, no solo escribirla. PA-T17/18/19 se mantienen en [plan](plan.md).

| ID | Entrega | Depende de | Evidencia de terminación |
|---|---|---|---|
| PA-T17-REV | Revisar catálogo de casos/campos, hechos necesarios y tratamiento de casos no soportados. | PA-T20; decisión humana PA-DI07. | Casos permitidos/rechazados y límites explícitos; sin delegar edición general al administrador. |
| PA-T18-BE | Contrato de revisión/ejecución central con identidad, lista blanca, motivo, versión e intento recuperable. | PA-T17-REV, PA-DI03/05. | CA01/03/04; no hay cambios por actor ajeno o campo libre, ni reenvío con doble efecto. |
| PA-T18-DB | Migración nueva de corrección/historial y efectos transaccionales del caso aprobado. | Contrato PA-T18-BE y esquema inspeccionado. | CA02/04–06; original y auditoría preservados, rollback completo, saldos conforme a hechos. |
| PA-T18-FE | Orientación ante error y lectura de corrección por audiencia; herramienta central mínima si se acuerda. | PA-DI05, contrato backend y PA-S02. | Persona distingue aviso pendiente de corrección aplicada; no aparece editor general ni aprobación de envíos. |
| PA-T19-INT | Integrar lecturas/agregados y verificar compatibilidad con cantidades, estados, mortandad/reposición existentes. | Efectos PA-T20 y PA-T18-BE/DB. | CA05–07; ningún doble conteo ni eliminación de hechos posteriores. |
| PA-T21-QA | Probar caso realista sintético de error, corrección/repetición, falta de autoridad y caso no soportado. | Mecanismo implementado en entorno aislado. | CA01–08 con ID original/corrección, actor, saldos antes/después y resultado visible; evidencia para decidir campo. |

Coordinar PA-T-INT07/08 del [plan de integración](../plan-reutilizacion-integracion.md). Ninguna tarea autoriza ejecutar SQL productivo o corregir registros reales al revisar esta documentación.
