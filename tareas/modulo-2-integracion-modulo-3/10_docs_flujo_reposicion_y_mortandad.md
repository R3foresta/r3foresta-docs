# Tarea 10 — Documentar correctamente flujo de reposición y reporte de mortandad

**Área:** Docs
**Severidad:** Importante
**Bloquea a:** modelado de M3 en BD (cuando se aborde)
**Referencias:** [plantacion-module/02_Procesos_Modulo_3_Plantacion.md §3.9 y §3.10](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md), [vivero-module/01_regas_de_negocio_vivero.md RN-VIV-58](../../vivero-module/01_regas_de_negocio_vivero.md), [vivero-module/04_consumo_de_vivero.md §3.1](../../vivero-module/04_consumo_de_vivero.md)

---

## 1. Contexto

En el análisis de consumo de vivero (conversación 2026-05-23) aparecieron tres gaps en el flujo de **reposición** y **reporte de mortandad** que la documentación actual no resuelve con suficiente precisión:

1. **Especie de la reposición**: la doc no dice si una reposición debe ser de la misma especie del grupo origen. Si no se dice nada, queda ambiguo qué pasa cuando el grupo origen era *Polylepis incana* y solo hay stock de *Schinus molle* en propósito `REPOSICION`.

2. **UX del operario al reponer**: el doc de mortandad (§3.9) dice que el sistema "muestra al operario el histórico del grupo antes de confirmar". No hay equivalente explícito para reposición, aunque el operario lo necesita igual o más.

3. **Roles que reportan mortandad**: §3.9 dice "operario en campo" pero no excluye al coordinador. En la práctica el coordinador hace visitas de mantenimiento y necesita reportar pérdidas igual que un operario.

Estos gaps no afectan la implementación de M2 ↔ M3 (la tabla de asignación ya funciona) pero **bloquean la decisión final sobre cómo modelar M3 en BD**.

---

## 2. Cambios requeridos en documentación

### 2.1. Decisión: reposición de cualquier especie permitida en MVP

**Decisión cerrada en conversación 2026-05-23:** una reposición puede usar stock de **cualquier especie**, no solo la del grupo origen.

Justificación:
- Operativamente, el stock disponible para reposición puede no coincidir con la especie original.
- Forzar misma especie generaría reposiciones bloqueadas por inventario.
- El mix de la subcampaña es una guía, no una restricción dura (RN ya existente).

Tradeoffs aceptados:
- El grupo plantado puede terminar con especies distintas a su origen.
- Esto contamina el mix real vs planificado, pero el sistema ya advierte sin bloquear si se excede tope (§2.12 de M3).
- Decisión **revisable post-MVP** si la certificación de carbono exige homogeneidad por grupo.

Cambios:
- Agregar regla nueva (numeración estable, no renumerar existentes) en [vivero-module/01_regas_de_negocio_vivero.md](../../vivero-module/01_regas_de_negocio_vivero.md), sección 13 (Integración con Módulo 3):
  - **RN-VIV-60 — Reposición no exige misma especie que el grupo origen**
    - Severidad: ADVERTENCIA
    - Aplica en MVP: Sí
    - Relevancia carbono: Media
    - Contenido: "Una reposición puede usar stock de cualquier especie disponible en una asignación con propósito `REPOSICION`. No se exige que coincida con la especie del grupo plantado origen. El sistema registra la especie real en el evento `REPOSICION` y el grupo plantado puede quedar con composición mixta. Esta política es revisable post-MVP si la certificación de carbono exige homogeneidad por grupo."
- Agregar línea correspondiente en [plantacion-module/02_Procesos_Modulo_3_Plantacion.md §3.10](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md) explicando que la especie de la reposición se elige libremente del stock disponible con propósito `REPOSICION`.

### 2.2. UX del operario al reponer

Agregar a [plantacion-module/02_Procesos_Modulo_3_Plantacion.md §3.10](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md):

> Antes de confirmar una reposición, el sistema debe mostrar al operario el estado del grupo origen:
>
> - `cantidad_plantada_inicial`: cuánto se plantó originalmente.
> - `cantidad_muerta_acumulada`: cuánto murió en total (suma de todos los reportes de mortandad del grupo).
> - `cantidad_repuesta_acumulada`: cuánto ya se repuso en eventos previos.
> - `cantidad_pendiente_reposicion = cantidad_muerta_acumulada − cantidad_repuesta_acumulada`: cuánto queda por reponer.
>
> Si la cantidad ingresada por el operario excede `cantidad_pendiente_reposicion`, se bloquea el registro con mensaje claro. Esto refleja la validación de [§3.10](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md) pero como **información proactiva en UX**, no solo como error al confirmar.

### 2.3. Roles que pueden reportar mortandad

Aclarar en [plantacion-module/02_Procesos_Modulo_3_Plantacion.md §3.9](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md):

> El reporte de mortandad lo puede registrar:
>
> - Cualquier **operario** miembro del equipo de la subcampaña.
> - El **coordinador** de la subcampaña.
> - **ADMIN**.
>
> En la práctica, las visitas de revisión las hace cualquiera de estos tres roles. No hay diferencias de permisos entre ellos para este evento.

Verificar consistencia con tabla de roles del módulo (§12 de M3) y agregar nota si necesario.

### 2.4. UX del operario/coordinador al reportar mortandad — explicitar

§3.9 ya dice "muestra al operario el histórico del grupo antes de confirmar (plantado, muertos previos, vivos estimados)". Confirmar que el alcance incluye **también al coordinador y al admin** cuando son ellos quienes reportan.

---

## 3. Criterios de aceptación

- [ ] `01_regas_de_negocio_vivero.md` tiene la regla `RN-VIV-60` agregada al final de la sección 13, con severidad, MVP, relevancia carbono y descripción completa.
- [ ] `02_Procesos_Modulo_3_Plantacion.md §3.10` documenta la elección libre de especie en reposición.
- [ ] `02_Procesos_Modulo_3_Plantacion.md §3.10` documenta el bloque informativo de pre-confirmación con los cuatro datos (`plantada_inicial`, `muerta_acumulada`, `repuesta_acumulada`, `pendiente_reposicion`).
- [ ] `02_Procesos_Modulo_3_Plantacion.md §3.9` aclara que el reporte de mortandad puede hacerlo operario, coordinador o admin.
- [ ] Numeración de reglas estable: no se renumera ninguna existente.
- [ ] CLAUDE.md actualizado en la sección "Invariantes de dominio a respetar" si la decisión de "cualquier especie en reposición" cambia un invariante.

---

## 4. Choques con la documentación actual

- **Ninguno fuerte.** Son aclaraciones y un punto explícito de política.
- La regla `RN-VIV-58` actual establece que asignaciones de propósito distinto no se cruzan; eso no cambia. Lo que se aclara es que **dentro** de propósito `REPOSICION` no hay restricción de especie.
- Si en el futuro se decide forzar misma especie, será un cambio post-MVP y se documenta como tal.

---

## 5. Archivos a tocar

- `vivero-module/01_regas_de_negocio_vivero.md` — agregar `RN-VIV-60`.
- `plantacion-module/02_Procesos_Modulo_3_Plantacion.md` — ampliar §3.9 y §3.10.
- `CLAUDE.md` — solo si se considera necesario un invariante explícito sobre "reposición especie libre" o "mortandad reportable por 3 roles".
- (Opcional) `vivero-module/04_consumo_de_vivero.md` — agregar una nota breve si conviene.

---

## 6. Pendientes derivados

- Cuando se modele M3 en BD, los validadores de inserción de `REPOSICION` y `MORTANDAD_REPORTADA` deben honrar las reglas aclaradas aquí.
- La UI de M3 (mockups en `plantacion-module/03_Mockups_Guia_Modulo_3_Plantacion.md`) debe incluir el bloque informativo pre-confirmación tanto para mortandad como para reposición.
