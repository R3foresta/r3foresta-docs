# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Naturaleza del repositorio

Repositorio **solo de documentación** (no hay build, tests, ni lint). Es la base documental de R3Foresta: requerimientos funcionales, reglas de negocio, guías operativas, decisiones de arquitectura y scripts SQL de soporte. El idioma de trabajo es español; preservarlo en cualquier documento nuevo o edición.

Archivos `.excalidraw` son material de trabajo en equipo, no documentación canónica del problema. **Ignorarlos por completo** al revisar, resumir o razonar sobre el dominio: no leerlos, no editarlos, no contarlos en inventarios de documentación, no incluirlos en análisis. El usuario los gestiona aparte en Excalidraw. `planificacion-weekly.excalidraw` está en `.gitignore`.

## Arquitectura del dominio

R3Foresta modela la cadena de custodia de material biológico para reforestación con trazabilidad blockchain. Tres módulos operativos más uno transversal:

```
00-general-module (catálogos maestros) ──► 01-recoleccion-module ──► 02-vivero-module ──► 03-plantacion-module
                  (RF-GEN-*)              (lote origen)         (maduración)        (campo)
```

- **`00-general-module/`** — Catálogos transversales (USUARIO, UBICACION, PAIS, DIVISION_ADMINISTRATIVA, VIVERO, PLANTA, TIPO_PLANTA, EVIDENCIAS_TRAZABILIDAD, METODO_RECOLECCION). Es la fuente viva de las entidades maestras; los demás módulos consumen vía snapshots congelados.
- **`01-recoleccion-module/`** — Módulo 1. Registro del lote origen con evidencia fotográfica, GPS y validación. Persistencia multicapa: Supabase DB (tabular) + Supabase Storage (binarios) + IPFS/Pinata (metadata NFT) + Blockchain (mint).
- **`02-vivero-module/`** — Módulo 2. Vivero Core: maduración pre-plantación, saldo vivo, eventos append-only y cierre. El **lote de vivero** es el agregado central con **un único origen** desde Recolección. Los contratos con Recolección y Plantación viven fuera del módulo, en `90-contratos-integracion/`.
- **`03-plantacion-module/`** — Módulo 3. Modelado base en BD (CAMPANIA → SUBCAMPANIA → REGISTRO_PLANTACION → EVENTO_PLANTACION) aplicado vía migraciones 027–032. Pendientes: handler atómico de despacho automático, triggers de mantenimiento de contadores materializados, historiales de ciclo de vida y job nocturno de transición a `MONITOREO_HISTORICO`; ver [ESTADO.md](ESTADO.md) para el detalle pieza por pieza.
- **`90-contratos-integracion/`** — Contratos entre módulos. `01_contrato_recoleccion_a_vivero.md` define la entrada atómica desde Recolección; `02_contrato_vivero_a_plantacion.md` define asignaciones, devoluciones, despacho automático y saldos derivados entre Vivero y Plantación.
- **`database/`** — Esquema ER consolidado (`00_database_schema.md` en sintaxis mermaid `erDiagram`), planeación de arquitectura, decisiones críticas, y scripts SQL en `database/supabase/`.

## Convenciones documentales

Cada módulo operativo sigue una estructura numerada de documentos. En Vivero, la documentación se separó en core y contratos:

- `00_Requerimientos_*.json` — requerimientos funcionales (códigos `RF-GEN-*`, `RF-REC-*`, `RF-VIV-*`).
- `01_reglas_de_negocio_*.md` — reglas con códigos `RN-{MODULO}-NN` (ej. `RN-VIV-01`). Las reglas de vivero incluyen `Severidad`, `Aplica en MVP` y `Relevancia carbono`.
- `02_guia_*` / `03_*` / `04_operativo_*` — guías operativas y procesos.
- `README.md` por módulo con propósito y dependencias.
- `90-contratos-integracion/` — contratos transversales. No convertirlos en módulos funcionales ni duplicarlos dentro de Vivero Core o Plantación.

Al editar o añadir reglas, **mantener la numeración estable** (no renumerar reglas existentes — otros módulos las referencian por código).

## Invariantes de dominio a respetar

Estas son decisiones cerradas y deben preservarse al redactar nueva documentación o cambios de esquema:

- **Unidades persistidas:** `ENUM(unidad_medida) = [UNIDAD, G]`. `kg` se acepta en frontend pero el backend normaliza a `G`. Nunca persistir `kg`.
- **Snapshots vs fuente viva:** las tablas maestras (PLANTA, USUARIO, VIVERO, territorios) son fuente viva; cuando un módulo operativo congela identidad debe copiarse a snapshot, no recalcularse.
- **Inactivación, no borrado:** entidades con historial se inactivan (`activo = false`), no se borran.
- **Roles MVP:** catálogo cerrado `ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`. No introducir roles libres.
- **Vivero — origen único:** un lote de vivero proviene de **una sola** recolección; un lote origen puede alimentar varios viveros pero cada consumo se registra individualmente.
- **Vivero — orden de eventos:** `INICIO → (DESCARTE_PRE_EMBOLSADO → CIERRE | EMBOLSADO → (MERMA | DESPACHO | ADAPTABILIDAD)* → CIERRE)`. Saldo vivo solo existe desde `EMBOLSADO` y se maneja en `UNIDAD`; si nunca hay plantas vivas, el cierre usa `DESCARTE_PRE_EMBOLSADO`, no `PERDIDA_TOTAL`.
- **Trazabilidad de vivero:** formato `VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`.
- **Historial:** append-only en `recoleccion_historial` y `evento_lote_vivero`.
- **Recolección — evidencia:** mínimo 2 fotos JPG/PNG para validar, GPS obligatorio.
- **Vivero ↔ Plantación — asignación es reserva lógica:** crear o devolver una `ASIGNACION_VIVERO_SUBCAMPANIA` **no genera evento** en `EVENTO_LOTE_VIVERO` y no toca `LOTE_VIVERO.saldo_vivo_actual`. Solo plantar (en M3) o despachar manualmente (en M2) baja el saldo vivo.
- **Vivero ↔ Plantación — `cantidad_asignada` inmutable:** una vez creada la asignación, `cantidad_asignada` no se modifica nunca. Consumos, devoluciones y afectaciones por merma viven en columnas separadas. `saldo_asignado_disponible = cantidad_asignada − cantidad_consumida − cantidad_devuelta − cantidad_mermada` (columna `GENERATED STORED`).
- **Vivero ↔ Plantación — mermas por urgencia sobre asignaciones:** una `MERMA` que excede el saldo no asignado del lote distribuye el excedente ordenando por `subcampania.fecha_estimada_inicio DESC NULLS FIRST` — la subcampaña con inicio más lejano absorbe primero (más margen); la más próxima queda protegida (más urgente). Sin fecha = absorbe antes que cualquier fecha concreta. `cantidad_asignada` nunca se modifica.
- **Despacho automático vs manual:** un `DESPACHO` en `EVENTO_LOTE_VIVERO` con `origen_despacho = AUTOMATICO_PLANTACION` lo emite **solo el handler de M3** y obliga a `destino_tipo = PLANTACION_CAMPANIA` + `subcampania_id` + `campania_id` + `registro_plantacion_id` no nulos. Todo `DESPACHO`, manual o automático, exige evidencia propia asociada al evento de vivero. Un `DESPACHO` manual exige los tres FKs en `NULL` y `destino_tipo ≠ PLANTACION_CAMPANIA`. La regla se materializa como CHECK constraint en BD.
- **Despacho manual valida contra saldo libre:** los despachos manuales validan cantidad contra `saldo_vivo_disponible_asignacion`, no `saldo_vivo_actual`. No pueden tocar stock reservado.
- **Plantación — COORDINADOR es membresía, no rol global.** El catálogo cerrado de `rol_usuario` (`ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`) se mantiene. La coordinación vive en `SUBCAMPANIA_EQUIPO.rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`. Una subcampaña tiene exactamente un COORDINADOR (constraint partial unique en BD); un usuario puede ser COORDINADOR de N subcampañas y simultáneamente OPERARIO en otras. Cualquier propuesta de schema con un FK directo `coordinador_id` en `SUBCAMPANIA` es incorrecta.
- **Plantación — Estado de campaña derivado, no persistido.** `CAMPANIA` no tiene columna de estado. Su estado (`BORRADOR | ACTIVA | EN_MANTENIMIENTO | MONITOREO_HISTORICO`) se deriva al leer desde el conjunto de sus subcampañas según las reglas de §2.2 y §5.3 del Módulo 3 (vista `campania_estado`). Cualquier diseño de BD que materialice estado de campaña como columna está prohibido.
- **Plantación — Tipo de campaña heredado por todas las subcampañas.** `CAMPANIA.tipo` (ENUM `tipo_subcampania`, reutilizado) es obligatorio al crear la campaña y define el tipo de toda subcampaña hija. `SUBCAMPANIA.tipo` debe ser idéntico a `CAMPANIA.tipo` (CHECK constraint en BD). El tipo de la campaña es inmutable una vez que tiene al menos una subcampaña; mezclar tipos dentro de una misma campaña no está permitido — para operar con otro tipo se crea una campaña separada. El enum `tipo_subcampania` se reutiliza por compatibilidad con migración 027; no introducir `tipo_campania` como enum separado.
- **Plantación — metas por especie en subcampaña.** `CAMPANIA` no tiene meta operativa propia; la meta vive en `SUBCAMPANIA`. Cada subcampaña debe poder planificar su composición en `SUBCAMPANIA_META_ESPECIE`: porcentaje objetivo y cantidad objetivo por `planta_id`, con suma de porcentajes = 100 y suma de cantidades = `SUBCAMPANIA.meta_total_arboles` al activar. La asignación de vivero sigue siendo reserva física por lote; el plan por especie vive en M3 y se usa para cobertura, progreso y validación de `PLANTACION_INICIAL`.
- **Plantación — Reposición libre de especie (`RN-VIV-60`).** Una reposición puede usar cualquier especie disponible en una asignación con propósito `REPOSICION`; no se exige coincidir con la especie del grupo origen. El grupo puede quedar con composición mixta. Revisable post-MVP si certificación de carbono exige homogeneidad.
- **Plantación — Validación GPS con PostGIS como fuente de verdad.** La función `gps_dentro_poligono_con_tolerancia(subcampania_id, lat, lng)` es la autoridad. Turf.js u otro chequeo en frontend es opcional, solo para feedback de UX.

## Estado de iniciativas en curso

- **Integración M2 ↔ M3:** contrato separado en [`90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](90-contratos-integracion/02_contrato_vivero_a_plantacion.md). Implementación pendiente o parcial. Asignaciones, devoluciones, despacho automático y mermas sobre asignaciones no pertenecen a Vivero Core y no deben asumirse en producción sin confirmarlo en [ESTADO.md](ESTADO.md).

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

### Estado de implementación

El avance de implementación (qué está en producción vs. pendiente) se registra en [ESTADO.md](ESTADO.md), un documento vivo. La documentación de diseño canónica sigue viviendo en los módulos operativos y en `database/00_database_schema.md`; `ESTADO.md` solo trackea avance, no diseño.

### Protocolo de cierre de tarea

Cuando el usuario informa que una tarea está aplicada en su repo:

1. **Pedirle un resumen breve** si no lo trajo: qué se hizo, qué se desvió del spec, qué quedó pendiente, qué decisiones nuevas se tomaron.
2. **Propagar a la documentación canónica** los cambios que afecten al dominio: actualizar JSON de requerimientos, MD de reglas de negocio, esquema ER, o decisiones cerradas/abiertas del addendum correspondiente.
3. **Notar invariantes nuevos** en CLAUDE.md si la tarea cerró una decisión que estaba abierta o estableció un patrón a respetar.
4. **Actualizar la fila correspondiente en `ESTADO.md`** con el nuevo estado de esa pieza.

El objetivo: que cualquier futura conversación pueda reconstruir el estado del proyecto leyendo solo los archivos del repo, sin tener que recordar la historia de la implementación.
