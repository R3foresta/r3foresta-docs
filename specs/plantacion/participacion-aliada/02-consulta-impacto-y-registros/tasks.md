# Tareas — PA-S02

**Estado:** backlog propuesto, pendiente de revisión humana. Ninguna tarea de implementación se declara ejecutada. Se conservan PA-T07..11; los sufijos identifican trabajo por capa sin renumerar las tareas base.

## Preparación y revisión

- [ ] **PA-T10 — Inventario de campos.** Contrastar respuestas de impacto, registro, contexto operativo, plan y evidencias con datos persistidos; marcar fuente, audiencia actual, propuesta y campos ausentes. Incluir URLs/metadatos y rutas públicas existentes. Entrega: matriz de PA-S02 §4 con ejemplos sintéticos; sin prometer composición viva por especie ni reconstruir participantes desconocidos.
- [ ] **PA-T11 — Casos de consulta.** Revisar PA-S02-CA01..22 con responsable, corresponsable y persona que solo consulta, incluida cuenta nueva y permiso retirado. Entrega: confirmaciones de producto y pendientes técnicos identificados, no un reporte ficticio de pruebas pasadas.
- [ ] **PA-T07-REV — Cierre de contratos de visibilidad.** Consulta, campos principales, distribución de resumen/detalle, faltantes por subcampaña, «Mis registros» por autoría/participación, afiliación histórica y entrada última campaña/global confirmados el 11 de octubre. Concretar payloads, fuentes/fórmulas de seguimiento, captura histórica, datos legados y campos adicionales; conciliar RN-PLA-34 y GET /plan de ADR-PLA-05. Entrega: ejemplos públicos sin sesión y privados, sin datos extra. Depende de PA-T10; mecanismos y revisión técnica pendientes.
- [ ] **PA-T08-UX — Recorrido limitado y comprensible.** Revisar mapa, resumen, detalle, filtros y entrada independiente a registro con PA-S00. Entrega: boceto con cargas, vacío, error y datos personales ficticios, sin herramientas de M1/M2 para el nuevo participante.

## Implementación posterior a la aprobación del contrato

Las confirmaciones incorporan CA16/17 a PA-T10/11 y PA-T07-BE/DB, PA-T08-UX/FE y PA-T11-QA: distinguir organizaciones de campaña de afiliaciones personales mixtas, excluir stock/contactos/perfiles completos del contenido público y comprobar la exclusión de metadatos en los archivos fotográficos entregados y sus URLs. La revisión en llamada amplía el conjunto a CA01..22 y confirma ampliar el detalle; el control visual exacto «Ver más» se boceta, sin ampliar la audiencia.

| ID | Capa y entrega | Dependencias | Verificación de salida |
|---|---|---|---|
| PA-T07-BE | Proyecciones de lectura común, propia y operativa; identidad/autorización, DTO y política de caché. Revisar accesos equivalentes legados. | PA-T07-REV; diseño compartido de identidad. | CA01/05/06/11: el servidor no entrega campos ajenos; revocado conserva su recibo; GET /plan conserva el contrato acordado. |
| PA-T07-DB | Consultas y privilegios para cada lectura, reutilizando registros/snapshots. Evaluar necesidad real de índices o migración nueva. | Contratos de PA-T07-BE; revisión del esquema vigente. | Lecturas no permiten elegir arbitrariamente otro actor ni amplían acceso SQL; no duplican hechos, persistencia de campaña o permisos. |
| PA-T08-FE | Integrar mapa de plantaciones, resumen, detalle y filtros en la experiencia participante; mantener navegación interna autorizada. | PA-T08-UX; PA-T07-BE; PA-S00. | CA02/04/10: recorrido comprensible, retorno conserva contexto, filtros no ocultan registro autorizado; error distinto de cero. |
| PA-T08-BE | Contrato de detalle persistido y «Mis registros» por responsable/participante histórico; integrar recuperación del resultado de PA-S01. | Contrato PA-DI05 y contrato de intento de PA-S01. | CA05/07/20/21: deduplicación, resultado propio tras revocación, afiliación histórica y sin exposición de equipo/stock. |
| PA-T09-DB | Agregados por registro/grupo y fórmulas de indicadores antes de uniones con personas u organizaciones. | PA-T10; etiquetas aprobadas en PA-T07-REV. | CA03/08/09: 30 sigue siendo 30, metas pueden superar 100%, reposición no aumenta avance inicial. |
| PA-T09-FE | Presentar unidades, alcance del filtro y etiquetas de cantidades/meta; evitar superficie plantada y composición viva por especie no sustentadas. | PA-T09-DB; PA-T08-UX. | El usuario distingue hecho inicial, objetivo orientativo y saldo cuando corresponda, sin interpretación falsa del mapa. |
| PA-T11-QA | Pruebas de contratos, queries y recorrido integrado por audiencia, incluidas URLs directas y cachés. | Tareas anteriores implementadas en entorno de prueba autorizado. | Evidencia vinculada a cada CA, versiones de frontend/backend y datos de prueba; fallos pendientes visibles. |

Las tareas técnicas corresponden a los repositorios de aplicación cuando se autorice implementar. Este backlog no crea tablas ni aplica migraciones. Coordinar con PA-T-INT03/05/08 del [plan de integración](../plan-reutilizacion-integracion.md) y el [diseño técnico compartido](../diseno-tecnico-compartido.md), sin duplicar entregas.

La actualización del 11 de octubre añade CA12/13 y exige visitante sin sesión, enlaces profundos y sesión expirada en PA-T11-QA; además, no solicitar perfil, wallet ni documento para consultar. El registro de decisiones no acredita ejecutar estas pruebas.

La aclaración de separación de experiencias añade US06 y CA14/15. Incluir resumen global público, cambio de campaña y detalle progresivo en PA-T08-UX/FE; alcances públicos coherentes y agregación deduplicada en PA-T07-BE/DB y PA-T09-DB/FE; y todos los CA01..15 en PA-T11/QA. Verificar visitante y plantador sobre el mismo Impacto reducido, sin acceso interno al profundizar ni cambios globales a las herramientas de los operativos de R3Foresta.

La revisión en llamada confirma las elecciones descritas en PA-S02 §3 y añade CA18..22. Incorporar a PA-T08-UX/FE la última campaña habilitada/global, las acciones rápidas y la distribución de resumen/detalle; a PA-T07-BE/DB y PA-T08-BE la captura/lectura histórica y autoría/participación deduplicadas; y a PA-T11-QA todos los CA01..22, incluido cambio de cuenta y error de capacidades. No convertir la fórmula por subcampaña en faltantes agregados de campaña/global sin una regla acordada. Estas confirmaciones no marcan implementada ninguna tarea.
