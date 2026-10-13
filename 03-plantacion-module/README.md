# Módulo Plantación — Campo, Campañas y Subcampañas

Módulo 3. Documenta la plantación efectiva en campo: campañas estratégicas y subcampañas operativas, base de los bonos de carbono y de la vista pública.

## Propósito

Modelar `CAMPANIA → SUBCAMPANIA → REGISTRO_PLANTACION → EVENTO_PLANTACION`, aplicado vía migraciones 027–032. Cubre la planificación por especie, el mantenimiento post-plantación y la transición a monitoreo histórico.

## Documentos de este módulo

* `00_Requerimientos_Modulo_3_Plantacion.json`: requerimientos funcionales (`RF-PLA-01..18`).
* `01_reglas_de_negocio_plantacion.md`: reglas propias de M3 (`RN-PLA-*`) — ciclo de vida de campaña/subcampaña, plan por especie, coordinación como membresía, plantación inicial, mortandad, reposición, GPS/PostGIS, vista pública y roles.
* `02_Procesos_Modulo_3_Plantacion.md`: proceso detallado.
* `03_Mockups_Guia_Modulo_3_Plantacion.md`: guía UX.
* `04_plan_frontend_m3.md`: plan operativo de implementación frontend por fases, pantallas, contratos de datos y criterios de cierre.
* [Revisión de cierre de metas/especies](07_revision_meta_especies_cierre.md): evidencia local frontend/backend, límites y verificación restante del 2026-10-10.
* [`PA-F01 — Participación aliada en Plantación`](../specs/plantacion/participacion-aliada/README.md): specs, acuerdos vigentes y tareas del incremento; PA-S00/01/02/03 aprobadas en comportamiento y D01–D12 del contrato backend aceptadas el 13 de octubre. PA-S04 conserva contratos/cierre integral propios pendientes; implementación y QA separados.

**Nota estructural:** el contrato de integración M2↔M3 (asignaciones físicas, devoluciones físicas, consumo de stock asignado y saldos derivados) **no vive aquí**: su fuente canónica es [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md). `01_reglas_de_negocio_plantacion.md` referencia ese contrato, no lo duplica.

## Incremento PA-F01 — diseño aceptado el 13 de octubre

El [contrato backend](../specs/plantacion/participacion-aliada/contrato-identidad-permisos-backend-propuesta.md) y [acta técnica](../specs/plantacion/participacion-aliada/revision-tecnica-2026-10-13.md) concretan identidad, alta VOLUNTARIO, roles/permisos, comandos y evidencias. Afiliación opcional del catálogo o «Otra», con snapshots históricos. La plantación inicial consume LIFO en servidor del stock elegible que ya tiene la subcampaña; no añade recepción por organización/administrador ni otro débito de Vivero. Impacto global/detalles/mapas/fotos públicas elegibles sigue compartible sin cuenta/login.

Las descripciones del registro interno existente conservan su evidencia y fechas; los nuevos permisos, LIFO y recuperación de comandos requieren adaptación/verificación. Siguiente entrega PA-T-INT02-A; el avance aplicado se registra en [ESTADO.md](../ESTADO.md), sin atribuir el incremento nuevo al cierre anterior del registro interno.

## Dependencias

* Consume [02-vivero-module](../02-vivero-module/README.md): lote de vivero y saldo vivo.
* Respeta el contrato [Vivero → Plantación](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md): asignaciones físicas como stock de consumo de subcampaña, devoluciones físicas y consumo por plantación.
* Consume [00-general-module](../00-general-module/README.md): `ORGANIZACION`, zona/territorios.
* Ver estado real de la integración M2↔M3 (piezas pendientes vs. en producción) en [ESTADO.md](../ESTADO.md).

## Invariantes clave

Detalladas en [CLAUDE.md](../CLAUDE.md); no se repiten aquí. Las de mayor impacto:

* Estado de campaña derivado en tiempo real, nunca persistido como columna.
* Edición básica de campaña en MVP; el tipo solo cambia antes de la primera subcampaña. La desactivación estricta exige que no haya hijas vivas no canceladas; la acción masiva puede cancelar atómicamente hijas `BORRADOR`/`ACTIVA` sin plantaciones, devolver stock y desactivar la campaña.
* Coordinador es membresía en `SUBCAMPANIA_EQUIPO.rol_en_subcampania`, no rol global.
* Asignación de lote a subcampaña es entrega física: genera salida en M2 y crea stock consumible en M3.
* Plantar o reponer en M3 consume `saldo_asignado_disponible`; no genera `DESPACHO AUTOMATICO_PLANTACION`.
* Metas total y por especie orientativas: se puede asignar y plantar por encima del objetivo, dentro del stock disponible y usando especies del plan para plantación inicial.
* Solo ADMIN puede editar meta/especies en BORRADOR o ACTIVA; la edición en ACTIVA está implementada en el backend local, con editor frontend implementado localmente; QA integrado y despliegue verificado pendientes ([ADR-PLA-05](../decisiones/02_decisiones_plantacion.md#adr-pla-05--edicion-de-meta-y-especies-en-activa-solo-admin)). Alcanzar la meta no cierra; ADMIN cierra explícitamente y la devolución de sobrantes es separada.

Actualización documental del 2026-10-10: ADR-PLA-04 conserva metas orientativas/cierre manual; ADR-PLA-05 implementa revisión atómica con `plan_revision`, `PLAN_REVISADO` y Bearer JWT en GET/PUT /plan. Cualquier usuario autenticado existente lee el plan; solo ADMIN global lo modifica. La lectura no concede permisos operativos. Aplicación hasta 062 y posteriormente de 063 confirmada por el usuario; frontend implementado localmente; publicación de sus últimos ajustes y QA integrado/verificación remota siguen pendientes en [ESTADO.md](../ESTADO.md). Los SQL anteriores se conservan como históricos.
