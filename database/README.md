# Database — Persistencia y Decisiones de Arquitectura

Capa de persistencia y decisiones de arquitectura de datos transversales a los cuatro módulos.

## Propósito

Mantener el esquema ER canónico y las decisiones de diseño de base de datos que sostienen a general, recolección, vivero y plantación.

## Documentos

* [00_database_schema.md](00_database_schema.md): entrada al modelo físico actualizado el 16 de noviembre de 2026 con el esquema aportado y confirmado como última versión. Contiene 57 tablas, 622 columnas y 175 relaciones. Incluye SVG completo, cinco vistas temáticas, fuentes Mermaid y procedencia del contraste.
* `fuentes/`: extractos del 4 y 16 de noviembre y procedencia de relaciones. El corte actual conserva el SQL contextual exacto, su huella y las quince claves compuestas contrastadas con migraciones locales. Proyecto y fecha de exportación del adjunto quedan sin identificar.
* `diagramas/` y `scripts/generar-modelo-fisico.mjs`: fuentes y renders reproducibles. El esquema previo se conserva en `archivo/00_database_schema-antes-2026-11-04.md`.
* `migrations/`: copia documental de las migraciones aplicadas o propuestas para Supabase, ordenadas por prefijo numerico.

Las decisiones de arquitectura de BD cerradas para vivero se migraron al registro unificado: ver [`../decisiones/00_decisiones_vivero.md`](../decisiones/00_decisiones_vivero.md) (índice en [`../decisiones/README.md`](../decisiones/README.md)). La planeación previa (comparativa de alternativas) quedó archivada en [`../decisiones/_historico/planeacion-bd-vivero.md`](../decisiones/_historico/planeacion-bd-vivero.md).

## Aclaración importante

`migrations/` es referencia documental para revisar el orden y contenido de cambios de BD. El estado real de cada migracion aplicada en producción debe confirmarse en los repos de implementación o en [`../ESTADO.md`](../ESTADO.md).

## Diseño de datos de participación aliada

D01–D12 del [contrato backend PA-F01](../specs/plantacion/participacion-aliada/contrato-identidad-permisos-backend-propuesta.md) están aceptadas como diseño el 13 de octubre de 2026: permisos separados de coordinación/logística, revisiones e historial, comandos/cargas recuperables y snapshots de afiliación opcional del catálogo o «Otra». El esquema existente y las migraciones históricas siguen describiendo su base; nuevas tablas/columnas/índices/privilegios se cotejan con el catálogo destino y se incorporan por migraciones nuevas.

El corte físico del 16 de noviembre incorpora las tablas de participación, correcciones, accesos M1/M2, recepción única e incorporación presentes en el extracto. El corte del 4 de noviembre conserva su fuente histórica. Su presencia estructural no completa las capacidades ni las pruebas de PA-F01. La autoridad de diseño futuro sigue siendo el contrato aceptado y su [acta](../specs/plantacion/participacion-aliada/archivo/revision-tecnica-2026-10-13.md); evidencia de ensayo/aplicación y entorno corresponde a [ESTADO.md](../ESTADO.md). Contratos específicos de compensación de PA-S04 conservan su revisión propia.
