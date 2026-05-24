# Tarea 10 — Cerrar decisiones M3 en documentación

**Área:** Docs
**Severidad:** Importante
**Bloquea a:** tarea 11 (modelado físico de M3 en BD) → tarea 03 (despacho automático)
**Referencias:** [plantacion-module/02_Procesos_Modulo_3_Plantacion.md](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md), [vivero-module/01_regas_de_negocio_vivero.md](../../vivero-module/01_regas_de_negocio_vivero.md), [CLAUDE.md](../../CLAUDE.md)

---

## 0. Origen de esta tarea

Esta tarea nació a partir de las **6 preguntas que el backend planteó al intentar implementar la [tarea 03](./03_backend_despacho_automatico_atomico.md)** (Generación atómica de `DESPACHO` desde M3). El handler atómico de tarea 03 escribe en `EVENTO_LOTE_VIVERO` con FKs hacia `subcampania_id`, `campania_id` y `registro_plantacion_id`. Cuando backend fue a implementarlo, descubrió que esas tablas de M3 **no existen todavía** y que varias decisiones de diseño estaban abiertas.

Las 6 preguntas (M1 a M6) se mapearon así:

| # | Pregunta del backend | Decisión cerrada |
|---|----------------------|------------------|
| M1 | ¿Campos mínimos de `CAMPANIA`? | Estado derivado, no persistido; FK N:M con `ORGANIZACION` vía `CAMPANIA_ORGANIZACION` |
| M2 | ¿`zona_id` FK a `DIVISION_ADMINISTRATIVA` o tabla nueva? | FK directo a `DIVISION_ADMINISTRATIVA`, sin tabla nueva |
| M3 | ¿`REGISTRO_PLANTACION` + tabla detalle? | Sí; además `CORESPONSABLE` y `EVENTO_PLANTACION` para mortandad/devolución |
| M4 | ¿Validación GPS con PostGIS o turf.js? | PostGIS en BD como fuente de verdad; turf opcional en frontend para UX |
| M5 | ¿Tabla de mix de especies permitidas? | **No hay mix en MVP** (decisión cerrada aquí) |
| M6 | ¿Rol nuevo `COORDINADOR` o usar existentes? | **COORDINADOR como membresía** vía `SUBCAMPANIA_EQUIPO`, no rol global (Opción B) |

El **modelado físico** de estas tablas vive en la [tarea 11](./11_db_modelado_m3_base.md). Esta tarea 10 se encarga **solo** de las decisiones que tienen que existir en documentación antes de modelar físicamente.

---

## 1. Contexto

Durante el análisis de cómo modelar M3 en BD (conversaciones 2026-05-23 y 2026-05-24) aparecieron varias decisiones abiertas y divergencias entre la doc canónica y lo que se va a implementar. Esta tarea las cierra todas en documentación, en un solo lote, **antes** de empezar a crear tablas para M3.

Decisiones que esta tarea cierra:

1. **Reposición**: cualquier especie permitida en MVP. (RN nueva)
2. **Mortandad**: reportable por operario, coordinador o admin. (Aclaración)
3. **UX de pre-confirmación**: mostrar mortandad pendiente al reponer.
4. **Rol COORDINADOR**: se cierra como **membresía por subcampaña** (Opción B), no como rol global.
5. **Mix de especies**: **fuera del MVP**. Se posterga a futuro.
6. **Estado de campaña**: derivado en tiempo real, **no persistido**. (Reafirmación + invariante explícito en CLAUDE.md)

---

## 2. Cambios requeridos en documentación

### 2.1. RN-VIV-60 — Reposición no exige misma especie que el grupo origen

Agregar al final de la sección 13 de [vivero-module/01_regas_de_negocio_vivero.md](../../vivero-module/01_regas_de_negocio_vivero.md):

> ### RN-VIV-60 — Reposición no exige misma especie que el grupo origen
>
> * **Severidad:** ADVERTENCIA
> * **Aplica en MVP:** Sí
> * **Relevancia carbono:** Media
>
> Una reposición puede usar stock de cualquier especie disponible en una asignación con propósito `REPOSICION`. No se exige que coincida con la especie del grupo plantado origen. El sistema registra la especie real en el evento `REPOSICION` y el grupo plantado puede quedar con composición mixta. Esta política es revisable post-MVP si la certificación de carbono exige homogeneidad por grupo.

### 2.2. UX del operario al reponer (pre-confirmación)

Agregar a [02_Procesos_Modulo_3_Plantacion.md §3.10](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md):

> Antes de confirmar una reposición, el sistema debe mostrar al operario el estado del grupo origen:
>
> - `cantidad_plantada_inicial`
> - `cantidad_muerta_acumulada`
> - `cantidad_repuesta_acumulada`
> - `cantidad_pendiente_reposicion = cantidad_muerta_acumulada − cantidad_repuesta_acumulada`
>
> Si la cantidad ingresada por el operario excede `cantidad_pendiente_reposicion`, se bloquea el registro con mensaje claro.

### 2.3. Roles que pueden reportar mortandad

Aclarar en [02_Procesos_Modulo_3_Plantacion.md §3.9](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md):

> El reporte de mortandad lo puede registrar:
>
> - Cualquier **operario** miembro del equipo de la subcampaña.
> - El **COORDINADOR** de la subcampaña (membresía, ver §2.10).
> - **ADMIN**.
>
> No hay diferencias de permisos entre ellos para este evento.

### 2.4. UX al reportar mortandad — confirmar alcance

§3.9 ya dice "muestra al operario el histórico del grupo antes de confirmar". Aclarar que el bloque se muestra **a todos los roles** habilitados (operario, COORDINADOR, ADMIN), no solo al operario.

### 2.5. Cierre de decisión abierta — COORDINADOR como membresía por subcampaña (Opción B)

**Decisión cerrada 2026-05-24:** el rol `COORDINADOR` **no se agrega** al enum global `rol_usuario`. La coordinación de una subcampaña se modela como **membresía** en la tabla puente `SUBCAMPANIA_EQUIPO` con un campo `rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`. Una subcampaña tiene exactamente un COORDINADOR.

Justificación:
- Preserva el invariante "Roles MVP: catálogo cerrado ADMIN | GENERAL | VALIDADOR | VOLUNTARIO" (CLAUDE.md).
- Un usuario puede ser COORDINADOR de Cota Cota y OPERARIO de San Miguel simultáneamente, sin tocar su rol global.
- Cuando una subcampaña termina, no hay que cambiar el rol global del usuario.

Cambios concretos:

- **[02_Procesos_Modulo_3_Plantacion.md §12 Roles](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md)**: reformular el bullet de COORDINADOR. Reemplazar:
  > "**COORDINADOR (rol nuevo):** gestiona sus subcampañas asignadas..."

  por:
  > "**COORDINADOR (membresía por subcampaña, no rol global):** cualquier USUARIO con rol global `GENERAL`, `ADMIN` o `VALIDADOR` puede ser COORDINADOR de una subcampaña a través de `SUBCAMPANIA_EQUIPO.rol_en_subcampania = 'COORDINADOR'`. Gestiona sus subcampañas asignadas (asignaciones, equipo, devoluciones) y también puede operar como operario. Una subcampaña tiene exactamente un COORDINADOR; un usuario puede ser COORDINADOR de varias subcampañas distintas y/o OPERARIO en otras."

- **[02_Procesos_Modulo_3_Plantacion.md §2.10 Equipo de la subcampaña](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md)**: aclarar que el equipo se modela en `SUBCAMPANIA_EQUIPO` con `rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`, constraint de "exactamente 1 COORDINADOR por subcampaña".

- **[CLAUDE.md](../../CLAUDE.md) sección "Invariantes de dominio a respetar"**:
  - Quitar el bullet abierto: "**Plantación — rol `COORDINADOR` pendiente**".
  - Agregar invariante nuevo: "**Plantación — COORDINADOR es membresía, no rol global.** El catálogo cerrado de `rol_usuario` (ADMIN | GENERAL | VALIDADOR | VOLUNTARIO) se mantiene. La coordinación vive en `SUBCAMPANIA_EQUIPO.rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`. Una subcampaña tiene exactamente un COORDINADOR; un usuario puede ser COORDINADOR de N subcampañas y simultáneamente OPERARIO en otras."

### 2.6. Mix de especies fuera del MVP

**Decisión cerrada 2026-05-24:** el control de mix de especies con topes porcentuales por subcampaña **no se implementa en MVP**. Se posterga a futuro. La composición de especies se sigue registrando (cada plantación lleva su especie en el detalle), pero no hay validación de topes contra plan.

Cambios concretos:

- **[02_Procesos_Modulo_3_Plantacion.md §2.12](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md)**: reemplazar la sección entera por:
  > "### 2.12. Mix de especies (fuera del MVP)
  >
  > El control de mix de especies con topes porcentuales por subcampaña queda fuera del MVP. La composición real de especies se registra a través de los detalles de cada `REGISTRO_PLANTACION`, pero no hay validación contra un plan ni advertencias por exceso de tope. Se incorpora en una fase posterior."

- **[02_Procesos_Modulo_3_Plantacion.md §3.3 Activación de la subcampaña](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md)**: quitar la validación "Mix de especies definido (al menos una especie con tope > 0)".

- **[02_Procesos_Modulo_3_Plantacion.md §3.6 paso 3](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md)**: quitar "Verifica que las especies estén en el mix permitido. Si exceden tope %, advierte pero permite."

- **[02_Procesos_Modulo_3_Plantacion.md §13 MVP incluye](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md)**: quitar "Mix de especies por subcampaña con topes %".

- **[02_Procesos_Modulo_3_Plantacion.md §13 Futuro](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md)**: agregar "Mix de especies por subcampaña con topes porcentuales y validación contra plan."

- **[00_Requerimientos_Modulo_3_Plantacion.json](../../plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json)**: revisar y eliminar/marcar como futuro cualquier requerimiento (`RF-PLT-*`) que mencione mix de especies o topes porcentuales.

### 2.7. Estado de campaña: derivado, no persistido (elevar a invariante)

**Decisión confirmada 2026-05-24:** `CAMPANIA` **no persiste estado**. Su estado se calcula al leer desde el conjunto de sus subcampañas. Esto ya está en [§2.2 y §5.3](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md) pero no es un invariante explícito en CLAUDE.md.

Cambios concretos:

- **[CLAUDE.md](../../CLAUDE.md) sección "Invariantes de dominio a respetar"**: agregar invariante nuevo: "**Plantación — Estado de campaña derivado, no persistido.** `CAMPANIA` no tiene columna de estado. Su estado (`BORRADOR | ACTIVA | EN_MANTENIMIENTO | MONITOREO_HISTORICO`) se deriva al leer desde el conjunto de sus subcampañas según las reglas de §2.2 y §5.3 del Módulo 3. Cualquier diseño de BD que materialice estado de campaña como columna está prohibido."

---

## 3. Criterios de aceptación

- [ ] `RN-VIV-60` agregada al final de la sección 13 de `01_regas_de_negocio_vivero.md`.
- [ ] `02_Procesos_Modulo_3_Plantacion.md §3.10` documenta elección libre de especie en reposición.
- [ ] `02_Procesos_Modulo_3_Plantacion.md §3.10` documenta UX pre-confirmación (cuatro datos).
- [ ] `02_Procesos_Modulo_3_Plantacion.md §3.9` aclara que mortandad puede reportarla operario, COORDINADOR o ADMIN.
- [ ] `02_Procesos_Modulo_3_Plantacion.md §12` redefine COORDINADOR como membresía por subcampaña.
- [ ] `02_Procesos_Modulo_3_Plantacion.md §2.10` describe `SUBCAMPANIA_EQUIPO` con rol contextual y constraint "1 COORDINADOR por subcampaña".
- [ ] `02_Procesos_Modulo_3_Plantacion.md §2.12` marcado como fuera de MVP.
- [ ] `02_Procesos_Modulo_3_Plantacion.md §3.3` y §3.6 sin referencias a validación de mix.
- [ ] `02_Procesos_Modulo_3_Plantacion.md §13` mueve mix de "MVP incluye" a "Futuro".
- [ ] `00_Requerimientos_Modulo_3_Plantacion.json` revisado: requerimientos de mix marcados/eliminados.
- [ ] `CLAUDE.md` actualizado: COORDINADOR cerrado en lugar de pendiente; invariante de "estado de campaña derivado" agregado.
- [ ] Numeración de reglas estable: ninguna existente renumerada.

---

## 4. Choques con la documentación actual

- **Mix de especies**: aparece hoy en M3 como parte del MVP (§2.12, §3.3, §3.6, §13). Quitarlo reduce scope; no rompe coherencia interna pero baja expectativas de validación.
- **COORDINADOR**: hoy aparece en M3 §12 como "rol nuevo" sin definir si global o local. Esta tarea lo redefine como local (membresía), consistente con el invariante de roles cerrados de CLAUDE.md. **Esto invalida cualquier propuesta de schema que use `coordinador_id` como FK directo a `USUARIO`** — el modelo correcto pasa por `SUBCAMPANIA_EQUIPO`.
- **Estado de campaña**: el doc ya lo dice derivado; la tarea solo lo eleva a invariante explícito en CLAUDE.md para que no se materialice por error.
- **Reposición libre de especie**: contradice la noción agronómica típica de "reponer con la misma especie", pero es decisión consciente del MVP.

---

## 5. Archivos a tocar

- `vivero-module/01_regas_de_negocio_vivero.md` — agregar `RN-VIV-60`.
- `plantacion-module/02_Procesos_Modulo_3_Plantacion.md` — múltiples secciones: §2.10, §2.12, §3.3, §3.6, §3.9, §3.10, §12, §13.
- `plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json` — revisar y limpiar referencias a mix de especies.
- `CLAUDE.md` — cerrar "COORDINADOR pendiente", agregar dos invariantes nuevos (COORDINADOR membresía, estado de campaña derivado).

---

## 6. Pendientes derivados (afectan el modelado de M3 en BD)

Cuando se modele M3 en BD, estos puntos deben respetarse:

- **`SUBCAMPANIA_EQUIPO`** reemplaza el FK directo `coordinador_id` en `SUBCAMPANIA`. Schema sugerido:

  ```
  SUBCAMPANIA_EQUIPO {
    bigint id PK
    bigint subcampania_id FK
    bigint usuario_id FK
    ENUM(rol_en_subcampania) rol  -- COORDINADOR | OPERARIO
    timestamptz agregado_at
    bigint agregado_by FK
    unique (subcampania_id, usuario_id)
    -- partial unique index: exactamente 1 COORDINADOR por subcampania
    -- create unique index on subcampania_equipo(subcampania_id) where rol = 'COORDINADOR'
  }
  ```

- **`CAMPANIA_ORGANIZACION`** como tabla puente N:M (ya está en doc M3 §2.3).

- **`REGISTRO_PLANTACION_CORESPONSABLE (registro_plantacion_id, usuario_id)`** como tabla puente. Validación: `usuario_id ∈ SUBCAMPANIA_EQUIPO` de la subcampaña del registro.

- **Tabla de eventos M3** (mortandad, asignación, devolución): unificada (`EVENTO_PLANTACION` con `tipo_evento`) o separada por tipo. La doc M3 §4.2 sugiere unificada; alinear con el patrón de `EVENTO_LOTE_VIVERO`.

- **`CAMPANIA` sin columna de estado**: estado se calcula al leer.

- **Sin validación de mix de especies** en handlers de plantación.

- **Bloque informativo pre-confirmación** en UI tanto para mortandad como para reposición.

---

## Resultado

**Fecha de cierre:** 2026-05-24
**Estado:** ✅ Hecha

### Qué se hizo

- **`vivero-module/01_regas_de_negocio_vivero.md`:** agregada `RN-VIV-60` al final de la sección 13 (reposición no exige misma especie que el grupo origen — ADVERTENCIA / MVP / Relevancia carbono Media). Numeración preservada.
- **`plantacion-module/02_Procesos_Modulo_3_Plantacion.md`:** reescritura de las secciones afectadas:
  - §2.1: removida la mención a "mix de especies" en la descripción de subcampaña; reemplazada por un puntero a §2.12 con la decisión.
  - §2.10: reescrita completa. Equipo modelado como `SUBCAMPANIA_EQUIPO` con `rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`. Constraint partial unique "1 COORDINADOR por subcampaña". Co-responsables ahora subset de `SUBCAMPANIA_EQUIPO`.
  - §2.12: convertida en "Mix de especies (fuera del MVP)" con justificación y puntero a esta tarea.
  - §3.2: ajustado dato "Coordinador asignado" para reflejar membresía via `SUBCAMPANIA_EQUIPO`. Quitada línea "Mix de especies con topes porcentuales".
  - §3.3: quitada la validación de mix. Validación de coordinador alineada a `SUBCAMPANIA_EQUIPO`.
  - §3.6: renumerados los pasos (5 a 9). Quitado paso 3 de validación de mix. Agregado puntero a `gps_dentro_poligono_con_tolerancia` como fuente PostGIS. Corregido `PLANTACION_CAMPAÑA` → `PLANTACION_CAMPANIA` (sin ñ, alineado a decisión cerrada). Evidencia heredada al `REGISTRO_PLANTACION` con cita a `RN-VIV-54`.
  - §3.9: agregada lista explícita de quién puede reportar mortandad (OPERARIO miembro del equipo, COORDINADOR de la subcampaña, ADMIN). Aclarado que la UX informativa se muestra a los tres roles. Evento referenciado como `MORTANDAD_REPORTADA` en `EVENTO_PLANTACION`.
  - §3.10: agregado bullet "Especie libre" con cita a `RN-VIV-60`. Bloque "UX de pre-confirmación obligatoria" con los cuatro datos y regla de bloqueo (no advertencia).
  - §11: cambiada "mix de especies real vs planificado" por "composición real de especies plantadas" (la primera asume un plan que el MVP no tiene).
  - §12: reescrita completa. Catálogo cerrado `ADMIN | GENERAL | VALIDADOR | VOLUNTARIO` preservado. COORDINADOR redefinido como membresía, con constraint partial unique en BD y compatibilidad con múltiples subcampañas. `VOLUNTARIO` explícitamente sin permisos operativos en M3.
  - §13: removidos del MVP "Mix de especies por subcampaña con topes %"; agregado a "Futuro" como "Mix de especies por subcampaña con topes porcentuales y validación contra plan".
- **`plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json`:** mismo tratamiento aplicado al JSON estructurado:
  - `RF-PLA-01`: validación "no tiene poligono, meta ni mix propios" → "no tiene poligono ni meta propios".
  - `RF-PLA-02`: coordinador y equipo redefinidos como membresía; campo "Mix de especies con tope porcentual por especie" eliminado; validación "suma de topes <= 100%" eliminada; validación de coordinador alineada al constraint de BD.
  - `RF-PLA-03`: validación de mix eliminada; coordinador validado como `SUBCAMPANIA_EQUIPO`.
  - `RF-PLA-06`: eliminadas validaciones de mix (pertenencia al mix permitido y advertencia por tope %).
  - `RF-PLA-10` (reposición): "Validaciones de GPS, poligono y mix idénticas" → "GPS y poligono idénticas (PostGIS via gps_dentro_poligono_con_tolerancia)". Agregadas: "Especie libre" con cita a RN-VIV-60, responsable validado contra `SUBCAMPANIA_EQUIPO`, y UX pre-confirmación obligatoria con bloqueo.
  - `RF-PLA-15`: "mix de especies real vs planificado" → "composición real de especies plantadas".
  - JSON re-validado con `python3 -c "import json; json.load(...)"`.
- **`CLAUDE.md`:**
  - Eliminado el bullet "Plantación — rol `COORDINADOR` pendiente" del bloque de invariantes.
  - Agregados cinco invariantes nuevos en el mismo bloque, en orden:
    1. "Plantación — COORDINADOR es membresía, no rol global."
    2. "Plantación — Estado de campaña derivado, no persistido."
    3. "Plantación — Mix de especies fuera del MVP."
    4. "Plantación — Reposición libre de especie (`RN-VIV-60`)."
    5. "Plantación — Validación GPS con PostGIS como fuente de verdad."

### Desviaciones del spec original

- **Más invariantes en CLAUDE.md de los pedidos.** El spec sólo pedía dos (COORDINADOR + estado derivado); se agregaron tres adicionales (mix fuera del MVP, reposición libre de especie, PostGIS como fuente de verdad) porque son decisiones cerradas en esta misma tarea con riesgo real de regresión si futuros diseños las olvidan. Mantener el invariante explícito es más barato que perseguir el error después.
- **§3.6 (M3): corrección colateral del valor de enum.** El doc decía `destino_tipo = PLANTACION_CAMPAÑA` (con ñ); migración 023 y el README de tareas tienen como decisión cerrada que el valor es `PLANTACION_CAMPANIA` (sin ñ, por compatibilidad técnica). Se aprovechó la edición para corregirlo. No estaba listado en los criterios de aceptación pero era un bug latente que iba a generar choque al implementar.
- **§3.6 (M3): renumeración de pasos.** El paso 3 (validar mix) se eliminó; los pasos posteriores se renumeraron (5 a 9). El spec sólo pedía "quitar la validación", pero dejarla con un hueco numérico (1, 2, 4, 5, 6...) era ruido visual evitable.

### Decisiones nuevas tomadas durante la implementación

- **`VOLUNTARIO` no puede ser miembro de `SUBCAMPANIA_EQUIPO`** (escrito explícito en §12). El spec no lo decía, pero al redefinir COORDINADOR como membresía habilitada a `GENERAL | ADMIN | VALIDADOR` quedó implícito que `VOLUNTARIO` queda fuera. Cerrar la duda ahora para no abrir una nueva discusión al implementar la tarea 11.
- **El campo `destino_referencia` en el DESPACHO automático no se usa como FK directo a `REGISTRO_PLANTACION.id`.** El spec original de §3.6 lo escribía como `destino_referencia = REGISTRO_PLANTACION.id`, pero el modelo correcto (consistente con migración 023 + 025) es usar la columna `registro_plantacion_id` poblada como FK. `destino_referencia` queda como texto descriptivo (heredado de M2) — cuando es automático se puede dejar NULL o con un texto humano-legible. Aclarado en el doc M3 §3.6.

### Pendientes derivados (alimentan tarea 11)

- `SUBCAMPANIA_EQUIPO` con índice único parcial `(subcampania_id) WHERE rol = 'COORDINADOR'`.
- `CAMPANIA` sin columna de estado; vista `campania_estado` derivada.
- `REGISTRO_PLANTACION_CORESPONSABLE` como tabla puente con validación de subset contra `SUBCAMPANIA_EQUIPO` en el handler.
- Validación de equipo del responsable de `REGISTRO_PLANTACION` y del responsable de `EVENTO_PLANTACION` (mortandad) en el handler, no en BD.
- Sin tabla `subcampania_especie_permitida`.
- `gps_dentro_poligono_con_tolerancia(subcampania_id, lat, lng)` como función SQL en M3.

### Referencias

- Commit: pendiente (será un commit único en `r3foresta-docs/` con todos los cambios de esta tarea).
- Tareas que se desbloquean: [tarea 11](./11_db_modelado_m3_base.md) — modelado físico de M3 en BD.
