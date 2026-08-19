# Estructura vigente del Perfil de Proyecto de Grado

> **Versión 9 — 19 de agosto de 2026.**
> Este documento explica la arquitectura del perfil; el texto entregable y fuente de verdad académica es [PERFIL_PROYECTO_GRADO.md](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md).
> Los principios que deben conservarse en la documentación posterior se encuentran en [base_perfil_proyecto_grado.md](../01_lineamientos/base_perfil_proyecto_grado.md) §§7–8.

## 1. Decisión central

El perfil presenta un proyecto de Ingeniería de Sistemas sobre trazabilidad de material vegetal para reforestación en el caso R3Foresta. La introducción explica primero el recorrido mediante la expresión “semillas y plantas”; las secciones posteriores emplean “material vegetal” como denominación general. El problema se formula en lenguaje organizacional y académico. El perfil compromete capacidad de reconstrucción, integridad y evidencia vinculada, mientras que los mecanismos concretos para conseguir estas propiedades se definirán posteriormente en el diseño y la implementación.

**Título propuesto:**

> Sistema de trazabilidad de material vegetal para reforestación: caso R3Foresta

El título, el problema y los objetivos están pendientes de aprobación de la tutora. No están pendientes de redacción.

## 2. Alcance funcional consolidado

Se mantienen tres módulos:

1. Recolección;
2. Vivero;
3. Plantación.

El recorrido principal se organiza alrededor de estos tres módulos. Si el material vegetal ingresa en una etapa intermedia, su procedencia debe conservarse dentro del módulo correspondiente. Esta posibilidad es una variante implícita del proceso y no un cuarto módulo, un flujo principal ni un resultado independiente.

## 3. Cadena de alineación académica

### Problema central

La información sobre el recorrido del material vegetal se conserva en registros dispersos sin una estructura común, lo que limita la reconstrucción de procedencia, cantidades, responsables, transferencias y plantación con evidencia contrastable.

### Pregunta general

¿Cómo desarrollar y evaluar un sistema de trazabilidad para reconstruir esa cadena y qué diferencias presenta frente a la práctica actual en capacidad de reconstrucción y carga operativa?

### Objetivo general

Se reproduce sin cambios porque los objetivos quedan fuera de la presente revisión terminológica y de alcance narrativo.

Desarrollar y evaluar un sistema de trazabilidad para la cadena de custodia del material biológico utilizado por R3Foresta, desde su recolección o recepción externa hasta su manejo en vivero y plantación, que permita reconstruir con evidencia contrastable su procedencia, movimientos, cantidades, responsables y destino.

### Objetivos específicos y resultados

| Obj. | Verbo | Resultado esperado | Sección del documento final |
|---|---|---|---|
| 1 | Analizar | Procesos, datos y reglas definidos | 4.1 |
| 2 | Diseñar | Modelo, invariantes y contratos de integración | 4.2 |
| 3 | Implementar | Tres módulos integrados | 4.3 |
| 4 | Verificar | Matriz de pruebas y resultados técnicos | 4.4 |
| 5 | Evaluar | Caracterización de la situación actual, piloto, reconstrucción, contraste y carga operativa | 4.5 |

## 4. Diseño de evaluación

La evaluación separa dos planos y prioriza las propiedades que el proyecto debe demostrar:

### Plano técnico

- pruebas funcionales y técnicas de las reglas críticas de trazabilidad e integridad;
- casos que permitan reconstruir el recorrido y explicar cantidades y saldos;
- matriz requerimiento–regla–invariante–prueba.

### Plano operativo

1. reconstrucción del origen y recorrido del material vegetal;
2. integridad de cantidades, saldos y asignaciones;
3. uso durante una operación real cuando el calendario lo permita;
4. comparación con la situación actual mediante el censo de trazas elegibles del periodo documental y las trazas paralelas o comparables del piloto;
5. carga operativa y experiencia de los participantes disponibles.

La cantidad de casos no se fija arbitrariamente en el Perfil. Antes de la recolección se delimitará un periodo documental, se inventariarán las actividades y se incluirán todas las trazas que cumplan los criterios del protocolo. La cantidad de participantes dependerá de disponibilidad, calidad de la información y autorizaciones de R3Foresta.

Durante el piloto se procurará registrar una misma actividad en paralelo mediante la práctica habitual y mediante R3Foresta. Si no fuera viable, la comparación se declarará descriptiva y entre trazas no equivalentes.

El lugar y los participantes concretos se seleccionarán según disponibilidad de una actividad real, accesibilidad logística, consentimiento y posibilidad de observar el proceso. Si una etapa del recorrido principal no ocurre en la ventana, se evaluará mediante un caso controlado y se declarará como tal.

Cuando resulte viable, una persona distinta de quien capturó los datos realizará la reconstrucción para reducir el efecto de la memoria del registrador.

## 5. Consideraciones éticas

- consentimiento informado para entrevistas y observación;
- acuerdo operativo de R3Foresta antes del piloto, sin exigir en el perfil una carta como anexo;
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

## 7. Metodología

- investigación aplicada y tecnológica;
- ciencia del diseño operacionalizada mediante DSRM;
- estudio de caso único embebido en R3Foresta, con trazas como unidades de análisis;
- datos cuantitativos y cualitativos con análisis descriptivo;
- desarrollo iterativo e incremental;
- organización del trabajo en ocho sprints entre agosto y noviembre;
- especificaciones y decisiones versionadas;
- agentes de IA aprobados como apoyo bajo revisión humana;
- construcción demostrable desde una línea base académica limpia;
- declaración transparente de desarrollos previos como referencia técnica, autoría y colaboración puntual.

La ejecución académica formal se planifica del 17 de agosto al 15 de noviembre de 2026. Conforme al criterio acordado con la docente de la UMSA, la solución que se defenderá se reconstruirá desde una línea base académica limpia y cada sprint conservará evidencia versionada de sus incrementos. Los desarrollos anteriores serán referencia técnica y factibilidad, no evidencia de construcción formal. Recolección, Vivero, Plantación, las dos integraciones, la reconstrucción transversal, la calidad, el piloto y la documentación deberán atravesar sus sprints y criterios de cierre dentro de la ventana formal.

## 8. Estructura y extensión

| Sección | Extensión orientativa |
|---|---:|
| Portada, resumen e índices | 2–3 páginas |
| 1. Introducción | 1 |
| 2. Antecedentes | 1,5–2 |
| 3. Planteamiento del problema | 2–3 |
| 4. Objetivos | 1 |
| 5. Justificación | 1,5–2 |
| 6. Alcances y límites | 2 |
| 7. Marco teórico preliminar | 2–3 |
| 8. Marco metodológico | 3 |
| 9. Propuesta y aporte | 2–3 |
| 10. Temario | 1 |
| 11. Cronograma | 1 |
| 12. Recursos y presupuesto | 1 |
| 13. Bibliografía | 1–2 |

El cuerpo esperado se mantiene aproximadamente entre 20 y 24 páginas una vez maquetado.

## 9. Cronograma consolidado

- Sprint 0, 17–23 de agosto: inicio, perfil, backlog, línea base académica, arquitectura, instrumentos iniciales y caracterización de la situación actual;
- Sprint 1, 24 de agosto–6 de septiembre: inicio de la construcción formal con Recolección;
- Sprint 2, 7–20 de septiembre: Vivero e integración M1→M2;
- Sprint 3, 21 de septiembre–4 de octubre: Plantación e integración M2→M3;
- Sprint 4, 5–18 de octubre: reconstrucción y trazabilidad transversal;
- Sprint 5, 19 de octubre–1 de noviembre: integración, pruebas y despliegue;
- Sprint 6, 2–8 de noviembre: piloto y evaluación;
- Sprint 7, 9–15 de noviembre: cierre académico.

El periodo posterior hasta fines de noviembre o inicios de diciembre se reserva para correcciones, maquetación y preparación de la defensa. Si se amplía la ejecución sustantiva, el cambio deberá reflejarse en el cronograma oficial.

## 10. Recursos consolidados

- infraestructura: planes gratuitos de Supabase, Vercel, Render y GitHub;
- dominio: subdominio gratuito de Vercel;
- equipos y horas: aporte en especie no monetizado;
- agentes de IA: una suscripción alternada entre Claude Code y Codex de USD 20 mensuales, 4 meses, total USD 80;
- campo y conectividad: Bs 1.060–1.360;
- financiamiento monetario: 100 % del postulante;
- aporte de R3Foresta: acceso y participación, sin efectivo comprometido;
- gastos exploratorios anteriores a agosto: costos hundidos, no imputados al periodo formal.

## 11. Entregable actual y trabajo posterior

La versión actual entrega únicamente el perfil en Markdown. No incluye DOCX, PDF, presentación, guion, anexos de instrumentos ni resultados del piloto. Esos artefactos se elaborarán después y solo cuando correspondan a la etapa académica solicitada.

---

*Documento de planificación actualizado el 19 de agosto de 2026.*
