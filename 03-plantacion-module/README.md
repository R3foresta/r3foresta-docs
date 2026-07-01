# Módulo Plantación — Campo, Campañas y Subcampañas

Módulo 3. Documenta la plantación efectiva en campo: campañas estratégicas y subcampañas operativas, base de los bonos de carbono y de la vista pública.

## Propósito

Modelar `CAMPANIA → SUBCAMPANIA → REGISTRO_PLANTACION → EVENTO_PLANTACION`, aplicado vía migraciones 027–032. Cubre la planificación por especie, el mantenimiento post-plantación y la transición a monitoreo histórico.

## Documentos de este módulo

* `00_Requerimientos_Modulo_3_Plantacion.json`: requerimientos funcionales (`RF-PLA-01..18`).
* `01_reglas_de_negocio_plantacion.md`: reglas propias de M3 (`RN-PLA-01..35`) — ciclo de vida de campaña/subcampaña, plan por especie, coordinación como membresía, plantación inicial, mortandad, reposición, GPS/PostGIS, vista pública y roles.
* `02_Procesos_Modulo_3_Plantacion.md`: proceso detallado.
* `03_Mockups_Guia_Modulo_3_Plantacion.md`: guía UX.

**Nota estructural:** el contrato de integración M2↔M3 (asignaciones, devoluciones, despacho automático, mermas sobre asignaciones) **no vive aquí**: su fuente canónica es `RN-VIV-47..60` en [`../02-vivero-module/01_reglas_de_negocio_vivero.md`](../02-vivero-module/01_reglas_de_negocio_vivero.md). `01_reglas_de_negocio_plantacion.md` referencia esas reglas, no las duplica.

## Dependencias

* Consume [02-vivero-module](../02-vivero-module/README.md): asignaciones y despacho automático de lotes.
* Consume [00-general-module](../00-general-module/README.md): `ORGANIZACION`, zona/territorios.
* Ver estado real de la integración M2↔M3 (piezas pendientes vs. en producción) en [ESTADO.md](../ESTADO.md).

## Invariantes clave

Detalladas en [CLAUDE.md](../CLAUDE.md); no se repiten aquí. Las de mayor impacto:

* Estado de campaña derivado en tiempo real, nunca persistido como columna.
* Coordinador es membresía en `SUBCAMPANIA_EQUIPO.rol_en_subcampania`, no rol global.
* Asignación y devolución de lote de vivero son reservas lógicas (no generan evento en M2).
* Plantar o reponer en M3 genera un `DESPACHO` automático en M2 (`origen_despacho = AUTOMATICO_PLANTACION`).
