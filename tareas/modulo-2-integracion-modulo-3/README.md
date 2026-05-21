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
| [01](./01_db_migraciones_esquema.md) | Migraciones de esquema (enums + columnas + constraints) | DB | Crítica | 02, 03, 04, 05 |
| [02](./02_db_tabla_asignacion_vivero_subcampania.md) | Crear tabla `ASIGNACION_VIVERO_SUBCAMPANIA` | DB | Crítica | 03, 04, 05 |
| [03](./03_backend_despacho_automatico_atomico.md) | Generación atómica de `DESPACHO` desde M3 | Backend | Crítica | 06 |
| [04](./04_backend_politica_mermas_fifo.md) | Política FIFO de mermas sobre asignaciones | Backend | Importante | 07 |
| [05](./05_backend_saldos_derivados.md) | Cálculo de `saldo_vivo_disponible_asignacion` y `saldo_asignado_disponible` | Backend | Importante | 06 |
| [06](./06_frontend_vista_operativa_lotes.md) | Vista operativa de lotes con columnas derivadas | Frontend | Mejora | — |
| [07](./07_frontend_historial_diferenciado.md) | Historial de lote: diferenciar manual vs automático + evidencia heredada | Frontend | Importante | — |
| [08](./08_notificaciones_merma_coordinador.md) | Notificación al coordinador por merma sobre asignación | Backend + Frontend | Importante | 04 |
| [09](./09_docs_integrar_addendum_a_modulo_2.md) | Integrar addendum al MD y JSON oficiales del Módulo 2 | Docs | Mejora | — |

---

## Orden recomendado de ejecución

```
01 (esquema base)
   ├── 02 (tabla nueva)
   │     └── 03 (despacho atómico)
   │           └── 06 (UI lectura)
   ├── 04 (mermas FIFO)
   │     └── 08 (notificaciones)
   └── 05 (saldos derivados)
         └── 06 / 07 (UI lectura)

09 (docs) puede ir en paralelo con cualquiera
```

---

## Decisiones cerradas (no rediscutir)

- `PLANTACION_CAMPANIA` se escribe sin `Ñ` por compatibilidad técnica.
- `cantidad_asignada` es **inmutable** una vez creada la asignación; las mermas y consumos van a campos separados.
- Las devoluciones desde M3 **no generan evento** en `EVENTO_LOTE_VIVERO`.
- El despacho automático **hereda evidencia** del `REGISTRO_PLANTACION` asociado; no requiere fotos propias.
- Las mermas afectan asignaciones por **FIFO** (asignación más antigua primero).
- El saldo disponible para asignar es **derivado**, no persistido como fuente de verdad.

---

## Decisiones todavía abiertas

- ¿`estado_asignacion` incluye `AFECTADA_POR_MERMA` como valor de enum, o se maneja como badge derivado de `cantidad_mermada > 0`? (Ver tarea 02.)
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

Al cerrar una tarea, actualizar la tabla resumen arriba con el estado (✅ Hecha / 🚧 En curso / ⏸️ Bloqueada).
