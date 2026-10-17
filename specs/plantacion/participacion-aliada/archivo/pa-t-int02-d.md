# PA-T-INT02-D — Permisos por objeto, rutas equivalentes y concurrencia

**Archivo del encargo completado:** conserva el corte de cierre del 16 de octubre, anterior al commit local de código `75a57eb`. [Acta y actualización posterior](cierre-pa-t-int02-d.md). Las referencias a INT04 pendiente pertenecen a ese corte; su [cierre posterior](cierre-pa-t-int04.md) y la continuación INT05 están en el [tablero vigente](../implementacion/README.md).

**Cierre:** 16 de octubre de 2026. **Estado:** BE01–BE08 completadas en alcance técnico local. **Responsable:** backend/DB en `Backend-r3foresta`. **Padre:** PA-T-INT02, incremento PA-F01. [Tablero](../implementacion/README.md).

Verificación final aprobada el 16 de octubre sobre PostgreSQL/PostGIS aislado y objetos sintéticos; hashes y limpieza registrados en la evidencia backend.

La revisión del árbol recibido cerró la expectativa de activación ante `40001`, completó la matriz de rutas/RPC/ACL/consumidores y corrigió el orden campaña → subcampaña de entrega, devolución y cancelación frente a desactivación masiva. Los fixtures incorporan FKs reales y seis carreras adicionales en ambos órdenes. Se preservan reposición/logística internas, historial y consumo del stock asignado sin otro débito de Vivero.

El [cierre con versiones, evidencia y límites](cierre-pa-t-int02-d.md) acredita el alcance local; el [encargo recibido](pa-t-int02-d-recepcion-2026-10-16.md) conserva los criterios y fuentes. La implementación parte de backend `a045d9d` más árbol local sin commit/push de D. Las migraciones 077–080 solo están ensayadas en clústeres sintéticos.

## Tareas para backend/DB

Las casillas acreditan exclusivamente el alcance técnico local enlazado; los cotejos/aplicación remotos y la habilitación real mantienen sus pendientes.

| Estado | ID de ejecución | Salida acreditada |
|---|---|---|
| [x] | PA-T-INT02-D-BE01 | Matriz ruta/objeto/audiencia/autoridad/RPC/cliente y alcance SQL local; catálogo/Storage destino pendientes explícitos. PA-T12-BE/REV, PA-T15 y PA-T-ENT02. |
| [x] | PA-T-INT02-D-BE02 | Identidad verificada, política por objeto y cierre local de rutas/RPC equivalentes; inventario reducido 080 autorizado, sin ampliaciones ni nuevos grants a servicio. PA-T12-BE, PA-T02-BE y PA-T-ENT04-BE/DB. |
| [x] | PA-T-INT02-D-BE03 | Locks compartidos, transacciones y rollback con plan, físicas y lifecycle; campaña precede a hija bajo FKs reales. PA-T04-DB, PA-T13-DB y PA-T16-QA parcial. |
| [x] | PA-T-INT02-D-BE04 | Inicial legada 409; reposición con autoridad interna y origen del mismo ámbito, sin efectos ante origen ajeno. PA-T02/04-BE/DB y PA-ID25/CR04. |
| [x] | PA-T-INT02-D-BE05 | Propiedad estricta de evidencia, originales privados y foto pública elegible sanitizada con objetos sintéticos. Compatibilidad interna entregada. PA-T04-BE, PA-T12-BE y PA-ID18/23/26. |
| [x] | PA-T-INT02-D-BE06 | Versionado/corte, pausa, recuperación y replay terminal preservados; inicial deshabilitada por omisión. PA-T12-BE, PA-ID24 e INT08 parcial. |
| [x] | PA-T-INT02-D-BE07 | Build, 64 suites/787 unitarios, 33 grupos SQL, 28 carreras, 25 HTTP, preflight adversario, preview y regresiones aisladas aprobados. PA-T16-QA, PA-T05-QA y PA-T-ENT06-QA parciales. |
| [x] | PA-T-INT02-D-BE08 | Informe, matriz de compatibilidad/DTO, OpenAPI, entorno INT04 y documentación canónica actualizados. INT08 parcial. |

## Entrega a INT04

[Informe backend](../../../../../Backend-r3foresta/docs/pa-int02d-entrega-local.md), [matriz y compatibilidad](../../../../../Backend-r3foresta/docs/pa-int02d-compatibilidad.md), [evidencia SQL/HTTP](../../../../../Backend-r3foresta/docs/evidencia/pa-int02d-local.json), [manifest](../../../../../Backend-r3foresta/docs/evidencia/pa-int02d-handoff.json) y [preview D](../../../../../Backend-r3foresta/docs/pa-int02d-preview.md).

**INT04 puede comenzar su integración local conforme al orden autorizado D → INT04.** Su [ficha](../implementacion/pa-t-int04.md) conserva FE01–FE08 pendientes; este cierre no implementa ni modifica la PWA. Inicial usa comando/cargas v1; upload/descarte de reposición interna requiere ámbito y `es_reposicion:true`. El launcher D en localhost:3303 reúne 077–080, PostGIS y objetos privados sintéticos.

## Límites y pendientes

Pablo confirmó 074–076 ejecutadas sin errores en desarrollo Supabase `vyrjlehkhabydkhjxagx`; su cotejo posterior sigue pendiente y no obliga a repetirlas. 077–080 no están aplicadas/cotejadas remotamente. Faltan catálogo/ACL/Storage/URLs/CDN y configuración PostgREST de destino, conciliación de fechas y manifest real revisado, corte/drenaje/habilitación reales, WebAuthn del nuevo recorrido, revisión humana de UX, QA integrado, publicación/despliegue y piloto. La garantía de locks es cooperativa entre RPC, con el límite privilegiado de `service_role` del contrato §8.3.

No se completan INT02, PA-S00/01/03, PA-T05-QA/PA-T16-QA/PA-T-ENT06-QA, INT08 ni PA-F01.
