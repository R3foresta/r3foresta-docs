# ADR-PLA — Decisiones cerradas — Modulo Plantacion (MVP)

Las decisiones de metas, cierre y revisión del plan distinguen el backend local de su integración y despliegue verificado.

## ADR-PLA-01 — Edicion basica y desactivacion de campaña en MVP

Fecha: 2026-07-03
Actualizacion: 2026-07-23

### Contexto

La campaña es un contenedor estrategico y su estado se deriva desde las subcampañas. Se evaluo una regla estricta que bloqueaba toda edicion y eliminacion al existir cualquier subcampaña, pero resulto demasiado dura para el flujo real: impide corregir datos generales y desactivar campañas que solo contienen subcampañas canceladas.

Para MVP se permiten correcciones que no rompen snapshots ni trazabilidad operativa. La operación real también requiere retirar de forma segura una campaña cuyas subcampañas todavía no plantaron, sin obligar al administrador a cancelar cada hija manualmente ni dividir una operación que debe ser atómica.

### Decision

En el MVP:

- `nombre`, `descripcion`, `fecha_estimada_inicio`, `fecha_estimada_fin` y organizaciones asociadas son editables como datos generales.
- `tipo` solo se edita mientras no exista ninguna `SUBCAMPANIA` asociada.
- La desactivación estricta puede aplicarse si no hay subcampañas vivas no canceladas; no produce efectos implícitos sobre hijas.
- Existe una acción explícita de desactivación con cancelación masiva, solo para `ADMIN`, con preview y motivo obligatorio.
- La acción masiva admite hijas `BORRADOR`/`ACTIVA` únicamente con `total_plantado_inicial = 0`, considera `CANCELADA` como postcondición satisfecha, devuelve físicamente el stock disponible y aplica soft-delete a la campaña en una sola transacción.
- Una hija con plantaciones o en `COMPLETADA`, `FINALIZADA_PARCIAL` o `PAUSADA` bloquea toda la operación masiva.
- El borrado fisico (`DELETE`) solo se permite si no existe ninguna subcampaña asociada.

### Consecuencias

- Permite corregir datos visibles de campaña sin tocar registros operativos.
- Las organizaciones pueden cambiar: las subcampañas ya activadas conservan `nombres_organizaciones_snapshot`; las futuras activaciones usan la relacion actual.
- No se implementa propagacion de `tipo` a subcampañas.
- La cancelación desde campaña reutiliza la semántica canónica de `RN-PLA-37`, registra `origen = DESACTIVACION_CAMPANIA`, devuelve stock y hace rollback completo ante cualquier fallo.
- Preview y ejecución son contratos separados: el preview no reserva ni autoriza; la ejecución vuelve a validar dentro de la transacción.

### Referencias

- `RN-PLA-38`
- `database/migrations/050_m3_campania_edicion_eliminacion_estricta_mvp.sql`
- `database/migrations/056_fix_devolucion_saldo_constraint.sql`
- `database/migrations/057_m3_campania_desactivacion_masiva.sql`
- `post-mvp/03-plantacion.md`

## ADR-PLA-02 — Registro de plantacion inicial en MVP

Fecha: 2026-07-08

**Estado:** histórico en cuanto al tope por especie; sustituido por ADR-PLA-04 el 2026-10-09. La ventana retroactiva de 10 días se mantiene. Las referencias a bloqueo y excedentes fuera del MVP describen el contrato anterior.

### Contexto

El registro inicial de plantacion consume el contrato vigente de backend para `POST /registros-plantacion` y el contexto operativo de subcampaña. El objetivo del MVP es registrar sin duplicar reglas complejas en frontend.

### Decision

En el MVP:

- La plantacion inicial no puede exceder `cantidad_objetivo` por especie, porque la RPC actual lo bloquea.
- La fecha de plantacion conserva la ventana retroactiva vigente de backend: 10 dias.
- No se implementa configuracion especial en frontend para estas reglas.

### Consecuencias

- El frontend debe respetar el limite por especie mientras backend no cambie el contrato.
- Los excedentes operativos por especie quedan fuera del MVP.
- La ventana retroactiva configurable queda fuera del MVP.

### Referencias

- `POST /registros-plantacion`
- `Backend-r3foresta/documentacion/postman/plantacion-context.md` (contexto de plantacion inicial)
- `post-mvp/03-plantacion.md`

## ADR-PLA-04 — Metas orientativas, cierre manual y edicion del plan

Fecha: 2026-10-09. Alineación solicitada por el usuario con el backend local; el registro de cambio del backend fecha la decisión de metas/cierre el 2026-10-08.

**Vigencia:** la restricción de edición a BORRADOR describe el backend revisado el 9 de octubre antes de implementar ADR-PLA-05. ADR-PLA-05 la sustituye y ya tiene soporte en el backend local para ADMIN en BORRADOR o ACTIVA; integración frontend y despliegue verificado siguen pendientes. Metas orientativas y cierre manual conservan su vigencia.

### Contexto

El contrato anterior ya permitía entregar 50 plantas frente a un objetivo de 40, pero limitaba la plantación a 40 por especie y preveía cierre automático. El backend local incorpora migraciones 060/061 y anuncia `permite_exceder_meta_especie=true`. Además, sus servicios de plan y edición solo permiten ADMIN/BORRADOR; la documentación anterior prometía ajustes del plan en ACTIVA por admin/coordinador.

### Decision

- La meta total y los objetivos por especie son referencias de planificación. Se conserva su valor original y se registra el total físico real, incluso por encima del 100%.
- Asignar puede superar el objetivo dentro del saldo físico del vivero. Plantar puede superar el objetivo dentro del stock asignado disponible de propósito PLANTACION_INICIAL. Objetivo 40 y stock 50 permiten 50 de una vez o 40 + 10; 51 sin más stock se rechaza.
- La especie debe estar en el plan tanto al asignar como al plantar inicialmente. No se permite «cualquier especie» por tener stock. Reposición conserva especie libre, propósito REPOSICION y límite de muertas menos repuestas; no avanza la meta.
- Solo ADMIN edita meta total y plan en BORRADOR. En ACTIVA no se extienden metas ni se agregan especies; el coordinador no obtiene esa facultad. Editar un plan activo queda para evaluación futura.
- Alcanzar o superar la meta no cierra: permanece ACTIVA y admite más plantación inicial elegible. Solo ADMIN ejecuta `POST /subcampanias/:id/cerrar`, con estado final y fechas explícitas de cierre y fin de mantenimiento. La UI propone tres años, editables; fin no puede preceder al cierre.
- La UI elige COMPLETADA con meta alcanzada/superada y FINALIZADA_PARCIAL por debajo, con motivo de catálogo obligatorio. El endpoint actual acepta ambos estados y no compara el total plantado con la meta; no documentar esa comparación como validación de backend.
- Tras cerrar se bloquean plantaciones/asignaciones iniciales y comienza mantenimiento. El saldo no utilizado sigue asignado hasta devolución física separada. El servicio de cierre actualiza la subcampaña; la escritura de eventos de cierre en historial sigue pendiente.

### Consecuencias y verificacion

Sustituye el tope de ADR-PLA-02/RN-PLA-18 y el cierre automático previsto por RN-PLA-10/RF-PLA-07. Alinea RN-PLA-17/RF-PLA-18 con los permisos/estados de edición realmente expuestos. No amplía los permisos contextuales ni declara su implementación.

Esta revisión documental no aplicó migraciones ni verificó la base compartida. Antes de utilizar el flujo en un entorno, confirmar migraciones 060/061 y versiones de backend/contexto/PWA coordinadas. Los SQL anteriores de este repositorio se conservan como históricos; la migración 053 contiene el tope anterior.

### Referencias de la evidencia local

- [Registro de cambio y límites de verificación del backend](../../Backend-r3foresta/documentacion/tareas/plantacion-metas-orientativas.md).
- [060: asignación exige especie del plan](../../Backend-r3foresta/migrations/060_vivero_asignacion_validar_plan_especie.sql).
- [061: metas orientativas en registro](../../Backend-r3foresta/migrations/061_plantacion_meta_especie_orientativa.sql).
- [Política de contexto](../../Backend-r3foresta/src/subcampanias/domain/policies/reglas-plantacion.policy.ts).
- [Servicio de plan](../../Backend-r3foresta/src/subcampanias/application/subcampanias-plan.service.ts) y [campos editables por estado](../../Backend-r3foresta/src/subcampanias/domain/policies/edicion-por-estado.policy.ts).
- [Servicio de cierre](../../Backend-r3foresta/src/subcampanias/application/subcampanias-cierre.service.ts) y [política de cierre](../../Backend-r3foresta/src/subcampanias/domain/policies/cierre.policy.ts).


## ADR-PLA-05 — Edicion de meta y especies en ACTIVA solo ADMIN

Fecha: 2026-10-09.

**Estado actualizado 2026-10-10:** decisión aprobada por el usuario, con confirmación explícita «ADMIN only», e implementada en el backend local mediante la migración 062 y revisión atómica. El usuario confirmó en el chat de implementación la aplicación en Supabase hasta 062 y posteriormente de 063. La integración frontend, publicación de los últimos ajustes JWT y verificación del despliegue siguen pendientes; la confirmación humana de las migraciones no equivale a una inspección remota de esta revisión.

### Decision

La planificación vive en SUBCAMPAÑA: ADMIN puede modificar `meta_total_arboles`, objetivos/porcentajes por especie y agregar especies del catálogo en BORRADOR o ACTIVA. La campaña conserva su meta agregada derivada; no obtiene una meta editable propia. Ser coordinador o administrador contextual de participación aliada no concede este permiso global.

Los ajustes conservan un plan coherente: al menos una especie, sin duplicados, objetivos positivos, porcentajes sumando 100 y cantidades sumando la meta total. Se guardan meta y plan como una revisión coherente con quién/cuándo y valores anteriores/nuevos. Los registros de plantación, autorías y cantidades reales permanecen intactos. Editar el plan no crea ni devuelve stock; no se elimina una especie con plantación inicial registrada o stock inicial disponible.

Las asignaciones/plantaciones iniciales siguen limitadas a especies del plan vigente: una especie nueva se incorpora antes de asignarla. Las metas siguen siendo orientativas; superar objetivos no obliga a editarlos y no los modifica automáticamente. El progreso se recalcula contra la meta vigente. Ajustar metas no cierra la subcampaña; el cierre manual por ADMIN se mantiene. Los estados cerrados/cancelados no admiten esta edición ni reapertura.

Ejemplo: una subcampaña ACTIVA tenía meta 40 y registra 50 árboles reales. ADMIN puede revisar su meta a 60 y ajustar el plan por especie; quedan 50 plantados y el saldo físico no cambia. También puede incorporar otra especie al plan antes de recibir stock de ella.

### Contrato implementado y límites

`GET /api/subcampanias/:id/plan` devuelve meta total, especies y `plan_revision` en un único snapshot. Cualquier usuario autenticado existente en `USUARIO` puede leerlo, sin pertenecer al equipo. `PUT /api/subcampanias/:id/plan` exige ADMIN global y permite BORRADOR o ACTIVA. Ambas rutas verifican `Authorization: Bearer <token>` con el JWT del login WebAuthn; `x-auth-id` es opcional y, si se envía, debe coincidir con `sub` del JWT. La lectura del plan no concede acceso operativo a equipo/stock ni permisos para plantar o gestionar participantes; los permisos contextuales conservan su alcance separado.

El guardado completo envía `meta_total_arboles`, `metas` y `revision_esperada` obtenida de `plan_revision`. En ACTIVA son obligatorios; en BORRADOR una meta explícita también exige versión. Se conserva el cuerpo histórico `{metas}` en BORRADOR usando la meta vigente y fijando la versión al inicio de la petición; los clientes nuevos deben enviar siempre la versión leída en el editor. Todo guardado exige un plan coherente, también en BORRADOR. `PATCH /subcampanias/:id` rechaza `meta_total_arboles`: usar PUT /plan.

La RPC `fn_subcampania_revisar_plan` comparte el bloqueo de subcampaña con asignación/plantación, comprueba estado y versión, guarda meta/especies e incrementa `plan_revision` junto con `PLAN_REVISADO` en una misma transacción. El historial contiene actor, fecha y snapshots `metadata.anterior`/`metadata.nuevo`; si falla, se revierte todo. Una versión obsoleta devuelve `409`: leer y conciliar antes de reenviar, sin reintento automático que sobrescriba cambios ajenos. Stock de REPOSICION no impide por sí solo retirar una especie del plan inicial.

La migración 063 restringe la RPC de lectura a `service_role`, igual que la escritura: los usuarios leen a través del backend autenticado, no ejecutando directamente la RPC como `anon`/`authenticated`. `JWT_SECRET` y `SUPABASE_SERVICE_ROLE_KEY` permanecen en el backend; la clave administrativa no convierte al usuario en ADMIN ni se envía al frontend. La edición de plantaciones y otros permisos no se amplían.

### Evidencia y pendientes de integración

La revisión del [chat de implementación](codex://threads/01a12288-904e-7061-8dd0-2b80f916a157) y del código local confirma el contrato. El chat reporta 531 pruebas unitarias/HTTP y 46 verificaciones PostgreSQL aisladas, compilación, tipos y estilo; esta actualización documental no vuelve a ejecutarlas ni acredita producción. La aplicación de 063 fue confirmada posteriormente por el usuario en ese chat.

Falta completar frontend: bloquear solicitudes sin token, manejar sesión vencida/permisos, enviar plan/meta/versión y resolver 409 con conciliación. Publicar los últimos cambios backend, coordinar versiones y verificar configuración, privilegios y lectura HTTP en el entorno real antes del cierre operativo. Ver [ESTADO.md](../ESTADO.md).

### Referencias

- [RF-PLA-18](../03-plantacion-module/00_Requerimientos_Modulo_3_Plantacion.json).
- [RN-PLA-17](../03-plantacion-module/01_reglas_de_negocio_plantacion.md#rn-pla-17---edicion-del-plan-segun-estado).
- [Proceso de ajuste en ACTIVA](../03-plantacion-module/02_Procesos_Modulo_3_Plantacion.md#ajuste-del-plan-mientras-activa-solo-admin).
- [Servicio local de plan](../../Backend-r3foresta/src/subcampanias/application/subcampanias-plan.service.ts) y [política local de edición](../../Backend-r3foresta/src/subcampanias/domain/policies/edicion-por-estado.policy.ts).
- [062 — revisión atómica](../../Backend-r3foresta/migrations/062_subcampania_revision_plan_atomica.sql) y [063 — lectura mediante backend](../../Backend-r3foresta/migrations/063_subcampania_plan_lectura_backend.sql).
- [Contrato API de planes](../../Backend-r3foresta/documentacion/frontend/modulos/subcampanias.md#get-subcampaniasidplan) y [guía de verificación 062–063](../../Backend-r3foresta/documentacion/tareas/verificacion-supabase-plan-062-063.md).
