# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Naturaleza del repositorio

Repositorio **solo de documentación** (no hay build, tests, ni lint). Es la base documental de R3Foresta: requerimientos funcionales, reglas de negocio, guías operativas, decisiones de arquitectura y scripts SQL de soporte. El idioma de trabajo es español; preservarlo en cualquier documento nuevo o edición.

Archivos `.excalidraw` son material de trabajo en equipo, no documentación canónica del problema. **Ignorarlos por completo** al revisar, resumir o razonar sobre el dominio: no leerlos, no editarlos, no contarlos en inventarios de documentación, no incluirlos en análisis. El usuario los gestiona aparte en Excalidraw. `planificacion-weekly.excalidraw` está en `.gitignore`.

## Arquitectura del dominio

R3Foresta modela la cadena de custodia de material biológico para reforestación con trazabilidad blockchain. Tres módulos operativos más uno transversal:

```
general-module (catálogos maestros) ──► recoleccion-module ──► vivero-module ──► plantacion-module
                  (RF-GEN-*)              (lote origen)         (maduración)        (campo)
```

- **`general-module/`** — Catálogos transversales (USUARIO, UBICACION, PAIS, DIVISION_ADMINISTRATIVA, VIVERO, PLANTA, TIPO_PLANTA, EVIDENCIAS_TRAZABILIDAD, METODO_RECOLECCION). Es la fuente viva de las entidades maestras; los demás módulos consumen vía snapshots congelados.
- **`recoleccion-module/`** — Módulo 1. Registro del lote origen con evidencia fotográfica, GPS y validación. Persistencia multicapa: Supabase DB (tabular) + Supabase Storage (binarios) + IPFS/Pinata (metadata NFT) + Blockchain (mint).
- **`vivero-module/`** — Módulo 2. Maduración pre-plantación. Modelo híbrido (estado actual + historial append-only de eventos), no event sourcing puro. El **lote de vivero** es el agregado central con **un único origen** desde Recolección.
- **`plantacion-module/`** — Módulo 3. Modelado base en BD (CAMPANIA → SUBCAMPANIA → REGISTRO_PLANTACION → EVENTO_PLANTACION) aplicado vía migraciones 027–032. Pendientes: handler atómico de despacho automático (tarea 03), triggers de mantenimiento de contadores materializados (tarea 13 sugerida), historiales de ciclo de vida y job nocturno de transición a `MONITOREO_HISTORICO`.
- **`database/`** — Esquema ER consolidado (`00_database_schema.md` en sintaxis mermaid `erDiagram`), planeación de arquitectura, decisiones críticas, y scripts SQL en `database/supabase/`.

## Convenciones documentales

Cada módulo operativo sigue la misma estructura numerada de documentos:

- `00_Requerimientos_*.json` — requerimientos funcionales (códigos `RF-GEN-*`, `RF-REC-*`, `RF-VIV-*`).
- `01_reglas_de_negocio_*.md` — reglas con códigos `RN-{MODULO}-NN` (ej. `RN-VIV-01`). Las reglas de vivero incluyen `Severidad`, `Aplica en MVP` y `Relevancia carbono`.
- `02_guia_*` / `03_*` / `04_operativo_*` — guías operativas y procesos.
- `README.md` por módulo con propósito y dependencias.

Al editar o añadir reglas, **mantener la numeración estable** (no renumerar reglas existentes — otros módulos las referencian por código).

## Invariantes de dominio a respetar

Estas son decisiones cerradas y deben preservarse al redactar nueva documentación o cambios de esquema:

- **Unidades persistidas:** `ENUM(unidad_medida) = [UNIDAD, G]`. `kg` se acepta en frontend pero el backend normaliza a `G`. Nunca persistir `kg`.
- **Snapshots vs fuente viva:** las tablas maestras (PLANTA, USUARIO, VIVERO, territorios) son fuente viva; cuando un módulo operativo congela identidad debe copiarse a snapshot, no recalcularse.
- **Inactivación, no borrado:** entidades con historial se inactivan (`activo = false`), no se borran.
- **Roles MVP:** catálogo cerrado `ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`. No introducir roles libres.
- **Vivero — origen único:** un lote de vivero proviene de **una sola** recolección; un lote origen puede alimentar varios viveros pero cada consumo se registra individualmente.
- **Vivero — orden de eventos:** `INICIO → EMBOLSADO → (MERMA | DESPACHO | ADAPTABILIDAD)* → CIERRE`. Saldo vivo solo existe desde `EMBOLSADO` y se maneja en `UNIDAD`.
- **Trazabilidad de vivero:** formato `VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`.
- **Historial:** append-only en `recoleccion_historial` y `evento_lote_vivero`.
- **Recolección — evidencia:** mínimo 2 fotos JPG/PNG para validar, GPS obligatorio.
- **Vivero ↔ Plantación — asignación es reserva lógica:** crear o devolver una `ASIGNACION_VIVERO_SUBCAMPANIA` **no genera evento** en `EVENTO_LOTE_VIVERO` y no toca `LOTE_VIVERO.saldo_vivo_actual`. Solo plantar (en M3) o despachar manualmente (en M2) baja el saldo vivo.
- **Vivero ↔ Plantación — `cantidad_asignada` inmutable:** una vez creada la asignación, `cantidad_asignada` no se modifica nunca. Consumos, devoluciones y afectaciones por merma viven en columnas separadas. `saldo_asignado_disponible = cantidad_asignada − cantidad_consumida − cantidad_devuelta − cantidad_mermada` (columna `GENERATED STORED`).
- **Vivero ↔ Plantación — mermas por urgencia sobre asignaciones:** una `MERMA` que excede el saldo no asignado del lote distribuye el excedente ordenando por `subcampania.fecha_estimada_inicio DESC NULLS FIRST` — la subcampaña con inicio más lejano absorbe primero (más margen); la más próxima queda protegida (más urgente). Sin fecha = absorbe antes que cualquier fecha concreta. `cantidad_asignada` nunca se modifica.
- **Despacho automático vs manual:** un `DESPACHO` en `EVENTO_LOTE_VIVERO` con `origen_despacho = AUTOMATICO_PLANTACION` lo emite **solo el handler de M3** y obliga a `destino_tipo = PLANTACION_CAMPANIA` + `subcampania_id` + `campania_id` + `registro_plantacion_id` no nulos. Hereda evidencia del `REGISTRO_PLANTACION`. Un `DESPACHO` manual exige los tres FKs en `NULL`, `destino_tipo ≠ PLANTACION_CAMPANIA` y evidencia propia. La regla se materializa como CHECK constraint en BD.
- **Despacho manual valida contra saldo libre:** los despachos manuales validan cantidad contra `saldo_vivo_disponible_asignacion`, no `saldo_vivo_actual`. No pueden tocar stock reservado.
- **Plantación — COORDINADOR es membresía, no rol global.** El catálogo cerrado de `rol_usuario` (`ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`) se mantiene. La coordinación vive en `SUBCAMPANIA_EQUIPO.rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`. Una subcampaña tiene exactamente un COORDINADOR (constraint partial unique en BD); un usuario puede ser COORDINADOR de N subcampañas y simultáneamente OPERARIO en otras. Cualquier propuesta de schema con un FK directo `coordinador_id` en `SUBCAMPANIA` es incorrecta.
- **Plantación — Estado de campaña derivado, no persistido.** `CAMPANIA` no tiene columna de estado. Su estado (`BORRADOR | ACTIVA | EN_MANTENIMIENTO | MONITOREO_HISTORICO`) se deriva al leer desde el conjunto de sus subcampañas según las reglas de §2.2 y §5.3 del Módulo 3 (vista `campania_estado`). Cualquier diseño de BD que materialice estado de campaña como columna está prohibido.
- **Plantación — Tipo de campaña heredado por todas las subcampañas.** `CAMPANIA.tipo` (ENUM `tipo_subcampania`, reutilizado) es obligatorio al crear la campaña y define el tipo de toda subcampaña hija. `SUBCAMPANIA.tipo` debe ser idéntico a `CAMPANIA.tipo` (CHECK constraint en BD). El tipo de la campaña es inmutable una vez que tiene al menos una subcampaña; mezclar tipos dentro de una misma campaña no está permitido — para operar con otro tipo se crea una campaña separada. El enum `tipo_subcampania` se reutiliza por compatibilidad con migración 027; no introducir `tipo_campania` como enum separado.
- **Plantación — Mix de especies fuera del MVP.** No existe tabla `subcampania_especie_permitida` ni validación de topes porcentuales. La composición real se registra en `REGISTRO_PLANTACION_DETALLE` pero no se valida contra plan. Se incorpora post-MVP.
- **Plantación — Reposición libre de especie (`RN-VIV-60`).** Una reposición puede usar cualquier especie disponible en una asignación con propósito `REPOSICION`; no se exige coincidir con la especie del grupo origen. El grupo puede quedar con composición mixta. Revisable post-MVP si certificación de carbono exige homogeneidad.
- **Plantación — Validación GPS con PostGIS como fuente de verdad.** La función `gps_dentro_poligono_con_tolerancia(subcampania_id, lat, lng)` es la autoridad. Turf.js u otro chequeo en frontend es opcional, solo para feedback de UX.

## Estado de iniciativas en curso

- **Integración M2 ↔ M3:** documentación absorbida (2026-05-21). Implementación pendiente, organizada en [tareas/modulo-2-integracion-modulo-3/](tareas/modulo-2-integracion-modulo-3/). Hasta que las tareas se cierren, el comportamiento descrito en los docs de M2 sobre asignaciones, devoluciones, despacho automático y LIFO de mermas todavía **no está en producción**. Consultar el README de tareas para el estado actual de cada pieza.

## SQL en `database/supabase/`

Scripts PostgreSQL idempotentes para Supabase. Convenciones observadas:

- Enums se crean con guard `do $$ ... if not exists ... $$` consultando `pg_type`.
- Tablas con `create table if not exists`.
- Nombres en `snake_case`, en español, sin prefijos de esquema más allá de `public`.
- FKs nombradas explícitamente con sufijo `_fk`.

Mantener idempotencia al añadir migraciones nuevas.

## Modo de trabajo con Claude (cerebro del proyecto)

Claude actúa como **cerebro del proyecto**: orquesta diseño, planifica tareas, revisa especs, mantiene coherencia entre módulos y registra estado. **El usuario es quien implementa** (backend, BD, frontend) en sus repos de código.

Claude **no ve el código de los repos de implementación**. El usuario le pasa resúmenes del resultado de aplicar los cambios (queries probadas, ajustes hechos, errores encontrados, decisiones tomadas en el camino). A partir de esos resúmenes, Claude actualiza la documentación canónica y cierra la tarea.

### Tareas en `tareas/`

Las tareas operativas viven en [tareas/](tareas/), organizadas por iniciativa (ej. `tareas/modulo-2-integracion-modulo-3/`). Cada carpeta tiene:

- `README.md` — índice con tabla de estado por tarea y dependencias.
- Archivos numerados por tarea (`01_*.md`, `02_*.md`, ...) con contexto, spec técnico, criterios de aceptación y choques.

### Protocolo de cierre de tarea

Cuando el usuario informa que una tarea está aplicada en su repo:

1. **Pedirle un resumen breve** si no lo trajo: qué se hizo, qué se desvió del spec, qué quedó pendiente, qué decisiones nuevas se tomaron.
2. **Agregar un bloque "Resultado" al final del archivo de tarea** con fecha (formato `YYYY-MM-DD`), resumen, desviaciones del spec original, decisiones nuevas, links a commits/PRs si los hay, y notas para futuras tareas que dependan de esta.
3. **Actualizar el estado en el `README.md`** de la carpeta de tareas (✅ Hecha).
4. **Mover el archivo a `completadas/`** dentro de la misma carpeta de iniciativa, preservando el nombre original (ej. `tareas/modulo-2-integracion-modulo-3/completadas/01_db_migraciones_esquema.md`). Ajustar el link en el README para apuntar a la nueva ruta.
5. **Propagar a la documentación canónica** los cambios que afecten al dominio: actualizar JSON de requerimientos, MD de reglas de negocio, esquema ER, o decisiones cerradas/abiertas del addendum correspondiente.
6. **Notar invariantes nuevos** en CLAUDE.md si la tarea cerró una decisión que estaba abierta o estableció un patrón a respetar.

El objetivo: que cualquier futura conversación pueda reconstruir el estado del proyecto leyendo solo los archivos del repo, sin tener que recordar la historia de la implementación.
