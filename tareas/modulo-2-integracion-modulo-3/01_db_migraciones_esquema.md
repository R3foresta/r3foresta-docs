# Tarea 01 — Migraciones de esquema (enums + columnas + constraints)

**Área:** Base de datos
**Severidad:** Crítica
**Bloquea a:** 02, 03, 04, 05
**Referencias:** Addendum secciones 3, 4, 5, 11.1, 12

---

## 1. Contexto

El esquema actual de Módulo 2 no contempla despachos generados desde Plantación. Los enums y la tabla `EVENTO_LOTE_VIVERO` deben extenderse para soportar el contrato M2 ↔ M3 documentado en el addendum.

Hay datos productivos en `EVENTO_LOTE_VIVERO`, por lo que toda alteración debe ser **aditiva y backward-compatible**. Eventos preexistentes deben quedar válidos (con `origen_despacho = MANUAL` y los nuevos FKs en `NULL`).

---

## 2. Cambios requeridos

### 2.1. Enum `destino_tipo_vivero` — agregar valor

```sql
alter type destino_tipo_vivero add value if not exists 'PLANTACION_CAMPANIA';
```

> En Postgres, `add value` a un enum requiere correr fuera de transacción si la migración es transaccional. Verificar el runner de migraciones del proyecto.

Valor actual del enum (ver [database/00_database_schema.md](../../database/00_database_schema.md)):

```
destino_tipo_vivero = [PLANTACION_PROPIA, PLANTACION_COMUNIDAD, DONACION, VENTA, OTRO]
```

**Nota de coherencia:** el addendum recomienda renombrar/consolidar a `[PLANTACION_CAMPANIA, PLANTACION_PROPIA, DONACION_COMUNIDAD, VENTA, OTRO]`. Eso implica renombrar `PLANTACION_COMUNIDAD → DONACION_COMUNIDAD` y `DONACION → DONACION_COMUNIDAD` (o decidir cuál se conserva). **Decisión pendiente:** confirmar con producto si renombramos o solo añadimos. Por defecto, esta tarea **solo agrega** `PLANTACION_CAMPANIA` y deja los demás valores intactos.

### 2.2. Crear enum `origen_despacho_vivero`

```sql
do $$ begin
  if not exists (select 1 from pg_type where typname = 'origen_despacho_vivero') then
    create type origen_despacho_vivero as enum ('MANUAL', 'AUTOMATICO_PLANTACION');
  end if;
end $$;
```

### 2.3. Alterar `EVENTO_LOTE_VIVERO`

Agregar columnas (todas nullable, con default seguro para datos existentes):

```sql
alter table evento_lote_vivero
  add column if not exists origen_despacho origen_despacho_vivero default 'MANUAL',
  add column if not exists subcampania_id bigint,
  add column if not exists campania_id bigint,
  add column if not exists registro_plantacion_id bigint;
```

Backfill explícito para registros existentes (idempotente):

```sql
update evento_lote_vivero
  set origen_despacho = 'MANUAL'
  where origen_despacho is null;

alter table evento_lote_vivero
  alter column origen_despacho set not null;
```

### 2.4. FKs hacia M3

Las tablas `SUBCAMPANIA`, `CAMPANIA` y `REGISTRO_PLANTACION` todavía no existen en BD (Módulo 3 está en diseño). **No agregar FKs hasta que esas tablas existan.** Esta tarea solo crea las columnas; los `foreign key` se añaden en la migración que crea M3.

Documentar las FKs futuras como comentario en la migración:

```sql
comment on column evento_lote_vivero.subcampania_id
  is 'FK pendiente a SUBCAMPANIA cuando se cree Modulo 3';
comment on column evento_lote_vivero.campania_id
  is 'FK pendiente a CAMPANIA cuando se cree Modulo 3';
comment on column evento_lote_vivero.registro_plantacion_id
  is 'FK pendiente a REGISTRO_PLANTACION cuando se cree Modulo 3';
```

### 2.5. CHECK constraint por origen de despacho

Solo aplica a eventos de tipo `DESPACHO`. Para no romper eventos `INICIO`, `EMBOLSADO`, etc., el constraint se restringe a `DESPACHO`:

```sql
alter table evento_lote_vivero
  add constraint evento_lote_vivero_origen_despacho_consistency_chk
  check (
    tipo_evento <> 'DESPACHO'
    or (
      (
        origen_despacho = 'MANUAL'
        and destino_tipo <> 'PLANTACION_CAMPANIA'
        and subcampania_id is null
        and campania_id is null
        and registro_plantacion_id is null
      )
      or (
        origen_despacho = 'AUTOMATICO_PLANTACION'
        and destino_tipo = 'PLANTACION_CAMPANIA'
        and subcampania_id is not null
        and campania_id is not null
        and registro_plantacion_id is not null
      )
    )
  );
```

### 2.6. Unidad obligatoria en despachos automáticos

```sql
alter table evento_lote_vivero
  add constraint evento_lote_vivero_auto_plantacion_unidad_chk
  check (
    origen_despacho <> 'AUTOMATICO_PLANTACION'
    or unidad_medida_evento = 'UNIDAD'
  );
```

---

## 3. Criterios de aceptación

- [ ] Migración corre limpia en una BD réplica del entorno productivo (sin errores, sin lock prolongado).
- [ ] Todos los eventos existentes quedan con `origen_despacho = 'MANUAL'` y los nuevos FKs en `NULL`.
- [ ] Insertar un evento `DESPACHO` con `destino_tipo = 'PLANTACION_CAMPANIA'` y `origen_despacho = 'MANUAL'` falla el CHECK.
- [ ] Insertar un evento `DESPACHO` con `origen_despacho = 'AUTOMATICO_PLANTACION'` sin `subcampania_id` falla el CHECK.
- [ ] Eventos no-DESPACHO (INICIO, EMBOLSADO, MERMA, etc.) siguen pudiendo guardarse sin cambios.
- [ ] El enum `origen_despacho_vivero` aparece en `pg_type`.
- [ ] El valor `PLANTACION_CAMPANIA` aparece en `destino_tipo_vivero`.

---

## 4. Choques con el sistema actual

- **Lock en `alter type add value`:** en Postgres < 12 requería rebuild; en 12+ es metadata-only. Verificar la versión productiva.
- **Aplicaciones cliente** que validen el enum `destino_tipo_vivero` por whitelist enumerada (TS types, ORM) necesitan regenerar tipos antes del deploy.
- El default `MANUAL` en `origen_despacho` cubre el path optimista, pero el CHECK constraint puede fallar al backfilear si algún `DESPACHO` histórico tiene `destino_tipo` que ya no es válido o referencias inconsistentes. **Antes del deploy:** correr una query de auditoría:

  ```sql
  select id, tipo_evento, destino_tipo, destino_referencia
    from evento_lote_vivero
   where tipo_evento = 'DESPACHO'
     and destino_tipo not in (
       'PLANTACION_PROPIA','PLANTACION_COMUNIDAD','DONACION','VENTA','OTRO'
     );
  ```

  Si devuelve filas, decidir cómo corregir antes de aplicar el CHECK.

---

## 5. Archivos a tocar

- Nuevo: `database/supabase/02_alter_evento_lote_vivero_m3.sql`
- Actualizar: [database/00_database_schema.md](../../database/00_database_schema.md) — sección ENUMS y entidad `EVENTO_LOTE_VIVERO`.
