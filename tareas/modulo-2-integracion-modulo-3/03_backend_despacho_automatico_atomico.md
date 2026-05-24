# Tarea 03 — Generación atómica de `DESPACHO` desde M3

**Área:** Backend
**Severidad:** Crítica
**Depende de:** 01, 02, **10** (decisiones M3 en docs), **11** (modelado físico de M3 en BD)
**Bloquea a:** 06
**Referencias:** Addendum secciones 3.3, 4.3, 5, 13.3, 13.4, 13.5

---

## 0. Prerequisitos descubiertos durante el intento de implementación

Al intentar implementar esta tarea (conversación 2026-05-24), el backend encontró que **las tablas de M3 no existen todavía en BD**. El handler atómico necesita escribir FKs hacia `subcampania_id`, `campania_id` y `registro_plantacion_id` reales, lo que disparó 6 preguntas de diseño (M1 a M6). Esas 6 preguntas se convirtieron en dos tareas prerequisito:

1. **[Tarea 10](./10_docs_flujo_reposicion_y_mortandad.md)** — Cerrar 6 decisiones de diseño en documentación (COORDINADOR como membresía, mix de especies fuera de MVP, estado de campaña derivado, reposición libre de especie, mortandad multi-rol, UX pre-confirmación).
2. **[Tarea 11](./11_db_modelado_m3_base.md)** — Modelar físicamente las tablas base de M3 en BD respetando las decisiones de la 10 (`CAMPANIA`, `SUBCAMPANIA`, `SUBCAMPANIA_EQUIPO`, `REGISTRO_PLANTACION`, `REGISTRO_PLANTACION_DETALLE`, `REGISTRO_PLANTACION_CORESPONSABLE`, `EVENTO_PLANTACION`, vista `campania_estado`, función `gps_dentro_poligono_con_tolerancia`).

Esta tarea 03 queda **bloqueada** hasta que la 10 y la 11 estén aplicadas. Una vez aplicadas:
- Los FKs hacia `subcampania`, `campania` y `registro_plantacion` resuelven correctamente.
- El handler puede llenar `registro_plantacion_detalle.evento_lote_vivero_despacho_id` con el id del `DESPACHO` automático generado.
- El handler puede usar `gps_dentro_poligono_con_tolerancia(subcampania_id, lat, lng)` para la validación GPS.
- La validación de permisos del responsable cambia: en lugar de revisar el rol global, el handler verifica que `responsable_id ∈ SUBCAMPANIA_EQUIPO` de la subcampaña destino.

---

## 1. Contexto

Cada `PLANTACION_INICIAL` o `REPOSICION` registrada en M3 debe disparar atómicamente la creación de uno o más eventos `DESPACHO` en `EVENTO_LOTE_VIVERO` (uno por cada lote afectado), con `origen_despacho = AUTOMATICO_PLANTACION`. Esto descuenta el saldo vivo del lote real y deja la trazabilidad cerrada.

**No puede haber un registro de plantación sin sus despachos correspondientes, ni viceversa.** Si algo falla, todo se revierte.

---

## 2. Cambio requerido

### 2.1. Endpoint / use case

Al guardar `REGISTRO_PLANTACION` (sea `es_reposicion = false` o `true`), el handler ejecuta dentro de **una sola transacción de base de datos**:

1. Validaciones de M3 (subcampaña activa, GPS dentro de polígono, mix permitido, etc.).
2. Validaciones contra asignaciones:
   - Para cada `(lote_vivero_id, especie, cantidad)`, existe una asignación activa con propósito coherente (`PLANTACION_INICIAL` o `REPOSICION`).
   - `cantidad_solicitada <= saldo_asignado_disponible` de esa asignación.
3. Inserta `REGISTRO_PLANTACION`.
4. Por cada lote afectado:
   - `update asignacion_vivero_subcampania set cantidad_consumida = cantidad_consumida + N where id = ?`.
   - `insert into evento_lote_vivero` con:
     - `tipo_evento = 'DESPACHO'`
     - `origen_despacho = 'AUTOMATICO_PLANTACION'`
     - `destino_tipo = 'PLANTACION_CAMPANIA'`
     - `subcampania_id`, `campania_id`, `registro_plantacion_id` poblados
     - `comunidad_destino_id` = `subcampania.zona_id`
     - `unidad_medida_evento = 'UNIDAD'`
     - `cantidad_afectada` = cantidad de ese lote
     - `responsable_id` = `registro_plantacion.responsable_id`
     - `fecha_evento` = `registro_plantacion.fecha_plantacion`
   - El trigger existente de `evento_lote_vivero` debe actualizar `saldo_vivo_actual` del lote.
5. Vincula evidencia fotográfica al `REGISTRO_PLANTACION`.
6. Commit. Si algo falla en cualquier paso, rollback completo.

### 2.2. Invariante post-commit

```txt
SUM(evento_lote_vivero.cantidad_afectada
    where registro_plantacion_id = X
      and tipo_evento = 'DESPACHO'
      and origen_despacho = 'AUTOMATICO_PLANTACION')
= registro_plantacion.cantidad_total_plantada
```

Test de integración debe verificarlo.

### 2.3. Concurrencia

`SELECT ... FOR UPDATE` sobre las filas de `asignacion_vivero_subcampania` involucradas, para evitar dos plantaciones simultáneas que sobrepasen el saldo asignado.

```sql
select id, saldo_asignado_disponible
  from asignacion_vivero_subcampania
 where id = any($1::bigint[])
 for update;
```

### 2.4. Evidencia heredada

El `DESPACHO` automático **no exige fotos propias** en `EVIDENCIAS_TRAZABILIDAD` con `tipo_entidad = EVENTO_LOTE_VIVERO`. Las fotos viven con `tipo_entidad = REGISTRO_PLANTACION`. El backend que muestre el historial del lote debe **buscar evidencia por el `registro_plantacion_id`** del despacho cuando `origen_despacho = AUTOMATICO_PLANTACION`. Eso es trabajo del frontend (tarea 07) pero el contrato lo fija esta tarea.

**Validación previa:** si el `REGISTRO_PLANTACION` no tiene al menos 1 foto válida, **la transacción no debe llegar al `commit`**. La validación de evidencia es parte del paso 1 (validaciones M3).

---

## 3. Criterios de aceptación

- [ ] Insertar una plantación con 3 lotes diferentes produce exactamente 3 eventos `DESPACHO` (uno por lote) en la misma transacción.
- [ ] Si una de las asignaciones tiene saldo insuficiente, ningún despacho se inserta ni el registro de plantación.
- [ ] El `saldo_vivo_actual` del lote disminuye en la cantidad correcta tras el commit (delega al trigger existente del M2).
- [ ] `cantidad_consumida` de la asignación correspondiente aumenta en la cantidad correcta.
- [ ] Dos plantaciones concurrentes contra el mismo lote no pueden sobrepasar el saldo asignado (validar con test de concurrencia).
- [ ] Un `REGISTRO_PLANTACION` sin fotos válidas falla antes de insertar despachos.
- [ ] Una reposición solo puede consumir asignaciones con `proposito = 'REPOSICION'`.
- [ ] Una plantación inicial solo puede consumir asignaciones con `proposito = 'PLANTACION_INICIAL'`.

---

## 4. Choques con el sistema actual

- **Tipo de evento `DESPACHO` ya existe** en `EVENTO_LOTE_VIVERO`. El trigger que recalcula `saldo_vivo_actual` debe seguir funcionando sin modificación, porque la diferencia entre manual y automático es solo el `origen_despacho`. **Validar** que el trigger no asume `origen_despacho = MANUAL`.
- **API de creación de DESPACHO manual del M2** debe seguir aceptando `origen_despacho = 'MANUAL'` por default y **rechazar** explícitamente cualquier intento de pasar `'AUTOMATICO_PLANTACION'` por esa vía. Solo el handler del M3 debe poder generarlo.
- **Permisos:** validar que el `responsable_id` del `REGISTRO_PLANTACION` está en `SUBCAMPANIA_EQUIPO` de la subcampaña destino (con `rol_en_subcampania = 'COORDINADOR'` o `'OPERARIO'`). No se hereda del rol global del usuario ni del rol "operario de vivero" — el permiso es contextual a la subcampaña. Para co-responsables, mismo criterio: deben ser subset de `SUBCAMPANIA_EQUIPO`.

---

## 5. Archivos a tocar

- Backend del módulo M3: handler de creación de plantación.
- Backend M2: revisar API de creación manual de despachos para rechazar `AUTOMATICO_PLANTACION`.
- Tests de integración nuevos: `despacho_automatico.spec.ts` (o equivalente).
