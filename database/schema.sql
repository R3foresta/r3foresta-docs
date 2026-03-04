-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.division_administrativa (
  id bigint NOT NULL DEFAULT nextval('division_administrativa_id_seq'::regclass),
  pais_id bigint NOT NULL,
  parent_id bigint,
  tipo_id bigint NOT NULL,
  nombre text NOT NULL,
  codigo_externo text,
  activo boolean NOT NULL DEFAULT true,
  reemplazada_por_id bigint,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone,
  CONSTRAINT division_administrativa_pkey PRIMARY KEY (id),
  CONSTRAINT division_administrativa_pais_id_fkey FOREIGN KEY (pais_id) REFERENCES public.pais(id),
  CONSTRAINT division_administrativa_tipo_id_fkey FOREIGN KEY (tipo_id) REFERENCES public.division_tipo(id),
  CONSTRAINT division_administrativa_reemplazada_por_id_fkey FOREIGN KEY (reemplazada_por_id) REFERENCES public.division_administrativa(id),
  CONSTRAINT division_administrativa_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.division_administrativa(id)
);
CREATE TABLE public.division_tipo (
  id bigint NOT NULL DEFAULT nextval('division_tipo_id_seq'::regclass),
  pais_id bigint NOT NULL,
  nombre text NOT NULL,
  orden integer NOT NULL,
  activo boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT division_tipo_pkey PRIMARY KEY (id),
  CONSTRAINT division_tipo_pais_id_fkey FOREIGN KEY (pais_id) REFERENCES public.pais(id)
);
CREATE TABLE public.evidencias_trazabilidad (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  tipo_entidad_id smallint NOT NULL,
  entidad_id bigint NOT NULL,
  codigo_trazabilidad text,
  bucket text NOT NULL DEFAULT 'trazabilidad'::text,
  ruta_archivo text NOT NULL,
  storage_object_id uuid,
  tipo_archivo text NOT NULL DEFAULT 'FOTO'::text,
  mime_type text NOT NULL,
  tamano_bytes bigint CHECK (tamano_bytes IS NULL OR tamano_bytes > 0),
  hash_sha256 text,
  titulo text,
  descripcion text,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  es_principal boolean NOT NULL DEFAULT false,
  orden integer NOT NULL DEFAULT 0 CHECK (orden >= 0),
  tomado_en timestamp with time zone,
  creado_en timestamp with time zone NOT NULL DEFAULT now(),
  actualizado_en timestamp with time zone NOT NULL DEFAULT now(),
  eliminado_en timestamp with time zone,
  creado_por_usuario_id bigint NOT NULL,
  actualizado_por_usuario_id bigint,
  eliminado_por_usuario_id bigint,
  CONSTRAINT evidencias_trazabilidad_pkey PRIMARY KEY (id),
  CONSTRAINT evidencias_trazabilidad_tipo_entidad_id_fkey FOREIGN KEY (tipo_entidad_id) REFERENCES public.tipos_entidad_evidencia(id),
  CONSTRAINT evidencias_trazabilidad_creado_por_usuario_id_fkey FOREIGN KEY (creado_por_usuario_id) REFERENCES public.usuario(id),
  CONSTRAINT evidencias_trazabilidad_actualizado_por_usuario_id_fkey FOREIGN KEY (actualizado_por_usuario_id) REFERENCES public.usuario(id),
  CONSTRAINT evidencias_trazabilidad_eliminado_por_usuario_id_fkey FOREIGN KEY (eliminado_por_usuario_id) REFERENCES public.usuario(id)
);
CREATE TABLE public.lote_fase_vivero (
  id bigint NOT NULL DEFAULT nextval('lote_plantacion_id_seq'::regclass),
  planta_id bigint NOT NULL,
  vivero_id bigint NOT NULL,
  responsable_id bigint NOT NULL,
  fecha_inicio date NOT NULL,
  cantidad_inicio integer NOT NULL,
  cantidad_embolsadas integer NOT NULL DEFAULT 0,
  cantidad_sombra integer NOT NULL DEFAULT 0,
  cantidad_lista_plantar integer NOT NULL DEFAULT 0,
  fecha_embolsado date,
  fecha_sombra date,
  fecha_salida date,
  altura_prom_sombra numeric,
  altura_prom_salida numeric,
  estado USER-DEFINED NOT NULL DEFAULT 'INICIO'::lote_estado,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone,
  updated_by bigint,
  codigo_trazabilidad text NOT NULL UNIQUE,
  CONSTRAINT lote_fase_vivero_pkey PRIMARY KEY (id),
  CONSTRAINT lote_plantacion_vivero_id_fkey FOREIGN KEY (vivero_id) REFERENCES public.vivero(id),
  CONSTRAINT lote_plantacion_responsable_id_fkey FOREIGN KEY (responsable_id) REFERENCES public.usuario(id),
  CONSTRAINT lote_plantacion_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.usuario(id),
  CONSTRAINT lote_plantacion_planta_id_fkey FOREIGN KEY (planta_id) REFERENCES public.planta(id)
);
CREATE TABLE public.lote_fase_vivero_foto (
  id bigint NOT NULL DEFAULT nextval('lote_fase_vivero_foto_id_seq'::regclass),
  lote_historial_id bigint NOT NULL,
  url text NOT NULL,
  peso_bytes integer,
  formato text,
  es_portada boolean DEFAULT false,
  descripcion text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT lote_fase_vivero_foto_pkey PRIMARY KEY (id),
  CONSTRAINT lote_fase_vivero_foto_lote_historial_id_fkey FOREIGN KEY (lote_historial_id) REFERENCES public.lote_fase_vivero_historial(id)
);
CREATE TABLE public.lote_fase_vivero_historial (
  id bigint NOT NULL DEFAULT nextval('lote_plantacion_historial_id_seq'::regclass),
  lote_id bigint NOT NULL,
  nro_cambio integer NOT NULL,
  fecha_cambio timestamp with time zone NOT NULL DEFAULT now(),
  responsable_id bigint NOT NULL,
  accion USER-DEFINED NOT NULL,
  estado USER-DEFINED NOT NULL,
  cantidad_inicio integer,
  cantidad_embolsadas integer,
  cantidad_sombra integer,
  cantidad_lista_plantar integer,
  fecha_inicio date,
  fecha_embolsado date,
  fecha_sombra date,
  fecha_salida date,
  altura_prom_sombra numeric,
  altura_prom_salida numeric,
  notas text CHECK (notas IS NULL OR length(notas) <= 2000),
  CONSTRAINT lote_fase_vivero_historial_pkey PRIMARY KEY (id),
  CONSTRAINT lote_plantacion_historial_lote_id_fkey FOREIGN KEY (lote_id) REFERENCES public.lote_fase_vivero(id),
  CONSTRAINT lote_plantacion_historial_responsable_id_fkey FOREIGN KEY (responsable_id) REFERENCES public.usuario(id)
);
CREATE TABLE public.lote_fase_vivero_recoleccion (
  lote_id bigint NOT NULL,
  recoleccion_id bigint NOT NULL,
  CONSTRAINT lote_fase_vivero_recoleccion_pkey PRIMARY KEY (lote_id, recoleccion_id),
  CONSTRAINT lote_plantacion_recoleccion_lote_id_fkey FOREIGN KEY (lote_id) REFERENCES public.lote_fase_vivero(id),
  CONSTRAINT lote_plantacion_recoleccion_recoleccion_id_fkey FOREIGN KEY (recoleccion_id) REFERENCES public.recoleccion(id)
);
CREATE TABLE public.metodo_recoleccion (
  id bigint NOT NULL DEFAULT nextval('metodo_recoleccion_id_seq'::regclass),
  nombre USER-DEFINED NOT NULL UNIQUE,
  descripcion text,
  CONSTRAINT metodo_recoleccion_pkey PRIMARY KEY (id)
);
CREATE TABLE public.pais (
  id bigint NOT NULL DEFAULT nextval('pais_id_seq'::regclass),
  nombre text NOT NULL,
  codigo_iso2 character NOT NULL UNIQUE,
  codigo_iso3 character,
  activo boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT pais_pkey PRIMARY KEY (id)
);
CREATE TABLE public.planta (
  id bigint NOT NULL DEFAULT nextval('planta_id_seq'::regclass),
  especie text NOT NULL,
  nombre_cientifico text NOT NULL,
  variedad text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  nombre_comun_principal text,
  nombres_comunes text,
  imagen_url text,
  notas text,
  tipo_planta_id integer NOT NULL,
  CONSTRAINT planta_pkey PRIMARY KEY (id),
  CONSTRAINT fk_planta_tipo_planta FOREIGN KEY (tipo_planta_id) REFERENCES public.tipo_planta(id)
);
CREATE TABLE public.plantacion (
  id bigint NOT NULL DEFAULT nextval('plantacion_id_seq'::regclass),
  codigo_trazabilidad text NOT NULL UNIQUE,
  destino text NOT NULL CHECK (destino = ANY (ARRAY['ARBORIZACION'::text, 'FORESTACION'::text, 'REFORESTACION'::text])),
  ubicacion_id integer NOT NULL,
  cantidad_arboles integer NOT NULL CHECK (cantidad_arboles > 0),
  fecha_plantacion date NOT NULL,
  superficie_m2 numeric,
  tamano_promedio_cm numeric,
  propietario text,
  origen_propiedad text CHECK (origen_propiedad IS NULL OR (origen_propiedad = ANY (ARRAY['DONADO'::text, 'ADQUIRIDO'::text, 'OTRO'::text]))),
  frecuencia_monitoreo_dias integer,
  created_by integer,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT plantacion_pkey PRIMARY KEY (id),
  CONSTRAINT plantacion_ubicacion_id_fkey FOREIGN KEY (ubicacion_id) REFERENCES public.ubicacion(id),
  CONSTRAINT plantacion_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.usuario(id)
);
CREATE TABLE public.plantacion_abono (
  plantacion_id bigint NOT NULL,
  tipo_abono_id integer NOT NULL,
  CONSTRAINT plantacion_abono_pkey PRIMARY KEY (plantacion_id, tipo_abono_id),
  CONSTRAINT plantacion_abono_plantacion_id_fkey FOREIGN KEY (plantacion_id) REFERENCES public.plantacion(id),
  CONSTRAINT plantacion_abono_tipo_abono_id_fkey FOREIGN KEY (tipo_abono_id) REFERENCES public.tipo_abono(id)
);
CREATE TABLE public.plantacion_foto (
  id bigint NOT NULL DEFAULT nextval('plantacion_foto_id_seq'::regclass),
  plantacion_id bigint NOT NULL,
  url text NOT NULL,
  peso_bytes integer,
  formato text,
  descripcion text,
  CONSTRAINT plantacion_foto_pkey PRIMARY KEY (id),
  CONSTRAINT plantacion_foto_plantacion_id_fkey FOREIGN KEY (plantacion_id) REFERENCES public.plantacion(id)
);
CREATE TABLE public.plantacion_lote_fase_vivero (
  plantacion_id bigint NOT NULL,
  lote_fase_vivero_id integer NOT NULL,
  cantidad_plantines_usados integer NOT NULL CHECK (cantidad_plantines_usados > 0),
  CONSTRAINT plantacion_lote_fase_vivero_pkey PRIMARY KEY (plantacion_id, lote_fase_vivero_id),
  CONSTRAINT plantacion_lote_fase_vivero_plantacion_id_fkey FOREIGN KEY (plantacion_id) REFERENCES public.plantacion(id),
  CONSTRAINT plantacion_lote_fase_vivero_lote_fase_vivero_id_fkey FOREIGN KEY (lote_fase_vivero_id) REFERENCES public.lote_fase_vivero(id)
);
CREATE TABLE public.plantacion_monitoreo (
  id bigint NOT NULL DEFAULT nextval('plantacion_monitoreo_id_seq'::regclass),
  plantacion_id bigint NOT NULL,
  fecha_monitoreo date NOT NULL,
  arboles_vivos integer,
  arboles_muertos integer,
  arboles_reemplazados integer,
  notas text,
  usuario_id integer,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT plantacion_monitoreo_pkey PRIMARY KEY (id),
  CONSTRAINT plantacion_monitoreo_plantacion_id_fkey FOREIGN KEY (plantacion_id) REFERENCES public.plantacion(id),
  CONSTRAINT plantacion_monitoreo_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id)
);
CREATE TABLE public.plantacion_riego (
  plantacion_id bigint NOT NULL,
  tipo_riego_id integer NOT NULL,
  CONSTRAINT plantacion_riego_pkey PRIMARY KEY (plantacion_id, tipo_riego_id),
  CONSTRAINT plantacion_riego_plantacion_id_fkey FOREIGN KEY (plantacion_id) REFERENCES public.plantacion(id),
  CONSTRAINT plantacion_riego_tipo_riego_id_fkey FOREIGN KEY (tipo_riego_id) REFERENCES public.tipo_riego(id)
);
CREATE TABLE public.plantacion_usuario (
  plantacion_id bigint NOT NULL,
  usuario_id integer NOT NULL,
  rol text,
  CONSTRAINT plantacion_usuario_pkey PRIMARY KEY (plantacion_id, usuario_id),
  CONSTRAINT plantacion_usuario_plantacion_id_fkey FOREIGN KEY (plantacion_id) REFERENCES public.plantacion(id),
  CONSTRAINT plantacion_usuario_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id)
);
CREATE TABLE public.recoleccion (
  id bigint NOT NULL DEFAULT nextval('recoleccion_id_seq'::regclass),
  fecha date NOT NULL CHECK (fecha >= (CURRENT_DATE - 45) AND fecha <= CURRENT_DATE),
  nombre_cientifico text,
  nombre_comercial text,
  cantidad numeric NOT NULL CHECK (cantidad > 0::numeric),
  unidad text NOT NULL,
  tipo_material USER-DEFINED NOT NULL,
  estado USER-DEFINED NOT NULL DEFAULT 'ALMACENADO'::estado_recoleccion,
  especie_nueva boolean NOT NULL DEFAULT false,
  observaciones text CHECK (observaciones IS NULL OR length(observaciones) <= 1000),
  usuario_id bigint NOT NULL,
  ubicacion_id bigint NOT NULL,
  vivero_id bigint,
  metodo_id bigint NOT NULL,
  planta_id bigint,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  codigo_trazabilidad text NOT NULL UNIQUE,
  blockchain_url text,
  token_id text,
  transaction_hash text,
  estado_registro USER-DEFINED NOT NULL DEFAULT 'BORRADOR'::estado_registro_recoleccion,
  unidad_canonica text NOT NULL CHECK (unidad_canonica IS NULL OR (unidad_canonica = ANY (ARRAY['G'::text, 'UNIDAD'::text]))),
  cantidad_inicial_canonica numeric NOT NULL,
  usuario_validacion_id bigint,
  fecha_validacion timestamp with time zone,
  blockchain_hash_validacion text,
  CONSTRAINT recoleccion_pkey PRIMARY KEY (id),
  CONSTRAINT recoleccion_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id),
  CONSTRAINT recoleccion_ubicacion_id_fkey FOREIGN KEY (ubicacion_id) REFERENCES public.ubicacion(id),
  CONSTRAINT recoleccion_vivero_id_fkey FOREIGN KEY (vivero_id) REFERENCES public.vivero(id),
  CONSTRAINT recoleccion_metodo_id_fkey FOREIGN KEY (metodo_id) REFERENCES public.metodo_recoleccion(id),
  CONSTRAINT recoleccion_planta_id_fkey FOREIGN KEY (planta_id) REFERENCES public.planta(id),
  CONSTRAINT recoleccion_usuario_validacion_id_fkey FOREIGN KEY (usuario_validacion_id) REFERENCES public.usuario(id)
);
CREATE TABLE public.recoleccion_foto (
  id bigint NOT NULL DEFAULT nextval('recoleccion_foto_id_seq'::regclass),
  recoleccion_id bigint NOT NULL,
  url text NOT NULL,
  peso_bytes integer CHECK (peso_bytes IS NULL OR peso_bytes <= 5242880),
  formato text CHECK (formato IS NULL OR (upper(formato) = ANY (ARRAY['JPG'::text, 'JPEG'::text, 'PNG'::text]))),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT recoleccion_foto_pkey PRIMARY KEY (id),
  CONSTRAINT recoleccion_foto_recoleccion_id_fkey FOREIGN KEY (recoleccion_id) REFERENCES public.recoleccion(id)
);
CREATE TABLE public.recoleccion_movimiento (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  recoleccion_id bigint NOT NULL,
  tipo_movimiento USER-DEFINED NOT NULL,
  delta numeric NOT NULL CHECK (delta <> 0::numeric),
  unidad_operativa text NOT NULL CHECK (unidad_operativa = ANY (ARRAY['G'::text, 'UNIDAD'::text])),
  motivo USER-DEFINED,
  motivo_otro text,
  lote_vivero_id bigint,
  detalle_cambios jsonb,
  created_by bigint NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  blockchain_tx_hash text,
  CONSTRAINT recoleccion_movimiento_pkey PRIMARY KEY (id),
  CONSTRAINT recoleccion_movimiento_recoleccion_id_fkey FOREIGN KEY (recoleccion_id) REFERENCES public.recoleccion(id),
  CONSTRAINT recoleccion_movimiento_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.usuario(id)
);
CREATE TABLE public.tipo_abono (
  id integer NOT NULL DEFAULT nextval('tipo_abono_id_seq'::regclass),
  nombre text NOT NULL UNIQUE,
  descripcion text,
  CONSTRAINT tipo_abono_pkey PRIMARY KEY (id)
);
CREATE TABLE public.tipo_planta (
  id integer NOT NULL DEFAULT nextval('tipo_planta_id_seq'::regclass),
  nombre text NOT NULL UNIQUE,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT tipo_planta_pkey PRIMARY KEY (id)
);
CREATE TABLE public.tipo_riego (
  id integer NOT NULL DEFAULT nextval('tipo_riego_id_seq'::regclass),
  nombre text NOT NULL UNIQUE,
  descripcion text,
  CONSTRAINT tipo_riego_pkey PRIMARY KEY (id)
);
CREATE TABLE public.tipos_entidad_evidencia (
  id smallint GENERATED ALWAYS AS IDENTITY NOT NULL,
  codigo text NOT NULL UNIQUE,
  descripcion text,
  activo boolean NOT NULL DEFAULT true,
  creado_en timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT tipos_entidad_evidencia_pkey PRIMARY KEY (id)
);
CREATE TABLE public.ubicacion (
  id bigint NOT NULL DEFAULT nextval('ubicacion_id_seq'::regclass),
  latitud numeric CHECK (latitud >= '-90'::integer::numeric AND latitud <= 90::numeric),
  longitud numeric CHECK (longitud >= '-180'::integer::numeric AND longitud <= 180::numeric),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  pais_id bigint,
  division_id bigint,
  nombre text,
  precision_m integer CHECK (precision_m IS NULL OR precision_m > 0),
  fuente text CHECK (fuente IS NULL OR (fuente = ANY (ARRAY['GPS_MOVIL'::text, 'MAPA'::text, 'MANUAL'::text, 'LEGACY'::text]))),
  referencia text,
  updated_at timestamp with time zone,
  CONSTRAINT ubicacion_pkey PRIMARY KEY (id),
  CONSTRAINT ubicacion_pais_id_fkey FOREIGN KEY (pais_id) REFERENCES public.pais(id),
  CONSTRAINT ubicacion_division_id_fkey FOREIGN KEY (division_id) REFERENCES public.division_administrativa(id)
);
CREATE TABLE public.usuario (
  id bigint NOT NULL DEFAULT nextval('usuario_id_seq'::regclass),
  nombre text NOT NULL,
  doc_identidad text UNIQUE,
  wallet_address text UNIQUE CHECK (wallet_address IS NULL OR wallet_address ~ '^0x[0-9a-fA-F]{40}$'::text),
  organizacion text,
  contacto text CHECK (contacto IS NULL OR contacto ~ '^\+\d{7,15}$'::text),
  rol USER-DEFINED NOT NULL DEFAULT 'GENERAL'::rol_usuario,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  username text DEFAULT ''::text UNIQUE,
  auth_id text DEFAULT ''::text,
  correo text DEFAULT ''::text UNIQUE,
  apellido text CHECK (length(apellido) <= 30),
  foto_perfil_url text,
  CONSTRAINT usuario_pkey PRIMARY KEY (id)
);
CREATE TABLE public.usuario_credencial (
  id bigint NOT NULL DEFAULT nextval('usuario_credencial_id_seq'::regclass),
  usuario_id bigint NOT NULL,
  credential_id text NOT NULL UNIQUE,
  public_key text NOT NULL,
  algorithm text NOT NULL DEFAULT 'ES256'::text,
  counter integer NOT NULL DEFAULT 0,
  transports ARRAY,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  last_used_at timestamp with time zone,
  CONSTRAINT usuario_credencial_pkey PRIMARY KEY (id),
  CONSTRAINT usuario_credencial_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id)
);
CREATE TABLE public.vivero (
  id bigint NOT NULL DEFAULT nextval('vivero_id_seq'::regclass),
  codigo text NOT NULL UNIQUE,
  nombre USER-DEFINED NOT NULL,
  ubicacion_id bigint NOT NULL UNIQUE,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT vivero_pkey PRIMARY KEY (id),
  CONSTRAINT vivero_ubicacion_id_fkey FOREIGN KEY (ubicacion_id) REFERENCES public.ubicacion(id)
);

-- =========================
-- ENUM: rol_usuario
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'rol_usuario' AND n.nspname = 'public'
  ) THEN
    CREATE TYPE public.rol_usuario AS ENUM (
      'RECOLECTOR',
      'VIVERO',
      'VOLUNTARIO',
      'GENERAL'
    );
  END IF;
END $$;

COMMENT ON TYPE public.rol_usuario IS 'Roles de usuario en el sistema.';

-- =========================
-- ENUM: tipo_material_origen // ESTACA se eliminara en el futuro porque no hay registros. Se mantiene para no romper el frontend.
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'tipo_material_origen' AND n.nspname = 'public'
  ) THEN
    CREATE TYPE public.tipo_material_origen AS ENUM (
      'SEMILLA',
      'ESQUEJE',
      'ESTACA'
    );
  END IF;
END $$;

COMMENT ON TYPE public.tipo_material_origen IS 'Tipo de material de origen para la recolección.';

-- =========================
-- ENUM: estado_recoleccion // esto se queda para legacy pero ya no se usa en las recolecciones nuevas.
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'estado_recoleccion' AND n.nspname = 'public'
  ) THEN
    CREATE TYPE public.estado_recoleccion AS ENUM (
      'USADO',
      'ALMACENADO',
      'DESECHADO'
    );
  END IF;
END $$;

COMMENT ON TYPE public.estado_recoleccion IS 'Estado del material recolectado.';

-- =========================
-- ENUM: lote_estado
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'lote_estado' AND n.nspname = 'public'
  ) THEN
    CREATE TYPE public.lote_estado AS ENUM (
      'INICIO',
      'EMBOLSADO',
      'SOMBRA',
      'LISTA_PLANTAR',
      'SALIDA_VIVERO'
    );
  END IF;
END $$;

COMMENT ON TYPE public.lote_estado IS 'Estados del lote en el flujo de vivero.';

-- =========================
-- ENUM: lote_accion
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'lote_accion' AND n.nspname = 'public'
  ) THEN
    CREATE TYPE public.lote_accion AS ENUM (
      'INICIO',
      'EMBOLSADO',
      'SOMBRA',
      'LISTA_PLANTAR',
      'SALIDA_VIVERO',
      'AJUSTE'
    );
  END IF;
END $$;

COMMENT ON TYPE public.lote_accion IS 'Acciones/eventos aplicables al lote.';

-- =========================
-- ENUM: estado_registro_recoleccion
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'estado_registro_recoleccion' AND n.nspname = 'public'
  ) THEN
    CREATE TYPE public.estado_registro_recoleccion AS ENUM (
      'BORRADOR',
      'VALIDADO'
    );
  END IF;
END $$;

COMMENT ON TYPE public.estado_registro_recoleccion IS 'Estado del registro (draft vs validado).';

-- =========================
-- ENUM: tipo_movimiento_recoleccion
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'tipo_movimiento_recoleccion' AND n.nspname = 'public'
  ) THEN
    CREATE TYPE public.tipo_movimiento_recoleccion AS ENUM (
      'CONSUMO_A_VIVERO',
      'DESECHO',
      'CORRECCION',
      'AJUSTE_MIGRACION'
    );
  END IF;
END $$;

COMMENT ON TYPE public.tipo_movimiento_recoleccion IS 'Tipo de movimiento aplicado a una recolección.';

-- =========================
-- ENUM: motivo_movimiento_recoleccion
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'motivo_movimiento_recoleccion' AND n.nspname = 'public'
  ) THEN
    CREATE TYPE public.motivo_movimiento_recoleccion AS ENUM (
      'CONSUMO_PARA_VIVERO',
      'DESECHO_MALA_CALIDAD',
      'DESECHO_PLAGA',
      'DESECHO_HONGO',
      'DESECHO_PUDRICION',
      'DESECHO_DANO_TRANSPORTE',
      'DESECHO_DANO_MANIPULACION',
      'DESECHO_CONTAMINACION',
      'DESECHO_CADUCIDAD',
      'DESECHO_OTRO',
      'CORRECCION_CONTEO_FISICO',
      'CORRECCION_ERROR_DIGITACION',
      'CORRECCION_CAMBIO_UNIDAD',
      'CORRECCION_OTRO',
      'AJUSTE_MIGRACION',
      'AJUSTE_INTEGRIDAD_DATOS',
      'AJUSTE_REVERSA_OPERACION',
      'AJUSTE_OTRO',
      'OTRO'
    );
  END IF;
END $$;

COMMENT ON TYPE public.motivo_movimiento_recoleccion IS 'Motivo específico del movimiento en recolección.';