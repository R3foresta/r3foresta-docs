# Guía personal — metodología, IA y defensa ante tribunal

> Documento de apoyo para planificar el desarrollo y preparar la defensa. No sustituye el Perfil ni amplía la metodología declarada: **RUP adaptado** es el proceso rector; **Spec-Driven Development (SDD)** es la práctica de trabajo; y la **IA** es asistencia bajo revisión humana.

## 1. Idea central que conviene recordar

La metodología no se eligió porque la IA esté de moda. Se eligió porque R3Foresta necesita integrar tres módulos dependientes, preservar reglas de trazabilidad e integridad y demostrar el resultado mediante evidencia verificable.

La IA hace más rápida la exploración, la redacción de código y la generación de pruebas, pero también puede proponer reglas inexistentes, interpretar mal el dominio o producir cambios incompatibles. Por eso la respuesta metodológica no es “usar más IA”, sino conservar un proceso que controle requisitos, arquitectura, riesgos, integración y pruebas.

La combinación funciona así:

| Capa | Función | Pregunta que responde |
|---|---|---|
| RUP adaptado | Organiza el ciclo completo mediante fases, riesgos, arquitectura, incrementos e hitos | ¿Cuándo conviene decidir, construir, integrar y validar? |
| SDD | Convierte cada necesidad en especificación, plan, tareas, implementación y pruebas | ¿Qué debe cambiar y cómo se comprobará? |
| IA asistida | Acelera análisis, alternativas, implementación, revisión y documentación | ¿Cómo se puede avanzar más rápido sin delegar el juicio? |

La formulación más precisa para defender es: **RUP controla el proyecto; SDD controla cada capacidad; la IA apoya el trabajo, pero no decide qué es correcto.**

## 2. Comparación con alternativas

| Enfoque | Aporta | Riesgo o límite para R3Foresta | Decisión razonada |
|---|---|---|---|
| **RUP adaptado + SDD + IA** | Ciclo completo, arquitectura y riesgos tempranos, incrementos integrados, trazabilidad desde requisito hasta prueba y un lugar explícito para la IA | Puede generar burocracia si se copian todos los artefactos de RUP | **Seleccionado.** Se conserva solo la evidencia que ayuda a decidir, integrar, probar o defender el proyecto |
| Scrum + IA | Priorización y retroalimentación frecuente | Sus roles, eventos y artefactos no resuelven por sí mismos los contratos, la arquitectura ni la comprobación de invariantes; forzarlo a un proyecto individual puede volverlo ceremonial | No se adopta como proceso rector. La revisión frecuente se mantiene mediante iteraciones RUP, sin convertirlas en sprints |
| Extreme Programming (XP) + IA | Prácticas valiosas: pruebas frecuentes, integración continua, simplicidad y retroalimentación técnica | Parte de sus prácticas sociales más características no se trasladan íntegramente a este contexto; no define por sí solo la estructura académica completa | Puede inspirar prácticas puntuales de pruebas e integración, sin reemplazar RUP |
| Secuencial de una sola pasada | Orden fácil de explicar y documentación lineal | Los contratos M1→M2 y M2→M3 se descubrirían tarde; una corrección de integración puede afectar todo lo anterior | No es conveniente para un dominio con dependencias e incertidumbres técnicas |
| Ciencia del diseño / DSRM | Marco útil cuando el objetivo principal es investigar, diseñar y evaluar un artefacto como contribución investigativa | Introduce un marco investigativo adicional que no es la decisión vigente del proyecto y puede desviar el esfuerzo hacia actividades no necesarias | No se adopta. El rigor se demuestra mediante ingeniería, pruebas, validación y resultados del producto |
| ISO/IEC 29110 | Guías de proceso para entidades muy pequeñas; actividades y productos de trabajo bien definidos | Es una norma de referencia, no una metodología única; declarar conformidad elevaría la carga documental sin aportar una ventaja directa | Referencia útil, pero no se declara conformidad. RUP ofrece una narrativa más clara de riesgos, arquitectura e hitos |
| OpenUP o AUP | Versiones más ligeras del Proceso Unificado | Reducen carga, pero también ofrecen menos estructura para explicar de forma explícita la adaptación, los productos y los hitos | Alternativas válidas, pero RUP adaptado resulta más fácil de defender por su base conceptual y sus hitos reconocibles |

La comparación no pretende afirmar que las alternativas sean malas. Cada una sirve en otros contextos. La pregunta correcta no es “¿cuál es la metodología más moderna?”, sino **“cuál permite controlar mejor el riesgo y demostrar el cumplimiento del problema planteado”**.

## 3. Por qué esta combinación tiene sentido al trabajar con IA

Las herramientas actuales de SDD estructuran el trabajo en el flujo “especificar → planificar → descomponer en tareas → implementar”. La especificación da contexto durable a la IA y permite contrastar el código contra un comportamiento esperado, en vez de pedir cambios a partir de instrucciones aisladas. [GitHub Spec Kit](https://github.github.com/spec-kit/) documenta ese flujo y añade controles de consistencia entre especificación, plan y tareas.

RUP añade lo que SDD por sí solo no cubre completamente: la visión del ciclo de vida, la arquitectura compartida, la gestión de riesgos, la integración progresiva, los hitos y el despliegue. Por eso SDD no compite con RUP: trabaja dentro de cada capacidad o incremento.

La conveniencia en un entorno con IA puede resumirse así:

| Situación introducida o amplificada por IA | Respuesta de la metodología |
|---|---|
| La IA genera código muy rápido | La especificación y los criterios de aceptación definen qué código vale la pena aceptar |
| La IA puede inventar reglas o asumir datos | Las reglas, invariantes y el análisis del dominio preceden a la implementación |
| La IA puede perder coherencia en cambios grandes | Las capacidades se dividen en unidades pequeñas con plan y tareas trazables |
| La IA puede producir pruebas superficiales | La verificación se basa en propiedades comprometidas, no en que exista una prueba generada |
| La IA puede proponer una solución técnicamente cómoda pero incorrecta para el dominio | La arquitectura, los contratos entre módulos y la revisión humana limitan las alternativas aceptables |
| La rapidez facilita que documentación y código se separen | SDD obliga a actualizar la especificación, plan, tareas y pruebas cuando cambia el comportamiento |

El NIST recomienda definir y evaluar los procesos de supervisión humana de acuerdo con el contexto y el riesgo. La adopción de IA en R3Foresta se limita justamente por esa idea: se usa como asistente, mientras que las decisiones, resultados y aceptación permanecen bajo revisión humana. [NIST AI RMF 1.0](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-1.pdf)

## 4. Lo que se debe cuidar durante el desarrollo

| Riesgo | Señal de alerta | Control práctico |
|---|---|---|
| **Especificación ambigua** | La IA responde con preguntas o alternativas incompatibles entre sí | Detener la implementación; aclarar actor, precondiciones, flujo, reglas, casos límite y criterio de aceptación |
| **Deriva de alcance** | Se agregan pantallas, campos o reglas porque “parecen útiles” | Relacionar cada cambio con un requisito o decisión aprobada; lo demás se registra como pendiente o se descarta |
| **Alucinación del dominio** | Se usan términos, estados o reglas que no existen en los documentos canónicos | Verificar contra requerimientos, reglas de negocio y contratos antes de aceptar el cambio |
| **Confianza excesiva en código generado** | El cambio parece completo, pero no existe prueba de la propiedad comprometida | Revisar el cambio y ejecutar pruebas negativas, de integración y de regresión; no aceptar solo por lectura |
| **Pruebas que verifican lo equivocado** | La prueba confirma la implementación, no el requisito | Formular primero resultado esperado e invariante; luego diseñar la prueba que intentaría romperlos |
| **Cambios demasiado grandes para una sola interacción** | La IA olvida restricciones, modifica piezas no relacionadas o deja inconsistencias | Dividir la capacidad en tareas pequeñas; implementar y verificar una por vez |
| **Desalineación entre módulos** | M1, M2 y M3 funcionan de manera aislada pero no conservan procedencia, cantidades o estados | Tratar cada contrato de integración como una especificación propia y mantener pruebas de extremo a extremo |
| **Exposición de información sensible** | Se pretende copiar credenciales, datos personales, coordenadas sensibles o información institucional no autorizada en una conversación | Usar datos controlados o minimizados; no compartir secretos ni información sensible con agentes |
| **Dependencia de una herramienta o modelo** | Una salida solo es reproducible con un agente específico o cambia drásticamente entre ejecuciones | Conservar la decisión y el criterio de aceptación en documentos propios; la herramienta no debe ser la única fuente de conocimiento |
| **Confusión entre evidencia digital y realidad física** | Se afirma que una foto, coordenada o registro certifica el hecho en campo | Expresar lo comprobable: relación, consistencia, procedencia y evidencia asociada; no certificación física |
| **Documentación desactualizada** | Código y reglas vigentes difieren de la especificación o el plan | Cerrar cada capacidad actualizando los artefactos afectados antes de pasar a la siguiente |

## 5. Rutina mínima por capacidad

Esta rutina mantiene el equilibrio entre velocidad y control:

1. **Seleccionar.** Elegir una necesidad priorizada por valor, dependencia o riesgo.
2. **Especificar.** Definir propósito, actor, precondiciones, flujo, alternativas, reglas, invariantes y criterios de aceptación.
3. **Clarificar.** Resolver términos ambiguos y decisiones de dominio antes de solicitar implementación.
4. **Planificar.** Identificar datos, interfaces, contratos, migraciones, seguridad y estrategia de pruebas.
5. **Descomponer.** Crear tareas pequeñas, ordenadas y comprobables.
6. **Implementar con IA asistida.** Solicitar cambios acotados y revisar cada resultado contra la especificación.
7. **Verificar.** Ejecutar pruebas de unidad, integración, regresión y casos negativos pertinentes.
8. **Demostrar y validar.** Recorrer el escenario operativo y contrastar el resultado con los criterios de aceptación.
9. **Actualizar.** Sincronizar especificación, decisiones, tareas, pruebas, resultados y documentación.

La IA puede participar desde el paso 2 hasta el 9, pero no elimina ningún paso. Si falta una especificación o un criterio observable, lo correcto es volver atrás, no avanzar con una instrucción más larga.

## 6. Lista breve antes de pedir ayuda a la IA

- ¿Qué requisito, regla o escenario se está atendiendo?
- ¿Qué queda explícitamente fuera del cambio?
- ¿Cuál es el resultado esperado y qué invariante no puede romperse?
- ¿Qué documento canónico define el dominio?
- ¿Qué datos no se deben compartir?
- ¿Qué prueba demostraría que el cambio es correcto?
- ¿Qué documento debe actualizarse si se acepta el cambio?

Si no es posible responder estas preguntas, primero falta análisis o especificación; no falta un mejor prompt.

## 7. Cómo defenderla ante el tribunal

### Argumento principal

> Se adoptó RUP adaptado porque el proyecto requiere controlar riesgos tempranos, definir una arquitectura común y construir de forma incremental tres módulos que deben conservar trazabilidad e integridad al integrarse. SDD se utiliza dentro de RUP para que cada capacidad parta de una especificación verificable; la IA acelera tareas de análisis, implementación y pruebas, pero no reemplaza la decisión ni la comprobación humanas.

### Preguntas previsibles y respuesta base

| Pregunta | Respuesta breve y defendible |
|---|---|
| ¿Por qué RUP y no Scrum? | Porque el reto principal no es administrar sprints sino estabilizar arquitectura, reglas de integridad y contratos entre módulos. RUP organiza esas decisiones y también permite iterar e incorporar retroalimentación. |
| ¿RUP no es demasiado pesado para un proyecto individual? | Se adopta de forma adaptada: se conservan fases, riesgos, arquitectura, incrementos, pruebas e hitos; se omiten documentos y ceremonias que no aportan control ni evidencia. |
| ¿SDD es otra metodología? | No. Es una práctica subordinada a RUP que organiza el trabajo de cada capacidad desde la especificación hasta las pruebas. |
| ¿La IA desarrolló el sistema? | La IA se utilizó como asistencia. El comportamiento aceptado se define mediante especificaciones, reglas y criterios de aceptación; cada cambio se revisa y se comprueba con pruebas. |
| ¿Cómo se evita que la IA invente reglas? | Las reglas del dominio se toman de los artefactos canónicos y se expresan como invariantes y casos de prueba. Una propuesta que los contradiga se rechaza o se corrige. |
| ¿Cómo se demuestra que el sistema funciona? | Se relacionan requisitos y reglas con pruebas, resultados y escenarios operativos de validación. Además se verifica la integración M1→M2→M3 y la reconstrucción de trazas completas. |
| ¿Por qué no se usó una metodología de investigación adicional? | La modalidad es un Proyecto de Grado orientado a construir un sistema. El rigor se demuestra mediante análisis, diseño, implementación, integración, verificación, validación y evidencia de resultados, sin presentar artificialmente un estudio experimental. |
| ¿Qué limita la validación? | Demuestra el comportamiento del producto en los escenarios ejecutados y con los datos disponibles. No certifica hechos físicos, resultados ecológicos ni elegibilidad de bonos de carbono. |

## 8. Evidencia que conviene poder mostrar

No hace falta exhibir grandes cantidades de documentos. Es mejor disponer de una cadena corta, clara y coherente:

`necesidad → requisito → especificación → decisión de diseño → tarea → cambio → prueba → resultado → aceptación`

Para las reglas críticas:

`requisito → regla → invariante → mecanismo → prueba → resultado`

Ejemplos de evidencia especialmente relevantes para R3Foresta:

- una especificación de transferencia M1→M2 y la prueba de que conserva la procedencia;
- una especificación de asignación M2→M3 y la prueba de que rechaza una cantidad superior al saldo;
- una prueba de regresión que demuestre que una corrección en un módulo no rompe un recorrido anterior;
- un escenario que reconstruya origen, eventos, cantidades, responsables, evidencia y destino;
- una decisión de diseño que explique cómo se evita un estado parcial en una operación crítica.

## 9. Límites que fortalecen la defensa

Es preferible declarar con claridad lo que la metodología y el sistema **no** demuestran:

- la IA no aprueba requisitos, decisiones de dominio, pruebas ni entregas;
- los registros informáticos no certifican por sí mismos la realidad física;
- la validación no equivale a una certificación ambiental ni de carbono;
- ejecutar escenarios no prueba automáticamente una mejora causal frente a la práctica previa;
- RUP adaptado no equivale a aplicar todos los artefactos de RUP ni a declarar conformidad con una norma.

Estos límites no debilitan el trabajo. Evitan promesas que no corresponden al alcance y hacen que los resultados positivos, negativos o mixtos sean académicamente creíbles.

## 10. Referencias de apoyo

- GitHub. (2026). *GitHub Spec Kit*. https://github.github.com/spec-kit/
- GitHub. (2026). *Agentic SDD*. https://github.github.com/spec-kit/reference/agentic-sdd.html
- International Organization for Standardization. (s. f.). *ISO/IEC 29110 series*. https://committee.iso.org/sites/jtc1sc7/home/projects/flagship-standards/isoiec-29110-series.html
- Kruchten, P. (2004). *The Rational Unified Process: An introduction* (3.ª ed.). Addison-Wesley Professional.
- National Institute of Standards and Technology. (2023). *Artificial Intelligence Risk Management Framework (AI RMF 1.0)* (NIST AI 100-1). https://doi.org/10.6028/NIST.AI.100-1
- Schwaber, K., & Sutherland, J. (2020). *The Scrum Guide*. https://scrumguides.org/docs/scrumguide/v2020/2020-Scrum-Guide-US.pdf
