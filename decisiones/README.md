# Decisiones — Registro unificado de ADR

Registro único de decisiones de arquitectura y diseño cerradas para el MVP, consolidado desde los distintos módulos para evitar que cada uno mantenga su propio historial disperso.

## Índice

| Rango | Documento | Alcance |
|---|---|---|
| `ADR-VIV-01` … `ADR-VIV-14` | [`00_decisiones_vivero.md`](00_decisiones_vivero.md) | Arquitectura de base de datos del módulo Vivero (modelo híbrido, origen único, saldo, eventos, evidencia, blockchain). Migrado desde `database/`. |
| `ADR-GEN-01` … `ADR-GEN-07` | [`01_decisiones_general.md`](01_decisiones_general.md) | Decisiones cerradas del módulo General (comunidad, naming de planta, roles, ubicación, evidencia). Migrado desde `general-module/`. |

## Invariantes de dominio

Los invariantes de dominio listados en [`CLAUDE.md`](../CLAUDE.md#invariantes-de-dominio-a-respetar) son las decisiones cerradas del dominio; varias corresponden 1:1 a un ADR de este índice (ver referencias cruzadas en cada documento). `CLAUDE.md` mantiene la lista corta y operativa; aquí vive el razonamiento detallado (alternativa evaluada, qué se sacrificó, qué se ganó).

## Histórico

Material de trabajo superado, conservado solo como referencia (no es fuente operativa ni de diseño): [`_historico/`](_historico/).

* [`_historico/planeacion-bd-vivero.md`](_historico/planeacion-bd-vivero.md) — comparativa de alternativas de arquitectura, superada por `00_decisiones_vivero.md`.
* [`_historico/vivero-addendum-m2-m3.md`](_historico/vivero-addendum-m2-m3.md) — negociación original del contrato Vivero↔Plantación, ya absorbida en `vivero-module/01_reglas_de_negocio_vivero.md` (RN-VIV-47 a RN-VIV-60).

## Convención

* Un documento por módulo/alcance, no un archivo por decisión individual (el volumen actual no lo justifica).
* Cada decisión tiene código estable `ADR-{MODULO}-NN`. No renumerar decisiones existentes — pueden ser referenciadas desde otros documentos.
* Nuevas decisiones cerradas se añaden al final del documento de su módulo, o como documento nuevo si el módulo no tiene uno todavía.
