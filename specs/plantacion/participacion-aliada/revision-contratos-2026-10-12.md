# Revisión de contratos: base de datos, backend y frontend

**Fecha:** 12 de octubre de 2026. **Alcance:** participación aliada, apartado 3 de [PA-F01](diseno-tecnico-compartido.md#3-contratos-que-deben-acordarse-entre-frontend-y-backend).

**Resultado:** existe una base reutilizable de registro inicial, contexto, evidencias, equipo, plan e impacto. El contrato vigente entre las aplicaciones corresponde al flujo interno anterior. No implementa todavía el permiso contextual, la consulta del mismo intento, la afiliación histórica ni las correcciones de PA-F01. Esta revisión documenta hechos y recomendaciones técnicas; no aprueba nuevas tablas, rutas o migraciones.

**Acuerdo posterior sobre H02/H07:** el usuario confirma [alta VOLUNTARIO, asignación administrativa de roles internos y permisos separados](acuerdo-roles-y-permisos-2026-10-12.md), con ADMIN global visible por autoridad derivada en miembros de todas las subcampañas. Se documenta primero; el código observado y sus diferencias siguen vigentes hasta implementar/verificar el cambio.

**Revisión técnica aceptada el 13 de octubre:** D01–D12 del [contrato backend](contrato-identidad-permisos-backend-propuesta.md) quedan aceptadas por Pablo, con ajustes D02/D07. El [acta del 13](revision-tecnica-2026-10-13.md) sustituye la orientación FIFO anterior para la nueva inicial por LIFO de servidor, exclusivamente sobre stock de esa subcampaña y sin recepción adicional. Se conservan aquí las observaciones/decisiones históricas de su fecha. Afiliación opcional mediante catálogo o «Otra», sin acceso automático. Esa versión concreta prevalece sobre los nombres/candidatos anteriores; la aceptación de diseño no marca implementación, migraciones o pruebas como completadas.

## 1. Evidencia y límites

| Repositorio | HEAD revisado | Estado al revisar |
|---|---|---|
| Backend-r3foresta | `ae19480bac9ccb2015fe825cbbc8a720972074e9` | Sin cambios locales reportados por Git. |
| pwa-r3foresta | `6520b6beb3096b83d27e461dd155fa5631195386` | Sin cambios locales reportados por Git. |
| r3foresta-docs | `6879ab8` | Cambios previos y trabajo documental concurrente; se conservan. |

Se contrastaron controladores, servicios, DTOs, tipos TypeScript, consumidor del formulario y migraciones locales. También se consultaron los chats existentes de ambos proyectos. Las migraciones indican el esquema esperado, pero su presencia en Git no prueba que estén aplicadas en una base determinada. No se consultaron filas de producción ni se ejecutaron migraciones. Las confirmaciones anteriores de aplicación de 062/063 siguen siendo antecedentes; no constituyen una nueva inspección del catálogo.

Para cerrar la comprobación del entorno se preparó [SQL de inventario de solo lectura](sql/inventario-contratos-solo-lectura.sql): columnas, enums, restricciones, índices, RLS y permisos de funciones. No incluye datos personales ni cambios de esquema. Debe conservarse la salida con identificación del entorno y fecha; no adjuntar credenciales.

## 2. Tipos persistidos que ya se reutilizan

Los siguientes tipos proceden del SQL local; la representación HTTP procede de los servicios actuales.

| Entidad / campos | PostgreSQL | HTTP / frontend | Regla o límite |
|---|---|---|---|
| `subcampania.id`, `campania_id`, `zona_id` y referencias de plantación | `BIGINT` | `number` | La aplicación convierte IDs con `Number()`. No hay garantía general para IDs superiores a `Number.MAX_SAFE_INTEGER`; acordar IDs seguros o migración consistente a cadenas, sin mezclar representaciones. |
| `subcampania.estado` | Enum `estado_subcampania` | Unión de cadenas | `BORRADOR`, `ACTIVA`, `COMPLETADA`, `FINALIZADA_PARCIAL`, `PAUSADA`, `CANCELADA`. La inicial exige ACTIVA; reposición tiene otras reglas. PAUSADA sigue reservada. |
| `subcampania.tipo` / `campania.tipo` | Enum `tipo_subcampania` | `TipoCampania` | `REFORESTACION`, `ARBORIZACION`, `FORESTACION`. Conservar herencia de campaña. |
| `subcampania.fase_mantenimiento` | Enum | Unión de cadenas | `NO_APLICA`, `MANTENIMIENTO_ACTIVO`, `MONITOREO_HISTORICO`. No es permiso del usuario. |
| `subcampania.poligono_geom` | `geometry(Polygon,4326)` | GeoJSON `Polygon`, posiciones `[longitud, latitud]` | Backend/PostGIS evalúa el punto; no invertir ejes. |
| `area_hectareas` | `NUMERIC(12,4)` | `number` | Dato derivado/presentado, no cantidad de plantas. |
| `meta_total_arboles`, contadores de subcampaña | `INT` | `number` | Meta positiva; `saldo_vivo_actual` es columna generada. No escribir el saldo desde frontend. |
| `subcampania.plan_revision` | `BIGINT NOT NULL DEFAULT 0` (062) | `number` | Control de concurrencia de PUT /plan; el DTO de registro actual no envía revisión esperada. |
| `subcampania_meta_especie` | IDs `BIGINT`, porcentaje `NUMERIC(5,2)`, cantidad `INT`, fechas `TIMESTAMPTZ` | Objetivos/porcentajes numéricos por especie | Único `(subcampania,planta)`; cantidades positivas y porcentaje > 0 hasta 100. La validación del conjunto ocurre en operación de plan/activación. |
| `subcampania_historial` | IDs/actor `BIGINT`, evento/estados enum, `TEXT`, `JSONB`, `TIMESTAMPTZ` | Historial por proyección | Append-only reutilizable; gestión actual de equipo no registra sus cambios mediante una transacción auditada. |
| `subcampania_equipo` | IDs `BIGINT`; `rol_en_subcampania`; `agregado_at TIMESTAMPTZ`; `agregado_by BIGINT` | `EquipoMember`, `COORDINADOR \| OPERARIO` | Único usuario por ámbito y como máximo un COORDINADOR por índice parcial. El índice no garantiza que siempre exista uno. No representa PLANTADOR/ADMINISTRADOR_SUBCAMPANIA. |
| `registro_plantacion.fecha_plantacion` | `DATE NOT NULL` | `string` | Frontend envía `YYYY-MM-DD`; DTO usa `IsDateString`, más amplio que fecha de calendario. Fijar formato exacto y zona de referencia. |
| `registro_plantacion.es_reposicion`, origen | `BOOLEAN`; origen `BIGINT NULL` | `boolean`; referencia numérica | Inicial sin origen; reposición con origen obligatorio. |
| Latitud / longitud del registro | `NUMERIC(9,6) NOT NULL` | `number` | Rangos −90..90 y −180..180. Persistencia redondea a seis decimales. |
| Resultado geográfico | `BOOLEAN NOT NULL`; distancia `NUMERIC(10,2) NULL` | `boolean`, `number \| null` | Exterior no bloquea; evaluador sin resultado sí aborta. |
| Cantidades del registro | `INT`; total inicial `> 0`; acumulados `>= 0` | `number` entero | Saldo generado = inicial + repuesto − muerto. Corrección a cero no puede implementarse escribiendo cero en el original. |
| Snapshots del registro | Nombres de subcampaña, zona y responsable `TEXT NULL` | No forman parte del comprobante actual completo | No hay afiliación histórica del responsable en 030. |
| `observaciones`, `codigo_trazabilidad`, `created_at`, `metadata_blockchain` | `TEXT NULL`, `TEXT NOT NULL UNIQUE`, `TIMESTAMPTZ`, `JSONB NULL` | Cadenas / objetos según proyección | DTO limita observaciones a 2000; el SQL base no tiene ese límite. Código único generado no equivale a clave de intento. |
| `registro_plantacion_detalle` | IDs `BIGINT`, cantidad `INT > 0`, snapshots de especie `TEXT NULL` | `{asignacion_id,lote_vivero_id,planta_id,cantidad}` | Único `(registro,asignacion,planta)`. Despacho M2 nullable/legado desde 051; plantar no crea otro despacho. |
| `registro_plantacion_coresponsable` | IDs `BIGINT`, `created_at TIMESTAMPTZ` | `coresponsable_ids: number[]` | Único `(registro,usuario)`; no conserva nombre/afiliación histórica en 030. |
| `asignacion_vivero_subcampania` | IDs `BIGINT`; cantidades `INT`; `fecha_asignacion TIMESTAMPTZ` | Stock y asignaciones numéricas en contexto | Saldo generado = asignada − consumida − devuelta − mermada. Plantación consume asignación física, no saldo M2 nuevamente. |
| Propósito / estado de asignación | Enums | Cadenas | `PLANTACION_INICIAL \| REPOSICION`; `ACTIVA \| AGOTADA \| DEVUELTA`. |
| Evidencia pendiente | Relación existente `evidencias_trazabilidad`; `entidad_id=0`, creador, tipo, ruta y metadatos | Upload devuelve `data[]` de evidencias y `evidencia_ids` arriba | El esquema base completo de evidencias/usuario no se crea en las migraciones M3 inspeccionadas. Confirmar tipos exactos en catálogo; no deducirlos de `any`. |

Fuentes: [024 asignaciones](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/024_vivero_asignacion_subcampania.sql:46), [027 enums](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/027_m3_postgis_y_enums.sql:25), [029 subcampaña/equipo](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/029_m3_subcampania.sql:12), [030 registro/detalles/participantes](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/030_m3_registro_plantacion.sql:18), [051 legado físico](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/051_m2_m3_asignacion_fisica_schema.sql:209), [062 revisión](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/062_subcampania_revision_plan_atomica.sql:6).

## 3. Contrato de registro vigente, campo por campo

Ruta actual: `POST /api/registros-plantacion`. El servidor obtiene el responsable mediante `x-auth-id`; no recibe `responsable_id` en el cuerpo. La validación global rechaza campos adicionales: añadir `intento_id`, `especies` o revisión solo en frontend no es compatible.

| Entrada | DTO backend | Frontend actual | Resultado de revisión |
|---|---|---|---|
| `subcampania_id` | Entero >= 1, convertido a número | `number` | Compatible para IDs seguros. |
| `es_reposicion` | Boolean opcional, false por defecto | Boolean opcional; pantalla envía false | Compatible para inicial. |
| `registro_plantacion_origen_id` | Entero >= 1 opcional, obligatorio para reposición por política/RPC | No existe en `CreateRegistroPlantacionInput` ni su normalizador | El cliente revisado es de inicial; no usarlo para reposición con `es_reposicion=true`. |
| `fecha_plantacion` | `IsDateString()`; RPC recibe DATE y verifica ventana operativa | Cadena de fecha | Formato/fecha límite necesitan contrato más preciso. |
| `latitud`, `longitud` | Número convertido; validación de rango | `number` | Compatible. Punto válido obligatorio, incluso captura manual. |
| `observaciones` | String opcional, máximo 2000 | Trim; omite vacío | Compatible en inicial. |
| `coresponsable_ids` | Array opcional de enteros; política/RPC deduplican y excluyen autor | Array deduplicado de enteros positivos | RPC comprueba equipo actual. No es lista histórica ni habilitación nueva. |
| `detalles` | Array >= 1; IDs y cantidad enteros >= 1 | Resolución FIFO en navegador, con asignación/lote/especie/cantidad | Compatible con contrato legado; difiere de CT04 propuesto, donde backend resuelve asignaciones a partir de cantidades por especie. |
| `evidencia_ids` | Array >= 1 de enteros | IDs del upload previo | Falta comprobar propiedad/tipo de evidencia dentro de RPC; ver H03. |
| Clave de intento / huella | Ausentes | Ausentes | No existe deduplicación durable de la operación. |

Respuesta actual: `{success:true,data:{message,registro_plantacion_id,codigo_trazabilidad,cantidad_total_plantada,gps_dentro_poligono,gps_distancia_a_poligono_m,consumos,coresponsable_ids_vinculados,evidencia_ids_vinculadas}}`.

Cada consumo incluye IDs de asignación/lote, cantidad consumida, saldo antes/después y `estado_final`. El backend convierte números antes de devolverlos. El tipo frontend marca varios resultados como opcionales aunque el servicio backend los entrega; no es validación de respuesta en ejecución. El servicio frontend exige básicamente la presencia del ID del registro.

Fuentes: [DTO registro](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/plantaciones/api/dto/registrar-plantacion.dto.ts:19), [DTO detalle](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/plantaciones/api/dto/detalle-plantacion.dto.ts:4), [respuesta backend](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/plantaciones/application/plantacion-creation.service.ts:112), [tipos frontend](/Users/pabloandresfernandezcari/Projects/R3foresta/pwa-r3foresta/src/modules/plantacion/types/contracts.ts:446), [normalizador](/Users/pabloandresfernandezcari/Projects/R3foresta/pwa-r3foresta/src/services/plantacion.service.ts:959), [validación global](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/main.ts:82).

## 4. Lecturas, evidencias, permisos y errores actuales

Todas las rutas siguientes tienen prefijo `/api`. No confundirlas con las rutas propuestas de `instrucciones-implementacion.md`.

| Ruta / contrato actual | Datos enviados / devueltos | Autorización y errores observados |
|---|---|---|
| `GET /subcampanias/:id/plantacion/context` | Devuelve `subcampania`, `usuario`, `equipo`, `plan_por_especie`, `stock_por_especie`, `reglas`. Incluye polígono, revisión, objetivos/avance, personas e IDs de lotes/asignaciones. | `x-auth-id`, global ADMIN/VALIDADOR/GENERAL y equipo COORDINADOR/OPERARIO, incluso ADMIN. 404 usuario/ámbito; 403 rol/equipo; 409 no ACTIVA; 422 falta plan/polígono/stock; 500 consulta operativa. No entregar como impacto público. |
| `POST /registros-plantacion/evidencias-pendientes` | Multipart `fotos` (1..10), título/descripcion/metadata/tomado_en/es_principal opcionales. Devuelve evidencias completas, URL pública e IDs top-level. | Rol global de escritura. El upload no recibe ámbito ni intento; no prueba permiso para una subcampaña. `es_principal` se persiste false. DB y Storage son operaciones separadas con limpieza compensatoria. |
| `DELETE /registros-plantacion/evidencias-pendientes` | `{evidencia_ids}` → IDs descartados/ignorados. | No elimina evidencias ya vinculadas; restringe creador salvo ADMIN global. Marca eliminación y luego intenta retirar archivo. Esta protección reduce el riesgo de borrar fotos de un registro ya confirmado, pero no resuelve incertidumbre del guardado. |
| `POST /registros-plantacion` | Contrato de §3 y comprobante mínimo | Header ausente 401, vacío 400; usuario inexistente 404; rol 403. El servicio transforma **todos** los errores de RPC en 400 con mensaje. Cambio de equipo, stock, fecha, estado o fallo PostGIS pierden categoría estable. |
| `GET /subcampanias/:id/equipo` | ID, usuario, rol, agregado_at, nombre y foto de perfil | Lectura revisada sin actor en servicio. No reutilizar como buscador público o participantes nuevos sin clasificar/proteger la ruta. |
| `POST /subcampanias/:id/equipo`, `DELETE /subcampanias/:id/equipo/:usuarioId` | Alta de miembros / retiro físico de fila | ADMIN global vía auth_id; catálogo COORDINADOR/OPERARIO. Alta duplicada/coordinador 422, referencia inválida 400. Retiro de coordinador en ACTIVA 422. No hay vigencia revocada ni permiso contextual nuevo. |
| `GET/PUT /subcampanias/:id/plan` | Meta, especies y revisión; PUT atómico con revisión esperada/motivo | Guard JWT verificado; lectura para usuario autenticado existente, escritura ADMIN. Conflicto de revisión 409. Este avance no protege automáticamente registro/evidencias/contexto. |
| `GET /v1/impact/organizations` y dashboard/campaigns/evidence/monitoring-timeline de organización | Proyección pública en camelCase: organización, métricas, campañas/subcampañas, especies, GPS y fotos | Sin sesión; `Cache-Control: public, max-age=60, stale-while-revalidate=300`. Existe impacto por organización; no equivale al global/Mis registros/lectura propia propuestos. |

Reglas actuales del contexto: 10 días retroactivos, exterior permitido, advertencia de precisión a 50 m, 1..10 fotos, meta por especie orientativa y FIFO por timestamp de asignación/ID. La fecha en SQL depende de `CURRENT_DATE`; el contexto no devuelve hoy/fecha mínima/fecha máxima/zona horaria. Acordar referencia temporal única evita diferencias cerca de medianoche.

El plan por especie devuelve también `porcentaje_objetivo`; el tipo `PlanEspecieContext` no lo declara. Es una omisión del tipo, no un dato inexistente. El contexto actual solo devuelve éxito si puede registrar; no entrega `puede_registrar:false` para los bloqueos, pese a que el tipo permitiría ese valor.

Fuentes: [contexto](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/subcampanias/application/subcampanias-plantacion-context.service.ts:103), [evidencias](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/plantaciones/application/plantacion-evidencias.service.ts:49), [equipo](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/subcampanias/application/subcampanias-equipo.service.ts:23), [guard plan](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/subcampanias/api/guards/subcampania-plan-auth.guard.ts:21), [impacto público](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/impact/impact.controller.ts:23), [reglas](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/subcampanias/domain/policies/reglas-plantacion.policy.ts:29), [cliente HTTP](/Users/pabloandresfernandezcari/Projects/R3foresta/pwa-r3foresta/src/api/plantacion.api.ts:22).

## 5. Hallazgos y cambios necesarios

| ID / prioridad | Hecho comprobado | Implicación / acción técnica propuesta |
|---|---|---|
| H01 · Alta | Registro/evidencias confían en `x-auth-id`; contexto también. El cliente envía Bearer si dispone de token, pero estas rutas no aplican el guard del plan. | La identidad declarada no acredita sesión. Extender identidad verificada y autorización a todos los caminos equivalentes; probar header ajeno, token ausente/vencido y acceso directo a RPC/Storage. No afirmar explotación en despliegue sin revisar sus barreras externas. |
| H02 · Alta | `assertCanWrite` rechaza VOLUNTARIO; contexto/RPC exigen equipo incluso para ADMIN. | Contradice el comportamiento aprobado: ADMIN directo en ACTIVA y otros con permiso contextual vigente. Fijar una fuente de autoridad, migración de consumidores y corte de compatibilidad; no dejar permiso nuevo OR equipo como alternativa permanente. |
| H03 · Alta | RPC 061 bloquea evidencias por ID y comprueba pendiente/no eliminada, pero no compara creador ni tipo de entidad. | Puede vincular una evidencia pendiente ajena o de otro módulo si llega su ID. Validar actor/tipo/ámbito de carga y estado bajo bloqueo transaccional antes de vincular; agregar prueba negativa. Servicio de upload anota el creador, pero creación de registro no lo comprueba. |
| H04 · Alta | No hay clave de operación, huella, recibo durable ni GET de intento en controller/DTO/RPC. UI hace upload → POST y trata cualquier excepción como fallo con cleanup. | Timeout después de commit no permite saber si se guardó. Reenviar bytes con las mismas fotos vinculadas puede fallar; reintentar desde UI sube fotos nuevas y puede crear otro registro. Implementar consulta/reenvío del mismo intento antes de habilitar recuperación de campo. |
| H05 · Media | Guardado convierte error RPC a 400/string; la pantalla muestra `message`. | El cliente no distingue revocación, stock cambiado, conflicto, validación y resultado desconocido. Acordar códigos estables y conservar estado HTTP; no analizar texto SQL para decidir recuperación. |
| H06 · Media | Contexto ordena por TIMESTAMPTZ, pero devuelve `fecha_asignacion` truncada a día. Servicio y resolutor frontend vuelven a ordenar por día/ID. | Puede variar el FIFO con datos legados/importados cuyo orden horario difiera del ID. Ejemplo: ID 20 a las 08:00 e ID 10 a las 12:00; backend prioriza 20, cliente 10. Los inserts habituales de RPC 060 reciben DATE y ambos órdenes coinciden. Conservar timestamp/`orden_consumo`, o resolver consumo en servidor como CT04. |
| H07 · Media | Perfil permite `rol` libre en DTO y servicio escribe `dto.rol`, con fallback GENERAL; alta actual asigna GENERAL. Documento de identidad requerido. | El perfil participante aprobado aún no existe. Separar actualización de perfil/autoridad; mínimo privilegio en servidor, sin documento/wallet obligatorios. No asignar nuevo rol automáticamente por completar datos. |
| H08 · Media | Registros/coresponsables de SQL 030 no guardan afiliación histórica. | `usuario.organizacion` actual no resuelve la afiliación al plantar. Acordar snapshot por persona/registro y diferencia entre no declarada e histórica no disponible, sin inferirla de organizaciones de campaña. |
| H09 · Media | PWA lista ACTIVA y filtra equipo en navegador; impacto existente se organiza por organización y su payload es cacheable. | Implementar lista autorizada/capacidades privada y alcance global público deduplicado. No sumar dashboards de organizaciones compartidas: contar un registro solo una vez. Lectura propia tras retiro requiere proyección separada. |
| H10 · Media | Tipos de respuesta frontend permisivos; parsing usa casts y acepta variantes de envelope. | Fijar required/nullable, enum y envelope por contrato; validar al menos respuestas críticas en ejecución. No tratar una respuesta incompleta como comprobante confirmado. |
| H11 · Alta | Lecturas generales de evidencias usan entidad/tipo sin actor en controlador; upload de plantación construye URL pública. | Revisar todos los accesos a fotos/metadatos y los permisos Storage/RLS. Una proyección reducida de Impacto no elimina rutas equivalentes ni vuelve privado un objeto con acceso público. La accesibilidad efectiva del despliegue sigue pendiente de comprobar. |

Evidencia adicional: [identidad de registro](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/plantaciones/api/plantaciones.controller.ts:44), [roles](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/plantaciones/application/plantacion-auth.service.ts:35), [equipo/evidencias en RPC](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/061_plantacion_meta_especie_orientativa.sql:184), [guardado UI](/Users/pabloandresfernandezcari/Projects/R3foresta/pwa-r3foresta/src/modules/plantacion/screens/RegistrarPlantacionScreen.tsx:337), [truncado de fecha](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/subcampanias/application/subcampanias-plantacion-context.service.ts:384), [reordenamiento cliente](/Users/pabloandresfernandezcari/Projects/R3foresta/pwa-r3foresta/src/services/plantacion.service.ts:767), [perfil](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/users/dto/register-form.dto.ts:19), [escritura de rol](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/users/users.service.ts:334).

Las consultas adicionales confirmaron H01–H05, la ausencia de intento recuperable y snapshots, y precisaron H06. Chats consultados: [Analizar Design System frontend](codex://threads/019ff168-814c-7e61-a10d-1a76e6f224b7) y [Implementar revisiones ADMIN atóm as](codex://threads/01a12271-cf17-7e10-960f-9d21ff057c90). El segundo se devolvió al archivo tras la consulta. Ninguno modificó las aplicaciones.

Fuentes adicionales: [plan e historial SQL](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/047_m3_cancelacion_subcampania_y_plan.sql:144), [fecha de insert habitual](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/060_vivero_asignacion_validar_plan_especie.sql:284), [lecturas generales de evidencia](/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/evidencias-trazabilidad/evidencias-trazabilidad.controller.ts:106). El servicio de Impacto limita porcentajes a 100 mediante `percentage()`; revisar cómo presentar excedentes cuando se implemente el contrato de PA-S02, sin confundir ese valor con cantidad física plantada.

## 6. Definición propuesta para consulta del mismo intento

Esta sección precisa el requisito; **no describe endpoints ni persistencia implementados**. Debe cerrarse junto con PA-DI06 y CT04/05 de [instrucciones](instrucciones-implementacion.md).

**Identidad/evidencias confirmadas después de esta revisión:** el usuario pide corregir la identidad al registrar y confirma que una evidencia pendiente debe pertenecer al actor. H01 se refiere a guardar y a subir/descartar fotos pendientes, no exclusivamente a visualizarlas. H03 exige verificar autor autenticado, tipo y estado al vincular dentro de la transacción; no introducir una excepción de propiedad por ADMIN global. Las lecturas públicas de fotos conservan la audiencia de PA-S02 y los pendientes requieren revisar API/Storage. Código aún sin cambios.

### Opciones de persistencia del intento para revisar

| Opción | Ventaja | Límite / alcance |
|---|---|---|
| Clave/huella en `registro_plantacion` | Cambio inicial más pequeño; permite encontrar un éxito y evitar dos registros para la misma clave. | No representa por sí sola rechazos durables ni ciclo de cargas/resultado aún no confirmado. Requiere más infraestructura para cumplir CT05 completo; insuficiente como única solución del contrato acordado. |
| Tabla dedicada de intento de plantación | Recibo/rechazo/clave/huella por actor para registro, con consulta y manejo de cargas; alcance acotado. | Acceso y correcciones necesitarían mecanismos equivalentes o posterior generalización. Nombre `plantacion_intento` sigue candidato. |
| Registro común de comandos | Misma garantía de clave/huella/recibo para plantación, permisos y correcciones, con autorización específica por operación. | Mayor definición inicial; no fusionar políticas de negocio ni almacenar fotos/perfiles completos. `participacion_comando` es candidato de las instrucciones, no tabla aprobada. |

**Elección confirmada el 12 de octubre:** el usuario elige la tercera opción, registro común de comandos, con primer recorrido de plantación. PA-S03 y PA-S04 ya necesitan recuperación todo-o-nada y repetir un resultado sin otro efecto. Ver [explicación y flujo paso a paso](diseno-comandos-compartidos.md). Se cierra la elección del enfoque; nombre/esquema/rutas definitivos, bloqueos, recuperación de cargas, retención y pruebas siguen por concretar. No acredita implementación. Las alternativas anteriores se conservan como comparación.

Ejemplo de comportamiento esperado: se envían 30 plantas con clave A; la base confirma y se pierde la respuesta. Consulta A devuelve el registro original y no consume otras 30. Si A se reenvía con 35, hay conflicto sin efecto. Un trabajo nuevo usa otra clave; si hay resultado incierto, no crear una nueva para repetirlo. Cargas de foto también necesitan referencia recuperable, no repetir uploads ciegamente.

### Garantías comunes

1. Frontend crea una clave estable antes del primer envío y la conserva por cuenta/operación. Fotos ya subidas, su recuperación y limpieza deben quedar vinculadas a ese intento. Reabrir la pantalla no genera otra clave si el resultado sigue desconocido.
2. Backend identifica al actor por sesión verificada. Unicidad `(actor,operacion,clave)` y huella canónica del contenido; mismo contenido vuelve al mismo resultado, contenido distinto devuelve conflicto sin otro consumo.
3. Registro, detalles, consumo, participantes, vínculo de fotos y resultado durable confirman en una transacción. La gestión de binarios en Storage requiere compensación/retención; no fingir transacción distribuida con el upload HTTP.
4. Consulta privada por actor original y clave/operación devuelve confirmado, rechazado sin efecto de forma durable o estado todavía no concluyente. Ausencia/404/en curso no habilitan automáticamente una operación distinta.
5. Si perdió respuesta, cliente consulta y, cuando corresponda, reenvía **la misma clave/contenido**. Conserva formulario y fotos mientras el resultado sea incierto. No ejecuta cleanup por un timeout como si probara rechazo.
6. Confirmado devuelve el ID/comprobante original incluso tras revocación del permiso, sin devolver contexto/stock/equipo. Esa lectura no habilita otra escritura. Revalidación de permiso para un intento aún no confirmado ocurre en transacción.
7. Retención, clave vencida, persistencia local privada y qué pasa al cambiar cuenta deben acordarse. No eliminar una clave y admitir su reuso silencioso.

Envelope candidato de las instrucciones: `{comando_id,operacion,estado,resultado?,error?}`. Acordar un nombre único entre `intento_id` de entrada y `comando_id` de consulta/recibo; no dejar que cliente tenga que adivinar la relación. Error estable con código y campos permitidos; 401 sesión, 403 permiso, 404 inexistente/no visible, 409 conflicto, 422 validación. Un fallo de evaluación geográfica confirmado sin efecto puede usar 503/código específico; la desconexión del cliente continúa siendo resultado desconocido hasta conciliar.

## 7. Qué puede quedar definido y qué sigue pendiente

| Contrato PA-F01 §3 | Base actual | Pendiente técnico concreto |
|---|---|---|
| Identidad/capacidades | JWT del plan y usuario actual reutilizables | Actor verificado común, capacidades/contextos privados, perfil sin elevación y compatibilidad interna. |
| Impacto público reducido | Servicio/proyecciones de impacto por organización | Alcance global deduplicado, filtros/mapa coherentes, detalle progresivo y privacidad de Storage/fotos. PWA revisada no consume aún `/v1/impact`. |
| Dónde puedo plantar | Lista ACTIVA + equipo filtrado en cliente | Lista filtrada en servidor; distinguir permiso vigente de falta de stock. |
| Contexto del registro | Plan/revisión/stock/reglas/equipo existentes | Objetivo actualizado por D07: LIFO/fecha sin pérdida en servidor, participantes mínimos, límites temporales/zona, nuevo permiso y autorización ADMIN. Evidencia FIFO del código existente conservada. |
| Otorgar/retirar acceso | Gestión de equipo antigua | Permiso contextual separado de logística, auditoría/vigencia, transacción masiva, revisión y último administrador. |
| Guardar/recuperar intento | RPC transaccional de hechos físicos | Clave/huella/resultado durable, consulta propia, propiedad de fotos, conflictos y recuperación. |
| Detalle persistido / Mis registros | ID/comprobante de POST e impacto público | Lectura propia por autoría/participación histórica tras retiro; afiliación conservada y proyección efectiva. |
| Corrección acotada | Originales, detalles y contadores existentes | Contratos específicos/revisión/historial/compensación de PA-S04; no editor universal ni reescritura de hechos originales. |

La revisión estática del código y las consultas a los dos chats están completadas. El contrato nuevo solo se cierra al acordar DTO/envelope/errores, identidad/permisos, fecha/zona, intento/retención, snapshots y transición; luego se implementa y prueba en ambos repositorios. La inspección del catálogo destino permanece separada y pendiente.

Pruebas necesarias para implementación: doble envío concurrente y timeout antes/después de commit; clave con contenido diferente; foto ajena/de otro módulo; retiro frente a guardado; stock simultáneo; ADMIN sin equipo y VOLUNTARIO con permiso; orden LIFO aceptado para inicial con timestamp/ID del mismo día y regresión del reparto legado; lectura propia tras retiro; global con campañas asociadas a varias organizaciones; token/header incompatibles y regresión del plan interno. Revisar SQL/RLS/grants/Storage del entorno además de tests con mocks.
