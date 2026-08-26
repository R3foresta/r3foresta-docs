# Capítulo II — Marco teórico y conceptual

> **Estado:** estructura inicial autorizada para desarrollo progresivo. Este capítulo deberá sustentar las decisiones del proyecto; no será un catálogo de tecnologías ni una repetición de los antecedentes o de la metodología.

## Función y límite del capítulo

El Marco teórico y conceptual desarrolla los conceptos del dominio y de Ingeniería de Software necesarios para comprender, diseñar y comprobar el producto. Además de trazabilidad, cadena de custodia e integridad, fundamenta los tres componentes adoptados para conducir el desarrollo: RUP como proceso rector, Spec-Driven Development como práctica de trabajo y la inteligencia artificial como herramienta de asistencia. El capítulo explica qué significa cada componente y cómo se relacionan; el Capítulo I establece cómo se aplicarán y el Marco aplicativo presentará la evidencia de su ejecución.

## 2.1. Material vegetal y procesos de reforestación

### 2.1.1. Material reproductivo forestal y procedencia

Definir el material vegetal considerado y la relevancia de conservar la información de origen disponible.

### 2.1.2. Etapas de recolección, vivero y plantación

Describir conceptualmente las etapas que producen cambios de estado, ubicación, responsable, agrupación o unidad de medida.

### 2.1.3. Transformación biológica observada

Explicar por qué el paso de semillas o unidades de propagación a plantas no es una conversión aritmética automática y debe registrarse como un resultado observado.

## 2.2. Trazabilidad y cadena de custodia

### 2.2.1. Definición y propósito de la trazabilidad

Comparar las definiciones pertinentes y adoptar una definición operativa para R3Foresta.

### 2.2.2. Trazabilidad interna y trazabilidad entre etapas

Explicar la diferencia y justificar la necesidad de relaciones que atraviesen Recolección, Vivero y Plantación.

### 2.2.3. Cadena de custodia

Desarrollar procedencia, transferencias, responsabilidad y límites de las declaraciones registradas.

### 2.2.4. Unidad trazable y granularidad

Definir lote, unidad de material, división, agrupación y criterios de identificación.

## 2.3. Eventos, transformaciones y procedencia

### 2.3.1. Evento de trazabilidad

Definir el hecho registrado y sus atributos mínimos: qué ocurrió, sobre qué entidad, cuándo, dónde, quién intervino y qué evidencia se asoció.

### 2.3.2. Transferencias y transformaciones

Distinguir el cambio de custodia o ubicación de la generación de una entidad resultante a partir de otra.

### 2.3.3. Relaciones de entrada y salida

Explicar cómo las relaciones entre entidades y eventos permiten reconstruir ramificaciones, agrupaciones y genealogías.

### 2.3.4. Procedencia, actividades y responsables

Desarrollar la relación entre entidades, actividades y agentes sin afirmar que el registro informático demuestra por sí mismo la verdad física.

## 2.4. Integridad de cantidades y saldos

### 2.4.1. Cantidades, unidades de medida y saldos

Definir cantidad registrada, saldo vivo, saldo disponible, cantidad reservada, merma, descarte, devolución y consumo.

### 2.4.2. Conciliación cuantitativa y doble contabilización

Explicar los principios aplicables para evitar consumos o asignaciones superiores a lo disponible y para conservar la explicación de cada cambio.

### 2.4.3. Invariantes de consistencia

Definir las propiedades que deben mantenerse antes y después de cada operación crítica.

### 2.4.4. Atomicidad y consistencia transaccional

Explicar por qué una transferencia o transformación crítica debe completarse como una unidad lógica, sin adelantar todavía el mecanismo concreto de implementación.

### 2.4.5. Diseño por contrato y trazabilidad de requerimientos

Desarrollar cómo precondiciones, poscondiciones e invariantes permiten expresar obligaciones observables de una operación y cómo la trazabilidad de requerimientos relaciona esas obligaciones con reglas, decisiones, componentes y pruebas. Mantener separadas la propiedad deseada, el mecanismo elegido y la forma de comprobarla.

## 2.5. Evidencia e información geográfica

### 2.5.1. Evidencia asociada con eventos

Definir la función de fotografías, documentos, fecha, responsable y ubicación como elementos vinculados con un registro.

### 2.5.2. Información geográfica

Desarrollar coordenadas, puntos, polígonos y criterios básicos de validez espacial pertinentes al registro de plantación.

### 2.5.3. Límites probatorios

Distinguir consistencia y recuperabilidad de la información de certificación, autenticidad forense o comprobación absoluta del hecho físico.

## 2.6. Reconstrucción y comprobación de la trazabilidad

### 2.6.1. Reconstrucción de una traza

Definir qué significa recuperar el origen, los eventos, las cantidades, los responsables, la ubicación, las pérdidas y el destino de una unidad trazable.

### 2.6.2. Completitud, coherencia y tiempo de recuperación

Definir dimensiones observables para comprobar el producto, como completitud, coherencia, evidencia recuperable y tiempo requerido para reconstruir una traza, sin presuponer superioridad frente a la práctica anterior.

### 2.6.3. Carga operativa

Definir el esfuerzo de registro y recuperación sin suponer anticipadamente que el sistema lo reducirá.

### 2.6.4. Calidad del producto software pertinente al caso

Desarrollar únicamente las características de calidad que se utilizarán para verificar o validar la solución, como adecuación funcional, fiabilidad, capacidad de interacción, seguridad y mantenibilidad. Explicar cómo cada característica se convertirá en criterios observables sin presentar ISO/IEC 25010 como una certificación del sistema.

## 2.7. Bonos de carbono y alcance de la proyección

### 2.7.1. Bonos o créditos de carbono

Definir el término incorporado al título mediante fuentes de programas o estándares reconocidos, diferenciándolo de la sola existencia de registros de plantación.

### 2.7.2. Relación indirecta con la trazabilidad operativa

Explicar qué datos de procedencia y actividad podría aportar el sistema a un proceso futuro y por qué no sustituyen una metodología de carbono, cuantificación de reducciones o remociones, monitoreo, validación, verificación ni emisión de créditos.

## 2.8. Rational Unified Process

### 2.8.1. Concepto y propósito

Rational Unified Process es un proceso configurable de ingeniería de software **dirigido por casos de uso, centrado en la arquitectura e iterativo e incremental**. Su propósito no es imponer una secuencia rígida de documentos, sino proporcionar una estructura para gestionar requisitos, riesgos, arquitectura, construcción, calidad, cambios y entrega. Los riesgos prioritarios orientan la selección y el orden del trabajo de cada iteración (Kruchten, 2004).

Que RUP sea **iterativo** significa que se vuelve sobre requisitos, diseño, código y pruebas para refinar la solución a medida que aumenta el conocimiento. La iteración es el intervalo de trabajo que recorre las disciplinas pertinentes y concluye con una revisión. Que sea **incremental** significa que la iteración produce una versión ejecutable que amplía lo construido. Por ello RUP no equivale a un ciclo secuencial de una sola pasada y tampoco necesita una capa adicional de sprints para admitir aprendizaje y entregas progresivas.

### 2.8.2. Dimensión temporal: fases e iteraciones

RUP divide el ciclo de vida en cuatro fases (Kruchten, 2004; IBM, s. f.):

1. **Inicio:** establece visión, alcance, interesados, requisitos principales, viabilidad y riesgos iniciales. Su pregunta de salida es si existe acuerdo suficiente sobre qué se construirá y por qué.
2. **Elaboración:** profundiza los requisitos significativos, establece una arquitectura base ejecutable y reduce los riesgos que podrían invalidar el proyecto. No es solamente documentación previa a programar.
3. **Construcción:** completa el producto mediante incrementos integrados y probados, manteniendo la arquitectura y gestionando cambios y defectos.
4. **Transición:** lleva el producto a su contexto de operación, corrige problemas de liberación y completa documentación, despliegue, validación y aceptación.

Las fases describen el estado de madurez del proyecto completo. Dentro de ellas existen iteraciones, pero una iteración no es sinónimo de módulo y las cuatro fases no deben repetirse artificialmente para cada módulo. R3Foresta establece una iteración de Inicio, una de Elaboración, cuatro de Construcción y una de Transición. Las cuatro iteraciones de Construcción producen incrementos que incorporan Recolección, Vivero, Plantación y sus integraciones sobre una arquitectura compartida.

### 2.8.3. Hitos de ciclo de vida

Cada fase termina con un punto de revisión:

- **LCO — Lifecycle Objectives:** confirma visión, alcance, viabilidad, riesgos y plan inicial;
- **LCA — Lifecycle Architecture:** confirma que la arquitectura base y los requisitos significativos permiten construir con un riesgo aceptable;
- **IOC — Initial Operational Capability:** confirma que la versión candidata está integrada y preparada para la transición;
- **PR — Product Release:** confirma que el producto ha satisfecho las condiciones de liberación y aceptación definidas.

Un hito no es solamente una fecha. Requiere revisar productos y criterios observables. Esta característica ofrece una defensa académica sólida porque permite mostrar por qué se avanzó de una fase a otra y qué evidencia sustentó la decisión.

### 2.8.4. Disciplinas y artefactos

RUP organiza actividades recurrentes en disciplinas como modelado del negocio, requisitos, análisis y diseño, implementación, pruebas, despliegue, gestión de configuración y cambios, gestión del proyecto y entorno. Estas disciplinas aparecen con distinta intensidad a lo largo de las fases; por ejemplo, requisitos y arquitectura dominan Elaboración, mientras implementación y pruebas adquieren mayor peso en Construcción.

Un **artefacto** es un producto de trabajo controlado: visión, modelo de casos de uso, especificación, arquitectura, código, prueba, registro de riesgo, versión o manual. RUP es configurable y no obliga a producir todos sus artefactos posibles. La adaptación debe conservar los necesarios para controlar el riesgo, comunicar decisiones, construir y demostrar el resultado.

### 2.8.5. Adaptación de RUP a R3Foresta

R3Foresta es un proyecto individual y de duración limitada. Por ello una sola persona puede desempeñar varios roles y los artefactos se consolidan para evitar burocracia. Se conservan, sin embargo, los elementos que dan rigor al proceso: fases, iteraciones, hitos, riesgos, arquitectura, requisitos, configuración, incrementos ejecutables, pruebas, integración y aceptación.

La adaptación tampoco añade ceremonias o roles de Scrum que no se utilizarán. El orden de los incrementos responde a dependencias de la cadena: M1 establece el origen propio; M2 recibe material de M1 o de procedencia externa; M3 recibe material desde M2 o por ingreso externo. La trazabilidad transversal se completa sobre los tres módulos integrados.

## 2.9. Spec-Driven Development y asistencia de inteligencia artificial

### 2.9.1. Concepto de Spec-Driven Development

Spec-Driven Development es una forma de trabajo en la que una especificación explícita y versionada precede a la implementación y actúa como referencia para planificar, construir y comprobar el software. En vez de redactar documentación después de que el código ya decidió el comportamiento, primero se expresa qué necesita el usuario, qué reglas deben preservarse, qué entradas y salidas existen, qué casos límite importan y cómo se aceptará el resultado.

El término no designa, en este proyecto, un estándar internacional ni una metodología de ciclo de vida equivalente a RUP. Se adopta como práctica operacional mediante un protocolo propio basado en el flujo central de GitHub Spec Kit —especificar, planificar, descomponer en tareas e implementar—, sin declarar adopción completa de la herramienta. La validez de una especificación depende de su claridad, revisión y correspondencia con el dominio, no de la herramienta utilizada (GitHub, 2026).

### 2.9.2. Flujo de una capacidad especificada

El flujo adoptado es:

`necesidad → requisito → especificación → diseño → tareas → implementación → pruebas → resultado → aceptación`

- la **necesidad** expresa el problema o resultado operativo buscado;
- el **requisito** establece una obligación verificable del sistema;
- la **especificación** detalla comportamiento, reglas, datos, interfaces, escenarios y criterios de aceptación;
- el **diseño** decide cómo satisfacerla dentro de la arquitectura;
- las **tareas** dividen el cambio en unidades ejecutables;
- la **implementación** materializa el comportamiento;
- las **pruebas** contrastan el producto con la especificación;
- el **resultado** conserva evidencia de conformidad o defecto;
- la **aceptación** decide si la capacidad puede cerrarse o requiere corrección.

El flujo no debe interpretarse como cascada. Una contradicción encontrada durante diseño, implementación o pruebas puede devolver el trabajo a la especificación. La diferencia es que el cambio se hace explícito y versionado antes de aceptar un comportamiento nuevo. Toda modificación aprobada actualizará la especificación y, según corresponda, el plan, las tareas y las pruebas, conservando el historial de la decisión.

### 2.9.3. Relación entre SDD y RUP

RUP y SDD resuelven niveles distintos. RUP responde **cómo se gobierna el proyecto completo**; SDD responde **cómo se trabaja una capacidad concreta dentro de una iteración**. En Inicio, SDD ayuda a convertir necesidades en requisitos y escenarios principales. En Elaboración, profundiza reglas, contratos y criterios que sostienen la arquitectura. En Construcción, guía las capacidades de cada incremento desde la especificación hasta las pruebas. En Transición, permite relacionar defectos y solicitudes de ajuste con el comportamiento aprobado.

Los artefactos SDD materializan el detalle de requisitos, diseño y planificación de las capacidades. No sustituyen los productos transversales de RUP cuya finalidad es diferente: visión, arquitectura, registro de riesgos, gestión de configuración, revisión de iteraciones, hitos y despliegue.

Esta subordinación evita presentar una suma de metodologías sin jerarquía. RUP sigue siendo el proceso rector; el desarrollo iterativo e incremental es su estrategia inherente; SDD es la práctica de especificación y ejecución; la IA es una herramienta transversal.

### 2.9.4. IA en la variante de SDD adoptada

SDD no cuenta con un estándar normativo ni con una única definición obligatoria. El referente adoptado por el proyecto, GitHub Spec Kit, sí define un flujo agentic en el que los artefactos proporcionan contexto estructurado a agentes de programación (GitHub, 2026). Por ello la IA está integrada operativamente en la variante seleccionada. Aun así, se conserva la formulación **Spec-Driven Development asistido por inteligencia artificial** para declarar con transparencia el uso de agentes y distinguirlos de la revisión y responsabilidad humanas.

La IA puede proponer preguntas para descubrir ambigüedades, alternativas de diseño, casos límite, código, migraciones, pruebas y explicaciones. También puede contrastar una modificación con una especificación y detectar posibles omisiones. Estas capacidades aceleran la exploración, pero no garantizan corrección: una salida puede inventar requisitos, desconocer una regla del dominio, introducir vulnerabilidades o producir una prueba que verifica el comportamiento equivocado.

### 2.9.5. Control humano, autoría y evidencia

La responsabilidad permanece en el postulante. Cada salida relevante de IA debe someterse a revisión del dominio, revisión técnica y pruebas ejecutadas. Las decisiones institucionales, la aprobación de requisitos, la aceptación, la interpretación de resultados y la autoría académica no se delegan. Esta separación hace explícitos los roles y responsabilidades humanos dentro de la configuración humano–IA (Tabassi, 2023).

La trazabilidad del trabajo no exige publicar conversaciones completas ni atribuir autoría a la herramienta. Requiere conservar especificaciones, decisiones, cambios, pruebas y resultados suficientes para explicar qué se hizo y por qué. Cuando la IA influya materialmente en una alternativa, se registrarán la fecha, la herramienta y el modelo o versión disponible, la tarea, el artefacto afectado, la salida adoptada, modificada o rechazada, la revisión humana, la prueba y la referencia al cambio. No se utilizará para fabricar retrospectivamente evidencia del proceso.

### 2.9.6. Riesgos y controles del uso de IA

Los riesgos principales son la generación de información falsa, la aceptación automática de código, la pérdida de coherencia entre documentación e implementación, la exposición de información sensible y la dependencia de resultados no reproducibles. Los controles correspondientes son:

- proporcionar contexto acotado y sin datos sensibles innecesarios;
- exigir correspondencia entre cambio y especificación;
- revisar diferencias y ejecutar pruebas en el entorno del proyecto;
- mantener decisiones y artefactos importantes bajo control de versiones;
- separar sugerencia de IA, decisión humana y resultado verificado;
- rechazar afirmaciones, fechas o resultados que no cuenten con evidencia real.

## 2.10. Síntesis conceptual adoptada por R3Foresta

R3Foresta adopta la trazabilidad como capacidad de reconstruir el recorrido registrado del material vegetal mediante relaciones entre unidades, eventos, cantidades, responsables, ubicaciones y evidencias. Distingue transferencias de transformaciones, preserva invariantes de cantidades y reconoce que la evidencia digital respalda un registro sin certificar por sí sola el hecho físico.

El desarrollo se gobierna con RUP adaptado. Inicio define propósito y alcance; Elaboración estabiliza arquitectura y riesgos; Construcción produce los tres módulos y sus integraciones mediante iteraciones con incrementos ejecutables; Transición valida, corrige, despliega y acepta. SDD convierte cada necesidad priorizada en una cadena versionada de especificación, diseño, tareas, implementación y pruebas. La IA apoya esas actividades, pero toda decisión y aceptación permanece bajo responsabilidad humana.

Esta combinación conecta tres niveles sin duplicarlos:

1. **RUP:** gobierno y ciclo de vida del proyecto;
2. **SDD:** práctica de trabajo para cada capacidad dentro de una iteración;
3. **IA:** asistencia transversal sometida a revisión y prueba.

La síntesis sirve como puente al Marco aplicativo, donde deberán presentarse los artefactos y resultados que demuestren la aplicación real de estos conceptos.

## Correspondencia entre proceso y fundamento conceptual

| Componente de desarrollo | Fundamento desarrollado en este capítulo | Uso posterior |
|---|---|---|
| RUP adaptado | Fases, iteraciones, hitos, disciplinas, riesgos, arquitectura y artefactos | Gobernar el proyecto y justificar el paso entre fases e iteraciones |
| Desarrollo iterativo e incremental | Iteraciones, incrementos ejecutables, integración y retroalimentación | Construir M1, M2, M3 y la trazabilidad transversal |
| Spec-Driven Development | Especificación precedente, criterios de aceptación y trazabilidad del cambio | Definir y ejecutar cada capacidad del incremento |
| Asistencia de IA | Apoyo generativo, revisión humana, autoría, riesgos y controles | Acelerar tareas sin delegar responsabilidad ni aceptación |
| Verificación técnica | Cantidades, saldos, atomicidad, consistencia y trazabilidad de requerimientos | Diseñar la matriz de pruebas críticas |
| Validación y aceptación | Completitud, coherencia, evidencia recuperable y carga de los flujos | Diseñar escenarios operativos y criterios de cierre |

La metodología del Capítulo I explica **cómo se organizará el desarrollo**; este capítulo explica **qué significan y cómo se relacionan** los conceptos adoptados. El Marco aplicativo mostrará **cómo se materializaron** en artefactos, incrementos, integraciones y resultados.

## Fuentes prioritarias para la redacción

La selección y las advertencias de uso se encuentran en:

- `03_investigacion/biblioteca_fuentes_trazabilidad_eventos_integridad.md`;
- `05_recursos/indice_fuentes_bibliograficas.md`;
- sección 7 del Perfil de Proyecto de Grado;
- Kruchten (2004) y documentación oficial de IBM para RUP;
- documentación de GitHub Spec Kit como referente práctico actual de SDD;
- Tabassi (2023), NIST AI RMF 1.0, para responsabilidades y supervisión humano–IA;
- documentación oficial del programa de acreditación seleccionado para delimitar bonos de carbono y su relación con el alcance.
