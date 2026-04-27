# Documento Operativo Corto — Módulo 2: Vivero (MVP)

## 1. Qué hace el módulo

El módulo **Vivero** recibe material biológico desde Recolección y registra su proceso operativo hasta generar plantas vivas, registrar pérdidas o despachos y cerrar el lote.

Su objetivo operativo es:

- mantener trazabilidad fuerte desde un único origen,
- registrar el arranque del lote,
- diferenciar material en proceso de plantas vivas,
- controlar saldo vivo,
- y cerrar el lote de forma auditable.

## 2. Entidades principales

- **LOTE_VIVERO**: entidad principal del módulo.
- **EVENTO_LOTE_VIVERO**: historial append-only del lote.
- **RECOLECCION**: origen único del lote.
- **RECOLECCION_MOVIMIENTO**: movimiento de consumo que alinea Módulo 1 con Módulo 2 en `INICIO`.
- **EVIDENCIAS_TRAZABILIDAD**: evidencia asociada a cada evento obligatorio.
- **PLANTA**: catálogo maestro de especie, pero no fuente viva del historial una vez congelado el snapshot.
- **VIVERO**: lugar donde opera el lote.

## 3. Reglas bloqueantes

- Todo lote de vivero tiene un solo origen.
- No se permite mezclar lotes origen.
- La creación del lote y el consumo del origen deben ser atómicos.
- `INICIO` debe quedar alineado con `RECOLECCION_MOVIMIENTO`.
- La identidad visible del lote debe heredarse desde los snapshots oficiales de `RECOLECCION`, no recalcularse desde `PLANTA`.
- El `codigo_trazabilidad` del lote debe usar formato `VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`.
- El `vivero_id` del lote se selecciona en Vivero y no se hereda automáticamente desde `RECOLECCION.vivero_id`.
- `EMBOLSADO` no puede existir sin `INICIO`.
- `MERMA`, `DESPACHO` y `ADAPTABILIDAD` no pueden existir sin `EMBOLSADO`.
- `EMBOLSADO` solo puede registrarse una vez por lote.
- Antes de `EMBOLSADO` no existe saldo vivo.
- Desde `EMBOLSADO`, el saldo vivo se maneja solo en `UNIDAD`.
- El sistema no convierte automáticamente gramos en plantas vivas.
- El saldo vivo no puede quedar negativo.
- Un lote `FINALIZADO` no admite nuevos eventos operativos normales.
- La evidencia mínima es 1 foto para `INICIO`, `EMBOLSADO`, `MERMA` y `DESPACHO`; en `ADAPTABILIDAD` es opcional.

## 4. Flujo feliz

1. Se selecciona una **RECOLECCION** `VALIDADO` con saldo suficiente.
2. Se leen los snapshots oficiales ya congelados en esa recolección.
3. Se selecciona el vivero operativo del lote.
4. Se crea el **LOTE_VIVERO** heredando esos snapshots y se registra `CONSUMO_A_VIVERO` en Módulo 1.
5. Se registra `INICIO` con la misma cantidad y unidad del consumo.
6. El lote queda `ACTIVO`, pero todavía sin saldo vivo.
7. Se registra `EMBOLSADO`.
8. Nacen `plantas_vivas_iniciales` y `saldo_vivo_actual` en `UNIDAD`.
9. Opcionalmente se registra `ADAPTABILIDAD`.
10. Si hay pérdidas, se registra `MERMA`.
11. Si salen plantas a destino, se registra `DESPACHO`.
12. Cuando `saldo_vivo_actual = 0`, el sistema genera `CIERRE_AUTOMATICO` y el lote pasa a `FINALIZADO`.

## 5. Qué no se permite

- Crear un lote desde una recolección no validada.
- Crear un lote desde una recolección que todavía no tenga snapshot oficial congelado.
- Mezclar varios orígenes en un lote.
- Registrar `EMBOLSADO` sin `INICIO`.
- Registrar `MERMA` sin `EMBOLSADO`.
- Registrar `DESPACHO` sin `EMBOLSADO`.
- Editar eventos ya registrados.
- Reabrir un lote en el MVP.
- Convertir automáticamente masa a plantas vivas.
- Persistir `kg` en base de datos.
- Usar unidades fuera de `UNIDAD` y `G`.
- Registrar saldo vivo negativo.
- Despachar o mermar más plantas de las disponibles.

## 6. Enums oficiales

- `estado_lote_vivero = [ACTIVO, FINALIZADO]`
- `tipo_evento_vivero = [INICIO, EMBOLSADO, ADAPTABILIDAD, MERMA, DESPACHO, CIERRE_AUTOMATICO]`
- `subetapa_adaptabilidad = [SOMBRA, MEDIA_SOMBRA, SOL_DIRECTO]`
- `causa_merma_vivero = [PLAGA, ENFERMEDAD, SEQUIA, DANO_FISICO, MUERTE_NATURAL, DESCARTE_CALIDAD, OTRO]`
- `destino_tipo_vivero = [PLANTACION_PROPIA, DONACION_COMUNIDAD, VENTA, OTRO]`
- `motivo_cierre_lote = [DESPACHO_TOTAL, PERDIDA_TOTAL, MIXTO]`
- `unidad_medida = [UNIDAD, G]`

## 7. Endpoints o acciones principales

Si la API todavía no está cerrada, estas son las **acciones mínimas** que el módulo debe soportar:

- Crear lote de vivero desde recolección.
- Consultar detalle de lote.
- Listar lotes activos y finalizados.
- Registrar `INICIO`.
- Registrar `EMBOLSADO`.
- Registrar `ADAPTABILIDAD`.
- Registrar `MERMA`.
- Registrar `DESPACHO`.
- Consultar timeline del lote.
- Consultar evidencias por evento.

## 8. Lectura rápida del lote

- `INICIO`: entra material en proceso, sin saldo vivo.
- `EMBOLSADO`: nacen las plantas vivas en `UNIDAD`.
- `ADAPTABILIDAD`: seguimiento sin cambiar saldo.
- `MERMA`: baja el saldo vivo.
- `DESPACHO`: baja el saldo vivo por salida.
- `CIERRE_AUTOMATICO`: el lote terminó porque ya no quedan plantas vivas.
