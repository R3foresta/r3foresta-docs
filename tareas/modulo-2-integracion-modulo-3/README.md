# Tareas — Integración Módulo 2 (Vivero) con Módulo 3 (Plantación)

> **Contexto:** El Módulo 2 (Vivero) ya tiene backend y base de datos en producción. Para que el Módulo 3 (Plantación) pueda integrarse correctamente, se requieren las modificaciones documentadas en el [Addendum del Módulo 2](../../vivero-module/03_Addendum_Modulo_2_por_Modulo_3.md).
>
> Estas tareas son **migraciones / extensiones** sobre un sistema vivo. No son trabajo greenfield. Hay choques con el esquema y la lógica actual, por lo que cada tarea debe planificarse cuidadosamente.

---

## Fuente canónica

Toda la especificación funcional vive en [vivero-module/03_Addendum_Modulo_2_por_Modulo_3.md](../../vivero-module/03_Addendum_Modulo_2_por_Modulo_3.md). Si una tarea contradice al addendum, gana el addendum (o se actualiza explícitamente).

---

## Resumen de tareas

| # | Tarea | Área | Severidad | Bloquea a |
|---|-------|------|-----------|-----------|
| [01 ✅](./completadas/01_db_migraciones_esquema.md) | Migraciones de esquema (enums + columnas + constraints) | DB | Crítica | 02, 03, 04, 05 |
| [02 ✅](./completadas/02_db_tabla_asignacion_vivero_subcampania.md) | Crear tabla `ASIGNACION_VIVERO_SUBCAMPANIA` | DB | Crítica | 03, 04, 05 |
| [03](./03_backend_despacho_automatico_atomico.md) | Generación atómica de `DESPACHO` desde M3 | Backend | Crítica | 06 |
| [04](./04_backend_politica_mermas_fifo.md) | Política FIFO de mermas sobre asignaciones | Backend | Importante | 07 |
| [05](./05_backend_saldos_derivados.md) | Cálculo de `saldo_vivo_disponible_asignacion` y `saldo_asignado_disponible` | Backend | Importante | 06 |
| [06](./06_frontend_vista_operativa_lotes.md) | Vista operativa de lotes con columnas derivadas | Frontend | Mejora | — |
| [07](./07_frontend_historial_diferenciado.md) | Historial de lote: diferenciar manual vs automático + evidencia heredada | Frontend | Importante | — |
| [08](./08_notificaciones_merma_coordinador.md) | Notificación al coordinador por merma sobre asignación | Backend + Frontend | Importante | 04 |
| [09](./09_docs_integrar_addendum_a_modulo_2.md) | Integrar addendum al MD y JSON oficiales del Módulo 2 | Docs | Mejora | — |
| [10 ✅](./completadas/10_docs_flujo_reposicion_y_mortandad.md) | Cerrar decisiones M3 en docs: reposición libre de especie, mortandad multi-rol, UX pre-confirmación, COORDINADOR como membresía, sin mix de especies, estado campaña derivado | Docs | Importante | 11 |
| [11 ✅](./completadas/11_db_modelado_m3_base.md) | Modelar tablas base de M3 en BD: PostGIS + enums + CAMPANIA + SUBCAMPANIA + REGISTRO_PLANTACION + EVENTO_PLANTACION + vista de estado + función GPS | DB | Crítica | 03 |
| [12](./12_db_drop_legacy_plantacion.md) | Eliminar de BD el boceto legacy de plantación (tablas PLANTACION + PLANTACION_*) superado por el modelo M3 | DB | Mejora | — |

---

## Orden recomendado de ejecución

```
01 (esquema base)
   └── 02 (tabla asignacion)
         ├── 04 (mermas FIFO)
         │     └── 08 (notificaciones)
         └── 05 (saldos derivados)
               └── 06 / 07 (UI lectura)

10 (docs decisiones M3) ✅
   └── 11 (modelado M3 en BD) ✅
         └── 03 (despacho automático)
               └── 06 (UI lectura)

12 (drop legacy PLANTACION) puede ir en paralelo con cualquiera
09 (docs integrar addendum) puede ir en paralelo con cualquiera
```

**Por qué 03 ahora depende de 10 y 11:** al intentar implementar la tarea 03, backend descubrió que las tablas de M3 no existen y que varias decisiones de diseño estaban abiertas. Esas 6 preguntas se cristalizaron en las tareas 10 (decisiones en docs) y 11 (modelado físico). Ver el bloque "## 0. Origen" de tarea 10 y "## 0. Prerequisitos descubiertos" de tarea 03.

---

## Decisiones cerradas (no rediscutir)

- `PLANTACION_CAMPANIA` se escribe sin `Ñ` por compatibilidad técnica.
- `cantidad_asignada` es **inmutable** una vez creada la asignación; las mermas y consumos van a campos separados.
- Las devoluciones desde M3 **no generan evento** en `EVENTO_LOTE_VIVERO`.
- El despacho automático **hereda evidencia** del `REGISTRO_PLANTACION` asociado; no requiere fotos propias.
- Las mermas afectan asignaciones por **FIFO** (asignación más antigua primero).
- El saldo disponible para asignar es **derivado**, no persistido como fuente de verdad.
- `AFECTADA_POR_MERMA` **no es un valor de enum** en `estado_asignacion_vivero`; se expone como badge derivado cuando `cantidad_mermada > 0`. El enum queda con tres valores: `ACTIVA`, `AGOTADA`, `DEVUELTA`.

### Decisiones de M3 cerradas en conversación 2026-05-24 (propagadas vía [tarea 10 ✅](./completadas/10_docs_flujo_reposicion_y_mortandad.md))

- **COORDINADOR es membresía por subcampaña**, no rol global. Vive en `SUBCAMPANIA_EQUIPO.rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`. El catálogo cerrado de `rol_usuario` (ADMIN | GENERAL | VALIDADOR | VOLUNTARIO) se mantiene intacto. Una subcampaña tiene exactamente un COORDINADOR (constraint partial unique). `VOLUNTARIO` no puede ser miembro de `SUBCAMPANIA_EQUIPO`.
- **Mix de especies con topes porcentuales queda fuera del MVP.** No hay tabla `subcampania_especie_permitida` ni validación de topes. La composición real se registra en `REGISTRO_PLANTACION_DETALLE` pero no se valida contra plan.
- **`CAMPANIA` no persiste estado.** El estado se calcula al leer vía vista `campania_estado` desde el conjunto de subcampañas.
- **Reposición no exige misma especie** que el grupo origen en MVP (`RN-VIV-60`). UX pre-confirmación obligatoria con bloqueo si la cantidad excede `cantidad_pendiente_reposicion`. Revisable post-MVP.
- **Mortandad puede reportarla** cualquier OPERARIO o COORDINADOR (membresía de la subcampaña) o ADMIN. La UX informativa se muestra a los tres roles.
- **PostGIS es la fuente de verdad** para validación GPS dentro de polígono (función `gps_dentro_poligono_con_tolerancia`). Turf.js opcional en frontend solo para feedback visual.
- **`EVENTO_PLANTACION` unificada** (no tablas separadas por tipo). Sigue el patrón de `EVENTO_LOTE_VIVERO` de M2. Captura mortandad, devolución y registro de asignación; los registros de plantación inicial y reposición viven directamente en `REGISTRO_PLANTACION`.

---

## Decisiones todavía abiertas

- ¿`saldo_vivo_disponible_asignacion` se expone como vista SQL, como columna materializada con trigger, o como query en el endpoint? (Ver tarea 05.)
- ¿Las notificaciones por merma usan el sistema de notificaciones existente o uno nuevo? (Ver tarea 08.)

Estas se cierran al ejecutar la tarea correspondiente.

---

## Cómo trabajar una tarea

Cada archivo de tarea contiene:

1. **Contexto** — por qué existe esta tarea.
2. **Cambio requerido** — qué hay que hacer.
3. **Spec técnico** — cómo (con SQL/pseudocódigo cuando aplica).
4. **Criterios de aceptación** — cómo validar que está hecha.
5. **Choques con el sistema actual** — qué rompe, qué hay que migrar, qué hay que coordinar.
6. **Referencias** — sección exacta del addendum y requerimientos afectados.

---

## Flujo de cierre de una tarea

**Importante:** Claude no ve el código de los repos de implementación. El usuario implementa la tarea en su repo y le pasa un resumen del resultado. A partir de ahí, Claude cierra el ciclo.

### Pasos al terminar una tarea

1. **El usuario reporta** que la tarea está aplicada y comparte un resumen: qué se hizo, qué se desvió del spec, qué quedó pendiente, qué decisiones nuevas se tomaron, links a commits/PRs si existen.

2. **Claude agrega un bloque `## Resultado` al final del archivo de tarea** con esta estructura:

   ```markdown
   ---

   ## Resultado

   **Fecha de cierre:** YYYY-MM-DD
   **Estado:** ✅ Hecha

   ### Qué se hizo
   - …

   ### Desviaciones del spec original
   - …

   ### Decisiones nuevas tomadas durante la implementación
   - …

   ### Pendientes derivados (si los hay)
   - …

   ### Referencias
   - Commit / PR: …
   ```

3. **Claude actualiza la tabla de la sección "Resumen de tareas"** de este README marcando la tarea con ✅ y cambiando el link para apuntar a `./completadas/NN_*.md`.

4. **Claude mueve el archivo** a `./completadas/` dentro de esta misma carpeta, preservando el nombre original. Ej: `01_db_migraciones_esquema.md` → `completadas/01_db_migraciones_esquema.md`.

5. **Claude propaga a documentación canónica** los cambios que afecten dominio: JSON de requerimientos, MD de reglas, esquema ER, addendum, decisiones cerradas/abiertas.

6. **Si la tarea cerró una "decisión abierta"** listada en este README, Claude la mueve a "Decisiones cerradas" con la justificación.

### Estados posibles

- 🆕 Pendiente — sin empezar
- 🚧 En curso — el usuario está implementando
- ⏸️ Bloqueada — depende de algo no listo (anotar qué)
- ✅ Hecha — cerrada con bloque de Resultado
- ❌ Descartada — decidimos no hacerla (anotar por qué)

### Por qué este protocolo

El objetivo es que cualquier futura conversación (o cualquier persona que entre al repo) pueda reconstruir el estado real del proyecto leyendo solo los archivos, sin depender de la memoria de la conversación. Claude es el cerebro que mantiene esa coherencia.
