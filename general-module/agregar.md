Evidencia operativa/auditable no se comprime en frontend.
Imágenes decorativas o de catálogo sí pueden comprimirse.
Para evidencia, backend no debería reemplazar el archivo original con una versión comprimida como única copia. Lo más sólido es:
guardar el archivo original intacto;
calcular hash del original;
guardar metadata técnica;
si hace falta, generar una copia optimizada/thumbnail para visualización.

## 1. Evidencia auditable: sin compresión frontend

Aplica a:

- M1 Recolecciones
- M2 Vivero
- Eventos de vivero:
  - INICIO
  - EMBOLSADO
  - ADAPTABILIDAD si tiene evidencia
  - MERMA
  - DESPACHO
- M3 Plantación
- Cualquier evidencia de trazabilidad asociada a procesos, estados, movimientos o validaciones

---

## Pendiente para M3 Plantación

Cuando se implemente Plantación:

- toda evidencia de plantación debe subir archivo original;
- no usar compresión frontend;
- no usar `nonEvidenceImageCompression`;
- usar solo validación/previews;
- backend debe guardar original + hash + metadata;
- backend puede generar thumbnails/derivados para visualización;
- frontend debe enviar archivos por `multipart/form-data` en campo acordado, idealmente `fotos`.