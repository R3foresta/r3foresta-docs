# Lineamientos estratégicos y principios de trazabilidad del Proyecto de Grado

> **Versión 10 — 19 de agosto de 2026.**
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

No calificar los registros como “certificados”, “certificables”, “auditables” o “verificables”. El término “verificación” se reserva para requerimientos e invariantes sometidos a pruebas.

## 2. Título propuesto

> **Sistema de trazabilidad de material vegetal para reforestación: caso R3Foresta**

El título es deliberadamente simple y no anticipa la arquitectura. Está pendiente de aprobación de la tutora, Ph.D. Marisol Téllez Ramírez.

No incluir en el título eventos, contratos atómicos, blockchain, NFT, IPFS, bonos de carbono ni MRV.

## 3. Problema

La práctica actual conserva fotografías, mensajes, redes sociales, cuadernos y memoria de los responsables, pero no una estructura común para vincular procedencia, manejo, cantidades, responsables, evidencia y plantación.

El recorrido principal comprende Recolección, Vivero y Plantación. El sistema admitirá material vegetal adquirido o recibido de terceros que ingrese directamente en Vivero o Plantación; estas entradas se tratarán como variantes integradas en los módulos existentes y no como un cuarto módulo o un entregable independiente.

La falta de relaciones comunes limita la reconstrucción de la cadena, la consistencia de saldos y la información presentada a patrocinadores y aliados.

## 4. Objetivos vigentes

Los objetivos deben mantener correspondencia con el problema, el alcance y la evaluación. Cualquier modificación sustantiva de su redacción deberá revisarse formalmente con la tutora.

### Objetivo general

Desarrollar y evaluar un sistema de trazabilidad para la cadena de custodia del material vegetal utilizado por R3Foresta, desde su recolección o recepción externa hasta su manejo en vivero y plantación, que permita reconstruir con evidencia contrastable su procedencia, movimientos, cantidades, responsables y destino.

### Objetivos específicos

1. **Analizar** procesos, actores, datos, estados, eventos, unidades, requerimientos y reglas de Recolección, Vivero y Plantación, incluidas las variantes de ingreso de material vegetal adquirido o recibido de terceros.
2. **Diseñar** el modelo de trazabilidad, integridad, invariantes y transferencias.
3. **Implementar** Recolección, Vivero y Plantación, incorporando el ingreso de material vegetal adquirido o recibido de terceros directamente en Vivero o Plantación, con sus datos de procedencia y su registro en el historial.
4. **Verificar** requerimientos e invariantes mediante pruebas funcionales y técnicas.
5. **Evaluar** capacidad de reconstrucción y carga operativa mediante la caracterización de la práctica actual y un piloto.

Cada objetivo mantiene un verbo rector y produce una sección principal de resultados.

## 5. Alcance funcional

### Incluido

- M1 Recolección;
- M2 Vivero;
- M3 Plantación;
- ingreso de material vegetal adquirido o recibido de terceros directamente en Vivero o Plantación, resuelto dentro de los módulos existentes y registrado como hecho del historial con sus datos de procedencia disponibles;
- reconstrucción del origen y recorrido del material vegetal;
- eventos e historial como capacidad transversal de los tres módulos;
- conservación de las relaciones entre material de origen, eventos, material resultante y destino;
- reglas para prevenir cantidades negativas, consumos o asignaciones superiores al disponible, doble consumo, doble asignación y saldos incoherentes;
- coherencia de cantidades y saldos durante transferencias y transformaciones;
- evidencia fotográfica, temporal y geográfica;
- pruebas funcionales y técnicas de las reglas críticas;
- evaluación de reconstrucción, integridad, operación real, comparación con la situación actual y carga operativa.

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

## 7. Principios de trazabilidad y evaluación del proyecto

1. **Trazabilidad no equivale a CRUD.** El valor del sistema no está solamente en registrar datos, sino en conservar relaciones y eventos suficientes para reconstruir posteriormente el recorrido del material vegetal.
2. **Evento antes que estado aislado.** Cuando una cantidad, estado o ubicación cambie, deberá poder identificarse el hecho que produjo ese cambio; no se debe sobrescribir el estado actual sin conservar su explicación.
3. **Las cantidades deben poder explicarse.** Los saldos actuales deberán relacionarse con los eventos anteriores que los produjeron.
4. **Transferencia y transformación son conceptos diferentes.** Una transferencia mueve material; una transformación puede modificar estado, naturaleza, cantidad o unidad de medida. No se asumirá una conversión aritmética automática entre gramos de semillas y cantidad de plantas.
5. **La procedencia debe conservarse.** Cuando material vegetal adquirido o recibido de terceros ingrese directamente a Vivero o Plantación, su historial comenzará con el hecho de ingreso externo y conservará la información disponible sobre proveedor u organización de procedencia, especie, cantidad, unidad, fecha, responsable y evidencia documental, sin crear un cuarto módulo ni atribuir una recolección inexistente.
6. **La evidencia respalda, no certifica.** Fotografías, fechas, ubicaciones y otros datos fortalecen el respaldo documental del evento, pero no prueban de forma absoluta la correspondencia con el mundo físico.
7. **La evaluación debe intentar reconstruir.** La prueba central no será solo guardar registros, sino comprobar si otra persona puede reconstruir de manera coherente qué ocurrió con un material determinado.
8. **Integridad y reconstrucción son complementarias.** No basta con conservar un historial; cantidades, asignaciones y saldos también deben mantener coherencia.
9. **La solución técnica permanece abierta durante el Perfil.** El Perfil define propiedades deseadas; los mecanismos concretos se decidirán y justificarán posteriormente.
10. **La carga operativa también importa.** La calidad de la trazabilidad se evaluará considerando el esfuerzo requerido para producir los registros necesarios.
11. **La verificación se concentra en riesgo y evidencia.** Se mantendrá un conjunto pequeño de pruebas de calidad sobre invariantes y recorridos críticos; el volumen de casos o archivos de prueba no es un resultado académico por sí mismo.
12. **La construcción formal debe ser demostrable.** El sistema académico partirá de una referencia inicial del repositorio y cada sprint conservará evidencia versionada de lo construido dentro del semestre.

## 8. Propagación a los artefactos posteriores

| Artefacto | Decisión que debe conservar |
|---|---|
| Planteamiento del problema y objetivos | Dificultad de reconstruir el recorrido de manera consistente, sin prometer certificación externa |
| Metodología | DSRM, caso único embebido, censo documental delimitado, comparación paralela cuando sea posible, reconstrucción, reglas de integridad y carga operativa |
| Requerimientos y reglas de negocio | Disponibilidad, saldos, doble consumo, doble asignación, transferencias, transformaciones, procedencia e historial de eventos |
| Modelo de datos | Relaciones entre material de origen, eventos, material resultante, cantidades, unidades, responsables y etapas |
| Modelo de eventos | Qué ocurrió, sobre qué material, cuándo, dónde, quién intervino, qué cantidad participó, qué cantidad resultó y qué evidencia se asoció |
| Plan de pruebas | Conjunto mínimo de calidad sobre reglas críticas de integridad y escenarios completos de reconstrucción |
| Marco teórico | Trazabilidad, procedencia, cadena de custodia, eventos, transformaciones, consistencia de cantidades, historial de auditoría, reconstrucción e integridad de registros |
| Discusión y conclusiones | Diferencia entre respaldo digital y verdad física; límites del estudio de caso y carga operativa observada |
| Todos los artefactos posteriores al Perfil | Lenguaje académico claro, separación entre propiedad, mecanismo y prueba, nivel de detalle adecuado y afirmaciones que puedan respaldarse con evidencia |

## 9. Metodología

### Investigación

- aplicada y tecnológica;
- ciencia del diseño operacionalizada mediante DSRM;
- estudio de caso único embebido: el caso es el diseño, construcción y evaluación del proceso digital de trazabilidad en R3Foresta, la Fundación es el contexto organizacional y las trazas son las unidades de análisis;
- enfoque mixto descriptivo;
- sin generalización estadística.

### Desarrollo

- ejecución formal prospectiva del 17 de agosto al 15 de noviembre de 2026;
- iterativo e incremental organizado en ocho sprints;
- especificaciones, reglas y decisiones versionadas;
- desarrollo y cierre formal de Recolección, Vivero y Plantación;
- integración M1→M2 y M2→M3;
- reconstrucción del recorrido, integración transversal, calidad, piloto y documentación final;
- construcción demostrada desde una referencia inicial académica del repositorio mediante evidencia versionada por sprint;
- desarrollos previos utilizados solo como referencia técnica y factibilidad, no como evidencia de construcción formal.

Esta reconstrucción académica dentro del semestre corresponde al criterio acordado con la docente de la UMSA y comunicado por el postulante. No se afirmará que nunca existió un prototipo previo; la referencia inicial mostrará qué capacidades todavía no existen y la evidencia de los sprints demostrará su construcción incremental dentro de la ventana autorizada.

### Autoría y asistencia

Pablo Andrés Fernández Cari es el autor académico y responsable principal del trabajo. La colaboración externa fue puntual y se delimitará en el documento final. Los agentes de IA Claude Code y Codex apoyarán la descomposición de tareas, implementación, revisión, pruebas y redacción. Toda salida será revisada y validada por el postulante; las decisiones del dominio y la responsabilidad son humanas.

## 10. Diseño de evaluación

La evaluación conservará este orden de prioridad:

1. **Reconstrucción de la trazabilidad:** comprobar si puede recuperarse el origen, las etapas, los eventos, los cambios, las cantidades, las transformaciones, las pérdidas, los responsables, la ubicación y el destino.
2. **Integridad y coherencia:** verificar las reglas sobre disponibilidad, saldos, doble consumo, doble asignación y relación entre material de origen y resultante.
3. **Operación real:** procurar utilizar el sistema durante una actividad real, especialmente una plantación o reforestación, cuando el calendario de R3Foresta lo permita.
4. **Comparación con la situación actual:** inventariar todas las trazas elegibles de un periodo documental delimitado y, durante el piloto, registrar en paralelo una misma actividad con la práctica habitual y con R3Foresta cuando sea posible.
5. **Carga operativa y experiencia:** observar tiempo, pasos, dificultades y percepción de las personas participantes.

No se fijará una cantidad arbitraria de casos históricos: se documentarán el periodo, los criterios de inclusión, el inventario completo, las trazas elegibles y las exclusiones. La cantidad de participantes dependerá de disponibilidad y autorización. Las rutas no observadas se tratarán como casos controlados claramente identificados.

## 11. Justificación

- **Técnica:** integridad de operaciones y transferencias bajo concurrencia y fallos.
- **Operativa:** disponibilidad, pérdidas, asignaciones y responsables reconstruibles.
- **Comercial:** información más consistente para patrocinadores y aliados.
- **Académica:** vínculo entre análisis, diseño, implementación, verificación y evaluación.
- **Económica:** infraestructura de bajo costo y medición del tiempo antes de afirmar ahorro.
- **Social y ambiental:** mejor rendición de cuentas sin atribuir éxito ecológico al software.

## 12. Cronograma rector

- Sprint 0, 17–23 de agosto: perfil, backlog, referencia inicial académica del repositorio, arquitectura, instrumentos iniciales y caracterización de la práctica actual;
- Sprint 1, 24 de agosto–6 de septiembre: inicio de la construcción formal de Recolección desde la referencia inicial;
- Sprint 2, 7–20 de septiembre: Vivero e integración M1→M2;
- Sprint 3, 21 de septiembre–4 de octubre: Plantación e integración M2→M3;
- Sprint 4, 5–18 de octubre: reconstrucción y trazabilidad transversal;
- Sprint 5, 19 de octubre–1 de noviembre: integración, calidad y despliegue;
- Sprint 6, 2–8 de noviembre: piloto y evaluación;
- Sprint 7, 9–15 de noviembre: documento y entrega final.

## 13. Recursos

- agentes de IA mediante una suscripción alternada entre Claude Code y Codex: USD 80 por 4 meses;
- transporte, alimentación, datos e Internet: Bs 1.060–1.360;
- Supabase, Vercel, Render, GitHub y subdominio: planes gratuitos;
- equipos y horas: aporte en especie;
- financiamiento monetario: 100 % del postulante;
- gastos exploratorios previos a agosto: no imputados al presupuesto formal.

## 14. Reglas de consistencia documental

Antes de cerrar cualquier versión:

1. problema y pregunta deben referirse al origen o ingreso del material vegetal sin convertir una procedencia alternativa en el foco;
2. deben conservarse exactamente tres módulos;
3. las variantes de ingreso deben resolverse dentro de los módulos existentes y no como una línea de trabajo independiente;
4. no deben reaparecer blockchain o créditos de carbono dentro del alcance;
5. la evaluación debe denominar claramente “situación actual” y “propuesta”, sin fijar cifras de casos o participantes antes de contar con sustento metodológico;
6. no se deben prometer mejoras, ahorros o certificaciones antes de medirlos;
7. deben diferenciarse validación de software y validación de campo;
8. debe mantenerse la declaración transparente de autoría y asistencia;
9. presupuesto y cronograma deben coincidir con el perfil oficial;
10. la construcción formal debe partir de una referencia inicial académica del repositorio y conservar evidencia de cada incremento; los desarrollos previos solo pueden describirse como referencia técnica y factibilidad;
11. los ocho sprints deben contener los tres módulos, ambas integraciones, reconstrucción transversal, calidad, piloto y cierre;
12. los agentes de IA deben aparecer como apoyo bajo validación humana;
13. cualquier cambio académico acordado con la docente o la tutora debe propagarse al perfil, estructura y TODO;
14. “semillas y plantas” debe introducir el dominio y “material vegetal” debe utilizarse después como denominación general;
15. transferencia y transformación deben mantenerse diferenciadas en requerimientos, datos, eventos, reglas y pruebas;
16. toda evidencia debe describirse como respaldo del registro, no como certificación de la realidad física;
17. el Perfil debe expresar propiedades deseadas sin comprometer prematuramente mecanismos de implementación;
18. cualquier nueva documentación del Proyecto de Grado debe revisar los principios de las secciones 7 y 8 antes de cerrarse;
19. los ingresos de material vegetal adquirido o recibido de terceros en Vivero y Plantación deben contar con requerimientos, historial, diseño, implementación y pruebas antes de cerrar el objetivo específico 3;
20. la comparación del piloto debe usar registro paralelo de una misma actividad cuando sea viable; si no, debe declararse que las trazas comparadas no son equivalentes;
21. las métricas deben contar con definiciones operativas breves y reproducibles antes de recolectar datos;
22. los roles y permisos del sistema no sustituyen el protocolo de custodia de datos de investigación;
23. las deudas técnicas críticas para identidad, seguridad, migraciones y pruebas deberán cerrarse internamente antes del piloto sin convertirlas en el foco narrativo del Perfil.
24. toda sección posterior al Perfil deberá aplicar la lista de revisión de [criterios_editoriales_proyecto_grado.md](criterios_editoriales_proyecto_grado.md) antes de cerrarse.

---

*Lineamiento actualizado el 19 de agosto de 2026.*
