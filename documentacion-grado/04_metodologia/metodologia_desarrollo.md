# Metodología de investigación y desarrollo

> **Versión 6 — 18 de agosto de 2026.**
> Documento de apoyo para la sección metodológica del perfil y el futuro Capítulo III. La formulación entregable está en [PERFIL_PROYECTO_GRADO.md](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md) §8.

## 1. Decisión metodológica

El proyecto combina dos ejes diferentes:

| Eje | Pregunta | Decisión |
|---|---|---|
| Investigación | ¿Cómo se construye y evalúa conocimiento sobre la solución? | Investigación aplicada y tecnológica, ciencia del diseño y estudio de caso único |
| Desarrollo | ¿Cómo se construirá y evolucionará el software durante el proyecto? | Desarrollo iterativo e incremental organizado en sprints, con especificaciones y decisiones versionadas |

No se declara Scrum completo, RUP, XP, Shape Up ni AI-DLC como metodología integral. Se adopta la unidad temporal de **sprint**, con planificación, ejecución, revisión del incremento con R3Foresta o seguimiento académico cuando corresponda y retrospectiva, sin atribuir al proyecto roles o artefactos de un marco que no hayan sido formalmente definidos.

## 2. Metodología de investigación

### 2.1. Investigación aplicada y ciencia del diseño

El trabajo desarrolla un artefacto para resolver un problema real de R3Foresta. La ciencia del diseño vincula relevancia organizacional, construcción y evaluación del artefacto y comunicación del conocimiento producido (Hevner et al., 2004).

La evaluación no se limita a mostrar pantallas. Debe producir evidencia sobre:

- cumplimiento de requerimientos;
- preservación de invariantes;
- capacidad de reconstrucción;
- evidencia recuperable;
- carga operativa;
- limitaciones del caso.

### 2.2. Estudio de caso

R3Foresta constituye un caso único. El diseño sigue las recomendaciones de Runeson y Höst (2009): declarar preguntas, contexto, unidad de análisis, procedimientos de recolección, análisis y amenazas a la validez.

La unidad principal es una **traza de cadena de custodia**. En la línea base, los 8 a 12 casos son actividades o recorridos históricos identificables; no son eventos generados por el software.

### 2.3. Enfoque y análisis

El enfoque es mixto con análisis descriptivo:

- cuantitativo: conteos, porcentajes, medianas, rangos, tiempos y resultados de pruebas;
- cualitativo: entrevistas, observación y dificultades percibidas.

La población accesible es pequeña y el piloto tendrá hasta cinco usuarios. No se utilizará inferencia estadística ni se generalizarán los resultados a otras organizaciones.

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

## 4. Cronología formal y sprints

### 4.1. Delimitación temporal

La ejecución académica formal se desarrollará del **17 de agosto al 15 de noviembre de 2026**. Todo módulo, integración, prueba, piloto y resultado que se presente como cumplimiento de los objetivos deberá atravesar actividades verificables dentro de esta ventana.

Existen repositorios, código, decisiones y prototipos producidos con anterioridad. Se conservan como insumos técnicos y evidencia de factibilidad, pero no se presentan como objetivos académicos ya cumplidos. Durante los sprints deberán ser revisados contra los requerimientos, corregidos cuando corresponda, integrados, documentados y sometidos a pruebas. Un componente solo contará como terminado cuando satisfaga el criterio de cierre del sprint.

### 4.2. Criterio general de terminado

Para cada incremento se exigirá:

1. requerimientos y reglas actualizados;
2. implementación funcional revisada;
3. integración con los módulos dependientes;
4. pruebas correspondientes ejecutadas;
5. documentación técnica y académica actualizada;
6. demostración o revisión del incremento;
7. incidencias críticas resueltas o declaradas.

### 4.3. Plan de sprints

| Sprint | Periodo | Objetivo | Criterio principal de salida |
|---|---|---|---|
| 0 | 17–23 ago | Perfil, backlog, arquitectura, criterios de terminado y levantamiento AS-IS | Plan formal y línea base medida |
| 1 | 24 ago–6 sep | Recolección | M1 integrado, probado y documentado |
| 2 | 7–20 sep | Vivero y M1→M2 | Eventos, saldos y primera transferencia cerrados |
| 3 | 21 sep–4 oct | Plantación y M2→M3 | Asignación, plantación y segunda transferencia cerradas |
| 4 | 5–18 oct | Genealogía y trazabilidad transversal | Recorrido completo reconstruible entre los tres módulos |
| 5 | 19 oct–1 nov | Integración, UI/UX, calidad y despliegue | Versión candidata para piloto |
| 6 | 2–8 nov | Piloto y evaluación | Evidencia TO-BE y contraste AS-IS disponibles |
| 7 | 9–15 nov | Resultados y cierre académico | Documento final revisado y entregado |

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

La verificación del objetivo específico 4 se organizará por propiedades y no por una cifra global de archivos de prueba.

| Categoría | Propósito |
|---|---|
| Unitarias | Reglas, validaciones y cálculos de saldo |
| Integración | Efectos completos de transferencias entre etapas |
| Concurrencia | Consumo simultáneo del último saldo |
| Fallo inducido | Ausencia de estados parciales |
| Extremo a extremo | Flujo completo sobre una base migrada |
| Contrafactual controlado | Mostrar el estado que la atomicidad evita |

El entregable central será la matriz:

> requerimiento → regla de negocio → invariante → mecanismo → prueba → resultado

No se mantendrá en la documentación académica una cantidad fija de pruebas o migraciones sin volver a verificarla en la fecha de corte.

## 7. Línea base y piloto

### 7.1. AS-IS

Se seleccionarán 8 a 12 actividades o recorridos históricos con fecha aproximada y al menos una persona que haya participado. La reconstrucción se realizará en dos pasadas:

1. solo con documentos disponibles;
2. con complemento de memoria del responsable.

Para cada respuesta se registrarán fuente, completitud y tiempo. La separación evidencia/memoria permite caracterizar la práctica sin desvalorizar los registros existentes.

### 7.2. TO-BE

El mismo instrumento se aplicará a trazas del piloto, con hasta cinco usuarios. Cuando sea posible, reconstruirá una persona distinta de quien capturó. El sitio se elegirá según:

- actividad real disponible;
- accesibilidad;
- consentimiento;
- posibilidad de observar el proceso;
- posibilidad de observar el recorrido del material vegetal entre las etapas disponibles.

Una persona externa o evaluador académico podrá participar si se formaliza su disponibilidad. No se compromete de antemano una institución específica.

### 7.3. Contingencias

- si una etapa del recorrido principal no ocurre, se prueba de forma controlada y se declara esa condición;
- si no ocurre una plantación, se diferencia claramente la verificación técnica de la validación de campo;
- si existen menos de ocho casos históricos, se reporta la muestra disponible y se refuerza el análisis cualitativo;
- si un participante no consiente el uso de su identidad, se omite o anonimiza.

## 8. Instrumentos previstos

Los instrumentos pertenecen al Proyecto de Grado final y no se crean durante la actualización Markdown del perfil:

- guía de entrevista semiestructurada;
- lista de cotejo de fuentes históricas;
- cuestionario común AS-IS/TO-BE;
- hoja de cronometraje y carga operativa;
- consentimiento informado;
- matriz de pruebas;
- protocolo de observación del piloto.

## 9. Amenazas a la validez

- selección intencional y muestra pequeña;
- calidad desigual de registros históricos;
- posible aprendizaje entre mediciones;
- disponibilidad del calendario de campo;
- rutas no ejercitadas en producción;
- sesgo si reconstruye quien registró;
- evidencia digital incapaz de probar por sí sola una realidad física;
- cambios del sistema durante la ventana de evaluación.

Las mitigaciones son instrumento idéntico, registro de fuentes, reconstrucción independiente cuando sea posible, separación entre casos reales y controlados y declaración explícita de limitaciones.

## 10. Referencias metodológicas

Basili, V. R., & Turner, A. J. (1975). Iterative enhancement: A practical technique for software development. *IEEE Transactions on Software Engineering, SE-1*(4), 390–396. https://doi.org/10.1109/TSE.1975.6312870

Gotel, O. C. Z., & Finkelstein, A. C. W. (1994). An analysis of the requirements traceability problem. *Proceedings of the 1st International Conference on Requirements Engineering*, 94–101. https://doi.org/10.1109/ICRE.1994.292398

Hevner, A. R., March, S. T., Park, J., & Ram, S. (2004). Design science in information systems research. *MIS Quarterly, 28*(1), 75–105. https://doi.org/10.2307/25148625

IEEE Computer Society. (2025). *Guide to the Software Engineering Body of Knowledge (SWEBOK Guide), version 4.0a*. https://www.computer.org/education/bodies-of-knowledge/software-engineering/v4

International Organization for Standardization, International Electrotechnical Commission, & Institute of Electrical and Electronics Engineers. (2026). *Systems and software engineering—Software life cycle processes* (ISO/IEC/IEEE Standard No. 12207:2026). https://www.iso.org/standard/90219.html

Larman, C., & Basili, V. R. (2003). Iterative and incremental development: A brief history. *Computer, 36*(6), 47–56. https://doi.org/10.1109/MC.2003.1204375

Meyer, B. (1992). Applying design by contract. *Computer, 25*(10), 40–51. https://doi.org/10.1109/2.161279

Runeson, P., & Höst, M. (2009). Guidelines for conducting and reporting case study research in software engineering. *Empirical Software Engineering, 14*, 131–164. https://doi.org/10.1007/s10664-008-9102-8

---

*Documento metodológico actualizado el 18 de agosto de 2026.*
