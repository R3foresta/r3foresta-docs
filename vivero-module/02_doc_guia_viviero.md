# Procesos — Módulo 2: Vivero — Guía operativa MVP

# Módulo 2 — Vivero (maduración y trazabilidad pre-plantación)

## 1. Propósito

El **Módulo 2 (Vivero)** registra la maduración y preparación pre-plantación del material biológico que proviene del **Módulo 1 (Recolección)**.

Su objetivo en el MVP es dejar evidencia verificable de:

* qué lote origen (recolección) alimentó al lote de vivero,
* qué planta o especie se está trabajando,
* cuánto material se consumió desde Recolección,
* cuánto material entró en proceso en vivero,
* cuándo nacen las plantas vivas como saldo operativo,
* qué eventos ocurren durante el ciclo,
* qué mermas y despachos se registran,
* qué evidencia acompaña cada evento,
* y cómo se cierra el lote cuando el saldo vivo llega a cero.

Este módulo no demuestra por sí solo captura de carbono, pero sí sostiene una parte crítica de la historia auditable: la **cadena de custodia y supervivencia operativa pre-plantación**.

---

## 2. Conceptos clave

### 2.1. Origen único y trazabilidad fuerte

* Un **lote de vivero** se crea usando material biológico proveniente de **un solo lote origen** del Módulo 1.
* **No se permite mezclar** varios lotes origen en un mismo lote de vivero.
* Un mismo lote origen **sí puede alimentar varios lotes de vivero**, siempre que cada consumo quede registrado individualmente y el saldo de Recolección se recalcule correctamente.

Esto mantiene trazabilidad fuerte: cada merma, despacho o cierre del vivero siempre puede atribuirse a un origen único.

### 2.2. Elegibilidad del lote origen

Solo se puede iniciar un lote de vivero desde una recolección que esté:

* con `estado_registro = VALIDADO`,
* operativamente habilitada para consumo,
* con `estado_recoleccion` no incompatible con consumo,
* con saldo suficiente para el consumo,
* y con identidad de planta disponible para heredar.

En la documentación previa de Recolección esto equivale al concepto operativo de registro "abierto": todavía existe saldo disponible para consumir.

### 2.3. Identidad de planta heredada desde Módulo 1

Al crear el lote de vivero se debe **heredar y congelar (snapshot)** la identidad de la planta relacionada al lote origen, incluyendo como mínimo:

* `planta_id`
* `nombre_cientifico_snapshot`
* `nombre_comercial_snapshot`
* `tipo_material_snapshot`
* `variedad_snapshot`
* `nombre_comunidad_origen_snapshot`
* `nombre_responsable_snapshot`

Esto evita que cambios futuros en catálogos alteren la trazabilidad histórica del lote.

El `vivero_id` del lote no se hereda desde la recolección. Se selecciona en el inicio del lote según el vivero operativo donde se gestionará ese material.

El `codigo_trazabilidad` del lote de vivero es propio y concatena el código del origen:

`VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`

### 2.4. Doble lectura del inicio

En `INICIO` conviven dos lecturas distintas, pero alineadas:

1. **Cantidad consumida del origen**
   Es la cantidad que se descuenta del Módulo 1 usando la **unidad canónica del lote origen**. En persistencia solo puede ser `G` o `UNIDAD`.

2. **Cantidad inicial en proceso**
   Es la cantidad con la que el vivero arranca su seguimiento operativo antes de contar plantas vivas.

En el MVP:

* `cantidad_inicial_en_proceso` usa la **misma unidad** del lote origen,
* y se registra como reflejo del consumo realizado al inicio.

Todavía no hablamos de plantas vivas. Eso empieza recién en `EMBOLSADO`.

### 2.5. Convención oficial de unidades

La convención oficial del sistema en base de datos, backend, frontend y documentación es:

* `ENUM(unidad_medida) = [UNIDAD, G]`
* no se deben mezclar `G` y `GR`

Entrada permitida desde frontend:

* `kg`
* `g`
* `unidad`

Normalización backend:

* `kg -> G`
* `g -> G`
* `unidad -> UNIDAD`

Reglas numéricas:

* `G` permite decimales
* `UNIDAD` no permite decimales
* `kg` no se persiste
* no se aceptan otras unidades en el MVP

### 2.6. Inicio no equivale a plantas vivas

* En `INICIO` se registra material en proceso.
* En `INICIO` **no existe saldo vivo** todavía.
* `saldo_vivo_antes` y `saldo_vivo_despues` quedan en `null` para este evento.

`INICIO` crea el lote, crea el evento, registra evidencia y descuenta origen; todavía no crea saldo vivo.

### 2.7. Material en proceso no es igual a plantas vivas

**Material en proceso**

* se usa en `INICIO`
* puede estar en `G` o `UNIDAD`
* representa material consumido desde Recolección
* no representa todavía plantas vivas

**Plantas vivas**

* nacen en `EMBOLSADO`
* se expresan siempre en `UNIDAD`
* representan conteo biológico observado
* no son una conversión automática matemática del material en proceso

Regla clave:

El sistema no convierte automáticamente gramos en plantas vivas. `EMBOLSADO` registra un nuevo dato observado del proceso: cuántas plantas vivas resultaron del material que entró al lote.

### 2.8. Embolsado crea el saldo vivo

El evento `EMBOLSADO` marca el momento en que la plántula o esqueje ya puede contarse como **planta viva**.

Desde ese momento:

* nace `plantas_vivas_iniciales`,
* nace `saldo_vivo_actual`,
* y todo evento posterior que opera sobre saldo vivo se expresa en **UNIDAD**.

### 2.9. Estados del MVP

Para el MVP:

* **Estado del lote:** `ACTIVO | FINALIZADO`

El carácter definitivo del evento se resuelve con el modelo **append-only** y con la inmutabilidad práctica del registro una vez insertado.

### 2.10. Evidencia de trazabilidad

La evidencia se modela mediante la entidad **`evidencia_trazabilidad`**, que puede almacenar:

* imágenes,
* documentos,
* metadatos,
* referencias técnicas,
* y otros soportes auditables.

En el MVP, la evidencia debe quedar **vinculada directamente al evento que la origina** usando el modelo polimórfico de `EVIDENCIAS_TRAZABILIDAD`:

* `tipo_entidad_id` identifica que la evidencia pertenece a un evento de vivero,
* y `entidad_id` apunta al `EVENTO_LOTE_VIVERO.id` correspondiente.

### 2.11. Motivo de cierre del lote

Cuando un lote llega a estado `FINALIZADO`, debe diferenciarse **por qué** se cerró usando `motivo_cierre`:

* `DESPACHO_TOTAL`
* `PERDIDA_TOTAL`
* `MIXTO`

---

## 3. Flujo del proceso (MVP)

El flujo mínimo del MVP se basa en **dos hitos estructurales obligatorios**, **dos eventos operativos principales**, un evento opcional de seguimiento y un cierre automático.

### Hitos estructurales obligatorios

1. `INICIO`
2. `EMBOLSADO`

### Eventos operativos principales

* `MERMA`
* `DESPACHO`

### Evento opcional de seguimiento

* `ADAPTABILIDAD` con subetapas `SOMBRA`, `MEDIA_SOMBRA` y `SOL_DIRECTO`

### Evento automático

* `CIERRE_AUTOMATICO`

### Secuencia mínima del MVP

`recolección origen -> consumo a vivero -> inicio -> embolsado -> adaptabilidad (opcional) -> merma(s) y/o despacho(s) -> cierre automático`

Reglas de secuencia:

* No se permite `EMBOLSADO` sin `INICIO` previo.
* No se permite `MERMA` sin `EMBOLSADO` previo.
* No se permite `DESPACHO` sin `EMBOLSADO` previo.
* No se permite `ADAPTABILIDAD` sin `EMBOLSADO` previo.
* `ADAPTABILIDAD` **no es requisito** para registrar `MERMA` ni `DESPACHO`.
* Un lote **puede finalizar sin despacho** si todo su saldo vivo se pierde por mermas.

---

## 4. Descripción de eventos del MVP

## 4.1. Inicio

Registro del arranque del lote según el material:

* **Semilla** -> germinación / semillero
* **Esqueje** -> inicio de enraizamiento o proceso equivalente

Datos mínimos esperados:

* `recoleccion_id`
* `fecha_inicio` en `LOTE_VIVERO`
* `fecha_evento` del `EVENTO_LOTE_VIVERO` tipo `INICIO`
* `responsable_id`
* `vivero_id` seleccionado para este lote
* `codigo_trazabilidad` con formato `VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`
* `cantidad_inicial_en_proceso`
* `unidad_medida_inicial`
* `cantidad_afectada` del evento `INICIO`
* `unidad_medida_evento` del evento `INICIO`
* snapshots de planta (`planta_id`, nombre científico, nombre comercial, tipo de material)
* `observaciones` si aplica
* al menos una `evidencia_trazabilidad` válida, mínimo 1 foto

Reglas importantes:

* El lote origen debe estar `VALIDADO`, habilitado para consumo y con saldo suficiente.
* La creación del lote en Módulo 2 y el descuento del saldo en Módulo 1 ocurren en **una misma transacción atómica**.
* El `vivero_id` del lote se selecciona en Vivero y no se hereda automáticamente desde `RECOLECCION.vivero_id`.
* En el MVP, `cantidad_inicial_en_proceso` usa la misma unidad del origen y se materializa en `LOTE_VIVERO.unidad_medida_inicial`.
* En el MVP, `cantidad_inicial_en_proceso` refleja la cantidad efectivamente consumida del origen.
* El consumo del origen queda reflejado en `RECOLECCION_MOVIMIENTO` con `tipo_movimiento = CONSUMO_A_VIVERO`.
* El evento `INICIO` queda persistido como un registro append-only en `EVENTO_LOTE_VIVERO`.
* No se permite edición posterior del evento.

Invariantes obligatorias entre Módulo 1 y Módulo 2:

* `abs(RECOLECCION_MOVIMIENTO.delta) = LOTE_VIVERO.cantidad_inicial_en_proceso`
* `LOTE_VIVERO.cantidad_inicial_en_proceso = EVENTO_LOTE_VIVERO.cantidad_afectada`
* `RECOLECCION_MOVIMIENTO.unidad_medida_movimiento = LOTE_VIVERO.unidad_medida_inicial`
* `LOTE_VIVERO.unidad_medida_inicial = EVENTO_LOTE_VIVERO.unidad_medida_evento`

Restricciones:

* No se puede consumir más de lo disponible en la recolección.
* La unidad del movimiento debe coincidir con la unidad canónica de la recolección.
* La unidad de `INICIO` debe coincidir con la del movimiento de consumo.
* `CONSUMO_A_VIVERO` usa `delta` negativo.

Aclaraciones:

* `plantas_vivas_iniciales = null`
* `saldo_vivo_actual = null`
* `saldo_vivo_antes = null`
* `saldo_vivo_despues = null`

## 4.2. Embolsado

El **Embolsado** marca el punto en el que la plántula o el esqueje ya pueden contarse como plantas vivas y empieza el seguimiento del **saldo vivo**.

Desde este punto se registra:

* `plantas_vivas_iniciales`
* `saldo_vivo_antes = null`
* `saldo_vivo_despues = plantas_vivas_iniciales`
* `cantidad_afectada = plantas_vivas_iniciales`
* `unidad_medida_evento = UNIDAD`
* `observaciones`
* al menos una `evidencia_trazabilidad` válida

Reglas importantes:

* El evento `EMBOLSADO` solo puede registrarse **una vez por lote**.
* El saldo vivo nace en este evento.
* `plantas_vivas_iniciales` debe ser mayor a `0`.
* El saldo debe ser **calculado por el sistema**, no ingresado libremente por el usuario.
* Desde este evento todo saldo vivo se maneja en **UNIDAD**.
* `EMBOLSADO` no convierte matemáticamente gramos en plantas; registra un conteo observado del proceso.

## 4.3. Adaptabilidad

La **Adaptabilidad** representa el periodo en el que la planta se fortalece en ambientes controlados antes de plantarse. Se aplica al lote completo, no a plantas individuales ni a fracciones del lote.

En el MVP:

* se registra como evento operativo de seguimiento,
* puede ocurrir múltiples veces durante el ciclo del lote,
* incluye subetapas como `SOMBRA`, `MEDIA_SOMBRA` y `SOL_DIRECTO`,
* no exige permanencia mínima,
* no exige una secuencia rígida,
* y **no bloquea el despacho**.

Su objetivo en el MVP es aportar contexto operativo e historial sin volver compleja la lógica central del sistema.

Datos mínimos esperados:

* `fecha_evento`
* `subetapa_destino`
* `responsable_id`
* `observaciones` si aplica
* `evidencia_trazabilidad` opcional

Reglas importantes:

* No se permite `ADAPTABILIDAD` sin `EMBOLSADO` previo.
* La foto es opcional en `ADAPTABILIDAD`; sus subetapas pueden registrarse sin evidencia.
* No cambia el saldo vivo.
* Si el modelo de eventos guarda saldo, entonces `saldo_vivo_antes = saldo_vivo_despues = saldo_vivo_actual`.
* Si el modelo persiste `cantidad_afectada` para este evento, debe expresarse en `UNIDAD`.

## 4.4. Merma

La **Merma** representa pérdida explícita del saldo vivo por causas reales del proceso.

Cada merma registra:

* `cantidad_afectada`
* `unidad_medida_evento = UNIDAD`
* `causa_merma`
* `fecha_evento`
* `responsable_id`
* `saldo_vivo_antes`
* `saldo_vivo_despues`
* `observaciones`
* al menos una `evidencia_trazabilidad` válida

Reglas importantes:

* La merma siempre se expresa en **UNIDAD**.
* La causa se registra en `causa_merma_vivero`.
* La cantidad perdida no puede exceder el saldo vivo disponible.
* El saldo no puede quedar negativo.
* Si el saldo vivo llega a `0`, el lote debe cerrarse automáticamente.

## 4.5. Despacho

El **Despacho** representa la salida parcial o total de plantas listas para plantación o destino equivalente.

Cada despacho registra:

* `cantidad_afectada`
* `unidad_medida_evento = UNIDAD`
* `fecha_evento`
* `responsable_id`
* `destino_tipo` (`PLANTACION_PROPIA`, `PLANTACION_COMUNIDAD`, `DONACION`, `VENTA`, `OTRO`)
* `destino_referencia`
* `comunidad_destino_id` cuando aplique
* `saldo_vivo_antes`
* `saldo_vivo_despues`
* `observaciones`
* al menos una `evidencia_trazabilidad` válida

Reglas importantes:

* No se permite `DESPACHO` sin `EMBOLSADO` previo.
* La cantidad despachada no puede exceder el saldo vivo disponible.
* Puede haber múltiples despachos parciales.
* Si el saldo vivo llega a `0`, el lote debe cerrarse automáticamente.

## 4.6. Cierre automático

El **Cierre automático** se genera cuando el saldo vivo llega a `0`.

Este evento debe registrar:

* `fecha_evento`
* `motivo_cierre_calculado` en `EVENTO_LOTE_VIVERO`
* `motivo_cierre` en `LOTE_VIVERO`
* `ref_evento_trigger_id` apuntando al evento que dejó el saldo en cero

Reglas importantes:

* El lote pasa a estado `FINALIZADO`.
* Ya no se permiten nuevos eventos operativos normales.
* El `motivo_cierre` se calcula como:
  * `DESPACHO_TOTAL`
  * `PERDIDA_TOTAL`
  * `MIXTO`

---

## 5. Modelo de eventos

El sistema se basa en eventos **append-only**: se agregan al historial y no se reescriben ni se eliminan.

Tipos de evento del MVP:

* `INICIO`
* `EMBOLSADO`
* `ADAPTABILIDAD`
* `MERMA`
* `DESPACHO`
* `CIERRE_AUTOMATICO`

Fuera del MVP:

* correcciones auditadas,
* excepción de evidencia,
* evidencia tardía,
* traslados entre viveros,
* división o fusión de lotes,
* y sincronización offline-first.

Regla explícita del MVP:

* El borrador operativo previo al guardado definitivo puede ajustarse.
* Una vez registrado un evento, no hay correcciones en esta fase del producto.

---

## 6. Evidencia de trazabilidad en el MVP

En esta versión del MVP, la evidencia se maneja de forma **estricta**.

### 6.1. Regla general

Todo evento operativo del vivero que exige evidencia debe quedar respaldado por evidencia de trazabilidad vinculada directamente al evento.

En términos del esquema:

* la evidencia se guarda en `EVIDENCIAS_TRAZABILIDAD`,
* `tipo_entidad_id` clasifica la entidad,
* y `entidad_id` referencia el `EVENTO_LOTE_VIVERO.id`.

### 6.2. Eventos con evidencia obligatoria

En el MVP la evidencia es obligatoria para:

* `INICIO`
* `EMBOLSADO`
* `MERMA`
* `DESPACHO`

La evidencia mínima para esos eventos es 1 foto válida.

`ADAPTABILIDAD` puede tener evidencia, pero no es obligatoria. Sus subetapas (`SOMBRA`, `MEDIA_SOMBRA`, `SOL_DIRECTO`) pueden registrarse sin foto.

### 6.3. Reglas de operación

* Si un evento requiere evidencia y no tiene soporte válido, **no debe registrarse**.
* No se aceptan excepciones de evidencia para eventos obligatorios en el MVP.
* No se acepta evidencia tardía en el MVP para eventos que exigen evidencia.

---

## 7. Reglas temporales

Para reflejar la realidad operativa:

* `fecha_evento` puede registrarse hasta **10 días en el pasado**,
* `created_at` siempre registra la fecha y hora real del sistema,
* no se permiten fechas futuras,
* no se permiten eventos con fecha anterior al hito que habilita el proceso.

Idealmente, la ventana retroactiva debe ser configurable por el sistema.

---

## 8. Reglas de cantidades, saldo vivo y cierre

### 8.1. Conservación operativa del saldo vivo

Desde `EMBOLSADO`:

* `EMBOLSADO`: `saldo_vivo_despues = plantas_vivas_iniciales`
* `MERMA`: `saldo_vivo_despues = saldo_vivo_antes - cantidad_perdida`
* `DESPACHO`: `saldo_vivo_despues = saldo_vivo_antes - cantidad_despachada`

Reglas:

* el saldo no puede quedar negativo,
* las cantidades normales solo pueden mantener o disminuir el saldo,
* el saldo vivo **no aumenta** en el MVP,
* y los saldos deben ser calculados por el sistema.

### 8.2. Cierre automático del lote

El lote se finaliza automáticamente cuando el saldo vivo llega a **0**.

No basta marcar `FINALIZADO`; también debe calcularse `motivo_cierre`:

* **DESPACHO_TOTAL**: el lote llegó a 0 solo por despachos,
* **PERDIDA_TOTAL**: el lote llegó a 0 sin despachos, solo por pérdida,
* **MIXTO**: el lote llegó a 0 combinando mermas y despachos.

---

## 9. Consulta operativa y cadena de custodia

El módulo debe exponer una vista operativa que permita:

* listar lotes activos y finalizados,
* buscar por lote origen, lote de vivero, planta o especie, vivero y motivo de cierre,
* visualizar el historial del lote,
* y seguir la cadena completa:

`recolección origen -> consumo a vivero -> inicio -> embolsado -> adaptabilidad -> mermas -> despachos -> cierre`

Esta vista es crítica para operación diaria y para auditoría.

---

## 10. Estrategia blockchain del MVP

En el MVP, el historial operativo vive primero en base de datos.

La estrategia blockchain **no debe bloquear** el registro, consulta ni cierre confiable del lote.

Si se implementa anclaje blockchain en esta fase, solo el evento **`DESPACHO`** será candidato a anclaje.

En el esquema actual, ese anclaje vive como `metadata_blockchain` dentro de `EVENTO_LOTE_VIVERO` y puede incluir datos como `blockchain_url`, `token_id` y `transaction_hash`.

Este anclaje se considera complementario y no indispensable para el funcionamiento base del módulo.

Fuera del MVP puede ampliarse a otros hitos relevantes.

---

## 11. Roles mínimos del MVP

Para operar el módulo de vivero en el MVP deben mapearse los permisos sobre los roles reales del enum `rol_usuario`:

* `ADMIN`
* `GENERAL`
* `VALIDADOR`
* `VOLUNTARIO`

Alcance recomendado:

* `ADMIN`: parametriza, consulta y administra.
* `GENERAL`: registra eventos permitidos y consulta lotes. En la práctica reemplaza el rol funcional que antes se describía como "operador".
* `VALIDADOR`: existe como rol global de la plataforma, pero en este módulo no activa un flujo especial en el MVP.
* `VOLUNTARIO`: no debería tener permisos operativos críticos del módulo salvo parametrización explícita.

---

## 12. Alcance real del MVP

### Incluye

* origen único por lote de vivero,
* elegibilidad solo desde recolecciones `VALIDADO` y con saldo suficiente,
* consumo atómico Módulo 1 -> Módulo 2,
* herencia de planta o especie y snapshots,
* doble lectura del inicio en la misma unidad del origen,
* eventos append-only,
* estados simples de lote y evento,
* `EMBOLSADO` como nacimiento del saldo vivo,
* `ADAPTABILIDAD` como seguimiento operativo no bloqueante,
* `MERMA` con causa,
* `DESPACHO` parcial o total con destino estructurado,
* evidencia estricta por evento,
* cierre automático con motivo de cierre,
* historial visible,
* cadena de custodia,
* y anclaje blockchain mínimo opcional sobre despacho.

### Queda fuera por ahora

* correcciones posteriores por eventos compensatorios,
* reapertura de lotes,
* excepciones de evidencia,
* evidencia tardía,
* blockchain multi-hito,
* anclaje por cada evento,
* modelado agronómico detallado por especie,
* división y fusión de lotes,
* y flujos complejos offline-first.

---

## 13. Integración con Módulo 3 (Plantación)

> Esta sección resume el contrato Vivero ↔ Plantación. El documento operativo completo vive en [04_consumo_de_vivero.md](./04_consumo_de_vivero.md) y la especificación técnica detallada en [03_Addendum_Modulo_2_por_Modulo_3.md](./03_Addendum_Modulo_2_por_Modulo_3.md). Las reglas formales son `RN-VIV-47` a `RN-VIV-59`.

### 13.1. Cómo se consume el vivero

Un lote de vivero puede consumirse por cuatro caminos:

1. **Asignación** a una subcampaña — reserva lógica, sin evento en M2, sin tocar `saldo_vivo_actual`.
2. **Devolución** de saldo asignado — libera la reserva, sin evento en M2.
3. **Despacho automático** generado desde M3 al registrar una plantación o reposición — salida real, baja saldo.
4. **Despacho manual** hacia destinos fuera de subcampañas (donaciones, ventas, otros) — salida real, baja saldo.

### 13.2. Los tres saldos del lote

| Saldo | Origen | Significado |
|-------|--------|-------------|
| `saldo_vivo_actual` | Persistido en `LOTE_VIVERO` | Plantas físicamente vivas en el vivero |
| `saldo_asignado_total` | Derivado de asignaciones activas | Plantas reservadas por subcampañas, aún en el vivero |
| `saldo_vivo_disponible_asignacion` | Derivado: `vivo_actual − asignado_total` | Plantas libres para nuevas asignaciones o despachos manuales |

Identidad invariante: `saldo_vivo_actual = saldo_vivo_disponible_asignacion + saldo_asignado_total`.

### 13.3. Cambios de comportamiento respecto al MVP previo

Para el equipo de vivero, tres cambios prácticos:

- **El operario de vivero ya no puede despachar manualmente saldo reservado.** La validación cambia de `saldo_vivo_actual` a `saldo_vivo_disponible_asignacion`.
- **Aparecen despachos automáticos en el historial del lote.** Los genera el sistema, no el operario. Tienen badge `POR PLANTACIÓN` y enlazan a la subcampaña + registro de plantación.
- **Las mermas pueden afectar reservas activas** (política FIFO). Cuando ocurre, se notifica al coordinador de la subcampaña afectada.

### 13.4. Asignación con propósito

Toda asignación lleva un `proposito_asignacion`:

- `PLANTACION_INICIAL`: solo se consume en plantaciones iniciales (avanzan meta).
- `REPOSICION`: solo se consume en reposiciones (no avanzan meta).

Esta restricción se valida en el handler de M3 al consumir; no se cruza.

### 13.5. Diferencias entre despacho manual y automático

| Aspecto | `MANUAL` | `AUTOMATICO_PLANTACION` |
|---------|----------|--------------------------|
| Quién lo crea | Operario de vivero o ADMIN | Sistema, desde el handler de M3 |
| Evento que lo dispara | Despacho manual desde Vivero | `PLANTACION_INICIAL` o `REPOSICION` en M3 |
| `destino_tipo` permitido | Todo excepto `PLANTACION_CAMPANIA` | Solo `PLANTACION_CAMPANIA` |
| Evidencia | Propia obligatoria (mínimo 1 foto en M2) | Heredada del `REGISTRO_PLANTACION` (no requiere foto propia) |
| `subcampania_id` / `campania_id` / `registro_plantacion_id` | Todos `NULL` | Todos obligatorios |
| Validación de saldo | Contra `saldo_vivo_disponible_asignacion` | Contra `saldo_asignado_disponible` de la asignación específica |

### 13.6. Atomicidad del despacho automático

Un `REGISTRO_PLANTACION` puede tocar N lotes. En ese caso se generan N eventos `DESPACHO`, **todos en la misma transacción** que el registro de M3 + la actualización de las asignaciones. Si algo falla, todo se revierte.

### 13.7. Política FIFO de mermas

Cuando una `MERMA` en un lote excede su saldo no asignado, el excedente se distribuye sobre las asignaciones activas en orden **FIFO por `fecha_asignacion`**, aumentando `cantidad_mermada` de cada una. `cantidad_asignada` nunca se toca.

Cada afectación dispara una notificación al coordinador de la subcampaña dueña.

### 13.8. Estado actual de la integración

El esquema lógico está definido y documentado. La implementación física se está aplicando por tareas en [tareas/modulo-2-integracion-modulo-3/](../tareas/modulo-2-integracion-modulo-3/). Hasta que todas las tareas estén cerradas, partes del comportamiento descrito aquí pueden no estar activas en producción. Consultar el README de tareas para el estado actual.
