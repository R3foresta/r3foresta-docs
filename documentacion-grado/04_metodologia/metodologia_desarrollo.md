# Metodología de desarrollo del Proyecto de Grado

> El proyecto utilizará el **Rational Unified Process (RUP) adaptado**, complementado con **Spec-Driven Development (SDD) asistido por inteligencia artificial**.

## 1. Alcance de la decisión metodológica

La metodología organiza directamente el desarrollo del sistema. No se declara ciencia del diseño, DSRM, estudio de caso ni otro marco de investigación. La verificación y la validación previstas se entienden como actividades de Ingeniería de Software: comprobar el cumplimiento de especificaciones, integrar los módulos, ejecutar escenarios de aceptación y entregar una versión operativa.

La estructura adoptada tiene cuatro niveles complementarios:

| Nivel | Elemento | Función en el proyecto |
|---|---|---|
| Proceso rector | RUP adaptado | Define fases, disciplinas, productos, hitos y control del ciclo de vida |
| Estrategia de construcción | Iterativa e incremental, inherente a RUP | Organiza ciclos de trabajo que revisan decisiones y producen incrementos ejecutables |
| Protocolo de trabajo de cada capacidad | Spec-Driven Development | Relaciona especificación, plan técnico, tareas, implementación y pruebas |
| Herramienta de apoyo | Inteligencia artificial | Apoya el análisis, el diseño, la implementación, las pruebas y la documentación bajo revisión y aprobación humanas |

SDD no cuenta con una definición normativa única. El referente concreto adoptado, GitHub Spec Kit, presenta un flujo explícitamente orientado a agentes de IA. Por transparencia académica se conservará la formulación **SDD asistido por IA**: identifica la variante aplicada y permite separar la práctica de especificación, la herramienta que propone cambios y la revisión humana que los aprueba.

## 2. Rational Unified Process adaptado

RUP es un proceso de desarrollo **dirigido por casos de uso, centrado en la arquitectura e iterativo e incremental** que organiza el ciclo de vida en cuatro fases: **Inicio, Elaboración, Construcción y Transición**. Las disciplinas de requisitos, análisis y diseño, implementación, pruebas, despliegue, gestión del proyecto, gestión de configuración y cambios y entorno se ejecutan con diferente intensidad a lo largo de esas fases. Los riesgos prioritarios orientan el contenido y el orden de las iteraciones (Kruchten, 2004; IBM, s. f.).

En este proyecto, una **iteración** es un intervalo planificado que recorre las disciplinas pertinentes y concluye con una revisión; el **incremento** es la versión ejecutable obtenida al cerrar esa iteración. Se establece una iteración de Inicio, una de Elaboración, cuatro de Construcción y una de Transición. Las cuatro iteraciones de Construcción producen los incrementos funcionales previstos. Estas iteraciones no se denominan sprints ni incorporan roles o ceremonias de Scrum.

La adaptación para R3foresta App conserva:

- las cuatro fases y sus hitos;
- la orientación a requisitos, arquitectura y riesgos;
- el desarrollo mediante incrementos ejecutables;
- la integración y las pruebas durante la construcción;
- la gestión de cambios y versiones;
- el despliegue, la aceptación y el cierre.

Se simplifican los roles, reuniones y documentos propios de organizaciones grandes. Un producto se conservará solo cuando permita tomar una decisión, ejecutar una actividad, comprobar un resultado o reconstruir la evidencia del proceso académico.

### 2.1. Matriz de adaptación

| Elemento de RUP | Tratamiento | Artefacto previsto en el proyecto | Justificación |
|---|---|---|---|
| Visión y alcance | Conservado | Visión, alcance, actores y glosario | Delimita el producto y sustenta LCO |
| Casos de uso y requisitos | Conservado y consolidado | Casos de uso, requisitos, reglas y criterios de aceptación | Vincula necesidades, construcción y pruebas |
| Modelado del negocio | Simplificado | Análisis de los procesos Recolección, Vivero y Plantación | Se limita al dominio necesario para el sistema |
| Arquitectura | Conservado | Descripción de arquitectura, modelo de datos, contratos y decisiones | Reduce tempranamente los riesgos de integración |
| Riesgos y plan del proyecto | Conservado | Registro de riesgos, plan de iteraciones y seguimiento | Permite priorizar y justificar ajustes |
| Evaluación de la iteración e hitos | Conservado | Registro de cierre, evidencia, desviaciones y decisión | Sustenta el avance entre fases e iteraciones |
| Gestión de configuración y cambios | Conservado y simplificado | Repositorio, referencias de versión, solicitudes y decisiones de cambio | Mantiene reproducibilidad y trazabilidad |
| Pruebas | Conservado | Casos, datos, resultados, defectos y regresión | Comprueba especificaciones e invariantes |
| Despliegue | Conservado | Configuración, migraciones, manuales y versión liberada | Sustenta Transición y PR |
| Roles y reuniones de equipos grandes | Consolidados u omitidos | Revisiones necesarias | Evita simular una estructura organizacional inexistente |

### 2.2. Justificación de la selección frente a otras opciones

RUP no se selecciona por ser la alternativa más reciente ni por afirmar que sea el proceso dominante en la industria actual. Se selecciona por su ajuste a los criterios concretos del proyecto: ciclo de vida completo, tratamiento temprano de riesgos, arquitectura compartida, requisitos trazables, integración progresiva, productos verificables e hitos defendibles dentro de una ejecución individual.

| Alternativa | Fortaleza | Razón para no adoptarla como proceso rector |
|---|---|---|
| Scrum | Gestión iterativa conocida, inspección frecuente y priorización | Deja abiertas las prácticas técnicas y los artefactos de arquitectura, requisitos y pruebas; además, sus responsabilidades y eventos de equipo no se aplicarían íntegramente en una ejecución individual (Schwaber & Sutherland, 2020) |
| Extreme Programming | Prácticas técnicas fuertes y retroalimentación rápida | Varias de sus prácticas son aprovechables, pero sus prácticas sociales centrales no pueden aplicarse íntegramente en un desarrollo individual y no estructura por sí sola el ciclo de vida académico completo |
| Ciclo secuencial de una sola pasada | Orden y documentación fáciles de explicar | Resulta menos adecuado para revisar tempranamente los contratos M1→M2 y M2→M3 y para incorporar retroalimentación antes de la integración final |
| ISO/IEC 29110, perfil básico | Lineamientos de gestión e implementación para un solo equipo pequeño | Es una opción técnicamente válida, pero el proyecto no pretende declarar conformidad normativa; se priorizó un proceso gobernado explícitamente por arquitectura, riesgos, iteraciones e hitos (International Organization for Standardization, 2025) |
| OpenUP o AUP | Simplificación del Proceso Unificado | Son alternativas más ligeras, pero RUP posee una base bibliográfica y una estructura de disciplinas, artefactos e hitos más amplia para justificar explícitamente la adaptación realizada |

La selección no implica aplicar RUP completo. Un RUP sin adaptación generaría documentación y responsabilidades innecesarias; una adaptación excesiva perdería el control que justificó elegirlo. Se conservarán únicamente los elementos vinculados con riesgos, decisiones, construcción, integración, pruebas, liberación y evidencia académica. SDD y la asistencia de IA complementan la práctica cotidiana sin cambiar el proceso rector.

### 2.3. Revisión humana

La aprobación de requisitos del dominio, decisiones críticas, resultados de prueba y entregas conservará revisión humana. Cada producto contará con criterios de revisión acordes con su finalidad.

Los agentes de IA no constituyen roles RUP ni participantes con capacidad de decisión. Son herramientas de apoyo cuyo uso se controla en la sección 5.

## 3. Fases, productos e hitos

### 3.1. Inicio

**Propósito:** acordar qué se construirá, para quién, con qué límites y bajo qué planificación.

**Actividades principales:**

1. delimitar el problema, el alcance y los tres módulos;
2. identificar actores, procesos y casos de uso principales;
3. definir requisitos y restricciones de alto nivel;
4. registrar riesgos iniciales;
5. preparar el plan de fases, iteraciones, incrementos, productos y evidencias.

**Productos mínimos:** visión y alcance, glosario, modelo inicial de casos de uso, lista priorizada de trabajo, registro de riesgos y plan del proyecto.

**Hito:** **Objetivos del ciclo de vida — LCO**. Se verifica que existe acuerdo sobre alcance, objetivos, riesgos y viabilidad.

### 3.2. Elaboración

**Propósito:** establecer una arquitectura base capaz de soportar los módulos y sus integraciones antes de profundizar la construcción funcional.

**Actividades principales:**

1. detallar los escenarios y reglas de mayor riesgo;
2. modelar entidades, eventos, estados, cantidades, saldos y evidencias;
3. definir la arquitectura y el modelo de datos;
4. especificar los contratos Recolección→Vivero y Vivero→Plantación;
5. comprobar mediante un esqueleto arquitectónico los mecanismos críticos de identidad, procedencia, integridad e historial;
6. actualizar riesgos, requisitos y planificación.

**Productos mínimos:** modelo del dominio, arquitectura base, modelo de datos, contratos de integración, especificaciones priorizadas y pruebas de los riesgos arquitectónicos.

**Hito:** **Arquitectura del ciclo de vida — LCA**. Se verifica que la arquitectura es ejecutable y que los riesgos restantes permiten iniciar la construcción de los módulos.

### 3.3. Construcción

**Propósito:** desarrollar, integrar y verificar incrementalmente las capacidades comprometidas.

El primer incremento funcional corresponde a **M1 Recolección**. Los incrementos posteriores agregan **M2 Vivero**, la integración M1→M2, **M3 Plantación**, la integración M2→M3 y la reconstrucción transversal. Cada incremento conserva funcionalidad ya integrada; no se construyen tres aplicaciones aisladas para unirlas recién al final.

**Productos mínimos por incremento:** especificación, plan técnico, lista de tareas, código y migraciones, pruebas, registro de decisiones, demostración y actualización de la documentación.

**Hito:** **Capacidad operativa inicial — IOC**. Se verifica que la versión integrada reúne las capacidades necesarias para pasar a estabilización, validación y entrega.

### 3.4. Transición

**Propósito:** estabilizar, validar, desplegar y entregar el producto.

**Actividades principales:**

1. congelar la versión candidata;
2. ejecutar pruebas de sistema y regresión;
3. aplicar escenarios operativos controlados y criterios de aceptación;
4. corregir defectos de la versión candidata;
5. preparar migraciones, configuración, manuales y despliegue;
6. obtener la aceptación y cerrar el proyecto.

**Productos mínimos:** versión final, informe de pruebas y validación, configuración reproducible, manuales, registro de aceptación y documentación académica consolidada.

**Hito:** **Liberación del producto — PR**.

### 3.5. Control de los hitos

| Hito | Evidencia mínima | Revisión requerida | Decisión de salida |
|---|---|---|---|
| LCO — Objetivos del ciclo de vida | Visión, alcance, casos de uso principales, riesgos y plan | Coherencia de alcance, riesgos y viabilidad | Confirmar o ajustar el alcance y autorizar el paso a Elaboración |
| LCA — Arquitectura del ciclo de vida | Arquitectura base ejecutable, contratos, modelo de datos, riesgos técnicos y especificaciones prioritarias | Coherencia técnica, de dominio y de riesgos | Avanzar, avanzar condicionado o reprocesar riesgos de Elaboración |
| IOC — Capacidad operativa inicial | Versión candidata integrada, pruebas, defectos conocidos, manual preliminar y demostración | Cumplimiento de capacidades, integración y defectos conocidos | Pasar a Transición o devolver capacidades a Construcción |
| PR — Liberación del producto | Versión liberable, pruebas finales, configuración, manuales, incidencias residuales y registro de aceptación | Cumplimiento de criterios de aceptación y condiciones de liberación | Liberar, liberar con condiciones o reprocesar |

Cada decisión registrará evidencia revisada, resultado, condiciones pendientes y riesgos o defectos residuales aceptados. La revisión de un hito no se dará por cumplida únicamente por alcanzar una fecha del cronograma.

## 4. Spec-Driven Development asistido por IA

SDD establece que la especificación sea la fuente principal para definir qué debe construirse. El flujo central tomado como referencia de GitHub Spec Kit se resume en **especificar → planificar → descomponer en tareas → implementar**; cada producto alimenta al siguiente y proporciona contexto estructurado a los agentes de programación (GitHub, 2026). El proyecto adopta un **protocolo propio basado en ese flujo**, no declara una adopción completa de la herramienta ni conformidad con todos sus comandos.

En R3foresta App, cada capacidad priorizada dentro de una iteración seguirá este ciclo:

1. **Seleccionar:** escoger el requisito, caso de uso o riesgo priorizado.
2. **Especificar:** definir propósito, actor, precondiciones, flujo principal, alternativas, reglas, invariantes y criterios de aceptación.
3. **Clarificar y revisar:** resolver ambigüedades y obtener conformidad humana sobre el comportamiento esperado.
4. **Planificar:** definir datos, componentes, interfaces, contratos, migraciones y estrategia de pruebas.
5. **Descomponer:** convertir el plan en tareas pequeñas, ordenadas y trazables.
6. **Implementar:** construir código, migraciones y pruebas con asistencia de IA cuando corresponda.
7. **Integrar y verificar:** ejecutar pruebas unitarias, funcionales, de integración y regresión.
8. **Demostrar y revisar:** comprobar el resultado contra sus criterios de aceptación.
9. **Actualizar:** sincronizar especificación, decisiones, tareas, código, pruebas, riesgos y estado del proyecto.

### 4.1. Correspondencia entre SDD y RUP

| SDD | Disciplina RUP | Artefacto adoptado por el proyecto |
|---|---|---|
| Especificar y clarificar | Requisitos | `spec.md` o especificación equivalente con criterios de aceptación |
| Planificar | Análisis y diseño | `plan.md`, modelos y decisiones técnicas |
| Descomponer | Gestión del proyecto | `tasks.md` o lista de trabajo del incremento |
| Implementar | Implementación | Código, migraciones y documentación técnica |
| Integrar y comprobar | Implementación y pruebas | Casos, resultados y registro de defectos |
| Demostrar y aceptar | Gestión del proyecto y despliegue | Registro de revisión de la iteración y aceptación del incremento |

Los artefactos SDD materializarán los productos de requisitos, diseño detallado y planificación de cada capacidad. Los productos transversales propios de RUP —visión, arquitectura, riesgos, configuración, evaluación de iteraciones, hitos y despliegue— se conservarán por separado cuando su finalidad no esté cubierta por aquellos. Toda modificación aprobada de comportamiento actualizará la especificación y, según corresponda, el plan, las tareas y las pruebas, conservando el historial del cambio.

## 5. Uso y control de la inteligencia artificial

La asistencia se gobernará diferenciando explícitamente las funciones humanas de las herramientas y conservando responsabilidad y supervisión humanas, de acuerdo con las orientaciones generales del NIST AI RMF sobre configuraciones humano–IA (Tabassi, 2023).

Claude Code y Codex podrán apoyar:

- la identificación de ambigüedades y la descomposición de especificaciones;
- la comparación de alternativas de diseño;
- la implementación y refactorización;
- la generación y revisión de casos de prueba;
- el análisis de errores;
- la actualización de documentación.

La IA no podrá:

- aprobar requisitos o reglas del dominio;
- cambiar por sí sola el alcance;
- aceptar decisiones arquitectónicas críticas;
- declarar aprobada una prueba o un incremento;
- fabricar o alterar evidencia académica;
- autorizar el despliegue;
- sustituir la autoría y responsabilidad humanas.

Toda contribución material deberá poder relacionarse con una especificación, un cambio revisable y pruebas. Se registrará como mínimo: fecha, herramienta y modelo o versión disponible, tarea apoyada, artefacto afectado, salida adoptada, modificada o rechazada, revisión humana, prueba ejecutada y referencia al cambio o evidencia. No será necesario publicar conversaciones privadas completas. Los datos personales, coordenadas sensibles, credenciales, secretos y datos institucionales no autorizados no se proporcionarán a los agentes.

## 6. Plan temporal de fases, iteraciones e incrementos

| Periodo | Fase | Iteración | Resultado principal |
|---|---|---|---|
| 6–19 jul | Inicio | IN-1 | Alcance, actores, requisitos iniciales, riesgos y plan |
| 20 jul–16 ago | Elaboración | EL-1 | Arquitectura base, línea vertical arquitectónica mínima M1→M2→M3, modelo de datos, contratos y especificaciones prioritarias |
| 17 ago–6 sep | Construcción | CO-1 | Incremento 1: M1 Recolección funcional y probado |
| 7–27 sep | Construcción | CO-2 | Incremento 2: M2 Vivero e integración M1→M2 |
| 28 sep–18 oct | Construcción | CO-3 | Incremento 3: M3 Plantación e integración M2→M3 |
| 19 oct–1 nov | Construcción | CO-4 | Incremento 4: trazabilidad transversal, integración completa y versión candidata |
| 2–15 nov | Transición | TR-1 | Pruebas de sistema, validación operativa, despliegue, documentación y aceptación |

La documentación académica, la gestión de configuración, el control de riesgos y la trazabilidad de requisitos se ejecutarán durante todo el periodo.

## 7. Seguimiento y cadena de evidencia

El control utilizará una fila por iteración y registrará el incremento cuando corresponda:

| Iteración | Incremento o resultado | Planificado | Realizado | Evidencia | Desviación | Decisión | Riesgo residual | Estado del hito |
|---|---|---|---|---|---|---|---|---|

Cada iteración conservará, de forma proporcional a su riesgo:

- referencia de inicio y cierre;
- especificaciones y reglas abordadas;
- plan y tareas;
- decisiones relevantes;
- código y migraciones;
- pruebas y resultados;
- evaluación de la iteración y evidencia de integración o demostración;
- defectos, desviaciones y acciones correctivas.

La matriz principal será:

`necesidad → requisito → especificación → decisión de diseño → tarea → cambio → prueba → resultado → aceptación`

Para reglas críticas se mantendrá además:

`requisito → regla → invariante → mecanismo → prueba → resultado`

Los identificadores serán estables y permitirán recorridos como `OBJ-01 → CU-03 → RF-012/RN-004 → SPEC-02 → ADR-006 → TASK-031 → cambio → TC-018 → resultado → ACT-02`.

## 8. Verificación, validación y aceptación

- **Verificación:** comprueba mediante pruebas que el software satisface sus especificaciones, reglas e invariantes.
- **Validación operativa:** comprueba mediante escenarios reales disponibles o escenarios controlados identificados como tales que los flujos responden a las necesidades de R3Foresta.
- **Aceptación:** confirma al final de Transición que la versión entregada cumple los criterios acordados.

Como mínimo se verificarán: saldo no negativo; consumo no superior al disponible; transferencias consistentes M1→M2; asignaciones y consumos coherentes M2→M3; rechazo de doble consumo o asignación; ausencia de estados parciales ante fallos críticos; e historial reconstruible de extremo a extremo con evidencia asociada.

## 9. Referencias

GitHub. (2026, 21 de agosto). *GitHub Spec Kit*. https://github.github.com/spec-kit/

IBM. (s. f.). *Project planning in the Rational Unified Process*. https://www.ibm.com/docs/en/rational-clearquest/10.0.9?topic=settings-project-planning

International Organization for Standardization. (2025). *Systems and software engineering—Life cycle profiles for very small entities (VSEs)—Part 5-1-2: Software engineering guidelines for the generic Basic profile* (ISO/IEC Standard No. 29110-5-1-2:2025). https://www.iso.org/standard/82669.html

Kruchten, P. (2004). *The Rational Unified Process: An introduction* (3.ª ed.). Addison-Wesley Professional.

Schwaber, K., & Sutherland, J. (2020). *The Scrum Guide*. https://scrumguides.org/docs/scrumguide/v2020/2020-Scrum-Guide-US.pdf

Tabassi, E. (2023). *Artificial Intelligence Risk Management Framework (AI RMF 1.0)* (NIST AI 100-1). National Institute of Standards and Technology. https://doi.org/10.6028/NIST.AI.100-1
