# Módulo Vivero — Maduración Pre-Plantación

Módulo 2. Documenta la maduración y trazabilidad del material vegetal entre su registro en Recolección y su plantación en campo.

## Propósito

Modelar el ciclo de vida de un **lote de vivero**, agregado central del módulo, desde que ingresa (con **un único origen** en Recolección) hasta su cierre o despacho hacia Plantación. El modelo es híbrido: estado actual del lote + historial append-only de eventos (no event sourcing puro).

## Documentos de este módulo

* `00_Requerimientos-Modulo_2_Vivero.json`: requerimientos funcionales (`RF-VIV-01..14`).
* `01_reglas_de_negocio_vivero.md`: reglas de negocio (`RN-VIV-01..60`), incluye el contrato de integración con Módulo 3 (`RN-VIV-47..60`).
* `02_doc_guia_vivero.md`: guía operativa y de proceso.
* `04_consumo_de_vivero.md`: operativo del consumo de saldo hacia plantación.
* [`../decisiones/_historico/vivero-addendum-m2-m3.md`](../decisiones/_historico/vivero-addendum-m2-m3.md): referencia histórica del contrato M2↔M3 (ya absorbido en `01_reglas_de_negocio_vivero.md`), archivada — no es fuente operativa.

## Dependencias

* Consume catálogos maestros de [general-module](../general-module/README.md).
* Recibe el lote origen de [recoleccion-module](../recoleccion-module/README.md) mediante contrato atómico en el evento `INICIO`.
* Se integra con [plantacion-module](../plantacion-module/README.md): asignaciones, devoluciones y despacho automático (ver estado de esta integración en [ESTADO.md](../ESTADO.md)).

## Invariantes clave

Detalladas en `01_reglas_de_negocio_vivero.md` y en [CLAUDE.md](../CLAUDE.md); no se repiten aquí. Las de mayor impacto:

* Origen único por lote de vivero.
* Orden de eventos: `INICIO → EMBOLSADO → (MERMA | DESPACHO | ADAPTABILIDAD)* → CIERRE`.
* Saldo vivo solo existe desde `EMBOLSADO` y se maneja en `UNIDAD`.
* Todo `DESPACHO`, manual o automático desde Plantación, requiere evidencia propia asociada al evento de vivero.

## Lectura operativa rápida

* `INICIO`: entra material en proceso desde Recolección; todavía no existe saldo vivo.
* `EMBOLSADO`: nacen `plantas_vivas_iniciales` y `saldo_vivo_actual`, siempre en `UNIDAD`.
* `ADAPTABILIDAD`: seguimiento operativo opcional; no cambia saldo ni bloquea despacho.
* `MERMA`: baja `saldo_vivo_actual`; valida contra el saldo vivo del lote. Si afecta reservas, se aplica la política de urgencia de subcampaña.
* `DESPACHO` manual: baja saldo vivo y valida contra `saldo_vivo_disponible_asignacion`, sin tocar reservas activas.
* `DESPACHO` automático: lo genera Módulo 3 al plantar o reponer; consume una asignación y también baja `saldo_vivo_actual`.
* `CIERRE_AUTOMATICO`: ocurre cuando `saldo_vivo_actual = 0`.
