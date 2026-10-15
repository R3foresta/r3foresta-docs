# PA-T-INT02-C — APIs y comandos de gestión de acceso

**Estado al 15 de octubre de 2026:** BE01–BE06 implementados/verificados en entorno local identificado; listo para integrar INT06 localmente. Cotejo SQL remoto y despliegue externo pendientes. **Responsable:** backend/DB, en `Backend-r3foresta`. **Padre:** PA-T-INT02. **Capacidades:** PA-S03 y parte administrativa pendiente de PA-S00. [Tablero](README.md).

## Resultado y entradas

Entregar APIs v1 de capacidades, miembros, búsqueda/revisión de personas y comandos de acceso, más las operaciones administrativas separadas de rol/baja. Cada operación revalida identidad, autoridad, estado y revisiones en backend/DB y publica un resultado recuperable. La PWA recibe contratos ejecutados y documentados para integrar [INT06](pa-t-int06.md).

Leer [PA-S03: spec](../03-gestion-acceso-subcampania/spec.md), [plan](../03-gestion-acceso-subcampania/plan.md), [tareas](../03-gestion-acceso-subcampania/tasks.md) y [contratos funcionales](../03-gestion-acceso-subcampania/contratos.md); [PA-S00: spec](../00-experiencia-participante/spec.md) y [tareas](../00-experiencia-participante/tasks.md); [contrato backend aceptado](../contrato-identidad-permisos-backend-propuesta.md) §2, §3.2, §4–5 y §7–11. Los DTO y rutas de ese contrato prevalecen sobre candidatos anteriores.

Dependencias de ejecución previstas: identidad de INT02-A, base técnica/fixtures de [INT02-B](pa-t-int02-b.md) y motor de comandos probado en INT03-A. **Ejecución acreditada:** INT03-A estaba ausente; C implementó la parte común sin fotos sobre B para C04–C09/rol/baja. No habilita registro/cargas/stock ni acredita las carreras compartidas de D; integrar ese motor con INT03-A sigue pendiente. PA-T13-UX prepara las confirmaciones que consumirá frontend; sus etiquetas no alteran las políticas del contrato. Una correspondencia real pendiente no impide pruebas sintéticas, pero impide declarar ejecutada esa transición.

## Tareas para backend/DB

| Estado | ID de ejecución | Trabajo | Tarea de capacidad | Depende de | Salida verificable |
|---|---|---|---|---|---|
| [x] | PA-T-INT02-C-BE01 | Implementar política efectiva por acción/ámbito y adaptadores v1. | PA-T12-BE, parte de PA-T-ENT04-BE | INT02-B + INT03-A. | Actor JWT/BD, cuenta activa, ADMIN global derivado o permiso contextual vigente; DTO estrictos. |
| [x] | PA-T-INT02-C-BE02 | Implementar capacidades propias y miembros mínimos. | PA-T12-BE | BE01. | GET privados paginados; ámbito autorizado, administrador global deduplicado y vacío distinto de error. |
| [x] | PA-T-INT02-C-BE03 | Implementar búsqueda y revisión de persona/ámbitos. | PA-T12-BE | BE01 y cotejo de índices/normalización de B. | POST de lectura, nombre/correo exacto, datos mínimos y revisiones de la selección completa. |
| [x] | PA-T-INT02-C-BE04 | Implementar C04–C09 y selección todo-o-nada. | PA-T13-BE/DB, PA-T14-BE | BE01 + motor INT03-A. | Efecto/historial/recibo atómicos; estado, revisión y continuidad protegidos. |
| [x] | PA-T-INT02-C-BE05 | Implementar cambio de rol y baja administrativa separados del perfil. | Parte pendiente de PA-T-ENT04-BE/DB; PA-T13-DB | BE01/04 y contrato §3.2/§8. | Solo ADMIN global; autoridad versionada, motivo/historial/recibo, últimos administradores protegidos. |
| [x] | PA-T-INT02-C-BE06 | Verificar HTTP/DB y entregar contratos a frontend. | Parte de PA-T16-QA / PA-T-ENT06-QA | BE01–BE05. | Local aprobado: 22 grupos DB/8 carreras, 13 HTTP, OpenAPI/ejemplos y entorno sintético persistente con ocho perfiles/30 pruebas HTTP. Arranque completo/Supabase 18 probes y cotejador SQL 26 pruebas; REST 35/35 en desarrollo. Pendientes cuerpos SQL remotos/catálogo, despliegue externo e integración INT03-A/D. |

**Las seis casillas anteriores acreditan implementación, pruebas y entrega local**, no cierre de la dependencia INT03-A ni despliegue. [Informe reproducible](../../../../../Backend-r3foresta/docs/pa-int02c-entrega-local.md) y [evidencia DB/HTTP](../../../../../Backend-r3foresta/docs/evidencia/pa-int02c-local.json): build y 58 suites/636 unitarias, PostgreSQL 14.17 C.UTF-8; 14 rutas y contratos v1 completos. Pablo confirmó 072/073 sin errores; REST comprobó presencia/grants anon, sin comandos válidos ni personas. Estado SQL local ejecutado y cotejado automáticamente: 18 huellas, 52 restricciones y 21 FKs RESTRICT. Comparación de cuerpos remotos pendiente. El entorno persistente permite integrar INT06 sin cuentas reales ni Supabase; semilla/reset y perfiles se describen en el informe. No se ejecutó manifest real ni se acreditó commit/push/despliegue.

### BE01–BE03 — Lecturas y autoridad

Aplicar §4.2/§5 por acción y estado, conservando políticas internas legítimas. Un administrador contextual gestiona plantadores de su ámbito; las acciones de administrador y autoridad global siguen centrales. ADMIN global no necesita fila contextual y no cuenta como administrador contextual para continuidad.

Implementar las lecturas de §4.3/§5.2:

- Capacidades con lista por actor; `subcampanias:[]` es resultado válido, un fallo no se traduce a ese vacío. No excluir una ACTIVA por saldo cero ni ampliar facultades internas por estos códigos.
- Miembros solo para gestores del ámbito, con nombre/afiliación opcional, permiso/revisión, logística mínima y «Administrador · Acceso global» deduplicado. No devolver directorio/contactos ni insertar esas filas derivadas.
- Búsqueda de cuentas registradas activas por nombre o correo exacto y revisión de accesos para todos los IDs elegidos. Autorizar acción/estado en cada ámbito; máximo 100 ámbitos/20 resultados. Probar normalización y colisiones antes de imponer índices únicos. No crear cuentas ni invitaciones.

Mantener BIGINT/revisiones como cadenas, envelopes completos, campos desconocidos rechazados y lecturas privadas fuera de caché pública. La autorización del frontend no sustituye estas comprobaciones.

### BE04–BE05 — Escrituras y concurrencia

Implementar C04–C09 conforme a §5.3 sobre el motor común: otorgar/retirar plantador, designar administrador, cambiarlo a plantador, retirarlo y reemplazarlo. Revalidar revisiones incluso en SIN_CAMBIOS. Un reemplazo comprueba entrante activo y ambas revisiones; designa/verifica entrante antes de modificar saliente, todo en la misma transacción. En cerradas/canceladas respetar retiros/reemplazo y prohibición de nuevas altas; no reabrir.

Adquirir cuentas y todos los ámbitos por el orden de §8 antes de aplicar efectos. Selección de 1..100 IDs, sin comodines ni partición en comandos independientes: un fallo deja intactos permisos, revisiones e historial del conjunto. Cambios reales producen el evento correspondiente; SIN_CAMBIOS no fabrica eventos. Errores no revelan ámbitos ajenos.

Cambio de rol y baja usan el contrato §3.2, sin pasar por edición de perfil. Proteger último ADMIN global y, en cada ámbito inicializado afectado, último administrador contextual efectivo. Integrar la baja con las designaciones concurrentes; no basta consultar un conteo antes de la transacción.

### BE06 — Evidencia y entrega consumible

| Verificación | Evidencia de salida |
|---|---|
| PA-S03-CA01–08/12/15/17/18/21/22, en el alcance de gestión | HTTP directo con visitante, VOLUNTARIO sin permiso, plantador, administrador propio/ajeno y ADMIN global; datos mínimos y estados respetados. CA17 aquí comprueba capacidades; el registro real se acredita en INT03-A/D. |
| PA-S03-CA06/16, dos retiros y baja/designación | PostgreSQL concurrente real aislado; al menos un administrador contextual efectivo permanece donde corresponde. |
| Selección múltiple con un ámbito inválido/revisión obsoleta | Rechazo completo y comparación DB sin cambios parciales. |
| PA-S03-CA14, replay y respuesta perdida | Mismo comando/contenido recupera recibo; contenido distinto no lo sobrescribe; SIN_CAMBIOS conserva revisión. |
| PA-S03-CA11 y recuperación propia | Un retiro no borra historia ni impide recuperar recibo propio; no concede contexto/stock/equipo. |
| Roles/baja PA-S00-CA20–22 y contrato §10 | Perfil no muta autoridad; operación administrativa revalida rol/cuenta/revisión y continuidad. |

Entregar OpenAPI/DTO de la versión implementada, ejemplos de cada lectura y de recibo CONFIRMADO/RECHAZADO, SIN_CAMBIOS, revisión obsoleta y resultado inconcluso, además de comando GET de recuperación. Referenciar §7.3/§7.4 para 202/404 inconclusos y errores fuera de recibo; no convertir un timeout en rechazo durable.

El informe enlaza revisiones backend/migraciones, entorno, fixtures y órdenes/resultados de pruebas. Frontend recibe instrucciones para ejecutar el entorno y cuentas sintéticas por perfil, sin credenciales en docs. Toda diferencia material con D01–D12 queda resuelta/documentada antes de entregar el contrato.

## Estado verificado y siguientes comprobaciones

C04–C09 y rol/baja pasan en SQL real con selección todo-o-nada, revisiones/no-op, replay/recuperación propia, últimos administradores y ocho carreras con espera Lock observada. El motor revierte una subtransacción de negocio y publica rechazo durable; error inesperado/timeout no fabrica terminal. `lock_timeout=5s` medido; `statement_timeout=30s` previo a la llamada en el ensayo; diagnóstico REST privado observó 30s/5s en desarrollo. Continuidad cooperativa entre RPC: servicio SQL privilegiado conserva el límite del contrato §8.3. BE06 está verificado para integración local: entorno persistente `127.0.0.1:3302`, ocho perfiles, CORS/recuperación 202 y 30 pruebas HTTP. La aplicación completa pasó 18 probes con Supabase y el cotejador SQL 26 pruebas. Cotejo SQL remoto y despliegue externo siguen pendientes; los perfiles locales son sintéticos.

## Cierre y dependencia de frontend

**Listo para integrar INT06 localmente:** BE01–BE06 verificados, APIs consumibles en el entorno sintético identificado y ejemplos/errores/recuperación coherentes con el contrato. La integración remota exige cotejo SQL/catálogo y backend desplegado acreditados. Actualizar PA-T12/13/14 y QA solo en la porción acreditada, el [tablero](README.md) y [ESTADO.md](../../../../ESTADO.md).

INT02-D completa rutas/RPC equivalentes y carreras con registro, plan, stock, logística y cierre. La integración frontend puede comenzar con C verificada; habilitar el recorrido participante y cerrar su QA requiere también las garantías de D. Esta ficha no completa INT02, PA-S03 ni el piloto.
