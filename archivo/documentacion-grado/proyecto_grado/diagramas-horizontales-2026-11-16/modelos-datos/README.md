# Modelos de datos del recorrido

Tres vistas horizontales del recorrido de material vegetal. Son representaciones parciales para el Capítulo III; los documentos de dominio y el modelo físico completo conservan el detalle.

| Vista | Figura | Fuente editable | Alcance |
|---|---|---|---|
| Conceptual | [SVG](modelo-conceptual.svg) | [Mermaid](modelo-conceptual.mmd) | Conceptos y asociaciones principales desde el origen hasta la plantación y la participación histórica. |
| Lógica | [SVG](modelo-logico.svg) | [Mermaid](modelo-logico.mmd) | Relaciones y cardinalidades de la misma porción del diseño integrado. Los nombres representan conceptos lógicos, no nombres necesariamente físicos. |
| Física | [SVG](modelo-fisico.svg) | [Mermaid](modelo-fisico.mmd) | Diez tablas y once relaciones seleccionadas del esquema recibido el 16 de noviembre de 2026. Muestra solo columnas relevantes para el recorrido. |

La vista lógica expresa el origen alternativo de cada lote. Sus dos enlaces opcionales deben leerse conjuntamente: cada lote tiene exactamente un origen, Recolección o incorporación de plantas vivas. La incorporación inicia un lote homogéneo; el historial anterior a su recepción o conteo no se presume conocido. Las cardinalidades de detalle expresan el diseño funcional, mientras que las de la vista física se derivan de las restricciones visibles en la fuente. El detalle de permisos, evidencias, devoluciones y demás reglas está en los módulos y contratos.

En la vista física, `PK` identifica clave primaria, `FK` una columna de referencia y `UK` unicidad individual; `NULL` señala una columna nullable. Las columnas sin esa marca son no nulas en el extracto. La línea continua corresponde a una FK que integra la PK hija; la discontinua representa las demás FK. Se muestran únicamente las relaciones seleccionadas, de modo que una columna `FK` puede referir una tabla que no aparece en esta vista. `USER_DEFINED` conserva el tipo no resuelto en el adjunto. El enlace semántico de `recoleccion_movimiento.lote_vivero_id` no se representa como FK física: la fuente no lo acredita como tal.

La [documentación del modelo físico completo](../../../../../database/00_database_schema.md) conserva las 57 tablas, 622 columnas y 175 relaciones del extracto recibido, otras vistas temáticas, procedencia, restricciones y límites del contraste. El adjunto carece de identificador de proyecto y fecha de exportación. La existencia de una tabla no demuestra una capacidad aceptada o desplegada; las evidencias y pendientes por capa y entorno se consultan en [ESTADO.md](../../../../../ESTADO.md).

Las vistas conceptual y lógica se basan en los modelos integrados de Elaboración, en [Recolección](../../../../../01-recoleccion-module/README.md), [Vivero](../../../../../02-vivero-module/README.md), [Plantación](../../../../../03-plantacion-module/README.md) y sus contratos. Las fuentes Mermaid se pueden editar y renderizar con Mermaid CLI. Los SVG se generaron a partir de ellas; sus dimensiones son apaisadas. La lógica completa y los límites de incorporación y custodia se detallan en [Elaboración](../../../../../documentacion-grado/06_entregables/proyecto_grado/03_2_fase_elaboracion.md#338-modelo-de-datos-conceptual-lógico-y-físico).
