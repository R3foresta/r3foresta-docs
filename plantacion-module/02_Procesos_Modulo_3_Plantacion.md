# Módulo 3 — Plantación (Concreción del objetivo: reforestar, arborizar, forestar)

## 1. Propósito

El **Módulo 3 (Plantación)** registra el momento en que los árboles producidos en el **Módulo 2 (Vivero)** se plantan efectivamente en una zona o comunidad, dentro de una **subcampaña** operativa que pertenece a una **campaña** estratégica planificada por el administrador.

Su objetivo es generar un historial auditable de:

- **qué se plantó** (especies y cantidades),
- **dónde se plantó** (zona/comunidad + GPS + polígono certificable),
- **cuándo se plantó** (fecha del registro),
- **quién lo plantó** (responsable y co-responsables),
- **bajo qué subcampaña** (planificación y meta operativa),
- **bajo qué campaña** (proyecto estratégico, organizaciones asociadas),
- **con qué evidencia** (fotografías por micro-ubicación),
- **de qué lote específico de vivero salió** (trazabilidad explícita al lote),
- **cómo evolucionó** (mortandad y reposiciones durante el ciclo de mantenimiento),
- **y de qué origen vino** (drill-down hacia Vivero y Recolección).

Este módulo es la cara visible del proyecto y la base operativa de los **bonos de carbono**. Toda la información del módulo es de transparencia pública, alineada con el carácter blockchain del proyecto.

---

## 2. Conceptos clave

### 2.1. Arquitectura de dos niveles: Campaña ↔ Subcampaña

El módulo separa **planificación estratégica** de **operación real**:

- **Campaña (nivel estratégico):** contenedor lógico que agrupa el proyecto. Tiene nombre, descripción, organizaciones asociadas, fechas estimadas globales. **No tiene polígono propio ni meta operativa propia.**
- **Subcampaña (nivel operativo):** unidad de trabajo real. Tiene su propio coordinador (membresía contextual, ver §2.10), equipo, polígono, meta de árboles, asignaciones de lotes y estado operativo. La composición real de especies se registra en `REGISTRO_PLANTACION_DETALLE`; el control de mix con topes queda fuera del MVP (ver §2.12).

Una campaña contiene **N subcampañas** (al menos 1, sin límite superior).

Ejemplo:

- Campaña: "Arborización La Paz 2026" (organizaciones: Alcaldía La Paz + ONG VerdesAndinos).
  - Subcampaña 1: "Cota Cota" (coordinador A, meta 1000 árboles, polígono A).
  - Subcampaña 2: "San Miguel" (coordinador B, meta 1000 árboles, polígono B).
  - Subcampaña 3: "Hampaturi" (coordinador C, meta 5000 árboles, polígono C).

Si se quiere ampliar el proyecto, **se crea una nueva subcampaña** dentro de la misma campaña. No existe el concepto de "fases" ni "campañas hijas".

### 2.2. Estado derivado de la campaña padre

La campaña padre **no tiene estado propio persistido**. Su estado se calcula en tiempo real a partir de sus subcampañas:

| Si las subcampañas son... | La campaña se muestra como... |
|---------------------------|-------------------------------|
| Todas en BORRADOR | BORRADOR |
| Al menos una ACTIVA | ACTIVA |
| Todas COMPLETADAS o FINALIZADA_PARCIAL en MANTENIMIENTO_ACTIVO | EN_MANTENIMIENTO |
| Todas en MONITOREO_HISTORICO | MONITOREO_HISTORICO |

Esto evita inconsistencias entre campaña padre y subcampañas. La fuente única de verdad es la subcampaña.

### 2.3. Organizaciones asociadas

Una campaña puede tener **1 o más organizaciones asociadas** (relación N:M).

Esto permite reflejar:
- Sponsors corporativos.
- Convenios con ONGs.
- Alianzas público-privadas.
- Transparencia pública sobre quién respalda cada proyecto.

En el MVP `ORGANIZACION` se modela como **tabla maestra real** del Módulo General, al mismo nivel que `USUARIO`, `VIVERO` o `PLANTA` (no como texto libre ni como catálogo embebido en Plantación). La relación N:M entre `CAMPANIA` y `ORGANIZACION` se persiste en una tabla puente `CAMPANIA_ORGANIZACION`.

La inactivación de una organización (`activo = false`) no rompe historial: las campañas que la tengan asociada siguen mostrando el snapshot de su nombre congelado al activar la subcampaña.

### 2.4. Estados operativos de la subcampaña

La subcampaña tiene los siguientes estados operativos:

- **BORRADOR:** en planificación, editable libremente, no acepta operaciones.
- **ACTIVA:** habilitada para plantar, recibir asignaciones, registrar mantenimiento.
- **COMPLETADA:** meta de árboles alcanzada al 100%. Cierre automático.
- **FINALIZADA_PARCIAL:** cerrada antes de alcanzar la meta. Cierre manual por admin.

Estados reservados para implementación futura (existen en el enum pero **no se usan en MVP**):

- `PAUSADA`
- `CANCELADA`

Transiciones permitidas en MVP:

- `BORRADOR → ACTIVA` (al activar)
- `ACTIVA → COMPLETADA` (automático al alcanzar meta)
- `ACTIVA → FINALIZADA_PARCIAL` (manual por admin, requiere motivo)

No hay reapertura: si una subcampaña queda en FINALIZADA_PARCIAL y aparece stock nuevo después, se crea una **nueva subcampaña** dentro de la misma campaña, no se reabre la anterior.

### 2.5. Fase de mantenimiento (segunda dimensión, derivada por fecha)

Independiente del estado operativo, la subcampaña tiene una **fase de mantenimiento** que se calcula automáticamente por tiempo:

| Fase | Cuándo aplica | Comportamiento |
|------|---------------|----------------|
| `NO_APLICA` | Mientras la subcampaña está en BORRADOR o ACTIVA | Sin lógica especial |
| `MANTENIMIENTO_ACTIVO` | Desde el cierre (COMPLETADA o FINALIZADA_PARCIAL) hasta 3 años después | Se esperan reposiciones y reportes de pérdidas |
| `MONITOREO_HISTORICO` | Desde 3 años después del cierre en adelante | Solo seguimiento de captura de CO₂; no se esperan reposiciones, aunque se siguen aceptando |

La ventana de **3 años** es configurable a nivel sistema.

### 2.6. Mantenimiento es transversal

El mantenimiento (registro de pérdidas + reposiciones) se acepta en **todos los estados operativos posteriores a BORRADOR**:

| Estado | Plantación inicial | Pérdidas | Reposiciones | Asignación nueva |
|--------|--------------------|----------|--------------|------------------|
| BORRADOR | No | No | No | No |
| ACTIVA | Sí | Sí | Sí | Sí (cualquier propósito) |
| COMPLETADA | No | Sí | Sí | Sí (solo propósito REPOSICION) |
| FINALIZADA_PARCIAL | No | Sí | Sí | Sí (solo propósito REPOSICION) |

### 2.7. Asignación de lotes con propósito explícito

Cada asignación de lote a subcampaña lleva un campo `proposito_asignacion`:

- `PLANTACION_INICIAL`: el stock asignado se consume en plantaciones iniciales (avanzan la meta).
- `REPOSICION`: el stock asignado se consume exclusivamente en reposiciones (no avanzan la meta).

Reglas:

- Mientras la subcampaña está `ACTIVA`, se aceptan asignaciones con ambos propósitos.
- Una vez `COMPLETADA` o `FINALIZADA_PARCIAL`, solo se aceptan asignaciones con propósito `REPOSICION`.
- Una asignación con propósito `PLANTACION_INICIAL` **no puede consumirse** en una reposición y viceversa.

### 2.8. Asignación de lotes con selección explícita por el operario

El operario, al registrar una plantación, **selecciona explícitamente de qué lote(s) sale el material**. Esto reemplaza el FIFO automático que estaba en versiones anteriores del documento.

Razones:

- **Trazabilidad real al lote:** cada plantación queda vinculada a un lote concreto, no a una "asignación promedio".
- **Bonos de carbono y certificación:** los lotes pueden venir de comunidades distintas con valores narrativos diferentes.
- **Transparencia blockchain:** datos más ricos para auditoría pública.
- **Realidad operativa:** el operario ya sabe físicamente de qué cajón saca los árboles; formalizar es bajo costo.

UX simplificada:

- El operario solo elige entre lotes **asignados a su subcampaña**, no entre todos los lotes del sistema.
- Si solo hay un lote asignado para esa especie, el sistema lo **preselecciona automáticamente**.
- Si hay varios lotes, el operario indica cantidad por lote.

### 2.9. Consumo parcial con cantidad absoluta

Las asignaciones se cargan en **cantidad absoluta** (árboles) como fuente de verdad. El porcentaje sobre el saldo del lote se muestra solo como ayuda visual ("estás asignando 300 del lote, equivale al 37.5%"), no se persiste.

Una subcampaña puede consumir parcialmente varios lotes. Un lote puede asignar a varias subcampañas. Solo se valida que las asignaciones activas de un lote no superen su saldo vivo disponible.

### 2.10. Equipo de la subcampaña

El equipo se modela en la tabla puente `SUBCAMPANIA_EQUIPO` con un campo `rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`. La membresía es **contextual a la subcampaña** y no afecta el rol global del usuario en `USUARIO.rol` (ver §12).

Cada subcampaña tiene:

- **Coordinador (1, obligatorio):** exactamente un miembro con `rol_en_subcampania = 'COORDINADOR'`. Designado por el admin al activar. Gestiona la subcampaña (asigna/devuelve lotes, edita equipo, cierra parcial) y también puede operar como cualquier OPERARIO.
- **Operarios (N, opcional):** miembros con `rol_en_subcampania = 'OPERARIO'`, autorizados a registrar plantaciones, reposiciones y reportes de mortandad en esa subcampaña.

Constraint en BD: índice único parcial `(subcampania_id) where rol = 'COORDINADOR'` que garantiza exactamente 1 COORDINADOR por subcampaña. Constraint adicional `unique (subcampania_id, usuario_id)` para evitar dobles membresías.

Reglas:

- Al registrar una plantación, el `responsable_id` debe pertenecer a `SUBCAMPANIA_EQUIPO` de la subcampaña destino (sea COORDINADOR u OPERARIO).
- Los **co-responsables** del registro deben ser un **subconjunto de `SUBCAMPANIA_EQUIPO`** (no se aceptan usuarios fuera del equipo como co-responsables).
- El equipo se puede ampliar o reducir mientras la subcampaña no está terminal.
- Un mismo usuario puede ser COORDINADOR de una subcampaña y OPERARIO de otras en paralelo. La membresía no rota su rol global.

No hay porcentaje de participación entre miembros del equipo. Todos los co-responsables de un registro son tratados por igual.

### 2.11. Geolocalización dual: puntos + polígono

- **Polígono de la subcampaña (obligatorio para activar):** lo define el admin/coordinador. Representa el área certificable.
- **Puntos GPS (obligatorios):** los captura el operario en cada registro de plantación, reposición o reporte de pérdida.

El área en hectáreas se **calcula automáticamente desde el polígono** como dato referencial. No se ingresa manualmente.

### 2.12. Mix de especies (fuera del MVP)

El control de mix de especies con topes porcentuales por subcampaña queda **fuera del MVP**. La composición real de especies se registra a través de los detalles de cada `REGISTRO_PLANTACION` (`REGISTRO_PLANTACION_DETALLE.planta_id`), pero no hay validación contra un plan ni advertencias por exceso de tope. Se incorpora en una fase posterior.

Decisión cerrada 2026-05-24 (ver [tareas/.../completadas/10_docs_flujo_reposicion_y_mortandad.md](../tareas/modulo-2-integracion-modulo-3/completadas/10_docs_flujo_reposicion_y_mortandad.md)).

### 2.13. Activación con stock parcial

Una subcampaña se puede **activar sin tener el 100% del stock asignado**. Por ejemplo, meta de 10.000 árboles con solo 3.000 asignados.

El sistema:

- Permite la activación con advertencia visual clara.
- Muestra siempre el % de stock asignado respecto a la meta.
- Permite ampliar asignaciones en cualquier momento durante el estado ACTIVA.

### 2.14. Snapshots oficiales (siguiendo el patrón de M1 y M2)

Al activar una subcampaña se congelan snapshots de identidad:

- `nombre_zona_snapshot`
- `nombre_coordinador_snapshot`
- `nombres_organizaciones_snapshot` (lista)

Al registrar una plantación se congelan snapshots adicionales:

- `nombre_subcampania_snapshot`
- `nombre_responsable_snapshot`
- Por cada especie plantada, los snapshots heredados desde el lote de vivero (científico, comercial, variedad).

### 2.15. Eventos append-only

Como en los módulos anteriores, todos los eventos operativos son **append-only**: se agregan al historial y no se reescriben ni eliminan. No hay correcciones en el MVP.

### 2.16. Sin "salida de campo" en el MVP

El MVP **no modela** la fase intermedia "el operario tiene árboles en su poder". El descuento del saldo asignado y el despacho real del Módulo 2 ocurren **al registrar la plantación efectiva**.

Las devoluciones al vivero son un evento explícito sobre la asignación: el coordinador o admin puede devolver árboles asignados pero no plantados, y el saldo vuelve al lote de vivero.

---

## 3. Flujo del proceso (etapas)

### 3.1. Creación de la campaña (admin)

**Objetivo:** crear el contenedor estratégico del proyecto.

Datos mínimos:

- Nombre de la campaña (obligatorio).
- Descripción (opcional).
- **Tipo: `REFORESTACION | ARBORIZACION | FORESTACION` (obligatorio).** Define el tipo de toda subcampaña hija. Una campaña no puede mezclar tipos: si la campaña es FORESTACION, todas sus subcampañas son FORESTACION.
- Una o más organizaciones asociadas (opcional pero recomendado).
- Fecha estimada de inicio y fin global (opcional, solo referenciales).

La campaña se crea **sin subcampañas**, en estado derivado `BORRADOR` (porque todavía no tiene subcampañas activas). Las subcampañas se agregan a continuación.

El tipo de la campaña es **inmutable una vez que tiene al menos una subcampaña**. Si se necesita operar con un tipo distinto, se crea una campaña separada.

### 3.2. Creación de subcampañas (admin)

**Objetivo:** definir las unidades operativas dentro de la campaña.

Datos mínimos por subcampaña:

- Nombre de la subcampaña.
- Tipo: `REFORESTACION | ARBORIZACION | FORESTACION`. **Se hereda de la campaña padre y no es editable**; el formulario lo muestra precargado y bloqueado. Un CHECK en BD garantiza que `SUBCAMPANIA.tipo = CAMPANIA.tipo`.
- Zona o comunidad (catálogo administrativo).
- Coordinador asignado (obligatorio al activar; se materializa como fila en `SUBCAMPANIA_EQUIPO` con `rol_en_subcampania = 'COORDINADOR'`).
- Equipo de operarios (opcional al crear, ampliable después en `SUBCAMPANIA_EQUIPO`).
- Polígono del área (obligatorio para activar).
- Meta total de árboles (> 0).
- Fechas estimadas de inicio y fin (solo futuras).

En `BORRADOR`:

- Es editable libremente.
- No acepta asignaciones ni plantaciones.
- Puede eliminarse con soft delete.

### 3.3. Activación de la subcampaña (admin)

**Objetivo:** habilitar la subcampaña para operar.

Validaciones para activar:

- Polígono presente.
- Coordinador asignado (`SUBCAMPANIA_EQUIPO` con `rol_en_subcampania = 'COORDINADOR'`).
- Meta total > 0.

Si todas las validaciones pasan, la subcampaña pasa a `ACTIVA`. Si la subcampaña se activa sin stock asignado al 100%, el sistema muestra advertencia pero permite continuar.

### 3.4. Asignación de árboles desde Vivero a subcampaña

**Objetivo:** vincular stock vivo del vivero a la subcampaña operativa.

- El admin o coordinador selecciona lotes de vivero con saldo vivo disponible.
- Define la cantidad a asignar de cada lote (cantidad absoluta).
- Define el **propósito**: `PLANTACION_INICIAL` o `REPOSICION`.
- El sistema crea una `ASIGNACION_VIVERO_SUBCAMPANIA` por cada lote-subcampaña-propósito.

Restricciones:

- La cantidad asignada no puede exceder el saldo vivo disponible del lote (saldo_vivo_actual − asignaciones_activas_de_ese_lote).
- Solo se pueden asignar lotes en estado `ACTIVO` en el Módulo 2.
- Asignaciones con propósito `PLANTACION_INICIAL` solo se aceptan en subcampañas `ACTIVA`.
- Asignaciones con propósito `REPOSICION` se aceptan en `ACTIVA`, `COMPLETADA` o `FINALIZADA_PARCIAL`.

La asignación **no genera evento en el Módulo 2** porque es una reserva lógica; el saldo vivo del lote no se descuenta hasta que se planta efectivamente.

### 3.5. Devolución al vivero

**Objetivo:** liberar reservas de árboles que no se plantarán.

- Solo aplica sobre cantidad asignada pero no plantada.
- El admin o coordinador inicia la devolución indicando cantidad y motivo (obligatorio).
- El sistema:
  - Reduce el saldo asignado de la asignación.
  - Libera la reserva lógica sobre el lote de vivero.
  - Registra evento `DEVOLUCION_A_VIVERO` append-only.

No genera evento en el Módulo 2 porque los árboles nunca salieron físicamente.

### 3.6. Registro de plantación inicial (operario en campo)

**Objetivo:** registrar la plantación efectiva en una micro-ubicación.

Flujo del operario:

1. Selecciona la **subcampaña** donde va a operar.
2. Toma fotos con GPS embebido.
3. Indica especies y cantidades plantadas.
4. Para cada especie, **selecciona el lote de vivero** del cual sale el material (entre los asignados con propósito `PLANTACION_INICIAL` a esa subcampaña).
   - Si solo hay un lote disponible para esa especie, se preselecciona.
   - Si hay varios, indica cantidad por lote.
5. Selecciona co-responsables (subconjunto del equipo).
6. Observaciones opcionales.
7. Confirma.

Al guardar, el sistema:

1. Valida que la subcampaña esté `ACTIVA`.
2. Verifica que el GPS esté dentro del polígono de la subcampaña (con tolerancia configurable). PostGIS es la fuente de verdad vía `gps_dentro_poligono_con_tolerancia(subcampania_id, lat, lng)`.
3. Verifica que las cantidades por lote no superen los saldos asignados disponibles.
4. Descuenta las cantidades de cada asignación afectada.
5. Genera atómicamente un evento `DESPACHO` en `EVENTO_LOTE_VIVERO` por cada lote afectado, con:
   - `destino_tipo = PLANTACION_CAMPANIA`.
   - `origen_despacho = AUTOMATICO_PLANTACION`.
   - `registro_plantacion_id` poblado.
   - `subcampania_id` y `campania_id` para drill-down.
   - `comunidad_destino_id` heredada de `subcampania.zona_id`.
6. Congela snapshots oficiales en el registro.
7. Crea el `REGISTRO_PLANTACION` como append-only.
8. Vincula las evidencias fotográficas al `REGISTRO_PLANTACION` (el `DESPACHO` automático las hereda, ver RN-VIV-54).
9. Si la suma de plantaciones iniciales alcanza la meta, dispara **cierre automático** a `COMPLETADA`.

### 3.7. Cierre automático a COMPLETADA

Cuando `SUM(PLANTACION_INICIAL.cantidad_total) >= meta_total`:

- La subcampaña pasa automáticamente a `COMPLETADA`.
- Se congela `fecha_cierre_operativo = NOW()`.
- Se calcula `fecha_fin_mantenimiento = fecha_cierre_operativo + 3 años`.
- Se registra evento `SUBCAMPANIA_COMPLETADA` en `SUBCAMPANIA_HISTORIAL`.
- No se aceptan más plantaciones iniciales.
- Continúan permitidos: mortandad, reposición, asignaciones con propósito REPOSICION.

### 3.8. Cierre manual a FINALIZADA_PARCIAL (admin)

**Objetivo:** cerrar una subcampaña antes de alcanzar la meta.

- Solo ADMIN puede ejecutar esta acción.
- Requiere motivo obligatorio (catálogo + OTRO).
- La subcampaña pasa a `FINALIZADA_PARCIAL`.
- Se congela `fecha_cierre_operativo` y se calcula `fecha_fin_mantenimiento`.
- Se registra evento `SUBCAMPANIA_FINALIZADA_PARCIAL` en `SUBCAMPANIA_HISTORIAL`.

Comportamiento posterior idéntico a COMPLETADA: sin plantaciones iniciales, con mantenimiento permitido.

### 3.9. Reporte de pérdidas (mortandad)

**Objetivo:** registrar pérdidas observadas en visitas posteriores.

**Quién puede reportar mortandad:**

- Cualquier **OPERARIO** miembro de `SUBCAMPANIA_EQUIPO` de la subcampaña.
- El **COORDINADOR** de la subcampaña (membresía, ver §2.10).
- **ADMIN** (rol global).

No hay diferencias de permisos entre ellos para este evento.

Datos obligatorios:

- `registro_plantacion_id` del grupo afectado.
- Fecha del reporte (no futura).
- `cantidad_muerta_delta > 0` (delta desde el último reporte).
- Causa de mortandad (catálogo `causa_mortandad_plantacion` + OTRO).
- **Foto con GPS obligatoria** (mínimo 1).
- Observaciones opcionales.

El sistema:

- Muestra al usuario que reporta (sea OPERARIO, COORDINADOR o ADMIN) el histórico del grupo antes de confirmar (plantado, muertos previos, vivos estimados) para evitar doble conteo.
- Valida que `cantidad_muerta_acumulada + delta ≤ plantado_inicial + reposiciones_acumuladas`.
- Crea evento `MORTANDAD_REPORTADA` en `EVENTO_PLANTACION` append-only.
- Recalcula el saldo vivo del grupo.

Permitido en estados: `ACTIVA`, `COMPLETADA`, `FINALIZADA_PARCIAL`. También permitido durante `MONITOREO_HISTORICO` aunque no se espere activamente.

### 3.10. Registro de reposición

**Objetivo:** plantar árboles nuevos para reemplazar muertos previos.

Funciona como una plantación pero:

- Vinculada al grupo origen mediante `registro_plantacion_origen_id`.
- Flag `es_reposicion = true`.
- Solo consume asignaciones con propósito `REPOSICION`.
- **No avanza la meta** de la subcampaña.
- **Especie libre:** no se exige que la especie repuesta coincida con la del grupo origen. El operario puede usar cualquier especie disponible en asignaciones `REPOSICION` (ver `RN-VIV-60`). El grupo resultante puede quedar con composición mixta y se registra fielmente en `REGISTRO_PLANTACION_DETALLE`.

**UX de pre-confirmación (obligatoria):**

Antes de confirmar la reposición, el sistema muestra al operario el estado del grupo origen:

- `cantidad_plantada_inicial`
- `cantidad_muerta_acumulada`
- `cantidad_repuesta_acumulada`
- `cantidad_pendiente_reposicion = cantidad_muerta_acumulada − cantidad_repuesta_acumulada`

Si la cantidad ingresada por el operario excede `cantidad_pendiente_reposicion`, el sistema **bloquea el registro** con mensaje claro (no es advertencia opcional).

Validaciones específicas:

- El grupo origen debe tener mortandad reportada previamente.
- `cantidad_repuesta ≤ cantidad_muerta_acumulada − cantidad_repuesta_acumulada` del grupo.
- Permitido en `ACTIVA`, `COMPLETADA`, `FINALIZADA_PARCIAL`.
- Sin límite temporal estricto, pero el sistema diferencia visualmente las reposiciones hechas durante `MANTENIMIENTO_ACTIVO` vs `MONITOREO_HISTORICO`.

Genera el mismo flujo atómico de `DESPACHO` automático en Módulo 2 que una plantación inicial.

### 3.11. Transición automática a MONITOREO_HISTORICO

Cuando `today >= fecha_fin_mantenimiento`:

- La subcampaña pasa automáticamente de `MANTENIMIENTO_ACTIVO` a `MONITOREO_HISTORICO`.
- No cambia el estado operativo (`COMPLETADA` o `FINALIZADA_PARCIAL` se mantiene).
- Se registra evento `TRANSICION_A_MONITOREO_HISTORICO` en `SUBCAMPANIA_HISTORIAL`.
- El sistema deja de generar alertas activas de monitoreo.
- Se sigue aceptando mortandad y reposición pero ya no se esperan rutinariamente.

---

## 4. Eventos y movimientos

### 4.1. Historial de ciclo de vida de la campaña y subcampaña

`CAMPANIA_HISTORIAL`:

- `CAMPANIA_CREADA`
- `ORGANIZACION_ASOCIADA_AGREGADA`
- `ORGANIZACION_ASOCIADA_REMOVIDA`

`SUBCAMPANIA_HISTORIAL`:

- `BORRADOR_CREADO`
- `SUBCAMPANIA_ACTIVADA`
- `SUBCAMPANIA_COMPLETADA` (automático)
- `SUBCAMPANIA_FINALIZADA_PARCIAL` (manual)
- `TRANSICION_A_MONITOREO_HISTORICO` (automático por fecha)
- `EQUIPO_AMPLIADO` / `EQUIPO_REDUCIDO`
- `COORDINADOR_CAMBIADO`

### 4.2. Eventos operativos de plantación

`EVENTO_PLANTACION`:

- `ASIGNACION_VIVERO` (saldo asignado +N)
- `DEVOLUCION_A_VIVERO` (saldo asignado −N)
- `PLANTACION_INICIAL` (avanza meta)
- `REPOSICION` (no avanza meta)
- `MORTANDAD_REPORTADA` (saldo vivo del grupo −N)

Fuera del MVP:

- `CORRECCION_MORTANDAD`
- `AJUSTE_MIGRACION`
- `PAUSAR_SUBCAMPANIA` / `REACTIVAR_SUBCAMPANIA` (reservado para futuro)
- `CANCELAR_SUBCAMPANIA` (reservado para futuro)

---

## 5. Estados y dimensiones

### 5.1. Estado operativo de la subcampaña

- **BORRADOR:** editable, soft delete permitido, sin operaciones.
- **ACTIVA:** acepta todo: plantación inicial, mortandad, reposición, asignaciones.
- **COMPLETADA:** meta 100% alcanzada. No acepta plantación inicial. Acepta mortandad, reposición, asignaciones con propósito REPOSICION.
- **FINALIZADA_PARCIAL:** cerrada antes de meta. Mismo comportamiento que COMPLETADA.

Estados reservados para futuro (en enum pero sin flujos en MVP): `PAUSADA`, `CANCELADA`.

### 5.2. Fase de mantenimiento (derivada por fecha)

- **NO_APLICA:** mientras la subcampaña está en BORRADOR o ACTIVA.
- **MANTENIMIENTO_ACTIVO:** desde cierre operativo hasta 3 años después. Sistema espera monitoreo activo.
- **MONITOREO_HISTORICO:** 3+ años desde cierre. Solo seguimiento histórico.

La transición es automática por fecha, sin acción manual.

### 5.3. Estado derivado de la campaña padre

No se persiste. Se calcula en tiempo real desde las subcampañas:

| Subcampañas | Campaña se muestra como |
|-------------|-------------------------|
| Todas BORRADOR | BORRADOR |
| Al menos una ACTIVA | ACTIVA |
| Todas cerradas + al menos una en MANTENIMIENTO_ACTIVO | EN_MANTENIMIENTO |
| Todas en MONITOREO_HISTORICO | MONITOREO_HISTORICO |

### 5.4. Estado de la asignación (derivado)

- `ACTIVA`: saldo asignado disponible > 0 y subcampaña no terminal.
- `AGOTADA`: saldo asignado consumido completamente en plantaciones/reposiciones.
- `DEVUELTA`: saldo asignado devuelto al vivero.

### 5.5. Saldo vivo del grupo plantado (derivado)

`saldo_vivo_grupo = cantidad_plantada_inicial + reposiciones_acumuladas − mortandad_acumulada`

Reglas:

- Nunca puede ser negativo.
- Es la métrica clave para captura de carbono.

---

## 6. Evidencia y geolocalización

### 6.1. Fotografías

- Obligatorias en `PLANTACION_INICIAL` y `REPOSICION` (mínimo 1).
- Obligatorias en `MORTANDAD_REPORTADA` (mínimo 1).
- Formato: JPG/PNG.
- Tamaño máximo: 5 MB por foto.
- Modelo polimórfico: `EVIDENCIAS_TRAZABILIDAD` vinculadas a `EVENTO_PLANTACION.id`.

### 6.2. GPS por registro

- Latitud y longitud obligatorias en plantación, reposición y reporte de mortandad.
- Rango: latitud `[-90, 90]`, longitud `[-180, 180]`, 6 decimales.
- Validación: el punto debe estar dentro del polígono de la subcampaña con tolerancia configurable (default sugerido: 50 metros).
- Si excede la tolerancia, se bloquea el registro.

### 6.3. Polígono de la subcampaña

- Obligatorio para activar.
- GeoJSON o equivalente.
- El área en hectáreas se calcula automáticamente como referencial.
- No se ingresa manualmente un área alternativa.

---

## 7. Reglas temporales

- Fecha de plantación: no futura, hasta 10 días retroactivo.
- Fecha de reporte de mortandad: no futura, sin restricción retroactiva fuerte (las visitas pueden ser meses o años después).
- Fecha de reposición: no futura, hasta 10 días retroactivo.
- `fecha_cierre_operativo`: timestamp del cierre (automático en COMPLETADA, manual en FINALIZADA_PARCIAL).
- `fecha_fin_mantenimiento = fecha_cierre_operativo + 3 años` (ventana configurable).
- Fechas estimadas de subcampaña: solo futuras al crear.
- `created_at`, `updated_at`, `updated_by` se mantienen para entidades editables.

---

## 8. Reglas de consistencia de cantidades

### 8.1. Conservación del saldo asignado por asignación

`saldo_asignado_disponible = cantidad_asignada − cantidad_consumida − cantidad_devuelta`

Donde `cantidad_consumida` solo cuenta plantaciones/reposiciones que efectivamente consumieron de esa asignación específica.

### 8.2. Conservación del saldo plantado de la subcampaña

`plantado_inicial_subcampania = SUM(PLANTACION_INICIAL.cantidad_total)`

`progreso_meta = plantado_inicial_subcampania / meta_total`

**Las reposiciones NO cuentan para la meta**, solo para el saldo vivo del grupo origen.

Cierre automático a COMPLETADA cuando `plantado_inicial_subcampania >= meta_total`.

### 8.3. Conservación del saldo vivo por grupo

`saldo_vivo_grupo = plantado_inicial + reposiciones_sobre_grupo − mortandad_acumulada_grupo`

Por subcampaña:

`saldo_vivo_subcampania = SUM(saldo_vivo_grupo)`

---

## 9. Integración con Módulo 2 (Vivero)

### 9.1. Contrato Asignación ↔ Vivero (sin evento en M2)

- Una `ASIGNACION_VIVERO_SUBCAMPANIA` reserva saldo vivo del lote pero **no genera evento en Módulo 2**.
- El saldo disponible para nuevas asignaciones se calcula como:

`saldo_vivo_disponible_asignacion = LOTE_VIVERO.saldo_vivo_actual − SUM(asignaciones_activas_del_lote)`

### 9.2. Contrato Plantación/Reposición ↔ Despacho (con evento automático en M2)

Cada `PLANTACION_INICIAL` y `REPOSICION` genera **atómicamente** uno o más eventos `DESPACHO` en `EVENTO_LOTE_VIVERO` (uno por lote afectado), con:

- `destino_tipo = PLANTACION_CAMPANIA`.
- `origen_despacho = AUTOMATICO_PLANTACION`.
- `destino_referencia = REGISTRO_PLANTACION.id`.
- `subcampania_id` y `campania_id` para drill-down.
- `comunidad_destino_id` heredada de la subcampaña.
- `unidad_medida_evento = UNIDAD`.

Invariantes:

- `SUM(DESPACHO.cantidad_afectada) por registro_plantacion = REGISTRO_PLANTACION.cantidad_total_plantada`.
- La evidencia del despacho automático **se hereda** del REGISTRO_PLANTACION; el operario de vivero no sube fotos adicionales.

### 9.3. Contrato Devolución (sin evento en M2)

`DEVOLUCION_A_VIVERO` no genera evento en M2 porque los árboles nunca salieron físicamente. Solo libera la reserva lógica.

### 9.4. Mermas del vivero sobre saldo asignado

Cuando ocurre una merma en un lote con asignaciones activas, la política del MVP es:

1. La merma afecta primero el **saldo no asignado** del lote.
2. Si la merma excede el saldo no asignado, afecta asignaciones ordenando por `subcampania.fecha_estimada_inicio DESC NULLS FIRST` — la subcampaña con inicio más lejano absorbe primero; la más próxima queda protegida (es la más urgente).
3. Si una asignación queda con menos saldo que su comprometido, el sistema **notifica al coordinador** de la(s) subcampaña(s) afectada(s).

Esta política se documenta en el addendum del Módulo 2.

---

## 10. Auditoría y estrategia blockchain (MVP)

- El historial vive primero en base de datos.
- Anclajes blockchain candidatos:
  - `SUBCAMPANIA_ACTIVADA`
  - `PLANTACION_INICIAL`
  - `REPOSICION`
  - `SUBCAMPANIA_COMPLETADA`
  - `SUBCAMPANIA_FINALIZADA_PARCIAL`
- El anclaje es complementario. Si falla, el evento operativo permanece válido.
- Se prioriza anclar `PLANTACION_INICIAL` por ser el evento más visible públicamente.

---

## 11. Vista pública (transparencia)

Toda la información de subcampañas activas, completadas y finalizadas parciales es **pública sin autenticación**:

- Mapa interactivo con polígonos de subcampañas y pines GPS de plantaciones.
- Totalizadores: árboles plantados, captura estimada de CO₂, subcampañas activas, comunidades alcanzadas.
- Detalle por campaña con sus subcampañas, organizaciones asociadas.
- Detalle por subcampaña con barra de progreso, composición real de especies plantadas, galería de fotos, equipo participante.
- Drill-down hacia Módulo 2 (lote de vivero específico) y Módulo 1 (recolección origen).
- Las subcampañas en `BORRADOR` no son públicas.

En MVP toda la información es pública (alineado con el carácter blockchain del proyecto). Sin restricciones sobre nombres de operarios, coordinadores o ubicaciones.

---

## 12. Roles (MVP)

El catálogo cerrado de roles globales se preserva: `ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`. La coordinación de una subcampaña **no introduce un rol global nuevo**: se modela como **membresía contextual** en `SUBCAMPANIA_EQUIPO.rol_en_subcampania ENUM(COORDINADOR | OPERARIO)`.

- **ADMIN:** crea campañas y subcampañas, asigna el coordinador inicial al activar, edita equipo, cierra manualmente a FINALIZADA_PARCIAL, gestiona organizaciones.
- **COORDINADOR (membresía por subcampaña, no rol global):** cualquier USUARIO con rol global `GENERAL`, `ADMIN` o `VALIDADOR` puede ser COORDINADOR de una subcampaña a través de `SUBCAMPANIA_EQUIPO.rol_en_subcampania = 'COORDINADOR'`. Gestiona sus subcampañas asignadas (asignaciones, equipo, devoluciones, cierre parcial si tiene rol global ADMIN) y también puede operar como operario. Una subcampaña tiene **exactamente un** COORDINADOR (constraint partial unique en BD); un usuario puede ser COORDINADOR de varias subcampañas distintas y/o OPERARIO en otras simultáneamente.
- **GENERAL (operario):** rol global. Registra plantaciones, reposiciones y mortandad en las subcampañas donde es miembro de `SUBCAMPANIA_EQUIPO` (como `OPERARIO` o `COORDINADOR`).
- **VALIDADOR:** rol global de plataforma, sin flujo especial en este módulo en MVP. Puede ser COORDINADOR u OPERARIO de subcampañas vía membresía.
- **VOLUNTARIO:** sin permisos operativos críticos en M3. No puede ser miembro de `SUBCAMPANIA_EQUIPO` ni registrar eventos.

---

## 13. Alcance MVP y futuro

### MVP incluye

- Campaña con organizaciones asociadas (relación N:M).
- Subcampañas como entidades de primera clase (N por campaña).
- Estado derivado de la campaña padre desde sus subcampañas.
- Estados operativos: BORRADOR, ACTIVA, COMPLETADA, FINALIZADA_PARCIAL.
- Fase de mantenimiento derivada: NO_APLICA, MANTENIMIENTO_ACTIVO, MONITOREO_HISTORICO.
- Ventana de mantenimiento de 3 años configurable.
- Cierre automático a COMPLETADA por alcance de meta.
- Cierre manual a FINALIZADA_PARCIAL por admin con motivo.
- Mantenimiento (mortandad + reposición) transversal: permitido en ACTIVA, COMPLETADA y FINALIZADA_PARCIAL.
- Asignaciones con propósito explícito: PLANTACION_INICIAL o REPOSICION.
- Selección explícita de lote por el operario al plantar.
- Cantidad absoluta como fuente de verdad (porcentaje solo visual).
- Equipo a nivel subcampaña; co-responsables subconjunto del equipo, sin porcentajes.
- Polígono obligatorio por subcampaña; GPS validado dentro del polígono (PostGIS como fuente de verdad).
- Foto + GPS obligatorios en plantación, reposición y mortandad.
- Activación con stock parcial permitida.
- No reapertura: si se cerró parcialmente y aparece stock, se crea nueva subcampaña.
- Vista pública sin autenticación con drill-down completo.
- Eventos append-only.

### Estados reservados (en enum, no implementados)

- `PAUSADA`
- `CANCELADA`

### Catálogos cerrados del módulo (enums)

Definidos formalmente en `database/00_database_schema.md`. Los valores `OTRO` se acompañan siempre de un campo de texto libre en observaciones cuando aplique.

**`motivo_cierre_parcial`** (cierre manual de subcampaña a `FINALIZADA_PARCIAL`):

- `FALTA_STOCK`
- `PROBLEMAS_CLIMATICOS`
- `CANCELACION_CONVENIO`
- `CONFLICTO_SOCIAL`
- `ACCESO_RESTRINGIDO`
- `CAMBIO_PRIORIDAD_INSTITUCIONAL`
- `RIESGO_OPERATIVO`
- `META_REDEFINIDA`
- `CIERRE_ADMINISTRATIVO`
- `OTRO`

**`causa_mortandad_plantacion`** (reporte de pérdidas sobre grupo plantado):

- `SEQUIA`
- `EXCESO_AGUA`
- `HELADA`
- `GRANIZO`
- `PLAGA`
- `ENFERMEDAD`
- `SUELO_INADECUADO`
- `FALTA_MANTENIMIENTO`
- `DANO_MECANICO`
- `PASTOREO`
- `VANDALISMO`
- `INCENDIO`
- `COMPETENCIA_MALEZA`
- `TRASPLANTE_DEFICIENTE`
- `DESCONOCIDA`
- `OTRO`

**`motivo_devolucion_plantacion`** (devolución de árboles asignados al vivero):

- `SOBRANTE_OPERATIVO`
- `ERROR_PLANIFICACION`
- `CAMBIO_SUBCAMPANIA`
- `CIERRE_SUBCAMPANIA`
- `PROBLEMAS_CALIDAD_LOTE`
- `CONDICIONES_CAMPO_NO_APTAS`
- `ACCESO_RESTRINGIDO`
- `CANCELACION_ACTIVIDAD`
- `REASIGNACION_PRIORIDAD`
- `OTRO`

---

### Futuro

- Mix de especies por subcampaña con topes porcentuales y validación contra plan.
- Implementar PAUSADA y CANCELADA con sus flujos.
- Correcciones auditadas de mortandad y plantación.
- Trazabilidad por árbol individual (no solo por lote).
- Salida de campo modelada (árboles "en mano del operario" entre vivero y plantación).
- Offline-first para operarios en zonas sin señal.
- Polígonos dinámicos calculados desde puntos GPS plantados.
- Cálculos avanzados de captura de CO₂ por especie con curvas de crecimiento.
- Monitoreo programado con notificaciones de visitas pendientes durante MANTENIMIENTO_ACTIVO.
- Validación comunitaria de plantaciones.
- Detección automática de duplicados de GPS.
- Permisos granulares para vista pública.
- Catálogo robusto de organizaciones con metadatos (tipo, sitio web, logo).
