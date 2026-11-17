"""Compone figuras para el área de 468 × 620 pt de una hoja carta vertical.

Requiere paneles renderizados con minFontPx medido en navegador en el informe
renderizados/dimensiones.json. Si algún panel queda por debajo de 9 pt, falla
antes de sustituir láminas. Produce PNG a 288 ppp y SVG con diagramas vectoriales.
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import base64
import html
import json
import re

ROOT = Path(__file__).resolve().parent
OUT = ROOT / 'paginas'
S = 4
W, H = 468, 620
MIN_TEXT_PT, TARGET_TEXT_PT = 9, 11
TITLE_HEIGHT, FOOTER_HEIGHT, GAP = 14, 18, 6
FONT = '/System/Library/Fonts/Supplemental/Arial.ttf'
font = ImageFont.truetype(FONT, 10 * S)
small = ImageFont.truetype(FONT, 9 * S)
manifest = json.loads((ROOT / 'paneles/manifest.json').read_text())
measurements = {
    item['name']: item
    for item in json.loads((ROOT / 'renderizados/dimensiones.json').read_text())
}


def prepare_panel(panel, multiple):
    name = panel['name']
    svg = (ROOT / 'renderizados' / f'{name}.svg').read_text()
    viewbox = re.search(r'viewBox="([^"]+)"', svg)
    if not viewbox:
        raise ValueError(f'{name}: SVG sin viewBox')
    _, _, width, height = map(float, viewbox[1].split())
    base_font = measurements.get(name, {}).get('minFontPx')
    if not base_font or base_font <= 0:
        raise ValueError(f'{name}: falta minFontPx medido; volver a renderizar los paneles')
    title = panel['title'] if multiple else ''
    available_height = H - FOOTER_HEIGHT - (TITLE_HEIGHT if title else 0) - GAP
    scale = min(TARGET_TEXT_PT / base_font, W / width, available_height / height)
    text_pt = base_font * scale
    if text_pt < MIN_TEXT_PT - 1e-6:
        raise ValueError(
            f'{name}: texto mínimo {text_pt:.2f} pt; dividir el panel '
            f'({width:.1f} × {height:.1f} px, fuente mínima {base_font:g} px)'
        )
    png_path = ROOT / 'renderizados' / f'{name}.png'
    if not png_path.is_file():
        raise ValueError(f'{name}: falta el PNG renderizado')
    return {
        'panel': panel, 'svg': svg, 'imagePath': png_path,
        'width': width * scale, 'height': height * scale,
        'title': title, 'textPt': text_pt,
        'space': height * scale + (TITLE_HEIGHT if title else 0) + GAP,
    }


# Validar todos los paneles antes de sustituir ninguna lámina vigente.
prepared = []
for diagram in manifest:
    panels = [prepare_panel(panel, len(diagram['panels']) > 1) for panel in diagram['panels']]
    pages, entries, used = [], [], 0
    for panel in panels:
        if entries and used + panel['space'] > H - FOOTER_HEIGHT:
            pages.append(entries)
            entries, used = [], 0
        entries.append(panel)
        used += panel['space']
    if entries:
        pages.append(entries)
    prepared.append((diagram, pages))

OUT.mkdir(exist_ok=True)
report = []
for diagram, pages in prepared:
    output = []
    for number, entries in enumerate(pages, 1):
        canvas = Image.new('RGB', (W * S, H * S), 'white')
        draw = ImageDraw.Draw(canvas)
        elements = []
        y = 0
        for entry in entries:
            if entry['title']:
                draw.text((0, y * S), entry['title'], font=font, fill='#233f31')
                elements.append(
                    f'<text x="0" y="{y + 11:.2f}" font-family="Arial,sans-serif" '
                    f'font-size="10" fill="#233f31">{html.escape(entry["title"])}</text>'
                )
                y += TITLE_HEIGHT
            width, height = entry['width'], entry['height']
            x = (W - width) / 2
            with Image.open(entry['imagePath']) as image:
                resized = image.convert('RGB').resize((round(width * S), round(height * S)), Image.Resampling.LANCZOS)
            canvas.paste(resized, (round(x * S), round(y * S)))
            encoded = base64.b64encode(entry['svg'].encode()).decode()
            elements.append(
                f'<image x="{x:.3f}" y="{y:.3f}" width="{width:.3f}" '
                f'height="{height:.3f}" href="data:image/svg+xml;base64,{encoded}"/>'
            )
            y += height + GAP
        if len(pages) > 1:
            label = f'Parte {number} de {len(pages)}'
            draw.text((0, (H - 13) * S), label, font=small, fill='#475569')
            elements.append(
                f'<text x="0" y="{H - 4}" font-family="Arial,sans-serif" '
                f'font-size="9" fill="#475569">{label}</text>'
            )
        stem = f'{diagram["source"]}-hoja-{number:02}'
        canvas.save(OUT / f'{stem}.png', dpi=(288, 288))
        title = html.escape(f'{diagram["source"]} · {number}/{len(pages)}')
        (OUT / f'{stem}.svg').write_text(
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}pt" height="{H}pt" '
            f'viewBox="0 0 {W} {H}" role="img"><title>{title}</title>'
            f'<rect width="100%" height="100%" fill="white"/>{"".join(elements)}</svg>\n'
        )
        output.append({
            'path': f'paginas/{stem}.png', 'svg': f'paginas/{stem}.svg',
            'widthPt': W, 'heightPt': H,
            'panels': [entry['panel']['name'] for entry in entries],
            'minTextPt': round(min(entry['textPt'] for entry in entries), 2),
        })
    report.append({'source': diagram['source'], 'sourcePath': diagram['sourcePath'], 'pages': output})
(OUT / 'manifest.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
expected = {
    Path(page[key]).name
    for diagram in report for page in diagram['pages'] for key in ('path', 'svg')
}
for extension in ('png', 'svg'):
    for stale in OUT.glob(f'*-hoja-[0-9][0-9].{extension}'):
        if stale.name not in expected:
            stale.unlink()
print(f'{len(report)} figuras compuestas en {sum(len(item["pages"]) for item in report)} láminas verticales; texto ≥ {MIN_TEXT_PT} pt.')
