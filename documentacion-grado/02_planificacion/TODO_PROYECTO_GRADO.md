# TODO — ejecución del Proyecto de Grado

> **Fecha de apertura:** 19 de agosto de 2026.
> **Revisión por observaciones de la tutora:** 25 de agosto de 2026.
> **Propósito:** convertir el Perfil en construcción demostrable, protocolo de investigación, evaluación y documento final. Este tablero comienza a ejecutarse en paralelo con el cierre del Perfil y se vuelve el tablero principal después de su aprobación.

> La revisión y cierre específicos de los capítulos I y II se controlan en [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md).

## 1. Decisiones cerradas y pendientes

- [x] Adoptar como título seleccionado por el postulante **Sistema de trazabilidad del material vegetal para reforestación con proyección hacia bonos de carbono: caso R3Foresta**, sujeto únicamente a la ratificación académica pendiente de la tutora.
- [x] Interpretar la proyección hacia bonos de carbono como un posible uso institucional futuro de la información trazable, sin ampliar el producto a monitoreo posterior, cuantificación de CO₂, MRV, validación, verificación, certificación, emisión o comercialización de créditos.
- [ ] Adoptar la metodología de desarrollo seleccionada y aprobada en la sección 2.9 de [`TODO.md`](TODO.md), y ajustar a ella la planificación interna; la decisión metodológica se controla únicamente en ese tablero.
- [ ] Después de adoptar la metodología, decidir si los sprints provisionales se conservan, se renombran como iteraciones o fases, o se eliminan; no utilizarlos como unidad del cronograma académico.
- [x] Demostrar la construcción académica dentro del semestre desde una referencia inicial académica del repositorio, conforme al criterio acordado con la docente de la UMSA.
- [x] Conservar los desarrollos anteriores solo como referencia técnica y factibilidad, no como evidencia de construcción formal.
- [x] Priorizar calidad sobre volumen de pruebas.
- [x] Excluir blockchain, NFT, contratos inteligentes e IPFS de la construcción, evaluación y contribución académica, sin exigir su eliminación de repositorios históricos.
- [x] Confirmar como decisión de alcance que el material vegetal adquirido o recibido de terceros ingresará por Vivero o directamente por Plantación, como variantes internas y no como un cuarto módulo; su implementación continúa pendiente en la sección 3.
- [x] Procurar comparación paralela de una misma actividad mediante la práctica habitual y R3foresta App.
- [x] Denominar **R3foresta App** a la aplicación, diferenciándola de R3Foresta como institución y de R3Carbon como componente institucional.

## 2. Línea base y evidencia de construcción

- [ ] Definir el repositorio, ramas y entorno que constituirán la referencia inicial académica.
- [ ] Crear una etiqueta o commit inicial que contenga solo la estructura autorizada y no los flujos funcionales que se construirán.
- [ ] Preparar una base de datos controlada y reproducible desde migraciones académicas.
- [ ] Registrar el inventario inicial: qué existe en la referencia inicial y qué todavía no existe.
- [ ] Conservar por sprint un paquete compacto de evidencia:
  - etiqueta o commit de inicio y cierre;
  - requerimientos y reglas abordados;
  - cambios principales de implementación;
  - migraciones aplicadas;
  - pruebas críticas y resultado;
  - captura o acta breve de demostración;
  - decisiones y desviaciones.
- [ ] Mantener por sprint la fila `planificado → realizado → evidencia → desviación → decisión → estado del gate`.
- [ ] Mantener un registro de riesgos e incidencias con impacto, mitigación, estado y efecto sobre el cronograma.
- [ ] Mantener la matriz DSR `problema → fuente → requisito de diseño → artefacto → demostración → evaluación → conclusión`.
- [ ] Registrar horas académicas por actividad y sprint.
- [ ] Diferenciar siempre referencia técnica previa, construcción académica y estado desplegado.

## 3. Planificación interna provisional por sprints

> Los sprints de esta sección son una herramienta interna provisional. No constituyen la metodología de desarrollo ni el cronograma académico aprobado. Se revisarán o reemplazarán después de seleccionar la metodología concreta y de confirmar con la tutora las fechas oficiales.

### Cronograma académico pendiente

- [ ] Adoptar la fecha exacta de inicio y las fechas de cierre que se confirmen en la sección 2.10 de [`TODO.md`](TODO.md).
- [ ] Formular el cronograma académico por objetivos, con un intervalo de fechas para cada objetivo, sin usar sprints como unidad de presentación.
- [ ] Conciliar la planificación interna provisional con la metodología elegida y el cronograma académico confirmado.

### Sprint 0 — Línea base, Perfil y preparación

- [ ] Cerrar Perfil y backlog académico.
- [ ] Evidenciar la referencia inicial académica del repositorio.
- [ ] Iniciar inventario documental de la práctica actual.
- [ ] Preparar versiones iniciales de los instrumentos.

### Sprint 1 — Recolección

- [ ] Construir M1 desde la referencia inicial.
- [ ] Documentar requerimientos, reglas, datos, interfaz y pruebas críticas de M1.
- [ ] Definir la información mínima de procedencia para material recolectado y recibido externamente.
- [ ] Generar paquete de evidencia del sprint.

### Sprint 2 — Vivero y Recolección→Vivero

- [ ] Construir M2 y el contrato M1→M2.
- [ ] Implementar en Vivero el ingreso de material vegetal adquirido o recibido de terceros, registrando el hecho de ingreso, el proveedor u organización de procedencia, la especie, la cantidad y unidad, la fecha, el responsable y la evidencia documental disponible.
- [ ] Probar saldo, transformación observada, merma y transferencia crítica.
- [ ] Generar paquete de evidencia del sprint.

### Sprint 3 — Plantación y Vivero→Plantación

- [ ] Construir M3 y el contrato M2→M3.
- [ ] Implementar en Plantación el ingreso directo de material vegetal adquirido o recibido de terceros, con los datos de procedencia disponibles y un historial diferenciado de las plantas procedentes de Vivero.
- [ ] Probar asignación, consumo, devolución y registro de plantación críticos.
- [ ] Generar paquete de evidencia del sprint.

### Sprint 4 — Reconstrucción transversal

- [ ] Construir la consulta o recorrido completo de una traza M1→M2→M3.
- [ ] Ejecutar un ensayo controlado del instrumento de reconstrucción.
- [ ] Corregir ambigüedades del instrumento y congelar su versión.
- [ ] Generar paquete de evidencia del sprint.

### Sprint 5 — Calidad y versión candidata

- [ ] Cerrar la deuda técnica crítica previa al piloto.
- [ ] Ejecutar la matriz mínima de pruebas críticas.
- [ ] Congelar commits, migraciones, configuración y datos de prueba de la versión candidata.
- [ ] Realizar ensayo operativo del piloto.
- [ ] Generar paquete de evidencia del sprint.

### Sprint 6 — Piloto y evaluación

- [ ] Obtener autorizaciones y consentimientos.
- [ ] Registrar en paralelo la práctica habitual y R3foresta App sobre la misma actividad cuando sea viable.
- [ ] Ejecutar reconstrucción independiente cuando exista una persona disponible.
- [ ] Consolidar resultados cuantitativos y cualitativos por traza.
- [ ] Diferenciar operaciones reales, reconstrucciones históricas y casos controlados.

### Sprint 7 — Resultados y cierre

- [ ] Responder cada pregunta de investigación y objetivo con evidencia.
- [ ] Redactar resultados, discusión, limitaciones, conclusiones y recomendaciones.
- [ ] Cerrar anexos, matriz de pruebas e instrumentos.
- [ ] Preparar versión para revisión y entrega.

## 4. Protocolo de la situación actual

> Esta sección es el único control operativo del diagnóstico y de la reconstrucción histórica. [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md) controla únicamente la incorporación de sus resultados en la redacción académica.

### 4.1. Delimitación

- [ ] Acordar con R3Foresta el inicio y fin del periodo documental.
- [ ] Identificar todas las actividades de reforestación realizadas durante ese periodo.
- [ ] Definir y congelar criterios de inclusión y exclusión de actividades y trazas.
- [ ] Incluir todas las trazas elegibles; no seleccionar únicamente las mejor documentadas.
- [ ] Conservar una bitácora de exclusiones y sus motivos.
- [ ] Distinguir actividades reales, reconstrucciones históricas y casos controlados.

### 4.2. Actores y procesos

- [ ] Identificar responsables reales de Recolección, Vivero y Plantación.
- [ ] Identificar responsables administrativos o institucionales que solicitan información.
- [ ] Identificar comunidades, voluntarios, patrocinadores y aliados que intervienen.
- [ ] Describir cómo comienza y termina cada proceso en la práctica actual.
- [ ] Confirmar si ocurren ingresos externos directamente en Vivero o Plantación.
- [ ] Confirmar si en la práctica se dividen, agrupan o mezclan lotes.
- [ ] Registrar actividades con o sin conectividad, dispositivos y condiciones reales de trabajo en campo.

### 4.3. Fuentes de información

- [ ] Inventariar por actividad fotografías, mensajería, publicaciones, cuadernos, notas, formularios, hojas de cálculo, archivos y sistemas anteriores.
- [ ] Identificar qué información existe únicamente en la memoria de los responsables.
- [ ] Registrar quién conserva cada fuente y dónde se encuentra.
- [ ] Comprobar si las fuentes comparten identificadores de actividad, lote o especie.
- [ ] Comprobar si las unidades de medida son consistentes.
- [ ] Comprobar si las evidencias se relacionan con fechas, responsables y ubicaciones.

### 4.4. Reconstrucción y entrega de resultados

- [ ] Aplicar las definiciones, categorías y reglas de medición preparadas en la sección 5.
- [ ] Reconstruir cada traza primero con documentos y después con documentos más la memoria del responsable.
- [ ] Mantener separados los resultados de ambas pasadas.
- [ ] Conservar ejemplos anonimizados de vacíos y contradicciones.
- [ ] Entregar al tablero de capítulos el corpus delimitado, los resultados de caracterización y la evidencia necesaria para redactar, sin convertir la existencia del problema en una hipótesis pendiente.

## 5. Métricas e instrumentos mínimos

> Esta sección es el destino operativo del alcance de evaluación y de los instrumentos diferidos desde el Perfil; sus resultados se consolidarán en el documento final.

- [ ] Definir la lista común de ítems de reconstrucción: procedencia, material o especie, cantidades y unidades, eventos o transformaciones, responsables, fecha, ubicación, destino y evidencia.
- [ ] Definir para cada ítem las categorías `COMPLETO`, `PARCIAL`, `AUSENTE` y `CONTRADICTORIO` con un ejemplo.
- [ ] Definir cuándo una evidencia se considera vinculada y recuperable.
- [ ] Definir inicio y final del cronometraje y cómo registrar pausas.
- [ ] Definir qué cuenta como reintento, error y solicitud de ayuda.
- [ ] Medir carga de registro con duración, reintentos, errores, ayuda y dificultad reportada; no crear un índice compuesto innecesario.
- [ ] Preparar y versionar:
  - guía de reconstrucción;
  - lista de cotejo documental;
  - hoja de cronometraje y carga;
  - guía breve de entrevista;
  - protocolo de observación;
  - consentimiento informado;
  - matriz de pruebas.
- [ ] Probar todos los instrumentos con una traza controlada antes del piloto definitivo.

## 6. Análisis cualitativo e integración

> Esta sección es el destino operativo del análisis diferido desde el Perfil; la formulación definitiva describirá lo efectivamente ejecutado en el documento final.

- [ ] Crear una plantilla inicial con las categorías: claridad, carga, dificultades, interrupciones y confianza en la reconstrucción.
- [ ] Permitir categorías emergentes sin borrar la plantilla ni cambiar silenciosamente preguntas ya aplicadas.
- [ ] Mantener una tabla `fuente → fragmento/observación → código → hallazgo → objetivo`.
- [ ] Conservar citas anonimizadas que respalden los hallazgos principales.
- [ ] Revisar con la tutora o una segunda persona una muestra de la codificación.
- [ ] Integrar por traza métricas, fuentes, observaciones y explicación cualitativa.
- [ ] No presentar frecuencia de comentarios como inferencia estadística.

## 7. Verificación técnica mínima de calidad

- [ ] Construir la matriz `requerimiento → regla → invariante → mecanismo → prueba → resultado` únicamente para el alcance académico vigente.
- [ ] Cubrir como mínimo:
  1. saldo no negativo y consumo no superior al disponible;
  2. transferencia atómica M1→M2;
  3. asignación y consumo coherentes M2→M3;
  4. doble consumo o asignación concurrente rechazados;
  5. fallo crítico sin estado parcial;
  6. reconstrucción extremo a extremo con evidencia.
- [ ] Agregar casos adicionales solo cuando exista riesgo o defecto que los justifique.
- [ ] Registrar ambiente, datos, versión, resultado esperado y resultado observado.

## 8. Deuda técnica interna previa al piloto

> Estas tareas son un gate interno de calidad y seguridad. No se convierten en el foco narrativo del Perfil.

- [ ] Derivar identidad desde JWT validado y eliminar confianza productiva en identificadores enviados sin validación.
- [ ] Proteger o retirar endpoints privilegiados y de diagnóstico fuera del alcance académico.
- [ ] Eliminar registro o sesión mock del flujo productivo del piloto.
- [ ] Exigir configuración segura de secretos.
- [ ] Cerrar los desajustes de migraciones necesarios para reconstruir la base académica desde cero.
- [ ] Alinear los contratos críticos que todavía difieren de la implementación.
- [ ] Incorporar pruebas frontend mínimas para los recorridos utilizados en el piloto.
- [ ] Confirmar que blockchain, Pinata o IPFS no bloqueen ni contaminen el flujo académico evaluado.

## 9. Ética y custodia de datos

> Esta sección es el destino operativo de las consideraciones éticas diferidas desde el Perfil; su aplicación y evidencia se documentarán en la versión final.

- [ ] Relacionar los perfiles y roles del sistema con las operaciones permitidas durante el piloto.
- [ ] Definir separadamente quién puede acceder a datos de investigación.
- [ ] Definir almacenamiento, respaldo, seudonimización, conservación y eliminación.
- [ ] Identificar fotografías, coordenadas y nombres que requieran protección especial.
- [ ] Definir procedimiento para retiro de consentimiento.
- [ ] Separar datos operativos, datos anonimizados para análisis y datos controlados de prueba.
- [ ] No proporcionar datos personales o sensibles a agentes de IA sin autorización y anonimización.

## 10. Alcance y coherencia documental

- [ ] Mantener en el documento final y en la defensa la delimitación del título: la trazabilidad M1→M2→M3 constituye una base informacional potencial para procesos futuros de carbono, pero el sistema académico no registra ni calcula captura de CO₂, no implementa MRV y no genera, certifica, emite ni comercializa bonos o créditos de carbono.
- [ ] Especificar los ingresos externos de Vivero y Plantación en requerimientos, reglas, historial de eventos, modelo de datos, interfaz, pruebas y documentación académica.
- [ ] Verificar al cierre que el ingreso externo esté implementado tanto en Vivero como directamente en Plantación y que corresponda con la decisión de alcance de la sección 1.
- [ ] Excluir blockchain, NFT, contratos inteligentes e IPFS de objetivos, incrementos académicos, pruebas, resultados y conclusiones.
- [ ] Mantener exactamente tres módulos.
- [ ] Propagar al plan, los instrumentos y el documento final la metodología aprobada en [`TODO.md`](TODO.md), después de que el Perfil y los lineamientos queden sincronizados desde su tablero propio.
- [ ] Aplicar la lista de revisión de [`criterios_editoriales_proyecto_grado.md`](../01_lineamientos/criterios_editoriales_proyecto_grado.md) antes de cerrar cada sección o documento posterior al Perfil.

## 11. Documento final y defensa

- [ ] Integrar las versiones aprobadas de los capítulos I y II conforme a [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md), que es el único tablero operativo de su diseño metodológico y su teoría avanzada.
- [ ] Desarrollar el Capítulo III como Marco aplicativo e incorporar la propuesta de solución, el aporte de ingeniería, la integración entre etapas y los resultados de construcción, verificación y evaluación.
- [ ] Ubicar después del Capítulo III las secciones de Conclusiones y Recomendaciones, seguidas por las referencias y los anexos.
- [ ] Mantener una cadena de evidencia desde dato o commit hasta conclusión.
- [ ] Si se amplía la recolección o construcción sustantiva, actualizar formalmente cronograma y fechas de corte.
- [ ] Redactar el Resumen y las palabras clave al cierre del documento final, una vez estabilizados los resultados y las conclusiones.
- [ ] Validar con la tutora las fechas de entrega, correcciones, maquetación y defensa antes de programar el cierre; no asumir todavía fines de noviembre o inicios de diciembre.

---

*Tablero abierto el 19 de agosto de 2026.*
