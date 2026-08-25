# TODO — cierre del Perfil de Proyecto de Grado

> **Fecha de corte:** 25 de agosto de 2026.
> **Alcance de este tablero:** únicamente el Perfil de Proyecto de Grado. El desarrollo restante, el piloto, las pruebas finales y el documento del Proyecto de Grado aparecen aquí solo como actividades prometidas en el perfil; no son entregables de esta actualización.

## 1. Entregable oficial

El contenido oficial se encuentra en:

- [PERFIL_PROYECTO_GRADO.md](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md)

La fuente oficial del Perfil es la versión Markdown y es el único archivo necesario en este repositorio. Su contenido requiere las correcciones abiertas de la sección 2; no se creará ni mantendrá una copia DOCX. El Perfil no requiere saltos de página después de cada encabezado principal; esa regla se reservará para los capítulos del documento final oficial al preparar su presentación.

La ejecución posterior se controla en [`TODO_PROYECTO_GRADO.md`](TODO_PROYECTO_GRADO.md), que separa construcción académica, protocolo empírico, cierre técnico prepiloto y documento final.

La revisión progresiva del Capítulo I, la preparación del Capítulo II y la propagación de las correcciones aprobadas se registran en [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md).

## 2. Correcciones del profesor Víctor — 25 de agosto de 2026

> **Estado:** backlog abierto; estas correcciones prevalecen sobre los estados de cierre de la versión anterior del Perfil.
> **Fuente:** observaciones del profesor Víctor, registradas por el postulante el 25 de agosto de 2026.
> **Regla de ejecución:** primero cerrar las decisiones P0; después corregir estructura y contenido; finalmente ejecutar la revisión APA 7 y la maquetación.

### 2.1. Enrutamiento y prioridades

| Prioridad | Bloque | Destino principal | Dependencia |
|---|---|---|---|
| P0 | Pregunta general, objetivo general y metodología de desarrollo | Perfil | Validación final del profesor Víctor |
| P0 | Estructura y secciones que permanecen en el Perfil | Perfil | Ninguna |
| P1 | Exploración opcional de un título alternativo | Perfil | El título base continúa vigente hasta nueva aprobación |
| P1 | Antecedentes, problema, alcances, marco teórico e índice | Perfil | Decisiones P0 |
| P1 | Cronograma por objetivos | Perfil | Fecha inicial y objetivo general confirmados |
| P1 | APA 7, citas, índice automático y bibliografía mínima | Perfil | Contenido sustantivo estabilizado |
| P2 | Evaluación, instrumentos, ética, unidades trazables, eventos, integridad y propuesta de ingeniería | Proyecto de Grado final | Aprobación del Perfil |

### 2.2. P0 — título y alineación problema–objetivos

- [x] Registrar el título actual como base aprobada: **Sistema de trazabilidad de material vegetal para reforestación: caso R3Foresta**.
- [ ] Proponer entre tres y cinco títulos más llamativos que relacionen trazabilidad y bonos de carbono sin afirmar que el sistema certificará, generará, emitirá o comercializará bonos.
- [ ] Evaluar cada alternativa mediante una matriz breve: claridad, correspondencia con el problema, términos que deberán definirse, riesgo de sobrepromesa y compatibilidad con los límites.
- [ ] Decidir con el profesor Víctor si se conserva el título aprobado o se adopta una alternativa; esta exploración no bloquea las demás correcciones mientras se utilice el título base.
- [ ] Si se adopta una alternativa, propagarla al marco teórico, los límites, el índice, la portada y los documentos rectores.
- [x] Reformular la pregunta general sin incorporar la solución en su redacción; evitar expresiones como “un sistema de trazabilidad” dentro de la pregunta.
- [x] Partir de una formulación neutral semejante a “¿Cómo asegurar la trazabilidad de la cadena de custodia del material vegetal…?”, precisando origen, recepción externa, vivero y plantación sin anticipar el artefacto.
- [x] Reformular el objetivo general con un solo verbo principal: **Desarrollar**; retirar **evaluar** del objetivo general sin eliminar la evaluación que corresponda al objetivo específico vigente.
- [x] Mantener los cinco objetivos específicos, que fueron considerados adecuados por el profesor Víctor.
- [x] Revisar su correspondencia con las preguntas específicas sin reescribirlos, salvo una corrección formal imprescindible.
- [ ] Sincronizar pregunta general, preguntas específicas, objetivo general y objetivos específicos en el Perfil, la estructura rectora y el Capítulo I.

**Criterio de cierre:** la pregunta expresa el problema sin revelar la solución; el objetivo general responde con “Desarrollar”; cada pregunta específica conserva correspondencia uno a uno con un objetivo específico; el profesor Víctor aprueba el conjunto.

### 2.3. P0 — estructura que debe conservar el Perfil

- [x] Eliminar el **Resumen** y las **palabras clave** del Perfil; reservar el resumen para el documento final.
- [x] Mantener la Introducción del Perfil y revisar su continuidad después de retirar las secciones trasladadas.
- [x] Retirar del cuerpo del Perfil el árbol de causas y efectos, trasladarlo a los **Anexos del propio Perfil** y conservar desde el planteamiento del problema la referencia cruzada correspondiente.
- [x] Eliminar del Perfil el alcance de la evaluación; trasladar su contenido al Proyecto de Grado final.
- [x] Eliminar del Perfil el diseño de investigación, las unidades de análisis y participantes, la evaluación, los instrumentos, el análisis y las consideraciones éticas; trasladarlos al documento final.
- [x] Conservar en el Perfil solamente la metodología de desarrollo de software, una vez seleccionada y justificada.
- [x] Eliminar del Perfil la sección **Propuesta de solución y aporte de ingeniería**, incluidas sus subsecciones de modelo, integración y resultados esperados; trasladarla al Marco aplicativo del documento final.
- [x] Eliminar la sección **Recursos** del Perfil.

**Criterio de cierre:** el índice del Perfil contiene únicamente las secciones solicitadas por el profesor Víctor y todo contenido retirado tiene una tarea de destino explícita en los otros TODO.

### 2.4. P1 — presentación, índice y APA 7

- [x] Definir el mecanismo de índice automático compatible con la fuente Markdown y la futura maquetación; no mantener un índice escrito y numerado manualmente.
- [ ] Confirmar si la exigencia de automatización abarca únicamente el índice general o también los índices de tablas y figuras.
- [x] Regenerar y verificar el índice después de cerrar títulos, numeración y anexos.
- [x] Aplicar APA 7 en citas y referencias de todo el Perfil.
- [x] Eliminar siglas o nombres de autor corporativo presentados entre corchetes dentro de las citas, por ejemplo `[ISO]`.
- [ ] Confirmar si la observación sobre corchetes se limita a las siglas de autores institucionales dentro de las citas o también afecta descriptores bibliográficos válidos, como `[Documento institucional no publicado]`.
- [x] Definir y aplicar una forma uniforme aceptada por el profesor Víctor para las citas de autores corporativos, utilizando el nombre corporativo sin siglas entre corchetes.
- [x] Revisar que cada cita tenga referencia y que cada referencia sea citada.
- [x] Alcanzar un mínimo de quince referencias bibliográficas efectivamente citadas; no existe un máximo fijado. La versión actual contiene diecisiete.
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
- [x] Auditar individualmente los límites actuales —información histórica, operaciones disponibles, participantes, sitio del piloto, caso único y alcance probatorio de las evidencias— y conservar en el Perfil únicamente límites del producto y del alcance académico.
- [x] Mantener explícito que no se mide ni certifica carbono y que no se generan, emiten ni comercializan bonos de carbono, incluso si el título definitivo los menciona como contexto o finalidad posterior.

**Criterio de cierre:** tres módulos claramente desarrollados, una sola sección de Límites, sin alcance de evaluación ni justificaciones por debilidad de datos.

### 2.8. P1 — marco teórico preliminar

- [x] Aplicar la regla **un concepto por subsección**; eliminar títulos que agrupen tres o más conceptos.
- [x] Definir primero los términos centrales del título definitivo.
- [x] Incluir como mínimo subsecciones independientes para **sistema**, **trazabilidad**, **material vegetal** y **reforestación**.
- [x] Mantener fuera del marco teórico la definición de bonos de carbono mientras se conserve el título base aprobado.
- [x] Trasladar al Capítulo II el desarrollo de unidades trazables, eventos, procedencia, integridad de operaciones y demás conceptos detallados de diseño.
- [x] Conservar **cadena de custodia** como concepto preliminar independiente por su presencia en el problema y la pregunta.
- [x] Auditar las subsecciones restantes y conservar en el Perfil solo los conceptos imprescindibles para comprender el título y la propuesta general.

**Criterio de cierre:** cada subtítulo desarrolla un solo concepto, todos los términos del título están definidos y el detalle de diseño queda reservado para el Capítulo II.

### 2.9. P0/P1 — metodología de desarrollo

- [x] Investigar metodologías de desarrollo de software más específicas que “iterativa e incremental” y revisar su adecuación a una ejecución académica individual.
- [x] Seleccionar el **Proceso Unificado Ágil** y justificar su adecuación a los tres módulos, los objetivos, los riesgos de integridad y el calendario.
- [x] Documentar sus fases de Inicio, Elaboración, Construcción y Transición, con actividades, productos, hitos y evidencia.
- [ ] Obtener la ratificación del profesor Víctor para el Proceso Unificado Ágil incorporado provisionalmente; si no es aceptado, sustituir la sección y reajustar el cronograma.
- [x] Reservar DSRM, estudio de caso y demás elementos del diseño de investigación únicamente para el documento final y fuera del Perfil.

**Criterio de cierre:** metodología específica aprobada, procedimiento reproducible y correspondencia explícita con objetivos y cronograma.

### 2.10. P1 — índice del documento final, cronograma y referencias

- [x] Renombrar **Temario tentativo del documento final** como **Índice**.
- [x] Ajustar el índice propuesto para que después del **Capítulo III — Marco aplicativo** aparezcan **Conclusiones** y **Recomendaciones**.
- [x] Mantener las referencias y los anexos después de Conclusiones y Recomendaciones.
- [x] Revisar la tabla de correspondencia entre objetivos y capítulos después de aprobar el nuevo índice.
- [x] Sustituir el cronograma anterior por un cronograma organizado por objetivos.
- [x] Asignar a cada objetivo un periodo de inicio, ejecución y cierre, además de las actividades transversales indispensables.
- [ ] Confirmar con el profesor Víctor si el inicio formal puede fijarse en la primera semana de julio de 2026.
- [x] Preparar provisionalmente el calendario desde el 6 de julio y retirar del Perfil la estructura temporal anterior; recalcularlo si el profesor Víctor confirma otra fecha.
- [x] Verificar y completar la bibliografía hasta alcanzar el mínimo de quince referencias citado en la sección 2.4.

**Criterio de cierre:** índice aprobado, cronograma expresado por objetivos con fechas confirmadas y bibliografía mínima cumplida.

### 2.11. Contenido trasladado al Proyecto de Grado final

- [x] Registrar en [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md) el diseño de investigación, unidades de análisis, participantes, evaluación, instrumentos, análisis y ética retirados del Perfil.
- [x] Registrar en [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md) los conceptos de unidades trazables, eventos, procedencia e integridad que se desarrollarán en el Capítulo II.
- [x] Registrar en [`TODO_PROYECTO_GRADO.md`](TODO_PROYECTO_GRADO.md) el modelo, la integración entre etapas, los resultados esperados y el aporte de ingeniería que pasarán al Marco aplicativo.
- [x] Registrar en [`TODO_PROYECTO_GRADO.md`](TODO_PROYECTO_GRADO.md) que la decisión de conservar, renombrar o eliminar los sprints como mecanismo técnico interno se tomará después de seleccionar la metodología; nunca formarán el cronograma académico del Perfil.

**Criterio de cierre:** ninguna sección retirada queda perdida y no existe duplicación entre el Perfil y el documento final.

## 3. Registro de decisiones vigentes

> Esta sección resume decisiones, no representa avance de ejecución. Las únicas casillas operativas del Perfil se encuentran en la sección 2.

### 3.1. Confirmadas

- El título base aprobado es **Sistema de trazabilidad de material vegetal para reforestación: caso R3Foresta**.
- El nombre oficial de la aplicación es **R3foresta App**; se distingue de R3Foresta, la institución, y R3Carbon, el componente institucional.
- Los cinco objetivos específicos se conservan.
- El alcance mantiene exactamente tres módulos: Recolección, Vivero y Plantación.
- El material vegetal adquirido o recibido de terceros ingresa como variante de Vivero o Plantación, con procedencia e historial; no constituye un cuarto módulo.
- El producto no mide ni certifica carbono y no genera, emite ni comercializa bonos de carbono; estos solo pueden presentarse como contexto institucional o uso posterior.
- DSRM, estudio de caso, evaluación, instrumentos, análisis y ética se reservan para el documento final.
- El Perfil se conserva únicamente en Markdown, sin copia DOCX ni saltos de página obligatorios después de cada encabezado principal.
- El Resumen, las palabras clave, el alcance de evaluación, el diseño de investigación, la propuesta de ingeniería y la sección Recursos deben retirarse del Perfil mediante las tareas de la sección 2.
- El presupuesto permanece fuera del Perfil.
- El resumen ejecutivo institucional respalda únicamente el contexto institucional y no redefine problema, objetivos, alcance, metodología o evaluación.

### 3.2. Pendientes de decisión o confirmación

- Adopción o descarte de un título alternativo relacionado con bonos de carbono.
- Conformidad del profesor Víctor con la nueva redacción del problema, las preguntas y el objetivo general.
- Ratificación del Proceso Unificado Ágil y decisión sobre el mecanismo técnico interno de iteración.
- Confirmación de si se requieren índices automáticos adicionales para tablas o figuras y del alcance de la observación sobre corchetes en los descriptores bibliográficos.
- Fecha oficial de inicio, fecha final e hitos del cronograma por objetivos.

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
| 8. Metodología | Aplicado; pendiente de ratificación | Proceso Unificado Ágil con fases, productos e hitos |
| Sección Propuesta | Trasladada y retirada | El contenido corresponde al Marco aplicativo del documento final |
| 9. Índice del documento final | Aplicado | Capítulo III seguido de Conclusiones y Recomendaciones |
| 10. Cronograma | Aplicado provisionalmente | Organizado por objetivos desde el 6 de julio; fechas pendientes de confirmación |
| Sección Recursos | Retirada | No forma parte del Perfil |
| 11. Bibliografía | Aplicado | Diecisiete referencias citadas y revisadas en APA 7 |
| 12. Anexos | Aplicado | Árbol de causas y efectos incorporado como Anexo A |

## 5. Verificaciones antes de entregar al profesor Víctor

- [ ] Cerrar todas las casillas operativas de las secciones 2.2 a 2.10 o registrar explícitamente cualquier excepción aprobada por el profesor Víctor.
- [x] Confirmar que los contenidos retirados del Perfil continúan en los tableros del Capítulo II o del Proyecto de Grado final, según su destino.
- [ ] Sincronizar título, problema, preguntas y objetivos con la estructura rectora y el Capítulo I.
- [x] Ejecutar la auditoría final de APA 7, mínimo de referencias, índice automático, numeración, figuras, tablas y referencias cruzadas.
- [x] Comprobar que el Perfil final conserve únicamente tres módulos y no prometa medición, certificación ni generación de bonos de carbono.
- [ ] Registrar la conformidad del profesor Víctor con la versión corregida.

## 6. Presentación posterior — fuera del alcance actual

- aplicar tamaño carta, margen izquierdo de 4 cm y demás márgenes de 3 cm;
- insertar logo UMSA proporcionado por el postulante;
- conservar las figuras que permanezcan después de la reestructuración y verificar el organigrama institucional y el árbol trasladado a Anexos;
- revisar pies de figura y tablas;
- aplicar saltos de página por capítulo únicamente en el documento final oficial, no en el Perfil;
- preparar diapositivas y guion de defensa, únicamente cuando se solicite.

## 7. Actividades posteriores a la aprobación del perfil

Después de aprobar el Perfil, [`TODO_PROYECTO_GRADO.md`](TODO_PROYECTO_GRADO.md) será el único tablero operativo de la ejecución, el inventario de la práctica actual, la evaluación, el Capítulo III y el cierre del documento final. Los capítulos I y II continuarán bajo el control especializado de [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md). El tablero de ejecución recibirá la metodología seleccionada en la sección 2.9 y el cronograma académico por objetivos definido en la sección 2.10; cualquier iteración o sprint que se conserve será únicamente un mecanismo técnico interno.

---

*Tablero actualizado el 25 de agosto de 2026.*
