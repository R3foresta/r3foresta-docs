# PA-T-INT02-D: alcance aprobado del cierre de superficie

16 de octubre de 2026. Base backend a045d9d + árbol INT02-D. **Estado: autorizada explícitamente por Pablo y ensayada en el alcance local; D cerrada en alcance técnico local, código `75a57eb`.** Aprobación: «Autorizar estos cambios locales», sobre las diez tablas, una vista, cuatro catálogos y rutas HTTP exactas de este documento. [Ejecución, evidencia y límites de entrega](../../../../../Backend-r3foresta/docs/pa-int02d-entrega-local.md). No habilita SQL remoto, nuevos grants a `service_role` o ampliaciones del inventario. El bloque anterior 080 + guards/consumidores fue rechazado por revisión automática antes de ejecutarse por su amplitud (RLS masivo y nuevos DML amplios de service_role). Se conserva aquí el alcance exacto aprobado de la variante reducida.

## Variante materialmente reducida

1. Mantener 077–079 ya implementadas. Sus firmas exactas y sobrecargas ya cierran EXECUTE a PUBLIC/anon/authenticated; no repetirlas en080 ni conceder DML a service_role.
2. 080 contendría solamente REVOKE de las 10 relaciones operativas enumeradas y de una vista concreta, más DML público de cuatro catálogos alcanzables por los controllers actuales. No ALTER TABLE ENABLE RLS, no modificación de políticas, no UPDATE de datos, no cambios Storage, no grants nuevos al servicio, no recorrido dinámico que revoque vistas desconocidas.
3. Preflight solo lectura enumera privilegios/grants de columnas, membresías, vistas dependientes y SECURITY DEFINER que lean las relaciones objetivo; comprueba que service_role YA tiene los permisos mínimos requeridos abajo. Un grant faltante, vista pública adicional o definer público que eluda la frontera hace fallar la validación y requiere revisión de ese objeto concreto; no se reabre acceso ni se concede DML automáticamente.
4. HTTP: guards explícitos y adaptación mínima de consumidores enumerados abajo. Este cambio HTTP se revisa como alcance separado del SQL, aunque ambos son necesarios para el cierre completo. No constituye aprobación del bloque previo ni habilita uso remoto.

## Relaciones SQL exactas propuestas

Cerrar ALL privilegios de tabla y privilegios SELECT/INSERT/UPDATE/REFERENCES por columna para PUBLIC/anon/authenticated únicamente en:

| Relación | Dato/vía protegida | Consumidor servidor que se conserva | Mínimo service_role a verificar, sin conceder |
|---|---|---|---|
| asignacion_vivero_subcampania | stock de ámbitos y consumo/devolución directa | 075/077, contexto v1, saldos internos | SELECT, INSERT, UPDATE |
| registro_plantacion | notas del autor y escritura por fuera de comando/origen | 075/077, detalle propio, Impacto público proyectado | SELECT, INSERT, UPDATE |
| registro_plantacion_detalle | trazas/asignaciones, escritura de consumo indirecta | 075/077 e Impacto agregado | SELECT, INSERT |
| registro_plantacion_coresponsable | identidades históricas sin permiso vigente | 075/077/detalle propio | SELECT, INSERT |
| evento_plantacion | historia operativa y contadores | 077, timeline interno, Impacto agregado | SELECT, INSERT |
| evidencias_trazabilidad | originales/paths privados/pendientes y vínculo directo | 074/075/077/079, API general filtrada, foto pública elegible | SELECT, INSERT, UPDATE |
| subcampania_equipo | logística no es permiso; mutación elude exclusión de ámbito | 077/078, equipo interno | SELECT, INSERT, DELETE |
| subcampania | lectura de campos internos/observaciones y cambios fuera de RPC | 070/075/077/078, consultas internas, Impacto proyectado | SELECT, INSERT, UPDATE |
| lote_vivero | saldo físico privado y escritura directa | 077, operaciones/saldos internos | SELECT, INSERT, UPDATE |
| evento_lote_vivero | historial físico privado y evidencia de salida | 077, Vivero interno | SELECT, INSERT |

Vista concreta: v_lote_vivero_saldos, si existe: REVOKE SELECT de PUBLIC/anon/authenticated; comprobar SELECT existente de service_role. campania_estado no cambia: su proyección contiene estado derivado, sin filas de stock/personas. Otras vistas no se revocan implícitamente: el preflight las enumera y bloquea el cierre si exponen datos protegidos.

Catálogos concretos: planta, comunidad, division_administrativa. Solo REVOKE INSERT/UPDATE/DELETE/TRUNCATE/REFERENCES/TRIGGER y privilegios de columna INSERT/UPDATE/REFERENCES a PUBLIC/anon/authenticated; conservar SELECT y las consultas mínimas existentes. tipo_planta también es escritura POST /plantas/tipos-planta: incluir la tabla tipo_planta si existe, con la misma regla de DML; no alterar sus lecturas. Verificar service_role SELECT/INSERT/UPDATE existentes. organizacion ya cerró DML público en066; sin cambio de080.

No cambiar usuario/usuario_credencial/permisos/comandos/cargas/auditorías: 066/068/070/072/074 ya declaran su frontera. Se cotejan como regresión, sin duplicar su DDL.

## ACL locales acreditadas y límites

- 066 revoca usuario/usuario_credencial y RPC sensibles existentes; no cierra las tablas operativas arriba. 070 revoca DML público de subcampania, conservando SELECT; su estado final no demuestra privacidad de lectura.
- 074 cierra cargas/generaciones y crea bucket privado con política restrictiva específica. No cierra lectura de evidencias_trazabilidad, registro_plantacion ni stock.
- 077 revoca todas las sobrecargas inventariadas y concede solo firmas vigentes; inicial antigua devuelve CLIENTE_INCOMPATIBLE. 078 hace lo mismo para lifecycle. 079 cierra RPC nuevas/pa_foto_publica a servicio privado.
- El fixture sintético actual concede las tablas operativas a service_role, sin grants anon adversarios por defecto. Ese hecho no prueba el catálogo Supabase; agregar probes adversarios de grants por tabla/columna/vista es parte de la verificación local propuesta.
- 074–076 fueron aplicadas sin errores en desarrollo vyrjlehkhabydkhjxagx según confirmación humana. No hay cotejo de ACL/tablas/vistas remotas de080 y no se ejecutará SQL remoto en esta tarea.

## Cambio HTTP exacto propuesto

| Controller/entradas | Cambio | Lectura que se conserva |
|---|---|---|
| AppController GET /api/test-db | InternalActorGuard en ese método; ActorModule en AppModule | /health y GET raíz siguen públicos |
| PinataController POST /api/pinata/upload-json | InternalActorGuard; importar ActorModule | No hay lectura pública en ese controller |
| BlockchainController POST /mint y GET /wallet,/contract-info | InternalActorGuard en estos métodos; ActorModule | GET token/:id/uri, token/:id/owner y balance/:address son consultas de cadena pública y se conservan públicas |
| PlantasController POST /, POST /tipos-planta, PATCH /:id, PATCH /:id/desactivar | InternalActorGuard en mutaciones; ActorModule | GET /plantas, /tipos-planta, /:id siguen públicos |
| ComunidadesController POST /, PATCH /:id, PATCH /:id/desactivar | InternalActorGuard en mutaciones; ActorModule | GET catálogo y detalle siguen públicos |
| UbicacionesController POST /divisiones/flexible | InternalActorGuard; ActorModule | GET países/divisiones siguen públicos |

Guard existente verifica JWT y cuenta activa en DB, ignora x-user-role como autoridad y admite ADMIN/GENERAL/VALIDADOR internos; un permiso contextual de VOLUNTARIO no abre estas rutas. No se introduce gate global sobre Impacto ni se concede rol nuevo.

Consumidores privados exactos afectados por revocar lectura de tablas/vista: campanias-metrics.service.ts (consulta registros/stock), campanias-consultas.service.ts (subcampañas), campanias-desactivacion.service.ts (registros/stock y RPC privada), vivero-saldos.service.ts (lote/vista), vivero-evidencias.service.ts (evidencias privadas). Cambiar getClient→getAdminClient únicamente en esas consultas; guards/roles por ruta ya existen y las respuestas siguen contratos internos. ImpactService ya usa getAdminClient en el árbol079 y reduce explícitamente su respuesta pública. No cambiar indiscriminadamente todos los services/catálogos a cliente administrativo.

Mutaciones catálogo usarían getAdminClient únicamente en los métodos de crear/editar/desactivar requeridos tras REVOKE DML; conservar getClient de consultas públicas. No ampliar SELECT público ni el DTO. Si falta clave administrativa, fallar; ningún fallback a cliente público.

## Verificación y riesgo revisable

Instalar/repetir080 solo en clúster sintético PostgreSQL/PostGIS, con grants adversarios de tabla/columna/vista; probar denegación real anon/authenticated/PUBLIC y que el servicio opera sin nuevos grants. HTTP real debe verificar401/403 sin IO para privados, positivos internos autorizados, GET plan con cualquier cuenta activa, Impacto/fotos antiguas+modernas sin JWT y catálogos públicos. La prueba de foto antigua utiliza un JPEG sintético con EXIF y verifica eliminación del metadata.

El cambio SQL puede romper consumidores externos que hoy lean/escriban raw tablas/vista o dependan de grants amplios. El cambio HTTP invalida escrituras/diagnósticos sin sesión interna. Las pruebas aisladas no prueban esos consumidores externos, políticas Supabase ni URLs/CDN emitidas; el despliegue/corte remoto requiere inventario/cotejo propio. service_role continúa privilegiado; no se promete aislamiento frente a SQL que eluda RPC cooperativas.

La autorización registrada arriba permitió implementar080 y los guards/consumidores enumerados, verificados localmente. La [evidencia de recepción](../../../../../Backend-r3foresta/docs/evidencia/pa-int02d-handoff.json) conserva la última comprobación del árbol; la expectativa de activación y la recepción fueron resueltas en el [cierre local D](../archivo/cierre-pa-t-int02-d.md). Cotejo/aplicación remotos y push/despliegue siguen pendientes.
