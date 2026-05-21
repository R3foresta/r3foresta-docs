# Tarea 02 — Crear tabla `ASIGNACION_VIVERO_SUBCAMPANIA`

**Área:** Base de datos
**Severidad:** Crítica
**Bloquea a:** 03, 04, 05
**Referencias:** Addendum sección 11.2, 12.2, 12.3

---

## 1. Contexto

La asignación de lotes de vivero a subcampañas es una **reserva lógica** que vive en M3 conceptualmente, pero referencia físicamente al lote del M2. La tabla `ASIGNACION_VIVERO_SUBCAMPANIA` es el puente que sostiene la contabilidad de qué fue reservado, consumido, devuelto y mermado por subcampaña.

No existe hoy en el esquema. Esta tarea la introduce.

---

## 2. Cambio requerido

### 2.1. Enums asociados

```sql
do $$ begin
  if not exists (select 1 from pg_type where typname = 'proposito_asignacion') then
    create type proposito_asignacion as enum ('PLANTACION_INICIAL', 'REPOSICION');
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_type where typname = 'estado_asignacion_vivero') then
    create type estado_asignacion_vivero as enum ('ACTIVA', 'AGOTADA', 'DEVUELTA');
  end if;
end $$;
```

**Decisión abierta:** ¿incluir `AFECTADA_POR_MERMA` en `estado_asignacion_vivero`? Recomendación del addendum: **omitir del enum** y mostrarlo como badge derivado cuando `cantidad_mermada > 0`. Esto evita un estado más complejo que se solapa con `ACTIVA`. Esta tarea sigue la recomendación.

### 2.2. Tabla

```sql
create table if not exists asignacion_vivero_subcampania (
  id              bigserial primary key,
  subcampania_id  bigint not null,
  lote_vivero_id  bigint not null,
  proposito       proposito_asignacion not null,
  estado          estado_asignacion_vivero not null default 'ACTIVA',

  cantidad_asignada     int not null,
  cantidad_consumida    int not null default 0,
  cantidad_devuelta     int not null default 0,
  cantidad_mermada      int not null default 0,
  saldo_asignado_disponible int generated always as (
    cantidad_asignada - cantidad_consumida - cantidad_devuelta - cantidad_mermada
  ) stored,

  usuario_asignacion_id bigint not null,
  fecha_asignacion      timestamptz not null default now(),
  updated_at            timestamptz not null default now(),

  constraint asignacion_vivero_subcampania_lote_fk
    foreign key (lote_vivero_id) references lote_vivero(id),
  constraint asignacion_vivero_subcampania_usuario_fk
    foreign key (usuario_asignacion_id) references usuario(id),

  constraint asignacion_cantidad_asignada_positiva_chk
    check (cantidad_asignada > 0),
  constraint asignacion_cantidad_consumida_no_negativa_chk
    check (cantidad_consumida >= 0),
  constraint asignacion_cantidad_devuelta_no_negativa_chk
    check (cantidad_devuelta >= 0),
  constraint asignacion_cantidad_mermada_no_negativa_chk
    check (cantidad_mermada >= 0),
  constraint asignacion_consistencia_saldos_chk
    check (cantidad_asignada >= cantidad_consumida + cantidad_devuelta + cantidad_mermada)
);
```

> **FK a `subcampania_id`:** queda pendiente hasta que la tabla `SUBCAMPANIA` exista (Módulo 3 en diseño). Documentar como comentario:
>
> ```sql
> comment on column asignacion_vivero_subcampania.subcampania_id
>   is 'FK pendiente a SUBCAMPANIA cuando se cree Modulo 3';
> ```

### 2.3. Índices recomendados

```sql
create index if not exists asignacion_vivero_subcampania_lote_idx
  on asignacion_vivero_subcampania(lote_vivero_id)
  where estado = 'ACTIVA';

create index if not exists asignacion_vivero_subcampania_subcampania_idx
  on asignacion_vivero_subcampania(subcampania_id);

create index if not exists asignacion_vivero_subcampania_fecha_fifo_idx
  on asignacion_vivero_subcampania(lote_vivero_id, fecha_asignacion)
  where estado = 'ACTIVA';
```

El último índice soporta la política FIFO de mermas (tarea 04).

### 2.4. Trigger de transición de estado (opcional, recomendado)

```sql
create or replace function asignacion_vivero_subcampania_actualizar_estado()
returns trigger language plpgsql as $$
declare
  v_saldo_disponible int;
begin
  -- saldo_asignado_disponible es GENERATED STORED y todavia es NULL en BEFORE trigger,
  -- por eso lo calculamos a mano aqui.
  v_saldo_disponible := new.cantidad_asignada
                      - new.cantidad_consumida
                      - new.cantidad_devuelta
                      - new.cantidad_mermada;

  new.updated_at := now();

  if v_saldo_disponible = 0
     and new.cantidad_consumida = 0
     and new.cantidad_devuelta = new.cantidad_asignada then
    new.estado := 'DEVUELTA';
  elsif v_saldo_disponible = 0 then
    new.estado := 'AGOTADA';
  else
    new.estado := 'ACTIVA';
  end if;

  return new;
end $$;

create trigger asignacion_vivero_subcampania_estado_trg
  before insert or update of cantidad_consumida, cantidad_devuelta, cantidad_mermada
  on asignacion_vivero_subcampania
  for each row execute function asignacion_vivero_subcampania_actualizar_estado();
```

> **Importante:** `saldo_asignado_disponible` es columna `GENERATED ALWAYS AS ... STORED`. En Postgres, las columnas GENERATED se computan **después** de los BEFORE triggers, así que dentro del trigger ese campo todavía es `NULL`. Por eso el trigger recalcula el saldo a mano usando las cuatro columnas base.

---

## 3. Criterios de aceptación

- [ ] Tabla creada con todos los CHECK constraints activos.
- [ ] Insertar una asignación con `cantidad_asignada = 0` falla.
- [ ] Actualizar una asignación a `cantidad_consumida = 200` cuando `cantidad_asignada = 100` falla por consistencia.
- [ ] `saldo_asignado_disponible` se calcula automáticamente sin necesidad de update manual.
- [ ] El estado pasa a `AGOTADA` automáticamente cuando se consume todo.
- [ ] El estado pasa a `DEVUELTA` automáticamente cuando todo se devuelve sin consumir.

---

## 4. Choques con el sistema actual

- **No hay choque directo:** la tabla es nueva.
- **Dependencia con M3:** las FKs hacia `subcampania_id` y `usuario_asignacion_id` necesitan que esas tablas estén listas. La FK a `usuario` ya existe; la de `subcampania` se difiere.
- **Booking conceptual:** si hoy el operario de vivero "reserva" mentalmente árboles para una campaña pero no hay registro de eso, la migración productiva debería incluir backfill manual de las asignaciones vigentes una vez que M3 entre en producción. Esto se trata como **dato cero** del MVP; no hay datos históricos a migrar.

---

## 5. Archivos a tocar

- Nuevo: `database/supabase/03_create_asignacion_vivero_subcampania.sql`
- Actualizar: [database/00_database_schema.md](../../database/00_database_schema.md) — agregar entidad y relaciones.
