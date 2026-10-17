# Archivo de PA-F01

Actas y antecedentes conservados al ordenar la documentación el 14 de octubre de 2026. [Índice vigente](../README.md) · [Ejecución actual](../implementacion/README.md).

## Entregas con cierre registrado

- [Cierre de PA-T-INT02-A](cierre-pa-t-int02-a.md): alcance acreditado, versiones, evidencias y límites.
- [Encargo original de INT02-A](inicio-pa-t-int02-a.md): conserva lo solicitado; ya no es el siguiente paso.
- [Cierre técnico local de INT03-A](cierre-pa-t-int03-a.md): BE01–BE08, evidencia del 15 y publicación en `main` del 16; 074–076 aplicadas en desarrollo según Pablo, con cotejo posterior, D e integración pendientes.
- [Encargo y tareas de INT03-A](pa-t-int03-a.md): contenido completo conservado al cerrar el alcance local; la [ruta anterior](../implementacion/pa-t-int03-a.md) permanece como entrada compatible.

- [Cierre técnico local de INT02-D](cierre-pa-t-int02-d.md): BE01–BE08, código local `75a57eb`, 787 unitarios y SQL/carreras/HTTP; aplicación remota, push/despliegue y piloto pendientes.
- [Encargo completado de INT02-D](pa-t-int02-d.md): ocho tareas acreditadas; la [ruta anterior](../implementacion/pa-t-int02-d.md) permanece como entrada compatible.
- [Recepción de INT02-D del 16 de octubre](pa-t-int02-d-recepcion-2026-10-16.md): conserva el árbol/pendiente 40001 y criterios recibidos; la [ficha vigente](../implementacion/pa-t-int02-d.md) registra el cierre local.
- [Cierre técnico local de INT04](cierre-pa-t-int04.md): FE01–FE08, código local `94f62a9`, 553 pruebas y 60 checks integrados; mantiene pendientes remotos, revisión humana y WebAuthn.
- [Encargo completado de INT04](pa-t-int04.md): criterios y ocho tareas conservados; la [ruta anterior](../implementacion/pa-t-int04.md) permanece como entrada compatible.

## Versiones de diagramas

- [Diagramas y dependencias anteriores al 14 de octubre](diagramas-antes-2026-10-14/README.md): fuentes Mermaid, renders y análisis previos conservados con sus fechas. La [versión vigente](../diagramas/README.md) incorpora el contrato D01–D12, el cierre de INT02-A y el orden actual de entregas.

## Actas y contrastes

Las actas siguen siendo evidencia de aceptación. Archivar una revisión cerrada conserva sus decisiones; las specs, el contrato aceptado y los ADR expresan el comportamiento vigente.

| Documento | Qué acredita |
|---|---|
| [Revisión humana del 11](revision-humana-2026-10-11.md) | Decisiones funcionales de entrada, registro, consulta y acceso. |
| [Correcciones del 12](revision-correcciones-2026-10-12.md) | Alcance confirmado y cuestiones propias de PA-S04 todavía pendientes. |
| [Contraste de contratos del 12](revision-contratos-2026-10-12.md) | Observación estática de las APIs y consumidores en esa fecha. |
| [Revisión técnica del 13](revision-tecnica-2026-10-13.md) | Aceptación D01–D12, con ajustes D02/D07. |

## Planificación anterior

| Documento | Uso conservado |
|---|---|
| [Plan inicial](plan-inicial.md) | Evolución del orden de trabajo y objetivo de campo condicionado. |
| [Plan de reutilización e integración](plan-reutilizacion-integracion.md) | Base de código observada, PA-DI y tareas INT originales; contiene pendientes de su fecha. |
| [Diseño técnico compartido](diseno-tecnico-compartido.md) | Razonamiento y distribución por capas anteriores al contrato aceptado. |
| [Comandos compartidos](diseno-comandos-compartidos.md) | Elección de un motor común; los contratos concretos vigentes están en el contrato backend. |
| [Instrucciones previas](instrucciones-implementacion.md) | Trazabilidad PA-CT/PA-Q, desgloses por capa y propuestas específicas de corrección aún por resolver. |
| [Ficha previa de INT02-B del 14](pa-t-int02-b-ficha-previa-2026-10-14.md) | Alcance conservado antes del desglose backend/frontend; la ejecución vigente sigue en las fichas B/C/INT06 del tablero. |

Los planes candidatos, rutas propuestas y estados de estas notas se leen con su fecha. Para decidir qué ejecutar prevalece el [tablero actual](../implementacion/README.md); para los mecanismos D01–D12, el [contrato aceptado](../contrato-identidad-permisos-backend-propuesta.md). PA-S04 conserva sus decisiones pendientes propias.

Se conservaron los nombres base de los archivos trasladados desde la carpeta de PA-F01; los enlaces del repositorio se actualizaron. La ruta original de [inicio INT02-A](../inicio-pa-t-int02-a.md) conserva un enlace de compatibilidad para la PWA y chats anteriores. Las referencias de código, las actas y las evidencias originales siguen localizables aquí.
