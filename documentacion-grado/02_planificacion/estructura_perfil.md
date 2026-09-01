# Estructura vigente del Perfil de Proyecto de Grado

> **Versión 13 — 31 de agosto de 2026.**
> Este documento explica la arquitectura del perfil; el texto entregable y fuente de verdad académica es [PERFIL_PROYECTO_GRADO.md](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md).
> Los principios que deben conservarse en la documentación posterior se encuentran en [base_perfil_proyecto_grado.md](../01_lineamientos/base_perfil_proyecto_grado.md) §§7–8.

## 1. Decisión central

El perfil presenta un proyecto de Ingeniería de Sistemas sobre trazabilidad de material vegetal para reforestación en el caso R3Foresta. La introducción explica primero el recorrido mediante la expresión “semillas y plantas”; las secciones posteriores emplean “material vegetal” como denominación general. El problema se formula en lenguaje organizacional y académico. El perfil compromete capacidad de reconstrucción, integridad y evidencia vinculada, mientras que los mecanismos concretos para conseguir estas propiedades se definirán posteriormente en el diseño y la implementación.

**Título seleccionado:**

> Sistema de trazabilidad del material vegetal para reforestación con proyección hacia bonos de carbono: caso R3Foresta

El título fue seleccionado por el postulante el 25 de agosto de 2026 y permanece pendiente de ratificación por la tutora. El problema y los objetivos también están pendientes de aprobación, no de redacción. La proyección hacia bonos de carbono expresa únicamente un posible uso institucional posterior de la información trazable y no amplía el alcance funcional ni la evaluación del sistema.

## 2. Alcance funcional consolidado

Se mantienen tres módulos:

1. Recolección;
2. Vivero;
3. Plantación.

El recorrido principal se inicia con el origen registrado: una recolección de semillas o la incorporación, en Vivero o Plantación, de material adquirido externamente; concluye con el registro de la plantación. Esta variante conserva la procedencia disponible dentro de los tres módulos existentes.

## 3. Cadena de alineación académica

### Problema central

Actualmente, R3Foresta no dispone de un historial integrado que le permita reconstruir, a partir de sus registros, el recorrido del material vegetal desde su origen registrado hasta el registro de su plantación.

### Pregunta general

¿Cómo puede R3Foresta organizar y relacionar la información generada durante sus actividades de reforestación para reconstruir, a partir de sus registros, el recorrido del material vegetal desde su origen registrado hasta el registro de su plantación?

### Objetivo general

Desarrollar un sistema web que permita a R3Foresta registrar, organizar y relacionar la información generada en las actividades de Recolección, Vivero y Plantación, para reconstruir, a partir de sus registros, el recorrido del material vegetal desde su origen registrado hasta el registro de su plantación.

### Objetivos específicos y resultados

| Obj. | Verbo | Resultado esperado | Sección del documento final |
|---|---|---|---|
| 1 | Analizar | Información actual y forma de gestión caracterizadas | 3.1 |
| 2 | Diseñar | Información y relaciones del recorrido definidas | 3.2 |
| 3 | Implementar | Funciones de los tres módulos integradas | 3.3 |
| 4 | Verificar | Matriz de pruebas y coherencia de registros comprobada | 3.4 |
| 5 | Evaluar | Escenarios operativos, reconstrucción y aceptación | 3.5–3.6 |

## 4. Verificación, validación y aceptación

La comprobación del producto separa dos planos y prioriza las propiedades que el proyecto debe demostrar:

### Plano técnico

- pruebas funcionales y técnicas de las reglas críticas de trazabilidad e integridad;
- casos que permitan reconstruir el recorrido y explicar cantidades y saldos;
- matriz requerimiento–regla–invariante–prueba.

### Plano operativo

1. reconstrucción del origen y recorrido del material vegetal;
2. integridad de cantidades, saldos y asignaciones;
3. ejecución de escenarios representativos sobre los tres módulos y sus integraciones;
4. aceptación del incremento y del sistema integrado frente a criterios previamente especificados.

Se priorizará una operación real cuando esté disponible y autorizada. Si una ruta no ocurre dentro de la ventana, se empleará un escenario controlado claramente identificado. Estos ejercicios validan el producto en su contexto de uso, pero no constituyen un estudio de caso, un experimento ni una demostración causal de mejora respecto de la práctica anterior.

## 5. Controles para la ejecución posterior

Estas medidas corresponden al desarrollo, la validación y el documento final; no constituyen una sección independiente del Perfil:

- consentimiento informado para entrevistas y observación;
- acuerdo operativo de R3Foresta antes de utilizar datos o realizar una validación con personas, sin exigir en el perfil una carta como anexo;
- uso de nombres o ubicaciones solo cuando sean pertinentes y exista consentimiento;
- omisión de datos personales no necesarios;
- separación entre datos operativos y casos controlados.

## 6. Alcance negativo

El perfil excluye:

- créditos de carbono y cualquier certificación asociada;
- biomasa, CO₂, adicionalidad y permanencia;
- monitoreo ecológico de largo plazo;
- certificación independiente de plantaciones;
- blockchain, NFT, contratos inteligentes e IPFS;
- autenticidad forense de evidencia;
- despliegue nacional;
- un módulo independiente de compras.

La meta organizacional futura de carbono se menciona únicamente como contexto.

Los componentes históricos relacionados con blockchain, NFT o IPFS pueden permanecer en repositorios técnicos, pero no forman parte de la construcción, evaluación ni contribución académica.

## 7. Metodología de desarrollo

- RUP adaptado como proceso rector del proyecto completo;
- fases de Inicio, Elaboración, Construcción y Transición, con hitos LCO, LCA, IOC y PR;
- enfoque iterativo e incremental, dirigido por requisitos y casos de uso, centrado en la arquitectura y orientado por riesgos;
- una iteración de Inicio, una de Elaboración, cuatro de Construcción y una de Transición; cada iteración recorre las disciplinas pertinentes y termina en una revisión;
- cuatro incrementos durante Construcción: M1, M2 con integración M1→M2, M3 con integración M2→M3 y trazabilidad transversal con integración total;
- Spec-Driven Development como práctica para convertir necesidades en especificaciones, planes, tareas, cambios y pruebas trazables;
- asistencia de IA durante especificación, diseño, implementación, pruebas y documentación, siempre bajo revisión y responsabilidad humana;
- evidencia versionada por iteración e incremento desde una referencia identificable del repositorio;
- verificación técnica, validación operativa y aceptación incorporadas al proceso de ingeniería.

La ejecución formal se planifica del 6 de julio al 15 de noviembre de 2026. El proyecto no se organiza por sprints ni declara ciencia del diseño, DSRM o estudio de caso como metodología. Una iteración es el ciclo de trabajo y un incremento es su resultado ejecutable. Los cuatro incrementos pertenecen a las cuatro iteraciones de Construcción; no son cuatro repeticiones completas de las fases RUP.

## 8. Estructura y extensión

| Sección | Extensión orientativa |
|---|---:|
| Portada e índice general | 1–2 páginas |
| 1. Introducción | 1 |
| 2. Antecedentes | 1,5–2 |
| 3. Planteamiento del problema | 2–3 |
| 4. Objetivos | 1 |
| 5. Justificación | 1,5–2 |
| 6. Alcances y límites | 2 |
| 7. Marco teórico preliminar | 3–4 |
| 8. Metodología de desarrollo | 3 |
| 9. Índice propuesto del Proyecto de Grado | 1 |
| 10. Cronograma de actividades | 1–2 |
| 11. Referencias bibliográficas | 2–3 |
| 12. Anexos | Según necesidad |

El Perfil no contiene Resumen, palabras clave, Propuesta de solución ni Recursos como secciones independientes. El cuerpo esperado se mantiene aproximadamente entre 20 y 24 páginas una vez maquetado.

## 9. Cronograma consolidado

- Inicio, iteración IN-1, 6–19 de julio: visión, alcance, requisitos iniciales, riesgos y LCO;
- Elaboración, iteración EL-1, 20 de julio–16 de agosto: especificaciones priorizadas, arquitectura base, línea vertical arquitectónica mínima, contratos de integración y LCA;
- Construcción, iteración CO-1 e incremento 1, 17 de agosto–6 de septiembre: M1 Recolección;
- Construcción, iteración CO-2 e incremento 2, 7–27 de septiembre: M2 Vivero e integración M1→M2;
- Construcción, iteración CO-3 e incremento 3, 28 de septiembre–18 de octubre: M3 Plantación e integración M2→M3;
- Construcción, iteración CO-4 e incremento 4, 19 de octubre–1 de noviembre: trazabilidad transversal, integración total, regresión, versión candidata e IOC;
- Transición, iteración TR-1, 2–15 de noviembre: validación, correcciones, despliegue, manuales, aceptación, PR y cierre académico.

El periodo posterior puede reservarse para observaciones de la tutora, maquetación y preparación de la defensa, sin presentarlo como ampliación de la construcción si no fue parte de la ventana aprobada.

## 10. Recursos de ejecución — fuera de la estructura del Perfil

Estos recursos se conservan para la planificación posterior y no forman una sección del Perfil:

- infraestructura: Supabase, Vercel, Render y GitHub;
- dominio: subdominio gratuito de Vercel;
- computadora portátil y teléfonos móviles propios;
- herramientas de programación, prueba, documentación y diagramación;
- agentes de IA mediante una suscripción alternada entre Claude Code y Codex;
- conexión a Internet, datos móviles, transporte y alimentación para las actividades de campo;
- acceso al contexto operativo y participación de R3Foresta.

## 11. Entregable actual y trabajo posterior

La fuente canónica y única versión editable del Perfil dentro del repositorio es `PERFIL_PROYECTO_GRADO.md`. Las versiones aprobadas se transferirán directamente al Google Docs existente en Drive, que será el documento de trabajo y presentación. El archivo DOCX local queda fuera del flujo y no deberá utilizarse para introducir cambios ni como intermediario. El Perfil tampoco requiere insertar un salto de página después de cada encabezado de nivel 1. En el documento final oficial del Proyecto de Grado sí se aplicará el inicio de cada capítulo principal en una página nueva durante la maquetación de entrega.

---

*Documento de planificación actualizado el 31 de agosto de 2026.*
