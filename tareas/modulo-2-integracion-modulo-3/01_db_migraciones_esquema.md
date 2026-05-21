# Tarea 01 — Migraciones de esquema (enums + columnas + constraints)

**Área:** Base de datos
**Severidad:** Crítica
**Bloquea a:** 02, 03, 04, 05
**Referencias:** Addendum secciones 3, 4, 5, 11.1, 12 — ver [vivero-module/03_Addendum_Modulo_2_por_Modulo_3.md](../../vivero-module/03_Addendum_Modulo_2_por_Modulo_3.md)

---

## 1. Contexto mínimo (lectura obligatoria antes de ejecutar)

### 1.1. Qué hace esta tarea

Extiende la tabla `EVENTO_LOTE_VIVERO` y el enum `destino_tipo_vivero` para que el Módulo 2 (Vivero) pueda recibir **despachos automáticos generados desde el Módulo 3 (Plantación)**. También introduce el enum `origen_despacho_vivero` para distinguir despachos manuales de los automáticos.

**No crea ninguna tabla nueva.** La tabla `ASIGNACION_VIVERO_SUBCAMPANIA` se crea en la [tarea 02](./02_db_tabla_asignacion_vivero_subcampania.md).

### 1.2. Modelo conceptual de los cambios

```
Hoy:                                  Después:
─────                                 ────────
EVENTO_LOTE_VIVERO                    EVENTO_LOTE_VIVERO
├── DESPACHO (solo MANUAL)            ├── DESPACHO MANUAL
                                      │   (a destinos fuera de subcampañas)
                                      └── DESPACHO AUTOMATICO_PLANTACION
                                          (generado desde M3 al plantar/reponer;
                                           apunta a subcampania + campania + registro_plantacion)
```

Un `DESPACHO` automático **no tiene evidencia propia** — su evidencia es la del `REGISTRO_PLANTACION` asociado en M3. Eso significa que esta migración debe permitir despachos sin foto propia cuando `origen_despacho = 'AUTOMATICO_PLANTACION'`, pero seguir exigiendo evidencia obligatoria para despachos manuales (eso último se valida en backend, no en BD).

### 1.3. Asunciones / prerrequisitos

- **Postgres ≥ 12.** Si la BD productiva está en 11 o menor, el `alter type ... add value` requiere rebuild de la columna y bloquea más tiempo; coordinar ventana.
- **Migración aplicada por un runner que soporta ejecutar partes fuera de transacción** (Flyway, sqitch, custom). `alter type add value` **no se puede ejecutar dentro de un bloque transaccional** que después usa ese mismo valor. La migración se divide en dos archivos (ver 4.x).
- **Hay datos productivos** en `EVENTO_LOTE_VIVERO`. La migración debe ser **aditiva y backward-compatible**: eventos existentes quedan válidos con `origen_despacho = 'MANUAL'` y los nuevos FKs en `NULL`.
- **Tablas `SUBCAMPANIA`, `CAMPANIA`, `REGISTRO_PLANTACION` aún no existen** (Módulo 3 en diseño). Las columnas FK se agregan pero las restricciones `FOREIGN KEY` se difieren a una migración posterior cuando esas tablas existan. Por ahora solo `bigint` con `COMMENT`.

### 1.4. Lo que esta tarea NO hace (decisiones pendientes)

- **No renombra** `PLANTACION_COMUNIDAD` ni `DONACION`. El addendum sugiere consolidar a `DONACION_COMUNIDAD`, pero esa decisión queda pendiente con producto. Si se hace después, será migración separada.
- **No agrega** las FKs reales hacia `SUBCAMPANIA` / `CAMPANIA` / `REGISTRO_PLANTACION` (esperan a Módulo 3 en BD).
- **No modifica** el trigger existente de `EVENTO_LOTE_VIVERO` que recalcula `LOTE_VIVERO.saldo_vivo_actual` — debe seguir funcionando idéntico para despachos automáticos (un DESPACHO es un DESPACHO desde la perspectiva del saldo).
- **No toca** la lógica de aplicación. Solo el esquema.

---

## 2. Estado actual antes de migrar

### 2.1. Enum `destino_tipo_vivero` (esperado)

```
[PLANTACION_PROPIA, PLANTACION_COMUNIDAD, DONACION, VENTA, OTRO]
```

Verificar con:

```sql
select unnest(enum_range(null::destino_tipo_vivero)) as valor;
```

### 2.2. Columnas relevantes de `EVENTO_LOTE_VIVERO` (esperado, parcial)

Verificar con:

```sql
\d evento_lote_vivero
-- o equivalente:
select column_name, data_type, is_nullable, column_default
  from information_schema.columns
 where table_name = 'evento_lote_vivero'
 order by ordinal_position;
```

Columnas que **deben existir** antes de empezar:

- `tipo_evento ENUM(tipo_evento_vivero)`
- `destino_tipo ENUM(destino_tipo_vivero)` (nullable, solo aplica en DESPACHO)
- `destino_referencia text` (nullable)
- `comunidad_destino_id bigint` (nullable, FK a `DIVISION_ADMINISTRATIVA`)
- `unidad_medida_evento ENUM(unidad_medida)` (nullable)

Columnas que **no deben existir** todavía (se crean aquí):

- `origen_despacho`
- `subcampania_id`
- `campania_id`
- `registro_plantacion_id`

Si alguna ya existe, **detenerse** y entender por qué antes de aplicar.

---

## 3. Pre-flight checks (correr en BD réplica antes del deploy)

### 3.1. Versión de Postgres

```sql
select version();
-- Esperar PostgreSQL 12+ para evitar rewrite en alter type add value.
```

### 3.2. Despachos existentes con `destino_tipo` fuera del enum esperado

Si esta query devuelve filas, hay datos sucios que pueden romper el CHECK constraint posterior. Investigar antes de seguir.

```sql
select id, tipo_evento, destino_tipo, destino_referencia, created_at
  from evento_lote_vivero
 where tipo_evento = 'DESPACHO'
   and destino_tipo is null;
-- DESPACHO sin destino_tipo no debería existir. Si aparece, decidir backfill.

select destino_tipo, count(*)
  from evento_lote_vivero
 where tipo_evento = 'DESPACHO'
 group by destino_tipo;
-- Sanity check de distribución.
```

### 3.3. Despachos con cantidades / unidades anómalas

```sql
select id, cantidad_afectada, unidad_medida_evento
  from evento_lote_vivero
 where tipo_evento = 'DESPACHO'
   and (cantidad_afectada is null or unidad_medida_evento <> 'UNIDAD');
-- Cualquier DESPACHO no en UNIDAD es anómalo. Investigar.
```

### 3.4. Volumen estimado

```sql
select count(*) from evento_lote_vivero;
-- Para estimar tiempo de alter table (con DEFAULT, en PG11+ es metadata-only).
```

### 3.5. Bloqueos activos

```sql
select * from pg_locks where granted = false;
-- No debería haber locks pesados sobre evento_lote_vivero al momento del deploy.
```

---

## 4. Migración consolidada

Se entrega como **dos archivos** por la restricción de `alter type add value` fuera de transacción.

### 4.1. Archivo `database/supabase/02_alter_evento_lote_vivero_m3__paso1_enums.sql`

Este archivo debe correrse **fuera de transacción** (o cada `alter type` en su propia transacción auto-commit).

```sql
-- =============================================================================
-- 02_alter_evento_lote_vivero_m3 — PASO 1: enums
--
-- Agrega:
--   * PLANTACION_CAMPANIA al enum destino_tipo_vivero
--   * Nuevo enum origen_despacho_vivero
--
-- Requiere: PostgreSQL 12+ para que alter type add value sea metadata-only.
-- Importante: ejecutar fuera de bloque transaccional. No combinar con paso 2
-- en la misma transacción, porque el nuevo valor del enum no es visible hasta
-- después del commit.
-- =============================================================================

-- 1) Agregar PLANTACION_CAMPANIA a destino_tipo_vivero (idempotente)
alter type destino_tipo_vivero add value if not exists 'PLANTACION_CAMPANIA';

-- 2) Crear enum origen_despacho_vivero (idempotente)
do $$
begin
  if not exists (select 1 from pg_type where typname = 'origen_despacho_vivero') then
    create type origen_despacho_vivero as enum ('MANUAL', 'AUTOMATICO_PLANTACION');
  end if;
end $$;
```

### 4.2. Archivo `database/supabase/03_alter_evento_lote_vivero_m3__paso2_columnas.sql`

Este archivo puede correrse dentro de transacción.

```sql
-- =============================================================================
-- 02_alter_evento_lote_vivero_m3 — PASO 2: columnas y restricciones
--
-- Requiere haber corrido el paso 1 antes.
-- Agrega columnas nuevas a EVENTO_LOTE_VIVERO y los CHECK constraints
-- que garantizan consistencia entre origen_despacho y los FKs hacia M3.
-- =============================================================================

begin;

-- 1) Agregar columnas (todas nullable, con default seguro)
alter table evento_lote_vivero
  add column if not exists origen_despacho        origen_despacho_vivero default 'MANUAL',
  add column if not exists subcampania_id         bigint,
  add column if not exists campania_id            bigint,
  add column if not exists registro_plantacion_id bigint;

-- 2) Backfill defensivo (no-op si el default ya rellenó filas existentes)
update evento_lote_vivero
   set origen_despacho = 'MANUAL'
 where origen_despacho is null;

alter table evento_lote_vivero
  alter column origen_despacho set not null;

-- 3) Documentar FKs futuras (se materializan cuando exista Módulo 3 en BD)
comment on column evento_lote_vivero.subcampania_id
  is 'FK pendiente a SUBCAMPANIA cuando se cree Módulo 3. Obligatorio cuando origen_despacho = AUTOMATICO_PLANTACION.';
comment on column evento_lote_vivero.campania_id
  is 'FK pendiente a CAMPANIA cuando se cree Módulo 3. Obligatorio cuando origen_despacho = AUTOMATICO_PLANTACION.';
comment on column evento_lote_vivero.registro_plantacion_id
  is 'FK pendiente a REGISTRO_PLANTACION cuando se cree Módulo 3. Obligatorio cuando origen_despacho = AUTOMATICO_PLANTACION.';
comment on column evento_lote_vivero.origen_despacho
  is 'MANUAL = despacho registrado desde Vivero. AUTOMATICO_PLANTACION = generado por el sistema desde M3 al plantar o reponer.';

-- 4) CHECK constraint: consistencia entre origen_despacho y los FKs hacia M3
--    Solo aplica a DESPACHO; los demás tipos de evento pasan sin restricción.
--    Casts explícitos a enum para evitar ambigüedades.
alter table evento_lote_vivero
  add constraint evento_lote_vivero_origen_despacho_consistency_chk
  check (
    tipo_evento <> 'DESPACHO'::tipo_evento_vivero
    or (
      (
        origen_despacho = 'MANUAL'::origen_despacho_vivero
        and destino_tipo <> 'PLANTACION_CAMPANIA'::destino_tipo_vivero
        and subcampania_id is null
        and campania_id is null
        and registro_plantacion_id is null
      )
      or (
        origen_despacho = 'AUTOMATICO_PLANTACION'::origen_despacho_vivero
        and destino_tipo = 'PLANTACION_CAMPANIA'::destino_tipo_vivero
        and subcampania_id is not null
        and campania_id is not null
        and registro_plantacion_id is not null
      )
    )
  );

-- 5) CHECK constraint: unidad obligatoria UNIDAD para despachos automáticos
alter table evento_lote_vivero
  add constraint evento_lote_vivero_auto_plantacion_unidad_chk
  check (
    origen_despacho <> 'AUTOMATICO_PLANTACION'::origen_despacho_vivero
    or unidad_medida_evento = 'UNIDAD'::unidad_medida
  );

commit;
```

---

## 5. Smoke tests post-deploy (correr en orden)

### 5.1. Verificar enums

```sql
select unnest(enum_range(null::destino_tipo_vivero)) as valor;
-- Debe incluir PLANTACION_CAMPANIA

select unnest(enum_range(null::origen_despacho_vivero)) as valor;
-- Debe devolver MANUAL y AUTOMATICO_PLANTACION
```

### 5.2. Verificar columnas

```sql
select column_name, data_type, is_nullable, column_default
  from information_schema.columns
 where table_name = 'evento_lote_vivero'
   and column_name in ('origen_despacho','subcampania_id','campania_id','registro_plantacion_id')
 order by column_name;
-- origen_despacho NOT NULL con default 'MANUAL'; el resto nullable.
```

### 5.3. Verificar que filas existentes quedaron consistentes

```sql
select origen_despacho, count(*)
  from evento_lote_vivero
 group by origen_despacho;
-- Todas las filas existentes deben tener origen_despacho = 'MANUAL'.

select count(*)
  from evento_lote_vivero
 where tipo_evento = 'DESPACHO'
   and origen_despacho = 'MANUAL'
   and (subcampania_id is not null or campania_id is not null or registro_plantacion_id is not null);
-- Debe ser 0.
```

### 5.4. Verificar que los CHECK constraints rechazan inconsistencias

Los siguientes inserts **deben fallar** (correr en transacción y hacer rollback):

```sql
-- a) DESPACHO MANUAL apuntando a PLANTACION_CAMPANIA → debe fallar
begin;
insert into evento_lote_vivero (lote_id, tipo_evento, fecha_evento, responsable_id,
                                cantidad_afectada, unidad_medida_evento,
                                destino_tipo, origen_despacho)
values (1, 'DESPACHO', current_date, 1, 10, 'UNIDAD',
        'PLANTACION_CAMPANIA', 'MANUAL');
-- ERROR esperado: viola evento_lote_vivero_origen_despacho_consistency_chk
rollback;

-- b) DESPACHO AUTOMATICO sin subcampania_id → debe fallar
begin;
insert into evento_lote_vivero (lote_id, tipo_evento, fecha_evento, responsable_id,
                                cantidad_afectada, unidad_medida_evento,
                                destino_tipo, origen_despacho)
values (1, 'DESPACHO', current_date, 1, 10, 'UNIDAD',
        'PLANTACION_CAMPANIA', 'AUTOMATICO_PLANTACION');
-- ERROR esperado: viola evento_lote_vivero_origen_despacho_consistency_chk
rollback;

-- c) DESPACHO AUTOMATICO con unidad_medida_evento = 'G' → debe fallar
begin;
insert into evento_lote_vivero (lote_id, tipo_evento, fecha_evento, responsable_id,
                                cantidad_afectada, unidad_medida_evento,
                                destino_tipo, origen_despacho,
                                subcampania_id, campania_id, registro_plantacion_id)
values (1, 'DESPACHO', current_date, 1, 10, 'G',
        'PLANTACION_CAMPANIA', 'AUTOMATICO_PLANTACION', 1, 1, 1);
-- ERROR esperado: viola evento_lote_vivero_auto_plantacion_unidad_chk
rollback;

-- d) MERMA (no-DESPACHO) con origen_despacho default → debe pasar
begin;
insert into evento_lote_vivero (lote_id, tipo_evento, fecha_evento, responsable_id,
                                cantidad_afectada, unidad_medida_evento, causa_merma)
values (1, 'MERMA', current_date, 1, 5, 'UNIDAD', 'PLAGA');
-- OK esperado: la constraint solo aplica a DESPACHO.
rollback;
```

### 5.5. Verificar el trigger de saldo existente

Insertar un `DESPACHO` manual válido en una transacción y verificar que `LOTE_VIVERO.saldo_vivo_actual` disminuyó (rollback al final si es BD productiva). Esto confirma que el trigger existente no se ve afectado por las columnas nuevas.

---

## 6. Rollback / Down migration

Si algo sale mal después de aplicar:

```sql
-- Quitar CHECK constraints
alter table evento_lote_vivero
  drop constraint if exists evento_lote_vivero_auto_plantacion_unidad_chk;
alter table evento_lote_vivero
  drop constraint if exists evento_lote_vivero_origen_despacho_consistency_chk;

-- Quitar columnas (orden inverso al alta)
alter table evento_lote_vivero
  drop column if exists registro_plantacion_id,
  drop column if exists campania_id,
  drop column if exists subcampania_id,
  drop column if exists origen_despacho;

-- Borrar enum nuevo (solo si no está siendo usado por otra cosa)
drop type if exists origen_despacho_vivero;

-- Nota: no se puede quitar un valor de un enum existente en Postgres.
-- PLANTACION_CAMPANIA queda en destino_tipo_vivero aunque no se use.
-- Si es absolutamente necesario eliminarlo, hay que recrear el enum, lo que
-- requiere bajar la columna que lo usa. No recomendado para rollback rápido.
```

---

## 7. Criterios de aceptación

- [ ] La query de versión devuelve PostgreSQL 12 o superior.
- [ ] Los pre-flight checks (sección 3) no muestran datos sucios sin justificar.
- [ ] Ambos archivos SQL corren limpios (paso 1 fuera de transacción, paso 2 dentro).
- [ ] El enum `destino_tipo_vivero` contiene `PLANTACION_CAMPANIA`.
- [ ] El enum `origen_despacho_vivero` existe con los dos valores correctos.
- [ ] La tabla `evento_lote_vivero` tiene las cuatro columnas nuevas con la nullabilidad y default correctos.
- [ ] Todas las filas existentes tienen `origen_despacho = 'MANUAL'` y los tres FKs en `NULL`.
- [ ] Los inserts de prueba de la sección 5.4 fallan / pasan según lo esperado.
- [ ] El trigger existente de saldo sigue funcionando (sección 5.5).
- [ ] La aplicación cliente regeneró tipos / bindings y un deploy de smoke sigue funcionando.

---

## 8. Choques con el sistema actual

- **`alter type add value` no transaccional**: por eso la migración se divide en dos archivos. Si el runner del proyecto no soporta scripts fuera de transacción, hay que ejecutar el paso 1 a mano antes del deploy.
- **Tipos generados / ORM**: aplicaciones que validen `destino_tipo_vivero` por whitelist enumerada (TypeScript types, Prisma/TypeORM/SQLAlchemy enum bindings) necesitan **regenerar tipos** antes del deploy de la app. Sin esto, una llamada a la API con `PLANTACION_CAMPANIA` puede fallar en validación del cliente.
- **Despacho manual**: el handler actual de despachos manuales sigue funcionando idéntico (los defaults rellenan los nuevos campos). Pero **debe modificarse en una tarea posterior** (ver tarea 05) para rechazar `destino_tipo = 'PLANTACION_CAMPANIA'` explícitamente, ya que la BD lo permitiría si origen_despacho fuera AUTOMATICO_PLANTACION. La protección de la BD es correcta; el handler debe ser explícito.
- **Auditoría histórica**: el pre-flight check 3.2 puede revelar `DESPACHO` con `destino_tipo` ya inexistente o mal poblado. Si aparece algo así, no aplicar la migración hasta haberlo corregido o documentado.

---

## 9. Checklist para el dev de backend

Antes de mergear:

- [ ] Leí el [Addendum del Módulo 2](../../vivero-module/03_Addendum_Modulo_2_por_Modulo_3.md) secciones 3, 4, 5, 11.1 y 12.
- [ ] Leí [vivero-module/04_consumo_de_vivero.md](../../vivero-module/04_consumo_de_vivero.md) para entender el contexto operativo.
- [ ] Verifiqué versión de Postgres (≥ 12).
- [ ] Corrí pre-flight checks en réplica y todo limpio (o documenté excepciones).
- [ ] Apliqué paso 1 fuera de transacción, paso 2 en transacción.
- [ ] Corrí todos los smoke tests post-deploy.
- [ ] Tengo el script de rollback listo a mano.
- [ ] Avisé al equipo de backend para regenerar tipos / bindings antes del deploy de la app.
- [ ] Cuando termine, paso resumen a Claude para cerrar la tarea según el protocolo del [README](./README.md).

---

## 10. Archivos a tocar

| Archivo | Acción |
|---------|--------|
| `database/supabase/02_alter_evento_lote_vivero_m3__paso1_enums.sql` | Crear nuevo |
| `database/supabase/03_alter_evento_lote_vivero_m3__paso2_columnas.sql` | Crear nuevo |
| [database/00_database_schema.md](../../database/00_database_schema.md) | Ya actualizado (refleja el estado post-migración) |
