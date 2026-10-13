# Inicio de RUP: una persona de una organización registra una plantación

**Fecha:** 7 de octubre de 2026.

**Estado:** encuadre inicial de capacidad, listo para revisión; no es una spec ni cierra el hito LCO del proyecto.
**Ciclo e iteración:** capacidad candidata del incremento de Plantación; número de iteración y estimación por confirmar en la planificación del proyecto.

## Para qué sirve esta ficha

En Inicio de RUP se decide por qué vale la pena abordar la capacidad, qué resultado se busca, cuáles son sus límites, quiénes intervienen, qué riesgos pueden cambiar la solución y qué se estudiará primero. No se detallan aquí todas las reglas, pantallas, componentes o tareas de programación.

La salida alimenta SDD: la necesidad y el alcance orientan la feature; los objetivos y escenarios se descomponen en capabilities; las reglas verificables pasan a capability specs; los contratos técnicos que lo necesiten pasan a component specs. Después se preparan plan, tareas, implementación y verificación. La spec se refina cuando se aclaran decisiones: no es necesario descubrir todo en Inicio.

Completa cada pregunta con una respuesta breve y marca **Confirmado**, **Propuesto** o **Pendiente**. Añade fuente y responsable cuando ayude a resolver una duda. “No aplica” también es una respuesta válida si se explica brevemente.

## 1. Necesidad y oportunidad

**Preguntas genéricas**

- ¿Qué sucede actualmente y quién realiza el trabajo?
- ¿Qué problema, limitación o riesgo queremos reducir?
- ¿A quién afecta y con qué consecuencia observable?
- ¿Qué observación, documento o persona respalda esta necesidad?

**Escribir:** “Actualmente, [actor] realiza [actividad] de [forma actual]. Esto causa [problema/consecuencia]. La necesidad se identificó mediante [fuente].”

**Aplicado aquí — propuesto para revisar:** algunas personas participan en plantaciones organizadas por entidades aliadas. Necesitamos que puedan registrar el trabajo que realizan, con permisos y consumo de plantas coherentes con su responsabilidad, sin darles acceso ajeno a la plantación.

## 2. Objetivo, valor y evidencia de éxito

**Preguntas genéricas**

- ¿Qué resultado podrá alcanzar el actor gracias a esta capacidad?
- ¿Quién recibe valor del resultado?
- ¿Qué evidencia observable indicará que la capacidad sirve?

**Escribir:** “Permitir que [actor] logre [resultado] en [ámbito] para [beneficio]. Revisaremos el éxito observando [evidencia].”

**Aplicado aquí — objetivo propuesto:** permitir que una persona autorizada registre una plantación real en una subcampaña, asociando el registro a su responsable, evidencia y stock consumido.

**Evidencia inicial de éxito — propuesta:** una persona autorizada puede guardar un registro en su ámbito; una persona sin autorización no puede hacerlo; el stock se actualiza una sola vez y el resultado conserva autoría e historial. Las condiciones concretas de aceptación se definirán en las specs.

## 3. Alcance de la capacidad

**Preguntas genéricas**

- ¿Qué resultado y acciones mínimas quedan dentro de esta capacidad?
- ¿Qué proceso o capacidad existente se reutiliza?
- ¿En qué punto empieza y termina la responsabilidad de esta capacidad?
- ¿Qué queda expresamente fuera o se considera después?

| Categoría | Aplicado a este caso | Estado |
|---|---|---|
| Incluido inicialmente | Consultar contexto operativo, registrar una plantación y consultar el resultado guardado. | Propuesto |
| Dependencias | Identidad de usuario, autorización operativa, subcampaña, stock asignado, metas/reglas por especie y flujo vigente de registro. | Documentado; adaptación por validar |
| Fuera del objetivo central | Crear campañas, entregar plantas desde Vivero, cambiar asignaciones, procesar pagos o repartir crédito organizacional. | Propuesto; confirmar alcance |
| Evolución posible | Gestionar solicitudes, seguimiento de mortalidad/reposición y atribución organizacional detallada, si se priorizan como capacidades relacionadas. | Pendiente |

Una dependencia existente puede requerir un cambio, pero eso no significa automáticamente que todo el sistema dependiente se construya dentro de esta capacidad.

## 4. Actores y responsabilidades

**Preguntas genéricas**

- ¿Quién inicia la interacción y qué intenta lograr?
- ¿Quién autoriza o administra el acceso, si corresponde?
- ¿En qué ámbito puede actuar cada persona?
- ¿La relación entre persona y organización equivale a permiso? Si no, ¿qué relación separada habilita la acción?

| Actor o interesado | Responsabilidad en el caso | Ámbito / condición | Estado |
|---|---|---|---|
| Persona que registra | Informar una plantación que realizó o en la que participó. | Acceso válido al ámbito operativo; regla final por precisar en spec. | Propuesto |
| Organización aliada | Contexto de colaboración y posible consulta de resultados. | La membresía por sí sola no se asume como autorización. | Pendiente de confirmación de producto |
| Responsable de habilitar acceso | Determinar quién puede operar en el ámbito. | Autoridad, flujo de otorgamiento y revocación deben quedar explícitos. | Parcialmente decidido; ver fuentes |
| Sistema R3Foresta | Validar condiciones, registrar el hecho, conservar trazabilidad y reflejar el consumo que corresponda. | Dentro de reglas de negocio aprobadas. | Propuesto |

Actor significa un papel de interacción, no necesariamente un rol global ni una tabla del sistema. No inferir que pertenecer a una organización habilita a consumir stock.

## 5. Vocabulario inicial

**Preguntas genéricas:** ¿qué términos pueden confundirse?, ¿qué conceptos son diferentes aunque se relacionen?, ¿qué fuente define el uso vigente?

| Término | Uso para este encuadre |
|---|---|
| Organización | Entidad o grupo con el que una persona puede estar relacionada; su relación con la autorización operativa debe ser explícita. |
| Pertenencia / membresía | Relación entre una persona y una organización. No asumir que concede permisos. |
| Habilitación / autorización | Permiso para ejecutar una acción en un ámbito definido; detalles y correspondencia técnica van a la spec/diseño. |
| Campaña | Agrupación de trabajo; no asumir que por sí misma delimita permiso o stock. |
| Subcampaña | Ámbito operativo documentado de Plantación; confirmar que sea la unidad para este flujo. |
| Stock asignado | Plantas físicamente entregadas al ámbito operativo, disponibles bajo las reglas existentes. No es lo mismo que la pertenencia a una organización. |
| Registro de plantación | Evidencia de una actividad física, con responsable, cantidades y datos asociados por definir/refinar. |

## 6. Caso de uso a nivel de Inicio

Inicio requiere reconocer objetivos y recorridos principales, no enumerar todos los clics o errores posibles.

| Campo | Respuesta inicial |
|---|---|
| Nombre | Registrar una plantación |
| Actor principal | Persona autorizada que informa el trabajo realizado. |
| Disparador | La persona necesita dejar constancia de una plantación realizada. |
| Condiciones generales conocidas | Debe existir un ámbito operativo válido y el actor debe cumplir las condiciones de acceso que se definan. Stock, ubicación, evidencia y demás reglas vigentes deben respetarse. |
| Recorrido principal | 1. La persona elige el ámbito de trabajo. 2. Revisa información necesaria para registrar. 3. Comunica los datos de la plantación. 4. Revisa y confirma. 5. El sistema registra el resultado y lo muestra. |
| Resultado esperado | Queda una plantación consultable con atribución individual y trazabilidad; cualquier efecto de stock sigue las reglas vigentes. |
| Alternativas que importan en Inicio | Actor sin acceso; ámbito no disponible; información incompleta; stock insuficiente o cambiado; fallo que impida guardar. Comportamiento exacto por definir. |
| Pendientes | Autorización concreta, ámbito seleccionable, datos mínimos, visibilidad del resultado y tratamiento de errores/concurrencia. |

## 7. Requisitos iniciales y restricciones

**Preguntas genéricas**

- ¿Qué debe permitir y qué debe impedir el sistema?
- ¿Qué resultado e información esencial deben persistir?
- ¿Qué reglas vigentes, de seguridad, trazabilidad o integridad limitan la solución?
- ¿Qué afirmaciones están acordadas y cuáles son solo hipótesis?

| Enunciado inicial | Prioridad | Estado / fuente |
|---|---|---|
| El sistema deberá permitir registrar una plantación únicamente bajo condiciones de autorización definidas para un ámbito concreto. | Esencial | Regla detallada pendiente |
| El sistema deberá conservar quién registró la actividad y el historial pertinente. | Esencial | Compatible con la base actual; confirmar requisitos de la capacidad |
| El sistema deberá aplicar el consumo de plantas que establezca el contrato vigente entre Vivero y Plantación sin descontar dos veces el mismo stock. | Esencial | Restricción documentada; revisar contrato y flujo actual |
| La relación con una organización no deberá usarse como permiso sin una decisión explícita. | Esencial | Principio por validar/adoptar para este caso |
| Los datos, validaciones, permisos, errores, estados y criterios de aceptación precisos se definirán en capability specs. | Siguiente etapa | Acuerdo metodológico |

En Inicio se expresan resultados y límites. Dejar endpoints, esquema de tablas y diseño de componentes para elaboración/plan técnico, salvo que un riesgo requiera una prueba temprana.

## 8. Riesgos, dudas y viabilidad

**Preguntas genéricas:** ¿qué decisión podría cambiar alcance o arquitectura?, ¿qué fallo tendría más impacto?, ¿qué dependencia puede bloquear?, ¿cómo y cuándo reduciremos la incertidumbre?

| Incertidumbre inicial | Por qué importa | Cómo resolverla | Cuándo |
|---|---|---|---|
| ¿Ser miembro de la organización basta para registrar o se requiere una habilitación separada? | Determina control de acceso y modelo operativo. | Confirmación de negocio; llevar la decisión a spec y ADR si afecta permisos. | Antes de cerrar spec de autorización |
| ¿Cuál es exactamente el ámbito del permiso y cómo se obtiene? | Evita acceso cruzado y define recursos/stock visibles. | Contrastar reglas actuales con el flujo operativo acordado. | Elaboración/spec prioritaria |
| ¿Qué datos mínimos y evidencia necesita registrar la persona? | Determina formulario, validez y trazabilidad. | Revisar flujo vigente y validar con responsable de operación. | Antes de implementar formulario |
| ¿Cómo se comporta el registro ante dos operaciones concurrentes o un fallo/reintento? | Puede duplicar registros o consumir stock incorrectamente. | Especificar invariantes y probar caso de riesgo en elaboración. | Antes de construir registro definitivo |
| ¿Qué componentes y permisos actuales deben adaptarse? | El diseño vigente puede no representar el nuevo actor. | Revisar arquitectura, restricciones y hacer una prueba pequeña si hay riesgo técnico alto. | Elaboración |

La necesidad de viabilidad en Inicio es un juicio inicial: valor, límites, dependencias y riesgos parecen abordables con el proyecto. La evidencia técnica de arquitectura, prototipo o código pequeño corresponde a Elaboración cuando reduce un riesgo significativo.

## 9. Prioridad y siguiente trabajo

**Preguntas genéricas:** ¿qué subresultado aporta valor primero?, ¿qué decisión bloquea la especificación?, ¿qué dependencia debe precederlo?, ¿qué evidencia revisaremos?

| Orden inicial | Trabajo | Evidencia para avanzar |
|---|---|---|
| 1 | Confirmar quién puede registrar, en qué ámbito y quién otorga/remueve la habilitación. | Decisión de negocio trazable |
| 2 | Precisar resultado, datos mínimos, visibilidad y reglas de consumo reutilizadas. | Capability spec revisable con ejemplos y excepciones esenciales |
| 3 | Identificar si la solución requiere cambiar componentes, datos o contratos. | Plan técnico; prueba arquitectónica solo si reduce un riesgo real |
| 4 | Derivar tareas ejecutables, pruebas y responsables desde la spec y el plan. | TASKs vinculadas a spec y criterios de verificación |

La iteración y su calendario se toman del plan RUP vigente. Esta ficha no crea un ciclo ni compromete una fecha.

## 10. Revisión de Inicio y su enlace con SDD

Antes de considerar este encuadre listo para pasar a especificación, revisar:

- [ ] Se entiende el problema, el actor afectado y el valor esperado.
- [ ] El objetivo puede expresarse como resultado observable.
- [ ] El alcance, las dependencias y las exclusiones son visibles.
- [ ] Actores, organización, permiso y ámbito no están confundidos.
- [ ] El caso principal tiene inicio, resultado y alternativas importantes.
- [ ] Las decisiones abiertas tienen responsable o tratamiento próximo.
- [ ] Los riesgos principales y la viabilidad inicial se revisaron.
- [ ] Los diagramas usan los mismos términos y distinguen confirmado de pendiente.
- [ ] Se registró quién revisó y qué se decidió.

| Salida de Inicio | Se convierte después en SDD |
|---|---|
| Problema, objetivo y éxito | Contexto y propósito de la feature |
| Alcance y límites | Límites de features/capabilities y exclusiones de specs |
| Actores, responsabilidades y términos | Conceptos, actores y condiciones de las specs |
| Caso de uso y flujo de negocio | Escenarios, precondiciones, resultados y criterios verificables |
| Restricciones, dudas y riesgos | Reglas/invariantes, decisiones, preguntas de la spec y riesgos del plan |
| Prioridad inicial | Selección de capacidades para el plan de iteración |

**Registro de revisión:** fecha [ ]; revisa [ ]; decisión [avanzar a especificación / ajustar / diferir]; condiciones [ ]; evidencia [ ]. Avanzar no significa que todas las preguntas estén resueltas: las que cambian autorización, ámbito o consumo deben quedar cerradas antes de implementar el comportamiento afectado.

## Diagramas que necesitamos

Para este encuadre recomiendo **tres diagramas en Inicio**, y un cuarto como apoyo si ayuda a aclarar conceptos. No hace falta producir todos los diagramas UML posibles.

### Necesarios para Inicio

1. **Contexto y límites de la capacidad** — una vista simple del sistema, las personas/organizaciones interesadas, entradas y resultados, y las capacidades existentes de las que depende. Responde: *¿qué estamos tratando y qué queda fuera?* Marcar si la organización es actor, interesada o fuente de datos; no presentarla como autoridad de permiso hasta confirmarlo.
2. **Casos de uso de alto nivel** — actores y objetivos dentro del límite del sistema. Como mínimo, «Registrar una plantación»; añadir «Consultar resultado» o «Administrar acceso» solo si se confirman dentro del alcance. Responde: *¿quién busca qué objetivo?*
3. **Actividad / flujo de negocio principal** — 5–7 pasos como máximo para elegir ámbito, aportar información, validar a alto nivel, confirmar y obtener resultado, con finales alternativos visibles (por ejemplo, no autorizado o no registrable). Separar actividad física en campo de la interacción con la aplicación si son momentos distintos. Responde: *¿cómo ocurre el trabajo y dónde termina?*

### Recomendado como apoyo

4. **Modelo conceptual del dominio** — persona, organización, pertenencia, autorización, ámbito operativo, stock y registro de plantación; etiquetar relaciones y anotar las cardinalidades dudosas como pendientes. Responde: *¿qué conceptos no debemos confundir?* Es conceptual, no un esquema de base de datos.

### Se dejan para spec, Elaboración o plan técnico salvo riesgo concreto

| Diagrama | Momento habitual | Motivo |
|---|---|---|
| Secuencia | Capability/component spec o Elaboración | Detalla interacciones, transacciones, errores, concurrencia y consumo. |
| Estados | Spec/Elaboración | Útil si autorización, subcampaña o registro tienen transiciones relevantes que cambian acciones. |
| Entidad-relación | Diseño/Elaboración | Define persistencia, claves, cardinalidades y restricciones técnicas. |
| Componentes/despliegue | Elaboración/plan técnico | Explica responsabilidades e infraestructura; reutilizar arquitectura actual. |
| Mockup/prototipo UI | Cuando reduce dudas de interacción | Puede empezar en Inicio, pero no reemplaza objetivos, reglas ni diagramas anteriores. |

Cada diagrama debe tener título, propósito, fuente, fecha/estado y leyenda para decisiones pendientes. Si una tabla de permisos expresa la regla mejor que otro dibujo, usar la tabla.

## Contraste preliminar con la documentación existente de R3Foresta

Esto es contexto para revisar la ficha, no una decisión nueva ni una aprobación de implementación:

- En Plantación, el trabajo operativo y el stock se gestionan por subcampaña; el contrato documenta asignación física desde Vivero y consumo en Plantación.
- La documentación vigente describe membresías de equipo y roles existentes. Cualquier autorización nueva debe reconciliarse con esas reglas y restricciones.
- La ficha de capacidad en [Registro de plantaciones con autorización por persona y subcampaña](../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md) ya registra decisiones humanas sobre autorización contextual: usarla como fuente primaria de esas decisiones, evitando duplicarlas como reglas aprobadas aquí.
- Las decisiones del dominio y pendientes se siguen en [ADR-PLA-03](../../decisiones/02_decisiones_plantacion.md#adr-pla-03--autorizacion-operativa-por-persona-y-subcampana-para-participacion-aliada).
- Revisar [Contrato Vivero → Plantación](../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md) y [Reglas de Plantación](../../03-plantacion-module/01_reglas_de_negocio_plantacion.md) antes de concretar stock y validaciones.

La fuente canónica se actualiza cuando una decisión de negocio queda expresamente adoptada; el detalle implementable va en las specs posteriores.
