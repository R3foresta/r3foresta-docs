# ESTADO.md — Estado vivo de implementación

> **Actualización de integración 2026-10-14: PA-T-INT02-A COMPLETADO** en identidad/perfil, privacidad e integración de desarrollo. 066/067 aplicadas y verificadas en el Supabase de DESARROLLO `vyrjlehkhabydkhjxagx`, identificado expresamente por Pablo. Lecturas/escrituras públicas de usuarios y credenciales y escrituras públicas de organizaciones cerradas; timeouts PostgREST 5/30 s medidos. Backend/PWA locales comprobados con passkey real, cuenta GENERAL, afiliación catálogo/Otra/null y recargas, rechazos de autoridad/identidad y plan/Impacto. Código publicado en main: backend `57e5b71` y PWA `cf13036`. Despliegue y piloto no acreditados. [Informe y evidencia](../Backend-r3foresta/docs/pa-int02a-continuacion-2026-10-14.md).

> Este documento registra el **avance de implementación** (qué está en el repo Backend, qué falta aplicar/verificar y qué queda pendiente), no el diseño. La documentación canónica del *diseño* del dominio vive en los módulos (`00-general-module/`, `01-recoleccion-module/`, `02-vivero-module/`, `03-plantacion-module/`), en los contratos de integración (`90-contratos-integracion/`) y en `database/00_database_schema.md`.

> **Actualización documental 2026-10-10:** el backend local mantiene metas orientativas y cierre manual (ADR-PLA-04/060–061), e implementa revisión atómica de meta/especies por ADMIN en BORRADOR o ACTIVA (ADR-PLA-05/062), con JWT en GET/PUT /plan y RPC de lectura restringida al backend (063). El usuario confirmó aplicación en Supabase hasta 062 y posteriormente de 063. El frontend está implementado localmente; la publicación de sus últimos ajustes, el QA integrado y la verificación del despliegue siguen pendientes; las pruebas locales y la confirmación humana de migraciones no acreditan funcionamiento remoto. El cierre conserva fechas explícitas y sus eventos de historial pendientes.

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
   ampliar exposición a clientes no confiables. GET/PUT /plan son una excepción
   actualizada el 2026-10-10: ya verifican JWT e identidad; esto no cierra la
   deuda de autenticación de las demás rutas.

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
| BD: tabla `SUBCAMPANIA_HISTORIAL` (append-only, con enum `tipo_historial_subcampania`) para eventos de ciclo de vida (`BORRADOR_CREADO`, `SUBCAMPANIA_ACTIVADA`, `SUBCAMPANIA_CANCELADA`, y futuros) | `02_Procesos...` §4.1 | ✅ creada por migración `047` en repo Backend; creation/activation/cancelación escriben eventos; 062 añade `PLAN_REVISADO`, obligatorio en cada revisión atómica del plan. Los eventos `SUBCAMPANIA_COMPLETADA / FINALIZADA_PARCIAL / TRANSICION_A_MONITOREO_HISTORICO / EQUIPO_*` quedan pendientes de sus flujos respectivos. |
| BD: tabla `SUBCAMPANIA_META_ESPECIE` + endpoints `GET /api/subcampanias/:id/plan` y `PUT /api/subcampanias/:id/plan`; validación al activar `SUM(%) = 100` y `SUM(cantidad) = meta_total_arboles` | `01_reglas...` RN-PLA-15/16/17, `database/00_database_schema.md` | ✅ base implementada con `047`, ampliada por `062` (revisión atómica BORRADOR/ACTIVA) y JWT/`063`. Aplicación hasta 062 y de 063 confirmada por el usuario; frontend implementado localmente, QA integrado/verificación remota pendientes. |

## Observaciones para el auditor

- El contrato M2↔M3 vigente ya no debe describirse como reserva lógica en documentos vivos. Las menciones restantes en `_legacy/`, `_historico/` y migraciones antiguas son históricas.
- La fuente de estado operativo es este archivo; la fuente de diseño sigue siendo el contrato y los módulos.


## Ajuste de meta y especies en ACTIVA — cierre documental 2026-10-10

**Backend y frontend implementados localmente; tareas de implementación cerradas según código y confirmación del usuario.** Conserva ADR-PLA-05, metas orientativas, cierre manual y saldos físicos. No acredita QA integrado ni despliegue remoto.

| Pieza | Evidencia | Estado |
|---|---|---|
| Revisión atómica, versión, auditoría y protección de especies usadas | Backend 062, servicio de plan y guard JWT/063 | Implementado. Meta/especies y PLAN_REVISADO se guardan juntos; conflicto 409 no sobrescribe cambios ajenos. |
| Lectura autenticada y escritura ADMIN | JWT del login WebAuthn; RPC solo service_role | Implementado. La lectura no concede permisos operativos ni acceso al stock. |
| Editor frontend, comparación/confirmación y formulario compartido | EditarPlanSubcampania, modal, PlanMetaEspeciesForm y hook | Implementado en el árbol local; meta/plan/versión en un único PUT, sin PATCH de meta separado. |
| Sesión, conflictos y guardado incierto | API/service frontend y editor | Sin token no hay request; 401 recupera sesión, 403 bloquea edición, 409/red/500/confirmación incompleta conservan propuesta y exigen nueva lectura/revisión. |
| Migraciones hasta 062 y 063 | Confirmaciones humanas conservadas en la actualización previa | Aplicadas según el usuario. Esta revisión no inspeccionó Supabase remoto. |
| Acceso local al plan | Registro backend de cierre del 10 de octubre | Usuario confirmó 200 tras renovar passkey y mix visible; sin sesión/token inválido devuelve 401. No es verificación remota. |
| Validación backend reportada | Documento backend de revisión atómica | 531 pruebas unitarias/HTTP, 46 PostgreSQL aisladas y build aprobados; no repetidos aquí. |
| Validación frontend reportada | FRONTEND_AUDIT.md, últimos ajustes del 10 de octubre | 284 pruebas/19 suites, lint y build aprobados; usan respuestas simuladas y no se repiten aquí. |
| Estado Git inspeccionado | Backend ae19480; frontend 2c8c29a | Ambas ramas main coinciden con sus referencias locales origin/main. Backend limpio; frontend conserva ajustes adicionales sin commit. No se consultó el remoto ni se alteró su código. |
| QA integrado y operación desplegada | AUD-015 frontend; guía de diagnóstico 062–063 | Pendientes de comprobación en entorno coordinado. AUD-016 conserva el hallazgo del encabezado exterior tras rechazo por cambio de estado; no afecta el rechazo del guardado. |

Fuentes: [revisión de cierre](03-plantacion-module/07_revision_meta_especies_cierre.md), [evidencia backend](../Backend-r3foresta/documentacion/tareas/subcampanias-revision-plan-atomica.md) y [auditoría frontend](../pwa-r3foresta/FRONTEND_AUDIT.md). Las confirmaciones de aplicación de migraciones provienen del [chat de implementación backend](codex://threads/01a12288-904e-7061-8dd0-2b80f916a157), ya conservadas en la revisión documental previa.

La implementación local se distingue de publicar los últimos ajustes frontend y comprobar el flujo real en un entorno objetivo: acceso autenticado, ADMIN 50/40 → 50/60, conservación física, especie nueva antes de asignación/plantación, retirada protegida, revisiones concurrentes y cierre con la meta vigente. No se realizan escrituras de prueba en Supabase compartido por esta revisión.


## Participación aliada PA-F01 — estado documental del 13 de octubre de 2026

El cierre anterior del registro interno, contexto y logística M2↔M3 no acredita el incremento participante. [Índice y tareas vigentes](specs/plantacion/participacion-aliada/README.md).

| Pieza | Estado acreditado | Pendiente de ejecución/verificación |
|---|---|---|
| PA-S00/01/02/03 | Comportamiento aprobado; PA-S01 cerrada integralmente el 12, incluidas observaciones/revisión/confirmación. | Adaptación e integración del incremento. |
| PA-S04 | Alcance de correcciones, duplicados y eliminación lógica de registros erróneos confirmado; administrador contextual de esa subcampaña o ADMIN global según caso. | Cierre integral de casos especiales, contratos de efectos e implementación/verificación. |
| Contraste de contratos actuales | Lectura de backend/DTO/SQL/consumidores frontend completada el 12. | Catálogo del entorno destino y garantías de ejecución reales. |
| Inventario de endpoints y regresión | Segunda lectura estática del 13 completada; matriz de facultades, pruebas propuestas y plantilla de transición preparadas. | Ejecutar suites y completar/revisar manifest real; no convertir usuarios por la plantilla. |
| Contrato backend, D01–D12 | Diseño aceptado por Pablo el 13, con afiliación opcional del catálogo o «Otra» y LIFO del stock de subcampaña sin recepción adicional. [Acta técnica](specs/plantacion/participacion-aliada/revision-tecnica-2026-10-13.md). | Cotejo catálogo, migraciones nuevas, código y pruebas; aceptación no equivale a aplicación. |
| Comandos compartidos e identidad/permisos | Enfoque y diseño aceptados; guard, alta VOLUNTARIO/perfil seguro, roles separados, permiso/versiones, cargas/recuperación definidos. | PA-T-INT02-A como siguiente entrega, luego permisos/registro/gestión según contrato. |
| Backend/frontend del incremento, SQL y piloto | Esta alineación documental no aporta evidencia nueva de implementación, migraciones aplicadas, pruebas ejecutadas o despliegue. | Registrar versión, entorno, resultados y habilitación humana de campo cuando se ejecuten. |

Fuentes de diseño: [contrato backend aceptado](specs/plantacion/participacion-aliada/contrato-identidad-permisos-backend-propuesta.md), [specs y acuerdos](specs/plantacion/participacion-aliada/README.md), [revisión de contratos](specs/plantacion/participacion-aliada/revision-contratos-2026-10-12.md) e [inventario](specs/plantacion/participacion-aliada/inventario-endpoints-y-regresion-participacion.md). Los textos FIFO de verificaciones/implementaciones anteriores conservan su evidencia; el objetivo del incremento inicial es LIFO aceptado, pendiente de adaptación.


## PA-T-INT02-A — implementación y revisión local del 13 de octubre de 2026

**Backend implementado y revisado en el árbol local, sin commit/push ni publicación.** Se cotejaron la tarea de inicio y el contrato D01–D12 aceptado. [Informe y evidencia reproducible](../Backend-r3foresta/docs/pa-int02a-entrega-local.md). Esta actualización no habilita el piloto.

| Evidencia | Estado acreditado | Pendiente |
|---|---|---|
| Código backend | JWT verificado, alta VOLUNTARIO, perfil propio v1 y afiliación opcional catálogo/Otra/ausencia; selector mínimo activo, aliases privados sin mutación de autoridad, IDs exactas, edición histórica atómica y directorio interno cerrado a VOLUNTARIO. | Commit/push se coordinan por separado; políticas completas y permisos/comandos continúan en INT02-B/C/D e INT03-A. |
| Build y pruebas | Build aprobado; 52 suites y 570 pruebas unitarias/HTTP aprobadas. Incluyen regresión del plan autenticado/ADMIN e Impacto público sin token y con sesión vencida. | HTTP usa frontera Supabase simulada; no acredita base remota ni ceremonia real de dispositivo. |
| PostgreSQL sintético aislado | Migración 064, constraints, cuatro roles, revisión/actividad conservadas, BIGINT, texto legado, NFC/paginación y rollback verificados. ACL/RLS previas permisivas y llamadas efectivas service_role/anon/authenticated probadas; carreras selección/inactivación verificadas en ambos órdenes con barreras de locks. | Cotejar catálogo/ACL/RLS real y conciliar datos antes de aplicar. Ningún dato real se usó como fixture. |
| 064 aplicada en desarrollo | JSON aportado por Pablo el 13 de octubre a las 17:07:17 America/La_Paz: 39 cuentas y conteos ADMIN 5/GENERAL 32/VOLUNTARIO 2 conservados; cero auth_id vacíos/nulos/duplicados; nuevas columnas, default y constraints validados; cinco RPC con firmas/argumentos/huellas coincidentes y ejecución solo postgres/service_role; INSERT/UPDATE públicos denegados, DELETE retirado de ACL. | RLS sigue desactivada. SELECT privado de usuario y escrituras públicas de organizacion aún abiertos; corte de consumidores/privacidad INT02-D pendiente. El agente no se conectó ni escribió remotamente; no hay despliegue acreditado. Configurar y medir statement_timeout de 30 s antes del comando en PostgREST/sesión. |
| Conciliación sintética previa a 064 | Script acotado al manifest real, probado con 39 cuentas/roles 5/32/2: ocho identidades vacías sin credenciales conciliadas; passkeys, duplicados no vacíos, manifest cambiado, afectadas adicionales, colisiones y FK detienen sin cambios. Conserva perfiles, PK, credenciales válidas e historial; repetición vacía y 064/diagnóstico final aprobados. | Conciliación real confirmada por Pablo en desarrollo: CONCILIACION_CONFIRMADA, ocho actualizaciones y manifest esperado. 064 y diagnóstico posterior confirmados mediante el JSON aportado por Pablo; no acredita despliegue. |
| 065 aplicada en desarrollo | Resultado aportado por Pablo el 13 de octubre a las 17:25:47 America/La_Paz, PostgreSQL 17.6: PERMISOS_RESIDUALES_CONFIRMADOS. anon/authenticated tienen solo SELECT en usuario; INSERT/UPDATE/DELETE/TRUNCATE/REFERENCES/TRIGGER/MAINTAIN=false. service_role mantiene sus permisos. Conserva 39 cuentas, ADMIN 5/GENERAL 32/VOLUNTARIO 2. La rama MAINTAIN queda confirmada en 17.6; ensayos locales de idempotencia, seis denegaciones SQL reales y regresión de perfiles aprobados. | SELECT privado de usuario y escrituras públicas de organizacion requieren el corte INT02-D. QA API/cliente y despliegue siguen pendientes; resultado SQL no acredita piloto listo. |
| Compatibilidad PWA | Repositorio sin cambios; aliases conservan su forma e IDs string/number admitidas por el cliente. | Retirar rol del payload de register-form antes de publicar: la PWA actual lo envía y el backend devuelve 422 CAMPO_NO_PERMITIDO. Integrar recorrido v1 opcional en su entrega. |
| Lint | Sin errores ni avisos en archivos TypeScript modificados; diff-check aprobado. | Lint global conserva 1.313 errores y 106 avisos en archivos ajenos a esta entrega. |

La revisión corrigió directorio abierto a VOLUNTARIO, edición parcial del alias, precisión de IDs, caché del plan, cursor demasiado largo, normalización del catálogo, constraints de identidad y pruebas SQL que podían ocultar su propio fallo. El contrato aceptado conserva su contenido; esta sección añade evidencia de implementación local. Conciliación y migraciones 064/065 están confirmadas en desarrollo por resultados aportados por Pablo. Privacidad, QA API/cliente, piloto y publicación requieren sus comprobaciones posteriores.

## PA-T-INT02-A — continuación de privacidad y PWA, 14 de octubre de 2026

Se preservaron los cambios locales del backend y de este documento. D01–D12 mantienen su aceptación; esta sección registra implementación/evidencia adicional, no autoriza producción ni piloto.

| Área | Estado acreditado | Límite |
|---|---|---|
| Inventario remoto | Proyecto DESARROLLO confirmado por Pablo: `vyrjlehkhabydkhjxagx`, coincidente con .env. PostgreSQL 17.6; 39 cuentas, ADMIN 5 / GENERAL 32 / VOLUNTARIO 2. Sin vistas de usuario/organización ni definers SQL/PLpgSQL públicos. Credenciales tenían permisos públicos de lectura/escritura y se incluyeron en el cierre. | No se usó el nombre de .env para identificar el entorno. No se copiaron filas personales al informe. |
| 066 aplicada | Resultado `PRIVACIDAD_USUARIO_ORGANIZACION_CONFIRMADA` después de COMMIT. Revoca grants de tabla/columna de usuario/credenciales y escrituras de organización, incluidos privilegios residuales; cierra todas las sobrecargas de RPC inventariadas. Verifica privilegios efectivos antes de confirmar. | RLS permanece como estaba; el cierre es por grants. Supabase Auth no se confunde con JWT app `sub=auth_id`. SELECT mínimo/público de organizaciones para Impacto se conserva. |
| Backend privado | Consumidores de usuario/joins/RPC y escrituras de organización usan service_role sin fallback. Siete controllers operativos verifican JWT, actividad y audiencia interna; perfil/selector v1 admite toda cuenta activa, VOLUNTARIO incluido. Escrituras de organizaciones siguen siendo ADMIN. | Permisos por objeto, locks completos, roles/baja y comandos pertenecen a INT02-B/C/D posteriores. Afiliación no concede autoridad. |
| PWA | Formulario v1 sin rol editable/enviado, documento/wallet obligatorios; nombre 100, apellido opcional 30 y Otra 150, NFC sin truncado. Selector mínimo por ID cadena, búsqueda/paginación, Otra/null, errores y protección ante cambio de sesión. El alias propio refleja catálogo vigente. | No se publicó frontend/backend remoto. Ajustes concentrados en perfil/afiliación. |
| 067 y medida real | Rol SQL service_role configurado antes del comando con statement_timeout=30s / lock_timeout=5s y recarga PostgREST. RPC mínima privada muestra los valores; `pg_sleep(31)` cancelado en **30.321 ms**, 57014 / HTTP 500. Anon no ejecuta diagnóstico. | SQL Editor solo confirmó configuración; la medida REST posterior acredita la interrupción real. |
| QA integrado real | Pablo completó passkey física en Brave localhost:5173. Cuenta 48 GENERAL: lectura/edición del perfil, búsqueda y catálogo ID `"1"`, Otra y null persistentes tras recargas. Afiliación original restaurada; rol GENERAL conservado. Identidad ajena 401, rol en v1/alias 422, crear organización GENERAL 403. Plan 103 GET 200 privado, PUT de formato válido GENERAL 403 sin RPC de escritura. Impacto listado/dashboard 200 incluso en Brave privado sin sesión. | QA real de GENERAL existente; VOLUNTARIO/cuatro roles/BIGINT >2^53 se prueban en HTTP simulado y PostgreSQL sintético. No se fabricó JWT para el QA real ni se hizo un registro participante de stock/plantación. |
| Pruebas locales | Backend build y **54 suites/594 tests** aprobados. PWA build/lint y **21 archivos/295 tests** aprobados. Fixture local independiente: **18 denegaciones SQL reales**, rollback por drift de vista pública, conservación e idempotencia de 066/067; regresión de perfil aprobada. | Ningún fixture sintético se cargó sobre datos reales. MAINTAIN se verifica en desarrollo 17.6; PostgreSQL aislado local es 14.17. Lint global backend mantiene deuda previa. |

[Informe completo, consumidores, comandos, orden y límites](../Backend-r3foresta/docs/pa-int02a-continuacion-2026-10-14.md). [Evidencia REST/timeout](../Backend-r3foresta/docs/evidencia/pa-rest-desarrollo-2026-10-14.json). [QA real](../Backend-r3foresta/docs/evidencia/pa-qa-real-2026-10-14.json). [Traza técnica sin tokens ni datos personales](../Backend-r3foresta/docs/evidencia/pa-navegador-backend-db-2026-10-14.jsonl).

[Estado final remoto](../Backend-r3foresta/docs/evidencia/pa-privacidad-estado-final-2026-10-14.json), observado el 14 de octubre a las **11:03:44 America/La_Paz**: 39 cuentas y los conteos ADMIN 5 / GENERAL 32 / VOLUNTARIO 2 conservados; nueve combinaciones rol/tabla con permisos efectivos esperados, incluido MAINTAIN. Cuenta QA 48 activa, GENERAL, revisión de autoridad 0 y afiliación original restaurada. service_role mantiene todos sus permisos y configuración 30s/5s.

Siguiente coordinación: publicar backend adaptado y PWA compatibles en el entorno que se decida; para otro proyecto, repetir identificación/preflight y coordinar el corte de clientes antes de 066/067. No restaurar lectura/escritura pública como compatibilidad. Producción y habilitación de piloto siguen pendientes de coordinación posterior; commit/push a main completados, despliegue no acreditado.


## Cierre de PA-T-INT02-A — 14 de octubre de 2026

**COMPLETADO** para identidad, alta VOLUNTARIO, perfil seguro, afiliación opcional, privacidad e integración de desarrollo. Pablo autorizó commit y push directamente a main. Backend `57e5b71` y PWA `cf13036` publicados; la documentación registra este cierre. No se crearon ramas nuevas.

La PWA incluye también la mejora posterior de acceso/Inicio/navegación/perfil: 339 pruebas, lint/build y 11 capturas con HTTP sintético. [Informe frontend](../pwa-r3foresta/docs/QA_PERFIL_PARTICIPACION_UX.md). El QA integrado con passkey GENERAL descrito arriba corresponde a la adaptación anterior; la mejora visual aún requiere repetir esa ceremonia/persistencia y probar la foto real.

[Auditoría de todas las ramas locales y remotas](../Backend-r3foresta/docs/revision-ramas-2026-10-14.md): quedan pendientes impacto en backend; dev y auditoría locales en PWA; proyección/carbono y flujo de recolección remoto en documentación. Las otras referencias revisadas están integradas por historial. No se fusionaron ni eliminaron ramas pendientes.

Continúan INT02-B permisos/versiones/transición, INT03-A registro recuperable, INT02-C gestión contextual/roles y las regresiones/políticas restantes de INT02-D. Impacto público aún requiere pantallas/rutas PWA. Publicación Git no acredita despliegue ni habilitación del piloto; INT02 completo y PA-F01 no se marcan terminados por cerrar INT02-A.
