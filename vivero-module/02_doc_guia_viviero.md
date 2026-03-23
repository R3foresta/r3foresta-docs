# Procesos — Módulo 2: Vivero — Guía operativa MVP

# Módulo 2 — Vivero (maduración y trazabilidad pre-plantación)

## 1. Propósito

El **Módulo 2 (Vivero)** registra el proceso de maduración y preparación pre-plantación del material biológico proveniente del **Módulo 1 (Recolección)**.

Su propósito operativo y de trazabilidad en el MVP es dejar evidencia verificable de:

* qué lote origen alimentó al lote de vivero,
* qué planta o especie se está trabajando,
* cuánto material se consumió desde Recolección,
* cuántas unidades entran en proceso en vivero,
* cuándo nacen las plantas vivas como saldo operativo,
* qué eventos operativos ocurren durante el ciclo,
* qué mermas y despachos se registran,
* qué evidencia de trazabilidad acompaña cada evento,
* y cómo se cierra el lote cuando el saldo vivo llega a cero.

Este módulo no demuestra por sí solo captura de carbono, pero sí sostiene una parte crítica de la historia auditable: la **cadena de custodia y supervivencia operativa pre-plantación**.

---

## 2. Conceptos clave

### 2.1. Origen único y trazabilidad fuerte

* Un **lote de vivero** se crea usando material biológico proveniente de **un solo lote origen** del Módulo 1.
* **No se permite mezclar** varios lotes origen en un mismo lote de vivero.
* Un mismo lote origen **sí puede alimentar varios lotes de vivero**, siempre que cada consumo quede registrado individualmente y el saldo del Módulo 1 se recalcule correctamente.

Esto mantiene trazabilidad fuerte: cada merma, despacho o cierre del vivero siempre puede atribuirse a un origen único.

### 2.2. Elegibilidad del lote origen

Solo se puede iniciar un lote de vivero desde una recolección que esté:

* en estado **VERIFICADO** o equivalente formal del Módulo 1,
* operativamente habilitada para consumo,
* con saldo suficiente,
* y con identidad de planta disponible para heredar.

### 2.3. Identidad de planta heredada desde Módulo 1

Al crear el lote de vivero se debe **heredar y congelar (snapshot)** la identidad de la planta relacionada al lote origen, incluyendo como mínimo:

* `planta_id`
* `nombre_cientifico_snapshot`
* `nombre_comercial_snapshot`
* `tipo_material_snapshot`

Esto evita que cambios futuros en catálogos alteren la trazabilidad histórica del lote.

### 2.4. Doble lectura de cantidad

En vivero conviven dos lecturas distintas de cantidad:

1. **Cantidad consumida del origen**
   Es la cantidad que se descuenta del Módulo 1 usando la **unidad canónica del lote origen**.

2. **Unidades iniciales en proceso**
   Es la cantidad operativa que inicia en vivero:

   * semillas sembradas estimadas, o
   * esquejes iniciados en proceso.

Esto es especialmente importante para **semillas**, donde el consumo desde Recolección puede mantenerse en gramos, mientras vivero necesita además una lectura estimada de unidades sembradas.

### 2.5. Inicio no equivale a plantas vivas

* En **Inicio** se registran **unidades en proceso**.
* La contabilidad estricta de **plantas vivas** comienza desde **Embolsado**.

Antes de Embolsado puede existir germinación, selección o pérdida natural del proceso, pero el saldo vivo operativo nace recién cuando la planta entra a bolsa o maceta.

### 2.6. Estados del MVP

Para el MVP:

* **Estado del lote:** `ACTIVO | FINALIZADO`
* **Estado del evento:** todo evento se registra directamente como `COMPLETO`

En esta fase no se usan estados operativos como `BORRADOR`, `PENDIENTE_VALIDACION` o `RECHAZADO`.

### 2.7. Evidencia de trazabilidad

La evidencia se modela mediante la entidad **`evidencia_trazabilidad`**, que puede almacenar:

* imágenes,
* documentos,
* metadatos,
* referencias técnicas,
* y otros soportes auditables.

En el MVP, la evidencia debe quedar **vinculada directamente al evento que la origina**.

### 2.8. Motivo de cierre del lote

Cuando un lote llega a estado `FINALIZADO`, debe diferenciarse **por qué** se cerró, usando `motivo_cierre`:

* `DESPACHO_TOTAL`
* `PERDIDA_TOTAL`
* `MIXTO`

---

## 3. Flujo del proceso (MVP)

El flujo mínimo del MVP se basa en **tres hitos obligatorios** y **dos eventos operativos principales**, con un evento opcional de seguimiento:

### Hitos obligatorios

1. **Inicio**
2. **Embolsado**
3. **Despacho**

### Eventos operativos principales

* **Merma**
* **Cierre automático**

### Evento opcional de seguimiento

* **Adaptabilidad**

### Secuencia mínima del MVP

`recolección origen → consumo a vivero → inicio → embolsado → adaptabilidad (opcional) → merma(s) y/o despacho(s) → cierre automático`

Reglas de secuencia:

* No se permite `EMBOLSADO` sin `INICIO` previo.
* No se permite `MERMA` sin `EMBOLSADO` previo.
* No se permite `DESPACHO` sin `EMBOLSADO` previo.
* No se permite `ADAPTABILIDAD` sin `EMBOLSADO` previo.
* `ADAPTABILIDAD` **no es requisito** para registrar `MERMA` ni `DESPACHO`.

---

## 4. Descripción de eventos del MVP

## 4.1. Inicio

Registro del arranque del lote según el material:

* **Semilla** → germinación / semillero
* **Esqueje** → inicio de enraizamiento o proceso equivalente

Datos mínimos esperados:

* `id_lote_origen`
* `fecha_evento_inicio`
* `responsable`
* `id_vivero`
* `cantidad_consumida_origen`
* `unidad_consumida_origen`
* `unidades_iniciales_en_proceso`
* `planta_id` y snapshots heredados desde Módulo 1
* observaciones (si aplica)
* evidencia de trazabilidad obligatoria

Reglas importantes:

* El lote origen debe ser elegible para consumo.
* La creación del lote en Módulo 2 y el descuento del saldo en Módulo 1 ocurren en **una misma transacción atómica**.
* En el MVP, el evento `INICIO` se registra directamente como `COMPLETO`.
* No se permite edición posterior del evento.

## 4.2. Embolsado

El **Embolsado** marca el punto en el que la plántula pasa a bolsa o maceta y comienza el seguimiento como **saldo vivo**.

Desde este punto se registra:

* `plantas_vivas_iniciales`
* `saldo_vivo_antes`
* `saldo_vivo_despues`
* observaciones
* evidencia de trazabilidad obligatoria

Reglas importantes:

* El evento `EMBOLSADO` solo puede registrarse **una vez por lote**.
* El saldo vivo nace en este evento.
* El saldo debe ser **calculado por el sistema**, no ingresado libremente por el usuario.

## 4.3. Adaptabilidad

La **Adaptabilidad** representa el periodo en el que la planta se fortalece en ambientes controlados antes de plantarse.

En el MVP:

* se registra como evento operativo de seguimiento,
* puede ocurrir múltiples veces durante el ciclo del lote,
* puede incluir subetapas como `SOMBRA`, `MEDIA_SOMBRA` y `SOL_DIRECTO`,
* no exige permanencia mínima,
* no exige una secuencia rígida,
* y **no bloquea el despacho**.

Su objetivo en el MVP es aportar contexto operativo e historial sin volver compleja la lógica central del sistema.

Datos mínimos recomendados:

* `fecha_evento`
* `subetapa_ambiente`
* `responsable`
* observaciones
* evidencia de trazabilidad obligatoria

## 4.4. Merma

La **Merma** representa pérdida explícita del saldo vivo por causas reales del proceso.

Cada merma registra:

* `cantidad_perdida`
* `causa_merma`
* `fecha_evento`
* `responsable`
* `saldo_vivo_antes`
* `saldo_vivo_despues`
* observaciones
* evidencia de trazabilidad obligatoria

Reglas importantes:

* La merma no puede dejar saldo negativo.
* La cantidad perdida no puede exceder el saldo vivo disponible.
* Cuando la merma supere el umbral operativo configurado, el sistema debe exigir observación obligatoria y puede exigir validaciones adicionales en fases futuras.

## 4.5. Despacho

El **Despacho** representa la salida parcial o total de plantas listas para plantación.

Cada despacho registra:

* `cantidad_despachada`
* `fecha_evento`
* `responsable`
* `destino_tipo`
* `destino_referencia`
* `comunidad_destino`
* `saldo_vivo_antes`
* `saldo_vivo_despues`
* evidencia de trazabilidad obligatoria

Reglas importantes:

* No se permite despacho sin `EMBOLSADO` previo.
* La cantidad despachada no puede exceder el saldo vivo disponible.
* Si el saldo vivo llega a `0`, el lote debe cerrarse automáticamente.

## 4.6. Cierre automático

El **Cierre automático** se genera cuando el saldo vivo llega a `0`.

Este evento debe registrar:

* `fecha_evento`
* `motivo_cierre`
* `saldo_vivo_final`
* referencia al evento que dejó el saldo en cero

Reglas importantes:

* El lote pasa a estado `FINALIZADO`.
* Ya no se permiten nuevos eventos operativos normales.
* El `motivo_cierre` debe calcularse como:

  * `DESPACHO_TOTAL`
  * `PERDIDA_TOTAL`
  * `MIXTO`

---

## 5. Modelo de eventos

El sistema se basa en eventos **append-only**: se agregan al historial y no se reescriben ni eliminan.

Tipos de evento del MVP:

* `INICIO`
* `EMBOLSADO`
* `ADAPTABILIDAD`
* `MERMA`
* `DESPACHO`
* `CIERRE_AUTOMATICO`

Fuera del MVP:

* correcciones auditadas,
* validación formal por evento,
* excepción de evidencia,
* evidencia tardía,
* multi-aprobación,
* traslados entre viveros,
* y sincronización offline-first.

---

## 6. Evidencia de trazabilidad en el MVP

En esta versión del MVP, la evidencia se maneja de forma **estricta**.

### 6.1. Regla general

Todo evento operativo del vivero debe quedar respaldado por evidencia de trazabilidad vinculada directamente al evento.

### 6.2. Eventos con evidencia obligatoria

En el MVP la evidencia es obligatoria para:

* `INICIO`
* `EMBOLSADO`
* `ADAPTABILIDAD`
* `MERMA`
* `DESPACHO`

### 6.3. Reglas de operación

* Si un evento requiere evidencia y no tiene soporte válido, **no debe registrarse**.
* No se aceptan excepciones de evidencia en el MVP.
* No se acepta evidencia tardía en el MVP.

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

`saldo_vivo_despues = saldo_vivo_antes - mermas - despachos`

Reglas:

* el saldo no puede quedar negativo,
* las cantidades normales solo pueden mantener o disminuir el saldo,
* el saldo vivo **no aumenta** en el MVP,
* y los saldos deben ser calculados por el sistema.

### 8.2. Cierre automático del lote

El lote se finaliza automáticamente cuando el saldo vivo llega a **0**.

No basta marcar `FINALIZADO`; también debe calcularse `motivo_cierre`:

* **DESPACHO_TOTAL**: el lote llegó a 0 por despachos,
* **PERDIDA_TOTAL**: el lote llegó a 0 sin despachos, por pérdida total,
* **MIXTO**: el lote llegó a 0 combinando mermas y despachos.

---

## 9. Consulta operativa y cadena de custodia

El módulo debe exponer una vista operativa que permita:

* listar lotes activos y finalizados,
* buscar por lote origen, lote de vivero, planta o especie, vivero y motivo de cierre,
* visualizar el historial del lote,
* y seguir la cadena completa:

`recolección origen → consumo a vivero → inicio → embolsado → adaptabilidad → mermas → despachos → cierre`

Esta vista es crítica para operación diaria y para auditoría.

---

## 10. Estrategia blockchain del MVP

En el MVP, el historial operativo vive primero en base de datos.

La estrategia blockchain **no debe bloquear** el registro, consulta ni cierre confiable del lote.

Si se implementa anclaje blockchain en esta fase, solo el evento **`DESPACHO`** será candidato a anclaje.

Este anclaje se considera complementario y no indispensable para el funcionamiento base del módulo.

Fuera del MVP puede ampliarse a otros hitos relevantes.

---

## 11. Roles mínimos del MVP

Para el MVP bastan estos roles:

* `ADMIN`
* `OPERADOR`
* `CONSULTA`

Alcance básico:

* `ADMIN`: parametriza, consulta y administra.
* `OPERADOR`: registra eventos permitidos y consulta lotes.
* `CONSULTA`: visualiza historial, cadena de custodia y reportes.

El rol `VALIDADOR` queda reservado para una fase posterior.

---

## 12. Alcance real del MVP

### Incluye

* origen único por lote de vivero,
* elegibilidad solo desde recolecciones verificadas y con saldo suficiente,
* consumo atómico Módulo 1 → Módulo 2,
* herencia de planta o especie y snapshots,
* doble lectura de cantidad,
* eventos append-only,
* estados simples de lote y evento,
* embolsado como nacimiento del saldo vivo,
* adaptabilidad como seguimiento operativo no bloqueante,
* merma con causa,
* despacho parcial o total con destino estructurado,
* evidencia estricta por evento,
* cierre automático con motivo de cierre,
* historial visible,
* cadena de custodia,
* y anclaje blockchain mínimo opcional sobre despacho.

### Queda fuera por ahora

* validación formal por evento,
* estados operativos `BORRADOR`, `PENDIENTE_VALIDACION` y `RECHAZADO`,
* correcciones post-validación,
* reapertura de lotes,
* excepciones de evidencia,
* evidencia tardía,
* multi-aprobación,
* blockchain multi-hito,
* anclaje por cada evento,
* modelado agronómico detallado por especie,
* y flujos complejos offline-first.
