# Modulo Vivero - Core operativo

Modulo 2. Documenta el nucleo operativo de Vivero: maduracion, saldo vivo, eventos y cierre del lote.

## Alcance del modulo

Este directorio documenta el nucleo operativo de Vivero.

Los contratos entre modulos no viven aqui, sino en:

- [`../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md`](../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md)
- [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md)

## Documentos de este modulo

- [`00_requerimientos_vivero_core.json`](00_requerimientos_vivero_core.json): requerimientos funcionales core (`RF-VIV-01..10`).
- [`01_reglas_de_negocio_vivero_core.md`](01_reglas_de_negocio_vivero_core.md): reglas internas de Vivero Core.
- [`02_flujo_operativo_vivero_core.md`](02_flujo_operativo_vivero_core.md): guia operativa del flujo core.
- [`03_tarea_frontend_separar_despacho_asignacion.md`](03_tarea_frontend_separar_despacho_asignacion.md): tarea completada para separar Despacho manual y Asignacion a subcampania en la UI de Vivero, sin cambios de backend.
- [`_legacy/`](_legacy/): respaldo historico de los documentos previos a la separacion.

## Contratos relacionados

- **Entrada desde Recoleccion:** [`../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md`](../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md)
  Define elegibilidad del origen, snapshots heredados, `CONSUMO_A_VIVERO`, invariantes de cantidad/unidad y transaccion atomica.

- **Salida hacia Plantacion:** [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md)
  Define asignaciones fisicas, devoluciones fisicas, consumo de stock asignado y saldos derivados.

## Lectura operativa rapida

- `INICIO`: crea el lote y registra material en proceso; no crea saldo vivo.
- `DESCARTE_PRE_EMBOLSADO`: cierra un lote iniciado que no producira plantas vivas; no crea saldo vivo.
- `EMBOLSADO`: crea `plantas_vivas_iniciales` y `saldo_vivo_actual`, siempre en `UNIDAD`.
- `ADAPTABILIDAD`: seguimiento opcional; no cambia saldo y no bloquea despacho.
- `MERMA`: baja `saldo_vivo_actual`.
- `DESPACHO MANUAL`: baja `saldo_vivo_actual` desde Vivero.
- `CIERRE_AUTOMATICO`: ocurre cuando `saldo_vivo_actual = 0`.

## Invariantes clave del core

- Un lote de vivero tiene un unico origen.
- En MVP no se permite division ni fusion de lotes.
- Los eventos son append-only.
- El saldo vivo nace unicamente en `EMBOLSADO`.
- Si el lote nunca llega a `EMBOLSADO`, se cierra con `DESCARTE_PRE_EMBOLSADO`, evidencia obligatoria y motivo de cierre propio.
- `ADAPTABILIDAD` no bloquea `MERMA` ni `DESPACHO MANUAL`.
- Blockchain es metadata opcional y no bloquea la operacion.

## Historico

Los archivos originales se conservaron en [`_legacy/`](_legacy/) para auditoria y trazabilidad documental:

- `_legacy/00_Requerimientos-Modulo_2_Vivero.json`
- `_legacy/01_reglas_de_negocio_vivero.md`
- `_legacy/02_doc_guia_vivero.md`
- `_legacy/04_consumo_de_vivero.md`
