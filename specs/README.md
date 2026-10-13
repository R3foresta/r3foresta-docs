# Especificaciones del incremento MVP

**Actualización:** 13 de octubre de 2026. Entrada, registro inicial, consulta de impacto y gestión de acceso de PA-F01 están aprobados en comportamiento. D01–D12 del contrato backend están aceptadas como diseño técnico, con ajustes de afiliación y consumo LIFO. Correcciones conserva acuerdos parciales y contratos propios pendientes. Implementación, migraciones y verificación del incremento tienen estado separado.

## Feature activa

[PA-F01 — Participación aliada en Plantación](plantacion/participacion-aliada/README.md): consultar y compartir impacto sin cuenta; registrar con identidad y permiso vigentes; gestionar acceso y resolver errores con historial. Se conserva la gestión interna y un único modelo de campañas, registros y stock.

## Estado de las specs

| Spec | Revisión funcional | Trabajo posterior |
|---|---|---|
| [PA-S00 · Entrada y experiencia](plantacion/participacion-aliada/00-experiencia-participante/spec.md) | Aprobada el 11; alta/roles confirmados el 12 y consulta pública compartible reafirmada el 13. | Implementar identidad, alta VOLUNTARIO, perfil seguro y navegación según diseño aceptado. |
| [PA-S01 · Registro inicial](plantacion/participacion-aliada/01-registro-plantacion-inicial/spec.md) | Cerrada el 12: tres pasos, observaciones, revisión/confirmación y recuperación del intento. LIFO acordado el 13. | Integrar permisos, stock, fotos, comando durable y comprobante; probar concurrencia y recorrido. |
| [PA-S02 · Consulta de impacto](plantacion/participacion-aliada/02-consulta-impacto-y-registros/spec.md) | Primera versión aprobada el 11; consulta y enlaces públicos sin login explícitos el 13. | Boceto final, proyecciones efectivas y seguimiento, snapshots históricos, integración y pruebas. |
| [PA-S03 · Gestión de acceso](plantacion/participacion-aliada/03-gestion-acceso-subcampania/spec.md) | Comportamiento y orquestación aprobados el 11; roles/permisos y diseño backend aceptados posteriormente. | Cotejar catálogo, preparar transición, implementar permisos/versiones y protección de administradores, integrar UI. |
| [PA-S04 · Corrección excepcional](plantacion/participacion-aliada/04-correccion-excepcional/spec.md) | Cantidades, participantes, duplicados y eliminación lógica de registros erróneos confirmados el 12. | Cierre integral de casos especiales y contratos de efectos/historial; implementación y pruebas propias. |

## Trabajo documental completado

- Revisión funcional PA-S00/01/02/03 y ampliación del alcance de PA-S04, con [acta funcional](plantacion/participacion-aliada/revision-humana-2026-10-11.md) y [acta de correcciones](plantacion/participacion-aliada/revision-correcciones-2026-10-12.md).
- [Contraste de contratos existentes](plantacion/participacion-aliada/revision-contratos-2026-10-12.md): DTO, APIs, persistencia y consumidores frontend revisados mediante lectura de código.
- [Inventario de endpoints y regresión](plantacion/participacion-aliada/inventario-endpoints-y-regresion-participacion.md): segunda lectura estática completada, matriz de facultades, casos de prueba y plantilla de transición preparados. Las pruebas y la transición no están ejecutadas por ese inventario.
- [Contrato backend](plantacion/participacion-aliada/contrato-identidad-permisos-backend-propuesta.md): D01–D12 aceptadas el 13; [acta técnica](plantacion/participacion-aliada/revision-tecnica-2026-10-13.md). El nombre «propuesta» del archivo se conserva por compatibilidad de enlaces.

La revisión del diseño ya no se presenta como una tarea por empezar. La siguiente entrega es **PA-T-INT02-A: identidad, alta VOLUNTARIO y perfil seguro en backend**, con cotejo del catálogo/entorno y fixtures antes del código que dependa de DB. El avance de implementación se registra en [ESTADO.md](../ESTADO.md).

## Convenciones y fuentes

Cada capacidad contiene `spec.md`, `plan.md` y `tasks.md`: comportamiento, diseño de entrega y trabajo verificable. Registrar decisiones humanas, evidencia de código, pruebas y despliegue por separado.

- **Confirmado/aprobado:** decisión humana de producto o diseño, indicando cuál.
- **Preparado:** documento, inventario o guion entregado; no acredita ejecución de código o pruebas.
- **Implementado/verificado:** requiere evidencia de la capa y entorno correspondientes.
- **Pendiente:** nombrar la decisión, cotejo o entrega concreta; no volver a incluir un acuerdo ya aceptado.
- IDs estables: `PA-F01`, `PA-S00`–`PA-S04`, `PA-C*`, `PA-Sxx-USnn`, `PA-Sxx-CAnn`, `PA-T*`, `PA-R*`, `PA-DI*`. D01–D12 son decisiones del contrato backend; PA-D01–05 son diagramas.

El [índice de PA-F01](plantacion/participacion-aliada/README.md) ubica las fuentes canónicas, acuerdos vigentes y secuencia de entregas. [Decisiones de Plantación](../decisiones/02_decisiones_plantacion.md) conserva las reglas transversales; [ESTADO.md](../ESTADO.md) conserva evidencia de implementación. Código local y migraciones presentes en Git no prueban producción.
