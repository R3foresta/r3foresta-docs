# Reglas de Negocio (RN) - Modulo Plantacion (M3)

## 1. Proposito

Estas reglas cubren el comportamiento propio del Modulo 3 (Plantacion): ciclo de vida de campaña y subcampaña, planificacion por especie, coordinacion como membresia, registro de plantacion, mortandad, reposicion, geolocalizacion y transparencia publica.

El contrato de integracion entre Vivero (M2) y Plantacion (M3) — asignaciones fisicas a subcampania, devoluciones fisicas, consumo de stock asignado y saldos derivados — **no se duplica aqui**. Su fuente canonica es [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md), donde viven `RN-VIV-47` a `RN-VIV-61`. Este documento referencia ese contrato cuando aplica, no lo copia.

Fuente de estas reglas: `02_Procesos_Modulo_3_Plantacion.md` y `00_Requerimientos_Modulo_3_Plantacion.json` (`RF-PLA-*`) de este modulo, y `database/00_database_schema.md`.

---

## 2. Definiciones base

* **Campaña:** contenedor estrategico. No tiene poligono ni meta operativa propia persistida; su estado no se persiste. Expone un total de meta **derivado** para planeacion (`RN-PLA-36`).
* **Subcampaña:** unidad operativa real: coordinador, equipo, poligono, meta total y plan por especie.
* **Asignacion fisica:** entrega real de plantas desde Vivero a una subcampaña. Crea stock de consumo para M3 y descuenta el saldo vivo del lote en Vivero (contrato M2↔M3, ver `RN-VIV-47`).
* **Stock de consumo de subcampaña:** saldo disponible de una asignacion (`saldo_asignado_disponible`) contra el que se validan plantaciones y reposiciones.
* **Despacho por asignacion:** evento de salida en `EVENTO_LOTE_VIVERO` que ocurre al crear la asignacion fisica, no al registrar la plantacion (ver `RN-VIV-52`).

---

## 3. Reglas de campaña y estado derivado

### RN-PLA-01 - La campaña no tiene estado propio persistido

El estado de `CAMPANIA` (`BORRADOR | ACTIVA | EN_MANTENIMIENTO | MONITOREO_HISTORICO`) se calcula en tiempo real desde el conjunto de sus subcampañas. Ninguna implementacion debe materializarlo como columna.

### RN-PLA-02 - Regla de derivacion del estado de campaña

El estado se deriva asi: `BORRADOR` si todas las subcampañas estan en `BORRADOR`; `ACTIVA` si al menos una subcampaña esta `ACTIVA`; `EN_MANTENIMIENTO` si todas estan cerradas (`COMPLETADA` o `FINALIZADA_PARCIAL`) y al menos una en fase `MANTENIMIENTO_ACTIVO`; `MONITOREO_HISTORICO` si todas estan en fase `MONITOREO_HISTORICO`. La fuente unica de verdad es la subcampaña.

### RN-PLA-03 - Tipo de campaña heredado e inmutable

`CAMPANIA.tipo` (`REFORESTACION | ARBORIZACION | FORESTACION`, enum `tipo_subcampania` reutilizado) es obligatorio al crear la campaña y define el tipo de toda subcampaña hija. `SUBCAMPANIA.tipo` debe ser identico (CHECK constraint en BD). En MVP, el tipo ya no se modifica una vez que existe cualquier subcampaña asociada (`RN-PLA-38`), porque cambiarlo exigiria actualizar hijas en cascada. Para operar con otro tipo se crea una campaña separada. No mezclar tipos dentro de una misma campaña.

### RN-PLA-04 - Una campaña no tiene "fases" ni "campañas hijas"

Si se quiere ampliar el proyecto, se crea una nueva subcampaña dentro de la misma campaña. No existe el concepto de fases ni de campañas hijas.

### RN-PLA-05 - Organizaciones asociadas a campaña

Una campaña puede tener 1 o mas organizaciones asociadas (relacion N:M via `CAMPANIA_ORGANIZACION`). `ORGANIZACION` es tabla maestra real del Modulo General (`RF-GEN-07`), no texto libre ni catalogo embebido en Plantacion. Ver `RN-GEN-27..29` para el comportamiento de la entidad maestra.

### RN-PLA-36 - Meta agregada de campaña (derivada, no persistida) — añadida 2026-07-01

La campaña sigue **sin meta propia persistida** (`RN-PLA-01`); no se agrega ninguna columna de meta a `CAMPANIA`. Para planificacion se expone un total **derivado**:

```text
meta_planificada_campania = SUM(SUBCAMPANIA.meta_total_arboles WHERE estado <> CANCELADA)
```

Incluye las subcampañas en `BORRADOR` — el sentido es que el admin planifique cuantos arboles debe conseguir y asignar antes de activar — y excluye las `CANCELADA` (cuya meta deja de contar, `RN-PLA-37`). Es una lectura de planificacion de uso interno (admin/coordinador). La **vista publica** sigue agregando unicamente subcampañas `ACTIVA`, `COMPLETADA` y `FINALIZADA_PARCIAL` (`RN-PLA-34`), nunca borradores. Como el estado derivado de campaña (`RN-PLA-01/02`), se calcula al leer y **nunca se materializa como columna**.

### RN-PLA-38 - Edicion basica y desactivacion de campaña en MVP — añadida 2026-07-03, ajustada 2026-07-23

En el MVP, `CAMPANIA` admite correcciones basicas sin romper trazabilidad:

- `nombre`, `descripcion`, `fecha_estimada_inicio` y `fecha_estimada_fin` pueden editarse como datos generales/referenciales.
- `CAMPANIA_ORGANIZACION` puede editarse. Las subcampañas ya activadas conservan sus `nombres_organizaciones_snapshot`; los cambios solo afectan la campaña y futuras activaciones.
- `tipo` solo puede editarse mientras no exista ninguna `SUBCAMPANIA` asociada.
- `codigo_trazabilidad` no se edita.

La desactivacion estricta de campaña se permite si no tiene subcampañas vivas, o si todas las subcampañas vivas ya estan en `CANCELADA`. Esta operacion aplica `deleted_at`/`deleted_by` a la campaña y no cancela subcampañas implicitamente.

Existe ademas una accion explicita de **desactivacion con cancelacion masiva** para `ADMIN`. Antes de confirmar muestra una previsualizacion de elegibilidad y efectos. Al ejecutar, bloquea la campaña y sus subcampañas vivas, repite las validaciones y, en una unica transaccion por campaña:

1. admite subcampañas `BORRADOR` o `ACTIVA` solo cuando `total_plantado_inicial = 0`, y `CANCELADA` como postcondicion ya satisfecha;
2. cancela cada `BORRADOR`/`ACTIVA` mediante la semantica canonica de `RN-PLA-37`, incluida la devolucion fisica de asignaciones de `RN-VIV-48`;
3. registra el origen `DESACTIVACION_CAMPANIA` en el historial de cada subcampaña procesada;
4. aplica soft-delete a la campaña.

Una subcampaña con plantaciones o en `COMPLETADA`, `FINALIZADA_PARCIAL` o `PAUSADA` bloquea toda la operacion. Si una sola validacion o devolucion falla, se revierte la campaña completa. Una campaña sin subcampañas vivas sigue siendo elegible. La operacion atomica abarca una sola campaña; una seleccion de varias campañas se procesa de forma independiente.

El borrado fisico (`DELETE`) solo se permite cuando no existe ninguna subcampaña asociada. La accion estricta y la accion masiva son contratos separados y explicitos.

Campos tecnicos o de auditoria (`updated_at`, `updated_by`, `metadata_blockchain`, cuando aplique) pueden seguir actualizandose por procesos internos. La edicion flexible de `tipo` con subcampañas en `BORRADOR` queda fuera del MVP y se registra en `post-mvp/03-plantacion.md`.

---

## 4. Reglas de subcampaña: estados y transiciones

### RN-PLA-06 - Estados operativos y transiciones permitidas en MVP

Estados: `BORRADOR`, `ACTIVA`, `COMPLETADA`, `FINALIZADA_PARCIAL`, `CANCELADA`. Reservado sin flujo en MVP: `PAUSADA`. Transiciones permitidas: `BORRADOR → ACTIVA` (al activar), `ACTIVA → COMPLETADA` (automatico al alcanzar meta), `ACTIVA → FINALIZADA_PARCIAL` (manual por ADMIN, con motivo obligatorio), y `BORRADOR → CANCELADA` / `ACTIVA → CANCELADA` (cancelacion, solo si no hay ninguna `PLANTACION_INICIAL` registrada; ver `RN-PLA-37`).

### RN-PLA-07 - No hay reapertura de subcampaña

Si una subcampaña queda `FINALIZADA_PARCIAL` y aparece stock nuevo despues, se crea una nueva subcampaña dentro de la misma campaña; la subcampaña cerrada no se reabre.

### RN-PLA-08 - Validaciones para activar

Para pasar de `BORRADOR` a `ACTIVA` se exige: poligono presente, coordinador asignado (`SUBCAMPANIA_EQUIPO` con `rol_en_subcampania = COORDINADOR`), meta total > 0, y plan de metas por especie completo (al menos una especie, suma de porcentajes = 100, suma de cantidades = meta total).

### RN-PLA-09 - Activacion con stock parcial permitida

Una subcampaña puede activarse sin tener el 100% del stock asignado. El sistema debe mostrar advertencia visual con cobertura total y por especie, y permitir ampliar asignaciones en cualquier momento durante `ACTIVA`.

### RN-PLA-10 - Cierre automatico a COMPLETADA

Cuando `SUM(PLANTACION_INICIAL.cantidad_total) >= meta_total`, la subcampaña pasa automaticamente a `COMPLETADA`: se congela `fecha_cierre_operativo = NOW()`, se calcula `fecha_fin_mantenimiento = fecha_cierre_operativo + 3 años`, y se registra `SUBCAMPANIA_COMPLETADA` en `SUBCAMPANIA_HISTORIAL`. Deja de aceptar `PLANTACION_INICIAL`; sigue aceptando mortandad, reposicion y asignaciones con proposito `REPOSICION`.

### RN-PLA-11 - Cierre manual a FINALIZADA_PARCIAL

Solo `ADMIN` puede cerrar manualmente una subcampaña `ACTIVA` a `FINALIZADA_PARCIAL`, con `motivo_cierre_parcial` obligatorio (catalogo cerrado + `OTRO`). Se congela `fecha_cierre_operativo` y se calcula `fecha_fin_mantenimiento` igual que en cierre automatico. Comportamiento posterior identico a `COMPLETADA`.

### RN-PLA-12 - Mantenimiento es transversal a los estados posteriores a BORRADOR

Mortandad y reposicion se aceptan en `ACTIVA`, `COMPLETADA` y `FINALIZADA_PARCIAL`. Plantacion inicial y asignaciones nuevas con cualquier proposito solo en `ACTIVA`; en `COMPLETADA` y `FINALIZADA_PARCIAL` solo se aceptan asignaciones con proposito `REPOSICION`.

### RN-PLA-37 - Cancelacion de subcampaña sin plantaciones — añadida 2026-07-01

Una subcampaña se cancela (`estado = CANCELADA`) **solo si no tiene ninguna `PLANTACION_INICIAL` registrada** (`total_plantado_inicial = 0`). Aplica al caso normal de descartar un `BORRADOR` de planificacion, y tambien a una subcampaña `ACTIVA` que aun no haya plantado nada. Un `BORRADOR` puede cancelarse aunque `poligono_geom` sea `NULL`: el poligono es requisito para activar, no para cancelar, y la cancelacion no inventa ni modifica geometria. Si ya existe al menos una plantacion inicial, la subcampaña **no puede cancelarse**: el cierre anticipado correcto es `FINALIZADA_PARCIAL` (`RN-PLA-11`), que preserva lo ya plantado como valido. Solo `ADMIN` puede cancelar, con motivo obligatorio.

Efectos:

* La subcampaña pasa a `CANCELADA`; el registro **se conserva** (inactivacion, no borrado fisico) y se registra `SUBCAMPANIA_CANCELADA` en `SUBCAMPANIA_HISTORIAL`.
* Su `meta_total_arboles` deja de sumar a la meta agregada de la campaña (`RN-PLA-36`).
* Toda asignacion activa de la subcampaña debe resolverse antes o durante la cancelacion: si las plantas ya fueron entregadas fisicamente, se registran como devolucion fisica al vivero; si no se entregaron por un flujo legado, se migran/corrigen antes de cerrar. En el contrato vigente la devolucion fisica aumenta `LOTE_VIVERO.saldo_vivo_actual` y registra `DEVOLUCION_A_VIVERO` en M3 (`RN-VIV-48`).
* Una subcampaña `CANCELADA` no es publica (`RN-PLA-34`) y no se reabre (`RN-PLA-07`); para retomar el trabajo se crea una subcampaña nueva.
* La cancelacion puede originarse en la accion individual de subcampaña o en la desactivacion atomica de su campaña (`RN-PLA-38`). En el segundo caso el historial identifica `origen = DESACTIVACION_CAMPANIA` y la campaña responsable.

`PAUSADA` sigue reservado, sin flujo en MVP.

---

## 5. Reglas de fase de mantenimiento (derivada por fecha)

### RN-PLA-13 - Fase de mantenimiento independiente del estado operativo

`fase_mantenimiento_subcampania` (`NO_APLICA | MANTENIMIENTO_ACTIVO | MONITOREO_HISTORICO`) se calcula automaticamente por tiempo, independiente del estado operativo. `NO_APLICA` mientras la subcampaña esta en `BORRADOR` o `ACTIVA`; `MANTENIMIENTO_ACTIVO` desde el cierre hasta 3 años despues; `MONITOREO_HISTORICO` desde 3 años despues del cierre. La ventana de 3 años es configurable a nivel sistema.

### RN-PLA-14 - Transicion automatica a MONITOREO_HISTORICO

Cuando `today >= fecha_fin_mantenimiento`, la subcampaña transita automaticamente de `MANTENIMIENTO_ACTIVO` a `MONITOREO_HISTORICO`. No cambia el estado operativo. Se registra `TRANSICION_A_MONITOREO_HISTORICO` en `SUBCAMPANIA_HISTORIAL`. Se sigue aceptando mortandad y reposicion, aunque el sistema ya no las espera activamente ni genera alertas.

---

## 6. Reglas de plan de metas por especie

### RN-PLA-15 - El plan de especies vive en SUBCAMPANIA_META_ESPECIE

La meta de una subcampaña se descompone por especie en `SUBCAMPANIA_META_ESPECIE` (`planta_id`, `porcentaje_objetivo`, `cantidad_objetivo`), independiente de la asignacion fisica de lotes de vivero.

### RN-PLA-16 - Consistencia del plan al activar

Cada `planta_id` aparece una sola vez por subcampaña. Al activar: `SUM(porcentaje_objetivo) = 100` y `SUM(cantidad_objetivo) = SUBCAMPANIA.meta_total_arboles`.

### RN-PLA-17 - Edicion del plan segun estado

En `BORRADOR` el plan se edita libremente. Con la subcampaña `ACTIVA`, ninguna `cantidad_objetivo` puede quedar por debajo de lo ya plantado inicialmente para esa especie. En `COMPLETADA` o `FINALIZADA_PARCIAL` el plan queda congelado.

### RN-PLA-18 - Tope de plantacion inicial por especie

Una `PLANTACION_INICIAL` solo puede registrar especies incluidas en el plan, y no puede hacer que el acumulado plantado de esa especie (`plantado_inicial_especie`) supere su `cantidad_objetivo`.

### RN-PLA-19 - Reposicion no participa del plan por especie

Las reposiciones no avanzan la meta y mantienen la politica de especie libre ya fijada en `RN-VIV-60` (no se exige que la especie repuesta coincida con la del grupo origen). La vista publica muestra por separado el cumplimiento de la meta inicial por especie y la composicion viva actual tras mortandad/reposiciones.

---

## 7. Reglas de coordinacion y equipo

### RN-PLA-20 - Coordinador es membresia, no rol global

El catalogo cerrado de `rol_usuario` (`ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`) se mantiene sin cambios. La coordinacion vive en `SUBCAMPANIA_EQUIPO.rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`. Ningun diseño de esquema debe introducir un FK directo `coordinador_id` en `SUBCAMPANIA`.

### RN-PLA-21 - Exactamente un coordinador por subcampaña

Una subcampaña tiene exactamente un `COORDINADOR` (constraint partial unique en BD sobre `(subcampania_id) where rol_en_subcampania = 'COORDINADOR'`). Un usuario puede ser `COORDINADOR` de N subcampañas y simultaneamente `OPERARIO` en otras.

### RN-PLA-22 - Responsable y co-responsables deben ser parte del equipo

Al registrar una plantacion, el `responsable_id` debe pertenecer a `SUBCAMPANIA_EQUIPO` de la subcampaña (COORDINADOR u OPERARIO). Los co-responsables deben ser un subconjunto de `SUBCAMPANIA_EQUIPO`. No hay porcentaje de participacion entre miembros; todos los co-responsables se tratan por igual.

---

## 8. Reglas de registro de plantacion inicial

### RN-PLA-23 - Consumo de stock asignado por especie/lote

Al registrar una plantacion, el sistema solo permite consumir plantas desde asignaciones fisicas activas de la misma subcampaña. La UI puede mostrar la seleccion agrupada por especie para simplificar el flujo; el backend debe persistir el detalle real por asignacion/lote en `REGISTRO_PLANTACION_DETALLE`.

Para el MVP se permite que el backend consuma automaticamente desde las asignaciones disponibles de una misma especie con orden estable y documentado (por ejemplo, asignacion mas antigua primero), siempre que guarde el detalle exacto por `asignacion_id`, `lote_vivero_id`, `planta_id` y cantidad. Si el producto decide exponer varios lotes al usuario, la seleccion manual sigue siendo valida.

### RN-PLA-24 - Validaciones para registrar PLANTACION_INICIAL

La subcampaña debe estar `ACTIVA`. Cada especie plantada debe existir en `SUBCAMPANIA_META_ESPECIE`. El acumulado por especie no puede superar su `cantidad_objetivo` (`RN-PLA-18`). Cada cantidad plantada debe consumir una asignacion activa con proposito `PLANTACION_INICIAL` de esa subcampaña, y la cantidad tomada no puede exceder `saldo_asignado_disponible`.

### RN-PLA-25 - Registro append-only con snapshots

`REGISTRO_PLANTACION` es append-only: no se permite edicion posterior en el MVP. Al registrar se congelan `nombre_subcampania_snapshot`, `nombre_responsable_snapshot` y, por cada especie, los snapshots heredados del lote de vivero (cientifico, comercial, variedad). Al activar la subcampaña ya se congelaron `nombre_zona_snapshot`, `nombre_coordinador_snapshot` y `nombres_organizaciones_snapshot`.

### RN-PLA-26 - Plantar no genera despacho automatico en M2

Cada `PLANTACION_INICIAL` y `REPOSICION` consume stock ya asignado fisicamente a la subcampaña. No genera `DESPACHO` en `EVENTO_LOTE_VIVERO` y no usa `origen_despacho = AUTOMATICO_PLANTACION`. El descuento de `LOTE_VIVERO.saldo_vivo_actual` ya ocurrio al crear la asignacion fisica a subcampaña. El contrato completo vive en `RN-VIV-47..61` en [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md).

---

## 9. Reglas de mortandad y reposicion

### RN-PLA-27 - Quien puede reportar mortandad

Cualquier `OPERARIO` u `COORDINADOR` miembro de `SUBCAMPANIA_EQUIPO` de la subcampaña, o `ADMIN`, puede reportar mortandad. No hay diferencias de permisos entre ellos para este evento.

### RN-PLA-28 - Mortandad es delta sobre el grupo, con evidencia obligatoria

`MORTANDAD_REPORTADA` exige `registro_plantacion_id`, `cantidad_muerta_delta > 0`, causa del catalogo `causa_mortandad_plantacion` (incluye `OTRO`), y minimo 1 foto con GPS. Debe cumplirse `cantidad_muerta_acumulada + delta <= plantado_inicial + reposiciones_acumuladas` del grupo. Permitido en estados `ACTIVA`, `COMPLETADA`, `FINALIZADA_PARCIAL`, y en ambas fases de mantenimiento. El evento es append-only; no hay correccion de mortandad en el MVP.

### RN-PLA-29 - Reposicion vinculada al grupo origen

Una `REPOSICION` requiere `registro_plantacion_origen_id` con mortandad previamente reportada, consume exclusivamente asignaciones fisicas con proposito `REPOSICION`, y no avanza la meta de la subcampaña (`es_reposicion = true`).

### RN-PLA-30 - Bloqueo por exceso sobre pendiente de reposicion

Antes de confirmar, el sistema muestra `cantidad_plantada_inicial`, `cantidad_muerta_acumulada`, `cantidad_repuesta_acumulada` y `cantidad_pendiente_reposicion = muerta - repuesta`. Si la cantidad ingresada excede `cantidad_pendiente_reposicion`, el sistema bloquea el registro (no es advertencia opcional).

### RN-PLA-31 - Saldo vivo del grupo

`saldo_vivo_grupo = cantidad_plantada_inicial + reposiciones_acumuladas − mortandad_acumulada`. Nunca puede ser negativo. Es la metrica base para la captura de carbono.

---

## 10. Reglas de geolocalizacion

### RN-PLA-32 - PostGIS es la autoridad para validar GPS

La funcion `gps_dentro_poligono_con_tolerancia(subcampania_id, lat, lng)` es la fuente de verdad para validar que un punto GPS de plantacion, reposicion o mortandad este dentro del poligono de la subcampaña, con tolerancia configurable (default sugerido 50 m). Fuera de tolerancia, se bloquea el registro. Turf.js u otro chequeo de frontend es opcional y solo sirve para feedback de UX, nunca como autoridad de validacion.

### RN-PLA-33 - Poligono obligatorio para activar; area es referencial

El poligono de la subcampaña es obligatorio para pasar a `ACTIVA`. El area en hectareas se calcula automaticamente desde el poligono; no se ingresa manualmente.

---

## 11. Reglas de vista publica y roles

### RN-PLA-34 - Transparencia publica sin autenticacion

Toda la informacion de subcampañas `ACTIVA`, `COMPLETADA` y `FINALIZADA_PARCIAL` es publica sin autenticacion (mapa, totalizadores, detalle de campaña/subcampaña, drill-down a M2 y M1). Las subcampañas en `BORRADOR` no son publicas.

### RN-PLA-35 - Roles del MVP sin rol global nuevo

El catalogo cerrado de roles globales (`ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`) no se altera. `ADMIN` crea campañas y subcampañas, asigna coordinador inicial, cierra manualmente y gestiona organizaciones. `GENERAL` registra plantaciones, reposiciones y mortandad en las subcampañas donde es miembro del equipo. `VALIDADOR` no tiene flujo especial propio en MVP. `VOLUNTARIO` no puede ser miembro de `SUBCAMPANIA_EQUIPO` ni registrar eventos en este modulo.

---

## 12. Referencia al contrato M2 ↔ M3

Las reglas del contrato de integracion entre Vivero y Plantacion (asignacion fisica como stock consumible de subcampaña, `cantidad_asignada` inmutable, devolucion fisica, no uso de `AUTOMATICO_PLANTACION`, especie libre en reposicion y saldos derivados) viven exclusivamente en [`../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`](../90-contratos-integracion/02_contrato_vivero_a_plantacion.md). Este documento no las duplica; las reglas de esta seccion (`RN-PLA-*`) solo cubren el comportamiento propio de M3.
