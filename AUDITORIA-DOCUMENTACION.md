# Auditoría de documentación — R3Foresta

> **Propósito:** entender el estado actual de la documentación y evaluar su calidad como lo haría un ingeniero senior que se incorpora al proyecto, **antes** de proponer cualquier refactor.
> **Alcance:** todos los `.md`, `.json` y `.sql` del repo. Se **excluyen los `.excalidraw`** (`diagramas/`, `methodology/`) por indicación de `CLAUDE.md`: son material de trabajo en Excalidraw, no documentación canónica. Se excluye también `documentacion-grado/` (no está trackeada por git, es material de trabajo del proyecto de grado, no documentación canónica de dominio).
> **Auditoría inicial:** 2026-07-01. **Actualización de sincronización:** 2026-07-23. **Re-auditoría completa:** 2026-07-24.
>
> **Motivo de la re-auditoría del 2026-07-24:** la "actualización de sincronización" del 2026-07-23 refrescó el resumen ejecutivo y el snapshot de implementación, pero **no** refrescó §3 (clasificación de archivos) ni §4 (duplicaciones). Ambas secciones seguían describiendo un árbol de `02-vivero-module/` y `database/` que ya no existe: `03_Addendum_Modulo_2_por_Modulo_3.md`, `_legacy/04_consumo_de_vivero.md`, `03_operativo_modulo_vivero.md`, `image.png`, `database/03_planeacion_arquitectura_bd_mvp_vivero.md` y `database/04_decisiones_bd_vivero_final.md` ya no viven donde el documento decía, y las tres contradicciones puntuales que reportaba como abiertas (política de merma "LIFO" vs "urgencia", fórmula de `saldo_asignado_disponible` de 3 vs 4 términos, `COORDINADOR` como rol global) ya estaban corregidas en el árbol real. Este documento se reescribe completo contra el estado verificado hoy. Se preserva la observación histórica solo donde aporta contexto de qué cambió y por qué.
>
> **Convención:** los enunciados son **hechos** verificados sobre los archivos salvo cuando digan explícitamente *(suposición)* o *(sin confirmar)*. Las citas usan `archivo:línea` donde aporta.
> **Regla de oro respetada:** este documento **no reescribe, no inventa y no crea** documentación de dominio. Solo audita y propone.

---

## 1. Entender el proyecto (sin criticar todavía)

### ¿Qué problema resuelve R3Foresta?

R3Foresta modela la **cadena de custodia de material biológico para reforestación**, con trazabilidad operativa y anclaje opcional en blockchain. El objetivo de negocio de fondo son los **bonos de carbono** y la **transparencia pública**: poder reconstruir, de punta a punta, que una semilla o esqueje recolectado en una comunidad terminó siendo un árbol plantado en una zona concreta. La cadena que persigue el sistema es:

`recolección (origen) → vivero (maduración) → plantación (campo) → monitoreo`

Todo el trabajo es en español y el sistema es un **MVP**: prioriza trazabilidad fuerte y simplicidad operativa sobre completitud.

### Piezas del repositorio

- **General (`00-general-module/`, `RF-GEN-*`)** — catálogos y entidades maestras transversales: `USUARIO`, `UBICACION`/territorios, `VIVERO`, `PLANTA`/`TIPO_PLANTA`, `EVIDENCIAS_TRAZABILIDAD`, `METODO_RECOLECCION`, `ORGANIZACION`. Fuente viva de identidad.
- **Recolección — Módulo 1 (`01-recoleccion-module/`, `RF-REC-*`)** — registro del *lote origen* con evidencia fotográfica, GPS y validación.
- **Vivero — Módulo 2 (`02-vivero-module/`, `RF-VIV-*`, `RN-VIV-*`)** — Vivero Core: maduración pre-plantación, saldo vivo, eventos append-only y cierre.
- **Plantación — Módulo 3 (`03-plantacion-module/`, `RF-PLA-*`, `RN-PLA-*`)** — plantación efectiva en campo: `CAMPANIA → SUBCAMPANIA → REGISTRO_PLANTACION → EVENTO_PLANTACION`.
- **Contratos de integración (`90-contratos-integracion/`)** — pieza que **no existía** en la auditoría anterior como carpeta propia. Contiene el contrato Recolección→Vivero y el contrato Vivero→Plantación (asignación física, devolución física, consumo de stock, saldos derivados). Antes vivía disperso entre `02-vivero-module/03_Addendum...` y reglas `RN-VIV-47..60` incrustadas en el módulo de vivero; ahora tiene carpeta propia y README.
- **`decisiones/`** — registro unificado de ADR (`ADR-VIV-*`, `ADR-GEN-*`, `ADR-PLA-*`), **nuevo** desde la auditoría anterior. Migra contenido que antes vivía disperso en `database/04_decisiones_bd_vivero_final.md`, `00-general-module/03_decisiones_pendientes_general.md` e invariantes sueltos.
- **`glosario.md`** — **nuevo**. Términos clave del dominio con enlace a su fuente canónica.
- **`database/`** — esquema ER consolidado (`00_database_schema.md`) y `migrations/` (documental, `001`–`057`).
- **`ESTADO.md`** — estado vivo de implementación (qué está en producción vs. pendiente).
- **`ARCHITECTURE.md`** — **nuevo**, fechado 2026-07-23. Auditoría técnica de arquitectura (frontend, backend, seguridad, datos, riesgos P0/P1/P2) que contrasta los tres repos (`r3foresta-docs`, `Backend-r3foresta`, `pwa-r3foresta`). Es más reciente, más detallado y más autoritativo que este documento para todo lo que sea **implementación** (drift de migraciones, seguridad, deuda de frontend). Este documento (`AUDITORIA-DOCUMENTACION.md`) se mantiene enfocado en la **calidad y coherencia de la documentación en sí**, no en el código; donde ambos tocan el mismo tema se referencia `ARCHITECTURE.md`/`ESTADO.md` en vez de duplicar el hallazgo.
- **`post-mvp/`** — **nuevo**. Ideas evaluadas y diferidas fuera del MVP, separadas de las reglas vigentes.

### ¿Cómo interactúan?

- **General** es consumido por los tres módulos operativos vía snapshots congelados.
- **Recolección → Vivero**: contrato en `90-contratos-integracion/01_contrato_recoleccion_a_vivero.md`. Crear el lote de vivero y descontar el saldo del origen es una transacción atómica.
- **Vivero ↔ Plantación**: contrato en `90-contratos-integracion/02_contrato_vivero_a_plantacion.md`. *Asignar* es entrega física (descuenta `LOTE_VIVERO.saldo_vivo_actual`, crea stock consumible en M3); *plantar/reponer* consume asignaciones sin volver a descontar el lote; *devolver* repone físicamente el saldo del lote; las mermas de vivero no afectan asignaciones ya entregadas.

### ¿Qué parece implementado vs. planeado?

Para esta pregunta, la fuente más confiable ya no es este documento sino **`ESTADO.md`** y **`ARCHITECTURE.md`** (ambos con fecha 2026-07-23, con confirmaciones explícitas de producción). En resumen verificado ahí: las migraciones `056`/`057` están aplicadas en Supabase de producción, Backend y Frontend están desplegados, y quedan pendientes explícitos el job nocturno de transición a `MONITOREO_HISTORICO`, la merma sobre stock ya asignado en campo, y varios riesgos de seguridad (guard JWT global, endpoints sin protección) listados en `ARCHITECTURE.md` §12.2.

### Documentos más importantes (núcleo del proyecto)

1. **`database/00_database_schema.md`** — ER consolidado; fuente de verdad estructural.
2. **`CLAUDE.md`** — invariantes de dominio, convenciones y punto de entrada para agentes.
3. **`ARCHITECTURE.md`** — arquitectura integral observada (nuevo, muy completo).
4. **`ESTADO.md`** — estado vivo de implementación.
5. **`90-contratos-integracion/`** — contrato formal entre módulos.
6. Los `01_reglas_de_negocio_*.md` y `00_requerimientos_*.json` de cada módulo.

---

## 2. Análisis de la estructura documental

### Organización de carpetas (hecho, verificado 2026-07-24)

```
r3foresta-docs/
├─ README.md, CLAUDE.md, ARCHITECTURE.md, ESTADO.md, glosario.md, AUDITORIA-DOCUMENTACION.md
├─ 00-general-module/     README + 00_json + 01_reglas + 02_guia
├─ 01-recoleccion-module/ README + 00_requerimientos + 01_reglas + 02_flujo + 03_checklist
├─ 02-vivero-module/      README + 00_json + 01_reglas + 02_flujo + 03_tarea_frontend + _legacy/ (4 archivos archivados)
├─ 03-plantacion-module/  README + 00_json + 01_reglas + 02_procesos + 03_mockups + 04_plan_frontend + 05_handoff
├─ 90-contratos-integracion/ README + 01_contrato_recoleccion_a_vivero + 02_contrato_vivero_a_plantacion
├─ database/           README + 00_schema + migrations/ (001–057)
├─ decisiones/         README + 00_decisiones_vivero + 01_decisiones_general + 02_decisiones_plantacion + _historico/ (2 archivos)
├─ post-mvp/           README + 03-plantacion.md
├─ documentacion-grado/  (fuera de alcance de esta auditoría; no trackeado por git)
├─ diagramas/          *.excalidraw   (ignorado)
└─ methodology/        *.excalidraw   (ignorado)
```

Comparado con el árbol descrito en la versión anterior de este documento, lo siguiente **ya se ejecutó**: se creó `90-contratos-integracion/` como carpeta propia; se creó `decisiones/` como ADR unificado; se creó `glosario.md`; se archivaron `03_Addendum_Modulo_2_por_Modulo_3.md` y `database/03_planeacion_arquitectura_bd_mvp_vivero.md` a `decisiones/_historico/`; se migró `database/04_decisiones_bd_vivero_final.md` a `decisiones/00_decisiones_vivero.md`; se renombraron los archivos de vivero con typo (`01_regas_de_negocio_vivero.md` → `01_reglas_de_negocio_vivero_core.md`, `02_doc_guia_viviero.md` → `02_flujo_operativo_vivero_core.md`) y los originales quedaron respaldados en `02-vivero-module/_legacy/`; se creó `03-plantacion-module/01_reglas_de_negocio_plantacion.md` (antes las reglas de M3 vivían incrustadas en el módulo de vivero); se crearon READMEs en `02-vivero-module/`, `03-plantacion-module/`, `database/`, `90-contratos-integracion/`, `decisiones/` y `post-mvp/`; se rehizo el `README.md` raíz sin rutas absolutas e incluyendo M3; se limpiaron `00-general-module/agregar.md` y `00-general-module/03_decisiones_pendientes_general.md` (su contenido migró a `decisiones/01_decisiones_general.md`); se eliminó `02-vivero-module/image.png`; no queda ninguna referencia viva a una carpeta `tareas/` (antes: 7 menciones en `CLAUDE.md` + 4 enlaces rotos — hoy: cero coincidencias en todo el árbol vivo, solo comentarios `-- ... (Tarea 04)` dentro de migraciones SQL antiguas, que son etiquetas de trabajo, no referencias a una carpeta).

Evaluación por dimensión, re-hecha hoy:

| Dimensión | Estado | Evidencia |
|---|---|---|
| **Consistencia de nombres** | ✔️ Buena | Los typos de M1 y M2 ya se corrigieron. No se detectaron nuevos. |
| **Jerarquía de documentos** | ✔️ Buena | Vivero: `00,01,02,03`. Plantación: `00,01,02,03,04,05`. General: `00,01,02`. Recolección: `00,01,02,03`. `database/` ya no mezcla ADRs de vivero con el esquema canónico (se migraron a `decisiones/`). |
| **Descubribilidad** | ✔️ Buena | `README.md` raíz es un índice real con enlaces a los 8 módulos/carpetas + `glosario.md` + `ESTADO.md` + `ARCHITECTURE.md`. |
| **Puntos de entrada** | ✔️ Buena | `CLAUDE.md` ya no referencia `tareas/`. Ver, sin embargo, el hallazgo nuevo en §5 sobre `database/supabase/`. |
| **Índices** | ✔️ Presente | El README raíz + `decisiones/README.md` + `glosario.md` cubren el rol de índice global; no hay un único archivo "mapa" adicional, pero la cobertura es funcionalmente equivalente. |
| **READMEs por módulo** | ✔️ Completo | Los 8 módulos/carpetas de primer nivel tienen README. |
| **Carpetas redundantes** | ✔️ Aceptable | Ninguna detectada. |

### Problemas concretos del punto de entrada — re-chequeados

- **`README.md` raíz**: ya no contiene rutas absolutas de máquina; incluye `03-plantacion-module/` y las carpetas nuevas (`90-contratos-integracion/`, `decisiones/`, `post-mvp/`). **Resuelto.**
- **Formato heterogéneo de requerimientos** — **sigue vigente**: `00-general-module/00_Requerimientos_Modulo_General.json`, `01-recoleccion-module/00_requerimientos_recoleccion.json` y `03-plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json` usan `{"requerimientos":[{"codigo": "RF-...", ...}]}`; `02-vivero-module/00_requerimientos_vivero_core.json` sigue usando un **array plano** con claves `"Severidad"`, `"Aplica en MVP"`, `"Aporta a carbono"`. Verificado hoy con lectura directa de ambos formatos. Es el único punto de la lista original que **no** se corrigió.
- **Reglas de M3 alojadas en M2** — **resuelto**: existe `03-plantacion-module/01_reglas_de_negocio_plantacion.md` con `RN-PLA-*` propias. El contrato M2↔M3 (antes `RN-VIV-47..60` dentro del módulo de vivero) ahora vive en `90-contratos-integracion/02_contrato_vivero_a_plantacion.md`, con su propia numeración de reglas dentro del contrato.

---

## 3. Clasificación de todos los documentos (re-hecha, 2026-07-24)

Leyenda — **Utilidad**: Alta/Media/Baja. **Completitud**: Completo/Parcial. **Refleja el sistema actual**: Alta/Media/Baja. **¿Mantenido?**: Sí/Parcial/No. **Acción**: Mantener / Fusionar / Archivar / Depurar.

| # | Documento | Propósito | Utilidad | Completo | Refleja actual | Mantenido | Acción sugerida |
|---|---|---|---|---|---|---|---|
| 1 | `README.md` (raíz) | Índice del repo | Alta | Completo | Alta | Sí | Mantener |
| 2 | `CLAUDE.md` | Invariantes + convenciones | Alta | Completo | Media-Alta | Sí | Mantener; corregir referencia a `database/supabase/` (§5) |
| 3 | `ARCHITECTURE.md` | Arquitectura técnica integral (frontend/backend/BD/seguridad) | Alta | Completo | Alta | Sí (2026-07-23) | Mantener — es la fuente para preguntas de implementación |
| 4 | `ESTADO.md` | Estado vivo de implementación | Alta | Completo | Alta | Sí (2026-07-23) | Mantener |
| 5 | `glosario.md` | Términos clave + fuente canónica | Media-Alta | Completo para lo cubierto | Alta | Sí | Mantener; ampliar si aparecen términos re-explicados fuera de él |
| 6 | `00-general-module/README.md` | Propósito y dependencias | Alta | Completo | Alta | Sí | Mantener |
| 7 | `00-general-module/00_Requerimientos_Modulo_General.json` | RF-GEN-* | Alta | Completo | Alta | Sí | Mantener |
| 8 | `00-general-module/01_reglas_de_negocio_general.md` | RN-GEN-* | Alta | Completo | Alta | Sí | Mantener |
| 9 | `00-general-module/02_guia_operativa_modulo_general.md` | Administración de catálogos | Media | Completo | Alta | Sí | Mantener |
| 10 | `01-recoleccion-module/README.md` | Resumen del flujo M1 | Media | Completo | Alta | Sí | Mantener |
| 11 | `01-recoleccion-module/00_requerimientos_recoleccion.json` | RF-REC-* | Alta | Completo | Alta | Sí | Mantener |
| 12 | `01-recoleccion-module/01_reglas_de_negocio_recoleccion.md` | RN-REC-* | Alta | Completo | Alta | Sí | Mantener |
| 13 | `01-recoleccion-module/02_flujo_operativo_recoleccion.md` | Flujo operativo M1 | Alta | Completo | Alta | Sí | Mantener |
| 14 | `01-recoleccion-module/03_checklist_validacion_recoleccion.md` | Checklist QA de M1 | Media | Completo | Alta | Sí | Mantener |
| 15 | `02-vivero-module/README.md` | Índice + alcance del módulo | Alta | Completo | Alta | Sí | Mantener |
| 16 | `02-vivero-module/00_requerimientos_vivero_core.json` | RF-VIV-01..10 | Alta | Completo | Alta | Sí | Mantener; homogeneizar formato JSON (único pendiente real, ver §4) |
| 17 | `02-vivero-module/01_reglas_de_negocio_vivero_core.md` | RN-VIV-* del core | Alta | Completo | Alta | Sí | Mantener |
| 18 | `02-vivero-module/02_flujo_operativo_vivero_core.md` | Guía operativa del core | Alta | Completo | Alta | Sí | Mantener |
| 19 | `02-vivero-module/03_tarea_frontend_separar_despacho_asignacion.md` | Tarea frontend cerrada (separar Despacho/Asignación en UI) | Media | Completo | Alta | Sí | Mantener como registro de tarea cerrada |
| 20 | `02-vivero-module/_legacy/*` (4 archivos) | Respaldo histórico pre-refactor de nombres/estructura | Baja (histórico) | — | — | No (archivado a propósito) | Mantener como respaldo, ya está fuera del flujo de lectura activo |
| 21 | `03-plantacion-module/README.md` | Índice del módulo | Alta | Completo | Alta | Sí | Mantener |
| 22 | `03-plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json` | RF-PLA-01..18 | Alta | Completo | Alta | Sí | Mantener — ya no contradice el enum de roles ni la fórmula de saldo (§4) |
| 23 | `03-plantacion-module/01_reglas_de_negocio_plantacion.md` | RN-PLA-* | Alta | Completo | Alta | Sí | Mantener |
| 24 | `03-plantacion-module/02_Procesos_Modulo_3_Plantacion.md` | Proceso M3 detallado | Alta | Completo | Alta | Sí | Mantener |
| 25 | `03-plantacion-module/03_Mockups_Guia_Modulo_3_Plantacion.md` | Guía UX/mockups M3 | Media | Completo | Media | Parcial | Revisar: si sigue mostrando "mix de especies con topes %", marcar explícitamente post-MVP o mover a `post-mvp/` *(sin re-confirmar el contenido exacto en este pase)* |
| 26 | `03-plantacion-module/04_plan_frontend_m3.md` | Plan de implementación frontend M3 | Media-Alta | Completo | Alta | Sí | Mantener |
| 27 | `03-plantacion-module/05_handoff_registro_plantacion_inicial.md` | Handoff de UI para plantación inicial | Media | Completo | Alta | Sí | Mantener |
| 28 | `90-contratos-integracion/README.md` | Índice de contratos | Alta | Completo | Alta | Sí | Mantener |
| 29 | `90-contratos-integracion/01_contrato_recoleccion_a_vivero.md` | Contrato M1↔M2 | Alta | Completo | Alta | Sí | Mantener — candidato a fuente única del contrato M1↔M2 |
| 30 | `90-contratos-integracion/02_contrato_vivero_a_plantacion.md` | Contrato M2↔M3 | Alta | Completo | Alta | Sí | Mantener — fuente única del contrato M2↔M3 |
| 31 | `database/README.md` | Índice de la carpeta database | Alta | Completo | Alta | Sí | Mantener |
| 32 | `database/00_database_schema.md` | ER canónico + enums + funciones | Alta | Completo | Alta | Sí | Mantener — fuente de verdad estructural |
| 33 | `database/migrations/*.sql` (001–057) | Copia documental de migraciones | Alta | Completo | Alta (documental) | Sí | Mantener; el estado real de aplicación en producción se confirma en `ESTADO.md`, no aquí |
| 34 | `decisiones/README.md` | Índice de ADR | Alta | Completo | Alta | Sí | Mantener |
| 35 | `decisiones/00_decisiones_vivero.md`, `01_decisiones_general.md`, `02_decisiones_plantacion.md` | ADR por módulo | Alta | Completo | Alta | Sí | Mantener |
| 36 | `decisiones/_historico/*` (2 archivos) | Material superado, conservado como referencia | Baja (histórico) | — | — | No (archivado a propósito) | Mantener como histórico |
| 37 | `post-mvp/README.md`, `03-plantacion.md` | Ideas diferidas fuera del MVP | Media | Completo | Alta | Sí | Mantener |

*(Nota metodológica)*: `.claude/`, `.vscode/`, `.gitignore` son configuración, no documentación; no se clasifican.

---

## 4. Conocimiento duplicado

### 4.1. Las tres contradicciones reportadas en la versión anterior — RESUELTAS (verificado 2026-07-24)

- **Política de merma — "LIFO" vs. "urgencia":** cero coincidencias de "LIFO" en `CLAUDE.md`, `02-vivero-module/` (incluido `_legacy/`), `database/00_database_schema.md` y `decisiones/_historico/vivero-addendum-m2-m3.md`. Los únicos usos restantes del término están en `database/migrations/036_vivero_merma_lifo.sql` (migración histórica, reemplazada por `055_vivero_merma_fisica.sql`, cuyo propio comentario dice explícitamente "reemplaza la version LIFO"). La política vigente ("urgencia" = `fecha_estimada_inicio DESC NULLS FIRST`) es consistente en todos los documentos vivos.
- **Fórmula `saldo_asignado_disponible` — 3 vs. 4 términos:** `03-plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json:157` y `03-plantacion-module/02_Procesos_Modulo_3_Plantacion.md:659` ya usan los 4 términos (`cantidad_asignada − cantidad_consumida − cantidad_devuelta − cantidad_mermada`), igual que `database/00_database_schema.md:267` y `CLAUDE.md`.
- **`COORDINADOR` como rol global:** `03-plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json:531` dice ahora explícitamente *"No se crea COORDINADOR en el enum rol_usuario; el enum global se mantiene ADMIN / GENERAL / VALIDADOR / VOLUNTARIO"*, alineado con `database/00_database_schema.md:599` y `CLAUDE.md`.

No fue posible determinar la fecha exacta de la corrección (no hay changelog en el repo); por la fecha de "Actualización de sincronización" registrada en la versión anterior de este documento, es razonable asumir que ocurrió alrededor del 2026-07-23 *(suposición)*.

### 4.2. Lo que sigue duplicado o sin unificar (real, verificado hoy)

- **Formato JSON heterogéneo (persiste):** `02-vivero-module/00_requerimientos_vivero_core.json` sigue en formato array plano con claves en español (`"Severidad"`, `"Aplica en MVP"`, `"Aporta a carbono"`), distinto del `{"requerimientos": [{"codigo": "RF-...", ...}]}` que usan general, recolección y plantación. Es el único punto de la auditoría anterior que no se tocó.
- **Convención de unidades** (`UNIDAD`/`G`, `kg` no persiste): se repite intencionalmente en los 4 módulos + `CLAUDE.md`, como es esperable de un invariante transversal citado desde cada módulo operativo. No es un caso de *drift*: no se detectó ninguna copia que lo contradiga.
- **Requisito de fotos de recolección** (mínimo 2): sigue citado en varios documentos de M1 y en `CLAUDE.md`. *(No se recontó el número exacto de copias ni se releyó cada una en este pase; en la auditoría anterior eran ~7 lugares y no hay indicio de que hayan divergido.)*

### 4.3. Lo que se corrigió estructuralmente (ya no es duplicación, es consolidación)

- **Contrato M2↔M3:** antes vivía repetido en `03_Addendum_Modulo_2_por_Modulo_3.md`, `04_consumo_de_vivero.md`, `02_doc_guia_viviero.md §13` y `RN-VIV-47..60` dentro del módulo de vivero. Hoy tiene una sola fuente viva: `90-contratos-integracion/02_contrato_vivero_a_plantacion.md`. Las cuatro copias anteriores están archivadas (`_legacy/`, `decisiones/_historico/`) y ya no se presentan como vigentes.
- **Enum `destino_tipo_vivero`:** en la auditoría anterior había 3 definiciones distintas en documentación viva (schema con 6 valores, guía operativa vieja con 5 valores sin `PLANTACION_CAMPANIA`, addendum recomendando `DONACION_COMUNIDAD`). Hoy, en documentación viva, solo hay una: `database/00_database_schema.md:571-573` (`PLANTACION_CAMPANIA, PLANTACION_PROPIA, PLANTACION_COMUNIDAD, DONACION, VENTA, OTRO`), y `02-vivero-module/02_flujo_operativo_vivero_core.md:137` remite a esa matriz en vez de redefinirla. **Importante:** esto no significa que el enum ya esté resuelto en el código — `ESTADO.md` y `ARCHITECTURE.md §9.4/§17` documentan que el *replay* de migraciones Backend todavía no reproduce este enum vivo (la migración `006` crea `DONACION_COMUNIDAD`, un valor que el código y el schema canónico ya no usan). Ese es un hallazgo de **implementación**, no de documentación, y ya está registrado donde corresponde — no se duplica aquí.

**Por qué sigue importando:** este es un proyecto de trazabilidad con certificación de carbono; los números tienen que cuadrar. El hallazgo real que queda abierto en el terreno de documentación (el formato JSON de vivero) es cosmético — no genera un cálculo erróneo si un desarrollador lo lee — a diferencia de las tres contradicciones ya resueltas, que sí eran bugs latentes.

---

## 5. Deuda documental

### 5.1. Hallazgo nuevo: `CLAUDE.md` referencia una carpeta que ya no existe

`CLAUDE.md:25` y la sección completa `## SQL en \`database/supabase/\`` (línea 72 en adelante) describen `database/supabase/` como la ubicación de los scripts SQL del proyecto, con convenciones específicas (guards `do $$`, `create table if not exists`, sufijo `_fk`). **Esa carpeta no existe hoy en el árbol del repo** (verificado con búsqueda directa): los scripts viven en `database/migrations/` (numeración `001`–`057`), correctamente descrito en `database/README.md:12`. Es el mismo patrón de deuda que ya se había cerrado para `tareas/` — un punto de entrada de alto tráfico (`CLAUDE.md`) apunta a una ruta que se movió. A diferencia de `tareas/`, esto no rompe ningún enlace clickeable (es prosa, no un link), pero sí puede llevar a un agente o colaborador a buscar en el lugar equivocado.

### 5.2. Addendum absorbido — ya resuelto correctamente

`decisiones/_historico/vivero-addendum-m2-m3.md` (el antiguo `03_Addendum_Modulo_2_por_Modulo_3.md`) ya no vive mezclado entre documentos vigentes: está en `_historico/`, `decisiones/README.md:22` lo describe correctamente como *"ya absorbida en `90-contratos-integracion/02_contrato_vivero_a_plantacion.md`"*, y no se detectó ningún documento vivo que lo siga llamando "fuente canónica" (la contradicción circular que existía en la versión anterior — `04_consumo:407` llamándolo canónico mientras el propio addendum decía que no lo era — desapareció junto con `04_consumo_de_vivero.md`, que ahora es un archivo archivado en `_legacy/`).

### 5.3. Documentos de planeación superados — ya resuelto

`decisiones/_historico/planeacion-bd-vivero.md` (antes `database/03_planeacion_arquitectura_bd_mvp_vivero.md`) está correctamente marcado como superado por `decisiones/00_decisiones_vivero.md` (`database/README.md:14`).

### 5.4. Requerimientos JSON rezagados — ya resuelto

El caso "un documento existe desactualizado porque otro se actualizó y este no" (RF-PLA-17 y RF-PLA-04 desalineados del resto) ya no aplica: ver §4.1.

### 5.5. Notas sueltas e histórico incrustado — ya resuelto

`00-general-module/agregar.md` y `00-general-module/03_decisiones_pendientes_general.md` ya no existen como archivos sueltos; su contenido se migró a `decisiones/01_decisiones_general.md`. No se detectó ningún archivo huérfano equivalente hoy.

### 5.6. Riesgo de solapamiento entre `AUDITORIA-DOCUMENTACION.md` y `ARCHITECTURE.md` (nuevo, a vigilar)

`ARCHITECTURE.md` (2026-07-23) es un documento mucho más profundo que este para todo lo que sea implementación: drift de migraciones, seguridad, deuda de frontend/backend. Existe riesgo real de que futuras actualizaciones dupliquen hallazgos entre ambos documentos si no se respeta la frontera de alcance. Se recomienda una regla explícita: **este documento** (`AUDITORIA-DOCUMENTACION.md`) audita la documentación en sí (estructura, duplicación, coherencia entre docs); **`ARCHITECTURE.md`** audita el sistema implementado (código, seguridad, drift entre docs y Backend real); **`ESTADO.md`** registra qué está confirmado en producción. Ningún hallazgo de implementación debería viajar hacia este documento sin pasar primero por `ARCHITECTURE.md`/`ESTADO.md`.

---

## 6. Salud de la documentación (puntajes 1–10, re-evaluados 2026-07-24)

| Categoría | Puntaje anterior | Puntaje actual | Justificación del cambio |
|---|---:|---:|---|
| **Mantenibilidad** | 4 | **7** | Las tres fuentes de *drift* verificado (LIFO/urgencia, fórmula de saldo, COORDINADOR) están resueltas y consolidadas en fuentes únicas (`90-contratos-integracion/`, `decisiones/`). Queda un punto real de riesgo: el formato JSON heterogéneo de vivero. |
| **Escalabilidad** | 5 | **7** | El patrón por módulo ya no se rompe al 4.º módulo: Plantación tiene su propio `01_reglas`, el contrato M2↔M3 tiene carpeta propia, `database/` ya no mezcla ADRs de un solo módulo con el esquema canónico. |
| **Claridad** | 7 | **8** | Se mantiene la calidad individual de los documentos y mejora la navegación entre ellos gracias a los READMEs nuevos y al glosario. |
| **Consistencia** | 3 | **7** | Las contradicciones verificadas de la versión anterior están cerradas. Persisten dos puntos menores: el formato JSON de vivero y la referencia obsoleta a `database/supabase/` en `CLAUDE.md`. No se auditó línea por línea el 100% de las ~700 reglas `RN-*`/`RF-*` del repo en este pase, así que no se puede afirmar consistencia total, solo ausencia de *drift* en los puntos verificados. |
| **Separación de responsabilidades** | 4 | **8** | Reglas de M3 ya no están en M2; ADRs de vivero ya no están en `database/`; `ORGANIZACION` está documentada en `00-general-module/README.md`; el histórico está separado en `_historico/`/`_legacy/`. |
| **Onboarding de un dev nuevo** | 6 | **8** | `README.md` raíz + `CLAUDE.md` + `ARCHITECTURE.md` + `ESTADO.md` + `glosario.md` + `decisiones/README.md` forman un punto de entrada coherente y sin enlaces rotos conocidos (salvo el hallazgo de §5.1). |
| **Facilidad de mantenimiento futuro** | 4 | **7** | El costo de mantener coherencia bajó porque hay fuentes únicas declaradas para los conceptos que antes divergían. El riesgo que queda es de proceso: nada impide que una futura edición vuelva a introducir *drift* si no se sigue citando en vez de recopiar. |

**Salud global ponderada: ≈ 7.5 / 10** (antes ≈ 4.5/10). Diagnóstico de una frase: **la arquitectura documental que la auditoría anterior proponía como "ideal" ya se implementó en gran parte; queda un remanente pequeño y concreto de deuda, no una reestructuración pendiente.**

---

## 7. Documentación faltante (re-evaluado)

De los 8 puntos de la versión anterior, el estado real hoy:

1. **Índice / mapa documental global** — ✅ resuelto (README raíz + glosario + `decisiones/README.md`).
2. **Glosario canónico de términos** — ✅ existe (`glosario.md`), con 13 términos y fuente canónica cada uno. Pendiente abierto genuino: no se verificó en este pase si hay términos que todavía se re-explican fuera de él.
3. **Catálogo de enums único** — ✅ resuelto en documentación viva (`database/00_database_schema.md` es la única fuente); el drift que queda es de implementación (Backend), no de documentación (ver §4.3).
4. **Registro de decisiones (ADR) unificado** — ✅ existe (`decisiones/`).
5. **Documento del maestro `ORGANIZACION`** — ✅ documentado en `00-general-module/README.md:31` y en las reglas del módulo.
6. **Estado real de implementación** — ✅ resuelto (`ESTADO.md`, más `ARCHITECTURE.md` como capa técnica adicional).
7. **`03-plantacion-module/01_reglas_de_negocio_plantacion.md` + README** — ✅ ambos existen.
8. **Guía de contribución humana** — ⏳ sigue sin existir; sigue siendo opcional, no bloqueante.

No se identificó ninguna pieza de documentación de dominio nueva que falte crear. El trabajo pendiente real es de homogeneización puntual (§4.2, §5.1), no de contenido faltante.

---

## 8. Mapa de dependencias entre documentos (actualizado)

```
FUNDACIONAL
  database/00_database_schema.md   ← esquema + enums + funciones (verdad estructural)
  CLAUDE.md                        ← invariantes de dominio
  ARCHITECTURE.md                  ← verdad de implementación observada
  ESTADO.md                        ← verdad de qué está en producción
  00-general-module/                ← maestros: identidad, territorios, evidencia, ORGANIZACION

        │
        ▼
MÓDULOS OPERATIVOS
  01-recoleccion-module  ──contrato (90-contratos-integracion/01)──►  02-vivero-module  ──contrato (90-contratos-integracion/02)──►  03-plantacion-module

        │
        ▼
DERIVADOS (referencian, no recopian)
  02_flujo/02_procesos, 03_checklist/03_mockups, 04_plan_frontend, 05_handoff

TRANSVERSAL
  decisiones/  ← ADR con el razonamiento detrás de cada invariante de CLAUDE.md
  glosario.md  ← términos, apunta a la fuente canónica de cada uno
```

### Qué NO debe duplicarse nunca (colapsar a una fuente) — vigente

Enums · fórmulas de saldo · invariantes de contrato M1↔M2 y M2↔M3 · convención de unidades · catálogo de roles · política de merma. Hoy cada uno de estos **tiene una fuente única verificada** salvo el formato JSON de requerimientos (que no es un enunciado de dominio, es un formato de archivo).

---

## 9. Arquitectura documental actual (ya implementada, no solo propuesta)

La versión anterior de este documento proponía una arquitectura ideal en su §9. Verificado hoy, **esa propuesta ya está construida**: existe `glosario.md`, existe `decisiones/` con `_historico/`, `90-contratos-integracion/` reemplaza al addendum disperso, cada módulo tiene README, y `database/` quedó reducido a esquema + migraciones documentales. La tabla de canonicidad declarada por aquella propuesta también es hoy una descripción fiel del estado real:

| Concepto | Fuente única | Referencian |
|---|---|---|
| Esquema y enums | `database/00_database_schema.md` | todos |
| Invariantes de dominio | `CLAUDE.md` + `decisiones/` | reglas |
| Reglas por módulo | `NN_module/01_reglas` | procesos, guías, mockups |
| Contrato M1↔M2 | `90-contratos-integracion/01_contrato_recoleccion_a_vivero.md` | Recolección, Vivero |
| Contrato M2↔M3 | `90-contratos-integracion/02_contrato_vivero_a_plantacion.md` | Vivero, Plantación |
| Estado de implementación | `ESTADO.md` | todos |
| Arquitectura técnica | `ARCHITECTURE.md` | todos |

Lo único que falta para que esta tabla sea 100% cierta sin excepciones es el punto de §4.2 (formato JSON) y el de §5.1 (`CLAUDE.md` → `database/supabase/`).

---

## 10. Roadmap de refactorización (re-priorizado, 2026-07-24)

> De los 9 pasos que proponía la versión anterior, 6 ya están hechos (Paso 1 tareas/, Paso 2 tres contradicciones, Paso 3 READMEs, Paso 5 archivado de deuda histórica, Paso 7 huecos de contenido, Paso 8 glosario+ADR). Quedan pasos pequeños y concretos.

### Paso 1 — Corregir la referencia a `database/supabase/` en `CLAUDE.md`
- **Por qué:** es el mismo patrón de riesgo que ya causó confusión con `tareas/`: un punto de entrada de alto tráfico apunta a una ruta que ya no existe.
- **Acción:** actualizar `CLAUDE.md:25` y la sección `## SQL en \`database/supabase/\`` para que digan `database/migrations/`, conservando las convenciones descritas (guards `do $$`, `create table if not exists`, sufijo `_fk`) si siguen aplicando a los scripts de `migrations/`.
- **Riesgo:** Nulo. **Esfuerzo:** Bajo.

### Paso 2 — Homogeneizar el formato JSON de `02-vivero-module/00_requerimientos_vivero_core.json`
- **Por qué:** es el único punto de la duplicación original que sigue abierto; dos formatos de requerimientos conviviendo obliga a cualquier tooling o lectura automatizada a manejar dos esquemas.
- **Acción:** migrar a `{"requerimientos": [{"codigo": "RF-VIV-...", ...}]}`, preservando los campos `Severidad`/`Aplica en MVP`/`Aporta a carbono` como propiedades del objeto en vez de claves de nivel superior distintas.
- **Riesgo:** Bajo (archivo interno, sin lectura automatizada conocida que dependa del formato viejo — sin confirmar). **Esfuerzo:** Bajo.

### Paso 3 — Confirmar que `03_Mockups_Guia_Modulo_3_Plantacion.md` no siga mostrando "mix de especies con topes %" como vigente
- **Por qué:** la versión anterior de este documento lo marcó como fuera del MVP; no se re-leyó el contenido completo del mockup en este pase.
- **Acción:** releer y, si sigue presente, marcarlo explícitamente post-MVP o moverlo a `post-mvp/03-plantacion.md`.
- **Riesgo:** Nulo. **Esfuerzo:** Bajo.

### Paso 4 — Declarar por escrito la frontera de alcance entre `AUDITORIA-DOCUMENTACION.md`, `ARCHITECTURE.md` y `ESTADO.md`
- **Por qué:** los tres documentos auditan cosas relacionadas pero distintas (documentación / sistema implementado / estado de producción); sin una regla explícita, un futuro hallazgo puede terminar duplicado en dos de los tres.
- **Acción:** una línea en cada uno de los tres documentos que remita a los otros dos y aclare su alcance propio (ya presente parcialmente en `ARCHITECTURE.md` §3, falta en `ESTADO.md` y aquí — este documento ya la incorpora en §5.6).
- **Riesgo:** Nulo. **Esfuerzo:** Bajo.

---

### Resumen ejecutivo

La brecha entre este documento y la realidad del repositorio era, en sí misma, el ejemplo más claro del problema que la auditoría original describía: documentación que diverge silenciosamente de su fuente. La "actualización de sincronización" del 2026-07-23 refrescó el resumen narrativo pero no las secciones estructurales (§3/§4), y ese desfase quedó expuesto al usarse este documento como checklist de coherencia para el perfil de proyecto de grado. Verificado hoy contra el árbol real: **la mayor parte del roadmap que la auditoría anterior proponía ya se ejecutó** — contratos consolidados en `90-contratos-integracion/`, ADR unificados en `decisiones/`, glosario creado, READMEs completos, carpeta `tareas/` fantasma eliminada de toda referencia viva, y las tres contradicciones puntuales (LIFO/urgencia, fórmula de saldo, COORDINADOR) corregidas. Queda una deuda pequeña y bien acotada: un formato de JSON sin homogeneizar, una referencia obsoleta en `CLAUDE.md`, y la necesidad de declarar explícitamente cómo se dividen las responsabilidades entre este documento y los dos nuevos (`ARCHITECTURE.md`, `ESTADO.md`) para no volver a duplicar hallazgos entre ellos.
