# Tarea 12 — Eliminar de BD el boceto legacy de plantación

**Área:** Base de datos
**Severidad:** Mejora (no bloquea a nadie)
**Depende de:** [tarea 11 ✅](./completadas/11_db_modelado_m3_base.md) (modelo M3 ya está en BD)
**Bloquea a:** —
**Referencias:** `database/00_database_schema.md` (post-actualización 2026-05-24)

---

## 0. Origen de esta tarea

Antes del diseño de M3, el esquema canónico (`database/00_database_schema.md`) incluía un boceto de plantación con las tablas `PLANTACION`, `PLANTACION_FOTO`, `PLANTACION_MONITOREO`, `PLANTACION_ABONO`, `PLANTACION_RIEGO`, `PLANTACION_USUARIO`, `PLANTACION_LOTE_VIVERO`, más los catálogos `TIPO_ABONO` y `TIPO_RIEGO`.

El modelo M3 oficial (aplicado vía migraciones 027–032 en tarea 11) reemplaza por completo ese boceto con la jerarquía `CAMPANIA → SUBCAMPANIA → REGISTRO_PLANTACION → EVENTO_PLANTACION`. El boceto legacy quedó obsoleto.

**Contexto operativo confirmado por el usuario (2026-05-24):**

- Ninguna de las tablas legacy contiene datos.
- Ningún componente las consume (backend ni frontend).
- No hay riesgo de pérdida de información ni de roturas en cascada.

Por eso esta tarea es un drop directo, sin migración de datos.

---

## 1. Alcance

**Tablas a eliminar:**

- `PLANTACION_FOTO`
- `PLANTACION_MONITOREO`
- `PLANTACION_ABONO`
- `PLANTACION_RIEGO`
- `PLANTACION_USUARIO`
- `PLANTACION_LOTE_VIVERO`
- `PLANTACION`
- `TIPO_ABONO`
- `TIPO_RIEGO`

**Orden:** primero las tablas hijas (FKs hacia `PLANTACION`), después `PLANTACION`, después los catálogos `TIPO_ABONO` y `TIPO_RIEGO` que solo eran referenciados por las tablas puente recién dropeadas.

**Fuera de alcance:**

- Eliminar enums relacionados (no existen — los catálogos eran tablas, no enums).
- Tocar las tablas vivas de M3 (`CAMPANIA`, `SUBCAMPANIA`, `REGISTRO_PLANTACION`, `EVENTO_PLANTACION`, `*_DETALLE`, `*_CORESPONSABLE`).
- Tocar `UBICACION` ni `USUARIO` (siguen vivos, siguen siendo referenciados por otras tablas).

---

## 2. Cambio requerido

Una migración SQL idempotente. Sugerencia de nombre: `Backend-r3foresta/migrations/033_drop_legacy_plantacion.sql`.

```sql
-- 033_drop_legacy_plantacion.sql
-- Elimina el boceto legacy de plantacion superado por el modelo M3
-- (CAMPANIA → SUBCAMPANIA → REGISTRO_PLANTACION → EVENTO_PLANTACION).
-- Contexto: las tablas nunca poblaron datos, ningun consumidor las lee.
-- Confirmado por el usuario el 2026-05-24.
-- Origen: tareas/modulo-2-integracion-modulo-3/12_db_drop_legacy_plantacion.md
-- Idempotente.

-- Orden: tablas hijas (con FK a plantacion) primero, despues plantacion, despues
-- los catalogos que solo referenciaban las tablas puente recien dropeadas.

DROP TABLE IF EXISTS public.plantacion_foto          CASCADE;
DROP TABLE IF EXISTS public.plantacion_monitoreo     CASCADE;
DROP TABLE IF EXISTS public.plantacion_abono         CASCADE;
DROP TABLE IF EXISTS public.plantacion_riego         CASCADE;
DROP TABLE IF EXISTS public.plantacion_usuario       CASCADE;
DROP TABLE IF EXISTS public.plantacion_lote_vivero   CASCADE;
DROP TABLE IF EXISTS public.plantacion               CASCADE;
DROP TABLE IF EXISTS public.tipo_abono               CASCADE;
DROP TABLE IF EXISTS public.tipo_riego               CASCADE;
```

> **Por qué `CASCADE`**: defensivo. Si alguna vista, función o constraint olvidado todavía referencia estas tablas, el CASCADE las arrastra. Como confirmamos que no hay consumidores, no debería romper nada — y si lo hace, el resultado del DROP nos va a mostrar exactamente qué fue arrastrado, que es información útil para auditoría.

---

## 3. Criterios de aceptación

- [ ] Ejecutar la migración en Supabase staging.
- [ ] Verificar con `SELECT to_regclass('public.plantacion')` que devuelve `NULL` (y lo mismo para cada tabla dropeada).
- [ ] Verificar que no hay errores en logs de aplicación tras el drop (confirma que efectivamente no había consumidores).
- [ ] Verificar que las tablas vivas de M3 siguen intactas: `SELECT count(*) FROM campania, subcampania, registro_plantacion, evento_plantacion` no falla.
- [ ] Aplicar la migración a producción una vez validada en staging.

---

## 4. Choques con el sistema actual

- **Ninguno esperado** según contexto del usuario (sin datos, sin consumidores).
- Si en producción alguna tabla legacy resulta tener datos inesperados, **detener el drop** y reabrir conversación. La operación es destructiva: una vez ejecutado el `DROP TABLE` no hay vuelta atrás sin restaurar backup.

---

## 5. Archivos a tocar

- Nuevo: `Backend-r3foresta/migrations/033_drop_legacy_plantacion.sql`.
- Documentación: ninguna actualización adicional. El esquema canónico (`database/00_database_schema.md`) ya fue limpiado del boceto legacy en el commit que cerró la tarea 11 (2026-05-24).

---

## 6. Pendientes derivados

Ninguno. Esta tarea es autocontenida.
