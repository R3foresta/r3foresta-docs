# PA-T-INT02-A — Inicio de identidad, alta VOLUNTARIO y perfil seguro

**Fecha:** 13 de octubre de 2026. **Estado:** instrucciones para comenzar implementación en backend, solicitada por Pablo tras aceptar D01–D12. Este documento define el encargo del nuevo chat; no acredita código, migraciones aplicadas, pruebas ejecutadas ni despliegue.

## 1. Objetivo y repositorios

Implementar la primera entrega de identidad y perfil de Participación Aliada: identidad verificada desde JWT, alta siempre VOLUNTARIO, edición propia sin mutar autoridad y afiliación opcional del catálogo o «Otra». Mantener Impacto público sin autenticación y el contrato vigente del plan.

- Backend principal: `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta`.
- Documentación canónica: `/Users/pabloandresfernandezcari/Projects/R3foresta/r3foresta-docs`.
- Consumidores para contraste: `/Users/pabloandresfernandezcari/Projects/R3foresta/pwa-r3foresta`.

Trabajar en el proyecto backend local. Leer instrucciones aplicables y estado de Git antes de editar; conservar cambios de otros chats y no actualizar el frontend completo en esta entrega. Si hacen falta cambios mínimos del cliente para evitar una incompatibilidad, identificarlos y documentar la coordinación. No crear un worktree por defecto ni asumir el nombre/número de una migración libre. Verificar HEADs actuales: en el contraste documental se observaron backend `ae19480bac9ccb2015fe825cbbc8a720972074e9` y PWA `6520b6beb3096b83d27e461dd155fa5631195386`; son referencias históricas, no una orden de reset.

## 2. Fuentes que se deben leer

1. [Contrato backend aceptado](contrato-identidad-permisos-backend-propuesta.md): §2 tipos/API; §3 alta/perfil/roles; §4 audiencias/guard; §8 locks/grants; §9 transición; §10 aceptación; §11–13 entregas/decisiones/siguiente punto.
2. [Acta técnica del 13](revision-tecnica-2026-10-13.md): aceptación D01–D12 y ajustes D02/D07.
3. [Inventario de endpoints y regresión](inventario-endpoints-y-regresion-participacion.md): 121 rutas estáticas, consumidores, controles reales y limitaciones de las suites.
4. [Acuerdo de roles y permisos](acuerdo-roles-y-permisos-2026-10-12.md), [PA-S00](00-experiencia-participante/spec.md), [PA-S03](03-gestion-acceso-subcampania/spec.md), [instrucciones](instrucciones-implementacion.md) y [plan de integración](plan-reutilizacion-integracion.md).
5. [ADR-PLA-03/05](../../../decisiones/02_decisiones_plantacion.md), [ESTADO](../../../ESTADO.md), [esquema documentado](../../../database/00_database_schema.md) y [consulta de catálogo preparada](sql/inventario-contratos-solo-lectura.sql).

D01–D12 están aceptadas. No volver a pedir aprobación de esas decisiones. Cotejar catálogo y consumidores antes del SQL; si aparece una incompatibilidad material, describirla con evidencia y avanzar con las partes independientes. PA-S04 mantiene sus efectos específicos por revisar.

## 3. Reconocimiento y preparación

Contrastar primero `src/users`, `src/auth`, `src/organizaciones`, `src/supabase` y el guard/servicio de auth de `src/subcampanias`. Revisar creación de cuentas, WebAuthn, emisión/verificación del JWT, perfil legado, filtros del catálogo, adaptación BIGINT y lectura/escritura de autoridad. Usar el inventario para localizar aliases y accesos equivalentes.

Inventariar `usuario` y `organizacion`: tipos, nulabilidad, defaults, PK/FK/índices, unicidad de `auth_id`, rol, actividad/suspensión, longitudes de datos, afiliaciones legadas, grants/RLS y funciones/triggers consumidores. El esquema de Markdown y las migraciones locales no demuestran el catálogo desplegado. Identificar el entorno antes de conectarse; usar consultas de solo lectura con credenciales del servidor sin mostrarlas. Si falta un entorno identificado/acceso, preparar consultas, migraciones y fixtures sintéticos y continuar el código verificable localmente; registrar la comprobación pendiente.

Usar una base aislada para ensayos con escritura; ningún dato real sirve como fixture. Preparar migración nueva aditiva en backend, sin editar migraciones históricas ni aplicar SQL en producción desde este encargo. La entrega es implementación revisable y verificada localmente; publicación/aplicación remota se acreditan por separado.

## 4. Identidad JWT y frontera pública

- Generalizar el patrón del guard del plan: Bearer obligatorio en rutas privadas, HS256 explícito, secret obligatorio, firma/expiración verificadas, `sub` string no vacío y `exp` numérico válido.
- Resolver `sub` como `usuario.auth_id` único; `auth_id` no es `usuario.id`. Adjuntar actor verificado en request. Rol/actividad se consultan en DB; JWT prueba identidad, no facultades por sí solo.
- Si se conserva `x-auth-id` durante compatibilidad, solo puede coincidir con `sub`. Ausente es válido; discrepante o header sin JWT devuelve 401. `x-user-role`, `actor_id` y campos enviados por cliente no autorizan.
- Mantener claims del emisor actual; no exigir `iss/aud` nuevos que el login no emite. Reutilizar dependencias existentes sin duplicar un verificador inseguro.
- Perfil y selector de organizaciones son privados. Inventariar y proteger sus rutas equivalentes; aplicar el guard a los puntos de esta entrega y documentar lo que corresponde al corte completo INT02-D/D12.
- Impacto global/campaña/subcampaña/registro/mapas/filtros/fotos públicas elegibles continúa sin cuenta, login, token, perfil ni permiso. VOLUNTARIO sin asignación ve la misma proyección pública que visitante. Guard global, sesión vencida o fallo de capacidades no debe cerrar esas rutas.
- Conservar ceremonias públicas WebAuthn con validación propia. GET /plan sigue autenticado y legible por usuario existente; PUT /plan sigue solo ADMIN global. No convertir todo GET en público ni exigir sesión a todo el módulo Impacto.

La revisión de actividad y fuente de autoridad debe usar un único modelo cotejado. Si no existe equivalente, preparar `usuario.activo BOOLEAN NOT NULL DEFAULT true` y `revision_autoridad BIGINT NOT NULL DEFAULT 0` según contrato; no implementar todavía una operación de baja/roles provisional.

## 5. Alta de mínimo privilegio

Conservar ceremonia/credencial WebAuthn y su respuesta de autenticación. Toda vía de alta de cuenta escribe VOLUNTARIO explícitamente en servidor; default DB VOLUNTARIO como defensa adicional. No reclasificar usuarios existentes ADMIN/GENERAL/VALIDADOR ni perder su autoridad por actualizar perfil.

DTO de alta rechaza rol, actividad, actor, permisos y capacidades. No pedir wallet/documento de identidad ni afiliación para el piloto. Conservar identidad/nombre identificable, incluido nombre inicial desde username según contrato vigente. Ningún alta/selección de organización concede permiso contextual o acceso interno.

## 6. Perfil v1 y selector de organizaciones

Implementar los contratos exactos de §3.1; prefijo `/api/v1`, IDs BIGINT como cadenas decimales positivas y salidas estrictas sin conversiones que pierdan precisión:

- `GET /api/v1/usuarios/me/perfil`: usuario de sesión, sin ID ajena.
- `PATCH /api/v1/usuarios/me/perfil`: al menos un campo; `nombre?:string` NFC/trim 1..100, `apellido?:string|null` 1..30 (vacío → null), `afiliacion?:AfiliacionEntrada|null`. Omitir conserva; null elimina solo el opcional.
- `AfiliacionEntrada`: `{tipo:"ORGANIZACION_REGISTRADA",organizacion_id:Id}` o `{tipo:"OTRA",nombre:string}` NFC/trim 1..150. No campos combinados ni nombre de catálogo del cliente.
- `PerfilPropio`: campos required `{usuario_id,nombre,apellido,afiliacion,rol_global}`. Afiliación de salida `{tipo,organizacion_id:Id|null,nombre}` o null; catálogo usa nombre vigente completo, «Otra» tiene ID null. Rol es informativo, sin edición. No devolver contactos, wallet, documento o credenciales.
- `GET /api/v1/participacion/organizaciones-seleccionables`: cualquier cuenta activa, incluido VOLUNTARIO sin contexto; consulta opcional 2..100, cursor opaco máximo 1024, límite 1..20 default 20; respuesta mínima paginada con ID/nombre de organizaciones activas. Orden por nombre normalizado/ID. No exige ADMIN ni subcampaña y no reutiliza el directorio interno completo.

Persistencia: referencia opcional `usuario.organizacion_id` FK RESTRICT a `organizacion`; `usuario.organizacion` solo para texto «Otra»; CHECK que ID/texto no coexistan. Ambos null indican ausencia. Cambio de opción limpia la otra representación. Legado textual conserva «Otra» sin enlace automático por nombre ni truncamiento.

Validar la organización activa bajo lock compatible con §8 antes de seleccionar; ID inexistente/inactiva → `422 ORGANIZACION_NO_SELECCIONABLE`, sin cambios. Si una selección guardada se inactiva después, conservarla al editar otros campos; no habilitar reselección. Una organización renombrada cambia el nombre vigente de perfil, pero no snapshots de plantaciones anteriores. La captura de snapshots nuevos corresponde al registro INT03-A/D08.

Afiliación siempre opcional: organización registrada, «Otra» o ninguna. No crea catálogo maestro, verifica membresía formal, concede roles/permisos ni se infiere desde `CAMPANIA_ORGANIZACION`. El máximo 150 aplica a «Otra»; no truncar nombres registrados.

Adaptar `POST /api/users/register-form` y cualquier alias de perfil consumido: JWT verificado, actor propio, conservar rol/actividad/revisión; `rol` enviado → `422 CAMPO_NO_PERMITIDO`, sin fallback GENERAL. Revisar consumidores de la PWA para documentar compatibilidad y evitar una ruptura silenciosa. Mantener edición interna especializada de datos históricos con sus reglas propias.

Envelope de lectura `{data:T,observado_en:Instant}`; paginación añade `siguiente_cursor:string|null`. Rutas privadas `Cache-Control: private, no-store`, fuera de caché pública; sin datos personales en logs. DTO rechaza desconocidos; diferenciar 401 identidad, 403 autoridad/actividad y 422 entrada. Claves administrativas solo en servidor; no fallback a un cliente Supabase de privilegio desconocido. Verificar grants/RLS relevantes para que API/DB no permitan alterar autoridad directamente.

## 7. Límites de esta primera entrega y dependencias

Operaciones administrativas de cambio de rol/baja con motivo, revisión, recibo y protección del último ADMIN global están aceptadas en D03, pero su implementación se integra con el motor de comandos en INT02-C. INT02-A no crea una ruta de cambio de rol temporal sin esas garantías.

Permisos/vigencias/revisiones/manifest concreto siguen en INT02-B; comandos, cargas y registro en INT03-A; gestión contextual/roles en INT02-C; corte de rutas/locks y regresión completa en INT02-D. No habilitar el piloto por completar solo identidad/perfil. No implementar correcciones PA-S04, invitaciones, recepción de stock o UI completa de esta entrega.

Conservar el acuerdo D07 para futuras entregas: inicial por especie, LIFO en servidor `fecha_asignacion DESC, id DESC`, stock elegible ya disponible de la misma subcampaña, entrega conciliada no posterior a la fecha del trabajo y locks ASC independientes. No añade recepción por organización/administradores ni segundo débito de Vivero. El FIFO legado observado no acredita LIFO implementado. No cambiar consumo/plan/stock en INT02-A.

## 8. Verificación y criterios de cierre

Preparar pruebas significativas de contrato/HTTP y, para persistencia, PostgreSQL aislado con fixtures sintéticos. Reutilizar suites del plan cuando sirvan; sus mocks no acreditan DB/RLS y su fixture GPS no acredita PostGIS real. Verificar como mínimo:

1. Alta siempre VOLUNTARIO y autoridad manipulada rechazada; perfil de cada rol conserva rol/actividad/revisión (PA-ID01).
2. Token válido/ausente/vencido/firma o claims inválidos; header coincidente/omitido/ajeno y header solo; actor/rol ajenos rechazados (PA-ID03).
3. Afiliación catálogo/«Otra»/ausencia/omisión/null; límites, campos desconocidos, exclusión ID/texto, ID inactiva/inexistente, texto legado, catálogo renombrado/inactivado y conservación de historial existente (PA-ID27; parte aplicable D08).
4. Selector mínimo disponible para cuenta activa sin permiso, sin campos internos ni modificación del catálogo/permisos.
5. GET /plan autenticado y PUT solo ADMIN conservados. Impacto público responde sin token y con sesión vencida, mismo alcance para VOLUNTARIO sin asignación y enlaces directos (parte aplicable PA-ID05/26).
6. Migración/constraints/grants relevantes sobre copia aislada; ningún dato/rol existente truncado/reclasificado y ninguna escritura directa de autoridad abierta al cliente.
7. Typecheck/build/lint/suites requeridas por el repositorio, adecuados a cambios reales. Registrar comandos/resultados y las verificaciones remotas que siguen pendientes; no declarar prueba ejecutada por haber escrito el caso.

Entrega final: resumen de comportamiento, archivos/DTO/aliases tocados, migraciones nuevas sin aplicar remotamente, evidencia de pruebas, compatibilidad PWA y pendientes concretos. Actualizar documentación/ESTADO solo con evidencia diferenciada de código local, prueba aislada, aplicación remota y despliegue. Dejar cambios revisables; commits/push del backend se coordinan en el nuevo chat, sin inferir publicación por el push documental actual.
