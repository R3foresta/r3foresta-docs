# Auditoría de documentación — R3Foresta

> **Propósito:** entender el estado actual de la documentación y evaluar su calidad como lo haría un ingeniero senior que se incorpora al proyecto, **antes** de proponer cualquier refactor.
> **Alcance:** todos los `.md`, `.json` y `.sql` del repo. Se **excluyen los `.excalidraw`** (`diagramas/`, `methodology/`) por indicación de `CLAUDE.md`: son material de trabajo en Excalidraw, no documentación canónica.
> **Fecha:** 2026-07-01. **Autor:** auditoría asistida (solo lectura; no se modificó ningún documento del dominio).
>
> **Convención:** los enunciados son **hechos** verificados sobre los archivos salvo cuando digan explícitamente *(suposición)* o *(sin confirmar)*. Las citas usan `archivo:línea` donde aporta.
> **Regla de oro respetada:** este documento **no reescribe, no inventa y no crea** documentación de dominio. Solo audita y propone.

---

## 1. Entender el proyecto (sin criticar todavía)

### ¿Qué problema resuelve R3Foresta?

R3Foresta modela la **cadena de custodia de material biológico para reforestación**, con trazabilidad verificable y anclaje opcional en blockchain. El objetivo de negocio de fondo son los **bonos de carbono** y la **transparencia pública**: poder demostrar, de punta a punta y de forma auditable, que una semilla o esqueje recolectado en una comunidad terminó siendo un árbol plantado y vivo en una zona concreta. La cadena que persigue el sistema es:

`recolección (origen) → vivero (maduración) → plantación (campo) → monitoreo`

Todo el trabajo es en español y el sistema es un **MVP**: prioriza trazabilidad fuerte y simplicidad operativa sobre completitud.

### Módulos principales

- **General (`00-general-module/`, `RF-GEN-*`)** — catálogos y entidades maestras transversales: `USUARIO`, `UBICACION`/territorios (`PAIS`, `DIVISION_ADMINISTRATIVA`), `VIVERO`, `PLANTA`/`TIPO_PLANTA`, `EVIDENCIAS_TRAZABILIDAD`, `METODO_RECOLECCION`. Es la fuente viva de identidad; los demás módulos la consumen y congelan *snapshots*.
- **Recolección — Módulo 1 (`01-recoleccion-module/`, `RF-REC-*`)** — registro del *lote origen* con evidencia fotográfica, GPS y validación. Doble estado: registro (`BORRADOR → PENDIENTE_VALIDACION → VALIDADO/RECHAZADO`) e inventario (`ABIERTO/CERRADO`). Persistencia multicapa (Supabase DB + Storage + IPFS/Pinata + blockchain).
- **Vivero — Módulo 2 (`02-vivero-module/`, `RF-VIV-*`, `RN-VIV-*`)** — maduración pre-plantación. Modelo **híbrido** (estado actual + historial append-only de eventos: `INICIO → EMBOLSADO → (MERMA | DESPACHO | ADAPTABILIDAD)* → CIERRE`). El *lote de vivero* es el agregado central con **origen único**.
- **Plantación — Módulo 3 (`03-plantacion-module/`, `RF-PLA-*`)** — plantación efectiva en campo. Arquitectura de dos niveles: `CAMPANIA` (estratégica, estado derivado) → `SUBCAMPANIA` (operativa, con polígono, meta, equipo). Incluye mantenimiento (mortandad + reposición) y vista pública.
- **Base de datos (`database/`)** — esquema ER consolidado en Mermaid (`00_database_schema.md`), documentos de decisiones de arquitectura y un script SQL de soporte.

### ¿Cómo interactúan?

- **General** es consumido por los tres módulos operativos vía snapshots congelados (no se recalcula identidad ya validada).
- **Recolección → Vivero**: contrato estricto en `INICIO`. Crear el lote de vivero y descontar el saldo del origen es **una transacción atómica**; cantidades y unidades quedan alineadas entre `RECOLECCION_MOVIMIENTO`, `LOTE_VIVERO` y `EVENTO_LOTE_VIVERO`.
- **Vivero ↔ Plantación**: contrato de reservas. *Asignar* y *devolver* árboles a una subcampaña son **reservas lógicas** (no tocan `saldo_vivo_actual`, no generan evento en M2); *plantar* o *reponer* en M3 genera un `DESPACHO` automático que sí baja el saldo. Las mermas de vivero pueden desbordar sobre asignaciones activas.

### ¿Qué parece implementado vs. planeado?

- **Modelado en BD (implementado o casi):** el esquema de los cuatro módulos existe en `00_database_schema.md`. Recolección tiene su script de historial (`database/supabase/01_create_recoleccion_historial.sql`). Según `CLAUDE.md`, Plantación está modelada vía migraciones 027–032.
- **Pendiente (planeado):** el propio esquema marca como pendientes varios FKs físicos (`"FK fisico pendiente de ALTER en BD"`) y contadores materializados por trigger (`"materializado por trigger (tarea pendiente)"`). `CLAUDE.md` describe pendientes: handler atómico de despacho automático, triggers de contadores, job nocturno de transición a `MONITOREO_HISTORICO`. La **integración M2↔M3** está *documentada y absorbida* (2026-05-21) pero **no en producción** hasta cerrar tareas.
- *(Suposición)*: como Claude no ve los repos de implementación (así lo dice `CLAUDE.md`), "implementado" aquí significa "documentado como aplicado", no verificado contra código.

### Documentos más importantes (núcleo del proyecto)

1. **`database/00_database_schema.md`** — el ER consolidado; es el artefacto más completo y actual, y de facto la fuente de verdad estructural.
2. **`CLAUDE.md`** — invariantes de dominio, convenciones y protocolo de trabajo. Punto de entrada para agentes.
3. **`02-vivero-module/01_regas_de_negocio_vivero.md`** — reglas `RN-VIV-01..60`; incluye el contrato M2↔M3 formal.
4. Los **`00_Requerimientos_*.json`** y **`01_reglas_*.md`** de cada módulo, más **`03-plantacion-module/02_Procesos_Modulo_3_Plantacion.md`**.

---

## 2. Análisis de la estructura documental

### Organización de carpetas (hecho)

```
r3foresta-docs/
├─ README.md, CLAUDE.md
├─ 00-general-module/     README + 00_json + 01_reglas + 02_guia + 03_decisiones + agregar.md
├─ 01-recoleccion-module/ README + 00_requerimientos + 01_reglas + 02_flujo + 03_checklist
├─ 02-vivero-module/      00_json + 01_reglas + 02_guia + 03_addendum + 03_operativo + 04_consumo + image.png
├─ 03-plantacion-module/  00_json + 02_procesos + 03_mockups        (sin 01_reglas, sin README)
├─ database/           00_schema + 03_planeacion + 04_decisiones + supabase/01_*.sql
├─ diagramas/          *.excalidraw   (ignorado)
└─ methodology/        *.excalidraw   (ignorado)
```

La **intención** de la estructura es buena: un patrón numerado por módulo (`00` requerimientos, `01` reglas, `02` procesos, …). Pero la ejecución es despareja. Evaluación por dimensión:

| Dimensión | Estado | Evidencia |
|---|---|---|
| **Consistencia de nombres** | ⚠️ Débil | Typos en nombres de archivo: M1 ya fue normalizado a `00_requerimientos_recoleccion.json` y `01_reglas_de_negocio_recoleccion.md`; persisten otros typos fuera de M1 como `01_regas_de_negocio_*` y `02_doc_guia_viviero.md` ("viviero"). |
| **Jerarquía de documentos** | ⚠️ Irregular | Numeración con huecos: plantación va `00,02,03` (falta `01`); database va `00,03,04` (faltan `01,02`). Vivero tiene **dos** archivos con prefijo `03` (`03_Addendum` y `03_operativo`). |
| **Descubribilidad** | ⚠️ Débil | El `README.md` raíz no funciona como índice real (ver abajo). No hay glosario ni mapa de "qué doc es canónico". |
| **Puntos de entrada** | ⚠️ Parcial | `CLAUDE.md` es un gran punto de entrada para agentes, pero apunta a `tareas/` que **no existe**. El README raíz está incompleto. |
| **Índices** | ❌ Falta | No hay índice global navegable. |
| **READMEs por módulo** | ⚠️ Incompleto | Solo `00-general-module/` y `01-recoleccion-module/` tienen README. **Faltan** en `02-vivero-module/`, `03-plantacion-module/` y `database/`, aunque `CLAUDE.md` dice "README.md por módulo". |
| **Carpetas redundantes** | ✔️ Aceptable | No hay carpetas redundantes; `diagramas/` y `methodology/` contienen solo `.excalidraw` (fuera de alcance). |

### Problemas concretos del punto de entrada

- **`README.md` raíz** (hecho): (a) contiene **2 rutas absolutas de máquina** `/Users/pabloandresfernandezcari/...` como enlaces — no portables, se rompen en cualquier otra máquina; (b) **no menciona `03-plantacion-module/`** (el Módulo 3, que sí existe y está muy desarrollado); (c) enlaza general y recolección pero deja vivero y database como texto plano.
- **Formato heterogéneo de requerimientos** (hecho): `general`, `recoleccion` y `plantacion` usan `{"requerimientos":[...]}`; `02-vivero-module/00_...json` usa un **array plano** con claves distintas (`"Severidad"`, `"Aplica en MVP"`, `"Aporta a carbono"`). Dos "esquemas" de JSON conviviendo.
- **Reglas de M3 alojadas en M2** (hecho): plantación no tiene `01_reglas`; sus reglas de integración viven como `RN-VIV-47..60` dentro de `02-vivero-module/01_regas_de_negocio_vivero.md`, y otras decisiones (p. ej. `RN-VIV-60` reposición de especie libre) rigen comportamiento de M3.

---

## 3. Clasificación de todos los documentos

Leyenda — **Utilidad**: Alta/Media/Baja. **Completitud**: Completo/Parcial. **Refleja el sistema actual** (confianza): Alta/Media/Baja. **¿Mantenido?**: Sí/Parcial/No. **Acción**: Mantener / Fusionar / Archivar / Depurar.

| # | Documento | Propósito | Utilidad | Completo | Refleja actual | Mantenido | Acción sugerida |
|---|---|---|---|---|---|---|---|
| 1 | `README.md` (raíz) | Índice del repo | Alta | Parcial | Baja | No (2026-04-30) | **Rehacer** como índice real (sin rutas absolutas; incluir M3) |
| 2 | `CLAUDE.md` | Invariantes + protocolo para agentes | Alta | Completo | Media-Alta | Sí (2026-05-26) | **Mantener**; reconciliar refs a `tareas/` y término "LIFO" |
| 3 | `00-general-module/README.md` | Propósito y dependencias del módulo | Alta | Completo | Alta | Sí | Mantener (añadir `ORGANIZACION`) |
| 4 | `00-general-module/00_Requerimientos_Modulo_General.json` | RF-GEN-01..06 | Alta | Completo | Alta | Sí | Mantener |
| 5 | `00-general-module/01_reglas_de_negocio_general.md` | RN-GEN-01..26 | Alta | Completo | Alta | Sí | Mantener |
| 6 | `00-general-module/02_guia_operativa_modulo_general.md` | Cómo administrar catálogos | Media | Completo | Alta | Sí | Mantener |
| 7 | `00-general-module/03_decisiones_pendientes_general.md` | Decisiones de MVP | Media | Completo | Alta | Parcial | **Depurar/renombrar**: el título dice "pendientes" pero el contenido está **cerrado** |
| 8 | `00-general-module/agregar.md` | Nota suelta sobre evidencia/compresión | Baja | Parcial | Media | Parcial (2026-06-23, el más reciente) | **Fusionar** en reglas de evidencia; nombre genérico sin prefijo |
| 9 | `01-recoleccion-module/README.md` | Resumen del flujo M1 | Media | Parcial | Media | Sí | Mantener; sincronizar cifra de fotos |
| 10 | `01-recoleccion-module/00_requerimientos_recoleccion.json` | RF-REC-01..05 | Alta | Completo | Alta | Sí | Mantener |
| 11 | `01-recoleccion-module/01_reglas_de_negocio_recoleccion.md` | RN-REC-01..27 | Alta | Completo | Alta | Sí | Mantener |
| 12 | `01-recoleccion-module/02_flujo_operativo_recoleccion.md` | Flujo operativo fusionado de M1 | Alta | Completo | Alta | Sí | Mantener |
| 13 | `01-recoleccion-module/03_checklist_validacion_recoleccion.md` | Checklist de desarrollo y QA de M1 | Media | Completo | Alta | Sí | Mantener |
| 14 | Documentos M1 fusionados | Procesos, diagramas y operativo antiguo | Media | Fusionado | Alta | No | Eliminados tras fusionar en `02_flujo_operativo_recoleccion.md` |
| 15 | `02-vivero-module/00_Requerimientos-Modulo_2_Vivero.json` | RF-VIV-01..14 | Alta | Completo | Media-Alta | Sí | Mantener; corregir "LIFO" en RF-VIV-03/14 |
| 16 | `02-vivero-module/01_regas_de_negocio_vivero.md` | RN-VIV-01..60 (incl. contrato M3) | Alta | Completo | **Alta** (fuente correcta del criterio de merma) | Sí | **Mantener** — candidato a fuente de verdad de reglas |
| 17 | `02-vivero-module/02_doc_guia_viviero.md` | Guía operativa M2 + §13 integración | Alta | Completo | Media | Sí | Mantener; renombrar (typo); resolver contradicción interna LIFO/urgencia |
| 18 | `02-vivero-module/03_Addendum_Modulo_2_por_Modulo_3.md` | Contrato negociado M2↔M3 | Media | Completo | Media | No (autodeclarado "ABSORBIDO") | **Archivar** a histórico/decisiones |
| 19 | `02-vivero-module/03_operativo_modulo_vivero.md` | Resumen operativo corto M2 (pre-M3) | Media | Parcial | Media-Baja | Parcial | **Fusionar** con 04_consumo; enum `destino_tipo` viejo |
| 20 | `02-vivero-module/04_consumo_de_vivero.md` | Operativo del consumo M2 (con M3) | Alta | Completo | Media-Alta | Sí | Mantener como operativo único de consumo |
| 21 | `02-vivero-module/image.png` | Imagen sin referencia hallada | Baja | — | — | No | **Depurar** (sin uso aparente en los `.md`) |
| 22 | `03-plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json` | RF-PLA-01..17 | Alta | Completo | **Media** (contiene ítems desactualizados) | Parcial | **Depurar**: RF-PLA-17 y RF-PLA-04 contradicen decisiones cerradas |
| 23 | `03-plantacion-module/02_Procesos_Modulo_3_Plantacion.md` | Proceso M3 detallado | Alta | Completo | Alta | Sí | **Mantener** — mejor doc de M3 |
| 24 | `03-plantacion-module/03_Mockups_Guia_Modulo_3_Plantacion.md` | Guía UX/mockups M3 | Media | Completo | Media | Parcial | Depurar: muestra "mix de especies con topes %", que está **fuera del MVP** |
| 25 | `database/00_database_schema.md` | ER canónico (mermaid) + enums + funciones | **Alta** | Completo | **Alta** | Sí (2026-05-27) | **Mantener** — fuente de verdad estructural |
| 26 | `database/03_planeacion_arquitectura_bd_mvp_vivero.md` | Comparativa de 3 arquitecturas (vivero) | Baja | Completo | Media-Baja | No | **Archivar**: superado por `04`; nombres de tabla viejos |
| 27 | `database/04_decisiones_bd_vivero_final.md` | ADR de vivero (14 decisiones) | Media-Alta | Completo | Media | Parcial | Mantener contenido, **mover** a ADR unificado; es solo-vivero |
| 28 | `database/supabase/01_create_recoleccion_historial.sql` | Migración de `recoleccion_historial` | Media | Parcial | Alta (para esa tabla) | No | Mantener; aclarar que `supabase/` **no** es el set real de migraciones |

*(Nota metodológica)*: `.claude/`, `.vscode/`, `.gitignore` son configuración, no documentación; no se clasifican pero se mencionan donde aportan.

---

## 4. Conocimiento duplicado (y por qué es peligroso aquí)

La duplicación es el problema **número uno** del repo. El principio de `CLAUDE.md` ("cada pieza de conocimiento tiene un único lugar canónico; todo lo demás lo referencia; nunca duplicar") **se enuncia pero no se cumple**. Peor: varias copias **ya divergieron**, que es exactamente el riesgo. Casos verificados, del más grave al más leve:

### 4.1. Política de merma sobre asignaciones — "LIFO" vs. "urgencia" (drift real)

- **Fuente correcta (actual):** `RN-VIV-50` en `02-vivero-module/01_regas_de_negocio_vivero.md` — el excedente se distribuye ordenando por `subcampania.fecha_estimada_inicio DESC NULLS FIRST` (la subcampaña que empieza **más tarde** absorbe primero; la más urgente queda protegida). Coincide con `CLAUDE.md` (invariante), `plantacion §9.4`, `04_consumo §4` y `addendum §7`.
- **Término obsoleto "LIFO" ("la más nueva primero")** sigue vivo en **6 archivos**: `database/00_database_schema.md:264` (comentario del esquema canónico), `03_Addendum:5,687`, `04_consumo_de_vivero.md:43,286,324`, `00_...Vivero.json:36,161` (título de RF-VIV-14 = "Politica LIFO"), `02_doc_guia_viviero.md:619`, y `CLAUDE.md:64`.
- **Contradicción interna:** en `04_consumo` y en `02_guia`, el **cuerpo** describe el orden por urgencia (`fecha_estimada_inicio DESC`) mientras el **rótulo/resumen** dice "LIFO". El mismo documento se contradice.
- **Fuente de verdad recomendada:** `RN-VIV-50`. Todo lo demás debe referenciarla y eliminar el término "LIFO" (o dejarlo solo como nota histórica de que la política **cambió** de LIFO a urgencia).

### 4.2. Fórmula `saldo_asignado_disponible` — 3 términos vs. 4 términos

- **Correcta (4 términos):** `cantidad_asignada − cantidad_consumida − cantidad_devuelta − cantidad_mermada`. Aparece en `database/00_database_schema.md`, `04_consumo`, `00_...Vivero.json` (RF-VIV-13) y `CLAUDE.md`.
- **Obsoleta (3 términos, sin `cantidad_mermada`):** `03-plantacion-module/00_...json:132` (RF-PLA-04) y `plantacion §8.1`. Los docs de M3 quedaron atrás porque se escribieron antes de la política de merma-sobre-asignación (RF-VIV-14).
- **Peligro:** si el backend de M3 implementa la fórmula tal como la dicta su propio JSON, calcula mal el saldo disponible. Es un bug latente nacido de la duplicación.

### 4.3. Contradicción `COORDINADOR` como rol global

- **Correcto:** `rol_usuario = [ADMIN, GENERAL, VALIDADOR, VOLUNTARIO]` es un catálogo **cerrado**; la coordinación es **membresía** en `SUBCAMPANIA_EQUIPO.rol_en_subcampania` (`database/00_database_schema.md:599`, `plantacion §2.10/§12`, invariante de `CLAUDE.md`).
- **Obsoleto:** `03-plantacion-module/00_...json:500` (RF-PLA-17) dice *"COORDINADOR es un rol nuevo a crear en el enum rol_usuario"*. Contradice directamente el esquema y `CLAUDE.md`.

### 4.4. Otras duplicaciones (mismo enunciado copiado en N lugares)

| Conocimiento | Copias (aprox.) | Debería ser fuente única |
|---|---|---|
| Enum `destino_tipo_vivero` | **3 definiciones distintas**: schema (6 valores con `PLANTACION_CAMPANIA`), `02_guia §4.5`/`03_operativo` (5 valores viejos, sin `PLANTACION_CAMPANIA`), addendum (recomienda `DONACION_COMUNIDAD`) | `database/00_database_schema.md` |
| Invariantes M1↔M2 (`abs(delta)=cantidad_inicial_en_proceso`, …) | ~8: RN-REC-24A, recolección 02 §3.4, RF-REC-05, RN-VIV-16A/17A, vivero 02 §4.1, RF-VIV-01, database 04 §10, CLAUDE.md | Reglas (RN) + schema |
| Convención de unidades (`UNIDAD`/`G`, `kg` no persiste) | ubicua (los 4 módulos + database 03/04 + CLAUDE) | Una nota canónica referenciada |
| Requisito de fotos de recolección (mín. 2 / máx. 10) | ~7: README M1, RN-REC-14, procesos §3.2/§6, 04_operativo, RF-REC-04, diagrama, CLAUDE.md | RN-REC-14 |
| Contrato M2↔M3 completo | 5+: addendum, 04_consumo, 02_guia §13, RN-VIV-47..60, plantación §9 | RN-VIV (reglas) + schema |

**Por qué es peligroso aquí en particular:** este es un proyecto de **trazabilidad con certificación de carbono**; los números tienen que cuadrar. Una fórmula de saldo o una política de merma que difiere entre el doc de M2 y el de M3 no es un detalle cosmético: es una discrepancia que, si llega al backend, rompe la conservación de saldos (la "identidad fundamental" que los propios docs marcan como *bug crítico si se rompe*). Además `CLAUDE.md` obliga a **mantener numeración estable de reglas** — bien —, pero eso no sirve si el mismo hecho se reafirma con otras palabras en cinco sitios que luego no se actualizan juntos.

---

## 5. Deuda documental

### 5.1. Carpeta `tareas/` fantasma (el hallazgo más grave de coherencia)

- **Hecho:** `CLAUDE.md` dedica dos secciones completas al directorio `tareas/` (protocolo de cierre, `tareas/modulo-2-integracion-modulo-3/`, mover a `completadas/`, etc.) y lo menciona **7 veces**. El historial de git muestra trabajo real sobre "tarea 1..11" y un commit "tareas completadas".
- **Hecho:** **la carpeta `tareas/` no existe** en el árbol actual.
- **Consecuencia:** hay **4 enlaces rotos** a `tareas/` en documentos de dominio: `03_Addendum` (justifica su propia existencia diciendo que "las tareas lo referencian sección por sección"), `04_consumo:411`, `02_doc_guia_viviero §13.8`, y `plantacion §2.12` (enlace a `completadas/10_docs_flujo_...md`). Más las 7 menciones de `CLAUDE.md`.
- *(Suposición, sin confirmar)*: la carpeta se **completó y se borró**, dejando `CLAUDE.md` y 4 docs apuntando a la nada. Alternativa: vive en otra rama. En cualquier caso, el "estado del proyecto" que `CLAUDE.md` promete poder reconstruir "leyendo solo los archivos del repo" **hoy no se puede** para la integración M2↔M3.

### 5.2. Addendum absorbido pero vivo

`03_Addendum_Modulo_2_por_Modulo_3.md` **se autodeclara**: *"Estado: ABSORBIDO en la documentación oficial… No es la fuente operativa"* y justifica conservarse *"porque las tareas técnicas lo referencian"* — justificación **ya inválida** (§5.1). Es una nota histórica mezclada entre documentos vigentes. Además `04_consumo:407` lo llama *"fuente canónica del contrato M2↔M3"*, mientras el propio addendum dice que **no** es la fuente operativa: **canonicidad circular/contradictoria**.

### 5.3. Documentos de planeación superados

`database/03_planeacion_arquitectura_bd_mvp_vivero.md` (comparativa "3 alternativas, elegimos híbrido") está **subsumido** por `database/04_decisiones_bd_vivero_final.md`. Ambos son **solo de vivero** pese a vivir en la carpeta general `database/`, y ambos usan **nombres de tabla viejos** (`LOTE_VIVERO_EVENTO`, `EVIDENCIA_TRAZABILIDAD`, `EVENTO_EVIDENCIA`) que **no coinciden** con el esquema canónico (`EVENTO_LOTE_VIVERO`, `EVIDENCIAS_TRAZABILIDAD`).

### 5.4. Requerimientos JSON rezagados

`03-plantacion-module/00_...json` contiene conocimiento **congelado antes** de decisiones cerradas: RF-PLA-17 (COORDINADOR al enum, §4.3) y RF-PLA-04 (fórmula de 3 términos, §4.2). Es el caso de libro de **"un documento existe desactualizado porque otro se actualizó y este no"**: el MD de procesos y `CLAUDE.md` se corrigieron; el JSON no.

### 5.5. Notas sueltas e histórico incrustado

- `00-general-module/agregar.md`: nota de política de compresión de evidencia, sin prefijo numérico, con una sección "Pendiente para M3". Debería vivir dentro de las reglas de evidencia (RN-GEN-21..23), no como archivo aparte.
- `00-general-module/03_decisiones_pendientes_general.md`: el nombre dice "pendientes" pero **todo está cerrado** ("decisión tomada", "quedan cerrados para el MVP"). El título miente sobre el contenido.
- `03_Mockups`: muestra UI de **mix de especies con topes %** (§3.6 Paso 3, §3.8.3), decisión que está **fuera del MVP** (`plantación §2.12`, `CLAUDE.md`).
- Término **"LIFO"** vestigial hasta en el esquema canónico y en `CLAUDE.md` (§4.1).
- `02-vivero-module/image.png`: sin referencia hallada en los `.md`.

---

## 6. Salud de la documentación (puntajes 1–10)

| Categoría | Puntaje | Justificación |
|---|---:|---|
| **Mantenibilidad** | **4** | Un cambio de una regla obliga a tocar 5–8 archivos. Ya hay *drift* real (LIFO/urgencia, fórmula 3 vs 4 términos, enum `destino_tipo`). Sin fuentes únicas declaradas, cada edición arriesga nueva divergencia. |
| **Escalabilidad** | **5** | El patrón por módulo (`00/01/02/…`) escala en teoría, pero ya se rompe al 4.º módulo: plantación sin `01_reglas`, reglas de M3 dentro de M2, `database/` mezclando esquema canónico con ADRs solo-vivero. |
| **Claridad** | **7** | Los documentos **individuales** son de alta calidad: bien redactados, con ejemplos numéricos, matrices, diagramas Mermaid y decisiones justificadas. El problema no es la claridad local sino la coherencia global. |
| **Consistencia** | **3** | Contradicciones verificadas (COORDINADOR, fórmula de saldo, LIFO/urgencia, 3 enums `destino_tipo`), typos en nombres de archivo, dos formatos de JSON, numeración con huecos, canonicidad circular addendum↔04_consumo. |
| **Separación de responsabilidades** | **4** | Reglas de M3 en M2; ADRs de vivero en `database/`; `ORGANIZACION` (maestro) documentado solo en M3; addendum histórico junto a docs vigentes; `agregar.md` fuera del sistema numerado. |
| **Onboarding de un dev nuevo** | **5** | `CLAUDE.md` es un excelente mapa mental… que apunta a `tareas/` inexistente. README raíz incompleto, sin glosario ni índice. Un recién llegado no sabe cuál doc manda entre addendum / 04_consumo / 02_guia / reglas. |
| **Facilidad de mantenimiento futuro** | **4** | Sin fuente única por concepto, el costo de mantener coherencia **crece con cada módulo nuevo**. La deuda ya presente (tareas fantasma, JSON rezagados) se acumulará. |

**Salud global ponderada: ≈ 4.5 / 10.** Diagnóstico de una frase: **excelentes documentos individuales, arquitectura documental incoherente.** La buena noticia es que casi todo el material fuente es de calidad; el trabajo pesado es de **organización y consolidación**, no de reescritura de contenido.

---

## 7. Documentación faltante (solo lo que aportaría de verdad — no se crea aquí)

1. **Índice / mapa documental global** — un README raíz que funcione como tabla de contenidos navegable (los 4 módulos + database + qué doc es canónico para qué). Hoy no existe de forma utilizable.
2. **Glosario canónico de términos** — `saldo_vivo_actual`, `saldo_asignado_disponible`, `saldo_vivo_disponible_asignacion`, "snapshot", "reserva lógica", "despacho automático vs. manual", "material en proceso vs. plantas vivas". Estos términos se re-explican en cada doc; deberían definirse una vez.
3. **Catálogo de enums único** — hoy los enums viven en el schema pero se recopian y **divergen** (`destino_tipo_vivero`). Una sola fuente referenciable evitaría el problema de §4.4.
4. **Registro de decisiones (ADR) unificado** — las decisiones están dispersas: `database/04` (solo vivero), `general/03`, invariantes de `CLAUDE.md`, "Decisión cerrada 2026-05-24" suelta en plantación. Un `decisiones/` central con una entrada por decisión.
5. **Documento del maestro `ORGANIZACION` en `00-general-module/`** — el esquema mismo marca `%% Placeholder defensivo (modulo General aun no la define)`. Es una entidad maestra documentada solo en M3.
6. **Estado real de implementación (roadmap vivo)** — qué está en producción vs. pendiente. Hoy esa información vivía en `tareas/` (inexistente) y en notas sueltas del schema ("tarea pendiente").
7. **`03-plantacion-module/01_reglas_de_negocio_plantacion.md` + README del módulo** — para que M3 no dependa de reglas alojadas en M2.
8. *(Opcional)* **Guía de contribución humana (`CONTRIBUTING`)** — las reglas del "bibliotecario" (no duplicar, numeración estable) están en `CLAUDE.md` para agentes; convendría una versión para colaboradores humanos.

Documentación que **no** hace falta inventar: no recomiendo "API docs" formales todavía (la API aún no está cerrada según los propios docs), ni diagramas nuevos (los Excalidraw y los Mermaid ya cubren el flujo).

---

## 8. Mapa de dependencias entre documentos

### Capas (de fundacional a derivado)

```
FUNDACIONAL
  database/00_database_schema.md   ← esquema + enums + funciones (verdad estructural)
  CLAUDE.md                        ← invariantes de dominio
  00-general-module/ (RF-GEN, RN-GEN) ← maestros: identidad, territorios, evidencia, ORGANIZACION*

        │ (consumen maestros y congelan snapshots)
        ▼
MÓDULOS OPERATIVOS
  01-recoleccion-module  ──contrato M1↔M2──►  02-vivero-module  ──contrato M2↔M3──►  03-plantacion-module
     (RF-REC/RN-REC)                        (RF-VIV/RN-VIV)                      (RF-PLA)

        │ (cada módulo: requerimientos → reglas → procesos → guías/operativos/mockups)
        ▼
DERIVADOS (deben REFERENCIAR, no recopiar)
  02_procesos, 03_diagrama, 04_operativo, 02_guia, 04_consumo, 03_mockups
```

### Reglas de dependencia (cómo *debería* fluir)

- **Fundacionales** (schema, `CLAUDE.md`, general): nadie por encima; todos dependen de ellos.
- **Reglas de negocio (`01_reglas` / `RN-*`)** de cada módulo: son el contrato semántico. Los **procesos, guías, operativos y mockups** deben **referenciarlas**, no reescribir sus enunciados.
- **Requerimientos (`00_*.json`)**: deben mantenerse **alineados** con reglas + schema (hoy plantación no lo está, §5.4).
- **Cross-módulo**: recolección referencia general; vivero referencia recolección + general; plantación referencia vivero + general. El contrato M2↔M3 debe tener **una** fuente (propuesta: `RN-VIV-47..60` + schema).

### Qué NO debe duplicarse nunca (colapsar a una fuente)

Enums · fórmulas de saldo · invariantes de contrato M1↔M2 y M2↔M3 · convención de unidades · catálogo de roles · política de merma. Cada uno de estos hoy vive en 3–8 sitios (§4).

---

## 9. Arquitectura documental ideal (propuesta, sin mover archivos todavía)

Objetivo: **una fuente canónica por pieza de conocimiento**; todo lo demás referencia. Estructura propuesta:

```
r3foresta-docs/
├─ README.md                      # ÍNDICE real y navegable (sin rutas absolutas), incluye M3
├─ CLAUDE.md                      # invariantes para agentes; referencia al ADR, no lo duplica
├─ glosario.md                    # (nuevo) términos + su fuente canónica
├─ decisiones/                    # (nuevo) ADR unificado, una entrada por decisión
│   ├─ README.md                  # índice de ADRs
│   ├─ 0001-modelo-hibrido-vivero.md      # ← de database/04
│   ├─ 0002-origen-unico-lote.md
│   ├─ 000N-merma-por-urgencia.md         # cierra el drift LIFO
│   └─ _historico/
│       ├─ addendum-m2-m3.md              # ← 03_Addendum (archivado)
│       └─ planeacion-bd-vivero.md        # ← database/03 (archivado)
├─ database/
│   └─ 00_database_schema.md      # ÚNICA fuente de esquema + enums + funciones
│   └─ supabase/                  # scripts; README aclara que no es el set real de migraciones
├─ 00-general-module/  README + 00_requerimientos + 01_reglas + 02_guia + 03_organizacion(nuevo)
├─ 01-recoleccion-module/ README + 00_requerimientos + 01_reglas + 02_flujo + 03_checklist
├─ 03-plantacion-module/ README(nuevo) + 00_requerimientos + 01_reglas(nuevo) + 02_procesos + 03_mockups
└─ 02-vivero-module/   README(nuevo) + 00_requerimientos + 01_reglas + 02_procesos + 03_consumo(operativo único)
```

### Responsabilidades por documento (contrato de contenido)

- **`database/00_database_schema.md`**: única fuente de esquema, **enums** y funciones. Todo enum citado en otros docs se referencia desde aquí.
- **`01_reglas` de cada módulo**: única fuente de las reglas `RN-*`. El contrato M2↔M3 (`RN-VIV-47..60`) es la fuente del criterio de merma, saldos y despacho — se elimina "LIFO" y queda "urgencia".
- **`00_requerimientos.json`**: se **homogeneíza** el formato entre módulos y se **sincroniza** con reglas + schema.
- **Procesos / guías / operativos / mockups**: narran flujo y UX; **enlazan** a reglas/schema en vez de recopiar fórmulas, invariantes o enums.
- **`glosario.md`** y **`decisiones/`**: absorben lo que hoy está disperso.

### Qué desaparece / se transforma

- **Desaparecen como docs vivos** (van a `decisiones/_historico/`): `03_Addendum`, `database/03_planeacion`.
- **Se fusionan**: `03_operativo_modulo_vivero.md` → dentro del operativo único de consumo; `agregar.md` → dentro de reglas de evidencia de general.
- **Se renombran** (arreglar typos, cerrar huecos de numeración): M1 ya fue normalizado; quedan pendientes fuera de M1 casos como `01_regas_*`→`01_reglas_*` y `02_doc_guia_viviero`→`02_procesos_vivero`.
- **Se depuran**: `general/03_decisiones_pendientes` (renombrar a "cerradas" o mover a ADR), `image.png` (si no se usa), mix de especies en mockups.

### Fuentes de verdad declaradas (tabla de canonicidad)

| Concepto | Fuente única | Referencian |
|---|---|---|
| Esquema y enums | `database/00_database_schema.md` | todos |
| Invariantes de dominio | `CLAUDE.md` + `decisiones/` | reglas |
| Reglas por módulo | `NN_module/01_reglas` | procesos, guías, mockups |
| Contrato M2↔M3 (merma, saldos, despacho) | `RN-VIV-47..60` | plantación, 04_consumo, addendum(histórico) |
| Maestros (incl. `ORGANIZACION`) | `00-general-module/` | M1, M2, M3 |

---

## 10. Roadmap de refactorización (priorizado, mayor → menor impacto)

> Principio rector: **corregir incoherencias que podrían llegar al código primero; embellecer estructura después.** Cada paso es no destructivo y preserva historia (nada se borra sin archivar).

### Paso 1 — Reconciliar la carpeta `tareas/` fantasma y sus enlaces rotos
- **Por qué primero:** rompe la promesa central de `CLAUDE.md` ("reconstruir el estado leyendo el repo") y deja 4 enlaces muertos + 7 menciones. Es la incoherencia más visible para cualquiera que abra el repo hoy.
- **Beneficio:** el estado real de la integración M2↔M3 vuelve a ser reconstruible; se elimina confusión de onboarding.
- **Acción:** decidir entre (a) restaurar `tareas/` (si existe en otra rama) o (b) mover el estado de implementación a un `decisiones/` o `ESTADO.md` vivo y actualizar las referencias en `CLAUDE.md` + los 4 docs.
- **Riesgo:** Bajo. **Esfuerzo:** Bajo *(sin confirmar si hay que recuperar contenido de otra rama)*.

### Paso 2 — Resolver las 3 contradicciones verificadas (declarar fuente de verdad)
- **Por qué:** son **bugs latentes**, no cosmética: (a) fórmula `saldo_asignado_disponible` 3 vs 4 términos; (b) `COORDINADOR` en enum `rol_usuario` (RF-PLA-17); (c) "LIFO" vs "urgencia".
- **Beneficio:** el backend no puede implementar la versión equivocada; se protege la conservación de saldos (bug crítico según los propios docs).
- **Acción:** corregir RF-PLA-04 y RF-PLA-17 en el JSON de plantación para que citen la fórmula de 4 términos y la membresía; sustituir "LIFO" por "urgencia" (o nota histórica) en los 6 archivos. **Sin renumerar reglas** (regla de `CLAUDE.md`).
- **Riesgo:** Bajo-Medio (editar varios archivos con cuidado). **Esfuerzo:** Medio.

### Paso 3 — Rehacer el `README.md` raíz + añadir los READMEs faltantes
- **Por qué:** es el primer punto de contacto y hoy está incompleto (sin M3, con rutas absolutas de máquina).
- **Beneficio:** onboarding inmediato; discoverability.
- **Acción:** índice navegable sin rutas absolutas, incluyendo `03-plantacion-module/` y `database/`; crear README en vivero, plantación y database.
- **Riesgo:** Nulo. **Esfuerzo:** Bajo.

### Paso 4 — Colapsar la duplicación estructural a fuentes únicas
- **Por qué:** es la causa raíz del *drift*; mientras exista, cada edición reintroduce divergencia.
- **Beneficio:** mantenibilidad sube de forma sostenida; un cambio se hace en un solo lugar.
- **Acción:** unificar enums (una sola definición de `destino_tipo_vivero`), invariantes M1↔M2 y convención de unidades; que procesos/guías **referencien** reglas+schema en vez de recopiar. Declarar la tabla de canonicidad (§9).
- **Riesgo:** Medio (hay que tocar muchos docs y decidir qué se cita). **Esfuerzo:** Medio-Alto.

### Paso 5 — Archivar la deuda histórica
- **Por qué:** el addendum "absorbido" y `database/03` confunden sobre qué manda.
- **Beneficio:** menos ruido; canonicidad clara.
- **Acción:** mover `03_Addendum` y `database/03_planeacion` a `decisiones/_historico/`; fusionar `agregar.md` en reglas de evidencia; renombrar/mover `general/03_decisiones_pendientes`.
- **Riesgo:** Bajo (actualizar los enlaces entrantes). **Esfuerzo:** Bajo.

### Paso 6 — Homogeneizar convenciones (nombres, numeración, formato JSON)
- **Por qué:** consistencia y profesionalismo; hoy hay typos y dos formatos de requerimientos.
- **Beneficio:** navegación predecible; menos fricción cognitiva.
- **Acción:** corregir typos de nombre de archivo, cerrar huecos de numeración, unificar el esquema de los `00_*.json`.
- **Riesgo:** Medio — **renombrar archivos rompe enlaces**; hay que actualizar todas las referencias entrantes en el mismo commit.
- **Esfuerzo:** Medio.

### Paso 7 — Cubrir los huecos de contenido reales
- **Por qué:** `ORGANIZACION` sin dueño y M3 sin reglas propias son fragilidades estructurales.
- **Beneficio:** separación de responsabilidades correcta.
- **Acción:** documentar `ORGANIZACION` en general; crear `03-plantacion-module/01_reglas` (moviendo/espejando las `RN` de M3 que hoy viven en M2, con numeración estable).
- **Riesgo:** Bajo. **Esfuerzo:** Bajo-Medio.

### Paso 8 — Crear glosario y ADR unificado
- **Por qué:** cierra la puerta a futura duplicación de definiciones y decisiones.
- **Beneficio:** valor compuesto a largo plazo; el repo se vuelve auto-explicativo.
- **Acción:** `glosario.md` + `decisiones/` con una entrada por decisión (migrando `database/04`, `general/03`, invariantes de `CLAUDE.md`).
- **Riesgo:** Bajo. **Esfuerzo:** Medio.

### Paso 9 — Depuración final (bajo impacto)
- **Acción:** quitar el mix-de-especies de los mockups (o marcarlo "post-MVP"), resolver `image.png`, barrer términos vestigiales.
- **Riesgo:** Nulo. **Esfuerzo:** Bajo.

---

### Resumen ejecutivo

R3Foresta tiene **documentación de contenido excelente sobre una arquitectura documental frágil**. El dominio está bien pensado y bien escrito módulo por módulo. Los riesgos no están en lo que dice cada documento, sino en que **el mismo hecho se repite en muchos documentos y ya empezó a divergir** (fórmula de saldo, política de merma, rol de coordinador), y en que **el andamiaje de navegación se degradó** (carpeta `tareas/` fantasma, README raíz incompleto, addendum absorbido pero vivo). El camino de mayor retorno es **declarar fuentes de verdad y consolidar**, empezando por las contradicciones que podrían filtrarse al backend, y dejando la cosmética estructural para el final. Ningún paso exige reescribir el conocimiento del dominio: es, sobre todo, trabajo de bibliotecario.
