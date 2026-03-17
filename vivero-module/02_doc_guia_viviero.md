# Procesos - Modulo 2 Vivero

# Módulo 2 — Vivero (Maduración y trazabilidad pre-plantación)

## 1. Propósito

El **Módulo 2 (Vivero)** registra el proceso de **germinación, maduración y preparación pre-plantación** del material biológico proveniente del **Módulo 1 (Recolección)**.

Su propósito operativo y de trazabilidad es dejar evidencia verificable de:

- **qué lote origen alimentó** al lote de vivero,
- **qué planta/especie** se está trabajando,
- **cuánto material se consumió** desde Recolección,
- **cuántas unidades entran en proceso** en vivero,
- **cuándo nacen las plantas vivas** como saldo operativo,
- **qué mermas y despachos ocurren**,
- **qué evidencias de trazabilidad existen**,
- y **qué hitos fueron validados y anclados**.

Este módulo no prueba por sí solo la captura de carbono, pero sí aporta una parte crítica de la historia auditable: la **cadena de custodia y supervivencia operativa pre-plantación**.

---

## 2. Conceptos clave

### 2.1. Origen único y trazabilidad dura

- Un **lote de vivero** se crea usando material biológico proveniente de **un solo lote origen** del Módulo 1.
- **No se permite mezclar** varios lotes origen en un mismo lote de vivero.
- Un mismo lote origen **sí puede alimentar varios lotes de vivero**, siempre que cada consumo quede registrado como movimiento `CONSUMO_A_VIVERO` y el saldo de Módulo 1 se recalcule correctamente.

✅ Esto mantiene trazabilidad fuerte: cada merma, despacho o corrección del vivero siempre puede atribuirse a un origen único.

### 2.2. Elegibilidad del lote origen

Solo se puede iniciar un lote de vivero desde una recolección que esté:

- en estado **VERIFICADO** (o el estado equivalente de validación formal definido por Módulo 1),
- operativamente **ABIERTA** para consumo,
- con **saldo suficiente**,
- y con la identidad de planta/especie disponible para ser heredada al lote de vivero.

### 2.3. Identidad de planta heredada desde Módulo 1

Al crear el lote de vivero se debe **heredar y congelar (snapshot)** la identidad de la planta relacionada al lote origen, incluyendo como mínimo:

- `planta_id`
- `nombre_cientifico_snapshot`
- `nombre_comercial_snapshot`
- `tipo_material_snapshot`

Esto evita que cambios futuros en catálogos alteren la trazabilidad histórica del lote.

### 2.4. Doble lectura de cantidad

En vivero conviven dos lecturas distintas de cantidad:

1. **Cantidad consumida del origen**  
   Es la cantidad que se descuenta del Módulo 1 usando la **unidad canónica del lote origen** (por ejemplo gramos o unidades).

2. **Unidades iniciales en proceso**  
   Es la cantidad operativa que inicia en vivero:
   - semillas sembradas estimadas, o
   - esquejes puestos en agua / iniciados en proceso.

Esto es especialmente importante para **semillas**, donde el consumo desde Recolección puede mantenerse en gramos, mientras que Vivero necesita además una lectura estimada de unidades sembradas.

### 2.5. Inicio ≠ plantas vivas

- En **Inicio** se registran **unidades en proceso**.
- La contabilidad estricta de **plantas vivas** comienza desde **Embolsado**.

Antes de Embolsado puede existir germinación, selección o pérdida natural del proceso, pero el saldo vivo operativo nace recién cuando la planta entra a bolsa/maceta.

### 2.6. Estados separados de lote y evento

Para evitar ambigüedad:

- **Estado del lote:** `ACTIVO | FINALIZADO`
- **Estado del evento:** `PENDIENTE_VALIDACION | COMPLETO | RECHAZADO | BORRADOR`

Además:

- **CORRECCIÓN** no es un estado; es un **tipo de evento** post-validación. (no para el MVP)

### 2.7. Evidencia de trazabilidad

La evidencia ya no se modela como “foto suelta” aislada, sino mediante la tabla/entidad **`evidencia_trazabilidad`**, que puede almacenar:

- imágenes,
- documentos,
- metadatos,
- referencias técnicas,
- y otros soportes auditables.

Cada evento del vivero puede vincularse a una o varias evidencias de trazabilidad.

### 2.8. Motivo de cierre del lote

Cuando un lote llega a estado `FINALIZADO`, debe diferenciarse **por qué** se cerró, usando `motivo_cierre`:

- `DESPACHO_TOTAL`
- `PERDIDA_TOTAL`
- `MIXTO`

Esto es crítico para reportes de certificación y lectura de valor para bonos de carbono.

**Tenemos que registrar la cantidad de plantas que se perdieron o se despacharon.

---

## 3. Flujo del proceso (hitos y eventos)

El flujo mínimo del MVP se basa en **tres hitos obligatorios** y **eventos flexibles**:

1. **Inicio**
2. **Embolsado**
3. **Despacho**

El **Cambio de Ambiente** se mantiene como evento flexible y no bloqueante.

### 3.1. Inicio

Registro del arranque del lote según el material:

- Semilla → germinación / semillero
- Esqueje → agua / enraizamiento inicial

Datos mínimos esperados:

- `id_lote_origen`
- `fecha_evento_inicio`
- `responsable`
- `id_vivero`
- `cantidad_consumida_origen`
- `unidad_consumida_origen`
- `unidades_iniciales_en_proceso`
- `planta_id` y snapshots de la planta heredados desde Módulo 1
- observaciones (si aplica)

Reglas importantes:

- El lote origen debe ser elegible para consumo.
- La creación del lote en Módulo 2 y el descuento del saldo en Módulo 1 ocurren en **una misma transacción atómica**.
- El evento de Inicio nace en estado `PENDIENTE_VALIDACION` y luego puede ser validado a `COMPLETO` por un supervisor con el rol de VALIDADOR.

### 3.2. Embolsado

El **Embolsado** marca el punto en el que la plántula pasa a bolsa/maceta y comienza el seguimiento como **saldo vivo**.

Desde este punto se registra:

- `plantas_vivas_iniciales`
- `saldo_vivo_antes`
- `saldo_vivo_despues`
- observaciones
- evidencias de trazabilidad
- validación del hito

El vivero debe permitir que la altura y el tiempo de crecimiento varíen por especie; el sistema no modela un agronomía rígida detallada en el MVP.

### 3.3. Ambientes de adaptabilidad obligatorios pero flexibles con las sub etapas

La antigua “Adaptación” es una etapa obligatoria y pasa a registrarse como **adapatabilidad** con subetapas.

Etapas (catálogo, configurable):

- Sombra
- Media Sombra
- Sol Directo
- otros que se definan en catálogo

Reglas:

- Puede ir directo a Sol Directo, quedarse en Media Sombra o alternar.
- Permite ida y vuelta entre ambientes.
- No bloquea el despacho.
- Se registra para análisis histórico y manejo operativo.
  
**No es necesario validar el cambio de ambiente y tampoco tiene que resgistrarse en blockchain**. Es un evento operativo importante pero no crítico para la trazabilidad de la cadena de custodia.

### 3.4. Merma

La **merma** representa pérdida explícita del saldo vivo por causas reales del proceso.

Cada merma registra:

- `cantidad_perdida`
- `causa_merma`
- `fecha_evento`
- `responsable`
- `saldo_vivo_antes`
- `saldo_vivo_despues`
- observaciones
- evidencias asociadas (si aplica)

Las mermas altas no deben bloquear el sistema; deben quedar registradas y justificadas.

### 3.5. Despacho

El **Despacho** representa la salida parcial o total de plantas listas para plantación.

Cada despacho registra:

- `cantidad_despachada`
- `fecha_evento`
- `responsable`
- `destino_tipo`
- `destino_referencia`
- `comunidad_destino`
- `saldo_vivo_antes`
- `saldo_vivo_despues`
- evidencia de trazabilidad obligatoria

El destino debe ser **estructurado** y, cuando exista integración con Módulo 3, idealmente enlazable a la actividad de plantación.

---

## 4. Modelo de eventos (append-only y audit-friendly)

El sistema se basa en eventos **append-only**: se agregan al historial y no se reescriben.

Tipos de eventos relevantes del MVP:

- `INICIO`
- `EMBOLSADO`
- `CAMBIO_AMBIENTE`
- `MERMA`
- `DESPACHO`
- `CORRECCION`
- `VALIDACION_EVENTO`
- `EXCEPCION_EVIDENCIA`
- `EVIDENCIA_TRAZABILIDAD_AGREGADA`

Futuro (fuera del MVP):

- `TRASLADO_VIVERO`
- multi-aprobación previa al anclaje
- sincronización offline-first

---

## 5. Validación, estados y correcciones

### 5.1. Estado del evento

Cada evento/hito pasa por:

- **PENDIENTE_VALIDACION:** registro editable con datos mínimos
- **RECHAZADO:** validado por supervisor pero con errores que requieren corrección
- **BORRADOR:** evento creado pero aún no listo para validación
- **COMPLETO:** validado por supervisor e inmutable

### 5.2. Estado del lote

Cada lote de vivero mantiene:

- **ACTIVO:** admite eventos operativos
- **FINALIZADO:** ya no admite eventos operativos normales

### 5.3. Validación por evento/hito

La validación se realiza **por evento/hito**, no por lote completo.

Esto permite:

- cerrar y validar hitos de manera independiente,
- bloquear edición solo del evento validado,
- y mantener el lote operativo mientras existan eventos futuros legítimos.

### 5.4. Corrección post-validación (No para MVP)

Si se detecta un error luego de un evento `COMPLETO` o de un hito anclado:

- no se edita el evento original,
- se crea un evento **CORRECCION**,
- se registra el `delta_ajuste`,
- se registra el motivo,
- se recalculan los saldos posteriores,
- y el correctivo también puede ser anclado si afecta la verdad operativa relevante.

Si una corrección posterior deja nuevamente saldo vivo disponible, el lote puede **reabrirse** a `ACTIVO`, manteniendo historial íntegro del cierre anterior.

---

## 6. Evidencia de trazabilidad y excepciones

### 6.1. Evidencia asociada por evento

La evidencia se asocia **por evento**, usando `evidencia_trazabilidad`.

Esto permite soportar distintos tipos de evidencia sin perder la relación auditada con el evento específico.

### 6.2. Reglas mínimas por tipo de evento

- **Inicio:** evidencia obligatoria para validar el hito, especialmente si es semilla (foto del semillero o registro de unidades sembradas).
- **Embolsado:** evidencia obligatoria según criterio de validación definido.
- **Merma:** evidencia obligatoria.
- **Cambio de ambiente:** evidencia opcional.
- **Despacho:** evidencia **obligatoria**. No se permite despacho sin evidencia.
- **Corrección:** evidencia opcional, pero recomendable si altera saldo o corrige un hito ya anclado. (no para MVP)

### 6.3. Excepción de evidencia

Para el MVP no se aceptaran excepciones de evidencia. Si un evento requiere evidencia y no se puede adjuntar, el evento no puede ser validado como completo.

### 6.4. Evidencia tardía

Para el MVP no se podra adjuntar evidencia tardía. Si una evidencia se obtiene después, puede adjuntarse como **evidencia tardía** pero esto no se incluye en el MVP, esto no debería alterar el historial previo.

---

## 7. Reglas temporales

Para reflejar la realidad operativa:

- `fecha_evento` puede registrarse hasta **10 días en el pasado**
- `created_at` siempre registra la fecha/hora real del sistema
- no se permiten fechas futuras
- no se permiten eventos con fecha anterior al hito que habilita el proceso, salvo correcciones justificadas

---

## 8. Reglas de cantidades, cierre y saldo vivo

### 8.1. Conservación operativa del saldo vivo

Desde Embolsado:

`saldo_vivo_despues = saldo_vivo_antes - mermas - despachos ± correcciones`

Reglas:

- el saldo no puede quedar negativo,
- las cantidades normales solo pueden mantener o disminuir el saldo,
- los incrementos solo pueden provenir de una corrección auditada.

### 8.2. Cierre automático del lote

El lote se finaliza automáticamente cuando el saldo vivo llega a **0**.

Pero no basta marcar `FINALIZADO`; también debe calcularse `motivo_cierre`:

- **DESPACHO_TOTAL**: el lote llegó a 0 por despachos, sin pérdidas acumuladas relevantes que expliquen el cierre
- **PERDIDA_TOTAL**: el lote llegó a 0 sin despachos, por pérdida total
- **MIXTO**: el lote llegó a 0 combinando mermas/pérdidas y despachos

### 8.3. Lectura visual del cierre

El timeline del lote debe hacer visible el motivo de cierre:

- verde para `DESPACHO_TOTAL`
- rojo para `PERDIDA_TOTAL`
- color intermedio para `MIXTO`

---

## 9. Cadena de custodia y consulta operativa

El módulo debe exponer una vista operativa que permita:

- listar lotes activos y finalizados,
- buscar por lote origen, lote de vivero, planta/especie, vivero, comunidad destino y motivo de cierre,
- ver pendientes de validación,
- ver cierres por pérdida,
- y visualizar la cadena completa:

`recolección origen → consumo a vivero → inicio → embolsado → adaptabilidad (con sus sub etapas) → mermas/cambios → despachos → cierre`

Esta vista es crítica para operación diaria y para auditoría.

---

## 10. Auditoría y estrategia blockchain (MVP)

Para evitar costos de gas innecesarios:

- los eventos se guardan en base de datos como historial append-only,
- el anclaje blockchain se realiza por **hitos/cierres relevantes**, no por cada evento,
- el sistema por defecto decide cuándo eventos/hitos solo se validan y cuándo se anclan a blockchain automaticamente.

Hitos recomendados para anclaje en blockchain en el MVP:

- **Inicio validado**
- **Embolsado validado**
- **Adaptación**
- **Cierre del lote**
- **Corrección** que altere saldo o afecte un hito previamente anclado

---

## 11. Alcance MVP y fuera de alcance

### MVP incluye

- origen único por lote de vivero
- elegibilidad solo desde recolecciones verificadas y con saldo suficiente
- consumo atómico Módulo 1 → Módulo 2
- herencia de planta/especie y snapshots
- doble lectura de cantidad (consumo origen + unidades en proceso)
- eventos append-only
- estados separados de lote y evento
- validación por evento/hito
- embolsado como nacimiento del saldo vivo
- obligatoriedad para ambiendes de adaptabilidad (sombra/media sombra/sol directo) pero no tiene que pasar por cada uno ni registrarse en blockchain o validarse. 
- mermas con causa
- despachos parciales y totales con destino estructurado
- evidencia de trazabilidad por evento
- motivo de cierre
- historial y cadena de custodia visible
- anclaje blockchain por hitos relevantes

### Fuera de alcance por ahora

- multi-aprobación antes de blockchain
- offline-first para carga de evidencias
- modelado agronómico detallado por especie
- traslado entre viveros como flujo completo
- anclaje blockchain por cada evento

---
