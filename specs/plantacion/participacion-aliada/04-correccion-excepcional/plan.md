# Plan — PA-S04

**Estado:** propuesta de diseño, no mecanismo implementado. Esta capacidad se define desde el inicio de Elaboración y se verifica antes de campo.

- `PA-T17` Definir casos y campos de corrección.
- `PA-T18` Definir historial, vínculo al original y auditoría.
- `PA-T19` Verificar saldos/estados y preparar prueba antes de campo.

## Reparto técnico

| Capa | Trabajo propuesto | Límite |
|---|---|---|
| UX/frontend | Identificador copiable, orientación para comunicar error y presentación del resultado/historial autorizado. Definir interfaz central mínima solo si la operación lo requiere. | No editor general, sistema de tickets ni aprobación previa del registro. |
| Backend | Comando por caso admitido: JWT, autoridad central, revisión y motivo, campos permitidos, precondiciones y resultado recuperable. Lecturas diferenciadas por audiencia. | No PATCH arbitrario de registro ni rol central declarado por cliente. |
| DB | Evento/registro de corrección vinculado, valores anteriores/nuevos, actor/fecha/motivo; versión/idempotencia; efectos e historial atómicos. | No borrar originales, alterar snapshots retroactivamente ni devolver stock sin hecho físico y comando aprobado. |
| Consulta/integración | Resolver la presentación efectiva y agregados con PA-S02; preservar hechos de PA-S01 y reposiciones existentes. | Una corrección no se cuenta como otra plantación. |

Ver alternativas de persistencia en [diseño compartido](../diseno-tecnico-compartido.md). No elegir una tabla o reutilizar un evento incompatible antes de precisar PA-DI07.

## Puerta de implementación y de campo

Primero revisar [matriz de casos](spec.md), después contrato/efectos y persistencia, finalmente implementar el caso acotado y probarlo con datos sintéticos. Para cambios de cantidad, documentar saldo anterior, hecho real, compensaciones permitidas y resultado esperado por asignación/grupo antes de programar.

La verificación debe demostrar: acceso central, rechazo de autor/administrador, original intacto, auditoría completa, corrección repetida/concurrente, consumo físico y lectura deduplicada. Un canal de contacto abierto o una anotación documental no satisface la salida a piloto. Si casos críticos siguen sin resolución segura, revisar fecha/alcance con el usuario; no declarar preparada esta capacidad.
