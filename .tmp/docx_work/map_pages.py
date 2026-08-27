import json
import re
import sys
from pathlib import Path

root=Path(__file__).resolve().parents[2]
md=(root/'documentacion-grado/06_entregables/perfil/PERFIL_PROYECTO_GRADO.md').read_text(encoding='utf-8')
render_name=sys.argv[1] if len(sys.argv)>1 else 'render1'
pdf_text=(Path(__file__).parent/render_name/'text.txt').read_text(encoding='utf-8',errors='replace')
pages=pdf_text.split('\f')
headings=[m.group(1).strip() for m in re.finditer(r'^## (.+)$',md,re.M) if re.match(r'(?:\d+\.|Anexos previstos)',m.group(1).strip())]
captions=[m.group(1).strip() for m in re.finditer(r'^\*\*((?:Tabla|Figura)\s+\d+\..+?)\*\*$',md,re.M)]
intro_phys=next(i for i,p in enumerate(pages,1) if re.search(r'^1\. Introducción\s*$',p,re.M))
result={}
for marker in headings+captions:
    for i,p in enumerate(pages,1):
        if i < intro_phys:
            continue
        normalized=' '.join(p.split())
        if ' '.join(marker.split()) in normalized:
            result[marker]=i-intro_phys+1
            break
missing=[m for m in headings+captions if m not in result]
if missing:
    raise SystemExit(f'Missing markers: {missing}')
out=Path(__file__).parent/'page_map.json'
out.write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'intro_physical_page':intro_phys,'entries':result},ensure_ascii=False,indent=2))
