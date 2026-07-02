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

## Observaciones para el auditor

- Ninguna por el momento. Si en una futura revisión se detecta una pieza de diseño que no esté ya cubierta por un documento canónico, anotarla aquí para su resolución — no inventarla como si ya estuviera resuelta.
