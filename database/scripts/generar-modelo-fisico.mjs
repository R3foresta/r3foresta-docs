import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createHash } from 'node:crypto';

// Columnas y restricciones del extracto contextual aportado.
// Las claves compuestas conservan la procedencia de su contraste SQL local.
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const source = fs.readFileSync(path.join(root, 'fuentes/supabase-estructura-2026-11-16.sql'), 'utf8');
const metadata = JSON.parse(fs.readFileSync(path.join(root, 'fuentes/supabase-relaciones-2026-11-16.json'), 'utf8'));
if (createHash('sha256').update(source).digest('hex') !== metadata.sha256) {
  throw new Error('La fuente SQL difiere de la huella documentada. Revisar su procedencia.');
}
const tables = new Map();
const relationships = [];
for (const match of source.matchAll(/^CREATE TABLE public\.(\w+) \(\n([\s\S]*?)\n\);/gm)) {
  const table = { name: match[1], columns: [] };
  if (tables.has(table.name)) throw new Error(`Tabla duplicada: ${table.name}`);
  tables.set(table.name, table);
  const foreignKeys = new Map();
  for (const line of match[2].split('\n')) {
    const row = line.match(/^  (\w+) (.+)/);
    if (row && row[1] !== 'CONSTRAINT') {
      const declaration = row[2].replace(/,$/, '');
      const rawType = declaration.split(/\s+(?:NOT NULL|NULL|DEFAULT|GENERATED|CHECK|UNIQUE|PRIMARY KEY|REFERENCES)\b/)[0];
      const type = rawType.replaceAll(' ', '_').replaceAll('-', '_').replaceAll('[]', '_array');
      table.columns.push({ name: row[1], type, declaration, primary: false,
        unique: /\bUNIQUE\b/.test(declaration), nullable: !/\bNOT NULL\b/.test(declaration),
        identity: /\bAS IDENTITY\b/.test(declaration) });
    }
    const key = line.match(/CONSTRAINT (\w+) FOREIGN KEY \(([^)]+)\) REFERENCES public\.(\w+)\(([^)]+)\)/);
    if (key) {
      const f = foreignKeys.get(key[1]) ?? { table: table.name, name: key[1], target: key[3], columns: [], targetColumns: [] };
      if (f.target !== key[3]) throw new Error(`Destino incompatible: ${key[1]}`);
      f.columns.push(...key[2].split(',').map(c => c.trim()));
      f.targetColumns.push(...key[4].split(',').map(c => c.trim()));
      foreignKeys.set(key[1], f);
    }
  }
  const primary = match[2].match(/CONSTRAINT \w+ PRIMARY KEY \(([^)]+)\)/);
  for (const name of primary?.[1].split(',').map(c => c.trim()) ?? []) {
    const column = table.columns.find(c => c.name === name);
    if (!column) throw new Error(`Columna PK desconocida: ${table.name}.${name}`);
    column.primary = true;
    column.nullable = false;
  }
  relationships.push(...foreignKeys.values());
}
for (const f of relationships) {
  f.source = 'Extracto aportado';
  if (f.columns.length > 1) {
    const origin = metadata.fuentes_compuestas.find(c => c.table === f.table && c.name === f.name);
    if (!origin || JSON.stringify(origin.columns) !== JSON.stringify(f.columns) ||
        origin.target !== f.target || JSON.stringify(origin.targetColumns) !== JSON.stringify(f.targetColumns)) {
      throw new Error(`Clave compuesta sin contraste documentado: ${f.table}.${f.name}`);
    }
    f.source = `Extracto y SQL ${origin.migration}`;
  }
}
function col(t, name) {
  const c = tables.get(t)?.columns.find(c => c.name === name);
  if (!c) throw new Error(`Columna no encontrada: ${t}.${name}`);
  return c;
}
for (const f of relationships) {
  f.columns.forEach(c => col(f.table, c));
  f.targetColumns.forEach(c => col(f.target, c));
}
const views = {
  completo: { title: 'Modelo físico completo · extracto aportado · revisión 16 de noviembre de 2026', tables: [...tables.keys()] },
  nucleo: { title: 'Modelo físico · recorrido Recolección → Vivero → Plantación', tables: [
    'recoleccion', 'recoleccion_historial', 'recoleccion_movimiento', 'lote_vivero', 'evento_lote_vivero',
    'campania', 'subcampania', 'subcampania_historial', 'subcampania_meta_especie',
    'asignacion_vivero_subcampania', 'registro_plantacion', 'registro_plantacion_detalle',
    'registro_plantacion_coresponsable', 'evento_plantacion', 'recoleccion_recepcion', 'vivero_incorporacion',
  ] },
  general: { title: 'Modelo físico · identidad, catálogos, territorio y evidencias', tables: [
    'usuario', 'usuario_credencial', 'organizacion', 'planta', 'tipo_planta', 'pais',
    'division_tipo', 'division_administrativa', 'ubicacion', 'vivero', 'metodo_recoleccion',
    'tipos_entidad_evidencia', 'evidencias_trazabilidad',
  ] },
  participacion: { title: 'Modelo físico · permisos, comandos y cargas de participación', tables: [
    'usuario', 'organizacion', 'subcampania', 'subcampania_equipo', 'subcampania_permiso_revision',
    'subcampania_permiso', 'participacion_comando', 'usuario_autoridad_historial',
    'participacion_carga', 'participacion_carga_generacion', 'evidencias_trazabilidad',
  ] },
  correcciones: { title: 'Modelo físico · originales, estado efectivo y compensaciones', tables: [
    'participacion_comando', 'registro_plantacion', 'registro_plantacion_coresponsable',
    'registro_plantacion_detalle', 'evento_plantacion', 'asignacion_vivero_subcampania',
    'registro_plantacion_grupo_revision', 'registro_plantacion_correccion', 'registro_plantacion_efectivo',
    'evento_plantacion_efectivo', 'registro_plantacion_participante_efectivo',
    'registro_plantacion_consumo_credito', 'registro_plantacion_consumo_compensacion',
  ] },
  operacion: { title: 'Modelo físico · acceso por vivero, recepción e incorporación', tables: [
    'usuario', 'vivero', 'recoleccion', 'lote_vivero', 'evento_lote_vivero', 'evidencias_trazabilidad',
    'recoleccion_acceso_comando', 'usuario_acceso_recoleccion_revision', 'usuario_acceso_recoleccion',
    'usuario_acceso_recoleccion_historial', 'vivero_acceso_comando', 'usuario_vivero_revision',
    'usuario_vivero', 'usuario_vivero_historial', 'm2_evidencia_contexto',
    'recoleccion_recepcion_comando', 'recoleccion_recepcion', 'recoleccion_recepcion_evidencia_contexto',
    'recoleccion_recepcion_evidencia', 'vivero_incorporacion',
  ] },
};
const out = path.join(root, 'diagramas');
fs.mkdirSync(out, { recursive: true });
const stats = [];
for (const [name, view] of Object.entries(views)) {
  const selected = new Set(view.tables);
  const lines = ['---', `title: ${view.title}`, '---', 'erDiagram', '  direction TB',
    '  %% Generado por database/scripts/generar-modelo-fisico.mjs.',
    '  %% NULL / NN e IDENTITY proceden de la exportación aportada.',
    '  %% FK del extracto aportado. Claves compuestas agrupadas y contrastadas con SQL local.',
    '  %% USER_DEFINED conserva el tipo no resuelto por el extracto.',
    '  %% La vista temática solo dibuja relaciones cuyos dos extremos están incluidos.',
  ];
  for (const t of view.tables) {
    const data = tables.get(t);
    if (!data) throw new Error(`Tabla de vista desconocida: ${t}`);
    const fks = new Set(relationships.filter(f => f.table === t).flatMap(f => f.columns));
    lines.push(`  ${t} {`);
    for (const c of data.columns) {
      const keys = [c.primary && 'PK', fks.has(c.name) && 'FK', c.unique && 'UK'].filter(Boolean);
      const comment = [c.nullable ? 'NULL' : 'NN', c.identity && 'IDENTITY'].filter(Boolean).join(' / ');
      lines.push(`    ${c.type} ${c.name}${keys.length ? ' ' + keys.join(', ') : ''} "${comment}"`);
    }
    lines.push('  }', '');
  }
  let count = 0;
  for (const f of relationships.filter(f => selected.has(f.table) && selected.has(f.target))) {
    const cs = f.columns.map(c => col(f.table, c));
    const primary = tables.get(f.table).columns.filter(c => c.primary).map(c => c.name);
    const exactPk = primary.length === cs.length && primary.every(c => f.columns.includes(c));
    const unique = exactPk || cs.some(c => c.unique);
    const optional = cs.some(c => c.nullable);
    const identifying = cs.every(c => c.primary);
    lines.push(`  %% ${f.source}: ${f.table}(${f.columns.join(',')}) -> ${f.target}(${f.targetColumns.join(',')})`);
    lines.push(`  ${f.target} ${optional ? '|o' : '||'}${identifying ? '--' : '..'}${unique ? 'o|' : 'o{'} ${f.table} : "${f.columns.join('+')}"`);
    count++;
  }
  fs.writeFileSync(path.join(out, `modelo-fisico-${name}.mmd`), lines.join('\n') + '\n');
  stats.push({ view: name, tables: selected.size, columns: view.tables.reduce((n, t) => n + tables.get(t).columns.length, 0), relationships: count });
}
const composites = relationships.filter(f => f.columns.length > 1);
console.log(JSON.stringify({ tables: tables.size, columns: [...tables.values()].reduce((n, t) => n + t.columns.length, 0), simpleRelationships: relationships.length - composites.length, compositeRelationshipsFromSql: composites.length, views: stats }, null, 2));
