-- PA-F01: inventario de catálogo, sin leer filas del dominio ni ejecutar RPC.
-- Ejecutar en el entorno que se pretende comprobar y conservar sus resultados.
-- No es una migración. No altera tablas, permisos, funciones ni Storage.
BEGIN TRANSACTION READ ONLY;

SELECT current_database() AS base, current_user AS rol_consulta,
       current_setting('TimeZone') AS zona_horaria, current_timestamp AS revisado_en;

-- Tablas esperadas y propuestas: ausente no implica fallo del inventario.
WITH esperadas(nombre) AS (VALUES
  ('usuario'), ('campania'), ('campania_organizacion'), ('campania_estado'),
  ('subcampania'), ('subcampania_equipo'), ('subcampania_meta_especie'),
  ('subcampania_historial'), ('registro_plantacion'),
  ('registro_plantacion_detalle'), ('registro_plantacion_coresponsable'),
  ('asignacion_vivero_subcampania'), ('evento_plantacion'),
  ('evidencias_trazabilidad'), ('tipos_entidad_evidencia'),
  ('subcampania_permiso'), ('plantacion_intento'),
  ('registro_plantacion_correccion')
)
SELECT nombre, to_regclass('public.' || nombre) IS NOT NULL AS existe
FROM esperadas ORDER BY nombre;

-- format_type conserva precisión, enums, geometría y arrays.
SELECT c.relname AS relacion, a.attnum AS orden, a.attname AS columna,
       format_type(a.atttypid, a.atttypmod) AS tipo,
       NOT a.attnotnull AS admite_null, a.attidentity AS identidad,
       a.attgenerated AS generada,
       pg_get_expr(d.adbin, d.adrelid) AS valor_por_defecto_o_expresion
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_attribute a ON a.attrelid = c.oid
LEFT JOIN pg_attrdef d ON d.adrelid = c.oid AND d.adnum = a.attnum
WHERE n.nspname = 'public' AND a.attnum > 0 AND NOT a.attisdropped
  AND c.relname IN (
    'usuario','campania','campania_organizacion','campania_estado',
    'subcampania','subcampania_equipo','subcampania_meta_especie',
    'subcampania_historial','registro_plantacion','registro_plantacion_detalle',
    'registro_plantacion_coresponsable','asignacion_vivero_subcampania',
    'evento_plantacion','evidencias_trazabilidad','tipos_entidad_evidencia',
    'subcampania_permiso','plantacion_intento','registro_plantacion_correccion'
  )
ORDER BY c.relname, a.attnum;

SELECT t.typname AS tipo_enum, e.enumlabel AS valor, e.enumsortorder AS orden
FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace
JOIN pg_enum e ON e.enumtypid = t.oid
WHERE n.nspname = 'public'
ORDER BY t.typname, e.enumsortorder;

SELECT c.relname AS tabla, con.conname AS restriccion, con.contype AS clase,
       con.convalidated AS validada, pg_get_constraintdef(con.oid) AS definicion
FROM pg_constraint con JOIN pg_class c ON c.oid = con.conrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public' AND c.relname IN (
  'subcampania','subcampania_equipo','subcampania_meta_especie',
  'subcampania_historial','registro_plantacion','registro_plantacion_detalle',
  'registro_plantacion_coresponsable','asignacion_vivero_subcampania',
  'evento_plantacion','evidencias_trazabilidad','subcampania_permiso',
  'plantacion_intento','registro_plantacion_correccion'
)
ORDER BY c.relname, con.conname;

SELECT tablename, indexname, indexdef
FROM pg_indexes WHERE schemaname = 'public' AND tablename IN (
  'subcampania','subcampania_equipo','registro_plantacion',
  'registro_plantacion_detalle','registro_plantacion_coresponsable',
  'evidencias_trazabilidad','subcampania_permiso','plantacion_intento'
)
ORDER BY tablename, indexname;

-- RLS y ACL de relaciones (NULL ACL exige considerar privilegios por defecto).
SELECT n.nspname AS esquema, c.relname, c.relrowsecurity AS rls,
       c.relforcerowsecurity AS rls_forzada, c.relacl::text AS acl
FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname IN ('public','storage') AND c.relname IN (
  'usuario','subcampania','subcampania_equipo','registro_plantacion',
  'registro_plantacion_detalle','registro_plantacion_coresponsable',
  'evidencias_trazabilidad','subcampania_permiso','plantacion_intento',
  'objects','buckets'
)
ORDER BY n.nspname, c.relname;

SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies WHERE schemaname IN ('public','storage')
  AND tablename IN ('usuario','subcampania','subcampania_equipo',
    'registro_plantacion','evidencias_trazabilidad','subcampania_permiso',
    'plantacion_intento','objects','buckets')
ORDER BY schemaname, tablename, policyname;

-- Firma/grants: no devuelve cuerpos de funciones ni ejecuta operaciones.
SELECT p.proname, pg_get_function_identity_arguments(p.oid) AS argumentos,
       pg_get_function_result(p.oid) AS retorno, p.prosecdef AS security_definer,
       p.proacl::text AS acl, p.proconfig AS configuracion,
       md5(p.prosrc) AS huella_cuerpo,
       CASE WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon')
         THEN has_function_privilege('anon', p.oid, 'EXECUTE') END AS anon_ejecuta,
       CASE WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated')
         THEN has_function_privilege('authenticated', p.oid, 'EXECUTE') END
         AS authenticated_ejecuta,
       CASE WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role')
         THEN has_function_privilege('service_role', p.oid, 'EXECUTE') END
         AS service_role_ejecuta
FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND (
  p.proname = 'fn_m3_registrar_plantacion'
  OR p.proname ILIKE '%subcampania%plan%'
  OR p.proname ILIKE '%plantacion%intento%'
  OR p.proname ILIKE '%participacion%'
)
ORDER BY p.proname, argumentos;

ROLLBACK;
