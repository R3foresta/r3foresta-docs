from pathlib import Path
import json,re,base64,html
root=Path(__file__).resolve().parent; panels=root/'paneles'; out=root/'laminas';out.mkdir(exist_ok=True)
manifest=json.loads((panels/'grupos.json').read_text()); catalog=[]
for group in manifest:
 for start in range(0,len(group['panels']),2):
  chunk=group['panels'][start:start+2]; width,height=2400,1500; col=width/len(chunk); body=[]
  for j,item in enumerate(chunk):
   data=(panels/(item['name']+'.svg')).read_text();tag=re.search(r'<svg[^>]+>',data).group();w=float(re.search(r'\bwidth="([\d.]+)',tag).group(1));h=float(re.search(r'\bheight="([\d.]+)',tag).group(1));scale=min((col-80)/w,(height-210)/h);ww=w*scale;hh=h*scale;x=j*col+(col-ww)/2;y=125+(height-195-hh)/2;enc=base64.b64encode(data.encode()).decode();body.append(f'<text x="{j*col+col/2:.1f}" y="88" text-anchor="middle" font-family="Arial,sans-serif" font-size="32" fill="#17212b">{html.escape(item["title"])}</text><image x="{x:.1f}" y="{y:.1f}" width="{ww:.1f}" height="{hh:.1f}" href="data:image/svg+xml;base64,{enc}"/>')
  fname=f'{group["source"]}-lamina-{start//2+1:02}.svg';(out/fname).write_text(f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="img"><title>{html.escape(group["source"])}: paneles {start+1} a {start+len(chunk)}</title><rect width="100%" height="100%" fill="white"/>{"".join(body)}</svg>');catalog.append({'source':group['source'],'lamina':fname,'paneles':[p['name'] for p in chunk]})
(out/'manifest.json').write_text(json.dumps(catalog,ensure_ascii=False,indent=2)+'\n'); print(len(catalog),'láminas horizontales')
