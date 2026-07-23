# ADR-VIV — Decisiones críticas de arquitectura de base de datos — Módulo Vivero (MVP)

> Parte del registro de decisiones del proyecto: ver [índice](README.md). Migrado desde el antiguo documento de decisiones de BD de vivero que vivía en `database/`.

## Propósito

Este documento resume únicamente las decisiones arquitectónicas que pueden generar discusión técnica al revisar o defender el modelo de base de datos del módulo **Vivero**.  
La idea no es repetir requerimientos, sino dejar explícito **qué decisiones fuertes se tomaron**, **qué alternativa se evaluó** y **por qué no se eligió** en esta fase.

---

## ADR-VIV-01 — Se eligió un modelo híbrido y no event sourcing puro

### Decisión
El modelo guarda el **estado actual del lote** en una tabla principal y el **historial** en una tabla de eventos.

### La duda crítica
“¿Por qué no reconstruir todo desde eventos?”

### Respuesta
Porque el MVP necesita operar rápido y con baja complejidad.  
Reconstruir siempre el estado desde eventos haría más costosas las consultas operativas, complicaría backend y aumentaría el esfuerzo de implementación.  
El modelo híbrido conserva trazabilidad, pero evita que toda lectura dependa de proyecciones o reconstrucción histórica.

### Lo que se sacrificó
Pureza arquitectónica de event sourcing.

### Lo que se ganó
Simplicidad, legibilidad y velocidad de implementación.

---

## ADR-VIV-02 — El lote es el agregado principal del módulo

### Decisión
Toda la arquitectura gira alrededor del **lote de vivero** como entidad central.

### La duda crítica
“¿Por qué no modelar el proceso como un flujo de registros independientes?”

### Respuesta
Porque eso fragmenta la lógica del dominio.  
El lote es la unidad que mantiene identidad, origen, estado, saldo, eventos y cierre.  
Si el modelo no gira alrededor del lote, la trazabilidad se dispersa y el sistema termina comportándose como un conjunto de formularios sueltos.

### Lo que se sacrificó
Flexibilidad para modelar cada acción como entidad semiautónoma.

### Lo que se ganó
Cohesión del dominio y menor ambigüedad estructural.

---

## ADR-VIV-03 — Cada lote de vivero tiene un solo origen

### Decisión
Un lote de vivero solo puede venir de **una recolección origen**.

### La duda crítica
“¿Por qué no permitir mezcla de orígenes?”

### Respuesta
Porque mezclar orígenes complica fuertemente la trazabilidad, la auditoría, la lógica de consumo y la interpretación del lote.  
En un MVP, aceptar mezcla introduce complejidad estructural antes de demostrar valor real.

### Lo que se sacrificó
Flexibilidad para escenarios productivos más complejos.

### Lo que se ganó
Trazabilidad fuerte, transacciones más simples y modelo más defendible.

---

## ADR-VIV-04 — Se concentró el historial en una sola tabla de eventos

### Decisión
Todos los hitos del lote viven en una sola tabla de eventos y no en una tabla distinta por cada tipo de proceso.

### La duda crítica
“¿No sería más limpio separar `EMBOLSADO`, `MERMA`, `DESPACHO` y `ADAPTABILIDAD` en tablas distintas?”

### Respuesta
No para este MVP.  
Los eventos son pocos, conocidos y controlados.  
Separarlos en muchas tablas habría aumentado joins, validaciones y complejidad sin aportar una mejora proporcional.  
Se priorizó un timeline claro y un modelo fácil de consultar y mantener.

### Lo que se sacrificó
Especialización relacional por tipo de evento.

### Lo que se ganó
Un historial uniforme, simple y más barato de implementar.

---

## ADR-VIV-05 — Los eventos son append-only

### Decisión
Los eventos no se editan una vez registrados.

### La duda crítica
“¿Por qué no permitir editar un evento si el usuario se equivocó?”

### Respuesta
Porque el evento no es solo un dato operativo; también es parte de la cadena de custodia del lote.  
Permitir edición directa del pasado debilita auditoría, complica consistencia y abre ambigüedad histórica.  
Si en el futuro se necesita corrección, deberá modelarse como ajuste explícito, no como edición del pasado.

### Lo que se sacrificó
Comodidad operativa inmediata para corregir registros.

### Lo que se ganó
Trazabilidad fuerte y coherencia histórica.

---

## ADR-VIV-06 — El saldo actual se materializa en el lote

### Decisión
El `saldo_vivo_actual` se guarda directamente en la tabla del lote.

### La duda crítica
“¿Por qué guardar saldo si puede derivarse desde eventos?”

### Respuesta
Porque el saldo es un dato operativo de lectura frecuente.  
Calcularlo siempre desde eventos sería posible, pero innecesariamente costoso y más frágil para el MVP.  
Se decidió materializarlo como proyección controlada por backend.

### Lo que se sacrificó
Normalización extrema.

### Lo que se ganó
Consultas más simples, pantallas más rápidas y menor complejidad de uso.

---

## ADR-VIV-07 — El saldo vivo nace en `EMBOLSADO`, no en `INICIO`

### Decisión
Antes del embolsado existe material en proceso, pero no saldo vivo formal del lote.

### La duda crítica
“¿Por qué no empezar a contar saldo desde el inicio?”

### Respuesta
Porque en términos operativos y semánticos no es lo mismo:
- insumo consumido del origen,
- unidades en proceso,
- y plantas vivas disponibles.

Si el modelo trata todo como una sola cantidad desde el inicio, mezcla conceptos y degrada la calidad del dato.

### Lo que se sacrificó
Un modelo cuantitativo más simple y uniforme.

### Lo que se ganó
Semántica correcta del proceso y mejor interpretación del dato.

---

## ADR-VIV-08 — Germinación no se modeló como evento independiente

### Decisión
La germinación no se registra como evento autónomo en esta versión.

### La duda crítica
“¿No debería existir como evento propio?”

### Respuesta
Podría existir, pero no era imprescindible para el MVP.  
Se evaluó y se concluyó que todavía no justificaba más estructura, más validaciones y más complejidad.  
En esta fase se absorbió dentro del tramo entre `INICIO` y `EMBOLSADO`.

### Lo que se sacrificó
Mayor granularidad histórica del proceso temprano.

### Lo que se ganó
Un modelo más simple sin afectar el núcleo de trazabilidad.

---

## ADR-VIV-09 — La creación del lote y el consumo del origen son atómicos

### Decisión
Crear el lote de vivero y descontar el origen deben ocurrir en la misma transacción lógica.

### La duda crítica
“¿Por qué no resolverlo como dos procesos desacoplados?”

### Respuesta
Porque eso abre escenarios inconsistentes:
- lote creado sin consumo real del origen,
- o consumo aplicado sin lote realmente creado.

Arquitectónicamente, ambos hechos forman una sola operación de negocio y deben tratarse como una unidad transaccional.

### Lo que se sacrificó
Separación técnica más relajada entre módulos.

### Lo que se ganó
Consistencia fuerte entre Recolección y Vivero.

---

## ADR-VIV-10 — El contrato entre Módulo 1 y Módulo 2 en `INICIO` es estricto

### Decisión
El movimiento `CONSUMO_A_VIVERO`, el `LOTE_VIVERO` y el evento `INICIO` deben persistirse con cantidades y unidades estrictamente alineadas.

### La duda crítica
“¿Por qué no dejar que cada tabla guarde su propia lectura?”

### Respuesta
Porque eso abre inconsistencias difíciles de auditar justo en el punto más sensible del proceso: el traspaso entre origen y vivero.  
Si las tres piezas no coinciden, la trazabilidad se rompe desde el arranque del lote.

### Invariantes obligatorias
Ver el enunciado completo (4 ecuaciones) en RN-VIV-17A ([`../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md`](../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md)) y RN-REC-24A ([`../01-recoleccion-module/01_reglas_de_negocio_recoleccion.md`](../01-recoleccion-module/01_reglas_de_negocio_recoleccion.md)) — fuente canónica de este contrato.

### Lo que se sacrificó
Flexibilidad para desacoplar lecturas o tolerar diferencias operativas.

### Lo que se ganó
Trazabilidad defendible y menor ambigüedad entre módulos.

---

## ADR-VIV-11 — Se adoptó una convención oficial única de unidades persistidas

### Decisión
La persistencia oficial del sistema usa solo `ENUM(unidad_medida) = [UNIDAD, G]`.

### La duda crítica
“¿Por qué no persistir también `kg` o soportar `GR` como variante?”

### Respuesta
Porque una sola convención fuerte simplifica backend, frontend, base de datos y documentación.  
`kg` es útil como entrada de usuario, pero no debe propagarse a persistencia.  
Tampoco se debe mezclar `G` con `GR`, porque eso introduce ruido semántico sin valor funcional.

### Reglas derivadas
Ver el enunciado completo en RN-VIV-17B ([`../02-vivero-module/01_reglas_de_negocio_vivero_core.md`](../02-vivero-module/01_reglas_de_negocio_vivero_core.md)) — fuente canónica de la convención de normalización y reglas numéricas.

### Lo que se sacrificó
Flexibilidad temprana para soportar más unidades.

### Lo que se ganó
Consistencia transversal y menos errores de integración.

---

## ADR-VIV-12 — La evidencia se desacopló del evento

### Decisión
La evidencia se modela como entidad separada y vinculable al evento, no como campos embebidos dentro del propio evento.

En el MVP, `INICIO`, `EMBOLSADO`, `MERMA` y `DESPACHO` requieren mínimo 1 foto. `ADAPTABILIDAD` puede registrar evidencia, pero sus subetapas pueden guardarse sin foto.

### La duda crítica
“¿Por qué no guardar los archivos directamente en columnas del evento?”

### Respuesta
Porque la evidencia tiene comportamiento propio: puede ser múltiple, reusable, versionable o transversal a otros módulos.  
Embebida dentro del evento, la estructura se vuelve rígida y poco escalable.

### Lo que se sacrificó
Simplicidad relacional inmediata.

### Lo que se ganó
Mejor diseño documental y mayor reutilización futura.

---

## ADR-VIV-13 — Blockchain es accesorio, no dependencia operativa

### Decisión
El anclaje blockchain no condiciona la validez operativa de un despacho.

### La duda crítica
“¿Por qué no hacer que el despacho dependa del registro blockchain?”

### Respuesta
Porque el MVP no debe depender de infraestructura externa para confirmar una operación core.  
Si blockchain falla, se retrasa o no responde, el negocio no puede quedar bloqueado.  
El modelo admite metadatos blockchain, pero no ata la operación principal a ese componente.

### Lo que se sacrificó
Acoplamiento fuerte con la capa de certificación externa.

### Lo que se ganó
Autonomía operativa y menor fragilidad del sistema.

---

## ADR-VIV-14 — Se privilegió semántica fuerte sobre flexibilidad prematura

### Decisión
El modelo no se diseñó para soportar todos los escenarios futuros desde el día uno.

### La duda crítica
“¿Por qué no dejarlo más genérico desde ahora?”

### Respuesta
Porque la flexibilidad temprana suele introducir ambigüedad estructural, validaciones difusas y más costo cognitivo.  
En un MVP, la prioridad no es cubrir todas las variantes posibles, sino construir una base estable, entendible y defendible.

Eso también implica dejar fuera del MVP:
- `CORRECCION` operativa una vez registrado el evento,
- persistencia de `kg`,
- conversiones automáticas entre masa y plantas vivas,
- y unidades híbridas o configurables por vivero.

### Lo que se sacrificó
Generalización temprana.

### Lo que se ganó
Claridad arquitectónica y menor riesgo de sobreingeniería.

---

## ADR-VIV-15 — El lote sin embolsado se cierra con `DESCARTE_PRE_EMBOLSADO`

### Decisión
Si un lote ya tuvo `INICIO` pero nunca llega a `EMBOLSADO`, se cierra con el evento `DESCARTE_PRE_EMBOLSADO` y el motivo de cierre `DESCARTE_PRE_EMBOLSADO`.

### La duda crítica
“¿Por qué no llamarlo `FALLO_PRE_EMBOLSADO` o tratarlo como `PERDIDA_TOTAL`?”

### Respuesta
`FALLO_PRE_EMBOLSADO` sugiere error, culpa o falla humana. El caso que se quiere modelar es operativo y tecnico: semilla que no germina, esqueje que no enraiza, contaminacion, material no viable o perdida total antes de formar plantas vivas.

Tampoco corresponde `PERDIDA_TOTAL`, porque ese motivo presupone que ya existio saldo vivo y se perdio todo por `MERMA`. Antes de `EMBOLSADO` no hay plantas vivas ni `saldo_vivo_actual`; hay material en proceso.

### Reglas derivadas

- `DESCARTE_PRE_EMBOLSADO` requiere `INICIO` previo.
- No puede registrarse si ya existe `EMBOLSADO`.
- No opera sobre saldo vivo.
- Es total sobre el material en proceso; no permite parcialidad.
- Exige causa y evidencia.
- Finaliza el lote inmediatamente.

### Lo que se sacrificó
Reusar el flujo de `MERMA` para todos los casos de perdida.

### Lo que se ganó
Semántica correcta, cierre confiable de lotes que no producen plantas vivas y reportes que no confunden material descartado con saldo vivo perdido.

---

## ADR-VIV-16 — Matriz de campos condicionados por `destino_tipo` en despacho manual; ningún tipo manual usa campaña

### Decisión
En `DESPACHO` con `origen_despacho = MANUAL`, `campania_id`, `subcampania_id` y `registro_plantacion_id` van siempre en `NULL`, para **todo** `destino_tipo` distinto de `PLANTACION_CAMPANIA` — incluyendo `PLANTACION_PROPIA`, sin excepción. El contrato backend conserva todos los valores manuales; el frontend MVP expone únicamente `DONACION`, `VENTA` y `OTRO`:

| `destino_tipo` | Campo obligatorio | Campo opcional | UI MVP |
|---|---|---|---|
| `PLANTACION_PROPIA` | `destino_referencia` (texto libre) | — | No se expone |
| `DONACION` | `comunidad_destino_id` (FK `DIVISION_ADMINISTRATIVA`) | `destino_referencia` | Donación |
| `VENTA` | `destino_referencia` (texto libre) | — | Venta |
| `OTRO` | `destino_referencia` (texto libre) | — | Otro |
| `PLANTACION_COMUNIDAD` | Reservado | — | No se expone |

### La duda crítica
"¿Por qué el formulario de despacho pedía 'Campaña destino' como obligatorio al elegir 'Plantación propia', si esa misma opción indica explícitamente que es una salida fuera de una campaña M3?"

### Respuesta
Porque el formulario no reflejaba un contrato que ya estaba cerrado: `origen_despacho = MANUAL` nunca lleva campaña (ver `90-contratos-integracion/02_contrato_vivero_a_plantacion.md` §6.4). El error no era del modelo de datos sino de un campo de UI mostrado fuera de su contexto. Para que no vuelva a pasar, se deja explícita la matriz de campo condicionado por `destino_tipo`, en vez de dejarlo implícito en la exclusión genérica de `PLANTACION_CAMPANIA`.

Decisión de producto cerrada el 2026-07-23: el formulario de Despacho manual expone solo `DONACION`, `VENTA` y `OTRO`. `DONACION` conserva la selección de comunidad y reemplaza al valor frontend inválido `DONACION_COMUNIDAD`; `PLANTACION_PROPIA` y `PLANTACION_COMUNIDAD` permanecen disponibles en el contrato backend para compatibilidad/futuro, pero no se muestran como nuevas operaciones en el MVP. `PLANTACION_CAMPANIA` sigue siendo exclusivo del flujo de asignación física a subcampaña y nunca aparece en Despacho manual.

### Lo que se sacrificó
Simplicidad de un único campo "destino" genérico para todo despacho manual.

### Lo que se ganó
Un formulario que no puede pedir un dato que el contrato prohíbe, una fuente única de verdad para el campo condicionado por tipo de destino y una separación visible entre Despacho manual y Asignación a subcampaña.

---

## Conclusión de defensa

La arquitectura no buscó ser la más abstracta ni la más extensible desde el inicio.  
Buscó resolver correctamente el núcleo del dominio con el menor nivel de complejidad posible.

Las decisiones más discutibles del modelo fueron tomadas a propósito:

- híbrido en lugar de event sourcing puro,
- origen único en lugar de mezcla,
- una sola tabla de eventos en lugar de muchas,
- saldo materializado en lugar de derivado siempre,
- germinación absorbida en lugar de formalizada,
- transacción atómica entre módulos,
- evidencia desacoplada,
- descarte pre-embolsado como cierre propio,
- y blockchain como componente accesorio.

Todas esas decisiones responden al mismo criterio:

**priorizar trazabilidad fuerte, simplicidad operativa y claridad estructural en el MVP.**
