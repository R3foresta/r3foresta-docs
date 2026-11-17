"""Deriva paneles verticales sin omitir relaciones de las fuentes completas.

Los nodos frontera se repiten con identidad y etiqueta conservadas. Los modelos
resumidos también se incluyen; la figura de actores se deriva por su generador
SVG y se declara aquí para la composición común.
"""
from pathlib import Path
import re, json, textwrap

ROOT = Path(__file__).resolve().parent
OUT = ROOT / 'paneles'
OUT.mkdir(exist_ok=True)

# Cada grupo asigna las relaciones por su nodo de origen. Los nodos frontera
# se repiten con la misma etiqueta para conservar continuidad entre páginas.
FLOW = {
 '03_1_fase_inicio-01': [('Recorrido operativo', 'A B C D E F G H'), ('Memoria de responsables', 'M'), ('Soportes documentales', 'P X')],
 '03_2_fase_elaboracion-01': [('Origen desde Recolección', 'REC VAL INI PROC RES'), ('Incorporación y existencias', 'COMP DON EXIST RECEP INVENT IDENT ETAPA'), ('Manejo y entrega física', 'EMB INC LOTE MAN MER SAL ENTREGA ASIG DEV'), ('Registro y consulta', 'PLANT DIRECTA CAMPO TRAZA')],
 '03_2_fase_elaboracion-10': [('Captura y validación', 'I B D E S C R'), ('Destino y cierre del saldo', 'V O T X Z')],
 '03_2_fase_elaboracion-11': [('Ingreso y resultado observado', 'I MOD O T P R AD'), ('Base viva y operación', 'E N SAL OP X')],
 '03_2_fase_elaboracion-12': [('Captura y confirmación', 'I C F Q P K'), ('Validación y resultado', 'V T RESP'), ('Recuperación del mismo intento', 'U REC TERM OK')],
 '03_3_fase_construccion-01': [('Capacidades y preparación', 'C P E Q S U'), ('Confirmación y resultado', 'G V'), ('Recuperación', 'R T I')],
 '03_4_fase_transicion-01': [('Reconstrucción y contraste', 'S E R C'), ('Resultado y decisión', 'D V P N H')],
 'modelo-conceptual': [('Origen y vida del lote', 'R I L'), ('Campaña y destino', 'C S'), ('Consumo y participación', 'A P')],
 'modelo-logico': [('Origen y vida del lote', 'R I L'), ('Campaña y destino', 'C S'), ('Consumo y participación', 'A P U')],
 '03_capitulo_marco_aplicativo-01': [('Inicio y Elaboración', 'IN1 EI LCO EL1 EE LCA'), ('Construcción', 'CO1 CO2 CO3 CO4 EC IOC'), ('Transición', 'TR1 ET'), ('Evidencia e iteraciones', 'PA CAM REV')],
}
USE = {
 '03_2_fase_elaboracion-03': [('Administración general', 'C1 UR AV'), ('Recolección', 'C2 C3 C4'), ('Vivero', 'C5 C6 C7 INC'), ('Planificación y logística', 'C8 C9 C10'), ('Registro y permisos', 'C11 ACC'), ('Consultas según audiencia', 'C12 IMP MIS'), ('Banco público de semillas', 'BAN')],
 '03_2_fase_elaboracion-04': [('Captura de Recolección', 'CRE EDI ENV COR'), ('Revisión de Recolección', 'REV APR REJ'), ('Saldo e historial', 'DEL DES CONH ESP'), ('Banco público de semillas', 'BAN')],
 '03_2_fase_elaboracion-05': [('Ingreso desde Recolección', 'SEM INI'), ('Incorporación e inventario', 'INC INV DOC'), ('Resultado y manejo', 'EMB PRE ADA'), ('Movimientos e historial', 'MER DES HIS')],
 '03_2_fase_elaboracion-06': [('Planificación de Plantación', 'PLAN ACT CIE'), ('Logística física', 'ENT DEV'), ('Registro inicial', 'REG COL'), ('Gestión del equipo', 'EQU GP GA'), ('Consultas según audiencia', 'PUB PRO')],
}

def flow_parse(text):
    defs={}; edges=[]
    # Definiciones completas; todas las fuentes usan etiquetas sin corchetes internos.
    pattern=re.compile(r'\b(\w+)(\[\(".*?"\)\]|\(\[".*?"\]\)|\(\[[^\]]*\]\)|\[".*?"\]|\[[^\]]*\]|\{".*?"\}|\{[^}]*\})')
    for line in text.splitlines()[1:]:
        if line.strip().startswith(('subgraph ', 'end', 'direction ', '%%')): continue
        def extract(m):
            defs[m[1]]=m[0]
            return m[1]
        line=pattern.sub(extract,line).strip()
        if re.search(r'-->|---|-\.->|\.->',line):
            first=re.match(r'(\w+)',line)[1]
            last=re.search(r'(\w+)\s*$',line)[1]
            chain=re.fullmatch(r'\w+(?:\s*-->\s*\w+){2,}',line)
            if chain:
                nodes=re.split(r'\s*-->\s*',line)
                edges.extend((a,b,f'{a} --> {b}') for a,b in zip(nodes,nodes[1:]))
            else: edges.append((first,last,line))
    return defs,edges

def flow_panel(defs, edges, title):
    ids=set()
    for a,b,_ in edges: ids.update((a,b))
    return 'flowchart TB\n'+'\n'.join('    '+v for k,v in defs.items() if k in ids)+'\n'+'\n'.join('    '+e for _,_,e in edges)+'\n'

manifest=[]
inputs=sorted((ROOT/'mermaid').glob('*.mmd'))+sorted((ROOT/'modelos-datos').glob('*.mmd'))
for p in inputs:
    name=p.stem; text=p.read_text(); panels=[]
    if name in FLOW or name in USE:
        defs,edges=flow_parse(text)
        groups=FLOW.get(name) or USE[name]
        selected_all=set()
        actor_ids={a for a,b,e in edges if '---' in e}
        for title,group in groups:
            prim=set(group.split()); selected=[]
            for i,(a,b,e) in enumerate(edges):
                keep=(b in prim if a in actor_ids else a in prim)
                if keep: selected.append((a,b,e)); selected_all.add(i)
            panel=flow_panel(defs,selected,title)
            if name=='03_capitulo_marco_aplicativo-01' and title=='Evidencia e iteraciones':
                panel+='    IN1 ~~~ EL1 ~~~ CO3 ~~~ CO4 ~~~ TR1\n'
            panels.append((title,panel))
        missing=set(range(len(edges)))-selected_all
        if missing: raise ValueError(f'{name}: relaciones sin panel: {[edges[i] for i in missing]}')
    elif name in ('03_2_fase_elaboracion-15','03_2_fase_elaboracion-16','03_2_fase_elaboracion-18','modelo-fisico'):
        kind=text.splitlines()[0]; lines=text.splitlines()[1:]
        relations=[l for l in lines if re.search(r'--|<\||\.\.',l) and not l.strip().startswith('note ')]
        if name=='modelo-fisico':
            groups=[('Recolección y recepción',[0]),('Origen del lote desde Recolección',[1]),('Evento e incorporación',[2,3]),('Campaña y asignación física',[4,5,6]),('Registro en subcampaña',[7]),('Detalle y asignación',[8]),('Detalle y lote de origen',[9]),('Detalle y registro',[10])]
        elif name.endswith('-15'):
            groups=[('Identidad, permisos y planificación',range(0,8)),('Origen y vida del lote',range(8,15)),('Asignación y detalle de consumo',range(15,19)),('Participación histórica',range(19,21)),('Evidencia de un solo hecho',range(21,len(relations)))]
        elif name.endswith('-16'):
            groups=[('Accesos de Vivero',[0,1]),('Permisos de subcampaña',[2,3]),('Responsabilidades logísticas',[4,5]),('Planificación',range(6,9)),('Modalidades de origen',range(9,11)),('Custodia e historial',range(11,14)),('Asignación y consumo',range(14,20)),('Responsabilidad y participación',range(20,23)),('Operación recuperable y evidencia',range(23,len(relations)))]
        else:
            groups=[('Consulta y administración',[0,1,2]),('Recolección',[0,1,3,4]),('Vivero y coordinación',[0,1,5,6]),('Participación en subcampaña',[0,1,7,8])]
        all_indices=set()
        attrs=dict((m[1],m[0]) for m in re.finditer(r'(\w+)\s*\{\n[^}]*\}',text)) if kind=='erDiagram' else {}
        for title,indices in groups:
            indices=list(indices);all_indices.update(indices)
            rel=[relations[i] for i in indices]
            if kind=='classDiagram':
                ids=set(re.findall(r'^\s*(\w+)\s+(?:"[^"]*"\s+)?(?:<\|--|-->|--)', '\n'.join(rel),re.M)) | set(re.findall(r'(?:<\|--|-->|--)\s*(?:"[^"]*"\s+)?(\w+)', '\n'.join(rel)))
                notes=[l for l in lines if l.strip().startswith('note for ') and l.split()[2] in ids]
                # Las notas largas se envuelven sin suprimir su regla textual.
                notes=[re.sub(r'"([^"\n]*)"$',lambda m:'"'+'<br/>'.join(textwrap.wrap(m[1],44,break_long_words=False,break_on_hyphens=False))+'"',line) for line in notes]
                direction='TB'
                panel=f'classDiagram\n    direction {direction}\n'+'\n'.join('    class '+i for i in sorted(ids))+'\n'+'\n'.join(rel+notes)+'\n'
            else:
                ids={r.split()[0] for r in rel} | {r.split()[2] for r in rel}
                direction='TB'
                panel=f'erDiagram\n    direction {direction}\n'+'\n'.join(rel)+'\n'+'\n'.join(attrs[i] for i in attrs if i in ids)+'\n'
            panels.append((title,panel))
        assert all_indices==set(range(len(relations))), (name,len(relations),all_indices)
    elif text.startswith('sequenceDiagram') and (name.endswith('elaboracion-14') or name.endswith('construccion-02')):
        lines=text.splitlines(); decl=[l for l in lines if l.strip().startswith(('actor ','participant '))]
        body=[l for l in lines[1:] if l not in decl]
        # Cortes entre operaciones; cada bloque alt/opt se conserva completo.
        marker='    P->>UI: Preparar registro inicial' if name.endswith('elaboracion-14') else '    U->>PWA: Confirmar resumen'
        a=body.index(marker)
        marker2='    opt Respuesta perdida o inconclusa'
        b=body.index(marker2)
        if name.endswith('elaboracion-14'):
            marker_mid='    P->>UI: Confirmar ubicación, fecha, cantidades y participantes'
            mid=body.index(marker_mid)
            photos=body.index('    UI->>API: Enviar fotografías del mismo comando')
            ranges=[('Entrega física',body[:a]),('Preparación y contexto',body[a:photos]),('Carga de evidencia',body[photos:mid]),('Confirmación de captura',body[mid:mid+1]),('Confirmación transaccional',body[mid+1:b]),('Recuperación y devolución',body[b:])]
        else:
            ranges=[('Contexto, preparación y cargas',body[:a+1]),('Confirmación transaccional',body[a+1:b]),('Recuperación y consulta propia',body[b:])]
        for title,part in ranges:
            used=set()
            for l in part:
                m=re.match(r'\s*(\w+)[-]+>>?(\w+):',l)
                if m: used.update(m.groups())
                m=re.search(r'Note over ([\w,]+):',l)
                if m:used.update(m[1].split(','))
            active=[l for l in decl if l.split()[1] in used]
            panels.append((title,'sequenceDiagram\n'+'\n'.join(active+part)+'\n'))
    else:
        panels=[('',text)]
    # Solo se añaden saltos de línea tipográficos: no cambia ningún mensaje.
    wrapped=[]
    for title,source in panels:
        if source.startswith('sequenceDiagram'):
            lines=[]
            for line in source.splitlines():
                if ':' in line and re.match(r'\s*(?:\w+[-]+>>?\w+|Note over )',line):
                    prefix,label=line.split(':',1)
                    label='<br/>'.join('<br/>'.join(textwrap.wrap(chunk.strip(),36 if name == '03_2_fase_elaboracion-14' else 44,break_long_words=False,break_on_hyphens=False)) for chunk in label.split('<br/>'))
                    line=prefix+': '+label
                lines.append(line)
            source='\n'.join(lines)+'\n'
        wrapped.append((title,source))
    panels=wrapped
    items=[]
    for i,(title,source) in enumerate(panels,1):
        stem=f'{name}-p{i:02}'
        (OUT/f'{stem}.mmd').write_text(source.rstrip()+'\n')
        items.append({'name':stem,'title':title})
    manifest.append({'source':name,'sourcePath':str(p.relative_to(ROOT)),'panels':items})
manifest.append({
    'source':'03_05_casos_uso_inicio',
    'sourcePath':'03_05_casos_uso_inicio.svg',
    'panels':[
        {'name':f'03_05_casos_uso_inicio-p{i:02}','title':title}
        for i,title in enumerate((
            'Recolección', 'Vivero', 'Plantación y acceso contextual',
            'Consulta y administración contextual'
        ),1)
    ]
})
# Retirar solo fuentes generadas que ya no estén en el manifiesto vigente.
expected={panel['name'] for diagram in manifest for panel in diagram['panels']}
for stale in OUT.glob('*-p[0-9][0-9].mmd'):
    if stale.stem not in expected:
        stale.unlink()
(OUT/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
print(f'{len(manifest)} diagramas, {sum(len(m["panels"]) for m in manifest)} paneles; cobertura de relaciones verificada.')
