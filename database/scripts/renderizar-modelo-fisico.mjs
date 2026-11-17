import { execFileSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const flag = process.argv.indexOf('--cli');
const cli = flag >= 0 ? process.argv[flag + 1] : null;
if (flag >= 0 && !cli) throw new Error('Falta la ruta de mermaid-cli después de --cli');
for (const name of ['completo', 'nucleo', 'general', 'participacion', 'correcciones', 'operacion']) {
  const args = ['-i', `database/diagramas/modelo-fisico-${name}.mmd`,
    '-o', `database/diagramas/modelo-fisico-${name}.svg`,
    '-c', 'database/diagramas/mermaid-config.json', '-b', 'white'];
  execFileSync(cli ? process.execPath : 'mmdc', cli ? [path.resolve(cli), ...args] : args,
    { cwd: root, stdio: 'inherit', timeout: 120000 });
  console.log(`SVG generado: ${name}`);
}
