# ESTADO.md — Estado vivo de implementación

> Este documento registra el **avance de implementación** (qué está en el repo Backend, qué falta aplicar/verificar y qué queda pendiente), no el diseño. La documentación canónica del *diseño* del dominio vive en los módulos (`00-general-module/`, `01-recoleccion-module/`, `02-vivero-module/`, `03-plantacion-module/`), en los contratos de integración (`90-contratos-integracion/`) y en `database/00_database_schema.md`.
>
> **Actualización 2026-07-23 — separación UI Despacho/Asignación:** implementado en `pwa-r3foresta` por el commit `562a97e`. Despacho manual expone solo `DONACION`, `VENTA` y `OTRO`; Asignación tiene formulario y acción propios; el tab `Asignaciones` queda para consulta/devolución. No hubo cambios de Backend. `npm run lint` y `npm run build` pasan.
>
> **Actualización 2026-07-23:** las migraciones `056` y `057` están aplicadas en Supabase de producción. Backend y frontend están desplegados en producción; se confirmó que pasaron unitarios Backend, e2e DB y build/lint Frontend.
>
> **Actualización 2026-07-21:** este estado se actualizó contrastando Backend, `pwa-r3foresta` y la documentación vigente. Cuando un ítem dice "implementado en Backend" significa que existe en código/migraciones/tests del repo backend. La confirmación explícita de producción se registra por separado.
>
> **Actualización 2026-07-08:** implementado en frontend el **registro de plantación inicial en campo** (flujo mobile de 3 pasos en `/app/planting/subcampanias/:id/plantaciones/new`) contra el contrato real (`GET /subcampanias/:id/plantacion/context`, `POST`/`DELETE /registros-plantacion/evidencias-pendientes`, `POST /registros-plantacion`). QA cerrado sin bloqueantes.

> **Actualización 2026-07-21:** el frontend ya consume el contrato físico M2↔M3, el timeline de Vivero, el despacho manual, el descarte pre-embolsado y las devoluciones físicas. Los pendientes frontend reales quedan limitados a autenticación mock, la ruta legacy de Embolsado, paginación/estados de Recolección, idempotencia de eventos y cobertura automatizada.

## Snapshot actual — Integración M2 Vivero ↔ M3 Plantación

El backend ya migró el flujo principal desde **reserva lógica + despacho automático al plantar** hacia **asignación física + consumo posterior de stock asignado**.

### Verificado en Backend

- Migraciones vigentes: `051_m2_m3_asignacion_fisica_schema.sql`, `052_vivero_asignar_stock_subcampania_rpc.sql`, `053_m3_registrar_plantacion_sin_despacho.sql`, `054_m3_devolucion_fisica.sql`, `055_vivero_merma_fisica.sql`, `056_fix_devolucion_saldo_constraint.sql` y `057_m3_campania_desactivacion_masiva.sql`.
- `POST /lotes-vivero/:id/asignaciones` crea asignación física, exige evidencia, registra salida M2 `DESPACHO / ASIGNACION_SUBCAMPANIA`, descuenta `LOTE_VIVERO.saldo_vivo_actual` y registra evento M3 `ASIGNACION_VIVERO`.
- `POST /lotes-vivero/:id/reservas` fue eliminado; `fn_vivero_reservar_stock_lote` queda dropeada por la migración `052`.
- `fn_m3_registrar_plantacion` ya no genera `EVENTO_LOTE_VIVERO`, no usa `AUTOMATICO_PLANTACION` y no toca `LOTE_VIVERO.saldo_vivo_actual`; devuelve `consumos`.
- Plantación inicial consume asignaciones `PLANTACION_INICIAL`; reposición consume asignaciones `REPOSICION`, permite subcampañas `ACTIVA`, `COMPLETADA` y `FINALIZADA_PARCIAL`, y bloquea exceso sobre pendiente de reposición.
- Devolución física implementada con `fn_m3_devolver_asignacion_vivero` y `POST /lotes-vivero/:id/asignaciones/:asignacionId/devolucion`: aumenta `cantidad_devuelta`, aumenta `LOTE_VIVERO.saldo_vivo_actual`, registra `DEVOLUCION_PLANTACION` en M2 y `DEVOLUCION_A_VIVERO` en M3. En MVP no exige evidencia fotográfica.
- Cancelación de subcampaña usa `fn_subcampania_cancelar` v2: bloquea si `total_plantado_inicial > 0` y devuelve físicamente saldos disponibles de asignaciones activas antes de cancelar.
- La restricción de saldo de `EVENTO_LOTE_VIVERO` permite y valida el incremento exacto producido por `DEVOLUCION_PLANTACION` (migración `056`).
- Desactivación masiva de campaña implementada con preview y ejecución atómica: cancela subcampañas `BORRADOR`/`ACTIVA` sin plantaciones, devuelve stock y aplica soft-delete a la campaña (migración `057`).
- Merma M2 vuelve a afectar solo stock físico en vivero: valida contra `LOTE_VIVERO.saldo_vivo_actual` y no modifica asignaciones entregadas.
- Despacho manual valida contra saldo físico del lote y rechaza `destino_tipo = PLANTACION_CAMPANIA`.
- Consultas de saldos exponen `saldo_vivo_actual` y `saldo_asignado_subcampanias`; ya no publican como vigente la identidad `saldo_vivo_actual - saldo_asignado_total`.
- Swagger, documentación local de frontend, guía de migración y Postman fueron actualizados en el repo Backend.
- Verificaciones confirmadas el 2026-07-23: unitarios Backend, e2e DB y build/lint Frontend pasan.

### Producción confirmada — 2026-07-23

1. Migraciones `056` y `057` aplicadas en Supabase de producción.
2. Backend y frontend desplegados coordinadamente en producción.
3. Unitarios Backend, e2e DB y build/lint Frontend ejecutados correctamente.
4. El frontend productivo consume el contrato físico M2↔M3 y la desactivación masiva de campaña.

### Seguimiento operativo

1. Vigilar que no aparezcan escrituras nuevas con `AUTOMATICO_PLANTACION`.
2. Alinear la implementación del despacho manual con la matriz de
   `ADR-VIV-16` y `RF-VIV-05`: no debe solicitar campaña/subcampaña, debe
   exigir comunidad para `DONACION`, aplicar `destino_referencia` según el tipo
   y mantener evidencia obligatoria.

### Hallazgos de auditoría Backend — 2026-07-23

Estos puntos describen diferencias verificadas entre el contrato canónico y el
repositorio `Backend-r3foresta`; no cambian las decisiones de dominio:

1. **`RF-VIV-05` no está completamente aplicado en el contrato HTTP/SQL.**
   `RegistrarDespachoDto` y `fn_vivero_registrar_despacho` exigen
   `destino_referencia` para todo destino, aunque para `DONACION` es opcional;
   a la vez, `comunidad_destino_id` sigue siendo opcional para `DONACION`,
   aunque la matriz canónica lo exige. ⏳ pendiente alinear DTO, Swagger,
   service, RPC y pruebas en un mismo cambio.
2. **El replay de migraciones no reproduce el enum vivo
   `destino_tipo_vivero`.** La migración `006` crea
   `DONACION_COMUNIDAD`; el código y el schema canónico usan
   `PLANTACION_COMUNIDAD` y `DONACION` como valores separados. La migración
   `023` documenta el estado vivo y agrega `PLANTACION_CAMPANIA`, pero no
   ejecuta la alineación previa. ⏳ pendiente una nueva migración idempotente y
   una prueba desde BD vacía.
3. **Persiste el drift de `TIPO_PLANTA`.** El código y el schema usan
   `planta.tipo_planta_id` + `tipo_planta`, pero las migraciones no reconstruyen
   completamente esa estructura. ⏳ pendiente migración de alineamiento.
4. **Seguridad de identidad pendiente.** WebAuthn emite JWT, pero la mayoría de
   endpoints confía en `x-auth-id` sin guard global; además existen endpoints
   de mint, Pinata y diagnóstico sin autenticación. ⏳ tratar como P0 antes de
   ampliar exposición a clientes no confiables.

Durante esta auditoría se sincronizó la copia documental de la migración `050`
con la versión del Backend. Antes difería en una condición funcional:
las subcampañas ya soft-deleted no deben bloquear el soft-delete de Campaña.

## Integración Módulo 2 (Vivero) ↔ Módulo 3 (Plantación)

| Pieza | Fuente documental | Estado |
|---|---|---|
| Enums y schema físico M2↔M3: `ASIGNACION_SUBCAMPANIA`, `DEVOLUCION_PLANTACION`, `evento_lote_vivero.asignacion_id`, FKs M3, CHECK que bloquea nuevas escrituras `AUTOMATICO_PLANTACION`, vista física `v_lote_vivero_saldos` | `database/00_database_schema.md`, migración `051` | ✅ implementado en Backend. La actualización del 2026-07-23 confirmó específicamente la aplicación de `056` y `057`; no hizo una nueva auditoría individual de `051`–`055`. |
| Handler atómico de asignación física | `90-contratos-integracion/02_contrato_vivero_a_plantacion.md`, migración `052` | ✅ implementado en Backend con `fn_vivero_asignar_stock_subcampania` y endpoint `POST /lotes-vivero/:id/asignaciones`. |
| Eliminación del flujo de reserva lógica | contrato M2↔M3, migración `052` | ✅ implementado en Backend: se elimina alias `POST /:id/reservas` y se dropea `fn_vivero_reservar_stock_lote`. |
| Plantación/reposición como consumo de asignaciones, sin despacho M2 | contrato M2↔M3, M3 procesos, migración `053` | ✅ implementado en Backend: respuesta con `consumos`, detalles con `evento_lote_vivero_despacho_id = NULL`. |
| Devolución física y cancelación de subcampaña | contrato M2↔M3, RN-PLA-37, migración `054` | ✅ implementado en Backend: RPC de devolución física, endpoint de devolución y cancelación con devolución física automática. |
| Merma M2, saldos y despacho manual con semántica física | contrato M2↔M3, migración `055` | ✅ implementado en Backend: merma no toca asignaciones; despacho manual valida contra saldo físico; saldos separados. |
| Constraint de incremento por devolución | migración `056` | ✅ aplicada en producción: `DEVOLUCION_PLANTACION` puede incrementar saldo y el delta debe coincidir exactamente con `cantidad_afectada`. |
| Desactivación atómica de campaña con cancelación masiva | RN-PLA-38, migración `057` | ✅ aplicada en producción: helper canónico compartido, devolución física, locks ordenados y rollback por campaña. |
| API/Swagger/documentación frontend del contrato nuevo | Backend docs / Swagger / `pwa-r3foresta` | ✅ implementado, desplegado y consumido por el frontend en producción. |
| Separación UI Despacho manual / Asignación | `02-vivero-module/03_tarea_frontend_separar_despacho_asignacion.md`, `pwa-r3foresta` commit `562a97e` | ✅ implementado en Frontend: Despacho ofrece `DONACION`, `VENTA`, `OTRO`; Asignación usa formulario/acción propios; el tab `Asignaciones` conserva consulta y devolución. Sin cambios de Backend. Lint/build verificados el 2026-07-23. |
| Pruebas de regresión y concurrencia | specs Backend | ✅ unitarios y e2e DB confirmados el 2026-07-23. |
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
| Frontend: en detalle/listado de lote, detectar `ACTIVO` + `INICIO` + sin `EMBOLSADO` y mostrar acción de descarte total pre-embolsado | `02-vivero-module/02_flujo_operativo_vivero_core.md` §7.2 | ✅ implementado en `pwa-r3foresta` (`QuickActions`, `ViveroEventScreen`). |
| Frontend: formulario con fecha, responsable, causa, cantidad total prellenada desde `cantidad_inicial_en_proceso`, unidad, observaciones y evidencia obligatoria | `RF-VIV-02A` | ✅ implementado en `DescartePreEmbolsadoForm`. |
| Frontend: si el lote ya tiene `EMBOLSADO`, la acción equivalente debe registrar pérdida total post-embolsado, no descarte pre-embolsado | `02-vivero-module/02_flujo_operativo_vivero_core.md` §7.2 | ✅ implementado: la acción pre-embolsado se oculta y queda disponible `MERMA`. |

## Módulo 3 (Plantación) — Creación/planeación de subcampaña

| Pieza | Fuente documental | Estado |
|---|---|---|
| Diseño: cancelación de subcampaña sin plantaciones (BORRADOR o ACTIVA sin plantar) → `CANCELADA`; si hay plantado, `FINALIZADA_PARCIAL` | `03-plantacion-module/01_reglas_de_negocio_plantacion.md` (RN-PLA-37, RN-PLA-06), `02_Procesos...` §3.12, `database/00_database_schema.md`, `CLAUDE.md` | ✅ documentado |
| Backend/BD: transición a `CANCELADA` (solo ADMIN, guard `total_plantado_inicial = 0`), evento `SUBCAMPANIA_CANCELADA`, resolución de asignaciones activas con devolución física si ya fueron entregadas | RN-PLA-37 / contrato M2↔M3 actualizado | ✅ implementado en Backend con `fn_subcampania_cancelar` v2 (migración `054`). |
| Diseño: meta agregada de campaña derivada (`meta_planificada_campania`, incluye BORRADOR, excluye CANCELADA), no persistida | `01_reglas...` (RN-PLA-36), `02_Procesos...` §2.1, `database/00_database_schema.md` | ✅ documentado |
| Backend: lectura derivada `meta_planificada_campania` para vista admin; el público agrega solo ACTIVA/COMPLETADA/FINALIZADA_PARCIAL | RN-PLA-36 | ✅ implementado en `GET /api/campanias` y `GET /api/campanias/:id`; vista pública a cargo del frontend. |
| Diseño: edición básica y dos acciones explícitas de desactivación — estricta y atómica con cancelación masiva —; `tipo` solo sin subcampañas | `01_reglas...` (RN-PLA-38), `02_Procesos...` §2.1/§3.1, `database/00_database_schema.md`, `decisiones/02_decisiones_plantacion.md` (ADR-PLA-01) | ✅ documentado |
| BD: desactivación estricta y desactivación atómica con cancelación de `BORRADOR`/`ACTIVA` sin plantaciones, devolución de stock y soft-delete de campaña | migraciones `050`, `056` y `057` | ✅ implementado y aplicado en Supabase de producción. |
| Backend: preview de elegibilidad y ejecución masiva por campaña | `GET /api/campanias/:id/desactivacion/preview`, `POST /api/campanias/:id/desactivar` | ✅ implementado y desplegado en producción. |
| Frontend: modal de preview, bloqueos, motivo, confirmación y resumen de devolución | `pwa-r3foresta`, `DesactivarCampaniaModal` | ✅ implementado, verificado y desplegado en producción. |
| Aclaración cerrada: asignación de lotes solo post-`ACTIVA` (no en BORRADOR); activar con 0% de stock permitido | `02_Procesos...` §2.13, `00_...json` RF-PLA-02/03, `03_Mockups...` §3.6 | ✅ implementado bajo contrato físico: `POST /api/lotes-vivero/:id/asignaciones` rechaza BORRADOR/CANCELADA y valida propósito por estado; activación permite 0 asignaciones. |
| Frontend: wizard de subcampaña sin paso de asignación + acción "Cancelar" según estado | `03_Mockups...` §3.6/§3.7/§3.10 | ✅ wizard y cancelación implementados; asignación física opera desde el detalle de lote de Vivero. |
| Frontend: adaptación UI al flujo de asignación física, consumo de stock asignado y devoluciones | `03-plantacion-module/04_plan_frontend_m3.md`, `02-vivero-module/03_tarea_frontend_separar_despacho_asignacion.md` | ✅ implementado en `pwa-r3foresta`: Asignación tiene acción/formulario independiente, el tab por lote lista asignaciones activas y permite devoluciones, y Despacho queda reservado en UI para salidas no asociadas a campaña. La vista agregada por subcampaña y el mantenimiento avanzado siguen fuera de este cierre. |
| Backend: `GET /subcampanias/:id/plantacion/context` (subcampaña, permisos, equipo, plan y stock asignado por especie con sus asignaciones, y reglas) | Backend `documentacion/postman/plantacion-context.md` | ✅ implementado en Backend. |
| Frontend: **registro de plantación inicial en campo** — flujo mobile 3 pasos (evidencia+GPS, cantidades por especie, resolución automática de `detalles` por asignación `fecha_asignacion ASC, asignacion_id ASC`), guardado transaccional con limpieza de evidencias y comprobante con `consumos` | `03-plantacion-module/04_plan_frontend_m3.md` §5.2 / §9 Paso 3 | ✅ implementado en `pwa-r3foresta` (`src/modules/plantacion`, ruta `/app/planting/subcampanias/:id/plantaciones/new`). QA 2026-07-08 sin bloqueantes. |
| BD: tabla `SUBCAMPANIA_HISTORIAL` (append-only, con enum `tipo_historial_subcampania`) para eventos de ciclo de vida (`BORRADOR_CREADO`, `SUBCAMPANIA_ACTIVADA`, `SUBCAMPANIA_CANCELADA`, y futuros) | `02_Procesos...` §4.1 | ✅ creada por migración `047` en repo Backend; creation/activation/cancelación escriben eventos. Los eventos `SUBCAMPANIA_COMPLETADA / FINALIZADA_PARCIAL / TRANSICION_A_MONITOREO_HISTORICO / EQUIPO_*` quedan pendientes de sus flujos respectivos. |
| BD: tabla `SUBCAMPANIA_META_ESPECIE` + endpoints `GET /api/subcampanias/:id/plan` y `PUT /api/subcampanias/:id/plan`; validación al activar `SUM(%) = 100` y `SUM(cantidad) = meta_total_arboles` | `01_reglas...` RN-PLA-15/16/17, `database/00_database_schema.md` | ✅ implementado en Backend (migración `047` + servicios/policy). ⏳ pendiente aplicar/confirmar en Supabase si no está aplicado. |

## Observaciones para el auditor

- El contrato M2↔M3 vigente ya no debe describirse como reserva lógica en documentos vivos. Las menciones restantes en `_legacy/`, `_historico/` y migraciones antiguas son históricas.
- La fuente de estado operativo es este archivo; la fuente de diseño sigue siendo el contrato y los módulos.
