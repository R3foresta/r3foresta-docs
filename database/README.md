# Database — Persistencia y Decisiones de Arquitectura

Capa de persistencia y decisiones de arquitectura de datos transversales a los cuatro módulos.

## Propósito

Mantener el esquema ER canónico y las decisiones de diseño de base de datos que sostienen a general, recolección, vivero y plantación.

## Documentos

* `00_database_schema.md`: esquema ER canónico (sintaxis mermaid `erDiagram`) + enums + funciones. Fuente de verdad estructural de todo el proyecto.
* `migrations/`: copia documental de las migraciones aplicadas o propuestas para Supabase, ordenadas por prefijo numerico.

Las decisiones de arquitectura de BD cerradas para vivero se migraron al registro unificado: ver [`../decisiones/00_decisiones_vivero.md`](../decisiones/00_decisiones_vivero.md) (índice en [`../decisiones/README.md`](../decisiones/README.md)). La planeación previa (comparativa de alternativas) quedó archivada en [`../decisiones/_historico/planeacion-bd-vivero.md`](../decisiones/_historico/planeacion-bd-vivero.md).

## Aclaración importante

`migrations/` es referencia documental para revisar el orden y contenido de cambios de BD. El estado real de cada migracion aplicada en producción debe confirmarse en los repos de implementación o en [`../ESTADO.md`](../ESTADO.md).
