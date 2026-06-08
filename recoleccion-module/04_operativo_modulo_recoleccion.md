# Documento Operativo Corto — Módulo 1: Recolección (MVP)

## 1. Qué hace el módulo

El módulo **Recolección** registra el origen del material biológico que luego puede alimentar al módulo de **Vivero**.

Su objetivo operativo es:

- crear un lote origen confiable,
- registrar evidencia y ubicación,
- gestionar el flujo de revisión del registro,
- y controlar el saldo disponible para consumo o descarte.

En este módulo todavía **no** se trabaja plantas vivas; eso empieza recién en Vivero.

## 2. Entidades principales

- **RECOLECCION**: ficha principal del lote origen.
- **EVIDENCIAS_TRAZABILIDAD**: aca se registran las fotos que sirven de evidencia. 
- **RECOLECCION_HISTORIAL**: historial del ciclo de vida del registro.
- **RECOLECCION_MOVIMIENTO**: movimientos que afectan saldo.
- **UBICACION**: latitud, longitud y referencia territorial.
- **PLANTA**: catálogo maestro de especie, pero no fuente viva del historial una vez congelado el snapshot oficial.
- **VIVERO**: lugar de almacenamiento asociado a la recolección.

## 3. Reglas bloqueantes

- Toda recolección nace en `BORRADOR`.
- Solo una recolección en `VALIDADO` puede alimentar Vivero.
- `PENDIENTE_VALIDACION` congela la ficha mientras revisa el validador.
- `RECHAZADO` no habilita consumo, pero permite corregir y reenviar.
- En `VALIDADO` no se edita la ficha; solo se permiten movimientos de saldo.
- El snapshot oficial de identidad se congela solo al aprobar la validación.
- En `BORRADOR` y `RECHAZADO`, el snapshot puede recalcularse.
- El naming oficial es `nombre_comercial_snapshot`; no `nombre_comun_snapshot`.
- El soft delete solo está permitido para `BORRADOR`.
- La fecha de recolección no puede ser futura y puede ser retroactiva hasta 45 días.
- La persistencia oficial de unidades es solo `UNIDAD` y `G`.
- `kg` solo existe como input; nunca se persiste.
- `ESQUEJE` solo admite `UNIDAD`, entero estricto, sin decimales.
- `SEMILLA` puede persistirse en `G` o `UNIDAD`, según la captura funcional.
- Para solicitar validación se exigen mínimo 2 fotos (1 de Lugar + 1 de Total recolectado) y ubicación válida.
- El saldo nunca puede quedar negativo.
- `CONSUMO_A_VIVERO` y `DESECHO` usan `delta` negativo.
- El consumo hacia Vivero debe ser atómico con la creación del lote de vivero.

## 4. Flujo feliz

1. El recolector crea una **RECOLECCION** en `BORRADOR`.
2. Completa especie, material, cantidad, vivero, ubicación y fotos.
3. Puede editar la ficha cuantas veces necesite mientras siga en `BORRADOR`.
4. Envía el registro a `PENDIENTE_VALIDACION`.
5. Se registra `SOLICITUD_VALIDACION` en `RECOLECCION_HISTORIAL`.
6. El validador revisa y aprueba.
7. En `approveValidation` se congelan en `RECOLECCION` los snapshots oficiales:
   `nombre_cientifico_snapshot`, `nombre_comercial_snapshot`, `variedad_snapshot`, `nombre_comunidad_snapshot`, `nombre_recolector_snapshot`.
8. El registro pasa a `VALIDADO` y se registra `VALIDACION_APROBADA`.
9. Desde Vivero se puede hacer un `CONSUMO_A_VIVERO` si hay saldo suficiente.
10. El lote de vivero hereda esos snapshots ya congelados, sin releer `PLANTA` en vivo.
11. El lote de vivero selecciona su propio `vivero_id`; no lo hereda automáticamente desde la recolección.
12. El lote de vivero genera `codigo_trazabilidad` con formato `VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`.
13. Si ocurre pérdida operativa en origen, se registra `DESECHO`.
14. Si el saldo llega a 0, el estado operativo pasa a `CERRADO`.

## 5. Qué no se permite

- Consumir una recolección en `BORRADOR`.
- Consumir una recolección en `PENDIENTE_VALIDACION`.
- Consumir una recolección en `RECHAZADO`.
- Consumir una recolección `VALIDADO` que todavía no tenga snapshot oficial congelado.
- Editar una ficha en `PENDIENTE_VALIDACION`.
- Editar una ficha en `VALIDADO`.
- Eliminar una recolección que no esté en `BORRADOR`.
- Persistir `kg` en base de datos.
- Mezclar `G` y `GR`.
- Registrar saldo negativo.
- Consumir más de lo disponible.
- Usar `RECOLECCION_MOVIMIENTO` como historial general de edición.

## 6. Enums oficiales

- `estado_registro_recoleccion = [BORRADOR, PENDIENTE_VALIDACION, VALIDADO, RECHAZADO]`
- `estado_operativo_recoleccion = [ABIERTO, CERRADO]`
- `tipo_material_origen = [SEMILLA, ESQUEJE]`
- `unidad_medida = [UNIDAD, G]`
- `tipo_historial_recoleccion = [BORRADOR_CREADO, SOLICITUD_VALIDACION, VALIDACION_APROBADA, VALIDACION_RECHAZADA, BORRADOR_ELIMINADO]`
- `tipo_movimiento_recoleccion = [CONSUMO_A_VIVERO, DESECHO, CORRECCION, AJUSTE_MIGRACION]`

Nota operativa del MVP:

- Se usan activamente `CONSUMO_A_VIVERO` y `DESECHO`.
- `CORRECCION` y `AJUSTE_MIGRACION` quedan fuera del flujo operativo normal del MVP.

## 7. Endpoints o acciones principales

Si la API todavía no está cerrada, estas son las **acciones mínimas** que el módulo debe soportar:

- Crear borrador.
- Editar borrador.
- Eliminar borrador con soft delete.
- Consultar detalle de recolección.
- Listar recolecciones por estado.
- Solicitar validación.
- Aprobar validación.
- Rechazar validación.
- Registrar desecho.
- Consultar historial del registro.
- Consultar movimientos de saldo.

## 8. Lectura rápida del historial

Para operación diaria, el timeline mínimo se interpreta así:

- `RECOLECCION.created_at`: se creó el borrador.
- `RECOLECCION_HISTORIAL`: cambios de estado del registro.
- `RECOLECCION.*_snapshot`: identidad oficial congelada al momento de aprobar la validación.
- `RECOLECCION.fecha_validacion`: momento materializado de aprobación.
- `RECOLECCION_MOVIMIENTO.created_at`: consumos y desechos.
