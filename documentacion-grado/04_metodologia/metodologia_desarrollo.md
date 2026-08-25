# Metodología de investigación y desarrollo

> **Versión 11 — 24 de agosto de 2026.**
> Documento de apoyo para la sección metodológica del perfil y el diseño metodológico integrado en el Capítulo I. La formulación entregable del Perfil está en [PERFIL_PROYECTO_GRADO.md](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md) §8.
> La evaluación y los artefactos posteriores deben conservar los [principios de trazabilidad y evaluación](../01_lineamientos/base_perfil_proyecto_grado.md#7-principios-de-trazabilidad-y-evaluación-del-proyecto).

## 1. Decisión metodológica integrada

El proyecto combina componentes diferentes pero relacionados. Ninguno reemplaza a los demás:

| Componente | Pregunta | Decisión |
|---|---|---|
| Investigación | ¿Cómo se construye y evalúa conocimiento sobre la solución? | Investigación aplicada y tecnológica, ciencia del diseño operacionalizada mediante DSRM |
| Estrategia empírica | ¿En qué contexto y sobre qué unidades se estudia la solución? | Estudio de caso único embebido en R3Foresta, con trazas de cadena de custodia como unidades de análisis |
| Desarrollo | ¿Cómo se construirá y evolucionará el software? | Desarrollo iterativo e incremental organizado en sprints, con especificaciones y decisiones versionadas |
| Verificación y evaluación | ¿Cómo se comprobarán la construcción y su utilidad contextual? | Pruebas técnicas formativas, reconstrucción de trazas, observación y piloto descriptivo |
| Seguimiento | ¿Cómo se controlará el avance y se conservará evidencia? | Línea base, backlog, criterio de terminado, versiones, pruebas, demostraciones, decisiones, incidencias y horas por sprint |

No se declara Scrum completo, RUP, XP, Shape Up ni AI-DLC como metodología integral. Se adopta la unidad temporal de **sprint**, con planificación, ejecución, revisión del incremento con R3Foresta o seguimiento académico cuando corresponda y retrospectiva, sin atribuir al proyecto roles o artefactos de un marco que no hayan sido formalmente definidos.

## 2. Metodología de investigación

### 2.1. Investigación aplicada y ciencia del diseño

El trabajo desarrolla un artefacto para resolver un problema real de R3Foresta. La ciencia del diseño vincula relevancia organizacional, construcción y evaluación del artefacto y comunicación del conocimiento producido (Hevner et al., 2004).

Para convertir ese enfoque en un proceso ejecutable se utilizará DSRM (Peffers et al., 2007): identificación del problema, definición de objetivos de la solución, diseño y desarrollo, demostración, evaluación y comunicación. Estas actividades no reemplazan los sprints; permiten explicar en el Perfil, en el diseño metodológico del Capítulo I y en los capítulos posteriores cómo cada incremento contribuye a construir y evaluar el artefacto.

El artefacto académico no se reduce a las pantallas de la aplicación. Comprende el modelo de trazabilidad y cadena de custodia, las reglas e invariantes de integridad, la implementación integrada de Recolección, Vivero y Plantación, el mecanismo de reconstrucción y la evidencia producida al verificar y evaluar la solución. La contribución deberá poder seguirse mediante la cadena:

> problema → conocimiento previo → requisito de diseño → componente del artefacto → demostración → evaluación → hallazgo o conclusión

### 2.1.1. Aplicación de DSRM al proyecto

| Actividad DSRM | Aplicación en R3Foresta | Evidencia principal |
|---|---|---|
| Identificación del problema y motivación | Caracterizar la práctica actual y las dificultades de reconstrucción e integridad | Inventario documental, entrevistas, trazas históricas y árbol del problema revisado |
| Definición de objetivos de la solución | Convertir el problema en preguntas, objetivos, requisitos, invariantes y criterios de evaluación | Perfil, matriz de alineación y especificaciones versionadas |
| Diseño y desarrollo | Diseñar y construir el modelo y los tres módulos integrados en incrementos | Decisiones, modelos, commits, migraciones, pruebas y documentación de los sprints 1–5 |
| Demostración | Ejecutar los incrementos y reconstruir un recorrido de extremo a extremo | Revisiones de sprint, demostraciones reproducibles y recorrido M1→M2→M3 |
| Evaluación | Contrastar el artefacto con requisitos, invariantes y necesidades del caso | Matriz de pruebas, situación actual, piloto, métricas y hallazgos cualitativos |
| Comunicación | Presentar proceso, artefacto, evidencia, límites y contribución | Repositorios, documento final, anexos y defensa |

DSRM se aplicará de forma iterativa. Un defecto o hallazgo de demostración o evaluación podrá devolver el trabajo a objetivos, diseño o desarrollo, siempre que el cambio y su justificación queden registrados.

La evaluación no se limita a mostrar pantallas. Debe producir evidencia sobre:

- cumplimiento de requerimientos;
- preservación de invariantes;
- capacidad de reconstrucción;
- evidencia recuperable;
- carga operativa;
- limitaciones del caso.

### 2.2. Estudio de caso

R3Foresta constituye un **caso único embebido**. El caso es el diseño, construcción y evaluación del proceso digital de trazabilidad del material vegetal en R3Foresta durante la ventana académica formal. La Fundación constituye el contexto organizacional y las trazas de cadena de custodia estudiadas constituyen las unidades embebidas de análisis. El diseño sigue las recomendaciones de Runeson y Höst (2009): declarar preguntas, contexto, unidad de análisis, procedimientos de recolección, análisis y amenazas a la validez.

La selección de un solo caso se justifica por su relación directa con el problema que origina el proyecto, el acceso autorizado a procesos y registros y la necesidad de estudiar con profundidad la interacción entre organización, operación y artefacto dentro del alcance de una licenciatura. Esta selección permite inferencia analítica y aprendizaje contextual, no generalización estadística.

Antes de recolectar datos se delimitarán el periodo, los procesos, los sitios, los actores y las fuentes incluidas. El carácter embebido exige analizar más de una traza y realizar después una síntesis del caso completo. Si solo resultara disponible una unidad de análisis, se revisará la denominación del diseño en vez de mantener la etiqueta de caso embebido sin sustento.

La unidad principal es una **traza de cadena de custodia**. Para caracterizar la situación actual se definirá un periodo documental, se inventariarán las actividades o recorridos identificables dentro de ese periodo y se analizará el conjunto de trazas que cumpla los criterios de inclusión. Los casos excluidos y su motivo también quedarán registrados. Este procedimiento corresponde a un censo documental delimitado de la información accesible, no a una muestra estadística ni a eventos generados por el software.

### 2.3. Enfoque y análisis

El enfoque es mixto con análisis descriptivo:

- cuantitativo: conteos, porcentajes, medianas, rangos, tiempos y resultados de pruebas;
- cualitativo: entrevistas, observación y dificultades percibidas.

La población accesible es pequeña y la cantidad de participantes del piloto dependerá de las personas disponibles y autorizadas por R3Foresta. No se utilizará inferencia estadística ni se generalizarán los resultados a otras organizaciones.

Los datos cuantitativos y cualitativos se integrarán por traza. Cada resultado de completitud, tiempo o carga se interpretará junto con las fuentes utilizadas, las interrupciones y las dificultades observadas. El componente cualitativo empleará análisis temático por plantilla: partirá de categorías ligadas a las preguntas del estudio —claridad, carga, dificultades, interrupciones y confianza en la reconstrucción—, las revisará durante la codificación y permitirá agregar categorías emergentes (Brooks et al., 2015). Se conservará la relación entre observación o respuesta, código, hallazgo y conclusión.

## 3. Metodología de desarrollo

### 3.1. Desarrollo iterativo e incremental

El desarrollo iterativo e incremental construye una base funcional y la amplía en ciclos sucesivos (Basili & Turner, 1975; Larman & Basili, 2003). ISO/IEC/IEEE 12207:2026 permite aplicar los procesos del ciclo de vida de forma iterativa e incremental sin prescribir una metodología concreta, y SWEBOK v4.0a organiza las prácticas reconocidas de Ingeniería de Software.

El criterio de incremento sigue el recorrido del material vegetal y las necesidades del dominio. Un incremento produce o estabiliza las capacidades que consumirá el siguiente.

### 3.2. Especificaciones y decisiones versionadas

Los requerimientos, reglas de negocio, decisiones de arquitectura, esquema de datos y contratos de integración se conservan en repositorios versionados. Cuando cambia una decisión:

1. se identifica la regla afectada;
2. se modifica la implementación;
3. se actualizan los artefactos normativos relacionados;
4. se agregan o ajustan pruebas;
5. se registra el estado del incremento.

Esta práctica se sustenta en diseño por contrato (Meyer, 1992) y trazabilidad de requerimientos (Gotel & Finkelstein, 1994). En el documento académico puede describirse como **especificación versionada y mantenida como referencia**, sin depender de una etiqueta metodológica emergente.

### 3.3. Actividades de cada incremento

Cada sprint adaptará al alcance del incremento las siguientes actividades de Ingeniería de Software:

1. seleccionar requisitos, reglas, riesgos y criterio de salida;
2. analizar el proceso y los datos afectados;
3. diseñar o ajustar interfaz, modelo, contratos y arquitectura;
4. construir código y migraciones;
5. verificar reglas y riesgos mediante las pruebas pertinentes;
6. integrar con los módulos dependientes;
7. demostrar y revisar el incremento;
8. actualizar documentación, decisiones, incidencias y retrospectiva.

La unidad temporal de sprint organiza estas actividades, pero no convierte el proyecto en Scrum completo. El Marco aplicativo describirá lo realmente ejecutado y justificará cualquier adaptación o desviación.

## 4. Cronología formal y sprints

### 4.1. Delimitación temporal

La ejecución académica formal se desarrollará del **17 de agosto al 15 de noviembre de 2026**. Todo módulo, integración, prueba, piloto y resultado que se presente como cumplimiento de los objetivos deberá atravesar actividades verificables dentro de esta ventana. El periodo posterior hasta la defensa, prevista para fines de noviembre o inicios de diciembre, podrá utilizarse como margen interno para correcciones, maquetación y preparación de la defensa; cualquier ampliación de la ejecución sustantiva deberá reflejarse en el cronograma vigente.

De acuerdo con el criterio académico acordado con la docente de la UMSA y comunicado por el postulante, la construcción que se defenderá deberá demostrarse dentro del semestre desde una **referencia inicial académica del repositorio**. Los repositorios, decisiones y sistemas producidos con anterioridad podrán consultarse como referencia técnica y evidencia de factibilidad, pero no serán presentados como la construcción formal del Proyecto de Grado.

La referencia inicial académica deberá mostrar de forma verificable qué flujos funcionales todavía no existen y serán construidos. Cada sprint conservará evidencia de inicio y cierre: etiqueta o commit de referencia, requerimientos abordados, cambios de implementación, migraciones aplicadas desde una base controlada, pruebas críticas ejecutadas y demostración del incremento. No se afirmará que nunca existió un prototipo previo; se demostrará que el sistema académico presentado fue reconstruido incrementalmente dentro de la ventana autorizada.

### 4.2. Criterio general de terminado

Para cada incremento se exigirá:

1. requerimientos y reglas críticas del incremento actualizados;
2. implementación funcional revisada;
3. integración con los módulos dependientes;
4. conjunto mínimo de pruebas correspondiente a sus riesgos ejecutado;
5. documentación técnica y académica actualizada;
6. evidencia versionada de la construcción y demostración del incremento;
7. incidencias críticas resueltas o declaradas.

### 4.3. Plan de sprints

| Sprint | Periodo | Objetivo | Criterio principal de salida |
|---|---|---|---|
| 0 | 17–23 ago | Perfil, backlog, referencia inicial académica del repositorio, arquitectura, instrumentos iniciales y caracterización de la práctica actual | Plan formal, referencia inicial y caracterización disponibles |
| 1 | 24 ago–6 sep | Inicio de la construcción formal: Recolección | M1 construido desde la referencia inicial, probado y documentado |
| 2 | 7–20 sep | Vivero y M1→M2 | Eventos, saldos y primera transferencia cerrados |
| 3 | 21 sep–4 oct | Plantación y M2→M3 | Asignación, plantación y segunda transferencia cerradas |
| 4 | 5–18 oct | Reconstrucción y trazabilidad transversal | Recorrido completo reconstruible entre los tres módulos |
| 5 | 19 oct–1 nov | Integración, interfaz y experiencia de uso, calidad y despliegue | Versión candidata para piloto |
| 6 | 2–8 nov | Piloto y evaluación | Evidencia de la propuesta y contraste con la situación actual disponibles |
| 7 | 9–15 nov | Resultados y cierre académico | Documento final revisado y entregado |

### 4.4. Seguimiento y cadena de evidencia

El control de avance utilizará una fila por sprint con, al menos:

| Sprint | Planificado | Realizado | Evidencia | Desviación | Decisión | Estado del gate |
|---|---|---|---|---|---|---|
| _n_ | Requisitos y resultado esperado | Alcance realmente cerrado | Commits, migraciones, pruebas y demostración | Diferencia y causa | Acción adoptada | Aprobado, condicionado o pendiente |

Se mantendrán además:

- un registro de riesgos e incidencias con impacto, mitigación, estado y efecto sobre el cronograma;
- una bitácora de decisiones y cambios que indique los objetivos, reglas, pruebas e instrumentos afectados;
- la matriz de trazabilidad de investigación `problema → fuente → requisito de diseño → artefacto → demostración → evaluación → conclusión`;
- la matriz técnica `requerimiento → regla → invariante → mecanismo → prueba → resultado`;
- el registro de horas académicas y de las desviaciones entre fechas planificadas y reales.

Estos controles constituyen seguimiento del proyecto y evidencia de ejecución; no son una metodología de investigación adicional.

## 5. Autoría, colaboración y asistencia

Pablo Andrés Fernández Cari es el autor académico y responsable principal de:

- análisis del dominio y requerimientos;
- arquitectura y modelo de datos;
- lógica de negocio e integraciones;
- diseño de experiencia e interfaz;
- coordinación con actores;
- documentación y evaluación.

Existió apoyo puntual de colaboradores:

- Jhamil Cali trabajó sobre una prueba de concepto de contratos inteligentes, excluida del alcance académico vigente;
- Miguel Calderón participó en pruebas y correcciones aisladas.

Estas contribuciones no convierten el Proyecto de Grado en una autoría grupal. Se identificarán con precisión en agradecimientos o declaración de contribuciones del documento final.

Los agentes de inteligencia artificial Claude Code y Codex se utilizarán como apoyo aprobado durante los sprints. Podrán colaborar en descomposición del backlog, propuestas de implementación, revisión de código, generación de casos de prueba, análisis de errores y redacción. El postulante revisará y validará cada resultado. Los agentes no aprobarán requerimientos, no modificarán por sí solos las reglas del dominio, no validarán evidencia de campo y no sustituyen la autoría ni la responsabilidad humana.

El uso de agentes deberá dejar evidencia proporcionada al riesgo de la tarea: cambios versionados, pruebas, revisión del diff y registro de las decisiones críticas. No se atribuirá a la IA una decisión que haya requerido conocimiento del contexto organizacional.

## 6. Diseño de verificación técnica

La verificación del objetivo específico 4 se organizará por propiedades críticas y no por una cifra global de archivos o casos de prueba. No todas las reglas recibirán todas las clases de prueba: se elegirá la técnica mínima que permita producir evidencia convincente según el riesgo.

La evaluación avanzará desde verificaciones formativas y controladas durante los sprints hacia una evaluación más naturalista y sumativa en el piloto. Esta combinación sigue la lógica de FEDS para evaluar artefactos de ciencia del diseño sin exigir que todas las técnicas se apliquen en todas las etapas (Venable et al., 2016).

| Categoría | Propósito |
|---|---|
| Unitarias | Reglas, validaciones y cálculos de saldo |
| Integración | Efectos completos de transferencias y transformaciones entre etapas |
| Concurrencia | Consumo simultáneo del último saldo |
| Fallo inducido | Ausencia de estados parciales |
| Extremo a extremo | Flujo completo sobre una base migrada |
| Contrafactual controlado | Mostrar un estado parcial o incoherente que las reglas críticas deben prevenir |

El entregable central será la matriz:

> requerimiento → regla de negocio → invariante → mecanismo → prueba → resultado

No se mantendrá en la documentación académica una cantidad fija de pruebas o migraciones sin volver a verificarla en la fecha de corte.

El núcleo obligatorio se concentrará en cinco familias de propiedades:

1. no aceptar cantidades o saldos negativos ni consumos superiores al disponible;
2. conservar atómicamente la relación y los saldos en Recolección→Vivero y Vivero→Plantación;
3. impedir doble asignación o doble consumo ante solicitudes concurrentes;
4. no dejar estados parciales cuando una operación crítica falla;
5. reconstruir de extremo a extremo una traza con cantidades, responsables, ubicaciones y evidencias relacionadas.

Se podrán agregar pruebas cuando aparezca un riesgo real, pero no se perseguirá volumen de pruebas como resultado académico independiente.

## 7. Situación actual y piloto

### 7.1. Caracterización de la situación actual

Se fijará un periodo documental y se levantará un inventario de todas las actividades identificables dentro de él. Se definirán criterios simples de inclusión —traza identificable, periodo conocido y al menos una fuente recuperable— y se documentará la razón de cada exclusión. Todas las trazas elegibles formarán la caracterización de la situación actual. La reconstrucción podrá realizarse en dos pasadas:

1. solo con documentos disponibles;
2. con complemento de memoria del responsable.

Para cada respuesta se registrarán fuente, completitud y tiempo. La separación evidencia/memoria permite caracterizar la práctica sin desvalorizar los registros existentes.

### 7.2. Evaluación de la propuesta

El mismo instrumento se aplicará a trazas del piloto. Siempre que sea operativamente posible, una misma actividad real se registrará en paralelo mediante la práctica habitual y mediante R3Foresta, sin obligar a abandonar los registros existentes. Esto permitirá comparar el mismo recorrido bajo ambas formas de registro. Si no fuese posible, se utilizarán trazas de complejidad semejante y el resultado se denominará contraste descriptivo entre trazas no equivalentes.

La cantidad de participantes dependerá de las personas disponibles y autorizadas. Cuando sea posible, reconstruirá una persona distinta de quien capturó. El sitio se elegirá según:

- actividad real disponible;
- accesibilidad;
- consentimiento;
- posibilidad de observar el proceso;
- posibilidad de observar el recorrido del material vegetal entre las etapas disponibles.

### 7.3. Contingencias

- si una etapa del recorrido principal no ocurre, se prueba de forma controlada y se declara esa condición;
- si no ocurre una plantación, se diferencia claramente la verificación técnica de la validación de campo;
- si el censo del periodo produce pocas trazas elegibles, se reportan el inventario completo, los criterios aplicados y el alcance limitado del contraste, y se refuerza el análisis cualitativo;
- si un participante no consiente el uso de su identidad, se omite o anonimiza.

## 8. Instrumentos previstos

Los instrumentos pertenecen al Proyecto de Grado final y no se crean durante la actualización Markdown del perfil:

- guía de entrevista semiestructurada;
- lista de cotejo de fuentes históricas;
- cuestionario común para la situación actual y la propuesta;
- hoja de cronometraje y carga operativa;
- consentimiento informado;
- matriz de pruebas;
- protocolo de observación del piloto.

Antes de la recolección definitiva se probarán con una traza controlada y se ajustarán únicamente si existen ambigüedades. Se conservarán la versión utilizada y el motivo de cualquier cambio.

### 8.1. Definiciones mínimas para métricas reproducibles

El protocolo definitivo mantendrá un conjunto pequeño de métricas:

| Dimensión | Definición operativa mínima |
|---|---|
| Información reconstruible | Cada ítem requerido se clasifica como completo, parcial, ausente o contradictorio; no se fuerza una puntuación global |
| Evidencia recuperable | Cantidad de ítems requeridos con al menos una evidencia vinculada y recuperable / cantidad de ítems que requerían evidencia |
| Tiempo de reconstrucción | Desde la entrega de la pregunta y las fuentes hasta la declaración de respuesta; pausas e interrupciones se registran por separado |
| Carga de registro | Duración de captura, reintentos, errores y solicitudes de ayuda observadas |
| Integridad técnica | Resultado aprobado/fallido por propiedad crítica y evidencia de la prueba correspondiente |
| Percepción | Respuestas breves sobre claridad, dificultad y carga, interpretadas junto con la observación |

Los ítems concretos de reconstrucción se derivarán de las preguntas de procedencia, especie o material, cantidades y unidades, eventos o transformaciones, responsables, tiempo, ubicación, destino y evidencia.

### 8.2. Custodia de datos de investigación

Los roles y permisos del sistema controlan quién puede operar R3foresta App, pero no sustituyen el protocolo de investigación. Antes de entrevistas o piloto se definirá por separado: ubicación de almacenamiento, personas autorizadas, seudonimización, tratamiento de fotografías y coordenadas sensibles, periodo de conservación, retiro del consentimiento y eliminación. Datos personales o sensibles no se entregarán a agentes de IA sin autorización y anonimización previa.

## 9. Amenazas a la validez

- corpus documental y cantidad de participantes potencialmente reducidos;
- calidad desigual de registros históricos;
- posible aprendizaje entre mediciones;
- disponibilidad del calendario de campo;
- rutas no ejercitadas en producción;
- sesgo si reconstruye quien registró;
- evidencia digital incapaz de probar por sí sola una realidad física;
- cambios del sistema durante la ventana de evaluación.

Las mitigaciones son instrumento común, registro de fuentes, comparación paralela sobre la misma actividad cuando sea posible, reconstrucción independiente, separación entre casos reales y controlados, versión congelada del sistema durante el piloto y declaración explícita de limitaciones.

## 10. Referencias metodológicas

Basili, V. R., & Turner, A. J. (1975). Iterative enhancement: A practical technique for software development. *IEEE Transactions on Software Engineering, SE-1*(4), 390–396. https://doi.org/10.1109/TSE.1975.6312870

Brooks, J., McCluskey, S., Turley, E., & King, N. (2015). The utility of template analysis in qualitative psychology research. *Qualitative Research in Psychology, 12*(2), 202–222. https://doi.org/10.1080/14780887.2014.955224

Gotel, O. C. Z., & Finkelstein, A. C. W. (1994). An analysis of the requirements traceability problem. *Proceedings of the 1st International Conference on Requirements Engineering*, 94–101. https://doi.org/10.1109/ICRE.1994.292398

Hevner, A. R., March, S. T., Park, J., & Ram, S. (2004). Design science in information systems research. *MIS Quarterly, 28*(1), 75–105. https://doi.org/10.2307/25148625

IEEE Computer Society. (2025). *Guide to the Software Engineering Body of Knowledge (SWEBOK Guide), version 4.0a*. https://www.computer.org/education/bodies-of-knowledge/software-engineering/v4

International Organization for Standardization, International Electrotechnical Commission, & Institute of Electrical and Electronics Engineers. (2026). *Systems and software engineering—Software life cycle processes* (ISO/IEC/IEEE Standard No. 12207:2026). https://www.iso.org/standard/90219.html

Larman, C., & Basili, V. R. (2003). Iterative and incremental development: A brief history. *Computer, 36*(6), 47–56. https://doi.org/10.1109/MC.2003.1204375

Meyer, B. (1992). Applying design by contract. *Computer, 25*(10), 40–51. https://doi.org/10.1109/2.161279

Peffers, K., Tuunanen, T., Rothenberger, M. A., & Chatterjee, S. (2007). A design science research methodology for information systems research. *Journal of Management Information Systems, 24*(3), 45–77. https://doi.org/10.2753/MIS0742-1222240302

Runeson, P., & Höst, M. (2009). Guidelines for conducting and reporting case study research in software engineering. *Empirical Software Engineering, 14*, 131–164. https://doi.org/10.1007/s10664-008-9102-8

Venable, J., Pries-Heje, J., & Baskerville, R. (2016). FEDS: A framework for evaluation in design science research. *European Journal of Information Systems, 25*(1), 77–89. https://doi.org/10.1057/ejis.2014.36

---

*Documento metodológico actualizado el 24 de agosto de 2026.*
