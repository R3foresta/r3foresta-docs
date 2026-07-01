# Database — Persistencia y Decisiones de Arquitectura

Capa de persistencia y decisiones de arquitectura de datos transversales a los cuatro módulos.

## Propósito

Mantener el esquema ER canónico y las decisiones de diseño de base de datos que sostienen a general, recolección, vivero y plantación.

## Documentos

* `00_database_schema.md`: esquema ER canónico (sintaxis mermaid `erDiagram`) + enums + funciones. Fuente de verdad estructural de todo el proyecto.
* `04_decisiones_bd_vivero_final.md`: decisiones de arquitectura cerradas, alcance vivero.
* `supabase/01_create_recoleccion_historial.sql`: script SQL de ejemplo/soporte.

La planeación de arquitectura previa (comparativa de alternativas, alcance vivero) fue superada por `04_decisiones_bd_vivero_final.md` y archivada: ver [../historico/planeacion-bd-vivero.md](../historico/planeacion-bd-vivero.md).

## Aclaración importante

`supabase/` **no** es el set real de migraciones del proyecto. Las migraciones productivas viven en los repos de implementación, que Claude no ve. Aquí solo hay scripts de soporte y ejemplo, mantenidos con las convenciones de idempotencia descritas en [CLAUDE.md](../CLAUDE.md).
