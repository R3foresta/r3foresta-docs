# Plan inicial — PA-F01

**Fecha de elaboración:** 8 de octubre de 2026. **Objetivo de campo:** jueves 15 de octubre de 2026, sujeto a controles y corrección excepcional preparados y verificados.

El orden general fue aceptado en el cierre LCO. El refinamiento del 10 de octubre incorpora la experiencia del usuario nuevo y explicita trabajo frontend/backend/datos; sus specs siguen en borrador.

## Orden general aceptado el 8 de octubre

| Prioridad | Resultado | Dependencias | Evidencia esperada |
|---|---|---|---|
| P0 | Boceto de registro y resultado | acuerdos LCO y handoff | revisión humana del recorrido |
| P0 | Contrastar roles, autorización/revocación, GPS, reintentos, concurrencia y consumo | migraciones, reglas y contrato | matriz de hallazgos y decisiones |
| P0 | Especificar y preparar registro inicial | P0 anteriores | spec revisada, tareas y verificación |
| P0 | Diseñar/verificar corrección excepcional | autoridad central, historial, saldos | mecanismo probado antes de campo |
| P1 | Consulta común | modelo de visibilidad pendiente | spec revisada y ejemplo de mapa |
| P1 | Gestión de acceso | adaptación del modelo actual | spec revisada y transición verificable |

## Bloqueos antes de implementar cada recorrido

- Acordar entrada, alcance de consulta y alta de mínimo privilegio para nuevas cuentas (PA-S00). Inventariar usuarios internos y cerrar rutas/API que permitan eludir la restricción; no basta reducir el menú.
- Resolver la discrepancia GPS: handoff/migración describen advertencia fuera de polígono y bloqueo no evaluable, mientras RN-PLA-32 mantiene bloqueo conceptual fuera de tolerancia.
- Diseñar autorización/guardado frente a revocación y reintentos concurrentes, sin asumir que pulsar enviar reserva permiso.
- Confirmar correspondencia entre permisos contextuales nuevos y catálogo global/equipo vigente; no equiparar ADMINISTRADOR contextual con ADMIN global o COORDINADOR.
- Confirmar que el consumo usa asignación física elegible una sola vez, sin nuevo despacho ni doble débito de Vivero.
- Precisar la corrección central vinculada al original: campos, casos, límites, actor, historial y efectos sobre saldos/estados.

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
