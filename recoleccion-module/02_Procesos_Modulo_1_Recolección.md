# Módulo 1 — Recolección (Origen y trazabilidad del material biológico)

## 1. Propósito

El **Módulo 1 (Recolección)** registra el **origen** del material biológico (semillas o esquejes) y crea el **Lote Origen** que alimenta al **Módulo 2 (Vivero)**.

Su objetivo es generar un historial auditable de:

- **qué se recolectó** (especie, tipo de material y cantidad),
- **dónde se recolectó** (ubicación estructurada),
- **con qué evidencia** (fotografías),
- **cuándo se selló/validó** (registro “final”),
- y **cómo se consumió** posteriormente (consumo automático hacia Vivero y/o descarte).

Este módulo es la base de trazabilidad: si acá el origen es flojo, todo lo demás es cuento.

---

## 2. Conceptos clave

### 2.1. Recolección = Lote Origen

- Una **recolección** representa un **lote origen** (un “contenedor” de material biológico).
- Un lote origen puede abastecer **uno o varios** lotes del Módulo 2, pero **siempre** manteniendo trazabilidad mediante movimientos (ver 4).

✅ Esto permite uso parcial sin perder el rastro: cada consumo queda enlazado a su lote de vivero.

### 2.2. Separación Web2 vs sellado (bloquechain-friendly)

El módulo separa dos cosas:

- **Estado del registro (Web2):**
    - `BORRADOR`: editable, barato, aún no registrado en blockchain (no sellado).
    - `PENDIENTE_VALIDACION`: congelado mientras el validador revisa.
    - `VALIDADO`: registrado en blockchain (sellado), no editable.
    - `RECHAZADO`: no consumible, pero corregible para reenvío.
- **Estado operativo (inventario):**
    - `ABIERTO`: saldo disponible > 0
    - `CERRADO`: saldo disponible = 0 (agotado)

Además, el módulo debe separar dos historiales:

- **`RECOLECCION_HISTORIAL`** para ciclo de vida del registro.
- **`RECOLECCION_MOVIMIENTO`** para movimientos que afectan saldo.

Esto sigue la misma lógica general de Vivero, pero en Recolección conviene separar ambas cosas porque editar, pedir validación o rechazar un registro **no es** un movimiento de inventario.

El módulo también separa dos momentos para la identidad:

- mientras la recolección está en borrador, la identidad visible puede recalcularse si cambia la fuente maestra,
- cuando la recolección se aprueba, se guarda un **snapshot oficial** en la propia recolección para congelar el dato validado.

### 2.3. Cantidad y unidad canónica

- **ESQUEJE:** unidades enteras (1, 2, 3…)
- **SEMILLA:** peso o unidades enteras, con persistencia oficial en `G` o `UNIDAD` según la regla funcional del material.

Convención oficial del sistema:

- `ENUM(unidad_medida) = [UNIDAD, G]`
- el frontend puede aceptar `kg`, `g` y `unidad`
- el backend normaliza `kg -> G`, `g -> G` y `unidad -> UNIDAD`
- `kg` no se persiste
- no se deben mezclar `G` y `GR`

Reglas por tipo de material:

- **SEMILLA:** puede capturarse en peso o en unidades; si entra por peso se persiste `G`, si entra por conteo se persiste `UNIDAD`.
- **ESQUEJE:** solo `UNIDAD`, entero estricto, sin decimales.

### 2.4. Consumo automático hacia Vivero

- El consumo del lote origen **no se registra manualmente** en Recolección, es decir no hay una pantalla u opción dentro del modulo de recolección donde se registra el consumo del material biológico.
- Se descuenta **automáticamente** cuando en el Modulo 2 se crea un lote de germinación/embolsado seleccionando esta recolección como origen, es decir al crear un nuevo lote en el modulo dos se selecciona la cantidad.

---

## 3. Flujo del proceso (etapas)

El lote origen atraviesa 4 etapas operativas (no confundir con estados):

### 3.1. Creación del BORRADOR

**Objetivo:** capturar el registro con opción a editar despues y agregar detalles o modificaciones sin costos elevados.

Datos mínimos recomendados para permitir guardar BORRADOR:

- fecha de recolección (≤ 45 días atrás, no futura)
- tipo de material (semilla/esqueje)
- especie (nombre científico + comercial)
- cantidad inicial (válida según material)
- recolector (por defecto el usuario autenticado)
- vivero de almacenamiento (catálogo RF-GEN-02)
- observaciones (opcional)
- fotos (2 minimo)
- ubicación (lat/long mínimo, niveles administrativos osea Comunidad-Zona)

> Nota MVP: ubicación y fotos tampocopueden faltar en BORRADOR pero si se pueden editar, y son **obligatorias** para pasar a `PENDIENTE_VALIDACION`.
> 

En `BORRADOR`:

- se puede editar la ficha,
- `created_at` no cambia,
- `updated_at` y `updated_by` deben reflejar la última edición,
- y se puede eliminar solo mediante **soft delete**.

---

### 3.2. Completar evidencia y ubicación

**Objetivo:** completar lo que hace al registro “defendible” ante auditoría.

Requisitos para avanzar hacia validación:

- **Fotografías:** mínimo 2 (especie + cantidad)
    - JPG/PNG
    - máximo 5MB por foto
- **Ubicación estructurada (RF-REC-02):**
    - latitud (obligatorio): -90 a 90, 6 decimales
    - longitud (obligatorio): -180 a 180, 6 decimales
    - administrativos opcionales por catálogo: país/departamento/provincia/Comunidad-Zona
        
        (permitiendo “SIN ESPECIFICAR” como MVP)
        

---

### 3.3. Solicitud de validación y decisión del validador

**Objetivo:** separar la captura del borrador de la revisión formal del registro.

Flujo del MVP:

1. El recolector envía el borrador a revisión.
2. El estado pasa a `PENDIENTE_VALIDACION`.
3. Se registra un historial `SOLICITUD_VALIDACION`.
4. El validador revisa y decide:
   - `VALIDADO`
   - `RECHAZADO`

Si el validador **aprueba**:

- se registran `usuario_validacion` y `fecha_validacion`,
- se registra un historial `VALIDACION_APROBADA`,
- se congelan en `RECOLECCION` los snapshots oficiales de identidad:
  - `nombre_cientifico_snapshot`
  - `nombre_comercial_snapshot`
  - `variedad_snapshot`
  - `nombre_comunidad_snapshot`
  - `nombre_recolector_snapshot`
- el registro queda sellado,
- puede registrarse/anclarse en blockchain,
- y ya no se permite editar la ficha directamente.

Si el validador **rechaza**:

- se registra un historial `VALIDACION_RECHAZADA`,
- el registro pasa a `RECHAZADO`,
- no se puede consumir,
- y puede corregirse para volver a enviarse a validación.

Mientras el registro está en `PENDIENTE_VALIDACION`, la ficha queda congelada.

---

### 3.4. Uso en Vivero (consumo automático)

**Objetivo:** iniciar el Modulo 2 usando un origen validado, descontando saldo de forma atómica.

Cuando desde el Modulo 2 se crea un lote seleccionando una recolección:

- el sistema verifica que la recolección esté:
    - `VALIDADO`
    - operativamente `ABIERTO` (saldo > 0)
    - con saldo suficiente para la cantidad solicitada
- crea el lote de vivero (el Modulo 2)
- registra un movimiento **CONSUMO_A_VIVERO** en la recolección
- descuenta saldo automáticamente
- enlaza `recolección_id → lote_vivero_id`
- y hereda al lote de vivero los snapshots oficiales ya congelados en Recolección, para no depender de lecturas vivas de `PLANTA`

El lote de vivero usa un `vivero_id` seleccionado en Módulo 2; no se hereda automáticamente desde `RECOLECCION.vivero_id`.

El `codigo_trazabilidad` del lote de vivero debe quedar como `VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}`.

Contrato estricto entre Módulo 1 y Módulo 2 en `INICIO`:

- `abs(RECOLECCION_MOVIMIENTO.delta) = LOTE_VIVERO.cantidad_inicial_en_proceso`
- `LOTE_VIVERO.cantidad_inicial_en_proceso = EVENTO_LOTE_VIVERO.cantidad_afectada`
- `RECOLECCION_MOVIMIENTO.unidad_medida_movimiento = LOTE_VIVERO.unidad_medida_inicial`
- `LOTE_VIVERO.unidad_medida_inicial = EVENTO_LOTE_VIVERO.unidad_medida_evento`
- `LOTE_VIVERO.nombre_cientifico_snapshot = RECOLECCION.nombre_cientifico_snapshot`
- `LOTE_VIVERO.nombre_comercial_snapshot = RECOLECCION.nombre_comercial_snapshot`
- `LOTE_VIVERO.variedad_snapshot = RECOLECCION.variedad_snapshot`

Restricciones del MVP:

- no se puede consumir más de lo disponible
- la unidad del movimiento debe coincidir con la unidad canónica de la recolección
- `CONSUMO_A_VIVERO` usa `delta` negativo
- `DESECHO` usa `delta` negativo

**Regla crítica:** creación el Modulo 2 + consumo deben ser **atómicos**:

- si falla el Modulo 2, no se descuenta saldo
- si falla el descuento, no se crea el Modulo 2

---

### 3.5. Descarte (parcial o total)

**Objetivo:** registrar pérdidas reales del lote origen.

- Se registra un movimiento **DESECHO** con:
    - cantidad descartada (según tipo de material)
    - **motivo de descarte** obligatorio (catálogo + “OTRO”)
    - observación si corresponde

Si el descarte deja el saldo en 0, el lote queda `CERRADO`.

---

## 4. Eventos y movimientos (modelo audit-friendly)

El módulo usa un enfoque **append-only** pero con dos capas distintas:

### 4.1. Eventos del ciclo de vida del registro

`RECOLECCION_HISTORIAL` registra el timeline del registro, no el saldo.

Eventos mínimos recomendados:

- `BORRADOR_CREADO`
- `SOLICITUD_VALIDACION`
- `VALIDACION_APROBADA`
- `VALIDACION_RECHAZADA`
- `BORRADOR_ELIMINADO`

En el MVP, esta tabla se deja preparada para no mezclar ciclo de vida con inventario.

### 4.2. Movimientos de inventario

`RECOLECCION_MOVIMIENTO` registra solo operaciones que afectan saldo o que en el futuro afecten integridad inventariable.

Movimientos típicos:

- **CONSUMO_A_VIVERO** (automático desde el Modulo 2)
- **DESECHO** (parcial o total, con motivo obligatorio)

Fuera del MVP:

- **CORRECCION**
- **AJUSTE_MIGRACION**

---

## 5. Estados y eventos del registro: BORRADOR, PENDIENTE_VALIDACION, VALIDADO y RECHAZADO

### 5.1. BORRADOR

**Objetivo:** permitir captura rápida en campo sin perder consistencia mínima.

- **Editable** (se puede corregir lo que esté mal).
- **Incompletitud controlada:** a pesar de ser un BORRADOR requerie compos minimos para no caer en basura.
- **No se ancla a blockchain** (no es “historia oficial” todavía).
- **Eliminable solo con soft delete**.

**Campos típicamente editables en BORRADOR (MVP):**
- Especie (científico/comercial) y tipo de material.
- Fecha de recolección.
- Método de recolección.
- Cantidad inicial (con normalización a unidad canónica).
- Vivero de almacenamiento.
- Ubicación (si existe) y referencia/observaciones.
- Evidencia fotográfica (alta/baja).

**Validaciones mínimas incluso en BORRADOR (anti-basura):**
- Tipo de material obligatorio.
- Especie obligatoria.
- Cantidad inicial **> 0**.
- Fecha **no futura** (y dentro del rango permitido por reglas temporales del módulo).

**Auditoría mínima (Web2):**
- `creado_por`, `creado_en`, `actualizado_por`, `actualizado_en`.

### 5.2. PENDIENTE_VALIDACION

**Objetivo:** congelar la ficha mientras el validador revisa.

- El recolector ya no edita mientras el registro está en revisión.
- El registro todavía no es elegible para consumo.
- Todavía no se ancla a blockchain.
- Debe existir un registro de historial `SOLICITUD_VALIDACION`.

### 5.3. VALIDADO

**Objetivo:** convertir el registro revisado en un origen **sellado** y auditable.

- Registro **sellado**.
- **No se permite editar la ficha** directamente.
- Se vuelve elegible para **consumo** hacia el Módulo 2 (Vivero).

**Condiciones para ser aprobado como `VALIDADO` (MVP):**
- Evidencia mínima completa (≥ 2 fotos).
- Ubicación con **latitud/longitud** válidas.
- Campos mínimos completos (especie, tipo material, fecha, cantidad inicial, método, vivero).
- Revisión/aprobación del validador.

**Post-validación (sin reescritura):**
- Solo se permiten **movimientos append-only**:
  - `CONSUMO_A_VIVERO` (automático desde Módulo 2)
  - `DESECHO` (con motivo)
  
(Fuera del MVP: se puede evaluar validacion comunitaria adicional, con registro explicito de quienes validaron y cuando.)

### 5.4. RECHAZADO

**Objetivo:** dejar constancia de que el validador no aprobó la solicitud.

- El registro no es consumible.
- El registro no se ancla a blockchain.
- Debe existir un registro de historial `VALIDACION_RECHAZADA`.
- El recolector puede corregir la ficha y reenviarla a validación.

### 5.5. Correcciones fuera del MVP

Si se detecta un error después de validar, en el MVP no se corrige la recolección validada ni sus movimientos. La regla operativa es:

- el borrador sí se puede editar antes de validar,
- una vez validado/subido, no hay vuelta atrás en el MVP,
- un modelo futuro de `CORRECCION` podrá existir como evento auditado, pero queda explícitamente fuera de esta fase.

---

## 6. Evidencia fotográfica y excepciones

- Las fotos son obligatorias para crear un **BORRADOR** y para enviarlo a `PENDIENTE_VALIDACION` también (mínimo 2).
- En MVP, no se permiten “validaciones sin evidencia” (para no abrir un agujero de trazabilidad).
- Futuro: se puede permitir excepción con motivo y aprobación (similar al el Modulo 2), pero no en el MVP.

---

## 7. Reglas temporales (operación real)

- La fecha de recolección (`fecha_recolección`) puede ser retroactiva hasta **45 días**.
- El sistema guarda siempre:
    - `created_at` (fecha/hora real del registro),
    - `updated_at` (última edición de ficha cuando aplica),
    - `fecha_validación` (cuando se selló).

Restricción:

- no se permite fecha futura.

---

## 8. Reglas de consistencia de cantidades (conservación del saldo)

El saldo del lote origen se conserva así:

**saldo = cantidad_inicial + SUM(delta_movimientos)**

Reglas:

- El saldo **nunca** puede ser negativo.
- En el MVP, los deltas persistidos son negativos porque solo existen `CONSUMO_A_VIVERO` y `DESECHO`.
- El lote se considera `CERRADO` cuando saldo = 0.

---

## 9. Auditoría y estrategia blockchain (MVP)

Para evitar gas innecesario:

- El sistema opera en Web2 con historial append-only.
- El timeline mínimo del registro se construye combinando `RECOLECCION.created_at`, `RECOLECCION_HISTORIAL` y `RECOLECCION_MOVIMIENTO.created_at`.
- Se ancla en blockchain:
    - al pasar a `VALIDADO` (hash/snapshot del registro sellado)
    - y por cada movimiento post-validación:
        - `CONSUMO_A_VIVERO`
        - `DESECHO`

Roles (MVP):

- `ADMIN`: administra catalogos y puede consultar o intervenir segun permisos de negocio.
- `GENERAL`: crea `BORRADOR`, edita la ficha y solicita validacion.
- `VALIDADOR`: revisa `PENDIENTE_VALIDACION` y aprueba o rechaza.
- `VOLUNTARIO`: no deberia tener permisos operativos criticos salvo habilitacion explicita.

---

## 10. Alcance MVP y futuro

**MVP incluye**

- BORRADOR / PENDIENTE_VALIDACION / VALIDADO / RECHAZADO
- Soft delete solo para BORRADOR
- Persistencia oficial de unidades: `UNIDAD | G`
- Ubicación con lat/long obligatorias para validar
- Evidencia mínima (2 fotos) para validar
- `RECOLECCION_HISTORIAL` preparado para ciclo de vida mínimo del registro
- Motivo de descarte obligatorio
- `RECOLECCION_MOVIMIENTO` reservado para consumo automático desde el Modulo 2 y descarte
- Integración con el Modulo 2 con consumo automático y transacción atómica
- Catálogos administrados + “SIN ESPECIFICAR” para niveles administrativos

**Futuro**

- Auditoría campo por campo del borrador
- Correcciones auditadas post-validación
- Excepciones aprobadas (validación sin evidencia, casos justificados)
- Alta de nuevas comunidades/zonas solo por `ADMIN`
- Offline-first (captura en campo sin señal: fotos/local → subida posterior)
- Métricas de calidad de evidencia (ej. obligatoriedad de foto GPS/EXIF si se quiere subir el estándar)
- Fuera del MVP se puede evaluar validacion comunitaria adicional, con registro explicito en historial y, si aplica, en blockchain.
