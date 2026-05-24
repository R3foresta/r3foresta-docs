# Tarea 11 — Modelar tablas base de M3 en BD

**Área:** Base de datos
**Severidad:** Crítica
**Depende de:** [tarea 10](./10_docs_flujo_reposicion_y_mortandad.md) (decisiones cerradas en docs)
**Bloquea a:** [tarea 03](./03_backend_despacho_automatico_atomico.md) (despacho automático)
**Referencias:** [02_Procesos_Modulo_3_Plantacion.md](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md), tarea 10

---

## 0. Origen de esta tarea

Esta tarea es **la consecuencia directa** de las preguntas M1–M6 del backend al intentar implementar la tarea 03. El handler atómico de despacho necesita FKs hacia `subcampania_id`, `campania_id` y `registro_plantacion_id` reales. Esas tablas no existen hoy. Esta tarea las crea.

La tarea 10 cerró las decisiones de diseño en documentación; esta tarea las materializa en BD. **Tarea 10 debe estar aplicada antes** (CLAUDE.md actualizado, invariantes nuevos vigentes, doc M3 sin mix de especies, etc.).

Mapa de tablas vs preguntas del backend:

| Backend preguntó | Esta tarea entrega |
|------------------|--------------------|
| M1. Campos de CAMPANIA | Tabla `CAMPANIA` + tabla puente `CAMPANIA_ORGANIZACION` + vista `campania_estado` derivada |
| M2. zona_id FK | `subcampania.zona_id bigint not null references division_administrativa(id)` |
| M3. REGISTRO_PLANTACION + DETALLE | Tabla principal + `REGISTRO_PLANTACION_DETALLE` + `REGISTRO_PLANTACION_CORESPONSABLE` + `EVENTO_PLANTACION` |
| M4. PostGIS | `create extension postgis` + `poligono_geom geometry` + función `gps_dentro_poligono_con_tolerancia` |
| M5. Mix de especies | **Nada** — fuera de MVP por decisión cerrada |
| M6. Rol COORDINADOR | `SUBCAMPANIA_EQUIPO` con `rol_en_subcampania ENUM(COORDINADOR | OPERARIO)` y unique index parcial |

---

## 1. Alcance

Esta tarea es grande. Si el implementador lo prefiere, puede aplicarla en fases (cada `### 2.X` es una migración separada y autocontenida), pero la spec vive aquí completa.

**Tablas a crear:**

- `CAMPANIA`
- `CAMPANIA_ORGANIZACION` (puente N:M con `ORGANIZACION`)
- `SUBCAMPANIA`
- `SUBCAMPANIA_EQUIPO`
- `REGISTRO_PLANTACION`
- `REGISTRO_PLANTACION_DETALLE`
- `REGISTRO_PLANTACION_CORESPONSABLE`
- `EVENTO_PLANTACION` (unificada para mortandad, devolución y registro de asignación)

**Vistas/funciones:**

- Vista `campania_estado` (estado derivado).
- Función `gps_dentro_poligono_con_tolerancia(subcampania_id, lat, lng)`.

**Enums nuevos:**

- `tipo_subcampania`
- `estado_subcampania`
- `fase_mantenimiento_subcampania`
- `motivo_cierre_parcial`
- `rol_en_subcampania`
- `causa_mortandad_plantacion`
- `motivo_devolucion_plantacion`
- `tipo_evento_plantacion`

**Extensión:** `postgis`.

**Fuera de alcance** (van a tareas posteriores):

- Triggers para mantener `total_plantado_inicial`, `total_repuesto`, `total_muerto_acumulado`, `cantidad_muerta_acumulada`, `cantidad_repuesta_acumulada` (tarea 12 propuesta).
- `CAMPANIA_HISTORIAL` y `SUBCAMPANIA_HISTORIAL` (eventos de ciclo de vida — tarea posterior).
- Job nocturno de transición `MANTENIMIENTO_ACTIVO → MONITOREO_HISTORICO`.

---

## 2. Cambio requerido

### 2.1. Habilitar PostGIS

```sql
create extension if not exists postgis;
```

> **Validar en Supabase**: la extensión `postgis` está disponible pero puede requerir habilitación desde el dashboard.

### 2.2. Enums nuevos

```sql
do $$ begin
  if not exists (select 1 from pg_type where typname = 'tipo_subcampania') then
    create type tipo_subcampania as enum ('REFORESTACION', 'ARBORIZACION', 'FORESTACION');
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_type where typname = 'estado_subcampania') then
    create type estado_subcampania as enum (
      'BORRADOR', 'ACTIVA', 'COMPLETADA', 'FINALIZADA_PARCIAL',
      'PAUSADA',     -- reservado, sin flujo en MVP
      'CANCELADA'    -- reservado, sin flujo en MVP
    );
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_type where typname = 'fase_mantenimiento_subcampania') then
    create type fase_mantenimiento_subcampania as enum (
      'NO_APLICA', 'MANTENIMIENTO_ACTIVO', 'MONITOREO_HISTORICO'
    );
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_type where typname = 'motivo_cierre_parcial') then
    create type motivo_cierre_parcial as enum (
      'FALTA_STOCK',
      'PROBLEMAS_CLIMATICOS',
      'CANCELACION_CONVENIO',
      'CONFLICTO_SOCIAL',
      'ACCESO_RESTRINGIDO',
      'CAMBIO_PRIORIDAD_INSTITUCIONAL',
      'RIESGO_OPERATIVO',
      'META_REDEFINIDA',
      'CIERRE_ADMINISTRATIVO',
      'OTRO'
    );
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_type where typname = 'rol_en_subcampania') then
    create type rol_en_subcampania as enum ('COORDINADOR', 'OPERARIO');
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_type where typname = 'causa_mortandad_plantacion') then
    create type causa_mortandad_plantacion as enum (
      'SEQUIA', 'EXCESO_AGUA', 'HELADA', 'GRANIZO', 'PLAGA', 'ENFERMEDAD',
      'SUELO_INADECUADO', 'FALTA_MANTENIMIENTO', 'DANO_MECANICO', 'PASTOREO',
      'VANDALISMO', 'INCENDIO', 'COMPETENCIA_MALEZA', 'TRASPLANTE_DEFICIENTE',
      'DESCONOCIDA', 'OTRO'
    );
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_type where typname = 'motivo_devolucion_plantacion') then
    create type motivo_devolucion_plantacion as enum (
      'SOBRANTE_OPERATIVO', 'ERROR_PLANIFICACION', 'CAMBIO_SUBCAMPANIA',
      'CIERRE_SUBCAMPANIA', 'PROBLEMAS_CALIDAD_LOTE', 'CONDICIONES_CAMPO_NO_APTAS',
      'ACCESO_RESTRINGIDO', 'CANCELACION_ACTIVIDAD', 'REASIGNACION_PRIORIDAD', 'OTRO'
    );
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_type where typname = 'tipo_evento_plantacion') then
    create type tipo_evento_plantacion as enum (
      'ASIGNACION_VIVERO',
      'DEVOLUCION_A_VIVERO',
      'MORTANDAD_REPORTADA'
    );
  end if;
end $$;
```

> **Nota sobre `tipo_evento_plantacion`**: `PLANTACION_INICIAL` y `REPOSICION` **no van** en `EVENTO_PLANTACION`. Esos viven directamente como filas en `REGISTRO_PLANTACION` con `es_reposicion = false | true`. La tabla `EVENTO_PLANTACION` captura solo los eventos auxiliares (mortandad, devolución, registro de asignación).

### 2.3. CAMPANIA + CAMPANIA_ORGANIZACION

```sql
create table if not exists campania (
  id                    bigserial primary key,
  nombre                text not null unique,
  descripcion           text,
  fecha_estimada_inicio date,
  fecha_estimada_fin    date,
  codigo_trazabilidad   text not null unique,
  -- Formato sugerido: 'CMP-YYYY-NNN'
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),
  created_by            bigint not null,
  updated_by            bigint not null,
  deleted_at            timestamptz,
  deleted_by            bigint,
  metadata_blockchain   jsonb,

  constraint campania_created_by_fk foreign key (created_by) references usuario(id),
  constraint campania_updated_by_fk foreign key (updated_by) references usuario(id),
  constraint campania_deleted_by_fk foreign key (deleted_by) references usuario(id)
);

comment on table campania is
  'Contenedor estratégico de subcampañas. No persiste estado: el estado es derivado vía vista campania_estado.';

create table if not exists campania_organizacion (
  id              bigserial primary key,
  campania_id     bigint not null,
  organizacion_id bigint not null,
  created_at      timestamptz not null default now(),
  created_by      bigint not null,

  constraint campania_organizacion_campania_fk
    foreign key (campania_id) references campania(id) on delete cascade,
  constraint campania_organizacion_organizacion_fk
    foreign key (organizacion_id) references organizacion(id),
  constraint campania_organizacion_created_by_fk
    foreign key (created_by) references usuario(id),
  constraint campania_organizacion_uq
    unique (campania_id, organizacion_id)
);
```

> **Dependencia**: la tabla `ORGANIZACION` debe existir (módulo General). Si no existe todavía, crearla primero como tabla maestra (`id`, `nombre`, `activo`, `created_at`, etc.) o ajustar el FK.

### 2.4. SUBCAMPANIA + SUBCAMPANIA_EQUIPO

```sql
create table if not exists subcampania (
  id                          bigserial primary key,
  campania_id                 bigint not null,
  nombre                      text not null,
  descripcion                 text,
  tipo                        tipo_subcampania not null,
  estado                      estado_subcampania not null default 'BORRADOR',
  fase_mantenimiento          fase_mantenimiento_subcampania not null default 'NO_APLICA',
  zona_id                     bigint not null,
  poligono_geom               geometry(Polygon, 4326),
  area_hectareas              numeric(12,4),
  meta_total_arboles          int not null check (meta_total_arboles > 0),
  fecha_estimada_inicio       date,
  fecha_estimada_fin          date,
  fecha_cierre_operativo      timestamptz,
  fecha_fin_mantenimiento     date,
  motivo_cierre_parcial       motivo_cierre_parcial,
  observaciones_cierre        text,
  tolerancia_gps_metros       int not null default 50 check (tolerancia_gps_metros > 0),

  nombre_zona_snapshot            text,
  nombre_coordinador_snapshot     text,
  nombres_organizaciones_snapshot text[],

  codigo_trazabilidad         text not null unique,
  -- Formato sugerido: 'SUB-NNN-CMP-YYYY-NNN'

  -- Contadores materializados (mantenidos por trigger en tarea posterior)
  total_plantado_inicial      int not null default 0,
  total_repuesto              int not null default 0,
  total_muerto_acumulado      int not null default 0,
  saldo_vivo_actual           int generated always as (
    total_plantado_inicial + total_repuesto - total_muerto_acumulado
  ) stored,

  created_at                  timestamptz not null default now(),
  updated_at                  timestamptz not null default now(),
  created_by                  bigint not null,
  updated_by                  bigint not null,
  deleted_at                  timestamptz,
  deleted_by                  bigint,
  metadata_blockchain         jsonb,

  constraint subcampania_campania_fk
    foreign key (campania_id) references campania(id),
  constraint subcampania_zona_fk
    foreign key (zona_id) references division_administrativa(id),
  constraint subcampania_created_by_fk
    foreign key (created_by) references usuario(id),
  constraint subcampania_updated_by_fk
    foreign key (updated_by) references usuario(id),
  constraint subcampania_deleted_by_fk
    foreign key (deleted_by) references usuario(id),

  -- Activar requiere polígono
  constraint subcampania_activacion_poligono_chk
    check (estado = 'BORRADOR' or poligono_geom is not null),

  -- Cierre requiere fechas y motivo
  constraint subcampania_cierre_chk
    check (
      (estado not in ('COMPLETADA', 'FINALIZADA_PARCIAL'))
      or (fecha_cierre_operativo is not null and fecha_fin_mantenimiento is not null)
    ),
  constraint subcampania_cierre_parcial_motivo_chk
    check (
      estado <> 'FINALIZADA_PARCIAL'
      or motivo_cierre_parcial is not null
    )
);

comment on column subcampania.poligono_geom is
  'Polígono certificable en WGS84. Obligatorio para activar.';

comment on column subcampania.fase_mantenimiento is
  'Persistida con default NO_APLICA. Se mueve a MANTENIMIENTO_ACTIVO al cerrar y a MONITOREO_HISTORICO 3 años después vía job nocturno.';

create index if not exists subcampania_campania_idx on subcampania(campania_id);
create index if not exists subcampania_zona_idx on subcampania(zona_id);
create index if not exists subcampania_estado_idx on subcampania(estado) where deleted_at is null;
create index if not exists subcampania_poligono_gix on subcampania using gist(poligono_geom);

create table if not exists subcampania_equipo (
  id              bigserial primary key,
  subcampania_id  bigint not null,
  usuario_id      bigint not null,
  rol             rol_en_subcampania not null,
  agregado_at     timestamptz not null default now(),
  agregado_by     bigint not null,

  constraint subcampania_equipo_subcampania_fk
    foreign key (subcampania_id) references subcampania(id) on delete cascade,
  constraint subcampania_equipo_usuario_fk
    foreign key (usuario_id) references usuario(id),
  constraint subcampania_equipo_agregado_by_fk
    foreign key (agregado_by) references usuario(id),
  constraint subcampania_equipo_uq
    unique (subcampania_id, usuario_id)
);

-- Exactamente 1 COORDINADOR por subcampania (constraint cerrada por tarea 10, RN-VIV-equivalente para M3)
create unique index if not exists subcampania_equipo_un_coordinador_idx
  on subcampania_equipo(subcampania_id)
  where rol = 'COORDINADOR';

create index if not exists subcampania_equipo_usuario_idx
  on subcampania_equipo(usuario_id);
```

> **Nota sobre el coordinador**: no hay columna `coordinador_id` en `SUBCAMPANIA`. La identidad del coordinador se obtiene con:
>
> ```sql
> select usuario_id from subcampania_equipo
> where subcampania_id = $1 and rol = 'COORDINADOR';
> ```
>
> El snapshot `nombre_coordinador_snapshot` se congela al activar la subcampaña.

### 2.5. REGISTRO_PLANTACION + DETALLE + CORESPONSABLE

```sql
create table if not exists registro_plantacion (
  id                              bigserial primary key,
  subcampania_id                  bigint not null,
  es_reposicion                   boolean not null default false,
  registro_plantacion_origen_id   bigint,
  fecha_plantacion                date not null,
  responsable_id                  bigint not null,
  latitud                         numeric(9,6) not null check (latitud between -90 and 90),
  longitud                        numeric(9,6) not null check (longitud between -180 and 180),
  gps_dentro_poligono             boolean not null,
  gps_distancia_a_poligono_m      numeric(10,2),

  cantidad_total_plantada         int not null check (cantidad_total_plantada > 0),
  cantidad_muerta_acumulada       int not null default 0 check (cantidad_muerta_acumulada >= 0),
  cantidad_repuesta_acumulada     int not null default 0 check (cantidad_repuesta_acumulada >= 0),
  saldo_vivo_grupo                int generated always as (
    cantidad_total_plantada + cantidad_repuesta_acumulada - cantidad_muerta_acumulada
  ) stored,

  nombre_subcampania_snapshot     text,
  nombre_zona_snapshot            text,
  nombre_responsable_snapshot     text,
  observaciones                   text,
  codigo_trazabilidad             text not null unique,
  -- Formato sugerido: 'PLT-NNN-SUB-NNN'

  created_at                      timestamptz not null default now(),
  created_by                      bigint not null,
  metadata_blockchain             jsonb,

  constraint registro_plantacion_subcampania_fk
    foreign key (subcampania_id) references subcampania(id),
  constraint registro_plantacion_responsable_fk
    foreign key (responsable_id) references usuario(id),
  constraint registro_plantacion_created_by_fk
    foreign key (created_by) references usuario(id),
  constraint registro_plantacion_origen_fk
    foreign key (registro_plantacion_origen_id) references registro_plantacion(id),

  -- Reposición debe referenciar grupo origen; plantación inicial NO
  constraint registro_plantacion_reposicion_origen_chk
    check (
      (es_reposicion = false and registro_plantacion_origen_id is null)
      or
      (es_reposicion = true and registro_plantacion_origen_id is not null)
    ),

  -- Saldo vivo del grupo no negativo (mantenido por triggers, validar también acá)
  constraint registro_plantacion_saldo_no_negativo_chk
    check (cantidad_total_plantada + cantidad_repuesta_acumulada - cantidad_muerta_acumulada >= 0)
);

create index if not exists registro_plantacion_subcampania_idx
  on registro_plantacion(subcampania_id);
create index if not exists registro_plantacion_origen_idx
  on registro_plantacion(registro_plantacion_origen_id)
  where es_reposicion = true;
create index if not exists registro_plantacion_responsable_idx
  on registro_plantacion(responsable_id);

create table if not exists registro_plantacion_detalle (
  id                              bigserial primary key,
  registro_plantacion_id          bigint not null,
  asignacion_id                   bigint not null,
  lote_vivero_id                  bigint not null,
  planta_id                       bigint not null,
  cantidad                        int not null check (cantidad > 0),
  nombre_cientifico_snapshot      text,
  nombre_comercial_snapshot       text,
  variedad_snapshot               text,
  evento_lote_vivero_despacho_id  bigint,
  created_at                      timestamptz not null default now(),

  constraint registro_plantacion_detalle_registro_fk
    foreign key (registro_plantacion_id) references registro_plantacion(id) on delete cascade,
  constraint registro_plantacion_detalle_asignacion_fk
    foreign key (asignacion_id) references asignacion_vivero_subcampania(id),
  constraint registro_plantacion_detalle_lote_fk
    foreign key (lote_vivero_id) references lote_vivero(id),
  constraint registro_plantacion_detalle_planta_fk
    foreign key (planta_id) references planta(id),
  constraint registro_plantacion_detalle_despacho_fk
    foreign key (evento_lote_vivero_despacho_id) references evento_lote_vivero(id),

  constraint registro_plantacion_detalle_uq
    unique (registro_plantacion_id, asignacion_id, planta_id)
);

comment on column registro_plantacion_detalle.lote_vivero_id is
  'Redundante con asignacion.lote_vivero_id; mantenido para queries rápidas. Debe coincidir.';
comment on column registro_plantacion_detalle.evento_lote_vivero_despacho_id is
  'FK al DESPACHO automático generado por tarea 03. NULL solo en intermedio de transacción.';

create index if not exists registro_plantacion_detalle_lote_idx
  on registro_plantacion_detalle(lote_vivero_id);
create index if not exists registro_plantacion_detalle_asignacion_idx
  on registro_plantacion_detalle(asignacion_id);

create table if not exists registro_plantacion_coresponsable (
  id                      bigserial primary key,
  registro_plantacion_id  bigint not null,
  usuario_id              bigint not null,
  created_at              timestamptz not null default now(),

  constraint registro_plantacion_coresponsable_registro_fk
    foreign key (registro_plantacion_id) references registro_plantacion(id) on delete cascade,
  constraint registro_plantacion_coresponsable_usuario_fk
    foreign key (usuario_id) references usuario(id),
  constraint registro_plantacion_coresponsable_uq
    unique (registro_plantacion_id, usuario_id)
);

comment on table registro_plantacion_coresponsable is
  'Co-responsables del registro. Deben ser subset del SUBCAMPANIA_EQUIPO de la subcampaña (validación en handler).';
```

### 2.6. EVENTO_PLANTACION

Tabla unificada para eventos auxiliares: mortandad, devolución y registro de asignación. Sigue el patrón de `EVENTO_LOTE_VIVERO` de M2.

```sql
create table if not exists evento_plantacion (
  id                       bigserial primary key,
  tipo_evento              tipo_evento_plantacion not null,
  subcampania_id           bigint not null,
  registro_plantacion_id   bigint,
  asignacion_id            bigint,

  fecha_evento             timestamptz not null,
  responsable_id           bigint not null,
  observaciones            text,

  -- MORTANDAD_REPORTADA
  cantidad_muerta_delta    int,
  causa_mortandad          causa_mortandad_plantacion,
  latitud                  numeric(9,6),
  longitud                 numeric(9,6),

  -- DEVOLUCION_A_VIVERO
  cantidad_devuelta        int,
  motivo_devolucion        motivo_devolucion_plantacion,

  -- ASIGNACION_VIVERO (registro del evento; la fuente de verdad es ASIGNACION_VIVERO_SUBCAMPANIA)
  cantidad_asignada_evento int,

  created_at               timestamptz not null default now(),
  created_by               bigint not null,
  metadata_blockchain      jsonb,

  constraint evento_plantacion_subcampania_fk
    foreign key (subcampania_id) references subcampania(id),
  constraint evento_plantacion_registro_fk
    foreign key (registro_plantacion_id) references registro_plantacion(id),
  constraint evento_plantacion_asignacion_fk
    foreign key (asignacion_id) references asignacion_vivero_subcampania(id),
  constraint evento_plantacion_responsable_fk
    foreign key (responsable_id) references usuario(id),
  constraint evento_plantacion_created_by_fk
    foreign key (created_by) references usuario(id),

  -- Coherencia por tipo de evento
  constraint evento_plantacion_mortandad_chk check (
    tipo_evento <> 'MORTANDAD_REPORTADA' or (
      cantidad_muerta_delta > 0
      and causa_mortandad is not null
      and registro_plantacion_id is not null
      and latitud is not null
      and longitud is not null
    )
  ),
  constraint evento_plantacion_devolucion_chk check (
    tipo_evento <> 'DEVOLUCION_A_VIVERO' or (
      cantidad_devuelta > 0
      and motivo_devolucion is not null
      and asignacion_id is not null
    )
  ),
  constraint evento_plantacion_asignacion_chk check (
    tipo_evento <> 'ASIGNACION_VIVERO' or (
      cantidad_asignada_evento > 0
      and asignacion_id is not null
    )
  )
);

create index if not exists evento_plantacion_subcampania_fecha_idx
  on evento_plantacion(subcampania_id, fecha_evento desc);
create index if not exists evento_plantacion_registro_idx
  on evento_plantacion(registro_plantacion_id)
  where registro_plantacion_id is not null;
create index if not exists evento_plantacion_asignacion_idx
  on evento_plantacion(asignacion_id)
  where asignacion_id is not null;
create index if not exists evento_plantacion_tipo_fecha_idx
  on evento_plantacion(tipo_evento, fecha_evento desc);
```

### 2.7. Vista de estado derivado de CAMPANIA

```sql
create or replace view campania_estado as
select
  c.id as campania_id,
  case
    when not exists (
      select 1 from subcampania s
      where s.campania_id = c.id and s.deleted_at is null
    ) then 'BORRADOR'
    when exists (
      select 1 from subcampania s
      where s.campania_id = c.id and s.deleted_at is null and s.estado = 'ACTIVA'
    ) then 'ACTIVA'
    when exists (
      select 1 from subcampania s
      where s.campania_id = c.id and s.deleted_at is null
        and s.fase_mantenimiento = 'MANTENIMIENTO_ACTIVO'
    ) then 'EN_MANTENIMIENTO'
    when not exists (
      select 1 from subcampania s
      where s.campania_id = c.id and s.deleted_at is null
        and s.fase_mantenimiento <> 'MONITOREO_HISTORICO'
    ) then 'MONITOREO_HISTORICO'
    else 'BORRADOR'
  end as estado_derivado
from campania c;

comment on view campania_estado is
  'Estado de campaña derivado en tiempo real desde sus subcampañas (invariante CLAUDE.md). No materializar.';
```

### 2.8. Función de validación GPS

Útil para que tarea 03 valide el GPS de cada `REGISTRO_PLANTACION` antes de insertar.

```sql
create or replace function gps_dentro_poligono_con_tolerancia(
  p_subcampania_id bigint,
  p_lat numeric,
  p_lng numeric
) returns table(dentro boolean, distancia_m numeric)
language sql stable as $$
  select
    st_dwithin(
      s.poligono_geom::geography,
      st_setsrid(st_makepoint(p_lng, p_lat), 4326)::geography,
      s.tolerancia_gps_metros
    ) as dentro,
    st_distance(
      s.poligono_geom::geography,
      st_setsrid(st_makepoint(p_lng, p_lat), 4326)::geography
    ) as distancia_m
  from subcampania s
  where s.id = p_subcampania_id;
$$;
```

---

## 3. Decisiones que esta tarea respeta (cerradas en tarea 10)

| # | Decisión | Cómo se manifiesta en BD |
|---|----------|--------------------------|
| 1 | Reposición libre de especie | No hay constraint que ate la especie del detalle a la especie del grupo origen |
| 2 | Mortandad por 3 roles | `EVENTO_PLANTACION.responsable_id` es FK a `USUARIO`; el handler valida pertenencia al equipo |
| 3 | UX pre-confirmación | Materialización de `cantidad_muerta_acumulada` y `cantidad_repuesta_acumulada` en `REGISTRO_PLANTACION` |
| 4 | COORDINADOR como membresía | `SUBCAMPANIA_EQUIPO` con `rol_en_subcampania`, no columna `coordinador_id` |
| 5 | Sin mix de especies | No hay tabla `subcampania_especie_permitida`, no hay validación de topes |
| 6 | Estado de campaña derivado | Vista `campania_estado`, no columna en `CAMPANIA` |

---

## 4. Criterios de aceptación

- [ ] PostGIS habilitado.
- [ ] Los 8 enums creados con guard `do $$ ... if not exists ... $$`.
- [ ] `CAMPANIA` creada **sin columna de estado**.
- [ ] `CAMPANIA_ORGANIZACION` creada con unique `(campania_id, organizacion_id)`.
- [ ] Vista `campania_estado` devuelve un valor coherente para campañas sin subcampañas, con activas, en mantenimiento y en monitoreo histórico.
- [ ] `SUBCAMPANIA` creada con polígono geometry, contadores materializados y CHECK constraints de activación y cierre.
- [ ] `SUBCAMPANIA_EQUIPO` creada con unique index parcial: insertar un segundo COORDINADOR sobre la misma subcampaña falla.
- [ ] `REGISTRO_PLANTACION` falla si `es_reposicion = true` y `registro_plantacion_origen_id is null`, y viceversa.
- [ ] `REGISTRO_PLANTACION_DETALLE` y `REGISTRO_PLANTACION_CORESPONSABLE` creadas con unique constraints.
- [ ] `EVENTO_PLANTACION` falla si se intenta insertar `MORTANDAD_REPORTADA` sin causa, sin delta, sin GPS o sin registro origen.
- [ ] `EVENTO_PLANTACION` falla si se intenta insertar `DEVOLUCION_A_VIVERO` sin motivo o sin `asignacion_id`.
- [ ] Función `gps_dentro_poligono_con_tolerancia` devuelve `(dentro, distancia_m)` correctamente para un punto adentro y otro afuera del polígono.
- [ ] Todas las FKs hacia `usuario`, `division_administrativa`, `lote_vivero`, `planta`, `evento_lote_vivero`, `asignacion_vivero_subcampania` resuelven correctamente contra el esquema existente.

---

## 5. Choques con el sistema actual

- **`ORGANIZACION` puede no existir**: si la tabla maestra `ORGANIZACION` no está creada todavía en el módulo General, la migración de `CAMPANIA_ORGANIZACION` falla. Crear `ORGANIZACION` primero o ajustar la dependencia.
- **`DIVISION_ADMINISTRATIVA`**: debe existir como tabla maestra. Si su columna PK no es `bigint`, ajustar el FK.
- **PostGIS en Supabase**: habilitar desde el dashboard de Supabase si no está activo. Validar con `select postgis_version();`.
- **Sin triggers todavía**: los contadores materializados (`total_plantado_inicial`, `cantidad_muerta_acumulada`, etc.) **arrancan en 0 y no se actualizan solos**. Las queries de M3 que dependan de ellos serán incorrectas hasta que la tarea de triggers se aplique. Mitigación posible: vista derivada temporal `subcampania_saldos` mientras los triggers no están.
- **`tarea 03` queda desbloqueada**: una vez aplicada esta tarea, la tarea 03 puede empezar (el handler atómico ya tiene FKs reales hacia `subcampania`, `campania` y `registro_plantacion`).

---

## 6. Archivos a tocar

- Nuevo: `database/supabase/04_create_m3_enums_y_postgis.sql` (sección 2.1 + 2.2).
- Nuevo: `database/supabase/05_create_campania.sql` (sección 2.3 + 2.7).
- Nuevo: `database/supabase/06_create_subcampania.sql` (sección 2.4).
- Nuevo: `database/supabase/07_create_registro_plantacion.sql` (sección 2.5).
- Nuevo: `database/supabase/08_create_evento_plantacion.sql` (sección 2.6).
- Nuevo: `database/supabase/09_create_gps_function.sql` (sección 2.8).
- Actualizar: [database/00_database_schema.md](../../database/00_database_schema.md) — agregar entidades de M3 al diagrama ER.

(Los nombres exactos de archivo y la división en sub-migraciones quedan a criterio del implementador; lo que importa es que la spec quede aplicada de forma idempotente.)

---

## 7. Pendientes derivados

- **Triggers para mantener materializados** (tarea siguiente, sugerida 12):
  - Trigger en `EVENTO_PLANTACION` (`MORTANDAD_REPORTADA`) → recalcula `REGISTRO_PLANTACION.cantidad_muerta_acumulada` y `SUBCAMPANIA.total_muerto_acumulado`.
  - Trigger en `REGISTRO_PLANTACION` (insert con `es_reposicion`) → recalcula `cantidad_repuesta_acumulada` del grupo origen y `SUBCAMPANIA.total_repuesto`.
  - Trigger en `REGISTRO_PLANTACION` (insert con `es_reposicion = false`) → recalcula `SUBCAMPANIA.total_plantado_inicial`.
  - Trigger de cierre automático a `COMPLETADA` cuando `total_plantado_inicial >= meta_total_arboles`.
- **`CAMPANIA_HISTORIAL` y `SUBCAMPANIA_HISTORIAL`** (tarea posterior): eventos de ciclo de vida (`CAMPANIA_CREADA`, `SUBCAMPANIA_ACTIVADA`, etc.) listados en doc M3 §4.1.
- **Job nocturno** de transición `MANTENIMIENTO_ACTIVO → MONITOREO_HISTORICO` cuando `today >= fecha_fin_mantenimiento`.
- **Validación de equipo al insertar registro/coresponsable**: el handler debe verificar que `responsable_id` y todos los `coresponsable.usuario_id` están en `SUBCAMPANIA_EQUIPO` de la subcampaña.
- **`evento_lote_vivero_despacho_id` en `REGISTRO_PLANTACION_DETALLE`**: lo llena la tarea 03 dentro de la transacción atómica. Antes de tarea 03 se inserta como `NULL` y luego se actualiza con el id del DESPACHO creado.
- **Snapshots oficiales**: el handler debe congelar `nombre_zona_snapshot`, `nombre_coordinador_snapshot`, `nombres_organizaciones_snapshot` al activar la subcampaña, y `nombre_subcampania_snapshot`, `nombre_responsable_snapshot`, `nombre_*_snapshot` al insertar un registro.

# Informe — Tarea 11 (modelado base M3)

**Resultado:** 6 migraciones SQL creadas en migrations/, idempotentes, aplicar en orden.

| # | Archivo | Sección spec | Contenido |
| --- | --- | --- | --- |
| 027 | 027_m3_postgis_y_enums.sql | 2.1 + 2.2 | `CREATE EXTENSION postgis` + los 8 enums (`tipo_subcampania`, `estado_subcampania`, `fase_mantenimiento_subcampania`, `motivo_cierre_parcial`, `rol_en_subcampania`, `causa_mortandad_plantacion`, `motivo_devolucion_plantacion`, `tipo_evento_plantacion`) con guards `DO $$ IF NOT EXISTS`. |
| 028 | 028_m3_campania.sql | 2.3 (+ placeholder `organizacion`) | `CAMPANIA` (sin columna estado) + `CAMPANIA_ORGANIZACION` (unique `(campania_id, organizacion_id)`) + placeholder defensivo para `organizacion`. |
| 029 | 029_m3_subcampania.sql | 2.4 + 2.7 | `SUBCAMPANIA` (polígono WGS84, contadores materializados, `saldo_vivo_actual` generated, CHECKs de activación/cierre) + `SUBCAMPANIA_EQUIPO` (unique index parcial **1 coordinador / subcampania**) + vista `campania_estado` (la moví aquí porque referencia `subcampania`). |
| 030 | 030_m3_registro_plantacion.sql | 2.5 | `REGISTRO_PLANTACION` (CHECK reposición↔origen, `saldo_vivo_grupo` generated) + `_DETALLE` (unique `(registro, asignacion, planta)`) + `_CORESPONSABLE`. |
| 031 | 031_m3_evento_plantacion.sql | 2.6 | `EVENTO_PLANTACION` unificada con 3 CHECKs de coherencia por tipo (mortandad / devolución / asignación). |
| 032 | 032_m3_gps_funcion.sql | 2.8 | Función `gps_dentro_poligono_con_tolerancia(subcampania_id, lat, lng)` → `(dentro, distancia_m)`. |

## Decisiones tomadas durante la implementación

- **Vista `campania_estado` vive en 029**, no en 028: necesita `public.subcampania` para validarse, por eso la moví al final de 029. El comentario en 028 lo aclara.
- **`organizacion` placeholder mínimo** en 028 (`id`, `nombre`, `activo`, timestamps): la tabla no existe en este repo de migraciones y el módulo General aún no la materializó. Sin esto, el FK de `CAMPANIA_ORGANIZACION` rompía. Se documenta como placeholder a reemplazar.
- **Estilo project-consistent**: `BIGINT GENERATED BY DEFAULT AS IDENTITY` (como las migraciones 024/007), schema `public.` explícito, SQL uppercase, FKs nombradas, `IF NOT EXISTS` en todo.
- **FK pendiente `asignacion_vivero_subcampania.subcampania_id → subcampania(id)`**: la tarea 11 lo deja fuera de alcance explícito. La migración 024 ya tiene comentario `FK pendiente`. No la agregué.

## Lo que **no** está incluido (declarado fuera de alcance en §1)

- Triggers de mantenimiento de contadores (`total_plantado_inicial`, `cantidad_muerta_acumulada`, etc.) → tarea 12.
- `CAMPANIA_HISTORIAL` / `SUBCAMPANIA_HISTORIAL` → tarea posterior.
- Job nocturno `MANTENIMIENTO_ACTIVO → MONITOREO_HISTORICO` → tarea posterior.
- Actualización del diagrama ER en `database/00_database_schema.md` (el archivo no existe en este repo; sí en `r3foresta-docs/` pero sin ER actual de M3 — lo dejo señalado).

## Riesgos a validar antes de aplicar a Supabase

1. **PostGIS**: habilitar desde el dashboard de Supabase si no está activo (`select postgis_version()`).
2. **`organizacion` real**: si el módulo General ya creó su versión definitiva, eliminar el placeholder de 028 y ajustar.
3. **Tarea 10 aplicada**: la spec asume decisiones de tarea 10 cerradas (sin mix de especies, coordinador como membresía, etc.). Confirmar antes de aplicar.
4. **Contadores en 0**: hasta que la tarea 12 cree los triggers, `total_plantado_inicial`, `cantidad_muerta_acumulada` etc. quedan en 0 y queries M3 que los lean serán incorrectas.

## Próximo paso

**Tarea 03 (despacho automático atómico)** queda desbloqueada: ya tiene FKs reales hacia `subcampania`, `campania`, `registro_plantacion`, `registro_plantacion_detalle` y `evento_plantacion`.