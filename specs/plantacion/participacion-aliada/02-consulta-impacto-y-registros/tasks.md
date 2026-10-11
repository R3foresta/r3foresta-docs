# Tareas — PA-S02

**Estado:** backlog propuesto, pendiente de revisión humana. Ninguna tarea de implementación se declara ejecutada. Se conservan PA-T07..11; los sufijos identifican trabajo por capa sin renumerar las tareas base.

## Preparación y revisión

- [ ] **PA-T10 — Inventario de campos.** Contrastar respuestas de impacto, registro, contexto operativo, plan y evidencias con datos persistidos; marcar fuente, audiencia actual, propuesta y campos ausentes. Incluir URLs/metadatos y rutas públicas existentes. Entrega: matriz de PA-S02 §4 con ejemplos sintéticos; sin prometer composición viva por especie ni reconstruir participantes desconocidos.
- [ ] **PA-T11 — Casos de consulta.** Revisar PA-S02-CA01..11 con responsable, corresponsable y persona que solo consulta, incluida cuenta nueva y permiso retirado. Entrega: expectativas aprobadas y pendientes identificados, no un reporte ficticio de pruebas pasadas.
- [ ] **PA-T07-REV — Cierre de visibilidad.** Resolver PA-DI05 y PA-DI08 con el usuario; conciliar RN-PLA-34 y lectura GET /plan de ADR-PLA-05. Entrega: qué contenido puede ver cada audiencia, qué no y qué permanece fuera del primer corte. Depende de PA-T10.
- [ ] **PA-T08-UX — Recorrido limitado y comprensible.** Revisar mapa, resumen, detalle, filtros y entrada independiente a registro con PA-S00. Entrega: boceto con cargas, vacío, error y datos personales ficticios, sin herramientas de M1/M2 para el nuevo participante.

## Implementación posterior a la aprobación del contrato

| ID | Capa y entrega | Dependencias | Verificación de salida |
|---|---|---|---|
| PA-T07-BE | Proyecciones de lectura común, propia y operativa; identidad/autorización, DTO y política de caché. Revisar accesos equivalentes legados. | PA-T07-REV; diseño compartido de identidad. | CA01/05/06/11: el servidor no entrega campos ajenos; revocado conserva su recibo; GET /plan conserva el contrato acordado. |
| PA-T07-DB | Consultas y privilegios para cada lectura, reutilizando registros/snapshots. Evaluar necesidad real de índices o migración nueva. | Contratos de PA-T07-BE; revisión del esquema vigente. | Lecturas no permiten elegir arbitrariamente otro actor ni amplían acceso SQL; no duplican hechos, persistencia de campaña o permisos. |
| PA-T08-FE | Integrar mapa de plantaciones, resumen, detalle y filtros en la experiencia participante; mantener navegación interna autorizada. | PA-T08-UX; PA-T07-BE; PA-S00. | CA02/04/10: recorrido comprensible, retorno conserva contexto, filtros no ocultan registro autorizado; error distinto de cero. |
| PA-T08-BE | Contrato de detalle persistido y, si se aprueba, consulta de contribuciones históricas; integrar recuperación del resultado de PA-S01. | PA-DI05 y contrato de intento de PA-S01. | CA05/07: deduplicación por registro, resultado propio tras revocación y sin exposición de equipo/stock. |
| PA-T09-DB | Agregados por registro/grupo y fórmulas de indicadores antes de uniones con personas u organizaciones. | PA-T10; etiquetas aprobadas en PA-T07-REV. | CA03/08/09: 30 sigue siendo 30, metas pueden superar 100%, reposición no aumenta avance inicial. |
| PA-T09-FE | Presentar unidades, alcance del filtro y etiquetas de cantidades/meta; evitar superficie plantada y composición viva por especie no sustentadas. | PA-T09-DB; PA-T08-UX. | El usuario distingue hecho inicial, objetivo orientativo y saldo cuando corresponda, sin interpretación falsa del mapa. |
| PA-T11-QA | Pruebas de contratos, queries y recorrido integrado por audiencia, incluidas URLs directas y cachés. | Tareas anteriores implementadas en entorno de prueba autorizado. | Evidencia vinculada a cada CA, versiones de frontend/backend y datos de prueba; fallos pendientes visibles. |

Las tareas técnicas corresponden a los repositorios de aplicación cuando se autorice implementar. Este backlog no crea tablas ni aplica migraciones. Coordinar con PA-T-INT03/05/08 del [plan de integración](../plan-reutilizacion-integracion.md) y el [diseño técnico compartido](../diseno-tecnico-compartido.md), sin duplicar entregas.
