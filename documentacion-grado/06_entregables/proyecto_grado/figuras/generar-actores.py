"""Genera la Figura 3.5 y sus cuatro paneles para carta vertical."""
from pathlib import Path
from html import escape
import textwrap

ROOT = Path(__file__).resolve().parent
OUT = ROOT / 'renderizados' / 'actores'
OUT.mkdir(parents=True, exist_ok=True)
PANELS = [
    ('General y Recolección', [
        ('CU-01', 'Administrar datos maestros y usuarios'),
        ('CU-02', 'Registrar recolección'),
        ('CU-03', 'Recibir y validar recolección'),
        ('CU-04', 'Afectar saldo de Recolección'),
        ('CU-08', 'Planificar campaña y subcampaña')],
     [('Operador de Recolección', 490, [1, 3]), ('Revisor de Recolección', 910, [2])],
     [0, 1, 2, 3, 4]),
    ('Vivero', [
        ('CU-05', 'Iniciar lote desde Recolección'),
        ('CU-06', 'Registrar resultado observado'),
        ('CU-07', 'Registrar movimientos de vivero'),
        ('RF-VIV-15', 'Incorporar plantas recibidas o contadas')],
     [('Operador de Vivero autorizado', 680, [0, 1, 2])], [0, 1, 2, 3]),
    ('Plantación y acceso contextual', [
        ('CU-09', 'Asignar plantas'), ('CU-10', 'Devolver plantas'),
        ('CU-11', 'Registrar plantación inicial'),
        ('PA-S03', 'Incorporar o retirar plantadores autorizados')],
     [('Coordinación de Plantación', 360, [0, 1]),
      ('Participante autorizado', 760, [2]),
      ('Administrador de subcampaña', 1160, [2, 3])], [0, 1, 2, 3]),
    ('Consulta y administración contextual', [
        ('CU-12', 'Consultar recorrido operativo autorizado'),
        ('PA-S02', 'Consultar información pública de Plantación'),
        ('PA-S02 · propia', 'Consultar registros y fotografías propios'),
        ('PA-S03', 'Designar o retirar administradores contextuales'),
        ('RF-REC-06', 'Consultar banco público de semillas')],
     [('Usuario de consulta operativa autorizada', 360, [0]),
      ('Visitante sin cuenta', 760, [1, 4]),
      ('Autor o participante autenticado', 1160, [2])], [0, 3]),
]

def label(x, y, value, width=17, size=28, bold=False):
    lines = textwrap.wrap(value, width=width, break_long_words=False)
    weight = ' font-weight="bold"' if bold else ''
    return f'<text x="{x}" y="{y}" font-size="{size}"{weight}>' + ''.join(
        f'<tspan x="{x}" dy="{0 if i == 0 else size + 5}">{escape(line)}</tspan>'
        for i, line in enumerate(lines)) + '</text>'

def actor(x, y, name):
    return (f'<g transform="translate({x} {y})" fill="none" stroke="#253d31" stroke-width="3">'
            '<circle cy="-32" r="20"/><path d="M0 -12 V48 M-35 8 H35 M0 48 L-30 90 M0 48 L30 90"/></g>'
            + label(x, y+130, name))

def panel(n, title, cases, actors, admin):
    ys = [360 + i * 200 for i in range(len(cases))]
    parts = ['<rect width="1200" height="1550" fill="white"/>',
             label(600, 60, f'Figura 3.5 · panel {chr(97+n)}', width=50, size=34, bold=True),
             label(600, 115, title, width=50, size=34, bold=True),
             '<rect x="250" y="210" width="700" height="1150" fill="none" stroke="#476556" stroke-width="3"/>',
             label(600, 255, 'R3Foresta · alcance académico', width=50, size=27)]
    for name, y, links in actors:
        for i in links:
            parts.append(f'<path d="M145 {y+10} L290 {ys[i]}" fill="none" stroke="#687c70" stroke-width="2"/>')
    for i in admin:
        parts.append(f'<path d="M1055 750 L910 {ys[i]}" fill="none" stroke="#687c70" stroke-width="2"/>')
    for y, (code, title) in zip(ys, cases):
        parts.append(f'<ellipse cx="600" cy="{y}" rx="310" ry="78" fill="#f5faf7" stroke="#476556" stroke-width="3"/>')
        parts.append(label(600, y-32, code, width=40, size=29, bold=True))
        parts.append(label(600, y+5, title, width=32, size=30))
    parts += [actor(110, y, name) for name, y, _ in actors]
    parts.append(actor(1090, 740, 'ADMIN global'))
    note = ('Recepción: ADMIN o VALIDADOR asignado al vivero, distinto del recolector.'
            if n == 0 else 'Las asociaciones indican interacción; cada operación conserva sus reglas de autorización.')
    parts.append(label(600, 1430, note, width=79, size=26))
    parts.append(label(600, 1510, 'El mismo sistema y ADMIN se repiten entre paneles.', width=79, size=26))
    return ''.join(parts)

style = '<style>text{font-family:Arial,Helvetica,sans-serif;fill:#172b23;text-anchor:middle}</style>'
body = []
for i, data in enumerate(PANELS):
    content = panel(i, *data)
    title = escape(data[0])
    svg = f'<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="1550" viewBox="0 0 1200 1550" role="img"><title>Figura 3.5: {title}</title>{style}{content}</svg>'
    (OUT / f'03_05_casos_uso_inicio-p{i+1:02}.svg').write_text(svg)
    body.append(f'<g transform="translate(0 {1550*i})">{content}</g>')
(ROOT / '03_05_casos_uso_inicio.svg').write_text(
    '<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="6200" viewBox="0 0 1200 6200" role="img">'
    '<title>Figura 3.5: actores y casos de uso generales, cuatro paneles verticales</title>'
    + style + ''.join(body) + '</svg>')
print('Figura 3.5: cuatro paneles verticales generados.')
