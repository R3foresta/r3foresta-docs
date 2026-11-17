import fs from 'node:fs/promises';
import path from 'node:path';
import { pathToFileURL, fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';

// Uso: node renderizar-mermaid.mjs /ruta/node_modules/@mermaid-js/mermaid-cli [filtro]
// Reutiliza un navegador y genera SVG y PNG a 3× sin servicios externos.
const here = path.dirname(fileURLToPath(import.meta.url));
const cli = process.argv[2];
if (!cli) throw new Error('Indicar el directorio instalado de @mermaid-js/mermaid-cli.');
const { renderMermaid } = await import(pathToFileURL(path.join(cli, 'src/index.js')));
const require = createRequire(path.join(cli, 'package.json'));
const { default: puppeteer } = await import(pathToFileURL(require.resolve('puppeteer')));
const config = JSON.parse(await fs.readFile(path.join(here, 'mermaid-config.json'), 'utf8'));
const out = path.join(here, process.env.MERMAID_OUTPUT || 'renderizados');
const input = process.env.MERMAID_INPUT || 'mermaid';
await fs.mkdir(out, { recursive: true });
const browser = await puppeteer.launch({ executablePath: process.env.CHROME_BIN || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', headless: true });
const report = [];
try {
  const extension = process.env.SVG_INPUT ? '.svg' : '.mmd';
  for (const f of (await fs.readdir(path.join(here, input))).filter(f => f.endsWith(extension) && (!process.argv[3] || new RegExp(process.argv[3]).test(f))).sort()) {
    const source = await fs.readFile(path.join(here, input, f), 'utf8');
    const name = f.slice(0, -extension.length);
    const localConfig = structuredClone(config);
    if (source.startsWith('sequenceDiagram') && source.split('\n').filter(l => /^\s*(actor|participant) /.test(l)).length <= 3) {
      localConfig.sequence.width = 180;
      localConfig.sequence.messageMargin = 20;
      if (/elaboracion-14-p05|construccion-02-p02/.test(name)) {
        localConfig.sequence.width = 240;
        localConfig.sequence.messageMargin = 8;
      }
    }
    const svg = extension === '.svg' ? { data: source } : await renderMermaid(browser, source, 'svg', { mermaidConfig: localConfig, viewport: { width: 1600, height: 1200, deviceScaleFactor: 1 } });
    const svgPath = path.join(out, `${name}.svg`);
    await fs.writeFile(svgPath, svg.data);
    const page = await browser.newPage();
    await page.setViewport({ width: 1600, height: 1200, deviceScaleFactor: 3 });
    await page.goto(pathToFileURL(svgPath).href);
    const element = await page.$('svg');
    const box = await element.boundingBox();
    const minFontPx = await page.evaluate(() => Math.min(...[...document.querySelectorAll('svg text, svg tspan, svg foreignObject span')]
      .filter(el => el.textContent.trim() && el.getBoundingClientRect().width > 0)
      .map(el => parseFloat(getComputedStyle(el).fontSize)).filter(Number.isFinite)));
    await element.screenshot({ path: path.join(out, `${name}.png`) });
    await page.close();
    const scale = Math.min(468 / box.width, 582 / box.height);
    const item = { name, width: box.width, height: box.height, minFontPx, widthPt: +(box.width * scale).toFixed(2), heightPt: +(box.height * scale).toFixed(2), textPt: +(minFontPx * scale).toFixed(2) };
    report.push(item);
    console.log(JSON.stringify(item));
  }
  let previous = [];
  try { previous = JSON.parse(await fs.readFile(path.join(out, 'dimensiones.json'), 'utf8')); }
  catch (error) { if (error.code !== 'ENOENT') throw error; }
  const measurements = new Map(previous.map(item => [item.name, item]));
  for (const item of report) measurements.set(item.name, item);
  await fs.writeFile(path.join(out, 'dimensiones.json'), JSON.stringify([...measurements.values()].sort((a, b) => a.name.localeCompare(b.name)), null, 2) + '\n');
} finally { await browser.close(); }
