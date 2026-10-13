# Plan — PA-S04

**Estado:** propuesta de diseño, no mecanismo implementado. Esta capacidad se define desde el inicio de Elaboración y se verifica antes de campo.

**Actualización 12 de octubre:** [acuerdo humano](../revision-correcciones-2026-10-12.md) confirma aumento/reducción de cantidad por ADMIN global o administrador contextual en su subcampaña, sin bajas/reposiciones ni cambio de especies. Reducción requiere confirmar disponibilidad física de la diferencia; aumento requiere saldo elegible. Participantes: ambos administradores, únicamente en ACTIVA, con listas anterior/nueva, actor, fecha y motivo; la habilitación operativa actual del participante no es requisito para corregir historia comprobada ni se restaura por esa corrección. Observaciones conserva ejecutor central. Confirmado posteriormente: solo subcampañas ACTIVA; cantidad cero fuera del ajuste simple. Decisión posterior: reversión de duplicados y eliminación lógica de plantación/baja/reposición erróneas por ADMIN global o administrador de esa subcampaña, con historial y compensaciones específicas; no cascada de hechos reales. No se aprueba toda PA-S04. Ver [instrucciones implementables](../instrucciones-implementacion.md), CT08..10.

- `PA-T17` Definir casos y campos de corrección.
- `PA-T18` Definir historial, vínculo al original y auditoría.
- `PA-T19` Verificar saldos/estados y preparar prueba antes de campo.

## Reparto técnico

| Capa | Trabajo propuesto | Límite |
|---|---|---|
| UX/frontend | «Corregir cantidad»: valor efectivo, cantidad propuesta, motivo, diferencia a consumir/liberar y confirmación explícita de disponibilidad física al reducir. Acceso global/contextual según capacidad; resultado/historial autorizados. | No editor general, tickets ni aprobación central adicional para la cantidad contextual admitida; ofrecer reversiones/eliminaciones lógicas por casos admitidos, con original/motivo/resumen de efectos; no editor libre. |
| Backend | Comando por caso: JWT y autoridad global o contextual según campo, motivo, versión, ausencia de bajas/reposiciones para ajuste de cantidad, especies preservadas, saldo y declaración requerida al reducir. Reversión específica de duplicados y plantación/baja/reposición erróneas con validación de consumo efectivo y dependencias, sin cascada. Resultado recuperable; lecturas por audiencia. | No PATCH arbitrario ni confiar en rol, saldo o pertenencia declarados por cliente. |
| DB | Evento/registro de corrección vinculado, valores anteriores/nuevos, actor/fecha/motivo; versión/idempotencia; efectos e historial atómicos. | No borrar originales, alterar snapshots retroactivamente ni devolver stock sin hecho físico y comando aprobado. |
| Consulta/integración | Resolver la presentación efectiva y agregados con PA-S02; preservar hechos de PA-S01 y reposiciones existentes. | Una corrección no se cuenta como otra plantación. |

Ver alternativas de persistencia en [diseño compartido](../diseno-tecnico-compartido.md). No elegir una tabla o reutilizar un evento incompatible antes de precisar PA-DI07.

## Puerta de implementación y de campo

Primero revisar [matriz de casos](spec.md), después contrato/efectos y persistencia, finalmente implementar el caso acotado y probarlo con datos sintéticos. Para cambios de cantidad, documentar saldo anterior, hecho real, compensaciones permitidas y resultado esperado por asignación/grupo antes de programar.

Añadir pruebas CA14..18: duplicado 30+30 queda en 30 y recupera solo consumo duplicado; baja errónea no libera stock; reposición errónea libera consumo a REPOSICION. Conservar originales; rechazar dependencias reales incompatibles.

La verificación debe demostrar: acceso global y contextual propio, rechazo de plantador/autor sin facultad y administrador de otra subcampaña, original intacto, auditoría completa, corrección repetida/concurrente, consumo físico y lectura deduplicada. Probar también aparición concurrente de baja/reposición y cambios de permiso/cierre/devolución, con serialización y rechazo seguro. La reducción restituye consumo a asignaciones trazables sin modificar cantidad entregada ni saldo del vivero; definir orden de reversión y correcciones sucesivas antes de SQL. Un canal de contacto abierto o una anotación documental no satisface la salida a piloto. Si casos críticos siguen sin resolución segura, revisar fecha/alcance con el usuario; no declarar preparada esta capacidad.
