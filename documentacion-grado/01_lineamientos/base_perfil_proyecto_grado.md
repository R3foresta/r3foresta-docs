# Lineamientos estratégicos y principios de trazabilidad del Proyecto de Grado

> **Versión 13 — 27 de agosto de 2026.**
> Este documento fija las decisiones que deben mantenerse coherentes desde el Perfil hasta los requerimientos, el diseño, la implementación, las pruebas, la evaluación y el documento final. El texto entregable vive en [PERFIL_PROYECTO_GRADO.md](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md).
> La redacción de los artefactos posteriores al Perfil se rige además por [criterios_editoriales_proyecto_grado.md](criterios_editoriales_proyecto_grado.md).

## 1. Enfoque del proyecto

R3Foresta tiene como objetivo organizacional de largo plazo fortalecer la confianza y explorar mecanismos de financiamiento ambiental. El Proyecto de Grado no intenta resolver ese objetivo completo. Se concentra en una capa anterior y necesaria: registrar y reconstruir la cadena de custodia del material vegetal utilizado para reforestación.

El resultado académico es un sistema de trazabilidad con evidencia contrastable. No es una certificación de plantación, supervivencia, captura de carbono ni crédito de carbono.

### Vocabulario adoptado

- **Semillas y plantas:** expresión introductoria utilizada para explicar el proceso a lectores sin conocimiento previo del dominio.
- **Material vegetal:** denominación general utilizada después de esa explicación para referirse de manera delimitada a las semillas, plantas y demás unidades de propagación comprendidas en el proceso.
- **Trazabilidad:** posibilidad de recuperar información relacionada con un objeto a lo largo de su recorrido.
- **Cadena de custodia:** relaciones de procedencia, transferencia y responsabilidad sobre el material vegetal.
- **Trazabilidad reconstruible:** capacidad de recomponer una traza desde registros relacionados.
- **Evidencia contrastable:** fotografías, datos temporales, geográficos o documentales vinculados con el hecho al que respaldan.
- **Invariante:** condición de consistencia que debe preservarse antes y después de una operación.
- **Transferencia:** movimiento de material entre ubicaciones, responsables o etapas que conserva una relación directa de cantidad.
- **Transformación:** hecho que puede modificar el estado, la naturaleza, la cantidad o la unidad de medida del material y producir una nueva cantidad observable.
- **Bonos de carbono:** expresión utilizada en el título para señalar una proyección institucional futura. No denomina una capacidad implementada ni evaluada por el Proyecto de Grado.

No calificar los registros como “certificados”, “certificables”, “auditables” o “verificables”. El término “verificación” se reserva para requerimientos e invariantes sometidos a pruebas.

## 2. Título seleccionado

> **Sistema de trazabilidad del material vegetal para reforestación con proyección hacia bonos de carbono: caso R3Foresta**

El título seleccionado permanece pendiente de ratificación académica. La expresión *con proyección hacia bonos de carbono* comunica una finalidad institucional posterior y no incorpora al alcance medición de carbono, MRV, certificación, emisión ni comercialización de créditos.

La expresión *caso R3Foresta* delimita la organización y el contexto de aplicación del producto. No declara la adopción de un diseño investigativo de estudio de caso.

No incluir en el título eventos, contratos atómicos, blockchain, NFT, IPFS ni MRV. La única referencia admitida al carbono es la proyección acotada expresada en el título seleccionado.

## 3. Problema

La práctica actual conserva fotografías, mensajes, redes sociales, cuadernos y memoria de los responsables, pero no una estructura común para vincular procedencia, manejo, cantidades, responsables, evidencia y plantación.

El recorrido principal comprende Recolección, Vivero y Plantación. Para el alcance académico, se inicia con el origen registrado: una recolección de semillas o la incorporación, en Vivero o Plantación, de material vegetal adquirido externamente; concluye con el registro de su plantación.

La falta de relaciones comunes limita la reconstrucción de la cadena, la consistencia de saldos y la información presentada a patrocinadores y aliados.

## 4. Objetivos vigentes

Los objetivos deben mantener correspondencia con el problema, el alcance y la evaluación. Cualquier modificación sustantiva de su redacción deberá revisarse formalmente con la tutora.

### Objetivo general

Desarrollar un sistema web que permita a R3Foresta registrar, organizar y relacionar la información generada en las actividades de Recolección, Vivero y Plantación, para reconstruir, a partir de sus registros, el recorrido del material vegetal desde su origen registrado hasta el registro de su plantación.

### Objetivos específicos

1. **Analizar** la información que se genera y cómo se gestiona actualmente en las actividades de Recolección, Vivero y Plantación de R3Foresta.
2. **Diseñar** la organización de la información y las relaciones necesarias para reconstruir el recorrido registrado del material vegetal desde su origen registrado hasta el registro de su plantación.
3. **Implementar** en el sistema las funciones de Recolección, Vivero y Plantación necesarias para mantener vinculada la información del material vegetal durante su recorrido.
4. **Verificar** que las funciones implementadas cumplan los requerimientos definidos y que los registros mantengan coherencia entre las cantidades y los movimientos del material vegetal.
5. **Evaluar**, mediante escenarios operativos representativos, en qué medida el sistema permite reconstruir, a partir de sus registros y evidencias, el recorrido del material vegetal.

Cada objetivo mantiene un verbo rector y produce una sección principal de resultados.

## 5. Alcance funcional

### Incluido

- M1 Recolección;
- M2 Vivero;
- M3 Plantación;
- incorporación, en Vivero o Plantación, de material vegetal adquirido externamente, con la procedencia disponible del material;
- reconstrucción del origen y recorrido del material vegetal;
- eventos e historial como capacidad transversal de los tres módulos;
- conservación de las relaciones entre material de origen, eventos, material resultante y destino;
- reglas para prevenir cantidades negativas, consumos o asignaciones superiores al disponible, doble consumo, doble asignación y saldos incoherentes;
- coherencia de cantidades y saldos durante transferencias y transformaciones;
- evidencia fotográfica, temporal y geográfica;
- pruebas funcionales y técnicas de las reglas críticas;
- validación mediante escenarios operativos, criterios de aceptación y reconstrucción de recorridos registrados.

### Excluido

- créditos de carbono y certificaciones;
- cuantificación de biomasa o CO₂;
- adicionalidad, permanencia y línea base de carbono;
- monitoreo, crecimiento o mantenimiento posteriores al registro de la plantación;
- garantía de supervivencia;
- blockchain, NFT, contratos inteligentes e IPFS;
- autenticidad forense de evidencia;
- despliegue nacional;

La existencia de prototipos o componentes históricos excluidos no obliga a eliminarlos de los repositorios técnicos. No deberán integrar la construcción académica, la matriz de cumplimiento, la evaluación ni las conclusiones del Proyecto de Grado.

## 6. Aporte de ingeniería

El aporte no es el número de pantallas. Se encuentra en la combinación de:

- modelo de procedencia y reconstrucción del recorrido;
- hechos operativos registrados como eventos;
- cantidades y saldos explicables mediante los hechos que los produjeron;
- tratamiento diferenciado de transferencias y transformaciones;
- invariantes de cantidad, disponibilidad, asignación y consumo;
- consistencia de las operaciones incluso ante solicitudes simultáneas o fallos;
- evidencia vinculada con su hecho;
- trazabilidad desde requerimiento y regla hasta prueba.

El Perfil compromete estas propiedades, no una arquitectura concreta. Las decisiones sobre transacciones, bloqueos, funciones de base de datos, control de concurrencia, compensaciones u otros mecanismos se definirán y justificarán en las fases posteriores de análisis, diseño e implementación.

## 7. Principios de trazabilidad y comprobación del proyecto

1. **Trazabilidad no equivale a CRUD.** El valor del sistema no está solamente en registrar datos, sino en conservar relaciones y eventos suficientes para reconstruir posteriormente el recorrido del material vegetal.
2. **Evento antes que estado aislado.** Cuando una cantidad, estado o ubicación cambie, deberá poder identificarse el hecho que produjo ese cambio; no se debe sobrescribir el estado actual sin conservar su explicación.
3. **Las cantidades deben poder explicarse.** Los saldos actuales deberán relacionarse con los eventos anteriores que los produjeron.
4. **Transferencia y transformación son conceptos diferentes.** Una transferencia mueve material; una transformación puede modificar estado, naturaleza, cantidad o unidad de medida. No se asumirá una conversión aritmética automática entre gramos de semillas y cantidad de plantas.
5. **La procedencia debe conservarse.** El recorrido del material vegetal se iniciará con el origen registrado: una recolección de semillas o la incorporación de material adquirido externamente en Vivero o Plantación. Durante las tres etapas conservará la información disponible sobre especie, cantidad, unidad, fecha, responsable, ubicación, procedencia y evidencia.
6. **La evidencia respalda, no certifica.** Fotografías, fechas, ubicaciones y otros datos fortalecen el respaldo documental del evento, pero no prueban de forma absoluta la correspondencia con el mundo físico.
7. **La validación debe intentar reconstruir.** La comprobación central no será solo guardar registros, sino determinar si puede reconstruirse de manera coherente qué ocurrió con un material determinado.
8. **Integridad y reconstrucción son complementarias.** No basta con conservar un historial; cantidades, asignaciones y saldos también deben mantener coherencia.
9. **La solución técnica permanece abierta durante el Perfil.** El Perfil define propiedades deseadas; los mecanismos concretos se decidirán y justificarán posteriormente.
10. **La validación se basa en escenarios representativos.** Cada escenario registrará pasos, resultados, evidencias y observaciones, sin convertir la validación en un estudio comparativo.
11. **La verificación se concentra en riesgo y evidencia.** Se mantendrá un conjunto pequeño de pruebas de calidad sobre invariantes y recorridos críticos; el volumen de casos o archivos de prueba no es un resultado académico por sí mismo.
12. **La construcción formal debe ser demostrable.** Cada iteración e incremento conservará evidencia versionada de los productos construidos.

## 8. Propagación a los artefactos posteriores

| Artefacto | Decisión que debe conservar |
|---|---|
| Planteamiento del problema y objetivos | Dificultad de reconstruir el recorrido de manera consistente, sin prometer certificación externa |
| Metodología de desarrollo | RUP adaptado como proceso rector; Spec-Driven Development asistido por IA como práctica de trabajo; desarrollo iterativo e incremental y evidencia versionada |
| Requerimientos y reglas de negocio | Disponibilidad, saldos, doble consumo, doble asignación, transferencias, transformaciones, procedencia e historial de eventos |
| Modelo de datos | Relaciones entre material de origen, eventos, material resultante, cantidades, unidades, responsables y etapas |
| Modelo de eventos | Qué ocurrió, sobre qué material, cuándo, dónde, quién intervino, qué cantidad participó, qué cantidad resultó y qué evidencia se asoció |
| Plan de pruebas | Conjunto mínimo de calidad sobre reglas críticas de integridad y escenarios completos de reconstrucción |
| Marco teórico | Trazabilidad, procedencia, cadena de custodia, eventos, transformaciones, consistencia de cantidades, reconstrucción, integridad de registros, RUP, Spec-Driven Development y asistencia de IA |
| Discusión y conclusiones | Diferencia entre respaldo digital y verdad física; cumplimiento técnico, resultados de aceptación y límites de la validación realizada |
| Todos los artefactos posteriores al Perfil | Lenguaje académico claro, separación entre propiedad, mecanismo y prueba, nivel de detalle adecuado y afirmaciones que puedan respaldarse con evidencia |

## 9. Metodología de desarrollo

El proyecto no incorpora un marco de investigación independiente. Su proceso rector es una **adaptación de Rational Unified Process (RUP)**, complementada con **Spec-Driven Development (SDD) asistido por inteligencia artificial**.

### Proceso rector: RUP adaptado

- ejecución formal del 6 de julio al 15 de noviembre de 2026;
- cuatro fases: Inicio, Elaboración, Construcción y Transición;
- hitos de ciclo de vida: objetivos (LCO), arquitectura (LCA), capacidad operativa inicial (IOC) y liberación del producto (PR);
- proceso dirigido por casos de uso, centrado en la arquitectura e iterativo e incremental; los riesgos prioritarios orientan el contenido de las iteraciones;
- siete iteraciones: IN-1, EL-1, CO-1 a CO-4 y TR-1;
- adaptación al tamaño del proyecto: se simplifican roles y documentos, se conservan solo artefactos que aportan evidencia y no se instalan ceremonias ni roles de Scrum;
- construcción progresiva de M1 Recolección, M2 Vivero y M3 Plantación, con integración M1→M2, M2→M3 y trazabilidad transversal.

RUP estructura el proyecto completo. Sus cuatro fases no se repiten como un miniproyecto por módulo. Una iteración es el intervalo de trabajo que recorre las disciplinas pertinentes y concluye con una revisión; un incremento es la versión ejecutable resultante. Los módulos se materializan mediante los cuatro incrementos de las iteraciones de Construcción.

### Práctica de trabajo: SDD asistido por IA

Cada capacidad seguirá un protocolo propio basado en el flujo central de GitHub Spec Kit y en la cadena `necesidad → requisito → especificación → diseño → tareas → implementación → pruebas → resultado → aceptación`. La especificación versionada será el contrato de trabajo antes de modificar el código. La IA podrá apoyar el análisis, la redacción, la generación de alternativas, la implementación y las pruebas, pero no reemplazará la decisión, revisión, ejecución de pruebas ni aceptación humanas.

La construcción conserva evidencia por iteración e incremento.

### Asistencia de IA

Los agentes de IA Claude Code y Codex apoyarán la descomposición de tareas, implementación, revisión, pruebas y redacción. Toda salida será revisada y comprobada antes de su aceptación; las decisiones del dominio y la responsabilidad son humanas. Cada aporte material registrará herramienta y versión disponible, tarea, artefacto afectado, decisión humana, prueba y referencia al cambio.

## 10. Verificación, validación y aceptación

La comprobación del producto se incorpora al ciclo de ingeniería y no se presenta como una metodología investigativa:

1. **Verificación:** pruebas unitarias, de integración, funcionales, de regresión y de reglas críticas para comprobar requisitos, contratos e invariantes.
2. **Validación operativa:** escenarios representativos para reconstruir origen, eventos, cantidades, responsables, evidencias y destino a partir de los registros de la aplicación.
3. **Aceptación:** criterios verificables acordados para cada incremento y para el producto integrado, con registro de resultado, defecto, corrección y decisión.

Cuando no exista una operación real disponible, el escenario se identificará como controlado. Los resultados no se generalizarán fuera del producto y contexto validados ni se convertirán en afirmaciones causales sobre mejoras no medidas.

## 11. Justificación

- **Técnica:** integridad de operaciones y transferencias bajo concurrencia y fallos.
- **Operativa:** disponibilidad, pérdidas, asignaciones y responsables reconstruibles.
- **Comercial:** información más consistente para patrocinadores y aliados.
- **Académica:** vínculo entre análisis, diseño, implementación, integración, verificación, validación y aceptación.
- **Económica:** infraestructura de bajo costo y medición del tiempo antes de afirmar ahorro.
- **Social y ambiental:** mejor rendición de cuentas sin atribuir éxito ecológico al software.

## 12. Cronograma rector

- **Inicio, iteración IN-1, 6–19 de julio:** visión, alcance, actores, requisitos iniciales, riesgos, plan e hito LCO;
- **Elaboración, iteración EL-1, 20 de julio–16 de agosto:** requisitos prioritarios, arquitectura base, línea vertical arquitectónica mínima, modelo de trazabilidad, contratos de integración y hito LCA;
- **Construcción, iteración CO-1 e incremento 1, 17 de agosto–6 de septiembre:** M1 Recolección funcional y probado;
- **Construcción, iteración CO-2 e incremento 2, 7–27 de septiembre:** M2 Vivero, integración M1→M2 y pruebas integradas;
- **Construcción, iteración CO-3 e incremento 3, 28 de septiembre–18 de octubre:** M3 Plantación, integración M2→M3 y pruebas integradas;
- **Construcción, iteración CO-4 e incremento 4, 19 de octubre–1 de noviembre:** trazabilidad transversal, integración total, regresión, versión candidata e hito IOC;
- **Transición, iteración TR-1, 2–15 de noviembre:** validación, correcciones, despliegue, manuales, aceptación, hito PR y cierre documental.

## 13. Recursos

- agentes de IA mediante una suscripción alternada entre Claude Code y Codex;
- conexión a Internet, datos móviles, transporte y alimentación para las actividades de campo;
- Supabase, Vercel, Render, GitHub y subdominio de Vercel;
- computadora portátil, teléfonos móviles y herramientas de desarrollo y documentación;
- acceso al contexto operativo y participación de R3Foresta.

## 14. Reglas de consistencia documental

Antes de cerrar cualquier versión:

1. problema y pregunta deben referirse al origen registrado del material vegetal sin convertir una procedencia alternativa en el foco;
2. deben conservarse exactamente tres módulos;
3. las variantes de ingreso deben resolverse dentro de los módulos existentes y no como una línea de trabajo independiente;
4. no deben reaparecer blockchain o créditos de carbono dentro del alcance;
5. la validación debe distinguir pruebas técnicas, escenarios operativos y aceptación, sin presentar sus resultados como un estudio causal o estadístico;
6. no se deben prometer mejoras, ahorros o certificaciones antes de medirlos;
7. deben diferenciarse verificación técnica, validación operativa y aceptación;
8. debe mantenerse la declaración transparente de autoría y asistencia;
9. recursos y cronograma deben coincidir con el perfil oficial; el Perfil no incluirá presupuesto;
10. la construcción formal debe conservar evidencia de cada iteración e incremento;
11. el cronograma debe conservar las cuatro fases RUP, las siete iteraciones y los cuatro incrementos de Construcción, incluidos los tres módulos, ambas integraciones y la trazabilidad transversal;
12. los agentes de IA deben aparecer como apoyo bajo revisión y aprobación humanas;
13. cualquier cambio académico acordado con la docente o la tutora debe propagarse al perfil, estructura y TODO;
14. “semillas y plantas” debe introducir el dominio y “material vegetal” debe utilizarse después como denominación general;
15. transferencia y transformación deben mantenerse diferenciadas en requerimientos, datos, eventos, reglas y pruebas;
16. toda evidencia debe describirse como respaldo del registro, no como certificación de la realidad física;
17. el Perfil debe expresar propiedades deseadas sin comprometer prematuramente mecanismos de implementación;
18. cualquier nueva documentación del Proyecto de Grado debe revisar los principios de las secciones 7 y 8 antes de cerrarse;
19. las incorporaciones de material vegetal adquirido externamente en Vivero y Plantación deben contar con requisitos, diseño, implementación y pruebas antes de cerrar el objetivo específico 3;
20. cada iteración debe contar con objetivos, riesgos, productos y revisión; cada incremento debe contar con especificación, criterios de aceptación, implementación, pruebas, resultado y evidencia de integración;
21. el uso de IA debe registrarse como asistencia bajo revisión humana; ninguna salida se acepta sin revisión humana;
23. las deudas técnicas críticas para identidad, seguridad, migraciones y pruebas deberán cerrarse antes de la liberación sin convertirlas en el foco narrativo del Perfil.
24. toda sección posterior al Perfil deberá aplicar la lista de revisión de [criterios_editoriales_proyecto_grado.md](criterios_editoriales_proyecto_grado.md) antes de cerrarse.
25. la fuente canónica y única versión editable del Perfil dentro del repositorio será su archivo Markdown; las versiones aprobadas se transferirán directamente al Google Docs existente en Drive, que será el documento de trabajo y presentación; el DOCX local quedará fuera del flujo;
26. el Perfil no requiere saltos de página después de cada encabezado principal; el documento final oficial sí iniciará cada capítulo principal en una página nueva al maquetarse.
27. antes de cerrar el diseño y la validación, debe definirse conceptualmente el “recorrido del material vegetal” como una secuencia observable de origen, ingresos, procesos o cambios, movimientos y destino, acompañada por las cantidades, responsables, fechas, ubicaciones y evidencias que correspondan;
28. los escenarios operativos representativos deben seleccionarse y justificarse a partir de variantes reales del proceso de R3Foresta; los ingresos externos, si permanecen en alcance, deben contar con diseño, implementación, verificación y al menos un escenario de evaluación pertinente.
27. los documentos institucionales se utilizarán de manera acotada para el contexto que respalden directamente; no podrán redefinir el problema, el título, los objetivos, el alcance, la metodología o la evaluación sin una validación explícita y una revisión completa de consistencia.
28. toda tabla del Perfil y del documento final deberá incluir inmediatamente debajo una nota que identifique su procedencia; si es de elaboración propia, también deberá indicar las fuentes, los datos, las secciones o las decisiones que sirvieron de base, conforme a [criterios_editoriales_proyecto_grado.md](criterios_editoriales_proyecto_grado.md).

---

*Lineamiento actualizado el 27 de agosto de 2026.*
