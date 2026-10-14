# Dependencias para implementar PA-F01

**Revisión:** 9 de octubre de 2026. **Estado:** análisis para Elaboración; no aprueba specs ni acredita preparación del piloto.

**Actualización documental del 12 de octubre:** la lectura de código de este informe conserva su fecha; no se repitió ni acredita el estado actual de los repos de aplicación. Los cinco diagramas locales se regeneraron con los acuerdos de PA-S00–04: consulta pública reducida separada de gestión interna, ADMIN global directo en ACTIVA, GPS manual/exterior y recuperación del mismo intento aprobados en comportamiento, y correcciones de cantidades/participantes por ambos administradores en ACTIVA. Cantidades exige ausencia de bajas/reposiciones y conserva entrega/vivero. Observaciones sigue central. Las menciones históricas de decisiones abiertas más abajo se interpretan según las specs y el [acta de correcciones](../revision-correcciones-2026-10-12.md); mecanismos, contratos y pruebas siguen pendientes. «Identidad verificada» significa autenticar la sesión en servidor, no pedir documento de identidad.

La dependencia principal es **adaptar identidad y autorización al ámbito persona/subcampaña sobre el registro y el stock que ya existen**. Crear el formulario no basta: contexto, guardado y gestión de acceso deben aplicar la misma política. El mapa es una entrada de consulta separada, no una condición para registrar.

El LCO enumera dependencias en §§3, 6, 8 y 9. Este análisis las ordena y añade una lectura estática acotada de los repositorios locales `Backend-r3foresta` y `pwa-r3foresta`. Sus árboles de trabajo contienen cambios sin commit. No se ejecutó la aplicación ni se consultó la base compartida; tampoco se comprobó el despliegue. Las confirmaciones históricas de [ESTADO.md](../../../../../ESTADO.md) conservan su fecha y alcance.

## 1. Qué podemos reutilizar y qué falta

| Dependencia | Base encontrada | Qué se necesita antes de habilitar el comportamiento |
|---|---|---|
| Usuario y sesión | Usuarios existentes; WebAuthn/JWT y restauración de perfil en la PWA. | Derivar identidad de credencial verificada en backend. Plantación local aún usa `x-auth-id`; enviar también JWT desde la PWA no demuestra que ese endpoint lo valide. |
| Campaña y subcampaña | Modelo, estados y contexto de plantación existentes. | Subcampaña existente, no eliminada y `ACTIVA`, con plan por especie y polígono evaluable en el entorno elegido. |
| Plan y especies | `SUBCAMPANIA_META_ESPECIE` y cantidades/avance en el contexto. | Conservar pertenencia al plan y alinear versión de reglas de meta/cierre; hay una discrepancia con cambios locales recientes (§4). |
| Entrega física y stock | Asignaciones M2→M3 y RPC de consumo existentes. | Al menos una asignación `ACTIVA`, de esa subcampaña, propósito `PLANTACION_INICIAL` y saldo positivo. No basta con plantas en Vivero. |
| Evidencia, ubicación y fecha | Pre-subida de fotos, GPS/PostGIS, fecha y vinculación con el registro existentes. | Comprobar almacenamiento/vinculación y adoptar límites revisados. Alinear GPS fuera del polígono frente a GPS no evaluable. |
| Permisos contextuales | Roles globales y `COORDINADOR/OPERARIO` en backend/PWA. | Adaptar `PLANTADOR` y `ADMINISTRADOR DE SUBCAMPAÑA`; varios administradores y protección del último. No equivalen automáticamente a roles actuales. |
| Gestión de acceso | Servicio actual de equipo: `ADMIN` global y un coordinador. | Incorporar/retirar plantadores dentro del ámbito contextual; designar/cambiar/retirar administradores por R3Foresta; selección masiva actual sin herencia. |
| Retiro frente a guardado | RPC comprueba equipo y mantiene atomicidad de datos/consumo. | Definir/verificar orden consistente entre autorización y retiro para los cuatro resultados del LCO. Una lectura del equipo no demuestra esa garantía. |
| Reintentos y duplicación | UI bloquea botón mientras envía; creación local no transporta una clave de intento en DTO/RPC. | Idempotencia durable y recuperación de resultado incierto. Mismo intento: un registro/consumo. Dos personas registrando el mismo hecho necesitan además una pauta operativa. |
| Consulta común y lectura propia | Registros, responsables, corresponsables y coordenadas como base documentada. | Campos visibles y agregados acordados; mapa→resumen→registros y lectura propia tras retiro sin equipo/stock. No se certifica implementación de la vista nueva. |
| Corrección excepcional | Autoridad central y original preservado confirmados en el LCO. | Definir/verificar casos, campos, motivo, historial y efectos en cantidades/saldos/estados antes del piloto. Revisar un error no repara los datos. |

«Base encontrada» significa documentos o código reutilizable, no una dependencia aplicada, integrada y lista en producción.

## 2. Datos que deben existir antes de un registro

1. **Usuario registrado**, identidad verificada y permiso vigente en la subcampaña elegida. Afiliación organizacional no es requisito ni fuente de permiso.
2. **Campaña y subcampaña preparadas**, con plan por especie, polígono y subcampaña `ACTIVA`. Activar permite cero asignaciones; registrar sí requiere stock elegible.
3. **Plantas disponibles en Vivero** para una nueva entrega: lote `ACTIVO` con `EMBOLSADO` y saldo físico positivo. Su origen conserva trazabilidad de Recolección; no hay que reconstruir los módulos anteriores para cada registro.
4. **Entrega física registrada**, por asignación a esa subcampaña con propósito `PLANTACION_INICIAL`. Entonces se descuenta Vivero y nace el stock de campo.
5. **Formulario completo y contexto vigente**: fotos, GPS evaluable, fecha válida, especies permitidas, cantidades enteras positivas y saldo suficiente. Corresponsables opcionales e identificados según el contrato adoptado; el responsable es el usuario autenticado.

Para registrar importa el saldo actual de la asignación, no exigir que el lote siga teniendo plantas después de una entrega ya realizada:

```text
saldo_asignado_disponible
= cantidad_asignada − cantidad_consumida − cantidad_devuelta − cantidad_mermada
```

Plantar consume ese saldo e incrementa `cantidad_consumida`. No descuenta otra vez `LOTE_VIVERO.saldo_vivo_actual` ni crea otro despacho. La cantidad entregada original es inmutable. El equipo mixto comparte stock de subcampaña; no se divide por organización.

**Caso ilustrativo:** entregar 100 plantas y registrar trabajos físicos distintos de 30 y 20 deja 50 disponibles y 50 plantados. Un trabajo grupal de 30 con varios participantes cuenta 30 una sola vez. Retirar permiso impide nuevos registros, pero conserva los guardados y su lectura propia.

Fuentes: [LCO §§3 y 6](../../../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md), [handoff §§3–8](../../../../../03-plantacion-module/05_handoff_registro_plantacion_inicial.md), [contrato M2→M3 §§5–6](../../../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md).

## 3. Dependencias entre unidades y orden recomendado

![PA-D05 — Dependencias de implementación](svg/PA-D05-dependencias-implementacion.svg)

Una flecha indica una condición necesaria para completar la capacidad que la recibe. Las entradas que convergen se necesitan juntas. No obliga a diseñar todo en serie ni representa arquitectura desplegada.

| Unidad | Dependencias para implementarla/habilitarla | Relación con las otras unidades |
|---|---|---|
| **PA-S01: registro inicial** | Identidad, permisos, contexto/datos, GPS/metas/cierre alineados, consumo atómico, retiro consistente e idempotencia. | Puede bocetarse/especificarse con persona ya habilitada. Adaptación técnica de PA-S03 condiciona sus permisos; mapa no es paso obligatorio. |
| **PA-S03: gestión de acceso** | Modelo/transiciones, autoridad central/contextual, varios administradores y último protegido, retiro e historial, selección sin herencia. | Condición del piloto aunque PA-S01 asuma persona habilitada. Elaborable junto con registro. |
| **PA-S02: consulta** | Registros/geometrías, visibilidad, agregación sin duplicar por participantes y lectura propia tras retiro. | Parte del piloto como consulta; no bloquea entrada directa al registro autorizado. |
| **PA-S04: corrección excepcional** | Original/autoría, autoridad central, revisión del administrador, casos/límites y efectos definidos/verificables. | No es aprobación previa de cada registro. Preparar/verificar antes de campo. |

**Orden recomendado, sujeto a specs revisadas:**

1. Identificar versión objetivo y alinear contratos, empezando por §4. El contexto no puede anunciar reglas nuevas si la RPC instalada aplica las anteriores.
2. Diseñar/adaptar identidad, permisos y transiciones; definir orden de retiro/guardado y recuperación de intentos. Esquema y mecanismos necesitan plan propio, no se inventan en los diagramas.
3. Integrar registro y gestión básica de acceso sobre esa política; verificar precondiciones, rechazos, atomicidad y resultado incierto.
4. Concretar consulta y corrección excepcional en sus unidades con campos/efectos revisados.
5. Verificar el alcance mínimo sobre versión identificada y datos de prueba; después revisar preparación para el **15 de octubre de 2026**, fecha objetivo de campo.

Consulta/corrección no retrasan el boceto, pero no son opcionales al cerrar preparación del piloto acordado. Mortandad, reposición, merma de campo, financiación detallada y edición general conservan recorridos posteriores.

## 4. Hallazgos de la revisión local

### PA-DEP-01 — Identidad de plantación basada en header

El [controller](../../../../../../Backend-r3foresta/src/plantaciones/api/plantaciones.controller.ts) recibe `x-auth-id`; `requireAuthId` verifica presencia y valor no vacío. El [servicio de autorización](../../../../../../Backend-r3foresta/src/plantaciones/application/plantacion-auth.service.ts) busca usuario por ese valor y comprueba rol global. No se encontró verificación JWT en esa ruta ni guard global en los archivos de arranque revisados. La [API PWA](../../../../../../pwa-r3foresta/src/api/plantacion.api.ts) envía JWT cuando existe además del header; eso no resuelve la identidad en servidor.

**P0:** identidad derivada de credencial verificada antes de confiar en permisos/autoría. Verificar que token ausente/inválido/expirado no pueda suplirse con un header y que cambiarlo no permita actuar como otra persona. Consta también en [ESTADO.md](../../../../../ESTADO.md) y [pendientes de seguridad/idempotencia](../../../../../../pwa-r3foresta/docs/BACKEND_SECURITY_AND_IDEMPOTENCY_TASK.md). No se probó explotación ni producción.

### PA-DEP-02 — Equipo actual y roles nuevos

El [servicio de equipo](../../../../../../Backend-r3foresta/src/subcampanias/application/subcampanias-equipo.service.ts) exige `ADMIN` para agregar/quitar, rechaza varios `COORDINADOR` y protege al coordinador de una subcampaña activa. El [contexto](../../../../../../Backend-r3foresta/src/subcampanias/application/subcampanias-plantacion-context.service.ts) exige rol global `ADMIN/VALIDADOR/GENERAL` más pertenencia `COORDINADOR/OPERARIO`; los [tipos PWA](../../../../../../pwa-r3foresta/src/modules/plantacion/types/contracts.ts) usan esos nombres. El [schema](../../../../../database/00_database_schema.md) describe un índice único parcial de coordinador.

**P0:** correspondencia/migración y ámbito sin convertir administrador contextual en `ADMIN` global. Varios administradores y último protegido. Incluir participación independiente/voluntaria sin deducir rol técnico desde «voluntario». Compatibilidad del catálogo global se resuelve en el plan; aquí no se añaden roles globales.

### PA-DEP-03 — Reintento y retiro frente a guardado

El [DTO](../../../../../../Backend-r3foresta/src/plantaciones/api/dto/registrar-plantacion.dto.ts) y la [creación](../../../../../../Backend-r3foresta/src/plantaciones/application/plantacion-creation.service.ts) no transportan clave de intento. La RPC local conserva bloqueos sobre subcampaña/asignaciones y consumo transaccional; eso no demuestra idempotencia de extremo a extremo ni el orden con retiro del permiso.

La [pantalla](../../../../../../pwa-r3foresta/src/modules/plantacion/screens/RegistrarPlantacionScreen.tsx) trata fallos del POST en un `catch` común e intenta descartar evidencias. Distinguir rechazo confirmado de pérdida de respuesta después de guardar: no asumir que esta última significa «no registrado», ni prometer reenvío seguro sin recuperación del intento original. La limpieza contempla si fotos quedaron vinculadas.

**P0:** especificar/verificar reenvío, contenido diferente bajo misma clave, concurrencia, pérdida de respuesta y retiro antes/después de autorización. No se define un endpoint/header ni mecanismo nuevo aquí.

### PA-DEP-04 — GPS por alinear

[Handoff §12](../../../../../03-plantacion-module/05_handoff_registro_plantacion_inicial.md) y [migración 053](../../../../../database/migrations/053_m3_registrar_plantacion_sin_despacho.sql) conservan bandera/distancia fuera del polígono sin abortar y bloquean GPS no evaluable. La [política backend](../../../../../../Backend-r3foresta/src/subcampanias/domain/policies/reglas-plantacion.policy.ts) declara `gps_fuera_poligono_bloquea=false`. RN-PLA-32 mantiene el bloqueo conceptual anterior.

**P0:** alinear fuentes y comprobar versión objetivo. PA-D03 se apoya en evidencia local, sin aprobar una nueva regla ni declarar probado el despliegue. GPS fuera del polígono no equivale a inválido/no evaluable.

### PA-DEP-05 — Meta orientativa y cierre manual recientes

La revisión inicial detectó que la base documental anterior tomaba meta como tope por especie. La alineación solicitada por el usuario el 2026-10-09 actualiza reglas, requisitos, handoff y PA-S01 a metas orientativas y cierre manual (ADR-PLA-04). El backend local contiene [migración 061](../../../../../../Backend-r3foresta/migrations/061_plantacion_meta_especie_orientativa.sql) y [política de contexto](../../../../../../Backend-r3foresta/src/subcampanias/domain/policies/reglas-plantacion.policy.ts) con `permite_exceder_meta_especie=true`. La RPC 061 permite exceder cantidades objetivo sin exceder stock, exige especies del plan y no cierra automáticamente. La PWA tiene cambios locales de cierre manual.

El [documento de ese cambio](../../../../../../Backend-r3foresta/documentacion/tareas/plantacion-metas-orientativas.md) registra decisión del usuario del 8 de octubre y comprobaciones locales; aclara que la investigación no aplicó migraciones ni desplegó. Esta revisión leyó la evidencia, no repitió pruebas ni verificó la base compartida.

**P0 de entorno pendiente:** confirmar 060/061 aplicadas y coordinar contexto/RPC/PWA. La discrepancia documental de metas/cierre se resuelve con ADR-PLA-04; no acredita despliegue, aprobación completa de specs ni cierre de los demás P0. Los diagramas que marcan alineación pendiente conservan el aviso de verificación de entorno y de GPS aún no resuelto.

## 5. Evidencia para revisar preparación

Derivada del LCO; no certifica pruebas ejecutadas:

- Identidad/permisos: persona autorizada, no autorizada, otro ámbito y manipulación de identidad; administrador contextual sin acceso implícito a Recolección/Vivero ni nombramiento de administradores.
- Acceso: incorporación directa, selección actual sin herencia, varios administradores y protección del último.
- Retiro: formulario abierto, envío sin autorizar, operación autorizada antes del retiro y registro guardado; lectura propia sin equipo/stock.
- Consumo: registros concurrentes con stock limitado, reenvío y pérdida de respuesta; un registro/consumo por intento y ningún segundo débito de Vivero.
- Datos: evidencia, fecha, especies/cantidades y meta/cierre coherentes con versión; GPS dentro, fuera y no evaluable.
- Consulta/corrección: mapa sin multiplicar grupos, campos acordados, lectura propia tras retiro y corrección central real con original/autoría/motivo/efectos definidos.
- Campo: acceso/registro sin guía, resultado reconocido y cantidades/stock correctos; dificultades anotadas. No hay umbral de tiempo aprobado.

## Fuentes y límites

Producto: [LCO](../../../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md) y [ADR-PLA-03](../../../../../decisiones/02_decisiones_plantacion.md). Base: [handoff](../../../../../03-plantacion-module/05_handoff_registro_plantacion_inicial.md), [contrato físico](../../../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md), [schema](../../../../../database/00_database_schema.md), [migración 053](../../../../../database/migrations/053_m3_registrar_plantacion_sin_despacho.sql). Specs: [PA-S01](../../01-registro-plantacion-inicial/spec.md), [PA-S02](../../02-consulta-impacto-y-registros/spec.md), [PA-S03](../../03-gestion-acceso-subcampania/spec.md), [PA-S04](../../04-correccion-excepcional/spec.md).

Código: archivos locales enlazados en §4. Backend HEAD `90620f4` y PWA HEAD `9104ef3`, ambos con cambios locales; esos commits no identifican todo el contenido revisado. Referencias a repos hermanos requieren tenerlos junto a este repositorio. El trabajo se limita a diagramas y documentación; aprobación de specs, cambios de código, migraciones y estado productivo requieren su evidencia correspondiente.


### Ajuste aprobado de planificación activa — ADR-PLA-05

La decisión humana posterior del 2026-10-09 permite ajustar meta total y especies en ACTIVA, exclusivamente por ADMIN global. El backend local aún limita esa edición a BORRADOR; adaptar y verificar guardado coherente/auditoría y UI antes de ofrecerla. No amplía la autoridad del administrador contextual de participación aliada. El registro inicial utiliza el plan vigente y el stock real; una revisión de plan no modifica plantaciones guardadas ni balances físicos. Ver [ADR-PLA-05](../../../../../decisiones/02_decisiones_plantacion.md#adr-pla-05--edicion-de-meta-y-especies-en-activa-solo-admin).
