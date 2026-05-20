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
- **`plantacion-module/`** — Módulo 3 (en diseño, solo diagrama base).
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

## SQL en `database/supabase/`

Scripts PostgreSQL idempotentes para Supabase. Convenciones observadas:

- Enums se crean con guard `do $$ ... if not exists ... $$` consultando `pg_type`.
- Tablas con `create table if not exists`.
- Nombres en `snake_case`, en español, sin prefijos de esquema más allá de `public`.
- FKs nombradas explícitamente con sufijo `_fk`.

Mantener idempotencia al añadir migraciones nuevas.
