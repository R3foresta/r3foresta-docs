# Estructura de los capítulos I y II del Proyecto de Grado

> **Estado:** estructura confirmada por el postulante; sujeta a correcciones posteriores de la tutora.
> **Alcance:** documento final posterior al Perfil de Proyecto de Grado.
> **Fecha de revisión:** 15 de septiembre de 2026.

## 1. Dictamen

La estructura confirmada para el inicio del documento final de R3Foresta es:

1. **Resumen independiente**: se redactará al final, cuando se disponga del contenido completo del documento.
2. **Capítulo I — Marco introductorio**: comienza con la Introducción y presenta el contexto, los antecedentes institucionales y trabajos similares, el problema, los objetivos, la justificación, el alcance y la metodología de desarrollo. Su última sección principal es 1.7; la organización global del documento no constituye una sección 1.8.
3. **Capítulo II — Marco teórico y conceptual**: desarrolla los conceptos y relaciones necesarios para comprender, diseñar y comprobar la solución, incluidos RUP, SDD, asistencia de IA y un inventario descriptivo de las tecnologías reales empleadas.
4. **Capítulo III — Marco aplicativo**: desarrolla análisis, diseño, implementación e integración de los tres módulos, verificación funcional y técnica, validación operativa, aceptación y resultados.

Esta organización coincide con el patrón observado en proyectos depositados en la colección oficial de Proyectos de Grado de la Carrera de Informática de la UMSA. No se la considera, por sí sola, un reglamento formal: los proyectos anteriores constituyen precedentes de presentación, mientras que la instrucción vigente de la Carrera y las observaciones de la tutora tienen prioridad.

La numeración interna se normaliza de la siguiente manera:

- **Capítulo I:** 1.1 Introducción; 1.2 Antecedentes, con 1.2.1 Antecedentes institucionales y 1.2.2 Trabajos similares; 1.3 Planteamiento del problema, con 1.3.1 Situación problemática, 1.3.2 Problema central y 1.3.3 Formulación del problema; 1.4 Objetivos, con 1.4.1 Objetivo general y 1.4.2 Objetivos específicos; 1.5 Justificación; 1.6 Alcances y límites; y 1.7 Metodología de desarrollo.
- **Capítulo II:** conserva la secuencia ya desarrollada de 2.1 a 2.9. Después incorpora 2.10 Tecnologías utilizadas; 2.11 Síntesis conceptual adoptada por R3Foresta; 2.12 Correspondencia entre proceso y fundamento conceptual; y 2.13 Selección de fuentes aplicada.

Las referencias bibliográficas no se repetirán al final de cada capítulo. Se consolidarán una sola vez, después de Conclusiones y Recomendaciones, en `04_referencias_bibliograficas.md`, antes de los anexos del documento completo.

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

La decisión confirmada sustituye esa separación: el **Resumen** será un elemento preliminar independiente y se redactará al final, mientras que la **Introducción** será la sección 1.1 del Capítulo I. Los demás aspectos generales permanecen en el Capítulo I, cuya estructura principal concluye en 1.7; el marco teórico se desarrolla en el Capítulo II. La metodología de desarrollo se incluye dentro del Capítulo I y no tendrá un capítulo independiente. El Capítulo III se denomina Marco aplicativo. Estos ajustes deben conservar el problema, los objetivos y el alcance; cualquier cambio sustantivo continuará sujeto a revisión.

## 4. Criterios de redacción para ambos capítulos

- El Capítulo I debe partir del Perfil, pero actualizarse con evidencia de análisis y desarrollo realmente disponible. No debe copiarse mecánicamente como si todavía fuera una propuesta.
- El Resumen permanece independiente y se redactará cuando el documento completo esté estabilizado. La Introducción abre el Capítulo I como sección 1.1; la numeración interna comienza con 1.1 en el Capítulo I, 2.1 en el Capítulo II y 3.1 en el Capítulo III. El Capítulo I no añadirá una sección 1.8 para explicar la organización del documento. Las figuras y tablas siguen la misma numeración por capítulo.
- El Capítulo II debe organizarse alrededor del problema y del aporte de ingeniería, no como un catálogo de tecnologías. La sección 2.10 se limita a identificar de forma descriptiva las tecnologías reales del sistema y su función general.
- Los antecedentes de proyectos y sistemas similares deben analizarse críticamente en el capítulo I; las definiciones y modelos generales deben desarrollarse en el capítulo II.
- La arquitectura seleccionada, los componentes, el despliegue, las alternativas descartadas, los mecanismos de implementación y el detalle operativo de cada iteración e incremento corresponden al Marco aplicativo. El inventario factual de 2.10 no adelanta ni sustituye esas explicaciones.
- La metodología de desarrollo forma parte del Capítulo I. Debe explicar RUP como proceso rector, la adaptación realizada, la estrategia iterativa e incremental, SDD asistido por IA, la verificación, la validación y el seguimiento de evidencias, sin trasladar allí todo el detalle de implementación.
- Dentro de la metodología se desarrollarán por separado: RUP y sus principios; fases, iteraciones e hitos; adaptación al proyecto; incrementos de Construcción; SDD y su flujo; asistencia y control humano de la IA; verificación, validación y aceptación; seguimiento y cadena de evidencia. No bastará con enumerar estas etiquetas.
- El Capítulo II desarrollará los fundamentos conceptuales utilizados por esas decisiones —trazabilidad, cadena de custodia, eventos, procedencia, cantidades, invariantes, atomicidad, evidencia, reconstrucción, calidad pertinente, RUP, SDD y asistencia de IA— y delimitará la proyección hacia bonos de carbono incorporada al título. No repetirá el cronograma ni el detalle de los incrementos.
- Toda tabla deberá seguir la estructura APA 7: número destacado, título en cursiva, cuerpo sin líneas verticales ni cuadriculado completo, líneas horizontales superior, de encabezado e inferior, y *Nota.* inmediata cuando corresponda. El encabezado se repetirá si la tabla continúa en otra página y la orientación horizontal se reservará para las tablas que no resulten legibles en orientación vertical.
- Las figuras y diagramas podrán ocupar una página completa o emplear orientación horizontal cuando su anchura lo exija. No se reducirán hasta cortar o volver ilegibles nombres, relaciones, cardinalidades o notas; los diagramas verticales podrán dividirse de forma legible. Cada figura conservará título y nota, y la exportación a PDF se revisará antes del cierre.
- El texto del documento se mantendrá justificado y con interlineado de 1,5; las decisiones de orientación de tablas o figuras no alteran ese criterio para el cuerpo textual.
- Las referencias bibliográficas se consolidarán en `04_referencias_bibliograficas.md`, al final del documento completo. Toda cita y toda fuente externa declarada en una nota deberá tener su referencia correspondiente allí.
- Cada sección debe cerrar mostrando su relación con el problema, un objetivo o una decisión posterior del proyecto.

## 5. Archivos de trabajo

- [`../06_entregables/proyecto_grado/01_capitulo_marco_introductorio.md`](../06_entregables/proyecto_grado/01_capitulo_marco_introductorio.md)
- [`../06_entregables/proyecto_grado/02_capitulo_marco_teorico_conceptual.md`](../06_entregables/proyecto_grado/02_capitulo_marco_teorico_conceptual.md)
- [`../06_entregables/proyecto_grado/03_capitulo_marco_aplicativo.md`](../06_entregables/proyecto_grado/03_capitulo_marco_aplicativo.md)
- `../06_entregables/proyecto_grado/04_referencias_bibliograficas.md` — bibliografía consolidada prevista para el cierre del documento completo.

## 6. Decisiones confirmadas y validación pendiente

Decisiones confirmadas por el postulante y actualizadas al 15 de septiembre de 2026:

- Resumen independiente, redactado al final;
- Introducción incorporada como primera sección del Capítulo I;
- Capítulo I denominado Marco introductorio;
- antecedentes institucionales y trabajos similares reunidos en el Capítulo I;
- metodología de desarrollo dentro del Capítulo I, sin capítulo metodológico independiente;
- Capítulo II denominado Marco teórico y conceptual;
- Capítulo I normalizado de 1.1 a 1.7, sin sección 1.8;
- Capítulo II normalizado con 2.10 Tecnologías utilizadas, 2.11 Síntesis conceptual, 2.12 Correspondencia entre proceso y fundamento conceptual y 2.13 Selección de fuentes aplicada;
- inventario tecnológico descriptivo en 2.10, sin trasladar arquitectura ni decisiones técnicas desde el Capítulo III;
- bibliografía única consolidada al final del documento completo;
- Capítulo III denominado Marco aplicativo, con análisis, diseño, implementación, integración, verificación, validación, aceptación y resultados.

Todavía se debe confirmar con la tutora o la Comisión de Grado:

1. si existe una guía interna vigente no publicada;
2. si la Carrera exige apartados específicos de justificación económica, social y tecnológica;
3. el formato final de fuente, márgenes, empaste y entrega digital; el texto justificado, el interlineado 1,5 y los criterios APA 7 de tablas y figuras se mantienen como decisiones de trabajo.
