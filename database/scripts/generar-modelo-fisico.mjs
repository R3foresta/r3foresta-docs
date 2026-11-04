import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

// Generación mecánica: columnas de la exportación; relaciones de sus fuentes
// declaradas. No consulta la base ni interpreta nombres *_id como claves.
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const source = fs.readFileSync(path.join(root, 'fuentes/supabase-estructura-2026-11-04.md'), 'utf8');
const metadata = JSON.parse(fs.readFileSync(path.join(root, 'fuentes/supabase-relaciones-2026-11-04.json'), 'utf8'));
const tables = new Map();
let table;
for (const line of source.split('\n')) {
  const heading = line.match(/^## Table `([^`]+)`$/);
  if (heading) {
    table = { name: heading[1], columns: [] };
    if (tables.has(table.name)) throw new Error(`Tabla duplicada: ${table.name}`);
    tables.set(table.name, table);
  } else if (line.startsWith('## Custom Types')) {
    table = undefined;
  } else {
    const row = line.match(/^\| `([^`]+)` \| `([^`]+)` \|\s*(.*?)\s*\|$/);
    if (table && row) table.columns.push({ name: row[1], type: row[2], constraints: row[3] });
  }
}
const composites = metadata.fuentes_compuestas.map(f => ({ ...f, source: `SQL ${f.migration}` }));
const relationships = metadata.foreignKeys
  .filter(f => tables.has(f.table) && tables.has(f.target))
  .map(f => ({ ...f, columns: [f.column], targetColumns: [f.targetColumn], source: 'PostgREST' }));
relationships.push(...composites);
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
  completo: { title: 'Modelo físico completo · Supabase · 4 de noviembre de 2026', tables: [...tables.keys()] },
  nucleo: { title: 'Modelo físico · recorrido Recolección → Vivero → Plantación', tables: [
    'recoleccion', 'recoleccion_historial', 'recoleccion_movimiento', 'lote_vivero', 'evento_lote_vivero',
    'campania', 'subcampania', 'subcampania_historial', 'subcampania_meta_especie',
    'asignacion_vivero_subcampania', 'registro_plantacion', 'registro_plantacion_detalle',
    'registro_plantacion_coresponsable', 'evento_plantacion',
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
  legado: { title: 'Modelo físico · tablas de Plantación conservadas y seguimiento', tables: [
    'plantacion', 'plantacion_usuario', 'plantacion_riego', 'plantacion_abono', 'plantacion_foto',
    'plantacion_monitoreo', 'tipo_riego', 'tipo_abono', 'usuario', 'ubicacion',
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
    '  %% FK simples: catálogo PostgREST. FK compuestas: SQL 070/072/074/082.',
    '  %% La vista temática solo dibuja relaciones cuyos dos extremos están incluidos.',
  ];
  for (const t of view.tables) {
    const data = tables.get(t);
    if (!data) throw new Error(`Tabla de vista desconocida: ${t}`);
    const fks = new Set(relationships.filter(f => f.table === t).flatMap(f => f.columns));
    lines.push(`  ${t} {`);
    for (const c of data.columns) {
      const keys = [c.constraints.includes('Primary') && 'PK', fks.has(c.name) && 'FK',
        c.constraints.includes('Unique') && 'UK'].filter(Boolean);
      const comment = [c.constraints.includes('Nullable') ? 'NULL' : 'NN',
        c.constraints.includes('Identity') && 'IDENTITY'].filter(Boolean).join('; ');
      lines.push(`    ${c.type} ${c.name}${keys.length ? ' ' + keys.join(', ') : ''} "${comment}"`);
    }
    lines.push('  }', '');
  }
  let count = 0;
  for (const f of relationships.filter(f => selected.has(f.table) && selected.has(f.target))) {
    const cs = f.columns.map(c => col(f.table, c));
    const primary = tables.get(f.table).columns.filter(c => c.constraints.includes('Primary')).map(c => c.name);
    const exactPk = primary.length === cs.length && primary.every(c => f.columns.includes(c));
    const unique = exactPk || cs.some(c => c.constraints.includes('Unique'));
    const optional = cs.some(c => c.constraints.includes('Nullable'));
    const identifying = cs.every(c => c.constraints.includes('Primary'));
    lines.push(`  %% ${f.source}: ${f.table}(${f.columns.join(',')}) -> ${f.target}(${f.targetColumns.join(',')})`);
    lines.push(`  ${f.target} ${optional ? '|o' : '||'}${identifying ? '--' : '..'}${unique ? 'o|' : 'o{'} ${f.table} : "${f.columns.join('+')}"`);
    count++;
  }
  fs.writeFileSync(path.join(out, `modelo-fisico-${name}.mmd`), lines.join('\n') + '\n');
  stats.push({ view: name, tables: selected.size, columns: view.tables.reduce((n, t) => n + tables.get(t).columns.length, 0), relationships: count });
}
console.log(JSON.stringify({ tables: tables.size, columns: [...tables.values()].reduce((n, t) => n + t.columns.length, 0), simpleRelationships: relationships.length - composites.length, compositeRelationshipsFromSql: composites.length, views: stats }, null, 2));
