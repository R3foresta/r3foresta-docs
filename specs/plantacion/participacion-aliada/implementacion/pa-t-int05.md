# PA-T-INT05 — Impacto público y Mis registros

**Fecha:** 17 de octubre de 2026. **Estado:** siguiente encargo preparado; sin implementación acreditada de INT05. **Orden:** contrato/proyecciones backend → integración frontend → QA local. **Capacidades:** PA-S02 y navegación pública pendiente de PA-S00. [Tablero](README.md).

## Resultado y fuentes

Consultar y compartir Impacto global → campaña → subcampaña → registro y fotos elegibles sin cuenta ni login. Ofrecer «Mis registros» autenticado por autoría o participación histórica, con cantidades grupales deduplicadas y afiliaciones conservadas al plantar. Mantener las herramientas internas y el registro recuperable entregado por INT04.

Base disponible: [cierre D](../archivo/cierre-pa-t-int02-d.md), [cierre INT04](../archivo/cierre-pa-t-int04.md), [contratos backend](../../../../../Backend-r3foresta/docs/pa-int02d-compatibilidad.md) y [entrega PWA](../../../../../pwa-r3foresta/docs/QA_REGISTRO_PARTICIPANTE_INT04.md). Los commits de código son backend `75a57eb` y PWA `94f62a9`; comprobar HEAD y árbol antes de trabajar. Tener foto pública y detalle propio no acredita la entrega completa de consulta.

Leer [PA-S02 spec](../02-consulta-impacto-y-registros/spec.md), [plan](../02-consulta-impacto-y-registros/plan.md) y [tareas](../02-consulta-impacto-y-registros/tasks.md); [PA-S00](../00-experiencia-participante/spec.md), [PA-S01](../01-registro-plantacion-inicial/spec.md), [contrato D01–D12](../contrato-identidad-permisos-backend-propuesta.md) y RN-PLA-34/ADR-PLA-05 de [Plantación](../../../../decisiones/02_decisiones_plantacion.md). La consulta pública, los snapshots y la separación de autoridad ya están aceptados; esta entrega concreta contratos e implementación sin volver a preguntar esas decisiones.

## Backend/DB — `Backend-r3foresta`

| Estado | ID | Trabajo y trazabilidad | Salida verificable |
|---|---|---|---|
| [ ] | PA-T-INT05-BE01 | Cotejar campos, fuentes y audiencias de Impacto, detalle propio, snapshots, fotos y aliases actuales. PA-T10, PA-T07-REV/BE. | Matriz pública/propia/operativa, DTO/errores/paginación/ejemplos y compatibilidad; campos pendientes identificados sin ampliar audiencia. |
| [ ] | PA-T-INT05-BE02 | Completar lecturas públicas global, campaña, subcampaña y registro, con filtros y enlaces estables. PA-T07-BE/DB. | Mismo alcance público elegible en agregados, mapa y detalle; sin JWT/perfil/capacidades como requisito, stock/equipo/contactos ni borradores por inferencia. |
| [ ] | PA-T-INT05-BE03 | Verificar agregación por registro antes de unir personas/organizaciones y distinguir indicadores. PA-T09-DB. | Dataset 30 + 20 = 50; cantidades no multiplicadas; inicial separada de bajas/reposiciones; faltantes por subcampaña `max(meta - inicial, 0)`, avance puede superar 100%. |
| [ ] | PA-T-INT05-BE04 | Implementar «Mis registros» por responsable o participante histórico. PA-T08-BE y PA-T07-BE/DB. | Actor desde JWT vigente; unión deduplicada/paginada con relación identificable, disponible tras retiro operativo y sin ampliar observaciones privadas al corresponsable. |
| [ ] | PA-T-INT05-BE05 | Entregar snapshots/personas/fotos según audiencia y datos históricos disponibles. PA-T07-BE/DB, PA-T08-BE. | Afiliación al plantar; ausencia declarada distinta de historia no disponible. Fotos públicas sanitizadas elegibles, sin originales/pendientes; GET /plan técnico conserva autenticación. |
| [ ] | PA-T-INT05-BE06 | Verificar HTTP/SQL y regresión, documentar contratos/entorno para frontend. PA-T11-QA parcial. | Probes sin token, sesión vencida, IDs ajenos, autor revocado y participante; evidencia reproducible con versiones, datos sintéticos y límites de entorno. |

Reutilizar el módulo Impacto, hechos y snapshots actuales. No crear otra tabla de plantaciones, estado persistido de campaña, crédito individual ni migraciones sin necesidad acreditada. No reconstruir afiliaciones legadas desde el perfil actual o la organización de campaña. El detalle propio de INT04 no se convierte en enlace público compartido.

Los contratos nuevos deben nombrar endpoints/DTO y caché después del cotejo, con ejemplos que frontend pueda validar en runtime. D conserva su frontera SQL/Storage; ninguna lectura nueva reabre privilegios raw ni ofrece un cliente público con acceso administrativo.

## Frontend — `pwa-r3foresta`

Comenzar integración con BE01–BE06 verificadas y contrato/entorno entregados. Boceto y revisión de componentes pueden prepararse antes sin acreditar implementación.

| Estado | ID | Trabajo y trazabilidad | Salida verificable |
|---|---|---|---|
| [ ] | PA-T-INT05-FE01 | Cotejar contrato backend y reutilización de mapas, cliente, capacidades y detalle INT04. PA-T08-UX/FE y PA-T-ENT05-FE. | Rutas/componentes/DTO runtime identificados, separando consulta pública y propia de las pantallas internas. |
| [ ] | PA-T-INT05-FE02 | Integrar global, campaña y subcampaña públicos con mapa, selección y enlaces directos. PA-T08-FE. | Abren en incógnito/sin sesión y ante fallo de capacidades; carga/vacío/error distintos, retorno conserva contexto y no abre gestión interna. |
| [ ] | PA-T-INT05-FE03 | Mostrar detalle público, fotos, etiquetas y alcance de indicadores. PA-T08/09-FE. | Punto = registro grupal; inicial/meta/faltantes separados de seguimiento. Datos históricos explícitos, sin atribuir todo el grupo a cada persona/organización. |
| [ ] | PA-T-INT05-FE04 | Integrar «Mis registros» y su navegación al resultado permitido. PA-T08-FE. | Lista autenticada «registré/participé», deduplicada y recuperable tras retiro; no sustituye los enlaces públicos ni concede contexto operativo. |
| [ ] | PA-T-INT05-FE05 | Integrar entrada por última campaña habilitada/global y acciones según capacidad. PA-T08-FE y PA-T-ENT05-FE. | Preferencia por cuenta revalidada; un enlace directo conserva destino; ausencia confirmada lleva al global y error de capacidades no se declara revocación. Registro/gestión INT04/INT06 conservados. |
| [ ] | PA-T-INT05-FE06 | Verificar recorrido integrado y entregar documentación/evidencia. PA-T11-QA y PA-T-ENT06-QA parciales. | Navegador → API → datos con CA01–24 aplicables, incógnito, sesión vencida, cambio de cuenta, foto elegible, autor revocado, agregados y regresión INT04/INT06. |

El visitante y el VOLUNTARIO sin asignación reciben la misma proyección pública. La consulta pública no espera perfil ni capacidades y queda fuera de la ruta protegida. La preferencia de campaña no cambia un enlace compartido ni autoriza acciones. Conservar el formulario de tres pasos; INT05 no vuelve a implementar registro/cargas.

## Evidencia, cierre y límites

Preparar dataset sintético con varios participantes/organizaciones, 30 plantas en una campaña, 20 en otra, ámbitos no publicables, afiliación cambiada después del hecho y legado sin snapshot. Comparar respuestas públicas/propias/operativas, totales/listas/mapa, URLs y bytes de fotos; no basta ocultar campos en la interfaz. No sumar faltantes de campaña/global sin regla aprobada ni prometer carbono, superficie efectivamente plantada o composición viva por especie sin fuente.

Backend entrega contrato/ejemplos y entorno reproducible; frontend entrega guía de rutas, estados, capturas y resultados. Actualizar esta ficha, PA-T07–11 y tareas de entrada/QA solo en el alcance acreditado, tablero y ESTADO; archivar encargo/cierre después de verificarlo. Un contrato preparado, un mock o pruebas de entregas anteriores no cierran INT05.

La revisión humana de UX puede avanzar en paralelo. Aplicación/cotejo remoto 077–080, transición real B/C, Storage/URLs históricas, WebAuthn, despliegue y piloto mantienen su evidencia separada. INT07 conserva el alcance pendiente de PA-S04; INT08 integra QA/corte/piloto. No iniciar implementación ni crear un chat nuevo por la sola preparación de esta ficha.
