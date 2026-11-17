# Diagramas del Capítulo III

Los documentos del capítulo conservan la fuente vigente de los diagramas Mermaid. Los 19 archivos independientes enlazados abajo son copias generadas para edición y exportación. Regenerarlos tras modificar los documentos:

```sh
node documentacion-grado/06_entregables/proyecto_grado/figuras/exportar-mermaid.mjs
```

## Impresión en carta vertical

Las figuras vigentes se preparan para hojas carta de 612 × 792 pt (21,59 × 27,94 cm), con un área de figura de 468 × 620 pt. Los diagramas extensos se dividen en paneles; se repiten los nodos frontera y los participantes para conservar continuidad. El [catálogo de láminas verticales](paginas/README.md) es la entrada para insertar las figuras en el documento. Los SVG completos sirven para consulta y edición, y no deben reducirse a una sola página cuando su tamaño de texto resulte insuficiente.

Los [modelos de datos](modelos-datos/README.md) conservan sus fuentes editables. Las carpetas `paneles/`, `renderizados/` y `paginas/` se regeneran desde las fuentes vigentes. La [edición horizontal anterior](horizontal/README.md) queda como antecedente, sustituida por la corrección del autor del 16 de noviembre. Las láminas anteriores de estas figuras siguen disponibles en la edición del 16 de noviembre.

## Diagramas en SVG

- [Casos de uso UML del Capítulo III](casos-de-uso/README.md): Figuras 3.5 y 3.8–3.11A, con fuentes SVG y láminas vectoriales.
- [Modelo físico completo y cinco vistas temáticas](../../../../database/00_database_schema.md): SVG y fuentes Mermaid, junto con procedencia y scripts de generación.

## Fuentes Mermaid del capítulo

| Diagrama | Fuente vigente | Archivo independiente |
|---|---|---|
| Figura 3.4. Flujo actual y soportes de información identificados | [Documento](../03_1_fase_inicio.md) | [Mermaid](mermaid/03_1_fase_inicio-01.mmd) |
| Figura 3.6. Recorrido del diseño integrado y variantes de ingreso | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-01.mmd) |
| Figura 3.7. Genealogía del material vegetal en la ruta principal | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-02.mmd) |
| Figura 3.12. Estados de Recolección y saldo operativo | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-07.mmd) |
| Figura 3.13. Bases iniciales y movimientos del lote de vivero | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-08.mmd) |
| Figura 3.14. Estados operativos de la subcampaña pertinentes al recorrido | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-09.mmd) |
| Figura 3.15. Actividad de Recolección | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-10.mmd) |
| Figura 3.16. Actividad de Vivero por modalidad de ingreso | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-11.mmd) |
| Figura 3.17. Actividad de Plantación y recuperación del resultado | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-12.mmd) |
| Figura 3.18. Secuencia diseñada para el contrato M1→M2 | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-13.mmd) |
| Figura 3.19. Entrega física, consumo de stock y resultado recuperable | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-14.mmd) |
| Figura 3.20. Modelo conceptual del recorrido y sus modalidades de origen | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-15.mmd) |
| Figura 3.21. Relaciones lógicas del diseño integrado | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-16.mmd) |
| Figura 3.22. Componentes y responsabilidades de la arquitectura académica | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-17.mmd) |
| Figura 3.22. Componentes y responsabilidades de la arquitectura académica | [Documento](../03_2_fase_elaboracion.md) | [Mermaid](mermaid/03_2_fase_elaboracion-18.mmd) |
| Figura 3.23. Flujo y secuencia del registro inicial de plantación | [Documento](../03_3_fase_construccion.md) | [Mermaid](mermaid/03_3_fase_construccion-01.mmd) |
| Figura 3.23. Flujo y secuencia del registro inicial de plantación | [Documento](../03_3_fase_construccion.md) | [Mermaid](mermaid/03_3_fase_construccion-02.mmd) |
| Figura 3.24. Evaluación de una traza y registro de la decisión | [Documento](../03_4_fase_transicion.md) | [Mermaid](mermaid/03_4_fase_transicion-01.mmd) |
| Figura 3.1. Organización del proceso RUP y relación con la evidencia técnica | [Documento](../03_capitulo_marco_aplicativo.md) | [Mermaid](mermaid/03_capitulo_marco_aplicativo-01.mmd) |

Los archivos Mermaid son texto editable y pueden renderizarse con Mermaid CLI. Estas copias conservan el contenido de las figuras del capítulo; su exportación no constituye una nueva revisión de requisitos o de implementación.
