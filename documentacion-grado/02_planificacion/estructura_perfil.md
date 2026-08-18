# Estructura vigente del Perfil de Proyecto de Grado

> **Versión 6 — 18 de agosto de 2026.**
> Este documento explica la arquitectura del perfil; el texto entregable y fuente de verdad académica es [PERFIL_PROYECTO_GRADO.md](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md).

## 1. Decisión central

El perfil presenta un proyecto de Ingeniería de Sistemas sobre trazabilidad de material biológico para reforestación en el caso R3Foresta. El problema se formula en lenguaje organizacional y académico; los mecanismos de eventos, transacciones e invariantes se desarrollan como aporte de ingeniería, pero no condicionan el título.

**Título propuesto:**

> Sistema de trazabilidad de material biológico para reforestación: caso R3Foresta

El título, el problema y los objetivos están pendientes de aprobación de la tutora. No están pendientes de redacción.

## 2. Alcance funcional consolidado

Se mantienen tres módulos:

1. Recolección;
2. Vivero;
3. Plantación.

La adquisición externa es un flujo de ingreso y no un cuarto módulo. El perfil contempla:

- proveedor → recepción externa → vivero para adaptación → asignación → plantación;
- proveedor → recepción externa → plantación directa.

Los datos mínimos preliminares son proveedor u origen declarado, especie, cantidad, fecha y fotografía. El comprobante de compra es opcional. Los estados, validaciones y puntos exactos de integración se definirán durante el análisis del objetivo específico 1.

## 3. Cadena de alineación académica

### Problema central

La información sobre material propio o externo se conserva en registros dispersos sin una estructura común, lo que limita la reconstrucción de procedencia, cantidades, responsables, transferencias y plantación con evidencia contrastable.

### Pregunta general

¿Cómo desarrollar y evaluar un sistema de trazabilidad para reconstruir esa cadena y qué diferencias presenta frente a la práctica actual en capacidad de reconstrucción y carga operativa?

### Objetivo general

Desarrollar y evaluar un sistema de trazabilidad para la cadena de custodia del material biológico utilizado por R3Foresta, desde su recolección o recepción externa hasta su manejo en vivero y plantación, que permita reconstruir con evidencia contrastable su procedencia, movimientos, cantidades, responsables y destino.

### Objetivos específicos y resultados

| Obj. | Verbo | Resultado esperado | Sección del documento final |
|---|---|---|---|
| 1 | Analizar | Procesos, datos, reglas y recepción externa definidos | 4.1 |
| 2 | Diseñar | Modelo, invariantes y contratos de integración | 4.2 |
| 3 | Implementar | Tres módulos y flujo externo integrados | 4.3 |
| 4 | Verificar | Matriz de pruebas y resultados técnicos | 4.4 |
| 5 | Evaluar | Línea base, piloto, contraste y carga operativa | 4.5 |

## 4. Diseño de evaluación

La evaluación separa dos planos:

### Plano técnico

- pruebas unitarias de reglas y saldos;
- pruebas de integración de transferencias;
- pruebas de concurrencia;
- pruebas de fallo inducido;
- pruebas extremo a extremo;
- matriz requerimiento–regla–invariante–prueba.

### Plano operativo

**AS-IS:** reconstrucción retrospectiva de 8 a 12 actividades o recorridos históricos identificables. Estos casos son unidades de análisis del proceso anterior y no eventos creados por el software.

**TO-BE:** piloto real coordinado con R3Foresta y hasta cinco usuarios. El mismo instrumento medirá completitud, evidencia, tiempo de reconstrucción y carga de registro.

El lugar y los participantes concretos se seleccionarán según disponibilidad de una actividad real, accesibilidad logística, consentimiento y posibilidad de observar el proceso. Si una de las rutas —propia o externa— no ocurre en la ventana, se evaluará mediante un caso controlado y se declarará como tal.

La independencia de quien reconstruye la traza es deseable. Puede intervenir una persona externa o un evaluador vinculado a una institución académica si su participación se formaliza; no se promete una afiliación específica.

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

## 7. Metodología

- investigación aplicada y tecnológica;
- ciencia del diseño como enfoque de construcción y evaluación;
- estudio de caso único en R3Foresta;
- datos cuantitativos y cualitativos con análisis descriptivo;
- desarrollo iterativo e incremental;
- organización del trabajo en ocho sprints entre agosto y noviembre;
- especificaciones y decisiones versionadas;
- agentes de IA aprobados como apoyo bajo revisión humana;
- declaración transparente de prototipos previos, autoría y colaboración puntual.

La ejecución académica formal se planifica del 17 de agosto al 15 de noviembre de 2026. Los artefactos y prototipos anteriores son insumos de factibilidad; no se contarán como objetivos cumplidos. Recolección, Vivero, Plantación, las dos integraciones, recepción externa, calidad, piloto y documentación deberán atravesar sus sprints y criterios de cierre dentro de la ventana formal.

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

- Sprint 0, 17–23 de agosto: inicio, perfil, backlog, arquitectura y levantamiento AS-IS;
- Sprint 1, 24 de agosto–6 de septiembre: Recolección;
- Sprint 2, 7–20 de septiembre: Vivero e integración M1→M2;
- Sprint 3, 21 de septiembre–4 de octubre: Plantación e integración M2→M3;
- Sprint 4, 5–18 de octubre: recepción externa y genealogía;
- Sprint 5, 19 de octubre–1 de noviembre: integración, pruebas y despliegue;
- Sprint 6, 2–8 de noviembre: piloto y evaluación;
- Sprint 7, 9–15 de noviembre: cierre académico.

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

*Documento de planificación actualizado el 18 de agosto de 2026.*
