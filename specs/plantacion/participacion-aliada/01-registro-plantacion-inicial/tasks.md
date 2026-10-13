# Tareas — PA-S01

- `PA-T01` Revisar boceto y criterios con el usuario.
- `PA-T02` Documentar matriz de autorización/guardado/retiro y concurrencia.
- `PA-T03` Contrastar GPS contra handoff, RN-PLA-32 y RPC local vigente 061; conservar 053 como antecedente y registrar PA-DI04.
- `PA-T04` Contrastar selección FIFO, stock asignado e idempotencia; acordar contrato de intento/recibo PA-DI06 y su persistencia antes del código.
- `PA-T05` Preparar guion de verificación del flujo y del comprobante.
- `PA-T06` Solo después de revisión: implementar/verificar en el repositorio de código del usuario.

## Desglose para ejecutar después de la revisión

Todas pendientes; los sufijos preservan PA-T01–06. No se marca implementación por redactar esta lista.

| ID | Entrega | Depende de | Terminación verificable |
|---|---|---|---|
| PA-T01-UX | Revisar historias, tres pasos, cantidades, responsable/participantes y recuperación. | PA-S00, PA-DI04/10 y boceto. | Recorrido y textos aceptados; cambios/preguntas documentados. |
| PA-T02-BE | Identidad verificada, contexto y guardado autorizados por subcampaña. | Contrato PA-S03; PA-T02. | CA01/06/08; sin bypass por headers, rol global o ruta legada. |
| PA-T03-BE | Validación de GPS/fecha y errores acordados; selección válida de participantes. | PA-DI04. | CA09/10 y casos de fecha/participante revocado conforme al contrato. |
| PA-T04-DB | Migración de guardado/idempotencia, recibo y bloqueo compartido con permisos/stock. | PA-T02/04; diseño compartido aprobado. | CA05–07; una transacción/un consumo, sin alterar cantidad asignada ni debitar otra vez Vivero. |
| PA-T04-BE | Consulta del mismo intento/detalle propio, huella, evidencia y recuperación. | Contrato PA-DI06 y PA-T04-DB. | Respuesta perdida recuperable; conflicto de contenido distinguible; no eliminar evidencia confirmada. |
| PA-T06-FE | Integrar formulario existente, capacidades, resumen y comprobante/reintento. | PA-T01-UX y contratos backend. | CA02–04/07–10; conserva datos, controla doble clic y usa siempre identidad durable del intento. |
| PA-T05-QA | Ejecutar guion por capas con datos sintéticos, PostGIS real y concurrencia. | Entregas anteriores en entorno aislado autorizado. | Evidencias de CA01–11, regresión de meta/plan/cierre, saldos y trazabilidad; fallos pendientes explícitos. |

Coordinar con PA-T-INT02/03/04/08 del [plan de integración](../plan-reutilizacion-integracion.md). Pruebas y migraciones son trabajo posterior; no se ejecutan contra producción como parte de revisar estos documentos.
