# Recepción de PA-T-INT02-D — 16 de octubre de 2026

**Antecedente archivado:** conserva el encargo y el estado recibido antes del cierre local. Para continuar, consultar la [ficha vigente](../implementacion/pa-t-int02-d.md) y el [cierre técnico local](cierre-pa-t-int02-d.md). Los pendientes aquí descritos tienen la fecha de recepción.

**Fecha:** 16 de octubre de 2026. **Estado:** lista para entregar a backend como revisión y cierre del árbol local preparado. Build aprobado; 784/785 unitarios aprobados, con un pendiente concreto. Sin cierre técnico de D. Pablo enviará el encargo; INT04 aún no se implementa. **Responsable:** backend/DB en `Backend-r3foresta`. **Padre:** PA-T-INT02, incremento PA-F01. **Orden autorizado:** INT02-D → INT04. [Tablero](../implementacion/README.md).

## Resultado y base

Cerrar las vías que permitirían eludir identidad, permiso contextual, propiedad de evidencias o recuperación del registro v1; integrar el orden de locks con plan, entregas/devoluciones, activación/cierre y equipo. Preservar reposición/logística internas con su autoridad propia. Entregar un backend verificable y contratos de compatibilidad que [INT04](../implementacion/pa-t-int04.md) pueda consumir.

Base observada: backend `a045d9d`, [cierre local INT03-A](../archivo/cierre-pa-t-int03-a.md), [informe de registro](../../../../../Backend-r3foresta/docs/pa-int03a-entrega-local.md), y entregas B/C. Comprobar revisiones/cambios y catálogo antes de editar; migraciones nuevas aditivas, sin sobrescribir 068–076. **Pablo confirmó el 16 de octubre 074–076 aplicadas sin errores en desarrollo Supabase `vyrjlehkhabydkhjxagx`.** El cotejo posterior de ese catálogo/Storage sigue pendiente; la confirmación de ejecución no lo sustituye ni exige repetir esas migraciones.

Leer [contrato backend aceptado](../contrato-identidad-permisos-backend-propuesta.md) §4, §6.1/§6.3, §7.3–7.5, §8–11; [PA-S03 spec](../03-gestion-acceso-subcampania/spec.md), [plan](../03-gestion-acceso-subcampania/plan.md) y [tareas](../03-gestion-acceso-subcampania/tasks.md); [PA-S01 spec](../01-registro-plantacion-inicial/spec.md) y [tareas](../01-registro-plantacion-inicial/tasks.md); [PA-S00](../00-experiencia-participante/spec.md) y [PA-S02](../02-consulta-impacto-y-registros/spec.md) para audiencias. Consultar [inventario de rutas](../inventario-endpoints-y-regresion-participacion.md) como mapa fechado y [contrato físico M2→M3](../../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md) §6/§7/§10 para invariantes.

## Recepción del trabajo preparado

El implementador recibe cambios locales existentes, no un repositorio vacío. Leer el [informe backend](../../../../../Backend-r3foresta/docs/pa-int02d-entrega-local.md), [manifest de recepción](../../../../../Backend-r3foresta/docs/evidencia/pa-int02d-handoff.json), [compatibilidad](../../../../../Backend-r3foresta/docs/pa-int02d-compatibilidad.md) y [preview D](../../../../../Backend-r3foresta/docs/pa-int02d-preview.md) antes de editar. Preservar el árbol y comprobar su revisión; no reiniciar ni duplicar 077–080.

Están preparadas 077–080, guards/consumidores, pausa de escritura y contratos. Evidencia aislada: 32 grupos SQL (10 D + 22 registro), 22 carreras (12 D + 10 registro), 25 HTTP con DB/Storage, siete escenarios adversarios de preflight y preview con 080 aprobado. Las pruebas de las trece entradas adicionales usan servicios externos simulados; no acreditan acciones externas reales.

**Pendiente inmediato de BE07:** `subcampanias-activacion.service.spec.ts`, caso «propaga 40001 sin dar por confirmada la activación», espera `ConflictException` 409 y recibe `ServiceUnavailableException` 503 por el nuevo manejo de resultado inconcluso. Conciliar la expectativa con el contrato y comprobar código/ausencia de confirmación durable; repetir las comprobaciones afectadas. Última ejecución global: 63/64 suites, 784/785 pruebas. Build y cuatro suites focales/101 pruebas aprobados. No usar el resultado anterior de 761 pruebas para declarar el árbol actual cerrado.

El encargo restante es resolver ese pendiente, revisar inventario/matriz final de BE01/BE02, confirmar BE01–BE08 y actualizar informe/evidencia/tablero/ESTADO. El cierre habilita que Pablo envíe INT04 a frontend. Aplicación remota, publicación y despliegue siguen separados; esta recepción no los autoriza.

## Tareas para backend/DB

**Alcance adicional autorizado el 16 de octubre:** el bloque amplio de seguridad 080/guards fue rechazado automáticamente antes de ejecutarse. Pablo autorizó explícitamente la [variante reducida y exacta](../implementacion/pa-t-int02-d-superficie-propuesta.md): implementación/pruebas locales de diez tablas, una vista, cuatro catálogos y las rutas enumeradas, sin RLS masivo, nuevos grants a `service_role` ni SQL remoto. 080 ya se implementó y ensayó localmente en ese alcance; el preflight aborta ante objetos adicionales expuestos, sin modificarlos. No ampliar el inventario por esta autorización.

Las casillas acreditan el alcance local indicado. Las pendientes requieren revisión/cierre del receptor; no significan ausencia de implementación. No archivar D ni iniciar INT04 mientras BE07 y la entrega final sigan pendientes.

| Estado | ID de ejecución | Trabajo y trazabilidad | Depende de | Salida verificable |
|---|---|---|---|---|
| [ ] | PA-T-INT02-D-BE01 | Cotejar rutas, RPC/sobrecargas, grants, consumidores y catálogo actual. PA-T12-BE/REV, PA-T15 y PA-T-ENT02. | Cierre local INT03-A y contrato. | Matriz ruta/objeto/audiencia/autoridad/función/cliente, diferencias y pendientes remotos explícitos. |
| [ ] | PA-T-INT02-D-BE02 | Cerrar bypass HTTP/SQL y unificar autorización por objeto. PA-T12-BE, PA-T02-BE, PA-T-ENT04-BE/DB. | BE01. | JWT/actividad/autoridad vigente en cada entrada privada; anon/authenticated/PUBLIC sin entrypoints sensibles equivalentes. |
| [x] | PA-T-INT02-D-BE03 | Adaptar locks/transacciones de operaciones físicas, plan y ciclo de vida. PA-T04-DB, PA-T13-DB, PA-T16-QA. | BE01/02 y §8. | Verificado localmente con carreras/rollback; pendiente aplicación/cotejo del destino. |
| [x] | PA-T-INT02-D-BE04 | Separar inicial de reposición interna y validar origen del mismo ámbito. PA-T02/04-BE/DB, PA-ID25/CR04. | BE02/03. | HTTP/RPC: inicial legada 409, origen ajeno sin efectos y reposición propia conservada. |
| [x] | PA-T-INT02-D-BE05 | Cerrar audiencias de evidencia/Storage y documentar compatibilidad interna. PA-T04-BE, PA-T12-BE, PA-ID18/23/26. | BE01/02/04. | Objetos sintéticos privados, propiedad estricta y fotos sanitizadas probados; URLs/CDN/políticas remotas conservan pendiente propio. |
| [x] | PA-T-INT02-D-BE06 | Implementar y ensayar corte/versiones y recuperación compatible. PA-T12-BE, PA-ID24, INT08 parcial. | BE02–BE05. | Pausa/recuperación y legado 409 probados localmente; drenaje y habilitación reales no ejecutados. |
| [ ] | PA-T-INT02-D-BE07 | Verificar HTTP, SQL/PostGIS, carreras y regresión interna/pública. PA-T16-QA, PA-T05-QA y PA-T-ENT06-QA parciales. | BE02–BE06. | Matriz con casos positivos/negativos, locks/conteos/saldos/recibos y regresiones de B/C/INT03-A. |
| [ ] | PA-T-INT02-D-BE08 | Entregar contratos/entorno a INT04 y documentar cierre por capa. Tareas anteriores e INT08 parcial. | BE01–BE07 en el alcance acreditado. | Informe backend, migraciones/orden, evidencia y adaptadores frontend requeridos; tablero/ESTADO actualizados sin completar padres. |

### BE01–BE02 — Inventario y política efectiva

Contrastar el inventario del 13 con el árbol actual, incluidos aliases de inicial/reposición, contexto/participantes/equipo, evidencia general/por entidad/ID, diagnósticos y RPC 054/057/060/061/062 más sus reemplazos. ADMIN global deriva autoridad sin fila; VOLUNTARIO contextual puede registrar solo en su ámbito ACTIVA. Permiso nuevo no se suma al equipo como alternativa para autorizar inicial. El perfil/cabeceras del cliente nunca deciden identidad o autoridad.

Mantener lectura pública de Impacto/foto elegible sin JWT, pendiente/original privado y GET /plan autenticado conforme ADR-PLA-05. No aplicar un gate global uniforme que revoque facultades internas legítimas de GENERAL/VALIDADOR: revalidar acción, dueño, estado y objeto. Cerrar sobrecargas, helpers, grants indirectos y rutas equivalentes; no deducir denegación SQL a partir de un 401 HTTP. Conservar el límite cooperativo de `service_role` de §8.3.

### BE03–BE04 — Locks y preservación del dominio interno

Usar el orden §8: mutex global solo para autoridad global cuando corresponda; cuentas ASC → organizaciones referenciadas → campañas afectadas → subcampañas ASC → secuencia de código → comandos → permisos/revisiones → objetos → asignaciones → lotes si la operación física los modifica → cargas/generaciones/evidencias. Tomar todos los IDs de una etapa antes de la siguiente; no adquirir cuentas después de ámbito ni envolver la 061 antigua sin resolver `rp_seq → subcampaña`. Esperar/revalidar en PostgreSQL, sin mutex local Node como garantía distribuida.

Adaptar devolución 054, cancelación masiva/desactivación 057, entrega física 060/076, plan 062 y entradas de activación/cierre/equipo que puedan competir. Las escrituras de servicio separadas que verifican y luego mutan sin exclusión deben pasar a una transacción coherente. Conservar coordinación/logística, metas, fechas, estados y hechos; no añadir recepción, reapertura o una condición nueva de activación. Consumo inicial sigue M3 sin segundo débito M2; devolución física sí retorna plantas a Vivero.

La reposición requiere su autoridad interna vigente; permiso de inicial no la concede. Bajo lock, comprobar origen inicial válido y `origen.subcampania_id = subcampania_id`, propósito REPOSICION y reglas existentes. Origen ajeno rechaza sin consumo/contador/vínculo ni datos del otro ámbito. Mantener el caso positivo con origen propio y su elección de especie vigente. Si la privacidad exige cambiar el DTO de upload interno, exigir ámbito/propósito explícitos, documentar el contrato y entregar el adaptador a INT04; un DTO anterior sin contexto no conserva una vía pública de escritura.

### BE05–BE06 — Evidencias y corte compatible

Las nuevas cargas internas/participantes deben acreditar propiedad también para ADMIN, tipo/ámbito/pendencia, original privado y derivado sanitizado. Rutas generales no pueden abrir ni modificar cargas del recorrido privado por conocer un ID. Inventariar `recoleccion_fotos`, `getPublicUrl`, políticas/URLs/CDN ya emitidas; no volver privado todo Recolección ni borrar binarios reales para simular el cierre. La evidencia local y el cotejo remoto son hechos separados.

Implementar el rechazo del contrato antiguo y la puerta de corte revisada en servidor, sin claves inventadas por petición ni roles elegidos por cliente. Mantener GET/replay propio y lecturas autorizadas durante el corte. Documentar pausa de inicial, drenaje de transacciones antiguas y habilitación del motor único; ningún registro antiguo puede conservar `rp_seq` en orden opuesto mientras opera el nuevo. Rollback posterior a retiros no reactiva el autorizador antiguo: cerrar escritura si corresponde y conservar recibos/lecturas.

## BE07 — Evidencia mínima

| Casos | Resultado a acreditar |
|---|---|
| PA-ID11–13 | Ambos órdenes de retiro/registro, baja/designación y cambio de rol; revalidación bajo lock y continuidad de administradores con cuentas activas. |
| PA-ID21 | Inicial frente a plan/cierre/devolución/entrega y operaciones físicas entre sí: orden observado, sin saldo negativo, doble consumo o inversión de locks. |
| PA-ID25 / CR04 | Reposición con origen ajeno rechazada por HTTP/RPC; origen propio autorizado conserva reglas y un consumo M3. |
| PA-ID18/23 | Roles SQL públicos y rutas/aliases generales no abren/mutan evidencia privada; propiedad estricta, públicas solo imágenes sanitizadas elegibles. |
| PA-ID24 | Cliente antiguo/inicial compartida recibe 409; replay terminal intacto tras retiro/cambio de versión, sin bypass ni reactivación por rollback. |
| PA-ID05/26 y regresión | Herramientas internas autorizadas, plan GET/PUT, logística/mantenimiento y Impacto anónimo preservados; login solo en lo privado. |

Usar HTTP con guards/services/RPC reales y PostgreSQL/PostGIS aislado con barreras de locks; conservar saldos/conteos/estado/auditoría antes/después. Reutilizar fixtures de INT03-A ampliándolos con operaciones físicas y ciclo de vida; el antecedente mínimo no acredita replay completo del esquema. Verificar instalación/repetición de migraciones, timeout/inconcluso y regresión B/C/registro v1. Datos de producción y personas reales no son fixtures.

## BE08 — Cierre técnico que recibe INT04

Entregar `docs/pa-int02d-entrega-local.md`, matriz final de rutas/políticas/compatibilidad, migraciones/orden y comandos/evidencias reproducibles. Registrar cambios de contrato que afectan al formulario interno/reposición, OpenAPI/ejemplos y configuración de versiones/corte. Actualizar documentación de módulos y las tareas de capacidad afectadas; enlazar informe desde esta ficha, tablero y ESTADO con revisión y entorno.

**Listo para comenzar INT04:** BE01–BE08 acreditadas para el alcance técnico local, regresiones de B/C/INT03-A aprobadas y contrato/entorno entregados. Aplicación/cotejo SQL/Storage remotos, conciliación de fechas/permisos, despliegue y piloto permanecen visibles y no se deducen del QA aislado. La confirmación humana de 074–076 no obliga a repetirlas. El orden INT02-D → INT04 se cumple con este cierre técnico; habilitar participantes reales requiere además la evidencia del corte en el entorno destino y los criterios de INT08.
