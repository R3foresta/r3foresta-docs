# Plan — PA-S02

**Estado:** propuesta técnica para revisar después del comportamiento de [PA-S02](spec.md). No autoriza cambios de código, SQL ni publicación de datos. **Fecha:** 10 de octubre de 2026.

## 1. Orden y decisiones previas

| Paso estable | Trabajo y motivo | Evidencia para avanzar |
|---|---|---|
| PA-T07 | Concretar matriz/contratos según decisiones del 11 de octubre: PA-DI08 pública sin sesión y campos principales PA-DI05 confirmados. Resolver detalles pendientes antes de lecturas/cachés. | Ejemplos de respuesta pública sin token, propia y operativa; campos/fórmulas y afiliación histórica/actual explícitos. Compatibilidad con RN-PLA-34 y ADR-PLA-05. |
| PA-T08 | Definir resumen global público → campaña → subcampaña → registro, con mapa, cambio de campaña y enlaces directos, sin convertirlo en requisito para registrar. Compartir Impacto reducido entre visitante y plantador según PA-S00. | Boceto progresivo con visitante, persona asignada y responsable revocado; vacío, error y recuperación. Profundizar no abre gestión interna; el personal interno conserva estructura, entradas y herramientas autorizadas. |
| PA-T09 | Validar que los totales grupales no se multiplican por participantes. Separar cantidades iniciales, reposiciones, saldo vivo y metas orientativas. | Dataset sintético con múltiples personas/organizaciones y resultados esperados de mapa, lista y totalizadores. |

Se puede avanzar en inventario, boceto y pruebas propuestas mientras se revisan decisiones. La implementación de un campo o lectura privada espera su política aprobada. La consulta mínima del resultado guardado es dependencia de PA-S01 y no se aplaza solo por la etiqueta P1 de esta capacidad.

## 2. Reparto por capa

| Capa | Reutilizar | Cambio a diseñar | Límite |
|---|---|---|---|
| Frontend | Infraestructura de mapas, servicios y patrones de detalle de la PWA. | Experiencia participante de PA-S00; mapa de plantaciones, resumen progresivo y detalle persistido. Capacidades vigentes controlan acciones y rutas; estados de lectura identificables. | El mapa actual de Recolecciones no equivale al mapa de impacto requerido. No sustituirlo globalmente ni duplicar el formulario de registro. |
| Backend | Módulo `impact`, agregados de Plantación y hechos existentes. | Contratos por audiencia, identidad verificada para lectura propia/operativa, filtros opcionales y listado autorizado desde servidor. Separar respuesta común de capacidades, stock y equipo privados. | Los endpoints públicos por organización no obligan a una organización inicial ni autorizan campos nuevos. Revisar también rutas legadas que permitan eludir la política. |
| Base de datos | Campaña/subcampaña, registros/detalles, personas realmente vinculadas y snapshots existentes. | Consultas/proyecciones con agregación por registro antes de unir participantes u organizaciones; índices solo si el contrato y medición los justifican. | No crear otra tabla de plantaciones ni estado persistido de campaña. No materializar crédito individual ni inferir historia desde afiliaciones actuales. |

Ver contratos transversales y alternativas de datos en [diseño técnico compartido](../diseno-tecnico-compartido.md). Los nombres de endpoints/DTO nuevos se fijan al cerrar el contrato, no por copiar una pantalla interna completa.

## 3. Contratos mínimos a revisar

- Lectura común: alcance global público, campaña o subcampaña, filtros aplicados, agregados con fórmula explícita, geometría y resúmenes permitidos. El total y los puntos deben usar el mismo conjunto público elegible; el resumen global no revela ámbitos internos por agregación ni multiplica hechos al unir personas/organizaciones.
- Detalle de registro: identificador persistido, autoría y campos según audiencia. El permiso para recuperar el recibo propio no depende de conservar permiso para plantar.
- Contexto autenticado: capacidades operativas del actor por subcampaña, separado del contenido común cacheable. No descargar todos los equipos al navegador para filtrar allí.
- «Mis contribuciones»: propuesta de consulta por responsable/corresponsable histórico, deduplicada por registro. Su lectura ampliada y presentación esperan PA-DI05; no convertirla en ranking o reparto de crédito.
- Fotos/GPS: campos públicos confirmados; delimitar contrato, exclusión confirmada de metadatos fotográficos y entrega de evidencia vinculada. Una URL ya pública debe inventariarse; omitirla del nuevo DTO no la vuelve privada por sí solo. Probar enlaces sin sesión y separación de evidencia pendiente/privada.
- GET /plan: preservar la lectura autenticada de ADR-PLA-05. Separar esa lectura de las operaciones internas y documentar cualquier revisión futura de alcance antes de cambiarla.

## 4. Verificación y salida de la unidad

Preparar pruebas de contrato con respuestas de cada audiencia, pruebas de agregación y recorridos UX de PA-S02-CA01..17. Usar datos sintéticos: registro público de 30 con tres personas y dos organizaciones, registro público adicional de 20 en otra campaña, ámbitos no publicables, visitante sin sesión, usuario sin asignación y responsable con permiso retirado. El total público global es 50 sin multiplicaciones por uniones; cambiar campaña obtiene 30 o 20 y profundizar no abre pantallas/datos internos. Verificar indicadores separados de meta, bajas y reposición conforme a la definición revisada.

Probar llamadas directas e IDs ajenos, sesión vencida, contenido privado fuera de caché pública, cero resultados y fallo de red. Comprobar que ausencia de resultado en una vista filtrada no se interpreta como rechazo de un guardado de PA-S01.

Salida requerida: decisión humana de visibilidad documentada; contratos y boceto revisados; implementación posterior con evidencia de navegador → API → datos; regresión de las lecturas internas y del plan. Aprobar esta spec no habilita por sí solo el piloto.
