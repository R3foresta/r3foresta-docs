# Plan inicial — PA-F01

**Fecha de elaboración:** 8 de octubre de 2026. **Objetivo de campo:** jueves 15 de octubre de 2026, sujeto a controles y corrección excepcional preparados y verificados.

El orden general fue aceptado en el cierre LCO. El refinamiento del 10 de octubre incorpora la experiencia del usuario nuevo y explicita trabajo frontend/backend/datos; en ese refinamiento las specs estaban en borrador. El estado vigente del 13 se recoge abajo; ese estado histórico no reabre revisiones cerradas.

**Avance de revisión del 11 de octubre:** PA-S00 queda aprobada en comportamiento, lista para preparar boceto y plan técnico; se confirma consulta pública sin sesión, perfil sin wallet/documento y afiliación opcional, orientación VOLUNTARIO + permiso contextual y GPS exterior/manual. ADMIN global queda confirmado como autoridad central; se mantienen contratos, matriz operativa, migración, pruebas y casos de corrección pendientes. Ver [acta](revision-humana-2026-10-11.md); las tablas históricas de orden no significan que las decisiones confirmadas sigan abiertas.

## Estado vigente y siguiente entrega — 13 de octubre

PA-S00/01/02/03 aprobadas en comportamiento; PA-S01 cerrada integralmente el 12. D01–D12 del [contrato backend](contrato-identidad-permisos-backend-propuesta.md) aceptadas con afiliación opcional del catálogo o «Otra», snapshots históricos y LIFO sobre stock existente de subcampaña, sin otra recepción. Contraste de APIs e inventario estático completados; cotejo del catálogo destino, manifest concreto, implementación y pruebas pendientes. PA-S04 conserva revisión específica de casos/efectos.

Siguiente entrega PA-T-INT02-A: identidad, alta VOLUNTARIO y perfil seguro; después permisos/versiones, registro recuperable y gestión contextual según contrato §13. El [índice](README.md#trabajo-ya-realizado-y-tareas-asociadas) distingue preparación documental de ejecución. Las tablas fechadas de orden siguientes conservan la evolución del plan, sin volver a pedir acuerdos aceptados.

## Orden general aceptado el 8 de octubre

| Prioridad | Resultado | Dependencias | Evidencia esperada |
|---|---|---|---|
| P0 | Boceto de registro y resultado | acuerdos LCO y handoff | revisión humana del recorrido |
| P0 | Contrastar roles, autorización/revocación, GPS, reintentos, concurrencia y consumo | migraciones, reglas y contrato | matriz de hallazgos y decisiones |
| P0 | Especificar y preparar registro inicial | P0 anteriores | spec revisada, tareas y verificación |
| P0 | Diseñar/verificar corrección excepcional | autoridad central, historial, saldos | mecanismo probado antes de campo |
| P1 | Consulta común | modelo de visibilidad pendiente | spec revisada y ejemplo de mapa |
| P1 | Gestión de acceso | adaptación del modelo actual | spec revisada y transición verificable |

## Condiciones de implementación — estado actualizado el 13

- Entrada, consulta pública y alta VOLUNTARIO/perfil seguro aceptadas. Cotejar usuarios internos y preparar el manifest concreto; implementar/verificar API y rutas legadas según el inventario.
- Verificar contrato GPS conforme a la confirmación del 11 de octubre: exterior permitido con evaluación/advertencia y captura manual válida como alternativa; RN-PLA-32 alineada para registro inicial. Distinguir fallo de dispositivo de fallo técnico de evaluación y no inventar coordenadas/resultados.
- Implementar y verificar el orden de autorización/guardado/retiro y comandos recuperables del diseño aceptado; el clic no reserva permiso.
- Modelo contextual separado de roles globales y coordinación/logística aceptado. Cotejar catálogo y revisar correspondencia concreta de personas en el manifest; no convertir masivamente COORDINADOR/GENERAL.
- Verificar consumo LIFO de asignación elegible de la misma subcampaña, una sola vez, sin otra recepción/despacho ni doble débito de Vivero.
- Concretar los contratos propios de PA-S04 por caso y autoridad: ADMIN global o administrador de esa subcampaña para casos admitidos, observaciones central. Cierre integral/efectos pendientes; no editor general ni cascada de hechos reales.

## Refinamiento del 10 de octubre: siguiente entrega

| Paso | Qué abordar y por qué | Resolver antes del código afectado | Evidencia para revisar avance |
|---|---|---|---|
| 1 | Revisar PA-S00 y visibilidad PA-S02: definir la experiencia de alguien involucrado en una sola campaña. | PA-DI08/09/10 y campos PA-DI05. | Historias/casos aceptados, boceto de entrada y matriz de audiencias. |
| 2 | Preparar identidad/permisos y transición: son la base de cualquier registro autorizado. | PA-DI01/02/03; capacidades, usuarios internos y contratos. | API/DB permiten el ámbito correcto y rechazan ajenos, perfil manipulado y rutas alternativas. |
| 3 | Completar una unidad vertical de registro: entrada → contexto → captura → guardado → comprobante. | PA-DI04/06, PA-S01, backend de acceso. | Un registro/consumo, recuperación de respuesta perdida, stock correcto y recorrido sin guía paso a paso. |
| 4 | Integrar consulta y gestión contextual con los contratos ya acordados. | PA-S02/03 y búsqueda mínima de personas. | Consulta sin exceso de información; alta/retiro solo en el ámbito permitido; último administrador protegido. |
| 5 | Preparar la salida excepcional y la prueba de campo. Diseñar corrección desde los pasos 1–2, no esperar al final para decidirla. | PA-DI07, PA-S04, todos los controles críticos. | Error representativo resuelto con historial y efectos correctos; QA integrado y decisión humana de habilitar campo. |

Frontend puede bocetar y preparar componentes con contratos simulados mientras backend/DB implementan su parte una vez autorizada. Se verifica la unidad completa al integrar. Las etiquetas P1 del plan original no eliminan las dependencias de autorización/consulta del piloto.

Responsabilidades: el usuario revisa decisiones de producto y acepta cada spec; el diseño técnico propone contratos/migraciones y evidencia; la implementación se ejecuta por tareas revisadas en los repositorios de aplicación. Registrar ejecutor y revisor al iniciar cada entrega; no se presupone aprobación técnica ni disponibilidad de personas.

Guía de lectura: [índice](README.md). Trabajo por capas y tablas candidatas: [diseño compartido](diseno-tecnico-compartido.md). Inventario de código y tareas PA-T-INT01–08: [plan de reutilización](plan-reutilizacion-integracion.md). Nuevas tareas de entrada: [PA-T-ENT01–06](00-experiencia-participante/tasks.md).

## Fuera de esta iteración

Mortandad/reposición completa, merma de campo, edición posterior general, solicitudes/invitaciones de acceso, financiación y una plataforma de organizaciones. Se permite diseñar contratos y migraciones como propuestas; no se presentan APIs/tablas nuevas como ya existentes ni se ejecuta SQL para aprobar este plan.

El 15 de octubre es objetivo de campo condicionado. Si una garantía crítica no está preparada y verificada, se revisa fecha o alcance explícitamente, sin declarar listo el piloto por tener specs o pantallas.
