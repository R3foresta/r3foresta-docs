# PA-T-INT02-B — Permisos, revisiones y transición

**Estado al 14 de octubre de 2026:** base técnica local implementada y ensayada; cierre parcial. 068–071 confirmadas sin errores en desarrollo; REST y estado SQL compacto cotejados. Inventario complementario y manifest real revisado pendientes; base lista para iniciar INT03-A. [Evidencia backend](../../../../../Backend-r3foresta/docs/pa-int02b-entrega-local.md). **Responsable de ejecución:** backend, en `Backend-r3foresta`. **Padre:** PA-T-INT02, dentro de [PA-F01](../README.md). **Capacidad principal:** [PA-S03 · Gestión de acceso](../03-gestion-acceso-subcampania/spec.md). **Consumidores:** PA-S00 y PA-S01.

**Aplicación y cotejo posterior — 14 de octubre:** Pablo confirma 068–071 sin errores en desarrollo `vyrjlehkhabydkhjxagx`. Aprobados 18 probes REST y salida SQL READ ONLY en PostgreSQL 17.6: 41 restricciones validadas, 17 FKs nuevas RESTRICT, 12 combinaciones de privilegios esperadas, tres RLS nuevas, marca y seis cuerpos de función coincidentes con código local. Foto posterior 40 usuarios (5/32/3 activos), 44 equipo, 9 hechos y 73 eventos; no acredita conservación antes/después sin preflight previo. Catálogo complementario y transición real pendientes; base disponible para iniciar INT03-A. [Informe y evidencia](../../../../../Backend-r3foresta/docs/pa-int02b-entrega-local.md). El preflight previo no se recibió en este chat. Backend desplegado, correspondencias reales revisadas y transición de personas siguen pendientes; no completar tareas padre ni piloto.

## Resultado esperado

Preparar y verificar la persistencia de permisos por persona/subcampaña, con vigencias, revisión estable e historial, y ensayar la transición de usuarios existentes. Entregar migraciones aditivas revisables, una propuesta explícita de correspondencia de personas/ámbitos y pruebas aisladas. Preservar roles, equipo, perfiles e historia existentes.

Esta es la base de acceso de PA-S03; la afiliación a una organización no otorga autoridad. La gestión HTTP de permisos/roles tiene su [encargo backend en INT02-C](pa-t-int02-c.md); el registro participante recuperable empieza en INT03-A. La [interfaz de gestión tiene su encargo frontend en INT06](pa-t-int06.md). Organizar estas tareas no aplica SQL ni asigna permisos reales.

## Orden por equipo

| Paso | Responsable | Resultado que recibe el siguiente |
|---|---|---|
| INT02-B, esta ficha | Backend/DB | Esquema, privilegios, fixtures y ensayo de transición; dependencias de comandos resueltas. |
| INT03-A | Backend/DB | Motor común probado con registro inicial como primer consumidor; recibos y recuperación. |
| [INT02-C](pa-t-int02-c.md) | Backend/DB | Capacidades, miembros, búsqueda/revisión y comandos de gestión verificados por HTTP y DB. |
| INT02-D | Backend/DB + QA | Autorización por objeto, rutas equivalentes y orden de locks compartido comprobados. |
| [INT06](pa-t-int06.md) | Frontend, en `pwa-r3foresta` | Gestión contextual conectada a esas APIs; QA navegador → API → DB. |

Frontend puede preparar el boceto PA-T13-UX con ejemplos del contrato. La integración de capacidades de entrada continúa en PA-T-ENT05-FE/INT04; la gestión de accesos se integra en INT06 después del backend. La existencia de las tablas de B no ofrece aún una API que la PWA pueda consumir.

## Entradas mínimas

- [Cierre de INT02-A](../archivo/cierre-pa-t-int02-a.md): backend `57e5b71`, PWA `cf13036` y 064–067 confirmadas en desarrollo. Comprobar el estado actual de los repositorios antes de editar; esas revisiones son evidencia, no una orden de reset.
- [Contrato D01–D12 aceptado](../contrato-identidad-permisos-backend-propuesta.md), especialmente §5.1, §7.1, §8, §9, §10 y §11. D04 acepta vigencias/revisión estable e historial; D03/D05/D06 definen autoridad y continuidad. No se repite su aprobación.
- [PA-S03: tareas](../03-gestion-acceso-subcampania/tasks.md) PA-T12-DB, PA-T12-REV/PA-T15 y preparación de PA-T13-DB; [PA-S00](../00-experiencia-participante/tasks.md) ENT02/ENT04-DB.
- [Inventario estático](../inventario-endpoints-y-regresion-participacion.md) y [consulta preparada](../sql/inventario-contratos-solo-lectura.sql). El cotejo realizado para identidad no acredita el catálogo contextual completo.

## Tareas para backend/DB

Los sufijos BE01–BE07 desglosan esta entrega; conservan las tareas de capacidad indicadas. Marcar cada casilla solo con su evidencia, sin completar automáticamente la tarea padre.

| Estado | ID de ejecución | Trabajo | Tarea de capacidad | Depende de | Salida verificable |
|---|---|---|---|---|---|
| [ ] | PA-T-INT02-B-BE01 | Cotejar catálogo, revisiones y consumidores actuales. | PA-T12-REV / PA-T15 / PA-T-ENT02 | Cierre de INT02-A. | Inventario de solo lectura con entorno/fecha, versiones, diferencias y consumidores por facultad. |
| [x] | PA-T-INT02-B-BE02 | Resolver el DDL compartido y las FKs a comandos. | Preparación de PA-T12-DB / PA-T13-DB | BE01 y contrato §7.1. | Orden de migraciones ejecutable con FKs válidas, coordinado con INT03-A. |
| [x] | PA-T-INT02-B-BE03 | Implementar esquema de vigencias, revisiones, historial e inicialización. | PA-T12-DB; parte de PA-T-ENT04-DB | BE02. | Migración aditiva/idempotente y pruebas de restricciones; conserva datos legados. |
| [x] | PA-T-INT02-B-BE04 | Cerrar privilegios de tablas y funciones nuevas. | PA-T12-DB; parte de PA-T-ENT04-DB | BE03 y contrato §8.3. | ACL/RLS efectivos comprobados; anon/authenticated/PUBLIC no operan sobre la base privada. |
| [ ] | PA-T-INT02-B-BE05 | Preparar correspondencia y excepciones de personas/ámbitos. | PA-T12-REV / PA-T15 / PA-T-ENT02 | BE01. | Manifest versionado y revisable; decisión de Pablo registrada por correspondencia antes de aplicación real. |
| [x] | PA-T-INT02-B-BE06 | Implementar y ensayar inicialización/transición controlada. | PA-T12-DB; preparación de PA-T13-DB | BE03/04 y manifest sintético de BE05. | Ensayo PostgreSQL aislado reproducible, auditoría y reconciliación antes/después; repetición sin duplicados. |
| [x] | PA-T-INT02-B-BE07 | Entregar base técnica y registrar límites del cierre. | Evidencia de las tareas anteriores | BE01–BE06 en el alcance acreditado. | Informe con versiones, comandos, resultados y pendientes para INT03-A/C/D; tablero y tareas actualizados. |

### Evidencia de ejecución local — 14 de octubre

Las casillas BE02/03/04/06/07 acreditan código y pruebas **locales aisladas** en el alcance del [informe backend](../../../../../Backend-r3foresta/docs/pa-int02b-entrega-local.md). Orden confirmado: 068 DDL común → 069 eventos ENUM (COMMIT separado) → 070 permisos/revisiones/historial/marca/ACL → 071 bootstrap privado. Instalarlas no asigna permisos. Build y 54 suites/594 pruebas aprobados; PostgreSQL 14.17, 53 casos y 78 denegaciones SQL reales. Roles, equipo, perfiles, hechos e historia previos conservados.

BE01 sigue pendiente en su catálogo actual remoto: scripts de preflight/estado de solo lectura preparados y ensayados; Pablo confirma desarrollo `vyrjlehkhabydkhjxagx`, con REST y estado SQL compacto posterior cotejados; inventario complementario y foto previa no acreditados. BE05 prepara export versionado con decisiones PENDIENTE y excepciones, sin correspondencias reales revisadas ni transición aplicada. Los fixtures no aprueban personas reales. Antes de 070, disponer del backend consumidor con cliente privado para escrituras de subcampañas/historial; la publicación/despliegue no se acredita por el build local.

068–071 en Supabase confirmadas por Pablo y cotejadas por SQL compacto/REST; Backend B/C publicado en `main` con `e9777f8` el 15 de octubre; despliegue externo **no acreditado**. Continuidad concurrente del último administrador, baja y carreras siguen en C/D; motor/HTTP en INT03-A/C. Este cierre parcial no completa tareas padre ni habilita registro participante/piloto.

### BE01 — Cotejo del estado actual

Identificar checkout, HEAD, cambios locales, última migración y entorno consultado. Usar el inventario estático como mapa, contrastándolo con `usuario`, `subcampania`, equipo e historial actuales: tipos, FKs, enums, índices, grants/RLS y consumidores de registro, activación, plan, entregas/devoluciones y mantenimiento. Ampliar la consulta de catálogo a las estructuras de §5.1/§7.1 si aún no están en su lista de relaciones; esa consulta no genera por sí sola el manifest de personas. Conservar resultados sin credenciales y registrar cualquier incompatibilidad material con el contrato.

### BE02–BE04 — Migraciones y frontera privada

- Resolver primero la referencia a `participacion_comando`: reutilizar una estructura compatible si existe o preparar su DDL compartido conforme a §7.1 antes de las FKs de acceso. Registrar qué migración lo crea y cuál lo consume. El motor/ejecución/recuperación sigue en INT03-A; su primera operación de dominio es el registro inicial. No quitar FKs, dejar referencias sin validar ni crear un comando provisional para salvar el orden.
- Implementar las cuatro estructuras de §5.1 con numeración nueva reservada al comprobar el repo. Probar PK/FKs RESTRICT, un solo permiso vigente por persona/ámbito, catálogo cerrado, retiro consistente, revisión estable y marca de inicialización. Retiro conserva historia/revisión; rehabilitación crea nueva vigencia; administrador incluye plantar. ADMIN global no genera filas contextuales por su acceso derivado.
- Reutilizar `subcampania_historial`, vinculando los cambios al comando y preservando eventos anteriores. Verificar restricciones de eventos y antes/después. Preparar protección de historial y privilegios según §8.3; comprobar también todas las sobrecargas de las funciones nuevas. La revisión del resto de rutas/RPC compartidas continúa en D.

### BE05–BE06 — Correspondencia y ensayo

Preparar `{usuario_id, subcampania_id, permiso_propuesto, justificacion, fuente_legada, decision_revisor}` conforme a §9. Separar decisiones pendientes y excepciones; GENERAL, COORDINADOR, organización o participación histórica no se convierten automáticamente en permiso contextual. Pablo revisa las personas/ámbitos reales antes de aplicar la transición. Los fixtures sintéticos permiten avanzar el ensayo sin presentar esa revisión como realizada.

El bootstrap de ámbitos legados cerrados es una inicialización acotada, auditable y ejecutable una vez sobre los IDs revisados. No habilita designación ordinaria en cerradas ni nuevas altas de plantadores allí. Preparar el procedimiento de reconciliación y repetición segura sin borrar historia ni reactivar permisos retirados. El ensayo debe comprobar:

| Caso en PostgreSQL aislado | Evidencia requerida |
|---|---|
| Instalación sobre base previa y segunda ejecución | Esquema esperado sin duplicar datos ni modificar roles/equipo/hechos existentes. |
| Duplicado vigente, rol no admitido, FK inválida o retiro incompleto | Rechazo por restricción, sin estado parcial. |
| Retiro y nueva vigencia sintéticos | Historia conservada y revisión creciente; ausencia previa se representa como 0 sin escritura por lectura. |
| Ámbito no inicializado, un administrador y dos administradores | Se distingue cuenta activa + permiso administrador vigente de ADMIN global y COORDINADOR; el ensayo no acredita aún la protección concurrente de C/D. |
| Bootstrap de legado cerrado y repetición | Solo correspondencias admitidas, un registro auditable de inicialización y ninguna ampliación en la repetición. |
| Manifest inconsistente o destino inactivo | Rechazo sin cambios; no sustitución automática por otra persona. |
| Acceso directo con roles DB públicos | Denegación real de lecturas/escrituras/ejecución privadas; no deducida solo de RLS habilitado. |

La garantía operativa del último administrador, la baja administrativa y las carreras retiro/registro pertenecen a C/D. Un índice único o un seed no las acredita.

## Cierre y entrega al siguiente equipo

BE07 entrega desde el repo backend: migraciones y orden, scripts/fixtures, informe reproducible y matriz de casos con versión/entorno/resultado. Enlazar la evidencia desde el [tablero](README.md), las tareas PA-S03/PA-S00 y [ESTADO.md](../../../../ESTADO.md); distinguir código, pruebas, SQL aplicado, Git y despliegue.

**Base técnica lista para INT03-A:** esquema cotejado, DDL/FKs instalables, privilegios comprobados y ensayo aislado reproducible. Si la correspondencia real sigue sin revisión, registrar el cierre técnico como parcial y conservar pendiente la transición de personas; los fixtures no la completan. La aplicación remota acredita su entorno por separado.

**Entrega a frontend:** B comunica modelo y dependencias. La API consumible se entrega en [INT02-C](pa-t-int02-c.md), con ejemplos/errores y evidencia real; [INT06](pa-t-int06.md) define las tareas de integración. B no habilita el registro participante ni el piloto.

[Ficha previa conservada](../archivo/pa-t-int02-b-ficha-previa-2026-10-14.md).
