# Módulo 3 — Plantación (Concreción del objetivo: reforestar, arborizar, forestar)

## 1. Propósito

El **Módulo 3 (Plantación)** registra el momento en que los árboles producidos en el **Módulo 2 (Vivero)** se plantan efectivamente en una zona o comunidad, dentro de una **campaña** planificada por el administrador o un coordinador de proyecto.

Su objetivo es generar un historial auditable de:

- **qué se plantó** (especies y cantidades),
- **dónde se plantó** (zona/comunidad + GPS + polígono certificable),
- **cuándo se plantó** (fecha del registro),
- **quién lo plantó** (responsable y co-responsables),
- **bajo qué campaña** (planificación y meta),
- **con qué evidencia** (fotografías por micro-ubicación),
- **cómo evolucionó** (mortandad y reposiciones para captura de carbono),
- **y de qué origen vino** (trazabilidad hacia vivero y recolección).

Este módulo es la cara visible del proyecto y la base operativa de los **bonos de carbono**. Toda la información del módulo es de transparencia pública, salvo lo expresamente restringido.

---

## 2. Conceptos clave

### 2.1. Campaña = unidad de planificación

- Una **campaña** es la unidad central del módulo: representa un proyecto de **reforestación**, **arborización** o **forestación** en una o más zonas.
- Toda plantación debe pertenecer a **una campaña activa**.
- Una campaña define la meta de árboles, el mix de especies con sus topes porcentuales, el polígono del área a intervenir y el equipo responsable.

✅ Esto permite agrupar y reportar de forma coherente: progreso global, progreso por zona, captura de carbono proyectada y supervivencia.

### 2.2. Campañas con sub-metas y fases

- Una campaña puede abarcar **varias zonas o comunidades**, cada una con su propia **sub-meta**.
- Una campaña puede tener **campañas hijas** que representan **fases** sucesivas.
- La campaña padre acumula el progreso global; las hijas tienen sus propias metas, estados, fechas y polígonos.

Ejemplo:

- Campaña padre: "Arborización La Paz 2026" (meta: 3000 árboles).
  - Hija fase 1: "Cota Cota" (meta: 1000).
  - Hija fase 2: "San Miguel" (meta: 1000).
  - Hija fase 3: "Hernán" (meta: 1000).

Una campaña hija puede crearse después si la campaña padre llegó al 100% pero se quiere ampliar la cobertura.

### 2.3. Mix de especies con topes (biodiversidad)

- Toda campaña debe definir un **mix de especies permitidas** con un **porcentaje máximo por especie**.
- La suma de los topes puede ser ≤ 100%.
- El sistema **advierte** si el operario excede el tope al registrar, pero **no bloquea** (el tope es guía, no restricción dura en MVP).
- La biodiversidad es relevante para certificación y bonos de carbono.

Ejemplo: en Hampaturi se permite máximo 40% de Queñua, 40% de Kewiña y 20% de otras especies nativas.

### 2.4. Asignación: vínculo Vivero ↔ Campaña

- Los árboles del Módulo 2 se vinculan a una campaña mediante una **asignación**.
- Una asignación **reserva** árboles vivos de un lote de vivero hacia una campaña, pero **no los despacha todavía**.
- El despacho real del Módulo 2 se dispara recién cuando el árbol se planta efectivamente.

✅ Esto permite planificar sin descontar prematuramente del saldo vivo del vivero.

Reglas clave de asignación:

- Un lote de vivero puede asignar árboles a **varias campañas**.
- Una campaña puede recibir asignaciones de **varios lotes de vivero**.
- La cantidad asignada no puede superar el saldo vivo disponible del lote.
- Las asignaciones son **flexibles**: pueden ampliarse, reducirse o devolverse al vivero, siempre que la cantidad afectada todavía no haya sido plantada.

### 2.5. Sin "salida de campo" en el MVP

- El MVP **no modela** la fase intermedia "el operario tiene árboles en su poder".
- El descuento del saldo asignado y el despacho real del Módulo 2 ocurren **al registrar la plantación efectiva**.
- Las **devoluciones al vivero** existen como evento explícito sobre la asignación: el coordinador o admin puede devolver árboles asignados pero no plantados, y el saldo vuelve al lote de vivero.

### 2.6. Registro de plantación = unidad atómica

- Un **registro de plantación** representa un grupo de árboles plantados en una **micro-ubicación** específica, dentro de una jornada.
- Cada registro captura: fotos, GPS, especies y cantidades, campaña asociada, responsable y co-responsables opcionales.
- Una jornada del operario puede generar **múltiples registros** en distintas micro-ubicaciones.
- Una jornada puede tocar **múltiples campañas** (un operario puede plantar en dos campañas el mismo día).

### 2.7. Geolocalización dual: puntos + polígono

- **Polígono de campaña (obligatorio):** lo define el admin/coordinador al crear la campaña. Representa el área certificable.
- **Puntos GPS (obligatorios):** los captura el operario en cada registro de plantación. Validan la presencia física en el área.

Esta doble lectura permite:

- Verificación operativa (puntos dentro del polígono).
- Certificación para bonos de carbono (polígono delimitado).

### 2.8. Trazabilidad por asignación, no por árbol

- En el MVP, **no se trackea de qué lote individual vino cada árbol plantado**.
- La trazabilidad se mantiene a nivel de **asignación**: se sabe qué lotes de vivero alimentaron qué campaña y en qué cantidades.
- El descuento del saldo asignado al plantar usa **FIFO automático** entre los lotes asignados.

✅ Esto reduce drásticamente la carga operativa del operario en campo sin perder trazabilidad relevante para bonos de carbono.

### 2.9. Snapshots oficiales (siguiendo el patrón de M1 y M2)

Al registrar una plantación se congelan snapshots oficiales en el registro:

- `nombre_campania_snapshot`
- `nombre_zona_snapshot`
- `nombre_responsable_snapshot`
- mix de especies plantadas con sus snapshots de identidad heredados del Módulo 2.

Al crear una campaña se congelan snapshots de la zona/comunidad y del coordinador.

### 2.10. Mortandad y reposiciones (clave para bonos de carbono)

- La **mortandad** se reporta en visitas posteriores a un grupo previamente plantado.
- Se reporta como **delta de muertos** sobre el grupo ("se reportan 10 muertos más en el grupo X").
- El sistema muestra siempre el histórico para evitar doble conteo.
- La **reposición** es una plantación nueva marcada con flag `REPOSICION`, vinculada al grupo original, que consume saldo de la asignación de la campaña.

Para bonos de carbono se trackean **ambas dimensiones**:

- Histórico total plantado (incluye los que después murieron).
- Saldo vivo actual (plantado − muertos + repuestos).

### 2.11. Estados del registro vs estado operativo

- **Estado de la campaña:** `BORRADOR | ACTIVA | PAUSADA | COMPLETADA | CANCELADA`
- **Estado del registro de plantación:** se considera inmutable (append-only). Su "estado operativo" deriva del saldo vivo del grupo.
- **Estado de la asignación:** `ACTIVA | AGOTADA | DEVUELTA` (derivado del saldo asignado y plantado).

### 2.12. Eventos append-only

Como en los módulos anteriores, todos los eventos operativos son **append-only**: se agregan al historial y no se reescriben ni eliminan. No hay correcciones en el MVP.

---

## 3. Flujo del proceso (etapas)

### 3.1. Creación de la campaña (admin)

**Objetivo:** planificar el proyecto antes de operar.

Datos mínimos:

- Nombre de la campaña.
- Tipo: `REFORESTACION | ARBORIZACION | FORESTACION`.
- Coordinador asignado (obligatorio).
- Operarios del equipo (opcional al crear, ampliable después).
- Una o más zonas/comunidades (catálogo administrativo).
- Sub-metas por zona si hay varias.
- Meta total de árboles (> 0).
- Mix de especies con tope % por especie.
- **Polígono del área** (obligatorio en MVP).
- Campaña padre (opcional, si es una fase).
- Fechas estimadas (opcional).

Mientras la campaña está en `BORRADOR`:

- Es editable libremente.
- No acepta asignaciones ni plantaciones.
- Puede eliminarse con soft delete.

Al activar la campaña pasa a `ACTIVA` y queda habilitada para operar.

### 3.2. Asignación de árboles desde vivero

**Objetivo:** vincular stock vivo del vivero a la campaña.

- El admin o coordinador selecciona lotes de vivero con saldo vivo disponible.
- Define la cantidad a asignar de cada lote.
- El sistema crea una `ASIGNACION_VIVERO` por cada lote-campaña.
- El saldo vivo del lote en Módulo 2 **no se descuenta todavía**; se reserva lógicamente.

Restricciones:

- La cantidad asignada no puede exceder el saldo vivo del lote.
- Solo se pueden asignar lotes de vivero en estado `ACTIVO`.
- La asignación puede ampliarse después, agregando más lotes o más cantidad.

### 3.3. Registro de plantación (operario en campo)

**Objetivo:** registrar la plantación efectiva en una micro-ubicación.

Datos mínimos:

- `campania_id` (debe estar `ACTIVA`).
- `responsable_id` (operario logueado).
- `co_responsables_ids` (opcional, equipo que plantó junto).
- Fecha del registro (no futura, hasta 10 días en el pasado).
- **Foto(s)** con GPS embebido (mínimo 1, recomendado varias).
- **Latitud y longitud** capturadas automáticamente.
- Lista de **especies plantadas** con sus cantidades (al menos una especie con cantidad > 0).
- Observaciones (opcional).

Flujo al guardar:

1. El sistema valida que la campaña esté `ACTIVA`.
2. Verifica que el GPS esté **dentro del polígono** de la campaña (o de alguna de sus zonas si tiene sub-metas).
3. Verifica que las especies plantadas estén dentro del mix permitido.
4. Si una especie excede el tope %, **advierte pero no bloquea**.
5. Descuenta la cantidad plantada del saldo asignado, usando **FIFO** entre los lotes asignados a esa campaña.
6. Genera automáticamente un `DESPACHO` en Módulo 2 con `destino_tipo = PLANTACION_CAMPAÑA` y referencia a la campaña.
7. Congela snapshots oficiales en el registro.
8. Crea el registro en `REGISTRO_PLANTACION` como append-only.
9. Vincula evidencias fotográficas al registro.

Reglas estrictas:

- No se puede plantar más de lo asignado disponible.
- Si la suma plantada llega a la meta de la campaña, el sistema **bloquea nuevos registros iniciales** y la campaña pasa a `COMPLETADA`.
- Solo se permite plantación inicial si la meta no se ha alcanzado.

### 3.4. Reporte de mortandad

**Objetivo:** registrar pérdidas observadas en visitas posteriores.

Datos mínimos:

- `registro_plantacion_id` del grupo afectado (obligatorio).
- Fecha del reporte (no futura).
- `cantidad_muerta_delta` > 0 (cuántos más murieron desde el último reporte).
- Causa probable (catálogo + "OTRO").
- Foto opcional de evidencia.
- Observación opcional.

El sistema:

- Muestra al operario el histórico del grupo antes de confirmar.
- Valida que `cantidad_muerta_acumulada + delta ≤ cantidad_plantada_inicial + reposiciones`.
- Crea un evento `MORTANDAD_REPORTADA` append-only vinculado al grupo.
- Recalcula el saldo vivo del grupo.

### 3.5. Reposición

**Objetivo:** plantar árboles nuevos para reemplazar muertos previos.

- Funciona como una plantación normal **vinculada al grupo original** mediante `registro_plantacion_origen_id`.
- Lleva flag `es_reposicion = true`.
- Consume saldo asignado de la campaña como cualquier plantación.
- Genera evento `REPOSICION` append-only.

Reglas:

- Solo se permite reposición sobre grupos con mortandad reportada.
- La cantidad repuesta no puede exceder la mortandad acumulada del grupo.
- La reposición está permitida incluso si la campaña está en `COMPLETADA` (es parte del compromiso de carbono).
- No tiene límite temporal en el MVP.

### 3.6. Devolución al vivero

**Objetivo:** liberar árboles asignados que no se van a plantar.

- Solo aplica sobre **cantidad asignada pero no plantada**.
- El admin o coordinador inicia la devolución indicando lote, cantidad y motivo.
- El sistema:
  - Reduce el saldo asignado.
  - Devuelve la cantidad al saldo vivo del lote de vivero.
  - Genera evento `DEVOLUCION_A_VIVERO` append-only.

### 3.7. Cierre de campaña

Una campaña puede llegar a `COMPLETADA` por:

- Alcanzar su meta de árboles plantados (cierre automático).
- Decisión del admin (cierre manual anticipado).

Una vez `COMPLETADA`:

- No se permiten más plantaciones iniciales.
- Sí se permiten reposiciones.
- Sí se permite reportar mortandad.
- Sí se permite devolver saldo asignado no plantado al vivero.

Una campaña en `CANCELADA`:

- Se decide explícitamente cancelar antes de cumplir la meta.
- No permite nuevas plantaciones, reposiciones ni reportes.
- El saldo asignado no plantado debe devolverse al vivero.

Una campaña en `PAUSADA`:

- Operación temporalmente suspendida.
- No acepta nuevos registros.
- Puede reactivarse a `ACTIVA`.

---

## 4. Eventos y movimientos

### 4.1. Historial de ciclo de vida de la campaña

`CAMPANIA_HISTORIAL` registra el timeline del registro, no el saldo:

- `BORRADOR_CREADO`
- `CAMPANIA_ACTIVADA`
- `CAMPANIA_PAUSADA`
- `CAMPANIA_REACTIVADA`
- `CAMPANIA_COMPLETADA`
- `CAMPANIA_CANCELADA`

### 4.2. Eventos operativos de plantación

`EVENTO_PLANTACION` registra operaciones que afectan la campaña o un grupo plantado:

- `PLANTACION_INICIAL` (saldo plantado +N)
- `REPOSICION` (saldo plantado +N, vinculado a grupo origen)
- `MORTANDAD_REPORTADA` (saldo vivo −N en grupo)
- `ASIGNACION_VIVERO` (saldo asignado +N)
- `DEVOLUCION_A_VIVERO` (saldo asignado −N)

Fuera del MVP:

- `CORRECCION_MORTANDAD`
- `AJUSTE_MIGRACION`

---

## 5. Estados y transiciones

### 5.1. Estados de la campaña

- **BORRADOR:** editable, no operativa, soft delete permitido.
- **ACTIVA:** habilitada para asignar árboles, plantar, reportar mortandad y reposiciones.
- **PAUSADA:** temporalmente detenida. No acepta nuevos registros. Reactivable.
- **COMPLETADA:** meta alcanzada o cerrada anticipadamente. Solo reposiciones y reportes de mortandad.
- **CANCELADA:** cerrada definitivamente. Solo lectura.

Transiciones permitidas:

- `BORRADOR → ACTIVA | (soft delete)`
- `ACTIVA → PAUSADA | COMPLETADA | CANCELADA`
- `PAUSADA → ACTIVA | CANCELADA`
- `COMPLETADA → CANCELADA` (excepcional, solo admin)
- `CANCELADA → (terminal)`

### 5.2. Estado de la asignación (derivado)

- `ACTIVA`: saldo asignado disponible > 0 y campaña no terminal.
- `AGOTADA`: saldo asignado consumido en plantaciones.
- `DEVUELTA`: saldo asignado devuelto al vivero.

### 5.3. Saldo vivo del grupo plantado (derivado)

`saldo_vivo_grupo = cantidad_plantada_inicial + reposiciones − mortandad_acumulada`

Reglas:

- Nunca puede ser negativo.
- Es la métrica clave para captura de carbono.

---

## 6. Evidencia y geolocalización

### 6.1. Fotografías

- Obligatorias en `PLANTACION_INICIAL` y `REPOSICION` (mínimo 1, recomendado varias por micro-ubicación).
- Opcionales en `MORTANDAD_REPORTADA` (pero recomendadas).
- Formato: JPG/PNG.
- Tamaño máximo: 5 MB por foto.
- Modelo polimórfico: `EVIDENCIAS_TRAZABILIDAD` vinculadas a `EVENTO_PLANTACION.id`.

### 6.2. GPS por registro

- Latitud y longitud obligatorias en cada `PLANTACION_INICIAL` y `REPOSICION`.
- Rango: latitud `[-90, 90]`, longitud `[-180, 180]`, 6 decimales.
- Validación: el punto debe estar **dentro del polígono** de la campaña o de alguna de sus zonas.
- Tolerancia configurable (margen en metros) para evitar bloqueos por imprecisión del GPS.

### 6.3. Polígono de campaña

- Obligatorio al activar la campaña.
- Se almacena como GeoJSON o equivalente.
- Si la campaña tiene sub-metas por zona, cada zona puede tener su propio sub-polígono.
- El área en hectáreas se calcula automáticamente como dato referencial (no es meta).

---

## 7. Reglas temporales

- Fecha del registro de plantación: no futura, hasta **10 días** retroactivo.
- Fecha del reporte de mortandad: no futura, sin restricción retroactiva fuerte (las visitas pueden ser meses después).
- `created_at` siempre se registra automáticamente.
- `updated_at` y `updated_by` se mantienen en entidades editables (campaña en BORRADOR, asignaciones activas).

---

## 8. Reglas de consistencia de cantidades

### 8.1. Conservación del saldo asignado

`saldo_asignado_disponible = cantidad_asignada − cantidad_plantada − cantidad_devuelta`

Reglas:

- Nunca negativo.
- Al llegar a 0, la asignación queda `AGOTADA`.

### 8.2. Conservación del saldo plantado de la campaña

`plantado_campaña = SUM(PLANTACION_INICIAL) + SUM(REPOSICION)`

Para la barra de progreso de la meta, **solo cuenta `PLANTACION_INICIAL`**:

`progreso_campaña = SUM(PLANTACION_INICIAL) / meta_total`

Las reposiciones **no cuentan** para la meta, porque su propósito es mantener el saldo vivo, no avanzar la meta.

### 8.3. Conservación del saldo vivo

Por cada grupo plantado:

`saldo_vivo_grupo = cantidad_plantada_inicial − mortandad_acumulada + reposiciones_acumuladas_sobre_grupo`

Por la campaña:

`saldo_vivo_campaña = SUM(saldo_vivo_grupo)`

---

## 9. Integración con Módulo 2 (Vivero)

### 9.1. Contrato Asignación ↔ Vivero

- Una `ASIGNACION_VIVERO` reserva saldo vivo del lote de vivero pero **no genera evento en el Módulo 2**.
- El saldo asignado se descuenta lógicamente: `saldo_vivo_lote − asignaciones_activas` es lo disponible para nuevas asignaciones.

### 9.2. Contrato Plantación ↔ Despacho

Cada `PLANTACION_INICIAL` y cada `REPOSICION` genera **atómicamente**:

- Un evento `DESPACHO` en `EVENTO_LOTE_VIVERO` por cada lote afectado (FIFO).
- `destino_tipo = PLANTACION_CAMPAÑA` (nuevo valor del enum `destino_tipo_vivero`).
- `destino_referencia` apunta al `REGISTRO_PLANTACION.id`.
- `comunidad_destino_id` se hereda de la campaña.

Invariantes obligatorias:

- `SUM(DESPACHO.cantidad_afectada) por registro_plantacion = REGISTRO_PLANTACION.cantidad_total_plantada`
- `EVENTO_LOTE_VIVERO.unidad_medida_evento = UNIDAD`
- Si una plantación toca varios lotes (FIFO), se generan varios DESPACHO atómicamente.

### 9.3. Contrato Devolución ↔ Vivero

Cada `DEVOLUCION_A_VIVERO` **no genera evento** en el Módulo 2 porque no afecta saldo vivo real (los árboles nunca salieron físicamente). Solo libera la reserva lógica.

---

## 10. Auditoría y estrategia blockchain (MVP)

- El historial vive primero en base de datos.
- El timeline se construye combinando `CAMPANIA_HISTORIAL`, `EVENTO_PLANTACION` y los eventos heredados de Módulo 2.
- Anclajes blockchain candidatos en el MVP:
  - Activación de campaña (`CAMPANIA_ACTIVADA`).
  - Cada `PLANTACION_INICIAL` y `REPOSICION` (porque son los eventos públicamente verificables).
  - Cierre de campaña (`CAMPANIA_COMPLETADA`).
- El anclaje es complementario; si la integración falla, el evento operativo permanece válido.
- Roles MVP:
  - `ADMIN`: crea/edita campañas, gestiona asignaciones globales, cierra campañas.
  - `COORDINADOR`: gestiona sus campañas asignadas, asigna/devuelve árboles, también puede operar.
  - `GENERAL` (operario): registra plantaciones, reposiciones y mortandad.
  - `VALIDADOR`: rol global de plataforma, sin flujo especial en este módulo en MVP.
  - `VOLUNTARIO`: sin permisos operativos críticos salvo habilitación explícita.

---

## 11. Vista pública (transparencia)

Toda la información de campañas activas y completadas es **pública sin autenticación**, accesible desde el home de la PWA:

- Mapa interactivo con polígonos de zonas y pines GPS de plantaciones.
- Totalizadores: árboles plantados, captura estimada de CO₂, campañas activas, comunidades alcanzadas.
- Detalle de campaña con barra de progreso, mix de especies real vs planificado, galería de fotos, equipo participante.
- Drill-down de trazabilidad hacia Módulo 2 y Módulo 1.
- Estimación de captura de CO₂ por especie + edad + cantidad (fórmulas referenciales del MVP).

Información sensible: en MVP **todo es público** porque el proyecto es de blockchain y la transparencia es un valor central. Sin restricciones especiales sobre nombres de operarios, coordinadores ni ubicaciones.

---

## 12. Alcance MVP y futuro

### MVP incluye

- Campañas con tipo, zona(s), sub-metas, mix de especies con topes %, polígono obligatorio.
- Campañas hijas (fases).
- Estados: BORRADOR / ACTIVA / PAUSADA / COMPLETADA / CANCELADA.
- Asignación flexible Vivero → Campaña, ampliable y devolvible.
- Sin "salida de campo": descuento atómico al plantar (FIFO).
- Registro de plantación con foto + GPS + especies + cantidades.
- Co-responsables (equipo).
- Reportes de mortandad como delta sobre grupo.
- Reposiciones vinculadas a grupo origen, permitidas incluso post-cierre.
- Integración atómica con DESPACHO del Módulo 2.
- Eventos append-only.
- Snapshots oficiales en campaña y en cada registro.
- Vista pública sin autenticación.
- Anclaje blockchain en eventos clave.

### Futuro

- Correcciones auditadas de mortandad y plantación.
- Trazabilidad por árbol individual (no solo por asignación).
- Salida de campo modelada (árboles "en mano del operario" entre vivero y plantación).
- Offline-first para operarios en zonas sin señal.
- Polígonos dinámicos calculados desde los puntos GPS plantados.
- Cálculos avanzados de captura de CO₂ por especie con curvas de crecimiento.
- Monitoreo programado con notificaciones de visitas pendientes.
- Validación comunitaria de plantaciones.
- Detección automática de duplicados de GPS.
- Restricciones temporales para reposiciones (ej: 2 años post-plantación).
- Permisos granulares para vista pública (ocultar info según contexto).
