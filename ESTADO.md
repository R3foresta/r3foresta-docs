# ESTADO.md — Estado vivo de implementación

> Este documento registra el **avance de implementación** (qué está corriendo en producción vs. qué falta), no el diseño. La documentación canónica del *diseño* del dominio vive en los módulos (`00-general-module/`, `01-recoleccion-module/`, `02-vivero-module/`, `03-plantacion-module/`), en los contratos de integración (`90-contratos-integracion/`) y en `database/00_database_schema.md`. Este archivo reemplaza el flujo anterior de seguimiento de tareas como fuente del estado de implementación de la integración M2 ↔ M3.
>
> **Importante:** Claude no ve los repos de implementación (backend, BD, frontend). El estado autoritativo lo confirma el usuario a partir de resúmenes de lo aplicado. Los ítems marcados `⏳ por confirmar` o `⏳ pendiente` **no deben leerse como hechos verificados** — son el punto de partida hasta que se confirmen o corrijan.

## Integración Módulo 2 (Vivero) ↔ Módulo 3 (Plantación)

| Pieza | Fuente documental | Estado |
|---|---|---|
| Enums `origen_despacho_vivero`, `proposito_asignacion`, `estado_asignacion_vivero`; valor `PLANTACION_CAMPANIA` en `destino_tipo_vivero` | `database/00_database_schema.md` (ENUMS) | ⏳ por confirmar |
| Columnas nuevas en `EVENTO_LOTE_VIVERO` (`origen_despacho`, `subcampania_id`, `campania_id`, `registro_plantacion_id`) — **FK físicos** | schema: "FK fisico pendiente de ALTER en BD" | ⏳ FK físicos pendientes |
| Tabla `ASIGNACION_VIVERO_SUBCAMPANIA` (+ `cantidad_mermada`, columna GENERATED `saldo_asignado_disponible`) — FK físico `subcampania_id` | schema | ⏳ FK físico pendiente |
| CHECK constraint de consistencia `origen_despacho` ↔ FKs de M3 | schema / `90-contratos-integracion/02_contrato_vivero_a_plantacion.md` (RN-VIV-55) | ⏳ por confirmar |
| Handler atómico de `DESPACHO` automático desde M3 (al guardar `PLANTACION_INICIAL` / `REPOSICION`) | `90-contratos-integracion/02_contrato_vivero_a_plantacion.md` | ⏳ pendiente |
| Triggers de contadores materializados: `SUBCAMPANIA` (`total_plantado_inicial`, `total_repuesto`, `total_muerto_acumulado`) y `REGISTRO_PLANTACION` (`cantidad_muerta_acumulada`, `cantidad_repuesta_acumulada`) | `database/00_database_schema.md` / `03-plantacion-module/02_Procesos_Modulo_3_Plantacion.md` | ⏳ pendiente |
| Política de merma por urgencia sobre asignaciones (RN-VIV-50) + notificación al coordinador (RN-VIV-51) | `90-contratos-integracion/02_contrato_vivero_a_plantacion.md` | ⏳ pendiente |
| Job nocturno de transición `MANTENIMIENTO_ACTIVO` → `MONITOREO_HISTORICO` (RF-PLA-11) | schema / `CLAUDE.md` | ⏳ pendiente |
| Función PostGIS `gps_dentro_poligono_con_tolerancia` + vista `campania_estado` | schema (OBJETOS DERIVADOS) | ⏳ por confirmar |

Este estado se refinará cuando el usuario confirme, pieza por pieza, qué está realmente en producción. No se debe recrear el seguimiento anterior como carpeta separada; el estado vivo queda centralizado aquí.

## Vivero Core — Descarte pre-embolsado

| Pieza | Fuente documental | Estado |
|---|---|---|
| Diseño de dominio: evento `DESCARTE_PRE_EMBOLSADO`, causa propia, evidencia obligatoria y motivo de cierre propio | `02-vivero-module/01_reglas_de_negocio_vivero_core.md` (RN-VIV-11A), `02-vivero-module/02_flujo_operativo_vivero_core.md`, `decisiones/00_decisiones_vivero.md` (ADR-VIV-15) | ✅ documentado |
| Migración BD `046_vivero_descarte_pre_embolsado.sql`: enums, columna `causa_descarte_pre_embolsado`, constraints y RPC `fn_vivero_registrar_descarte_pre_embolsado` | `database/migrations/046_vivero_descarte_pre_embolsado.sql` | ⏳ pendiente de aplicar/confirmar |
| Backend: endpoint/servicio para registrar descarte pre-embolsado desde lote `ACTIVO` con `INICIO` y sin `EMBOLSADO` | `RF-VIV-02A` / migración 046 | ⏳ pendiente |
| Backend: si el lote ya tiene `EMBOLSADO`, bloquear `DESCARTE_PRE_EMBOLSADO` y usar perdida total post-embolsado vía `MERMA` por todo `saldo_vivo_actual`; no permitir parcialidad en esa acción de perdida total | `02-vivero-module/02_flujo_operativo_vivero_core.md` §7.1 | ⏳ pendiente |
| Backend: pruebas de negocio para inicio sin embolsado, bloqueo con embolsado existente, evidencia obligatoria, cierre automático y motivo `DESCARTE_PRE_EMBOLSADO` | `RF-VIV-02A` | ⏳ pendiente |
| Frontend: en detalle/listado de lote, detectar `ACTIVO` + `INICIO` + sin `EMBOLSADO` y mostrar acción de descarte total pre-embolsado | `02-vivero-module/02_flujo_operativo_vivero_core.md` §7.2 | ⏳ pendiente |
| Frontend: formulario con fecha, responsable, causa, cantidad total prellenada desde `cantidad_inicial_en_proceso`, unidad, observaciones y evidencia obligatoria | `RF-VIV-02A` | ⏳ pendiente |
| Frontend: si el lote ya tiene `EMBOLSADO`, la acción equivalente debe registrar perdida total post-embolsado, no descarte pre-embolsado | `02-vivero-module/02_flujo_operativo_vivero_core.md` §7.2 | ⏳ pendiente |

## Módulo 3 (Plantación) — Creación/planeación de subcampaña (decisiones 2026-07-01)

| Pieza | Fuente documental | Estado |
|---|---|---|
| Diseño: cancelación de subcampaña sin plantaciones (BORRADOR o ACTIVA sin plantar) → `CANCELADA`; si hay plantado, `FINALIZADA_PARCIAL` | `03-plantacion-module/01_reglas_de_negocio_plantacion.md` (RN-PLA-37, RN-PLA-06), `02_Procesos...` §3.12, `database/00_database_schema.md` (enum `estado_subcampania`), `CLAUDE.md` | ✅ documentado |
| Backend/BD: transición a `CANCELADA` (solo ADMIN, guard `total_plantado_inicial = 0`), evento `SUBCAMPANIA_CANCELADA`, liberación de asignaciones activas como devolución lógica (sin evento M2) | RN-PLA-37 | ✅ implementado (Backend-r3foresta migración `047_m3_cancelacion_subcampania_y_plan.sql` + `POST /api/subcampanias/:id/cancelar` con RPC atómico `fn_subcampania_cancelar`; ⏳ **migración pendiente de aplicar en Supabase**) |
| Diseño: meta agregada de campaña derivada (`meta_planificada_campania`, incluye BORRADOR, excluye CANCELADA), no persistida | `01_reglas...` (RN-PLA-36), `02_Procesos...` §2.1, `database/00_database_schema.md` (OBJETOS DERIVADOS) | ✅ documentado |
| Backend: lectura derivada `meta_planificada_campania` para vista admin; el público agrega solo ACTIVA/COMPLETADA/FINALIZADA_PARCIAL | RN-PLA-36 | ✅ implementado en `GET /api/campanias` y `GET /api/campanias/:id` (suma no persistida en `campanias-consultas.service.ts`). La vista pública (filtro `ACTIVA | COMPLETADA | FINALIZADA_PARCIAL`) queda a cargo del frontend. |
| Aclaración cerrada: asignación de lotes solo post-`ACTIVA` (no en BORRADOR); activar con 0% de stock permitido | `02_Procesos...` §2.13, `00_...json` RF-PLA-02/03, `03_Mockups...` §3.6 | ✅ implementado. Guard reforzado en `POST /api/lotes-vivero/:loteId/reservas` (rechaza BORRADOR/CANCELADA, discrimina `PLANTACION_INICIAL` vs `REPOSICION` por estado) y en RPC `fn_vivero_reservar_stock_lote` (`047`). Activación permite 0 asignaciones (`activacion.policy.ts` corregido; `RN-PLA-09`). |
| Frontend: wizard de subcampaña sin paso de asignación (asignación en pantalla dedicada tras activar) + acción "Cancelar" según estado | `03_Mockups...` §3.6/§3.7/§3.10 | ⏳ en progreso (mocks/pantallas por el usuario, por confirmar) |
| BD: tabla `SUBCAMPANIA_HISTORIAL` (append-only, con enum `tipo_historial_subcampania`) para eventos de ciclo de vida (`BORRADOR_CREADO`, `SUBCAMPANIA_ACTIVADA`, `SUBCAMPANIA_CANCELADA`, y futuros) | `02_Procesos...` §4.1 | ✅ creada por migración `047` en repo Backend; el creation/activation/cancelación ya escriben eventos. Los eventos `SUBCAMPANIA_COMPLETADA / FINALIZADA_PARCIAL / TRANSICION_A_MONITOREO_HISTORICO / EQUIPO_*` **quedan pendientes** de ser escritos por sus flujos respectivos (fuera del alcance de esta tarea). |
| BD: tabla `SUBCAMPANIA_META_ESPECIE` (plan por especie) + endpoints `GET /api/subcampanias/:id/plan` y `PUT /api/subcampanias/:id/plan` (reemplazo bulk, editable en BORRADOR); validación al activar `SUM(%) = 100` y `SUM(cantidad) = meta_total_arboles` | `01_reglas...` RN-PLA-15/16/17, `database/00_database_schema.md` | ✅ implementado en Backend (migración `047` + `subcampanias-plan.service.ts` + `activacion.policy.ts`). ⏳ migración pendiente de aplicar en Supabase. |

## Observaciones para el auditor

- Ninguna por el momento. Si en una futura revisión se detecta una pieza de diseño que no esté ya cubierta por un documento canónico, anotarla aquí para su resolución — no inventarla como si ya estuviera resuelta.
