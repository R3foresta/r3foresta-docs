import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

// Los documentos del capítulo son la fuente de estos archivos generados.
const dir = path.dirname(fileURLToPath(import.meta.url));
const chapter = path.dirname(dir);
const out = path.join(dir, 'mermaid');
fs.mkdirSync(out, { recursive: true });
const rows = [];
for (const file of fs.readdirSync(chapter).filter(f => /^03.*\.md$/.test(f)).sort()) {
  const source = fs.readFileSync(path.join(chapter, file), 'utf8');
  let i = 0;
  for (const match of source.matchAll(/^```mermaid\s*\n([\s\S]*?)^```/gm)) {
    i++;
    const prefix = source.slice(0, match.index);
    const figures = [...prefix.matchAll(/^\*\*(Figura [^\n]+?)\*\*\s*$/gm)];
    const headings = [...prefix.matchAll(/^#{1,6} (.+)$/gm)];
    const title = figures.at(-1)?.[1] ?? headings.at(-1)?.[1] ?? file;
    const name = `${file.replace(/\.md$/, '')}-${String(i).padStart(2, '0')}.mmd`;
    fs.writeFileSync(path.join(out, name), match[1].trimEnd() + '\n');
    rows.push(`| ${title.replaceAll('|', '\\|')} | [Documento](../${file}) | [Mermaid](mermaid/${name}) |`);
  }
}
const text = `# Diagramas del Capítulo III\n\nLos documentos del capítulo conservan la fuente vigente de los diagramas Mermaid. Los ${rows.length} archivos independientes enlazados abajo son copias generadas para edición y exportación. Regenerarlos tras modificar los documentos:\n\n\`\`\`sh\nnode documentacion-grado/06_entregables/proyecto_grado/figuras/exportar-mermaid.mjs\n\`\`\`\n\n## Impresión en carta vertical\n\nLas figuras vigentes se preparan para hojas carta de 612 × 792 pt (21,59 × 27,94 cm), con un área de figura de 468 × 620 pt. Los diagramas extensos se dividen en paneles; se repiten los nodos frontera y los participantes para conservar continuidad. El [catálogo de láminas verticales](paginas/README.md) es la entrada para insertar las figuras en el documento. Los SVG completos sirven para consulta y edición, y no deben reducirse a una sola página cuando su tamaño de texto resulte insuficiente.\n\nLos [modelos de datos](modelos-datos/README.md) conservan sus fuentes editables. Las carpetas \`paneles/\`, \`renderizados/\` y \`paginas/\` se regeneran desde las fuentes vigentes. La [edición horizontal anterior](horizontal/README.md) queda como antecedente, sustituida por la corrección del autor del 16 de noviembre. No se actualizó ningún documento remoto de Google Docs.\n\n## Diagramas en SVG\n\n- [Figura 3.5 — Actores y casos de uso generales](03_05_casos_uso_inicio.svg).\n- [Modelo físico completo y cinco vistas temáticas](../../../../database/00_database_schema.md): SVG y fuentes Mermaid, junto con procedencia y scripts de generación.\n\n## Fuentes Mermaid del capítulo\n\n| Diagrama | Fuente vigente | Archivo independiente |\n|---|---|---|\n${rows.join('\n')}\n\nLos archivos Mermaid son texto editable y pueden renderizarse con Mermaid CLI. Estas copias conservan el contenido de las figuras del capítulo; su exportación no constituye una nueva revisión de requisitos o de implementación.\n`;
fs.writeFileSync(path.join(dir, 'README.md'), text);
console.log(`${rows.length} diagramas exportados y catálogo actualizado.`);
