# Tareas — PA-S04

**Estado:** pendientes para revisión/ejecución. Se conservan PA-T17–21; no se acredita ningún caso corregido.

**Acuerdo del 12 de octubre incorporado:** [acta](../revision-correcciones-2026-10-12.md). Cantidades por ADMIN global y administrador de la subcampaña, sin bajas/reposiciones ni cambio de especies; aumento con stock y reducción con disponibilidad física confirmada. PA-T17-REV no debe volver a preguntar estas decisiones; ACTIVA y exclusión de cero del ajuste simple también confirmadas. La ampliación posterior admite duplicados y plantación/baja/reposición erróneas mediante reversión/eliminación lógica por ADMIN global o administrador de esa subcampaña; no cascada de hechos reales. Participantes también confirmado: ambos administradores, únicamente en ACTIVA, con historial visible de cambio y actor, sin alterar responsable original ni stock. Quedan contratos de búsqueda histórica/visibilidad y de compensación por caso, propuestos en [instrucciones implementables](../instrucciones-implementacion.md).

- `PA-T20` Redactar matriz de efectos por campo corregible.
- `PA-T21` Preparar escenario de corrección sin retorno automático de stock.

La matriz está propuesta en [spec](spec.md); PA-T20 conserva revisión técnica de efectos; catálogo ampliado por confirmación humana. Instrucciones CT08..10 y PA-Q08..10 preparadas, sin implementación. PA-T17/18/19 se mantienen en [plan](plan.md).

| ID | Entrega | Depende de | Evidencia de terminación |
|---|---|---|---|
| PA-T17-REV | Revisar catálogo de casos/campos, hechos necesarios y tratamiento de casos no soportados. | PA-T20; decisión humana PA-DI07. | Casos permitidos/rechazados y límites explícitos; sin delegar edición general al administrador. |
| PA-T18-BE | Contrato de ejecución global/contextual por caso, identidad, ámbito, campos permitidos, motivo, versión, ausencia de bajas/reposiciones para ajuste de cantidad, y resultado recuperable. Reversiones específicas CT09/10 con dependencias y consumo efectivo. | PA-T17-REV, PA-DI03/05. | CA01/03/04/09–13; sin corrección en ámbito ajeno, campos libres o repetición con doble efecto. |
| PA-T18-DB | Migración nueva de corrección/historial y efectos transaccionales del caso aprobado. | Contrato PA-T18-BE y esquema inspeccionado. | CA02/04–06; original y auditoría preservados, rollback completo, saldos conforme a hechos. |
| PA-T18-FE | Acción «Corregir cantidad» para autoridad global/contextual permitida; motivo, resumen del delta, confirmación física al reducir y resultado/historial por audiencia. | PA-DI05, contrato backend y PA-S02. | Persona distingue propuesta de corrección aplicada; no hay editor general, elección de vivero ni reapertura implícita. |
| PA-T19-INT | Integrar lecturas/agregados y verificar compatibilidad con cantidades, estados, mortandad/reposición existentes. | Efectos PA-T20 y PA-T18-BE/DB. | CA05–07; ningún doble conteo ni eliminación de hechos posteriores. |
| PA-T21-QA | Probar caso sintético de aumento/reducción, repetición, concurrencia con bajas/reposiciones, falta de autoridad y duplicado, plantación/baja/reposición erróneas y caso no soportado. | Mecanismo implementado en entorno aislado. | CA01–18 con ID original/corrección, actor, saldos por asignación antes/después, vivero intacto y resultado visible; evidencia para decidir campo. |

Coordinar PA-T-INT07/08 del [plan de integración](../plan-reutilizacion-integracion.md). Ninguna tarea autoriza ejecutar SQL productivo o corregir registros reales al revisar esta documentación.
