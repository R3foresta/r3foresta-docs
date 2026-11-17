"""Indexa las láminas vigentes, su figura de origen y sus hashes de contenido."""
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parent
manifest = json.loads((ROOT / 'paginas/manifest.json').read_text())
titles = {}
for chapter in sorted(ROOT.parent.glob('03*.md')):
    source = chapter.read_text()
    for i, block in enumerate(re.finditer(r'^```mermaid\s*\n([\s\S]*?)^```', source, re.M), 1):
        figures = re.findall(r'^\*\*(Figura [^\n]+?)\*\*\s*$', source[:block.start()], re.M)
        titles[f'{chapter.stem}-{i:02}'] = figures[-1]
titles.update({
    '03_05_casos_uso_inicio': 'Figura 3.5. Actores y casos de uso generales',
    'modelo-conceptual': 'Figura 3.20 · vista conceptual resumida',
    'modelo-logico': 'Figura 3.21 · vista lógica resumida',
    'modelo-fisico': 'Sección 3.3.8.3 · modelo físico parcial del recorrido',
})
lines = [
    '# Figuras para carta vertical', '',
    'Edición del 16 de noviembre de 2026. Las láminas usan un área de 468 × 620 pt '
    '(16,51 × 21,87 cm) dentro de hojas carta verticales de 612 × 792 pt '
    '(21,59 × 27,94 cm). Insertar cada PNG al ancho máximo de 16,51 cm, '
    'conservar su proporción y dejar espacio para el título y la nota de figura. '
    'El tamaño mínimo medido del texto del diagrama es de 9 pt a ese ancho. '
    'Reducir el ancho también reduce ese tamaño.', '',
    'Los diagramas extensos continúan en varias láminas. Se repiten participantes '
    'y nodos frontera; no deben fusionarse reduciendo todas las partes a una sola hoja. '
    'PNG a 288 ppp para documentos; SVG para edición y ampliación. '
    'El texto y las cardinalidades se verifican en el navegador al renderizar.', '',
    '| Figura o vista | Fuente editable | Láminas en orden | Texto mínimo |',
    '|---|---|---|---|',
]
mapping = []
for diagram in manifest:
    name = diagram['source']
    title = titles[name]
    links = []
    pages = []
    for number, page in enumerate(diagram['pages'], 1):
        png = ROOT / page['path']
        svg = ROOT / page['svg']
        links.append(f'[{number} PNG]({png.name}) / [SVG]({svg.name})')
        pages.append({**page, 'sha256': hashlib.sha256(png.read_bytes()).hexdigest()})
    minimum = min(page['minTextPt'] for page in diagram['pages'])
    lines.append(f'| {title} | [Fuente](../{diagram["sourcePath"]}) | {" · ".join(links)} | {minimum:.2f} pt |')
    mapping.append({'source': name, 'title': title, 'sourcePath': diagram['sourcePath'], 'pages': pages})
lines += ['',
    'La [correspondencia local](../correspondencia-google-docs.json) identifica las '
    'figuras actuales, sus fuentes y sus hashes. Es una preparación para inserción; '
    'no acredita cambios en Google Docs. La correspondencia de la edición anterior '
    'se conserva en el archivo histórico.', '',
    'Regeneración desde `figuras/` (Mermaid CLI ya instalado; Python con Pillow):', '',
    '```sh',
    'node exportar-mermaid.mjs',
    'python3 generar-actores.py',
    'python3 preparar-paneles.py',
    'MERMAID_INPUT=paneles node renderizar-mermaid.mjs /ruta/node_modules/@mermaid-js/mermaid-cli',
    'SVG_INPUT=1 MERMAID_INPUT=renderizados/actores node renderizar-mermaid.mjs /ruta/node_modules/@mermaid-js/mermaid-cli',
    'python3 componer-paginas.py',
    'python3 catalogar-paginas.py',
    '```', '',
    'Los bloques Mermaid del capítulo son la fuente de los 23 diagramas; '
    'los tres modelos resumidos mantienen sus propias fuentes en `modelos-datos/`. '
    'El generador de actores conserva la Figura 3.5. El compositor detiene la '
    'generación si una lámina incumple el tamaño mínimo.', '',
]
(ROOT / 'paginas/README.md').write_text('\n'.join(lines))
(ROOT / 'correspondencia-google-docs.json').write_text(json.dumps({
    'fecha_edicion': '2026-11-16',
    'estado': 'preparacion_local_carta_vertical',
    'actualizacion_remota': False,
    'edicion_anterior': '../../../../archivo/documentacion-grado/proyecto_grado/diagramas-horizontales-2026-11-16/correspondencia-google-docs-anterior.json',
    'figures': mapping,
}, ensure_ascii=False, indent=2) + '\n')
print(f'{len(manifest)} figuras indexadas; correspondencia local actualizada sin publicación remota.')
