# Estructura de los capítulos I y II del Proyecto de Grado

> **Estado:** estructura confirmada por el postulante; sujeta a correcciones posteriores de la tutora.
> **Alcance:** documento final posterior al Perfil de Proyecto de Grado.
> **Fecha de revisión:** 27 de agosto de 2026.

## 1. Dictamen

La estructura confirmada para el inicio del documento final de R3Foresta es:

1. **Introducción independiente**: se redactará al final, cuando se disponga del contenido completo del documento.
2. **Capítulo I — Marco introductorio**: presenta el contexto, los antecedentes institucionales y trabajos similares, el problema, los objetivos, la justificación, el alcance y la metodología de desarrollo.
3. **Capítulo II — Marco teórico y conceptual**: desarrolla los conceptos y relaciones necesarios para comprender, diseñar y comprobar la solución, incluidos RUP, SDD y asistencia de IA.
4. **Capítulo III — Marco aplicativo**: desarrolla análisis, diseño, implementación e integración de los tres módulos, verificación funcional y técnica, validación operativa, aceptación y resultados.

Esta organización coincide con el patrón observado en proyectos depositados en la colección oficial de Proyectos de Grado de la Carrera de Informática de la UMSA. No se la considera, por sí sola, un reglamento formal: los proyectos anteriores constituyen precedentes de presentación, mientras que la instrucción vigente de la Carrera y las observaciones de la tutora tienen prioridad.

## 2. Base de la decisión

Se contrastaron cuatro proyectos de la colección oficial de la Carrera de Informática, correspondientes a la mención Ingeniería de Sistemas Informáticos:

| Proyecto revisado | Año | Capítulo I | Capítulo II |
|---|---:|---|---|
| Aplicación web y móvil para la gestión de recursos humanos, caso MEFP | 2022 | Marco introductorio | Marco teórico |
| Sistema integrado web de control personal y salarial mediante huella biométrica | 2022 | Marco introductorio | Marco teórico |
| Sistema web de gestión documental y digitalización de expedientes jurídicos | 2022 | Introducción y aspectos generales | Marco teórico |
| Sistema web de control y generación de certificados digitales | 2023 | Introducción, antecedentes, problema, objetivos, justificaciones, límites/alcances y diseño metodológico | Marco teórico |

Los índices no son idénticos y contienen diferencias de detalle, numeración y calidad editorial. Por ello, deben utilizarse para reconocer una estructura habitual, no para copiar su contenido ni sus errores.

El cuarto precedente resulta especialmente cercano a la organización adoptada para R3Foresta: coloca en el Capítulo I los antecedentes institucionales y de trabajos anteriores, seguidos del problema, los objetivos, las justificaciones, los límites y alcances y la metodología. No obstante, su índice contiene inconsistencias de numeración y desarrolla en el Capítulo II contenidos metodológicos y tecnológicos que no deben copiarse automáticamente. La referencia sirve para confirmar la ubicación general de las secciones, no como modelo de calidad o contenido.

**Precedente incorporado el 24 de agosto de 2026:** Villafuerte Mollinedo, D. (2023). *Sistema web de control y generación de certificados digitales* [Proyecto de grado, Universidad Mayor de San Andrés]. [PDF del Repositorio Institucional](https://repositorio.umsa.bo/xmlui/bitstream/handle/123456789/40433/T-4035.pdf?sequence=1&isAllowed=y).

## 3. Alineación respecto del temario del Perfil

El temario del Perfil originalmente proponía una introducción separada, seguida de:

- capítulo I: marco teórico y conceptual;
- capítulo II: marco referencial y contextual.

La decisión confirmada conserva la introducción como sección independiente, reorganiza los aspectos generales dentro del Capítulo I y desplaza el marco teórico al Capítulo II. La metodología de desarrollo se incluye dentro del Capítulo I y no tendrá un capítulo independiente. El Capítulo III se denominará Marco aplicativo. Estos ajustes deben conservar el problema, los objetivos y el alcance; cualquier cambio sustantivo continuará sujeto a revisión.

## 4. Criterios de redacción para ambos capítulos

- El Capítulo I debe partir del Perfil, pero actualizarse con evidencia de análisis y desarrollo realmente disponible. No debe copiarse mecánicamente como si todavía fuera una propuesta.
- El capítulo II debe organizarse alrededor del problema y del aporte de ingeniería, no como un catálogo de tecnologías.
- Los antecedentes de proyectos y sistemas similares deben analizarse críticamente en el capítulo I; las definiciones y modelos generales deben desarrollarse en el capítulo II.
- Las tecnologías concretas de implementación, la arquitectura seleccionada y el detalle operativo de cada iteración e incremento corresponden al Marco aplicativo.
- La metodología de desarrollo forma parte del Capítulo I. Debe explicar RUP como proceso rector, la adaptación realizada, la estrategia iterativa e incremental, SDD asistido por IA, la verificación, la validación y el seguimiento de evidencias, sin trasladar allí todo el detalle de implementación.
- Dentro de la metodología se desarrollarán por separado: RUP y sus principios; fases, iteraciones e hitos; adaptación al proyecto; incrementos de Construcción; SDD y su flujo; asistencia y control humano de la IA; verificación, validación y aceptación; seguimiento y cadena de evidencia. No bastará con enumerar estas etiquetas.
- El Capítulo II desarrollará los fundamentos conceptuales utilizados por esas decisiones —trazabilidad, cadena de custodia, eventos, procedencia, cantidades, invariantes, atomicidad, evidencia, reconstrucción, calidad pertinente, RUP, SDD y asistencia de IA— y delimitará la proyección hacia bonos de carbono incorporada al título. No repetirá el cronograma ni el detalle de los incrementos.
- Toda tabla deberá incluir inmediatamente debajo una nota de procedencia. Cuando sea de elaboración propia, la nota identificará además las fuentes bibliográficas, los datos, las secciones o las decisiones utilizadas como base, conforme a los criterios editoriales del Proyecto de Grado.
- Cada sección debe cerrar mostrando su relación con el problema, un objetivo o una decisión posterior del proyecto.

## 5. Archivos de trabajo

- [`../06_entregables/proyecto_grado/01_capitulo_marco_introductorio.md`](../06_entregables/proyecto_grado/01_capitulo_marco_introductorio.md)
- [`../06_entregables/proyecto_grado/02_capitulo_marco_teorico_conceptual.md`](../06_entregables/proyecto_grado/02_capitulo_marco_teorico_conceptual.md)

## 6. Decisiones confirmadas y validación pendiente

Decisiones confirmadas por el postulante y actualizadas al 25 de agosto de 2026:

- introducción independiente, redactada al final;
- Capítulo I denominado Marco introductorio;
- antecedentes institucionales y trabajos similares reunidos en el Capítulo I;
- metodología de desarrollo dentro del Capítulo I, sin capítulo metodológico independiente;
- Capítulo II denominado Marco teórico y conceptual;
- Capítulo III denominado Marco aplicativo, con análisis, diseño, implementación, integración, verificación, validación, aceptación y resultados.

Todavía se debe confirmar con la tutora o la Comisión de Grado:

1. si existe una guía interna vigente no publicada;
2. si la Carrera exige apartados específicos de justificación económica, social y tecnológica;
3. el formato final de fuente, interlineado, márgenes, empaste y entrega digital.
