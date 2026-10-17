# Cierre técnico local de PA-T-INT02-D

**Actualización del 17 de octubre:** código versionado en commit local backend `75a57eb05e57b3048908cccc04aa14fc24ae8629`, verificado sin hallazgos bloqueantes; push pendiente. [INT04 cerrada después de D](cierre-pa-t-int04.md). Se conserva a continuación el corte del 16 previo a los commits; su mención de INT04 sin implementar es histórica. [Encargo completado](pa-t-int02-d.md) y [siguiente entrega INT05](../implementacion/pa-t-int05.md).

**Registro:** 16 de octubre de 2026. **Estado:** BE01–BE08 completadas exclusivamente para el alcance técnico local. **Base backend:** `a045d9d7f5664007f0fbf9fcc8cf53bea226e7e4` más árbol de D, sin commit/push ni despliegue de esta entrega.

Verificación final aprobada el 16 de octubre sobre PostgreSQL/PostGIS aislado y objetos sintéticos; hashes y limpieza registrados en la evidencia backend.

La recepción cerró la discrepancia `40001`: activación devuelve 503 `RESULTADO_NO_DETERMINADO`, `resultado_concluyente:false`, sin fabricar éxito ni recibo terminal. Se completó la matriz de rutas/objetos/audiencias/autoridad/RPC/consumidores. La auditoría detectó y corrigió en 077 la inversión que producían las FKs de campaña frente a desactivación: entrega, devolución y cancelación adquieren campaña antes de hija; seis carreras adicionales verifican ambos órdenes y rollback sobre FKs reales.

| Capa | Evidencia y límite |
|---|---|
| Código y SQL local | 077–080: físicas/plan/reposición, lifecycle transaccional, evidencia privada/foto sanitizada y superficie reducida autorizada. 080 limita su inventario a diez tablas, una vista y cuatro catálogos; aborta ante exposición adicional sin ampliarlo, sin RLS masivo ni nuevos grants a `service_role`. |
| Build / unitarios | Build aprobado; 64 suites / 787 pruebas aprobadas. Activación, cierre, equipo y lifecycle: 4 suites / 33 pruebas. |
| SQL/PostGIS / carreras | 33 grupos (11 D + 22 registro) y 28 carreras (18 D + 10 registro), con locks observados, saldos/conteos/estado/auditoría y rollback. PostgreSQL 14.24 / PostGIS 3.2.10; fixture sintético post-076, sin acreditar replay completo del esquema. |
| HTTP / objetos | 25 pruebas (9 D + 16 registro) con guards/services/RPC y objetos privados sintéticos; regresión de acceso C sobre D. Las trece entradas adicionales usan servicios externos simulados y no prueban acciones reales de Pinata/blockchain. |
| Preflight / timeouts / preview | Siete escenarios adversarios; locks ~5 s y sentencia ~30 s medidos con rollback. Preview D con 080: cinco grupos aprobados, incluidos pausa/recuperación y HEIC. Clústeres/objetos sintéticos eliminados al terminar. Configuración PostgREST y Storage remotos pendientes. |
| Basales B/C | Ambos runners exit 0, conservando evidencia histórica de sus bases; no equivalen a todas las pruebas de B/C bajo D. La regresión C bajo D se acredita en el runner compartido. |
| Aplicación remota / Git / despliegue | 077–080 solo locales. Este cierre no ejecuta SQL remoto, push, despliegue ni piloto. |

Fuentes: [informe backend y reproducción](../../../../../Backend-r3foresta/docs/pa-int02d-entrega-local.md), [matriz de compatibilidad](../../../../../Backend-r3foresta/docs/pa-int02d-compatibilidad.md), [SQL/HTTP y carreras](../../../../../Backend-r3foresta/docs/evidencia/pa-int02d-local.json), [manifest](../../../../../Backend-r3foresta/docs/evidencia/pa-int02d-handoff.json), [preview](../../../../../Backend-r3foresta/docs/pa-int02d-preview.md), [basales B/C](../../../../../Backend-r3foresta/docs/evidencia/pa-int02d-regresiones-basales.json), [ficha completada](../implementacion/pa-t-int02-d.md) y [recepción histórica](pa-t-int02-d-recepcion-2026-10-16.md).

El backend entrega OpenAPI/ejemplos, DTO/adaptadores internos y entorno aislado para [INT04](../implementacion/pa-t-int04.md). **Se cumple el orden autorizado INT02-D → INT04 para comenzar integración local; INT04 sigue sin implementar.** Nuevos POST de inicial permanecen pausados por omisión hasta el corte real; GET/cargas y replay terminal se conservan.

Pablo confirmó el 16 de octubre 074–076 ejecutadas sin errores en desarrollo `vyrjlehkhabydkhjxagx`; no repetirlas por falta de cotejo posterior. Faltan cotejo remoto de cuerpos/ACL/Storage/URLs/CDN y configuración PostgREST, aplicación/cotejo 077–080, manifest real/fechas, corte/drenaje/habilitación de escritura, revisión humana de INT06, WebAuthn, QA completo de INT04/05/07/08, publicación/despliegue y piloto. La garantía de locks sigue siendo cooperativa entre RPC y no cubre SQL privilegiado que omita §8.3.

INT02, PA-S00/01/03, las tareas padre de QA e integración y PA-F01 permanecen abiertos. El [tablero](../implementacion/README.md) registra la continuación.
