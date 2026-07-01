# Database — Persistencia y Decisiones de Arquitectura

Capa de persistencia y decisiones de arquitectura de datos transversales a los cuatro módulos.

## Propósito

Mantener el esquema ER canónico y las decisiones de diseño de base de datos que sostienen a general, recolección, vivero y plantación.

## Documentos

* `00_database_schema.md`: esquema ER canónico (sintaxis mermaid `erDiagram`) + enums + funciones. Fuente de verdad estructural de todo el proyecto.
* `supabase/01_create_recoleccion_historial.sql`: script SQL de ejemplo/soporte.

Las decisiones de arquitectura de BD cerradas para vivero se migraron al registro unificado: ver [`../decisiones/00_decisiones_vivero.md`](../decisiones/00_decisiones_vivero.md) (índice en [`../decisiones/README.md`](../decisiones/README.md)). La planeación previa (comparativa de alternativas) quedó archivada en [`../decisiones/_historico/planeacion-bd-vivero.md`](../decisiones/_historico/planeacion-bd-vivero.md).

## Aclaración importante

`supabase/` **no** es el set real de migraciones del proyecto. Las migraciones productivas viven en los repos de implementación, que Claude no ve. Aquí solo hay scripts de soporte y ejemplo, mantenidos con las convenciones de idempotencia descritas en [CLAUDE.md](../CLAUDE.md).
