# Plan — PA-S01

**Estado:** propuesta técnica del 10 de octubre; leer primero [spec](spec.md). Se conserva el orden de riesgos, con recuperación del guardado como condición crítica del piloto.

1. **P0:** resolver autorización frente a retiro y concurrencia (`PA-R01`), coordinado con PA-S00/03.
2. **P0:** alinear GPS y documentar la regla que gobernará el piloto (`PA-R02`, PA-DI04).
3. **P0:** contrastar consumo/idempotencia contra contrato y RPC local 061 (`PA-R03`, PA-DI06); 053 sirve como antecedente.
4. Revisar [boceto](../boceto-registro-resultado.md) y estados con el usuario; puede hacerse en paralelo al contraste técnico.
5. **P0:** definir y probar resultado incierto, recuperación del mismo intento, evidencia y comprobante persistido; forma parte del guardado, no un añadido posterior.

| Capa | Trabajo | Evidencia requerida |
|---|---|---|
| Frontend | Reutilizar tres pasos, selector, carga de fotos y contadores; adaptar capacidades, resumen, estados y recuperación. | CA01–04/07–10; navegación conserva datos, no emite éxito sin comprobante ni un nuevo intento automático. |
| Backend | JWT, contexto/participantes autorizados, evidencias propias, errores tipados y consulta de intento/detalle. | HTTP permite ámbito propio y rechaza ajeno, actor falsificado y evidencia no autorizada; lectura propia tras revocación. |
| DB | Nueva migración de RPC y persistencia del intento según diseño aprobado; permiso, stock, registro/detalles, vínculo de evidencias y recibo atómicos. | PostgreSQL aislado: doble petición, competencia por stock y ambos órdenes de revocación; rollback completo ante fallo. |
| Integración | Conectar entrada PA-S00, permisos PA-S03 y detalle PA-S02; preparar salida PA-S04. | Navegador → API → DB con ID, cantidades, fotos y stock verificados sobre versiones identificadas. |

Referencias de archivos reutilizables: [plan de integración](../plan-reutilizacion-integracion.md). Contratos/tablas candidatas: [diseño compartido](../diseno-tecnico-compartido.md). No duplicar formulario, stock ni backend de Plantación.

Fijar por escrito DTO/errores, fuente de permiso, punto de autorización, clave/huella/retención, reglas de evidencia, FIFO y GPS antes de implementar sus partes. Mantener invariantes de reposición ya existentes al modificar la RPC compartida, aunque la nueva UI solo capture plantación inicial. Probar regresión de plan/meta/cierre y que clientes antiguos no eludan las garantías.

No se inicia implementación de una tarea que dependa de un P0 abierto.
