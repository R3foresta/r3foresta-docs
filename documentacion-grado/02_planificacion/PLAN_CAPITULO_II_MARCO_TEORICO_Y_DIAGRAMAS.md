# Plan de elaboración del Capítulo II Marco teórico y conceptual

> **Estado:** actualizado el 16 de septiembre de 2026. La estructura, el inventario tecnológico, los diagramas conceptuales y la bibliografía única ya se consolidaron en Markdown; permanecen pendientes la revisión formal de la tutora, la comprobación visual en PDF y las decisiones aplicativas aún abiertas del Capítulo III.
>
> **Base de trabajo:** Perfil de Proyecto de Grado cerrado, lineamientos académicos vigentes, borrador actual del Capítulo II y metodología de desarrollo RUP adaptado con SDD asistido por IA.

## 1. Decisión de planificación

El Capítulo II no debe empezar de cero ni convertirse en un catálogo de tecnologías, diagramas o tablas de base de datos. Su función es explicar los conceptos que permiten comprender, diseñar y comprobar el sistema de trazabilidad de material vegetal de R3Foresta. La sección 2.10 se limita a un inventario descriptivo de las tecnologías reales utilizadas y de su función general.

El borrador se normaliza de 2.1 a 2.13. Después de 2.9 se incorporan 2.10 Tecnologías utilizadas, 2.11 Síntesis conceptual adoptada por R3Foresta, 2.12 Correspondencia entre proceso y fundamento conceptual y 2.13 Selección de fuentes aplicada. El inventario tecnológico y las figuras conceptuales ya se contrastaron con la documentación técnica disponible; quedan pendientes la revisión académica de las definiciones y la comprobación visual durante la maquetación. Los modelos concretos del sistema, la arquitectura, los flujos implementados y los resultados se desarrollan en el Capítulo III — Marco aplicativo.

La regla que guiará todo el capítulo es:

> **Capítulo II explica qué significan los conceptos y por qué son necesarios; Capítulo III demuestra cómo se aplicaron en R3Foresta.**

## 2. Alcance académico que no se puede alterar

| Elemento confirmado | Aplicación en el Capítulo II |
|---|---|
| Problema | Fundamentar cómo un historial integrado puede reconstruir el recorrido registrado del material vegetal. |
| Recorrido | Comienza con una recolección registrada o con un ingreso externo en Vivero o Plantación; termina con el registro de la plantación. |
| Módulos | Recolección, Vivero y Plantación. El historial de eventos es transversal; no es un cuarto módulo. |
| Datos transversales | Procedencia, lote o unidad trazable, cantidades, unidades, eventos, responsables, fechas, ubicaciones y evidencia asociada. |
| Proceso de desarrollo | RUP adaptado como proceso rector; SDD como práctica subordinada; IA como asistencia sujeta a revisión y decisión humana. |
| Exclusiones | Monitoreo posterior, supervivencia, biomasa, CO2, MRV, certificación o emisión de créditos, blockchain, NFT, IPFS, autenticidad forense y despliegue nacional. |

La evidencia debe describirse como respaldo del registro y no como prueba absoluta del hecho físico. Asimismo, la transformación biológica observada no puede presentarse como una conversión aritmética automática de semillas a plantas.

## 3. Frontera entre el Capítulo II y el Capítulo III

| Tema | Capítulo II — fundamento | Capítulo III — aplicación y evidencia |
|---|---|---|
| Trazabilidad | Definición, unidad trazable, eventos, procedencia, cadena de custodia y reconstrucción. | Modelo concreto, consultas, recorridos y resultados de escenarios. |
| Integridad | Cantidad, saldo, invariante, atomicidad, consistencia y trazabilidad de requisitos. | Reglas de negocio, mecanismos escogidos, pruebas y resultados. |
| Modelado | Entidad, relación, cardinalidad, evento, actividad, responsable y notación seleccionada. | Modelo de dominio, DER lógico y modelo físico depurado. |
| Procesos | Qué expresa un flujo, una actividad, un estado y una interacción. | Diagramas de Recolección, Vivero, Plantación y contratos M1→M2 y M2→M3. |
| Tecnologías utilizadas | Inventario descriptivo y verificable de las tecnologías reales y de su función general, sin evaluar alternativas ni justificar la arquitectura. | Uso concreto por componente, versiones cuando sean pertinentes, configuración, despliegue, dependencias y evidencia de implementación. |
| Arquitectura | Conceptos mínimos de componente, interfaz e integración si se usan después. | Componentes, despliegue, servicios, decisiones implementadas y su justificación. |
| Metodología | Significado de RUP, iteración, incremento, hito, SDD, IA, verificación, validación y aceptación. | Aplicación real por fases, artefactos, cambios, pruebas, escenarios y cierre. |

Esta separación evita dos riesgos: presentar el DER o la arquitectura como si estuvieran cerrados antes del análisis, y repetir en el Capítulo II el cronograma o los resultados que pertenecen al Marco aplicativo.

## 4. Estructura propuesta y matriz de contenido

Se conservará la estructura ya iniciada, normalizada de 2.1 a 2.13, incluido el fundamento de modelado conceptual dentro de 2.3 para sustentar el uso posterior de un DER.

| Sección | Propósito | Definiciones que se deben cerrar | Recurso conceptual propuesto | Uso posterior |
|---|---|---|---|---|
| 2.1 Material vegetal y procesos de reforestación | Determinar qué material se seguirá y hasta dónde llega el recorrido. | Material reproductivo forestal, material vegetal, procedencia, recolección, vivero, plantación, reforestación y transformación biológica observada. | Figura del recorrido físico registrado. | Alcance, modelo del dominio y reglas de ingreso. |
| 2.2 Trazabilidad y cadena de custodia | Explicar por qué un inventario aislado no basta. | Trazabilidad, trazabilidad reconstruible, trazabilidad interna y entre etapas, cadena de custodia, unidad trazable, lote y granularidad. | Cadena conceptual desde origen hasta destino registrado. | Consultas de trazabilidad y criterios de reconstrucción. |
| 2.3 Eventos, transformaciones y procedencia | Explicar cómo se representan hechos y relaciones históricas. | Evento frente a dato maestro, transferencia, transformación, entrada, salida, procedencia, entidad, actividad, agente y responsable. | Grafo entrada–evento–salida y ejemplo ER didáctico. | Modelo de dominio, eventos y relaciones entre módulos. |
| 2.3.5 Entidades, relaciones y cardinalidades | Fundar la lectura de un diagrama entidad–relación sin anticipar tablas reales. | Entidad, atributo, identificador, relación, cardinalidad, opcionalidad y entidad asociativa. | Ejemplo genérico mínimo de unidad trazable, evento y participación. | DER lógico del Capítulo III. |
| 2.4 Integridad de cantidades y saldos | Precisar las propiedades que el sistema debe conservar. | Cantidad, unidad de medida, saldo, asignación, consumo, devolución, merma, descarte, doble contabilización, invariante, precondición, poscondición, atomicidad y consistencia. | Comparación transferencia–transformación y tabla propiedad–mecanismo–prueba. | Reglas, contratos y matriz de pruebas. |
| 2.5 Evidencia e información geográfica | Explicar el valor y el límite de fotos, documentos, puntos y polígonos. | Evidencia asociada, metadato, ubicación, punto, polígono y límite probatorio. | Relación evento–evidencia–ubicación. | Campos, validaciones espaciales y recuperación de evidencia. |
| 2.6 Reconstrucción y comprobación | Establecer cómo se juzgará útil una traza. | Reconstrucción, completitud, coherencia, tiempo de recuperación, carga operativa, calidad pertinente, verificación, validación y aceptación. | Cadena de reconstrucción y criterios observables. | Escenarios, matriz de pruebas y acta de aceptación. |
| 2.7 Bonos de carbono y alcance de la proyección | Delimitar con precisión el término del título. | Crédito de carbono, línea base, MRV, cuantificación, validación, verificación y emisión. | Frontera entre datos preservados y actividades excluidas. | Límites del proyecto y discusión final. |
| 2.8 Rational Unified Process | Fundamentar el proceso rector sin repetir el cronograma. | Proceso, fase, iteración, incremento, hito, disciplina, artefacto, riesgo, casos de uso y arquitectura. | Esquema fase–iteración–incremento, solo si mejora la tabla vigente. | Presentación de la ejecución del proyecto. |
| 2.9 SDD e IA | Distinguir práctica de trabajo, herramientas y responsabilidad humana. | Necesidad, requisito, especificación, criterio de aceptación, plan, tarea, cambio, prueba, trazabilidad de requisitos, asistencia de IA, revisión humana y autoría. | Cadena necesidad→requisito→prueba y mapa RUP–SDD–IA. | Evidencias de cada capacidad e iteración. |
| 2.10 Tecnologías utilizadas | Identificar únicamente las tecnologías reales empleadas por la solución y su función general. | Plataforma, lenguaje, frontend, backend, persistencia, geografía, almacenamiento y herramientas verificadas en los documentos canónicos. | Inventario breve, sin diagrama arquitectónico ni comparación de alternativas. | Contextualizar la implementación sin reemplazar la arquitectura del Capítulo III. |
| 2.11 Síntesis conceptual adoptada por R3Foresta | Unir el dominio, las propiedades y el proceso de desarrollo. | Relación entre conceptos ya definidos; no añadir jerga nueva. | Síntesis narrativa. | Puente explícito al Capítulo III. |
| 2.12 Correspondencia entre proceso y fundamento conceptual | Mostrar qué fundamento sustenta cada componente del proceso de desarrollo. | Relación entre RUP, SDD, IA, verificación, validación y aceptación. | Tabla de correspondencia revisada. | Trazar la transición hacia los artefactos y resultados del Capítulo III. |
| 2.13 Selección de fuentes aplicada | Declarar el criterio de incorporación de fuentes y su relación con el texto. | Fuente pertinente, lectura, función y límite de transferencia. | Referencia al registro de selección, sin duplicar bibliografía. | Preparar la bibliografía única del documento completo. |

## 5. Plan de fuentes

### 5.1 Principio de selección

No todas las definiciones deben provenir de libros. Para el dominio forestal, estándares, trazabilidad, información geográfica o créditos de carbono, las fuentes primarias y normativas tienen mayor pertinencia que un texto general. Los libros se usarán principalmente para fundamentos de bases de datos, notaciones de modelado, requisitos y proceso de software.

Cada definición se documentará antes de redactarse mediante una ficha con estos campos:

| Campo de la ficha | Pregunta que debe responder |
|---|---|
| Término | ¿Qué expresión se definirá? |
| Razón | ¿Qué problema, objetivo, regla o figura del proyecto necesita ese término? |
| Fuente | ¿Cuál es la fuente primaria o libro más adecuado? |
| Localizador | ¿Qué página, capítulo, sección o cláusula respalda la paráfrasis? |
| Paráfrasis | ¿Cómo se explicará sin copiar la fuente? |
| Definición adoptada | ¿Qué significa exactamente dentro de R3Foresta? |
| Límite | ¿Qué no permite afirmar o implementar esa definición? |
| Reutilización | ¿En qué sección, figura o artefacto posterior se aplicará? |

No se citará una fuente cuya lectura completa siga pendiente para sostener una afirmación específica.

### 5.2 Fuentes ya seleccionadas que se deben leer y fichar

| Grupo | Fuente prioritaria | Uso limitado |
|---|---|---|
| Dominio forestal | FAO, *Forest reproductive material* y definiciones FRA. | Material reproductivo, procedencia, vivero, plantación y reforestación. |
| Trazabilidad | Olsen y Borit; Moe; Dabbene; ISO 22095. | Definición, unidad trazable, granularidad, cadena de custodia y sus límites. |
| Eventos y procedencia | Thakur et al.; GS1 EPCIS/CBV; Solanki y Brewster; W3C PROV-O. | Evento, entrada–salida, transferencia, transformación, entidad, actividad, agente y responsable. |
| Integridad | ISO 22095-2; Härder y Reuter; Meyer; Gotel y Finkelstein. | Cantidades, invariantes, atomicidad, contrato y trazabilidad de requisitos. |
| Geografía y comprobación | OGC Simple Features; Donnelly et al.; ISO/IEC 25010. | Punto, polígono, reconstrucción, criterios de calidad y escenarios. |
| Proyección climática | ISO 14064-2 y Verra. | Delimitar créditos y separar el sistema de MRV o certificación. |
| Metodología | Kruchten; IBM; GitHub Spec Kit; NIST AI RMF. | RUP, SDD, control humano y asistencia de IA. |
| Tecnologías reales | `ARCHITECTURE.md`, estado técnico, manifiestos y documentación canónica de los módulos. | Inventario descriptivo de 2.10; no convertir estas fuentes internas en fundamento conceptual ni en una comparación de alternativas. |

### 5.3 Libros complementarios para diagramas y diseño

Solo se incorporarán después de decidir que su notación será utilizada. Se debe verificar la edición disponible, leer el capítulo pertinente y registrar el localizador exacto antes de citar.

| Necesidad | Libro o fuente candidata | Términos que cubriría |
|---|---|---|
| Modelo ER y diseño de datos | Elmasri y Navathe, *Fundamentals of Database Systems*. | Entidad, atributo, clave, relación, cardinalidad, participación y entidad asociativa. |
| Transacciones y concurrencia | Silberschatz, Korth y Sudarshan, *Database System Concepts*. | Transacción, atomicidad, consistencia, aislamiento y concurrencia. |
| UML | Fowler, *UML Distilled*, complementado por la especificación OMG UML. | Caso de uso, actividad, estado, secuencia, componente y despliegue. |
| Procesos si se selecciona BPMN | Dumas et al., *Fundamentals of Business Process Management*. | Evento, actividad, compuerta, flujo y carril. |
| Requisitos | Wiegers y Beatty, *Software Requirements*. | Requisito, especificación, criterio de aceptación y trazabilidad. |

La recomendación inicial es usar **UML más DER** y no añadir BPMN, salvo que la tutora lo pida. Un diagrama de actividad UML puede expresar los flujos necesarios sin duplicar los mismos procesos en dos notaciones distintas.

## 6. Plan de figuras y tablas del Capítulo II

La cantidad debe mantenerse contenida: una figura solo se incluye si aclara una relación que el texto no puede comunicar con igual economía. Todas las figuras y tablas llevarán título, numeración, llamada en el texto y nota de procedencia. Las tablas seguirán la estructura APA 7 de número destacado, título en cursiva, nota cuando corresponda y tres líneas horizontales principales, sin líneas verticales ni cuadriculado completo; el encabezado se repetirá en continuaciones y la orientación horizontal se reservará para las tablas demasiado anchas.

| Prioridad | Figura o tabla | Propósito | Ubicación |
|---|---|---|---|
| Alta | Figura 2.1 Recorrido conceptual del material vegetal | Mostrar origen registrado, ingreso externo, manejo cuando corresponda y plantación registrada, con datos transversales. | 2.1–2.2 |
| Alta | Figura 2.2 Transferencia y transformación | Distinguir una salida o movimiento directo de una transformación biológica observada, sin igualdad aritmética entre unidades distintas. | 2.3–2.4 |
| Alta | Figura 2.3 Modelo conceptual de la traza | Relacionar unidad trazable, evento, responsable, ubicación, evidencia y procedencia. No representa tablas SQL. | 2.3 |
| Media | Figura 2.4 Ejemplo ER didáctico | Enseñar entidad, relación, cardinalidad y entidad asociativa mediante un ejemplo abstracto. No usar nombres de tablas reales. | 2.3.5 |
| Media | Figura 2.5 Alcance de la proyección hacia carbono | Separar el registro hasta plantación de monitoreo, biomasa, MRV, validación, verificación y emisión. | 2.7 |
| Alta | Figura 2.6 Relación RUP–SDD–IA | Mostrar que RUP gobierna el ciclo de vida, SDD organiza una capacidad e IA asiste con control humano. | 2.8–2.9 |
| Alta | Definiciones operativas integradas | Desarrollar cada término junto con su fuente y límite, evitando una tabla repetitiva que desconecte el concepto de su contexto. | 2.1–2.9 |
| Alta | Tabla 2.1 Propiedad, mecanismo y prueba | Mantener separadas las invariantes conceptuales, los mecanismos que se elegirán después y la prueba futura. | 2.4 |

Las figuras 2.1, 2.2, 2.3 y 2.6 son el paquete mínimo recomendado. Las figuras 2.4 y 2.5 se incluirán si la revisión de la tutora confirma que añaden claridad suficiente. Una figura podrá ocupar una página completa u orientación horizontal cuando sea necesario; no se reducirá hasta perder legibilidad y se revisará en PDF antes del cierre.

## 7. Paquete de diagramas para el Capítulo III y anexos

Los siguientes artefactos se planifican desde ahora porque necesitan fundamentos en el Capítulo II, pero no deben dibujarse como modelo definitivo hasta cerrar requisitos, contratos e implementación. Su secuencia de elaboración será: **requerimientos → casos de uso → procesos → interacciones → modelo de datos → implementación**.

| Artefacto | Pregunta que responde | Ubicación recomendada | Decisión de alcance |
|---|---|---|---|
| Diagrama de casos de uso | ¿Qué actores interactúan con qué capacidades del sistema? | Capítulo III. | Un diagrama general y diagramas o especificaciones específicas cuando aclaren capacidades críticas; revisar actores, asociaciones, límite del sistema, `include`, `extend` y generalizaciones. |
| Diagrama de actividad UML | ¿Cómo fluye cada proceso crítico y dónde se toman decisiones? | Capítulo III. | Cubrir Recolección, Vivero, Plantación, el flujo completo y las variantes de ingreso de material vegetal; los diagramas completos podrán dividirse en vez de reducirse. |
| Modelo conceptual | ¿Qué conceptos del negocio se relacionan antes de convertirlos en tablas? | Capítulo III. | Vista conceptual de trazabilidad, no modelo físico. |
| DER lógico | ¿Qué datos, cardinalidades y restricciones requiere la solución? | Capítulo III. | Dividir en vistas legibles si es necesario: núcleo de trazabilidad, Vivero–Plantación y campaña–subcampaña. |
| DER físico | ¿Cómo quedó la base de datos implementada? | Capítulo III y anexos. | Contrastar con la base de datos aplicada; puede presentarse en una vista principal y vistas complementarias, retirando elementos heredados fuera de alcance. |
| Diagramas de estado | ¿Qué transiciones son válidas para Recolección, Lote de Vivero y Subcampaña? | Capítulo III. | Solo para entidades con reglas de transición importantes. |
| Diagramas de secuencia | ¿Qué participantes intervienen en una operación crítica y en qué orden? | Capítulo III. | Procesos críticos de Recolección→Vivero, Vivero→Plantación y variantes pertinentes; incluir fallos o rechazos cuando demuestren atomicidad. |
| Componentes y despliegue | ¿Cómo se organizan y despliegan los componentes reales? | Capítulo III. | Basarse en la versión implementada, no en documentación histórica. |
| Matriz requisito→regla→invariante→prueba | ¿Cómo se demuestra cada propiedad comprometida? | Capítulo III y anexos. | Es una matriz, no un diagrama; debe servir de evidencia verificable. |

No se incluirán DFD, BPMN, diagrama de clases y DER para representar el mismo aspecto del sistema. Cada diagrama debe responder una pregunta distinta. La selección propuesta —casos de uso, actividad, dominio/DER, estados, secuencias y componentes— cubre el análisis y diseño sin redundancia. Las cuatro fases de RUP —Inicio, Elaboración, Construcción y Transición— deberán relacionarse con sus iteraciones, actividades, hitos y entregables en el texto o en una matriz, sin presentar una fase como si fuera un módulo.

## 8. Riesgos y decisiones que se trasladan a revisión formal o al Capítulo III

Estos puntos se identificaron durante la planificación. No impiden cerrar el primer borrador conceptual, porque no se presentan como decisiones ya implementadas; sí deben resolverse antes de cerrar el Marco aplicativo o la versión final del documento.

1. Confirmar con la tutora la extensión esperada, la profundidad conceptual y si exige una notación determinada.
2. Resolver cómo se modelará y probará el ingreso de material externo, pues el Perfil lo incluye pero parte de la documentación técnica vigente se concentra en el origen por Recolección.
3. Definir los campos obligatorios de cada escenario de validación, el criterio de completitud y cómo se registrará el tiempo de recuperación.
4. Confirmar el sistema de referencia espacial, cuáles registros usan punto o polígono y qué significa validez geográfica en el producto.
5. Validar los actores académicos finales. Los roles técnicos presentes en requisitos no deben presentarse automáticamente como estructura institucional definitiva.
6. Depurar los diagramas y documentación técnica heredada que mencionan blockchain, IPFS, monitoreo, mantenimiento o reposición fuera del alcance académico.
7. Normalizar la bibliografía en APA 7, asegurar que cada cita tenga fuente leída y cada fuente sea citada por una afirmación necesaria, y consolidarla una única vez en `04_referencias_bibliograficas.md` al final del documento completo.

## 9. Secuencia de trabajo propuesta

1. **Validar el plan con la tutora.** Confirmar alcance, extensión, notaciones y cantidad de figuras.
2. **Cerrar el vocabulario.** Completar las fichas de definición y actualizar el glosario de términos comprometidos cuando corresponda.
3. **Seleccionar la notación mínima.** Confirmar UML más DER; incorporar BPMN únicamente si existe una razón académica concreta.
4. **Preparar los seis recursos conceptuales.** Diseñarlos primero como borradores; verificar que cada uno tenga propósito, fuente y llamada textual.
5. **Revisar el texto 2.1–2.13.** Reemplazar formulaciones provisionales por definiciones con fuente, verificar el inventario de tecnologías reales en 2.10 y eliminar repeticiones entre metodología y marco conceptual.
6. **Preparar el plan de artefactos del Capítulo III.** No convertir todavía documentación técnica en figuras finales sin contrastarla con requisitos, migraciones y versión desplegada.
7. **Aplicar control editorial.** Revisar límites del alcance, consistencia terminológica, APA 7, notas de tablas/figuras, estructura visual de las tablas, legibilidad de diagramas y separación propiedad–mecanismo–prueba.
8. **Revisar la exportación a PDF.** Comprobar encabezados repetidos de tablas, ausencia de líneas indebidas, orientación de páginas anchas y que no existan figuras cortadas, desplazadas o ilegibles.
9. **Pasar por revisión formal.** Incorporar observaciones de la tutora antes de maquetar o cerrar la bibliografía.

## 10. Criterio de salida para iniciar la redacción definitiva

Se podrá pasar de planificación a redacción cuando se cumplan estas condiciones:

- la estructura del Capítulo II y las notaciones seleccionadas estén confirmadas;
- cada término técnico tenga una fuente leída, un localizador y una definición operativa delimitada;
- el paquete mínimo de figuras conceptuales tenga propósito, fuente y ubicación definida;
- los diagramas de Capítulo III estén asignados a una pregunta de diseño distinta;
- la secuencia requerimientos → casos de uso → procesos → interacciones → modelo de datos → implementación conserve correspondencia con los artefactos y el sistema real;
- el inventario de 2.10 se limite a tecnologías reales verificadas, sin sustituir el análisis arquitectónico del Capítulo III;
- se hayan registrado los vacíos de ingreso externo, geografía, completitud y actores para no presentarlos como decisiones ya cerradas;
- el contenido respete los límites del Perfil y no incorpore blockchain, MRV o resultados ambientales fuera del alcance.

## 11. Cierre de la planificación

- [x] Se normalizó la estructura 2.1–2.13 y se añadió el fundamento de entidad, relación y cardinalidad en 2.3.5.
- [x] Se cerró el mapa de definiciones del dominio, trazabilidad, eventos, integridad, evidencia, comprobación, RUP, SDD e IA.
- [x] Se incorporaron fuentes complementarias para modelo entidad–relación, UML, requisitos y verificación/validación.
- [x] Se diseñó y validó el paquete de seis figuras conceptuales del Capítulo II, con notas de procedencia y límites de interpretación.
- [x] Se asignaron los diagramas aplicados al Capítulo III y el DER físico completo al anexo, evitando duplicaciones.
- [x] Se consolidó un registro de trabajo para las fuentes efectivamente citadas o reservadas; la bibliografía del manuscrito se reúne una sola vez en `04_referencias_bibliograficas.md`, al final del documento completo.
- [x] Se mantuvieron los límites del Perfil: sin blockchain, IPFS, MRV, certificación, supervivencia o resultados ambientales atribuidos al sistema.

La planificación queda completada. Las decisiones identificadas en la sección 8 permanecen como controles explícitos para la revisión de la tutora y para el posterior desarrollo del Capítulo III.

## 12. Documentos de referencia

- `documentacion-grado/06_entregables/perfil/PERFIL_PROYECTO_GRADO.md`
- `documentacion-grado/06_entregables/proyecto_grado/02_capitulo_marco_teorico_conceptual.md`
- `documentacion-grado/04_metodologia/metodologia_desarrollo.md`
- `documentacion-grado/01_lineamientos/estructura_capitulos_1_y_2_proyecto_grado.md`
- `documentacion-grado/01_lineamientos/base_perfil_proyecto_grado.md`
- `documentacion-grado/03_investigacion/seleccion_fuentes_capitulo_ii.md`
- `documentacion-grado/05_recursos/indice_fuentes_bibliograficas.md`
- `documentacion-grado/05_recursos/glosario_terminos.md`
