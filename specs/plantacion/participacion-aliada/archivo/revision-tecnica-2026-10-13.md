# PA-F01 — Revisión técnica del 13 de octubre de 2026

> **Acta/contraste archivado.** Conserva decisiones y observaciones de su fecha. El avance posterior se consulta en el [tablero de ejecución](../implementacion/README.md).

**Revisor:** Pablo. **Fuente:** aceptación explícita del punto 12 del contrato backend en este chat. **Estado:** D01–D12 aceptadas como diseño técnico, con ajustes D02/D07; implementación pendiente.

## 1. Decisiones aceptadas

La [sección 12 del contrato](../contrato-identidad-permisos-backend-propuesta.md#12-decisiones-técnicas-aceptadas-por-pablo--13-de-octubre-de-2026) conserva D01–D12 con su contenido y comprobaciones de implementación. D01, D03–D06 y D08–D12 se aceptan conforme a la propuesta. D02 y D07 se aceptan con las precisiones siguientes. No queda pendiente volver a pedir la aprobación de esas doce decisiones.

## 2. D02 — Afiliación opcional con catálogo o «Otra»

Una persona puede escoger una organización existente registrada en el sistema, escoger «Otra» e introducir un nombre o dejar la afiliación sin declarar. No es obligatoria para completar perfil ni para plantar; Impacto público sigue disponible sin cuenta/perfil/login. Seleccionar una organización declara afiliación; no acredita membresía formal, no concede permisos ni convierte a la persona en administradora. «Otra» no crea una organización maestra ni se enlaza por nombre automáticamente.

El contrato §3.1 precisa DTO, selector mínimo autenticado para cualquier cuenta activa, ID validada y persistencia excluyente ID/texto/ausencia. D08 conserva el nombre histórico y la procedencia catálogo/«Otra» en snapshots; cambios posteriores de nombre, actividad o perfil no recalculan lo ocurrido. Ausencia declarada y afiliación histórica no disponible siguen siendo situaciones distintas.

## 3. D07 — Stock de subcampaña y consumo LIFO

La entrega física Vivero → subcampaña y el consumo al plantar son hechos distintos. El registro participante consume el stock ya asignado/disponible **de esa misma subcampaña**, compartido por sus personas autorizadas. No añade recepción, acuse o confirmación de entrega por la organización encargada, administrador contextual o administradores de campaña; ese flujo no se aborda en esta entrega.

Se acepta LIFO en servidor para la inicial por especie: `fecha_asignacion DESC, id DESC` entre asignaciones activas de PLANTACION_INICIAL con saldo y fecha de entrega conciliada no posterior a la fecha del trabajo. El orden de adquisición de locks permanece ASC para evitar carreras; no define la prioridad del consumo. Consumo aumenta `cantidad_consumida` M3 sin cambiar `cantidad_asignada` ni volver a descontar Vivero. La metadata `fecha_entrega_operativa` conserva el día de la asignación existente, sin crear una recepción nueva.

Esto sustituye la orientación FIFO de las actas del 11/12 para el nuevo recorrido de inicial. Las referencias a FIFO como comportamiento **observado** del código legado se conservan como evidencia; la adaptación a LIFO sigue pendiente en backend/PWA y corte de compatibilidad. Reposición interna y logística mantienen sus contratos específicos.

## 4. Próximo punto y estado

Siguiente entrega: **PA-T-INT02-A**, identidad JWT, alta VOLUNTARIO y perfil seguro con afiliación opcional. Preparar el inventario del catálogo/entorno y fixtures aislados antes del SQL dependiente de DB, preservando Impacto público sin autenticación y GET /plan de ADR-PLA-05. El manifest concreto de transición aún requiere revisión de las personas/ámbitos propuestos; aprobar el mecanismo no aprueba filas desconocidas.

La actualización es documental. No se inicia implementación ni se ejecutan migraciones, pruebas integradas o despliegues; esos estados se acreditan por separado. PA-S04 conserva la revisión de sus efectos específicos.
