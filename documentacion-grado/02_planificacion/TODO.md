# TODO — cierre del Perfil de Proyecto de Grado

> **Fecha de corte:** 25 de agosto de 2026.
> **Alcance de este tablero:** únicamente el Perfil de Proyecto de Grado. El desarrollo restante, los incrementos, la validación, la aceptación y el documento final aparecen aquí solo como actividades comprometidas en el perfil; no son entregables operativos de este tablero.

## 1. Entregable oficial

El contenido oficial se encuentra en:

- [PERFIL_PROYECTO_GRADO.md](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md)

La fuente oficial y única versión editable del Perfil es la versión Markdown. El DOCX existente es una instantánea no canónica y no sincronizada; no debe utilizarse como fuente de cambios ni como versión vigente sin regenerarlo. El Perfil no requiere saltos de página después de cada encabezado principal; esa regla se reservará para los capítulos del documento final oficial al preparar su presentación.

La ejecución posterior se controla en [`TODO_PROYECTO_GRADO.md`](TODO_PROYECTO_GRADO.md), que organiza las fases RUP, los incrementos, las integraciones, la verificación, la transición y el cierre documental.

La revisión progresiva del Capítulo I, la preparación del Capítulo II y la propagación de las correcciones aprobadas se registran en [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md).

## 2. Correcciones de la Doctora Téllez — 25 de agosto de 2026

> **Estado:** backlog abierto; estas correcciones prevalecen sobre los estados de cierre de la versión anterior del Perfil.
> **Fuente:** observaciones de la Doctora Téllez, registradas por el postulante el 25 de agosto de 2026.
> **Regla de ejecución:** primero cerrar las decisiones P0; después corregir estructura y contenido; finalmente ejecutar la revisión APA 7 y la maquetación.

### 2.1. Enrutamiento y prioridades

| Prioridad | Bloque | Destino principal | Dependencia |
|---|---|---|---|
| P0 | Pregunta general, objetivo general y metodología de desarrollo | Perfil | Validación final de la Doctora Téllez |
| P0 | Estructura y secciones que permanecen en el Perfil | Perfil | Ninguna |
| P1 | Ratificación y propagación del título seleccionado | Perfil | Conformidad de la tutora y delimitación explícita de la proyección hacia bonos de carbono |
| P1 | Antecedentes, problema, alcances, marco teórico e índice | Perfil | Decisiones P0 |
| P1 | Cronograma por objetivos | Perfil | Fecha inicial y objetivo general confirmados |
| P1 | APA 7, citas, índice automático y bibliografía mínima | Perfil | Contenido sustantivo estabilizado |
| P2 | Evaluación, instrumentos, ética, unidades trazables, eventos, integridad y propuesta de ingeniería | Proyecto de Grado final | Aprobación del Perfil |

### 2.2. P0 — título y alineación problema–objetivos

- [x] Conservar como antecedente el título base **Sistema de trazabilidad de material vegetal para reforestación: caso R3Foresta**.
- [x] Proponer y contrastar alternativas que relacionen trazabilidad y bonos de carbono sin afirmar que el sistema certificará, generará, emitirá o comercializará bonos.
- [x] Seleccionar, por decisión del postulante del 25 de agosto de 2026, el título **Sistema de trazabilidad del material vegetal para reforestación con proyección hacia bonos de carbono: caso R3Foresta**.
- [ ] Obtener la ratificación de la Doctora Téllez para el título seleccionado.
- [x] Propagar el título seleccionado y su delimitación a los documentos rectores, el Perfil, el marco conceptual planificado y los tableros; la portada maquetada se actualizará cuando corresponda.
- [x] Reformular la pregunta general sin incorporar la solución en su redacción; evitar expresiones como “un sistema de trazabilidad” dentro de la pregunta.
- [x] Partir de una formulación neutral semejante a “¿Cómo asegurar la trazabilidad de la cadena de custodia del material vegetal…?”, precisando origen, recepción externa, vivero y plantación sin anticipar el artefacto.
- [x] Reformular el objetivo general con un solo verbo principal: **Desarrollar**; retirar **evaluar** del objetivo general sin eliminar la evaluación que corresponda al objetivo específico vigente.
- [x] Mantener los cinco objetivos específicos, que fueron considerados adecuados por la Doctora Téllez.
- [x] Revisar su correspondencia con las preguntas específicas sin reescribirlos, salvo una corrección formal imprescindible.
- [x] Sincronizar pregunta general, preguntas específicas, objetivo general y objetivos específicos en el Perfil, la estructura rectora y el Capítulo I.

**Criterio de cierre:** la pregunta expresa el problema sin revelar la solución; el objetivo general responde con “Desarrollar”; cada pregunta específica conserva correspondencia uno a uno con un objetivo específico; la Doctora Téllez aprueba el conjunto.

### 2.3. P0 — estructura que debe conservar el Perfil

- [x] Eliminar el **Resumen** y las **palabras clave** del Perfil; reservar el resumen para el documento final.
- [x] Mantener la Introducción del Perfil y revisar su continuidad después de retirar las secciones trasladadas.
- [x] Retirar del cuerpo del Perfil el árbol de causas y efectos, trasladarlo a los **Anexos del propio Perfil** y conservar desde el planteamiento del problema la referencia cruzada correspondiente.
- [x] Eliminar del Perfil el alcance de la evaluación; trasladar su contenido al Proyecto de Grado final.
- [x] Eliminar del Perfil y de los documentos activos el diseño de investigación, las unidades de análisis, los instrumentos investigativos y el análisis asociado. Conservar en el documento final únicamente la verificación, la validación operativa, la aceptación y los controles de datos como actividades de Ingeniería de Software.
- [x] Conservar en el Perfil solamente la metodología de desarrollo de software, una vez seleccionada y justificada.
- [x] Eliminar del Perfil la sección **Propuesta de solución y aporte de ingeniería**, incluidas sus subsecciones de modelo, integración y resultados esperados; trasladarla al Marco aplicativo del documento final.
- [x] Eliminar la sección **Recursos** del Perfil.

**Criterio de cierre:** el índice del Perfil contiene únicamente las secciones solicitadas por la Doctora Téllez y todo contenido retirado tiene una tarea de destino explícita en los otros TODO.

### 2.4. P1 — presentación, índice y APA 7

- [x] Definir el mecanismo de índice automático compatible con la fuente Markdown y la futura maquetación; no mantener un índice escrito y numerado manualmente.
- [ ] Confirmar si la exigencia de automatización abarca únicamente el índice general o también los índices de tablas y figuras.
- [x] Regenerar y verificar el índice después de cerrar títulos, numeración y anexos.
- [x] Aplicar APA 7 en citas y referencias de todo el Perfil.
- [x] Eliminar siglas o nombres de autor corporativo presentados entre corchetes dentro de las citas, por ejemplo `[ISO]`.
- [ ] Confirmar si la observación sobre corchetes se limita a las siglas de autores institucionales dentro de las citas o también afecta descriptores bibliográficos válidos, como `[Documento institucional no publicado]`.
- [x] Definir y aplicar una forma uniforme aceptada por la Doctora Téllez para las citas de autores corporativos, utilizando el nombre corporativo sin siglas entre corchetes.
- [x] Revisar que cada cita tenga referencia y que cada referencia sea citada.
- [x] Alcanzar un mínimo de quince referencias bibliográficas efectivamente citadas; no existe un máximo fijado. La versión actual contiene veintiuna.
- [x] Ejecutar una revisión final de ortografía, numeración, tablas, figuras y referencias cruzadas después de los cambios estructurales.

**Criterio de cierre:** índice regenerable sin edición manual, cero siglas de autores corporativos introducidas entre corchetes en las citas, conformidad APA 7 y al menos quince fuentes citadas y referenciadas.

### 2.5. P1 — antecedentes

- [x] Reordenar los trabajos similares en este orden: **internacionales → Bolivia → ciudad de La Paz**.
- [x] Seleccionar aproximadamente tres antecedentes internacionales pertinentes.
- [x] Seleccionar entre uno y tres antecedentes bolivianos pertinentes.
- [x] Buscar entre uno y tres antecedentes de la ciudad de La Paz; documentar la búsqueda y aceptar que el bloque quede vacío si no se encuentran trabajos realmente pertinentes.
- [x] Tratar “La Paz” como ciudad en la búsqueda; declarar que no se identificó un trabajo equivalente y presentar por separado los antecedentes cercanos del departamento y de El Alto.
- [x] Para cada antecedente resumir de forma comparable: problema, solución, resultado y diferencia respecto de R3foresta App.
- [x] Mantener separados los antecedentes institucionales de R3Foresta y los trabajos académicos o sistemas similares.

**Criterio de cierre:** orden geográfico aplicado, cantidades justificadas, búsqueda local documentada y comparación explícita con el proyecto.

### 2.6. P1 — planteamiento del problema

- [x] Ampliar el párrafo que comienza con “Como consecuencia…” para desarrollar efectos sobre reconstrucción, decisiones internas, cantidades y saldos, responsables, rendición de cuentas y comunicación con patrocinadores y aliados.
- [x] Evitar que la ampliación introduzca la solución, resultados no medidos o afirmaciones sobre certificación.
- [x] Verificar que el árbol trasladado a Anexos conserve correspondencia con causas, problema central y efectos del texto.
- [x] Revisar nuevamente problema central y preguntas después de reformular la pregunta general y el objetivo general.

**Criterio de cierre:** la consecuencia está suficientemente desarrollada, el problema sigue siendo informacional y la formulación no contiene la respuesta tecnológica.

### 2.7. P1 — alcances y límites

- [x] Reescribir el alcance funcional alrededor de únicamente tres módulos: **Recolección, Vivero y Plantación**.
- [x] Ampliar para cada módulo sus funciones, datos principales, inicio, final y relación con el módulo siguiente.
- [x] Integrar el material vegetal adquirido o recibido de terceros dentro de Vivero o Plantación, sin crear un cuarto módulo ni un apartado de alcance independiente.
- [x] Renombrar la sección **Limitaciones** como **Límites**.
- [x] Integrar dentro de **Límites** el contenido pertinente de **Fuera del alcance** y eliminar esa sección independiente.
- [x] Revisar y retirar formulaciones que parezcan justificar una falta de datos, participantes u operaciones; conservar solo límites reales del proyecto y del producto.
- [x] Auditar los límites heredados de la propuesta investigativa y conservar en el Perfil únicamente límites reales del producto y del alcance académico.
- [x] Mantener explícito que no se mide ni certifica carbono y que no se generan, emiten ni comercializan bonos de carbono, incluso si el título definitivo los menciona como contexto o finalidad posterior.

**Criterio de cierre:** tres módulos claramente desarrollados, una sola sección de Límites, sin alcance de evaluación ni justificaciones por debilidad de datos.

### 2.8. P1 — marco teórico preliminar

- [x] Aplicar la regla **un concepto por subsección**; eliminar títulos que agrupen tres o más conceptos.
- [x] Definir primero los términos centrales del título definitivo.
- [x] Incluir como mínimo subsecciones independientes para **sistema**, **trazabilidad**, **material vegetal** y **reforestación**.
- [x] Incorporar una definición acotada de bonos de carbono y explicar que su presencia en el título expresa una proyección institucional futura, no una capacidad del sistema.
- [x] Trasladar al Capítulo II el desarrollo de unidades trazables, eventos, procedencia, integridad de operaciones y demás conceptos detallados de diseño.
- [x] Conservar **cadena de custodia** como concepto preliminar independiente por su presencia en el problema y la pregunta.
- [x] Auditar las subsecciones restantes y conservar en el Perfil solo los conceptos imprescindibles para comprender el título y la propuesta general.

**Criterio de cierre:** cada subtítulo desarrolla un solo concepto, todos los términos del título están definidos y el detalle de diseño queda reservado para el Capítulo II.

### 2.9. P0/P1 — metodología de desarrollo

- [x] Investigar metodologías de desarrollo de software más específicas que “iterativa e incremental” y revisar su adecuación a una ejecución académica individual.
- [x] Seleccionar definitivamente el **Rational Unified Process (RUP) adaptado** y justificar su adecuación a los tres módulos, los objetivos, los riesgos de integridad, las integraciones y el calendario.
- [x] Documentar las fases de Inicio, Elaboración, Construcción y Transición, con sus disciplinas esenciales, productos e hitos LCO, LCA, IOC y PR.
- [x] Distinguir la iteración como ciclo temporal de trabajo del incremento ejecutable que produce: IN-1, EL-1, CO-1 a CO-4 y TR-1.
- [x] Complementar RUP con **Spec-Driven Development asistido por inteligencia artificial** como protocolo de especificación, planificación, tareas, implementación y pruebas para cada capacidad dentro de una iteración.
- [x] Confirmar que RUP ya es iterativo e incremental y reemplazar la terminología de sprints por fases, iteraciones e incrementos.
- [x] Retirar ciencia del diseño, DSRM, estudio de caso único embebido, FEDS y demás elementos del diseño de investigación, de acuerdo con la decisión comunicada por la tutora de desarrollar directamente el producto.
- [x] Establecer que la verificación, la validación operativa y la aceptación son actividades de Ingeniería de Software y no una metodología de investigación adicional.

**Criterio de cierre:** metodología específica aprobada, procedimiento reproducible y correspondencia explícita con objetivos y cronograma.

### 2.10. P1 — índice del documento final, cronograma y referencias

- [x] Renombrar **Temario tentativo del documento final** como **Índice**.
- [x] Ajustar el índice propuesto para que después del **Capítulo III — Marco aplicativo** aparezcan **Conclusiones** y **Recomendaciones**.
- [x] Mantener las referencias y los anexos después de Conclusiones y Recomendaciones.
- [x] Revisar la tabla de correspondencia entre objetivos y capítulos después de aprobar el nuevo índice.
- [x] Sustituir el cronograma anterior por un cronograma organizado por objetivos.
- [x] Asignar a cada objetivo un periodo de inicio, ejecución y cierre, además de las actividades transversales indispensables.
- [x] Confirmar el inicio formal el **6 de julio de 2026** y el cierre el **15 de noviembre de 2026**.
- [x] Organizar el cronograma por objetivos y fases RUP, sin utilizar sprints: Inicio y Elaboración; incremento M1 Recolección; incremento M2 Vivero e integración M1→M2; incremento M3 Plantación e integración M2→M3; trazabilidad transversal; y Transición.
- [x] Mantener requisitos, diseño, construcción, pruebas y documentación dentro de cada iteración que produce un incremento, con integración progresiva y pruebas del sistema en Transición.
- [x] Verificar y completar la bibliografía hasta alcanzar el mínimo de quince referencias citado en la sección 2.4.

**Criterio de cierre:** índice aprobado, cronograma expresado por objetivos con fechas confirmadas y bibliografía mínima cumplida.

### 2.11. Contenido trasladado al Proyecto de Grado final

- [x] Retirar de los tableros y capítulos activos el diseño de investigación, las unidades de análisis, el caso único embebido, DSRM, FEDS, los instrumentos cualitativos y las amenazas a la validez investigativa.
- [x] Registrar en [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md) los conceptos de RUP, SDD asistido por IA, unidades trazables, eventos, procedencia e integridad que se desarrollarán en el Capítulo II.
- [x] Registrar en [`TODO_PROYECTO_GRADO.md`](TODO_PROYECTO_GRADO.md) las fases RUP, el flujo SDD, los incrementos de los tres módulos, las integraciones, la verificación, la validación operativa y el cierre.
- [x] Eliminar los sprints como unidad de planificación y reemplazarlos por fases e iteraciones RUP, con incrementos ejecutables en Construcción.

**Criterio de cierre:** ninguna sección retirada queda perdida y no existe duplicación entre el Perfil y el documento final.

## 3. Registro de decisiones vigentes

> Esta sección resume decisiones, no representa avance de ejecución. Las únicas casillas operativas del Perfil se encuentran en la sección 2.

### 3.1. Confirmadas

- El título seleccionado por el postulante es **Sistema de trazabilidad del material vegetal para reforestación con proyección hacia bonos de carbono: caso R3Foresta**; permanece pendiente de ratificación por la tutora.
- El nombre oficial de la aplicación es **R3foresta App**; se distingue de R3Foresta, la institución, y R3Carbon, el componente institucional.
- Los cinco objetivos específicos se conservan.
- El alcance mantiene exactamente tres módulos: Recolección, Vivero y Plantación.
- El material vegetal adquirido o recibido de terceros ingresa como variante de Vivero o Plantación, con procedencia e historial; no constituye un cuarto módulo.
- El producto no mide ni certifica carbono y no genera, emite ni comercializa bonos de carbono; estos solo pueden presentarse como contexto institucional o uso posterior.
- La metodología vigente es **RUP adaptado, complementado con SDD asistido por IA**.
- No se adoptarán ciencia del diseño, DSRM, estudio de caso único embebido ni FEDS; la verificación, validación y aceptación se documentarán como actividades de Ingeniería de Software.
- El Perfil conserva el Markdown como fuente canónica y única versión editable; el DOCX existente es una instantánea no canónica y no sincronizada. No existen saltos de página obligatorios después de cada encabezado principal.
- El Resumen, las palabras clave, el alcance de evaluación, el diseño de investigación, la propuesta de ingeniería y la sección Recursos deben retirarse del Perfil mediante las tareas de la sección 2.
- El presupuesto permanece fuera del Perfil.
- El resumen ejecutivo institucional respalda únicamente el contexto institucional y no redefine problema, objetivos, alcance, metodología o evaluación.

### 3.2. Pendientes de decisión o confirmación

- Ratificación de la tutora para el título seleccionado.
- Conformidad de la Doctora Téllez con la nueva redacción del problema, las preguntas y el objetivo general.
- Confirmación de si se requieren índices automáticos adicionales para tablas o figuras y del alcance de la observación sobre corchetes en los descriptores bibliográficos.

## 4. Estado por sección

| Sección | Estado Markdown | Observación |
|---|---|---|
| Portada institucional | Revisión condicionada | Actualizar solo si cambia el título; logo y maquetación quedan para la presentación oficial |
| Resumen y palabras clave | Aplicado | Retirados del Perfil y reservados para el documento final |
| Índice general | Aplicado | Regenerable a partir de los encabezados Markdown |
| 1. Introducción | Aplicado | Continuidad revisada y aporte operativo reforzado |
| 2. Antecedentes | Aplicado | Orden internacional, Bolivia y La Paz, con comparación explícita |
| 3. Problema | Aplicado | Consecuencias ampliadas y árbol trasladado al Anexo A |
| 4. Objetivos | Aplicado; pendiente de conformidad | Objetivo general con un verbo y cinco objetivos específicos conservados |
| 5. Justificación | Aplicado | Coherente con el título y los límites |
| 6. Alcances y límites | Aplicado | Tres módulos desarrollados, sin alcance de evaluación, y una sola sección de Límites |
| 7. Marco teórico preliminar | Aplicado | Un concepto por subsección y solo términos esenciales |
| 8. Metodología | Aplicado | RUP adaptado con fases, iteraciones, incrementos, SDD asistido por IA, productos e hitos |
| Sección Propuesta | Trasladada y retirada | El contenido corresponde al Marco aplicativo del documento final |
| 9. Índice del documento final | Aplicado | Capítulo III seguido de Conclusiones y Recomendaciones |
| 10. Cronograma | Aplicado | Organizado por objetivos, fases e iteraciones RUP del 6 de julio al 15 de noviembre de 2026 |
| Sección Recursos | Retirada | No forma parte del Perfil |
| 11. Bibliografía | Aplicado | Veintiuna referencias citadas y revisadas en APA 7 |
| 12. Anexos | Aplicado | Árbol de causas y efectos incorporado como Anexo A |

## 5. Verificaciones antes de entregar a la Doctora Téllez

- [ ] Cerrar todas las casillas operativas de las secciones 2.2 a 2.10 o registrar explícitamente cualquier excepción aprobada por la Doctora Téllez.
- [x] Confirmar que los contenidos retirados del Perfil continúan en los tableros del Capítulo II o del Proyecto de Grado final, según su destino.
- [x] Sincronizar título, problema, preguntas y objetivos con la estructura rectora y el Capítulo I.
- [x] Ejecutar la auditoría final de APA 7, mínimo de referencias, índice automático, numeración, figuras, tablas y referencias cruzadas.
- [x] Comprobar que el Perfil final conserve únicamente tres módulos y no prometa medición, certificación ni generación de bonos de carbono.
- [ ] Registrar la conformidad de la Doctora Téllez con la versión corregida.

## 6. Presentación posterior — fuera del alcance actual

- aplicar tamaño carta, margen izquierdo de 4 cm y demás márgenes de 3 cm;
- insertar logo UMSA proporcionado por el postulante;
- conservar las figuras que permanezcan después de la reestructuración y verificar el organigrama institucional y el árbol trasladado a Anexos;
- revisar pies de figura y tablas;
- aplicar saltos de página por capítulo únicamente en el documento final oficial, no en el Perfil;
- preparar diapositivas y guion de defensa, únicamente cuando se solicite.

## 7. Actividades posteriores a la aprobación del perfil

Después de aprobar el Perfil, [`TODO_PROYECTO_GRADO.md`](TODO_PROYECTO_GRADO.md) será el único tablero operativo de la ejecución, los incrementos de construcción, la verificación, la validación, el Capítulo III y el cierre del documento final. Los capítulos I y II continuarán bajo el control especializado de [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md). El tablero de ejecución aplicará RUP y SDD asistido por IA conforme a la sección 2.9 y al cronograma académico de la sección 2.10.

---

*Tablero actualizado el 25 de agosto de 2026.*
