# ESTADO.md — Estado vivo de implementación

> Este documento registra el **avance de implementación** (qué está en el repo Backend, qué falta aplicar/verificar y qué queda pendiente), no el diseño. La documentación canónica del *diseño* del dominio vive en los módulos (`00-general-module/`, `01-recoleccion-module/`, `02-vivero-module/`, `03-plantacion-module/`), en los contratos de integración (`90-contratos-integracion/`) y en `database/00_database_schema.md`.
>
> **Actualización 2026-07-07:** este estado se actualizó a partir de la revisión local del repo `Backend-r3foresta`. Cuando un ítem dice "implementado en Backend" significa que existe en código/migraciones/tests del repo backend. No implica por sí solo que las migraciones ya estén aplicadas en Supabase ni que el despliegue productivo esté actualizado.

## Snapshot actual — Integración M2 Vivero ↔ M3 Plantación

El backend ya migró el flujo principal desde **reserva lógica + despacho automático al plantar** hacia **asignación física + consumo posterior de stock asignado**.

### Verificado en Backend

- Migraciones nuevas: `051_m2_m3_asignacion_fisica_schema.sql`, `052_vivero_asignar_stock_subcampania_rpc.sql`, `053_m3_registrar_plantacion_sin_despacho.sql`, `054_m3_devolucion_fisica.sql`, `055_vivero_merma_fisica.sql`.
- `POST /lotes-vivero/:id/asignaciones` crea asignación física, exige evidencia, registra salida M2 `DESPACHO / ASIGNACION_SUBCAMPANIA`, descuenta `LOTE_VIVERO.saldo_vivo_actual` y registra evento M3 `ASIGNACION_VIVERO`.
- `POST /lotes-vivero/:id/reservas` fue eliminado; `fn_vivero_reservar_stock_lote` queda dropeada por la migración `052`.
- `fn_m3_registrar_plantacion` ya no genera `EVENTO_LOTE_VIVERO`, no usa `AUTOMATICO_PLANTACION` y no toca `LOTE_VIVERO.saldo_vivo_actual`; devuelve `consumos`.
- Plantación inicial consume asignaciones `PLANTACION_INICIAL`; reposición consume asignaciones `REPOSICION`, permite subcampañas `ACTIVA`, `COMPLETADA` y `FINALIZADA_PARCIAL`, y bloquea exceso sobre pendiente de reposición.
- Devolución física implementada con `fn_m3_devolver_asignacion_vivero` y `POST /lotes-vivero/:id/asignaciones/:asignacionId/devolucion`: aumenta `cantidad_devuelta`, aumenta `LOTE_VIVERO.saldo_vivo_actual`, registra `DEVOLUCION_PLANTACION` en M2 y `DEVOLUCION_A_VIVERO` en M3. En MVP no exige evidencia fotográfica.
- Cancelación de subcampaña usa `fn_subcampania_cancelar` v2: bloquea si `total_plantado_inicial > 0` y devuelve físicamente saldos disponibles de asignaciones activas antes de cancelar.
- Merma M2 vuelve a afectar solo stock físico en vivero: valida contra `LOTE_VIVERO.saldo_vivo_actual` y no modifica asignaciones entregadas.
- Despacho manual valida contra saldo físico del lote y rechaza `destino_tipo = PLANTACION_CAMPANIA`.
- Consultas de saldos exponen `saldo_vivo_actual` y `saldo_asignado_subcampanias`; ya no publican como vigente la identidad `saldo_vivo_actual - saldo_asignado_total`.
- Swagger, documentación local de frontend, guía de migración y Postman fueron actualizados en el repo Backend.
- Unit tests locales del Backend verificados el 2026-07-07: `npm test -- --runInBand` pasa (`388/388`) y `tsc -p tsconfig.build.json --noEmit` pasa limpio.

### Pendiente fuera del repo Backend

1. Aplicar en Supabase las migraciones `051` a `055`, en orden.
2. Ejecutar `npm run test:e2e:db` contra un entorno Supabase migrado y seguro.
3. Desplegar backend y frontend coordinados por los breaking changes de API.
4. Confirmar en producción/staging que no existen escrituras nuevas con `AUTOMATICO_PLANTACION`.
5. Implementar/ajustar frontend contra el contrato nuevo: asignación física con evidencia, plantación con `consumos`, devolución física y saldos separados.

## Integración Módulo 2 (Vivero) ↔ Módulo 3 (Plantación)

| Pieza | Fuente documental | Estado |
|---|---|---|
| Enums y schema físico M2↔M3: `ASIGNACION_SUBCAMPANIA`, `DEVOLUCION_PLANTACION`, `evento_lote_vivero.asignacion_id`, FKs M3, CHECK que bloquea nuevas escrituras `AUTOMATICO_PLANTACION`, vista física `v_lote_vivero_saldos` | `database/00_database_schema.md`, migración `051` | ✅ implementado en Backend. ⏳ pendiente aplicar/confirmar en Supabase. |
| Handler atómico de asignación física | `90-contratos-integracion/02_contrato_vivero_a_plantacion.md`, migración `052` | ✅ implementado en Backend con `fn_vivero_asignar_stock_subcampania` y endpoint `POST /lotes-vivero/:id/asignaciones`. |
| Eliminación del flujo de reserva lógica | contrato M2↔M3, migración `052` | ✅ implementado en Backend: se elimina alias `POST /:id/reservas` y se dropea `fn_vivero_reservar_stock_lote`. |
| Plantación/reposición como consumo de asignaciones, sin despacho M2 | contrato M2↔M3, M3 procesos, migración `053` | ✅ implementado en Backend: respuesta con `consumos`, detalles con `evento_lote_vivero_despacho_id = NULL`. |
| Devolución física y cancelación de subcampaña | contrato M2↔M3, RN-PLA-37, migración `054` | ✅ implementado en Backend: RPC de devolución física, endpoint de devolución y cancelación con devolución física automática. |
| Merma M2, saldos y despacho manual con semántica física | contrato M2↔M3, migración `055` | ✅ implementado en Backend: merma no toca asignaciones; despacho manual valida contra saldo físico; saldos separados. |
| API/Swagger/documentación frontend del contrato nuevo | Backend docs / Swagger | ✅ implementado en Backend. ⏳ frontend consumidor pendiente/por confirmar. |
| Pruebas de regresión y concurrencia | specs Backend | ✅ unitarios implementados y pasando. ✅ e2e DB nuevos en repo Backend (`asignacion_fisica`, `plantacion_fisica`). ⏳ pendiente correr e2e DB contra Supabase migrado. |
| Merma de stock ya asignado en campo | contrato M2↔M3 §8.2 | ⏳ fuera del MVP backend actual; si se prioriza debe vivir en M3 y afectar `cantidad_mermada`. |
| Job nocturno de transición `MANTENIMIENTO_ACTIVO` → `MONITOREO_HISTORICO` (RF-PLA-11) | schema / `CLAUDE.md` | ⏳ pendiente. |
| Función PostGIS `gps_dentro_poligono_con_tolerancia` + vista `campania_estado` | schema / migraciones M3 previas | ✅ función PostGIS usada por plantación. ⏳ vista/uso público de `campania_estado` por confirmar. |

## Vivero Core — Descarte pre-embolsado

| Pieza | Fuente documental | Estado |
|---|---|---|
| Diseño de dominio: evento `DESCARTE_PRE_EMBOLSADO`, causa propia, evidencia obligatoria y motivo de cierre propio | `02-vivero-module/01_reglas_de_negocio_vivero_core.md` (RN-VIV-11A), `02-vivero-module/02_flujo_operativo_vivero_core.md`, `decisiones/00_decisiones_vivero.md` (ADR-VIV-15) | ✅ documentado |
| Migración BD `046_vivero_descarte_pre_embolsado.sql`: enums, columna `causa_descarte_pre_embolsado`, constraints y RPC `fn_vivero_registrar_descarte_pre_embolsado` | `database/migrations/046_vivero_descarte_pre_embolsado.sql` | ✅ implementado en repo Backend. ⏳ pendiente aplicar/confirmar en Supabase si no está aplicado. |
| Backend: endpoint/servicio para registrar descarte pre-embolsado desde lote `ACTIVO` con `INICIO` y sin `EMBOLSADO` | `RF-VIV-02A` / migración 046 | ✅ implementado en Backend. |
| Backend: si el lote ya tiene `EMBOLSADO`, bloquear `DESCARTE_PRE_EMBOLSADO` y usar pérdida total post-embolsado vía `MERMA` por todo `saldo_vivo_actual` | `02-vivero-module/02_flujo_operativo_vivero_core.md` §7.1 | ✅ implementado en Backend. |
| Backend: pruebas de negocio para inicio sin embolsado, bloqueo con embolsado existente, evidencia obligatoria, cierre automático y motivo `DESCARTE_PRE_EMBOLSADO` | `RF-VIV-02A` | ✅ unitarios/e2e DB presentes en Backend. |
| Frontend: en detalle/listado de lote, detectar `ACTIVO` + `INICIO` + sin `EMBOLSADO` y mostrar acción de descarte total pre-embolsado | `02-vivero-module/02_flujo_operativo_vivero_core.md` §7.2 | ⏳ pendiente/por confirmar. |
| Frontend: formulario con fecha, responsable, causa, cantidad total prellenada desde `cantidad_inicial_en_proceso`, unidad, observaciones y evidencia obligatoria | `RF-VIV-02A` | ⏳ pendiente/por confirmar. |
| Frontend: si el lote ya tiene `EMBOLSADO`, la acción equivalente debe registrar pérdida total post-embolsado, no descarte pre-embolsado | `02-vivero-module/02_flujo_operativo_vivero_core.md` §7.2 | ⏳ pendiente/por confirmar. |

## Módulo 3 (Plantación) — Creación/planeación de subcampaña

| Pieza | Fuente documental | Estado |
|---|---|---|
| Diseño: cancelación de subcampaña sin plantaciones (BORRADOR o ACTIVA sin plantar) → `CANCELADA`; si hay plantado, `FINALIZADA_PARCIAL` | `03-plantacion-module/01_reglas_de_negocio_plantacion.md` (RN-PLA-37, RN-PLA-06), `02_Procesos...` §3.12, `database/00_database_schema.md`, `CLAUDE.md` | ✅ documentado |
| Backend/BD: transición a `CANCELADA` (solo ADMIN, guard `total_plantado_inicial = 0`), evento `SUBCAMPANIA_CANCELADA`, resolución de asignaciones activas con devolución física si ya fueron entregadas | RN-PLA-37 / contrato M2↔M3 actualizado | ✅ implementado en Backend con `fn_subcampania_cancelar` v2 (migración `054`). |
| Diseño: meta agregada de campaña derivada (`meta_planificada_campania`, incluye BORRADOR, excluye CANCELADA), no persistida | `01_reglas...` (RN-PLA-36), `02_Procesos...` §2.1, `database/00_database_schema.md` | ✅ documentado |
| Backend: lectura derivada `meta_planificada_campania` para vista admin; el público agrega solo ACTIVA/COMPLETADA/FINALIZADA_PARCIAL | RN-PLA-36 | ✅ implementado en `GET /api/campanias` y `GET /api/campanias/:id`; vista pública a cargo del frontend. |
| Diseño: edición básica y desactivación de campaña en MVP; `tipo` solo sin subcampañas, desactivación si no hay subcampañas o todas están `CANCELADA` | `01_reglas...` (RN-PLA-38), `02_Procesos...` §2.1/§3.1, `database/00_database_schema.md`, `decisiones/02_decisiones_plantacion.md` (ADR-PLA-01) | ✅ documentado |
| BD: trigger para bloquear cambio de `tipo` con subcampañas, permitir soft-delete solo sin subcampañas o todas `CANCELADA`, y bloquear `DELETE` físico si hay subcampañas | `database/migrations/050_m3_campania_edicion_eliminacion_estricta_mvp.sql` | ✅ implementado como migración en Backend. ⏳ pendiente aplicar/confirmar en Supabase si no está aplicado. |
| Aclaración cerrada: asignación de lotes solo post-`ACTIVA` (no en BORRADOR); activar con 0% de stock permitido | `02_Procesos...` §2.13, `00_...json` RF-PLA-02/03, `03_Mockups...` §3.6 | ✅ implementado bajo contrato físico: `POST /api/lotes-vivero/:id/asignaciones` rechaza BORRADOR/CANCELADA y valida propósito por estado; activación permite 0 asignaciones. |
| Frontend: wizard de subcampaña sin paso de asignación (asignación en pantalla dedicada tras activar) + acción "Cancelar" según estado | `03_Mockups...` §3.6/§3.7/§3.10 | ⏳ en progreso/por confirmar. |
| Frontend: planificación MVP completa para adaptar UI al flujo de asignación física, consumo de stock asignado, devoluciones y vista pública | `03-plantacion-module/04_plan_frontend_m3.md` | ✅ plan documentado; implementación pendiente/por confirmar. |
| BD: tabla `SUBCAMPANIA_HISTORIAL` (append-only, con enum `tipo_historial_subcampania`) para eventos de ciclo de vida (`BORRADOR_CREADO`, `SUBCAMPANIA_ACTIVADA`, `SUBCAMPANIA_CANCELADA`, y futuros) | `02_Procesos...` §4.1 | ✅ creada por migración `047` en repo Backend; creation/activation/cancelación escriben eventos. Los eventos `SUBCAMPANIA_COMPLETADA / FINALIZADA_PARCIAL / TRANSICION_A_MONITOREO_HISTORICO / EQUIPO_*` quedan pendientes de sus flujos respectivos. |
| BD: tabla `SUBCAMPANIA_META_ESPECIE` + endpoints `GET /api/subcampanias/:id/plan` y `PUT /api/subcampanias/:id/plan`; validación al activar `SUM(%) = 100` y `SUM(cantidad) = meta_total_arboles` | `01_reglas...` RN-PLA-15/16/17, `database/00_database_schema.md` | ✅ implementado en Backend (migración `047` + servicios/policy). ⏳ pendiente aplicar/confirmar en Supabase si no está aplicado. |

## Observaciones para el auditor

- El contrato M2↔M3 vigente ya no debe describirse como reserva lógica en documentos vivos. Las menciones restantes en `_legacy/`, `_historico/` y migraciones antiguas son históricas.
- La fuente de estado operativo es este archivo; la fuente de diseño sigue siendo el contrato y los módulos.
