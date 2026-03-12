# Reglas de Negocio - Modulo 2 Vivero

# Reglas de Negocio (RN) — Módulo 2: Vivero

## 1. Propósito

Estas reglas definen cómo debe comportarse el sistema frente a la realidad operativa del vivero, asegurando:

- trazabilidad fuerte,
- coherencia temporal y de cantidades,
- compatibilidad con auditoría,
- y valor real para la cadena de custodia de bonos de carbono.

Cada regla incluye:

- **Severidad:** `BLOQUEANTE | REQUIERE_SUPERVISOR | ADVERTENCIA`
- **Aplica en MVP:** `Sí | No`
- **Relevancia carbono:** `Alta | Media | Baja`

---

## 2. Definiciones base

- **Lote origen:** registro de Recolección (Módulo 1) que abastece al vivero.
- **Lote de vivero:** lote iniciado en Módulo 2 a partir de un único lote origen.
- **Cantidad consumida del origen:** cantidad descontada en Módulo 1, usando la unidad canónica del lote origen.
- **Unidades en proceso:** semillas sembradas estimadas o esquejes iniciados; no son plantas vivas aún.
- **Plantas vivas:** saldo operativo desde Embolsado.
- **Estado del lote:** `ACTIVO | FINALIZADO`
- **Estado del evento:** `PENDIENTE | COMPLETO`
- **Corrección:** tipo de evento post-validación que ajusta sin editar el pasado.
- **Evidencia de trazabilidad:** soporte auditado asociado al evento, almacenado en `evidencia_trazabilidad`.

---

## 3. Identidad y trazabilidad del lote

### RN-VIV-01 — Identificador único del lote de vivero
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Todo lote de vivero debe poseer un identificador único e inmutable generado por el sistema.

### RN-VIV-02 — Origen único del lote
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Todo lote de vivero debe estar vinculado a **un solo lote origen**.

No se permite mezclar múltiples lotes origen en un mismo lote de vivero.

### RN-VIV-03 — Prohibida la división y fusión en vivero
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

En el módulo de vivero:

- no se permite dividir un lote en sub-lotes,
- no se permite fusionar dos lotes en uno.

### RN-VIV-04 — Elegibilidad del origen para iniciar vivero
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Solo se puede iniciar un lote de vivero desde una recolección que esté:

- en estado **VERIFICADO** (o el estado formal equivalente del Módulo 1),
- operativamente habilitada para consumo,
- con saldo suficiente,
- y con identidad de planta disponible.

### RN-VIV-05 — Atomicidad entre Módulo 1 y Módulo 2
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

La creación del lote de vivero y el descuento del saldo del lote origen en Módulo 1 deben ejecutarse en **una sola transacción atómica**.

Si falla una parte, falla toda la operación.

### RN-VIV-06 — Múltiples lotes de vivero desde un mismo origen
- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

Un mismo lote origen puede abastecer a múltiples lotes de vivero, siempre que cada consumo quede registrado individualmente y el saldo se recalcule correctamente.

### RN-VIV-07 — Herencia y snapshot de la planta
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Al crear el lote de vivero se debe heredar y congelar la identidad de la planta/especie desde Módulo 1, incluyendo como mínimo:

- `planta_id`
- `nombre_cientifico_snapshot`
- `nombre_comercial_snapshot`
- `tipo_material_snapshot`

---

## 4. Flujo operativo y hitos

### RN-VIV-08 — Hitos obligatorios del ciclo mínimo
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

El flujo mínimo del lote en MVP incluye estos hitos obligatorios:

1. Inicio
2. Embolsado
3. Despacho

### RN-VIV-09 — Cambio de ambiente como evento flexible
- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Baja

El cambio de ambiente se registra como evento flexible y no constituye una etapa obligatoria ni bloqueante.

### RN-VIV-10 — Secuencialidad mínima por hitos
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

No se permite registrar:

- Embolsado sin Inicio previo
- Despacho sin Embolsado previo

### RN-VIV-11 — Embolsado como nacimiento del saldo vivo
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

El saldo de plantas vivas nace en el evento **EMBOLSADO**. Antes de ese hito solo existen unidades en proceso.

---

## 5. Estados y validación

### RN-VIV-12 — Estados del lote
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

El lote de vivero solo puede tener estos estados:

- `ACTIVO`
- `FINALIZADO`

### RN-VIV-13 — Estados del evento
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Todo evento/hito del vivero solo puede tener estos estados:

- `PENDIENTE`
- `COMPLETO`

### RN-VIV-14 — CORRECCIÓN es tipo de evento, no estado
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

La corrección posterior a la validación debe registrarse como un evento `CORRECCION`, no como un estado del lote ni del evento original.

### RN-VIV-15 — Edición permitida solo en PENDIENTE
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

Mientras un evento esté en `PENDIENTE`, se permite editarlo.

Una vez `COMPLETO`, queda bloqueado y solo puede ser ajustado mediante `CORRECCION`.

### RN-VIV-16 — Validación por evento/hito
- **Severidad:** REQUIERE_SUPERVISOR
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

La validación se realiza por evento/hito, no por lote completo.

### RN-VIV-17 — Solo supervisor puede pasar a COMPLETO
- **Severidad:** REQUIERE_SUPERVISOR
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Solo un usuario con rol de supervisor puede pasar un evento de `PENDIENTE` a `COMPLETO`.

---

## 6. Cantidades, saldos y cierres

### RN-VIV-18 — Doble lectura de cantidad en Inicio
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

El inicio del lote debe registrar simultáneamente:

- `cantidad_consumida_origen` en la unidad canónica de Módulo 1,
- y `unidades_iniciales_en_proceso` como lectura operativa del vivero.

### RN-VIV-19 — Semilla puede consumir en gramos y operar en unidades estimadas
- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

Para semilla, el consumo del origen puede mantenerse en gramos o unidades según la unidad canónica del lote origen, mientras que vivero puede registrar una cantidad estimada de semillas sembradas.

### RN-VIV-20 — Todo evento que afecte saldo vivo registra saldo antes y después
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Los eventos `EMBOLSADO`, `MERMA`, `DESPACHO` y `CORRECCION` que afecten saldo vivo deben registrar:

- `saldo_vivo_antes`
- `saldo_vivo_despues`

### RN-VIV-21 — MERMA representa pérdida explícita
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Toda pérdida operativa debe registrarse mediante un evento `MERMA` con causa, cantidad y responsable.

### RN-VIV-22 — Despachos y mermas no pueden exceder el saldo
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

La cantidad perdida o despachada no puede superar el saldo vivo disponible al momento del evento.

### RN-VIV-23 — El saldo vivo no puede ser negativo
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Ningún evento puede dejar el saldo vivo en un valor negativo.

### RN-VIV-24 — El saldo vivo solo aumenta por corrección auditada
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Un incremento del saldo vivo solo puede provenir de un evento `CORRECCION` con delta positivo y motivo obligatorio.

### RN-VIV-25 — Cierre automático por saldo vivo 0
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Cuando el saldo vivo llegue a `0`, el lote debe pasar automáticamente a estado `FINALIZADO`.

### RN-VIV-26 — Motivo de cierre obligatorio
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Todo lote finalizado debe registrar `motivo_cierre` con uno de estos valores:

- `DESPACHO_TOTAL`
- `PERDIDA_TOTAL`
- `MIXTO`

### RN-VIV-27 — Cálculo del motivo de cierre
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

La lógica de cierre debe calcular el motivo así:

- si el saldo llegó a 0 solo por despachos → `DESPACHO_TOTAL`
- si el saldo llegó a 0 sin despachos y por pérdidas/ajustes negativos → `PERDIDA_TOTAL`
- si el saldo llegó a 0 combinando despachos y pérdidas → `MIXTO`

### RN-VIV-28 — Restricción posterior al cierre
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Una vez `FINALIZADO`, el lote no admite nuevos eventos operativos normales.

Solo admite:

- consulta,
- correcciones auditadas,
- y carga de evidencia tardía cuando corresponda.

### RN-VIV-29 — Corrección posterior puede reabrir el lote
- **Severidad:** REQUIERE_SUPERVISOR
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

Si una corrección posterior deja nuevamente `saldo_vivo > 0`, el lote puede regresar a `ACTIVO`, preservando el historial íntegro del cierre anterior.

---

## 7. Evidencia de trazabilidad

### RN-VIV-30 — La evidencia se registra en evidencia_trazabilidad
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

La evidencia del vivero debe gestionarse mediante la entidad/tabla `evidencia_trazabilidad`, no como fotos aisladas sin contexto.

### RN-VIV-31 — La evidencia se asocia por evento
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Toda evidencia debe quedar vinculada al evento correspondiente para preservar auditabilidad.

### RN-VIV-32 — Despacho requiere evidencia obligatoria
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

No se permite registrar ni completar un despacho sin evidencia de trazabilidad válida.

### RN-VIV-33 — Excepción de evidencia permitida solo en eventos autorizados
- **Severidad:** REQUIERE_SUPERVISOR
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

La excepción de evidencia puede existir para eventos permitidos, pero **no aplica a despacho**.

### RN-VIV-34 — Evidencia tardía no borra el historial previo
- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

Si una evidencia se obtiene después, puede agregarse como evidencia tardía sin borrar la excepción ni alterar el historial anterior.

### RN-VIV-35 — Umbral de merma puede exigir evidencia y observación
- **Severidad:** REQUIERE_SUPERVISOR
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

Cuando una merma supere el umbral operativo configurado, el sistema debe exigir observación y puede exigir evidencia adicional según parametrización.

---

## 8. Reglas temporales

### RN-VIV-36 — Doble fecha obligatoria
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Todo evento debe registrar:

- `fecha_evento`
- `created_at`

### RN-VIV-37 — No se permiten fechas futuras
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

No se permite registrar eventos con `fecha_evento` futura.

### RN-VIV-38 — Ventana retroactiva máxima de 10 días
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

Se permite registrar eventos hasta 10 días en el pasado respecto de la fecha actual del sistema.

### RN-VIV-39 — Coherencia temporal por hitos
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

No se permite registrar un evento con fecha anterior al hito que lo habilita, salvo corrección justificada.

---

## 9. Modelo de eventos y blockchain

### RN-VIV-40 — Eventos append-only
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Los eventos del vivero se agregan al historial y no pueden sobrescribirse ni eliminarse.

### RN-VIV-41 — Hitos recomendados para anclaje blockchain
- **Severidad:** REQUIERE_SUPERVISOR
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

En el MVP se recomienda anclar al menos:

- Inicio validado
- Embolsado validado
- Cierre del lote
- Corrección que altere saldo o un hito previamente anclado

### RN-VIV-42 — No se ancla cada evento
- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

Para optimizar costos, el anclaje blockchain no se realiza por cada evento individual sino por hitos/cierres relevantes.

---

## 10. Consulta operativa y cadena de custodia

### RN-VIV-43 — Listado operativo obligatorio
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

El módulo debe permitir listar y consultar lotes por estado, vivero, planta/especie, lote origen, motivo de cierre y pendientes de validación.

### RN-VIV-44 — Cadena de custodia visible
- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

La consulta del lote debe hacer visible la secuencia:

`recolección origen → consumo → inicio → embolsado → mermas/cambios → despachos → cierre`

### RN-VIV-45 — Reportes deben distinguir cierre por pérdida vs despacho
- **Severidad:** BLOQUEANTE
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

Los reportes para auditoría/certificación deben diferenciar claramente los lotes cerrados por:

- `DESPACHO_TOTAL`
- `PERDIDA_TOTAL`
- `MIXTO`

Un cierre por pérdida total no debe interpretarse igual que uno despachado a plantación.

---

## 11. Roles mínimos

### RN-VIV-46 — Roles base del módulo
- **Severidad:** REQUIERE_SUPERVISOR
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Media

Roles mínimos:

- **Responsable:** registra eventos en `PENDIENTE`
- **Supervisor:** valida eventos, aprueba excepciones y autoriza anclajes
- **Auditor/Consulta:** lectura y trazabilidad

---

## 12. Principio rector del MVP

### RN-VIV-47 — Prioridad del dato auditable sobre la complejidad innecesaria
- **Severidad:** ADVERTENCIA
- **Aplica en MVP:** Sí
- **Relevancia carbono:** Alta

El MVP prioriza:

- origen claro,
- consumo atómico,
- identidad de planta,
- saldo vivo auditable,
- despachos trazables,
- y cierres bien clasificados,

por encima de modelados agronómicos avanzados, offline-first o multi-aprobación compleja.

---
