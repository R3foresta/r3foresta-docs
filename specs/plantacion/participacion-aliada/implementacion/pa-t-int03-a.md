# PA-T-INT03-A — Registro participante recuperable en backend

**Fecha:** 15 de octubre de 2026. **Estado:** BE01–BE08 implementadas y verificadas en entorno local aislado; SQL remoto y habilitación real pendientes. **Responsable:** backend/DB, en `Backend-r3foresta`. **Incremento:** PA-F01. **Capacidad principal:** PA-S01; integra identidad/capacidades de PA-S00, permisos de PA-S03 y lectura propia mínima de PA-S02. [Tablero único](README.md).

**Evidencia de ejecución — 15 de octubre:** base backend `345d8f2` más árbol, migraciones nuevas 074–076, 22 grupos SQL/PostGIS, 10 carreras y 16 HTTP/Storage, build/unitarios y regresión B/C. [Entrega reproducible](../../../../../Backend-r3foresta/docs/pa-int03a-entrega-local.md) y [evidencia](../../../../../Backend-r3foresta/docs/evidencia/pa-int03a-local.json). Las casillas acreditan alcance técnico local con PostGIS/objetos de prueba; no SQL remoto, conciliación de entregas reales, push, despliegue ni cierre D/INT04/INT08.

**Publicación — 16 de octubre:** backend [`a045d9d`](https://github.com/R3foresta/Backend-r3foresta/commit/a045d9d7f5664007f0fbf9fcc8cf53bea226e7e4) publicado en `main`. La evidencia anterior identifica el árbol ensayado antes del commit; publicación Git no acredita SQL remoto ni despliegue.

## Encargo y resultado esperado

Implementar y verificar en el repositorio backend el registro inicial participante: contexto autorizado, participantes seleccionables, fotos privadas recuperables, guardado atómico con consumo LIFO/snapshots, recibo y detalle propio. Reutilizar el motor común que INT02-C adelantó y mantener operativas sus acciones de acceso/rol/baja. Entregar migraciones nuevas, pruebas reproducibles y contratos consumibles por INT04.

**Puede comenzar en entorno aislado mientras Pablo revisa visualmente INT06.** Esa revisión no cambia las reglas de registro ya aceptadas. Los permisos y fechas de entrega de personas/asignaciones reales conservan su revisión específica antes de una transición real. La habilitación del recorrido participante depende además del corte y las regresiones de INT02-D.

## Entradas y punto de partida

1. [PA-S01: spec](../01-registro-plantacion-inicial/spec.md), [plan](../01-registro-plantacion-inicial/plan.md) y [tareas](../01-registro-plantacion-inicial/tasks.md); [PA-S03: spec](../03-gestion-acceso-subcampania/spec.md) para autorización/retiro y [PA-S02: spec](../02-consulta-impacto-y-registros/spec.md) para proyecciones históricas/públicas.
2. [Contrato backend D01–D12 aceptado](../contrato-identidad-permisos-backend-propuesta.md): §2 convenciones v1; §4 autoridad/audiencias; §6.1 contexto, fecha y LIFO; §6.2 snapshots/detalle propio; §6.3 cargas; §7 comandos/retención; §8 locks/privilegios; §9 corte; §10 aceptación y §11 entregas. Esta ficha distribuye trabajo; los DTO y reglas permanecen en ese contrato.
3. [INT02-B](pa-t-int02-b.md) y [INT02-C](pa-t-int02-c.md), con sus [informes B](../../../../../Backend-r3foresta/docs/pa-int02b-entrega-local.md) y [C](../../../../../Backend-r3foresta/docs/pa-int02c-entrega-local.md). Backend observado: `e9777f8`; 068–073 existen en el repo y su aplicación en desarrollo está informada/verificada con los límites de esos informes. Comprobar HEAD, cambios locales y última migración antes de editar; no resetear ni sobrescribir esas migraciones.
4. [Contrato Vivero → Plantación](../../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md), §5.2, §6.2, §7 y §10; [reglas de Plantación](../../../../03-plantacion-module/01_reglas_de_negocio_plantacion.md), especialmente RN-PLA-32 y reglas de meta/estado; [inventario de rutas](../inventario-endpoints-y-regresion-participacion.md), como mapa fechado para contrastar con el código actual.

La base B permite ensayos sintéticos sin aplicar correspondencias reales. C implementó comandos **sin fotos**, recuperación y canonicalización: INT03-A extiende ese ciclo con PREPARADO/cargas/registro. Las pruebas de C usaron un antecedente sintético mínimo; no acreditan PostGIS, Storage, stock ni replay de todas las migraciones. Los cotejos remotos pendientes de B/C se conservan como tales.

## Tareas para backend/DB

Los IDs BE01–BE08 desglosan PA-T-INT03-A y mantienen la trazabilidad a las tareas originales. Marcar cada casilla con evidencia; completar una subtarea no completa PA-S01 ni su tarea padre.

| Estado | ID de ejecución | Trabajo | Tarea de capacidad | Depende de | Salida verificable |
|---|---|---|---|---|---|
| [x] | PA-T-INT03-A-BE01 | Cotejar código/catálogo y preparar fixture de dominio con PostGIS. | PA-T02/03-BE, PA-T04-DB; coordinación PA-T15 | Base B/C y fuentes anteriores. | Entorno/versiones, mapa de consumidores/dependencias y fixture representativo reproducible. |
| [x] | PA-T-INT03-A-BE02 | Implementar migraciones de cargas/generaciones, snapshots, revisión del registro y fecha operativa de entrega. | PA-T04-DB | BE01 y contrato §6–8. | DDL aditivo/idempotente, FKs RESTRICT, constraints/ACL/RLS verificados; legado sin historia inventada. |
| [x] | PA-T-INT03-A-BE03 | Implementar contexto v1 y participantes seleccionables. | PA-T02-BE / PA-T03-BE | BE01/02 y política B/C. | Lecturas JWT por ámbito ACTIVA, datos mínimos y saldo por especie; cero stock distinto de falta de permiso. |
| [x] | PA-T-INT03-A-BE04 | Implementar preparación, carga, recuperación, preview, descarte y limpieza durable. | PA-T04-BE/DB | BE02 y ciclo común C. | Cargas privadas por actor/comando, lease/generación y reconciliación DB/Storage; ninguna evidencia vinculada se elimina. |
| [x] | PA-T-INT03-A-BE05 | Implementar registro inicial atómico y extender canonicalización/recibo. | PA-T02/03-BE / PA-T04-BE/DB | BE02–BE04. | Una RPC confirma hecho, consumo LIFO, snapshots, vínculo y terminal, o rechaza sin efectos de dominio. |
| [x] | PA-T-INT03-A-BE06 | Integrar recuperación y detalle propio; asegurar acceso a imagen según audiencia. | PA-T04-BE; base de PA-T07-BE/DB | BE04/05. | Mismo recibo tras retiro; detalle propio limitado, originales privados y solo derivados vinculados/elegibles en lectura pública. |
| [x] | PA-T-INT03-A-BE07 | Verificar HTTP, PostgreSQL/PostGIS, Storage y concurrencia; regresión B/C. | Parte de PA-T05-QA / PA-T16-QA | BE01–BE06. | Matriz de aceptación con saldos/IDs/historial/recibos y órdenes de locks; límites de D explícitos. |
| [x] | PA-T-INT03-A-BE08 | Entregar contrato a INT04, actualizar documentación y registrar el cierre por capa. | Evidencia de PA-T02/03/04 y QA parcial | BE01–BE07 en el alcance acreditado. | OpenAPI/ejemplos/entorno, informe backend, fichas/tablero/ESTADO y pendientes enlazados. |

### BE01–BE02 — Base real y migraciones

Inventariar tablas/funciones/consumidores que se van a modificar: registro/detalles/coresponsables, asignaciones, plan/revisión, permisos, evidencia/Storage y comandos. Contrastar particularmente las RPC 060/061/062, recuperación/canonicalizador de C, guards y cliente privado. Reservar números de migración nuevos según el repo actual; ensayar instalación/repetición sobre la base declarada sin presentar un fixture parcial como replay 001–073.

Preparar `participacion_carga` y `participacion_carga_generacion` conforme a §6.3, snapshots y `revision_registro` conforme a §6.2. No reconstruir nombres/afiliaciones históricos a partir del perfil actual. Cerrar tablas/RPC nuevas a PUBLIC/anon/authenticated y comprobar todas las sobrecargas; servicio privado con actor revalidado. Preservar la limitación de `service_role` explicada en §8.3, sin prometer aislamiento que RLS no proporciona.

Añadir `fecha_entrega_operativa DATE` a la asignación según D07: para entregas nuevas procede de la fecha de entrada de la entrega física existente. Preparar conciliación explícita del legado con su fuente/zona y excepciones; conservar timestamp original. Un cast automático a La Paz no acredita el día histórico. Stock candidato sin día conciliado produce `CONTEXTO_INCOMPLETO`; no inventar fecha ni una nueva recepción. El ensayo sintético puede completar estas fechas sin declarar conciliados datos reales.

### BE03 — Contexto y personas elegibles

Implementar las dos lecturas de §6.1 con DTO/envelopes estrictos, BIGINT/revisiones como cadenas, JWT del actor activo y política efectiva del ámbito. ADMIN global puede operar sin fila contextual; VOLUNTARIO con permiso vigente puede operar sin ascenso de rol. Inicial requiere ACTIVA; pertenencia a organización, logística o historia no concede permiso.

El contexto devuelve plan/revisión, polígono, ventana operativa y saldo elegible por especie, sin lotes/viveros/asignaciones ni equipo interno. Saldo cero devuelve contexto válido con `SIN_STOCK`. Participantes seleccionables son cuentas activas habilitadas en ese ámbito o ADMIN globales activos, con nombre/afiliación mínimos y paginación; excluir actor y revalidar los elegidos al guardar. No seleccionarlos automáticamente ni multiplicar cantidades por persona.

### BE04 — Cargas y compensaciones de Storage

Implementar preparación, PUT por carga, listado recuperable, preview y descarte de §6.3 sobre `participacion_comando`. Usar bucket privado `participacion_evidencias`, hash de bytes del servidor, máximo diez cargas/10 MiB por archivo y exigir entre una y diez fotos al registrar. Decodificar realmente JPG/JPEG/PNG/WEBP/HEIC/HEIF y producir derivado sanitizado JPG/PNG. Verificar conversión y recursos reales; no declarar soporte por aceptar MIME/extensión. Preview propio firmado por cinco minutos; ni ADMIN accede a una carga ajena por su rol.

Reservar lease de dos minutos y generación durable antes del upload; liberar locks DB antes de llamar a Storage. Mismos bytes/identidad recuperan la misma evidencia; bytes distintos rechazan. Reconciliar objeto/hash cuando se pierda la respuesta de Storage o finalización DB. Una generación obsoleta o lease invalidado nunca finaliza como DISPONIBLE; conservar y barrer el ledger de compensación incluso si un upload atrasado reaparece después de un borrado.

Descarte/expiración de 30 días clausuran PREPARADO antes de limpiar; confirmación protege VINCULADAS. Al confirmar un registro, las cargas omitidas quedan DESCARTE_PENDIENTE con leases invalidados y generaciones obsoletas en el mismo commit. Cleanup fallido se reintenta sin deshacer el registro. Claves/recibos/tombstones no vencen ni se reciclan durante el piloto. Si se entrega reutilización entre preparaciones, aplicar transferencia todo-o-nada de §6.3; la alternativa inicial aceptada es conservar fotos locales y volver a cargarlas tras rechazo terminal con nueva confirmación. Documentar cuál consume INT04; timeout nunca autoriza una clave nueva.

### BE05 — Registro, LIFO y snapshots en una transacción

Implementar el POST de §6.1 sin campos libres de actor/rol/origen/lote/asignación ni `es_reposicion`. Extender el canonicalizador común para la intención de inicial y los estados preparados; preservar vectores/replay de C04–C09 y rol/baja. Revalidar bajo los locks de §8: cuentas/organizaciones, subcampaña, secuencia de código, comando, permisos, asignaciones, cargas/generaciones y evidencias. No envolver 061 sin adaptar su orden legado `rp_seq → subcampaña`.

En esa transacción comprobar ACTIVA, autoridad, plan/revisión, cantidades, fecha, participantes, fotos propias y geografía PostGIS real. Día operativo único en `America/La_Paz`, ventana inclusiva `[hoy-10,hoy]` y cota de las entregas efectivamente consumidas. Coordenadas manuales válidas y punto exterior son admitidos con evaluación; fallo confirmado del evaluador solo genera `EVALUADOR_NO_DISPONIBLE` durable si se revierte el dominio y se confirma su recibo. Un timeout/error desconocido conserva resultado inconcluso.

Repartir por especie entre asignaciones ACTIVA/PLANTACION_INICIAL de la misma subcampaña, con saldo elegible y `fecha_entrega_operativa <= fecha_plantacion`, ordenando **`fecha_asignacion DESC, id DESC`**. Los locks ASC no cambian el reparto. Meta total/por especie orientativa: se permite superarla dentro del stock, sin cierre automático. Incrementar consumo M3 y conservar detalles por asignación; no modificar `cantidad_asignada`, debitar saldo vivo de Vivero ni generar otro despacho.

Crear registro/detalles/coresponsables/snapshots, vincular evidencias y publicar recibo en el mismo commit. Confirmar exige original y derivado listos/verificables. El responsable procede de sesión. Afiliación opcional catálogo/Otra/ausencia no concede autoridad; congelar nombre/procedencia. Para fecha retroactiva usar declaración específica o historia acreditada, y en su ausencia `HISTORICA_NO_DISPONIBLE`; no copiar el perfil actual como historia. `afiliaciones_declaradas` participa en la huella sin modificar perfiles/permisos. Revisión inicial del hecho 0, independiente de plan y permiso.

### BE06 — Recuperación, detalle propio e imágenes

Integrar el GET común de C y replay terminal antes de exigir autorización de una nueva escritura. Misma clave/contenido recupera el recibo original; contenido distinto produce conflicto; rechazo terminal no cambia si luego se repone stock/permiso. PREPARADO/ausencia propia siguen 202/404 inconclusos de §7.3. La preparación tiene huella null: comprobar este caso al extender los helpers de replay de C, sin confundirlo con reutilización de clave ni alterar sus terminales. POST sobre una preparación ya cancelada conserva `409 PREPARACION_CANCELADA`, con huella null, sin convertirse en `COMANDO_REUTILIZADO` ni reabrirse.

Implementar `detalle-propio` de §6.2 por autoría/participación histórica, incluso tras retiro contextual, con cuenta activa. Observaciones solo para autor; sin stock, equipo, contactos ni contexto operativo. El recibo conserva lo confirmado entonces y el detalle su versión persistida, sin anticipar correcciones PA-S04.

Originales y pendientes quedan privados. Para las nuevas fotos, la lectura pública solo sirve derivado sanitizado vinculado a un registro elegible según PA-S02; implementar la frontera de imagen de §6.3 sin construir aquí las pantallas/agregados de INT05. Inventariar las rutas generales y URLs heredadas que puedan evitar esa clasificación; la comprobación/corte completo se acredita en D. Un derivado temporalmente indisponible después del commit no revierte stock ni habilita cleanup de la evidencia vinculada.

## BE07 — Verificación mínima para cerrar el alcance local

| Casos / trazabilidad | Evidencia requerida |
|---|---|
| PA-S01-CA01/02/04/12; PA-ID04/06/21 | JWT/roles/ámbitos, inicial solo ACTIVA, saldo cero válido, especies del plan, cantidades positivas y metas superables dentro del saldo. Fechas inclusivas, entrega conciliada, falta de conciliación y cambio de revisión sin ajustes silenciosos. |
| PA-S01-CA05; PA-ID21 | Dos comandos compiten por últimas unidades: solo consumos válidos. LIFO con timestamp e ID de desempate, entregas posteriores a la fecha excluidas y cero segundo débito M2; verificar saldos y detalles antes/después. |
| PA-S01-CA06; PA-S03-CA09/10; PA-ID11/13 | Barreras DB para ambos órdenes retiro/registro, participante retirado y cambio de rol/perfil durante captura de snapshots. Guardado/rechazo conforme al orden observado, no al tiempo del clic. |
| PA-S01-CA07/08/13; PA-ID14–17 | Doble POST simultáneo, pérdida de respuesta antes/después de commit, misma clave con otro contenido, rechazo tras efecto parcial y fallo inesperado/timeout. Un hecho/consumo/terminal; recuperar después de retiro sin otro efecto ni contexto privado. |
| PA-S01-CA09/10; PA-ID18–20 | Fotos ajenas/tipo/ámbito/vínculo inválidos; punto dentro/fuera y evaluador caído en PostGIS real. Upload/finalización/lease/cleanup con orden controlado, original privado, derivado sanitizado y ninguna foto vinculada borrada. |
| PA-S01-CA14; PA-ID22 | Nombre/afiliación congelados tras cambiar perfil/catálogo; catálogo/Otra/ausencia y retroactivo con/sin declaración. Cantidad del grupo contabilizada una vez. |
| PA-ID23 y regresión B/C | Denegaciones SQL/RPC reales de roles públicos, propiedad incluso ADMIN, caché privada y sin secretos en logs. C04–C09/rol/baja/capacidades conservan contrato y replay tras extender el motor. |

Usar PostgreSQL aislado con **PostGIS real**, HTTP sobre guards/services/RPC reales y Storage de prueba con objetos/decodificación verificables. Declarar qué fallos de red/Storage se inyectan; mocks unitarios no acreditan geografía, privacidad de objetos ni compensación durables. Si falta infraestructura para alguna prueba, conservar esa casilla/caso pendiente y continuar el trabajo independiente. No usar personas, stock ni buckets productivos como fixture.

Registrar revisión/entorno/fixture, comandos/resultados HTTP y SQL, IDs/revisiones, saldos, evidencia/recibo/historial y orden de locks/commit. Ejecutar build y checks pertinentes del repo, regresión de C y pruebas nuevas; no atribuir a esta entrega resultados previos ni afirmar replay completo de migraciones con un antecedente mínimo.

## BE08 — Entrega a frontend y actualización documental

- En backend, entregar informe `docs/pa-int03a-entrega-local.md` con versión, migraciones/orden, casos ejecutados, comandos reproducibles y límites. Actualizar OpenAPI/ejemplos y documentación de los módulos modificados, indicando cómo se extiende el motor de C; conservar referencias a sus pruebas/contratos existentes.
- Entregar a INT04 las rutas/DTO de §6, GET común, errores/recibos, carga/preview/descarte y estrategia de reutilización elegida. Incluir entorno reproducible y fixtures autorizados por perfil, sin tokens/secretos en docs. El launcher de C no contiene registro, Storage ni PostGIS: ampliarlo o entregar otro mecanismo documentado para este alcance.
- En este repo, actualizar casillas, PA-T02/03-BE/PA-T04-BE/DB y QA solo en su alcance probado, fila del [tablero](README.md) y [ESTADO.md](../../../../ESTADO.md). Añadir evidencia de código, pruebas, aplicación SQL, publicación Git y despliegue como hechos separados. Un informe histórico puede conservar su revisión original; el cierre nuevo debe identificar la versión realmente entregada.

**Cierre técnico local:** BE01–BE08 acreditados, migraciones/contratos instalables, registro y recuperación probados con geografía/objetos reales y sin regresión de gestión C. Una prueba faltante o una dependencia remota no comprobada se conserva explícitamente, sin completar su padre. La ejecución local se acredita arriba; no aplica SQL remoto ni habilita el recorrido real.

**Siguiente consumidor:** INT04 integra formulario participante; INT02-D completa locks/rutas equivalentes/plan/cierre/logística, integridad de reposición del mismo ámbito y corte de clientes/RPC antiguos. Si se toca código compartido de reposición en esta entrega, probar origen de la misma subcampaña y conservar su autoridad/stock propios (PA-ID25); permiso de inicial no concede reposición. Antes de habilitar participantes reales, D debe acreditar el corte sin fallback al equipo ni convivencia insegura con RPC antiguas, incluida `409 CLIENTE_INCOMPATIBLE`. Aplicación remota, transición real B, revisión humana INT06, Impacto/INT05, correcciones/INT07 y piloto/INT08 mantienen sus evidencias y tareas propias.
