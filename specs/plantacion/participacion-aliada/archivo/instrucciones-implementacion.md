# PA-F01 — Instrucciones de implementación

> **Planificación anterior archivada.** Conserva trazabilidad y propuestas de su fecha. Para ejecutar, leer el [tablero actual](../implementacion/README.md) y el [contrato D01–D12 aceptado](../contrato-identidad-permisos-backend-propuesta.md). Las propuestas de PA-S04 conservan su revisión propia.

**Fecha:** 12 de octubre de 2026; actualización técnica del 13. **Estado:** D01–D12 del contrato backend aceptadas por el usuario el 13 de octubre, con ajustes D02/D07. Las decisiones funcionales de PA-S01 están cerradas. Implementación, migraciones y pruebas integradas siguen pendientes; contratos de efectos específicos de PA-S04 conservan su revisión propia.

Leer [PA-S01](../01-registro-plantacion-inicial/spec.md), [PA-S03 y sus contratos](../03-gestion-acceso-subcampania/contratos.md), [PA-S04](../04-correccion-excepcional/spec.md) y sus actas. Este documento convierte el diseño compartido y el plan de integración en entregas con entradas, efectos y criterios de salida. Conserva sus IDs; no sustituye reglas de producto por decisiones técnicas implícitas.

**Revisión técnica aceptada el 13 de octubre:** D01–D12 del [contrato backend](../contrato-identidad-permisos-backend-propuesta.md) quedan aceptadas por Pablo, con ajustes D02/D07. La inicial consume LIFO del stock disponible de su subcampaña (`fecha_asignacion DESC, id DESC`), sin nueva recepción por organización/administradores ni segundo débito de Vivero. Afiliación opcional: organización existente del catálogo o «Otra»; snapshots históricos conservados. Esa versión concreta prevalece sobre los nombres/candidatos anteriores; la aceptación de diseño no marca implementación, migraciones o pruebas como completadas.

## 1. Contratos API propuestos

**Impacto público reafirmado el 13 de octubre:** PA-CT11 global/campaña/subcampaña/registro/mapa/fotos públicas se consulta y comparte sin cuenta, sin registro y sin login. VOLUNTARIO sin asignación obtiene la misma proyección pública que una persona anónima. No exige Bearer, `x-auth-id`, perfil, afiliación ni permiso; no queda detrás del guard de operaciones privadas. Alta/login solo se piden para registrar o usar áreas/datos privados. Las rutas públicas y sus enlaces deben funcionar en incógnito y con sesión vencida/fallo de capacidades, conservando el destino compartido y los campos/estados elegibles de PA-S02.

Todos los comandos privados derivan actor y rol de JWT verificado, resuelto a una cuenta existente y activa. Nunca aceptar `actor_id`, `responsable_id` o `rol` como fuente de autoridad enviada por el cliente. Autoría del original permanece inmutable. La recuperación histórica de un comando propio no exige conservar permiso contextual; exige sesión propia válida y entrega solo el resultado mínimo.

**Confirmación del usuario, 12 de octubre, tras revisión de contratos:** corregir identidad en registro y asegurar que cada evidencia pendiente pertenece al actor autenticado. El refuerzo comprende contexto privado, upload/descarte de pendientes y vinculación al guardar; enviar Bearer sin verificarlo en servidor no basta. Derivar creador/responsable de sesión y comprobar propiedad/tipo/estado bajo bloqueo antes de vincular, también para ADMIN global. Las lecturas de fotos siguen su audiencia: Impacto público conserva su política; verificación JWT no convierte toda foto publicada en privada ni autoriza publicar pendientes. Revisar acceso directo a pendientes por Storage junto con API. Implementación pendiente; elección posterior del usuario: tabla compartida de comandos, según §2; esquema y contrato concretados en el contrato backend aceptado el 13 de octubre; cotejo del catálogo e implementación pendientes.

| ID / ruta candidata | Entrada | Respuesta / efecto |
|---|---|---|
| PA-CT01 · `GET /participacion/capacidades` | JWT; filtros opcionales de navegación. | Capacidades y subcampañas accesibles con estado y acciones actuales. Sin equipos ajenos, contactos o stock en el resumen. |
| PA-CT02 · `GET /subcampanias/:id/contexto-registro` | JWT y ámbito autorizado. | `subcampania_id`, estado, revisión de plan, especies planificadas, saldo elegible por especie, fecha mínima/máxima, zona horaria y capacidades. Leer no reserva permiso ni stock. |
| PA-CT03 · `GET /subcampanias/:id/participantes-seleccionables` | JWT; ámbito autorizado; búsqueda por nombre y cursor. | Referencia, nombre y afiliación opcional de personas registradas/habilitadas en ese ámbito. No perfil completo. No reutilizar esta búsqueda para participantes históricos de una corrección. |
| PA-CT04 · `POST /plantaciones/iniciales` | JWT, `comando_id`, `subcampania_id`, `plan_revision_esperada`, `fecha_plantacion`, latitud/longitud, `especies[{planta_id,cantidad}]`, `coresponsable_ids`, `evidencia_ids`, observaciones opcionales. | Registro/comprobante persistidos, identificación del intento y estado confirmado. El servidor determina responsable y asignaciones LIFO; no recibe elección de lote/vivero del plantador. |
| PA-CT05 · `GET /participacion/comandos/:comando_id` | JWT del actor original y tipo de operación. | `CONFIRMADO` con resultado mínimo, `RECHAZADO` durable sin efecto o resultado todavía no confirmado. No devuelve contexto operativo tras revocación. |
| PA-CT06 · `GET /plantaciones/:id/detalle-propio` | JWT; responsable o participante histórico según PA-S02. | Datos permitidos y versión efectiva; conserva lectura tras revocación. No entrega equipo/stock como consecuencia de esta lectura. |
| PA-CT07 · comandos de acceso | Entrada/acciones de PA-S03-C04..09, con `comando_id`, ámbitos y revisiones esperadas. | Cambios todo-o-nada, auditoría y recibo. Mantener propuesta de PA-S03, sin introducir herencia de campaña. |
| PA-CT08 · `POST /plantaciones/:id/correcciones/{cantidad,participantes,observaciones}` | JWT, `comando_id`, `revision_esperada`, motivo y campos específicos del caso. | Original conservado, nueva versión efectiva, efecto de stock por asignación cuando corresponda y recibo. Cantidad/participantes por ambos administradores en ACTIVA; observaciones central. |
| PA-CT09 · `POST /plantaciones/:id/reversiones` | JWT, comando/revisión/motivo y causa `DUPLICADO` o `REGISTRO_ERRONEO`; referencia al registro que permanece válido si es duplicado. | Eliminación lógica auditable y compensación del consumo efectivo del registro revertido. Incluye reposición errónea, identificada como tal en servidor. Sin borrado físico. |
| PA-CT10 · `POST /eventos-plantacion/:id/reversiones` | JWT, comando/revisión/motivo; evento de mortandad erróneo. | Reversión lógica del efecto de la baja en el grupo, sin crear plantas disponibles para plantar ni devolver stock al vivero. No es comando para revertir entregas o devoluciones. |
| PA-CT11 · consultas públicas de Impacto | Sin JWT/cuenta/login/perfil/asignación: global, campaña, subcampaña, registro, mapa y fotos públicas; filtros/cursor según PA-S02. | Misma proyección para anónimo y VOLUNTARIO sin permiso, accesible por enlace compartido; sin stock, contactos, observaciones libres, EXIF o motivo interno. Un registro válido se suma una vez. |

Los nombres definitivos se registran juntos en DTO, Swagger y cliente. PA-CT04 adapta el DTO actual: hoy envía `detalles` por asignación; el nuevo contrato envía cantidades por especie y el servidor construye los detalles. Conservar el registro/reposición interno existente con autorización equivalente; ninguna ruta legada puede eludir las nuevas garantías. No convertir CT09/10 en un DELETE HTTP que borre originales por cascada.

### Validación de registro inicial

- Subcampaña ACTIVA; ADMIN global verificado o permiso contextual vigente; participantes registrados/habilitados en el mismo ámbito según el orden válido de autorización.
- Especies sin duplicados, cantidades enteras positivas, especie incluida en el plan; no usar meta como tope. Saldo de asignaciones activas/elegibles para PLANTACION_INICIAL, sin nuevo débito de vivero.
- Entre 1 y 10 evidencias propias, pendientes, de tipo admitido y no vinculadas/eliminadas. Verificar permisos de Storage además de la RPC.
- Coordenadas válidas; PostGIS evalúa interior/exterior. Exterior permitido con evaluación/advertencia; fallo técnico confirmado rechaza sin registro/consumo.
- Conservar ventana retroactiva vigente de 10 días y prohibición de fecha futura. La fecha no puede preceder a la entrega de ninguna asignación consumida. Publicar límites calculados por servidor; verificar extremos inclusivos y zona horaria aceptados en D07 al contrastar `fn_vivero_assert_fecha_operativa`, sin cambiar silenciosamente su semántica. Zona operativa aceptada en D07: `America/La_Paz`; extremos inclusivos y día de entrega conciliado de la asignación existente.
- Observaciones opcionales hasta 2000 caracteres. El cliente muestra después de fecha en paso 2, incluye en resumen privado si hay contenido y permite volver para corregir. No publica el campo por este cambio.

### Resultados y errores

Envelope propuesto: `{comando_id, operacion, estado, resultado?, error?}`. En `error`: código estable, campos afectados y contexto permitido; sin SQL ni datos ajenos. HTTP: 401 sesión inválida, 403 facultad insuficiente, 404 inexistente/no visible, 409 versión/estado/clave incompatibles o saldo/participantes cambiados, 422 datos inválidos. Fallo geográfico confirmado sin efecto: 503 con código `EVALUADOR_NO_DISPONIBLE` y rechazo verificable. Un timeout genérico o un 5xx sin ese resultado verificable sigue siendo incierto.

`CONFIRMADO` apunta al mismo recibo; `RECHAZADO` acredita ausencia de efecto de ese intento; 202 `PREPARADO` y 404 `COMANDO_NO_CONFIRMADO` en CT05 no acreditan fallo. El cliente conserva/repite la misma clave y contenido; nunca crea otra clave por no encontrar aún un resultado.

### Validación de reversión

CT09/10 exige motivo no vacío, revisión actual, autoridad global o de esa subcampaña y estado ACTIVA según PA-S04. El objeto aún debe tener efecto reversible; un comando nuevo sobre objeto ya revertido rechaza sin compensar de nuevo, mientras una repetición del comando confirmado recupera su recibo. Para duplicado exigir `registro_vigente_id` distinto, efectivo y del mismo ámbito/tipo, revisado dentro de la transacción; no admitir referencias cíclicas o a otro registro invalidado. Dos reversiones opuestas concurrentes no pueden dejar ambos originales sin registro válido.

Recalcular consumo pendiente por asignación incluyendo correcciones previas; comprobar asignación, propósito, devoluciones, inactivación y dependencias. Compensación no supera consumo efectivo ni produce saldos negativos/incompatibles. No aplicar parcialmente si una línea falla. Una reposición errónea se identifica por `es_reposicion` y su grupo origen; una baja errónea por `MORTANDAD_REPORTADA`. No aceptar tipo de objeto, saldo o diferencia calculados por cliente como hechos confiables.

## 2. Idempotencia, evidencia y borrador

**Elección del 12 de octubre:** el usuario acepta el enfoque de tabla común de comandos; `participacion_comando` sigue nombre candidato. Primer recorrido: plantación; reutilización posterior para acceso/correcciones con su autorización específica. Ver [flujo explicado](diseno-comandos-compartidos.md). Esta elección sustituye la indecisión entre tabla dedicada y común; no cierra esquema físico, nombres de DTO/rutas, retención ni toda la secuencia transaccional.

1. Crear UUID del intento al confirmar, después de la revisión del contenido. Normalizar listas y formar huella en servidor con operación/ámbito/fecha/coordenadas/especies/personas/evidencias/observaciones. No confiar en huella enviada por el navegador.
2. Unicidad durable de `(actor, operacion, comando_id)`. Misma clave y huella devuelve resultado previo; clave igual y contenido distinto devuelve conflicto. Peticiones concurrentes convergen en un recibo mediante unicidad y bloqueo en DB.
3. Registro, detalles, vínculos de fotos, consumo y resultado confirmado se confirman en la misma transacción. Para rechazo de negocio, usar subtransacción/savepoint o estructura equivalente que revierta todos los efectos y conserve un rechazo durable; un error de infraestructura con rollback completo no inventa ese rechazo.
4. Si no hay recibo porque la transacción sigue ejecutándose o se revirtió, CT05 no afirma fracaso. Repetir el mismo comando compite por la misma unicidad; no abre otra plantación. Tras rechazo durable, cambiar contenido o volver a confirmar después de cambiar el contexto crea otro comando y conserva el anterior.
5. Recuperar recibo antes de autorizar una escritura nueva. Si hubo éxito y luego retiro de permiso, devolver el recibo mínimo histórico; no volver a consumir ni devolver contexto privado.
6. Cargas de fotos: UUID de carga por archivo/intento, propietario y respuesta recuperable, para que pérdida de respuesta de upload no provoque otra carga ciega. Limpieza de pendientes comprueba ausencia de vínculo confirmado/intento en curso. Nunca elimina fotos de un original conservado o revertido lógicamente.
7. Borrador privado por cuenta/ámbito. Propuesta: IndexedDB para datos y archivos pendientes; aislamiento por cuenta, sin borrador privado en caché pública ni accesible tras logout/cambio de cuenta. Durante recuperación de sesión no afirmar que el intento falló. Documentar cuándo se elimina el contenido local.
8. Retención aceptada para piloto: claves y recibos mínimos sin vencimiento durante el piloto y cargas 30 días, según D11 aceptada; limpieza tras clausura transaccional del comando. No reciclar claves vencidas. No conservar fotos o contactos duplicados en recibos/auditoría.

## 3. Cambios de datos propuestos

Preparar migraciones nuevas en Backend-r3foresta después de inventariar el esquema destino y la última numeración. No editar 027–063 ni aplicar SQL productivo en esta revisión. Tipos FK deben coincidir con el esquema real (`bigint` en las entidades revisadas).

| Estructura candidata | Campos/restricciones mínimos | Integración |
|---|---|---|
| `subcampania_permiso` | Usuario, subcampaña, rol contextual cerrado, vigencia, actor/fecha de alta y retiro. Índice único parcial para permiso vigente por persona/ámbito. | Fuente única de autorización del nuevo registro; no `permiso OR equipo legado`. Mantener `subcampania_equipo` para coordinación/logística. |
| Revisión de permiso por persona/ámbito | Versión durable que no reinicia al revocar; revisar fila estable o extensión equivalente. | Comandos masivos/versiones de PA-S03 y protección del último administrador activo. |
| `participacion_comando` | Actor, operación, UUID, huella, estado terminal, resultado mínimo/registro asociado, fechas; unicidad actor/operación/clave. | Reutilizable para registro, acceso y corrección; no contiene un permiso ni duplica fotos. |
| `registro_plantacion_correccion` o evento compatible | Original o evento objeto, revisión anterior/nueva, caso, comando, actor/fecha/motivo, antes/después y referencia válida del duplicado. | Historial inmutable y eliminación lógica. Un evento append-only no se borra por esta extensión. |
| Líneas de efecto por asignación | Corrección, asignación, especie y delta de consumo; unicidad por línea de efecto. | Reconstruir consumo efectivo y revertir exactamente lo pendiente del registro, incluyendo correcciones anteriores; no reducir de nuevo el valor original ya compensado. |
| Afiliación histórica por persona/registro | Snapshot al guardar para responsable/participantes de nombre, origen catálogo/«Otra» e ID de procedencia cuando corresponda; distingue no declarada de histórica no disponible. | No reconstruir usando perfil actual. Para participante histórico añadido, no fingir que su afiliación actual era la de la fecha del trabajo. |

No añadir segunda tabla de plantaciones, stock por organización ni columna de estado de campaña. Evaluar extensión de historial existente antes de añadir auditoría redundante.

### Cantidades efectivas y eliminación lógica

Conservar datos originales, detalles, evidencias, responsable y eventos. La lectura efectiva aplica correcciones/reversiones; cada registro tiene una revisión verificable. El diseño físico debe distinguir cantidad original, cantidad efectiva y estado lógico sin escribir cero en columnas originales `> 0` ni introducir mortandad negativa en eventos cuyos CHECK exigen delta positivo.

`cantidad_consumida` de asignaciones se actualiza junto con las líneas de compensación. Entrega, devolución física, merma física y saldo de vivero permanecen intactos. Definir vistas/proyecciones efectivas para contexto, impacto, mapa, meta, detalle propio y contadores de grupo; revisar triggers existentes para que no vuelvan a sumar el original revertido. Ninguna reversión reabre automáticamente una subcampaña ni equivale a cancelar la subcampaña.

Ejemplos exigidos por producto:

- Stock entregado 100; dos registros de 30 para el mismo trabajo → disponible 40 y total 60. Revertir el duplicado → disponible 70, total efectivo 30, un registro válido y ambos originales auditables. Repetir el comando conserva 70/30.
- Reposición errónea de 5: liberar únicamente sus 5 consumidas en las asignaciones de REPOSICION de origen, reducir su contribución efectiva al grupo y conservar la reposición original y motivo. No trasladar a stock inicial ni devolver a vivero.
- Baja errónea de 4: revertir su delta efectivo de mortandad y recalcular saldo vivo del grupo; disponible para plantar no cambia. Es corregir una declaración errónea, no revivir plantas que realmente murieron.

La reversión de un registro inicial con bajas/reposiciones efectivas dependientes sigue sin autorización de cascada: la aclaración humana permite eliminar eventos erróneos, no borrar hechos posteriores reales. Propuesta de contrato: rechazar dependencias incompatibles y exigir revisión específica. Validar también asignaciones inactivas/devoluciones y saldo vivo no negativo antes de cualquier compensación.

## 4. Orden transaccional y compatibilidad

Propuesta de disciplina común para registro, acceso, correcciones, cierre, devolución y baja de cuenta; contrastar todas las RPC consumidoras antes de implementarla. Bloqueo aislado solo en una ruta nueva no garantiza concurrencia con las existentes.

1. Verificar JWT y resolver IDs. En transacción, bloquear cuentas involucradas por ID estable para serializar inactivación/rol, luego subcampañas por ID estable. Releer y autorizar allí. No usar tiempo del clic como orden de autorización.
2. Reclamar/leer clave de comando mediante unicidad; devolver resultado previo si corresponde, sin escritura nueva. Bloquear permisos/revisiones y registros/eventos objeto en orden estable.
3. Bloquear asignaciones elegibles por orden estable y revalidar plan, estado, fechas, participantes, evidencias y dependencias bajo la misma disciplina. LIFO de inicial usa `fecha_asignacion DESC, id DESC` del stock elegible de la misma subcampaña; locks por ID ASC, independientes del consumo. No añade recepción por organizaciones/administradores.
4. Resolver cantidades por especie en servidor. Ante saldo insuficiente, rechazar íntegro; no bajar cantidad ni quitar personas automáticamente. Liberación parcial propuesta: compensar líneas de consumo más recientes primero, sin superar su consumo efectivo; reversión total compensa todas las líneas pendientes. Revisar esta regla técnica antes del SQL.
5. Persistir dominio, consumo, auditoría y recibo juntos. No intervalo observable de stock liberado durante una sustitución ni efecto parcial si falla evidencia/GPS.
6. Devolver resultado confirmado e invalidar contexto privado/impacto afectado después del commit. Recuperar siempre recibo en cliente ante respuesta perdida; cachear consultas públicas sin datos de cuenta.

Retiro antes de autorización válida rechaza sin efecto. Autorización válida primero puede finalizar con las demás reglas; el retiro espera el orden transaccional. Cierre/devolución/cambio de plan y aparición de baja/reposición se prueban con órdenes controlados. Preservar REGISTRO_REPOSICION y facultades internas de GENERAL/VALIDADOR/COORDINADOR en la transición; administrador contextual no adquiere esas facultades por nombre.

Alta confirmada por [acuerdo del 12 de octubre](../acuerdo-roles-y-permisos-2026-10-12.md): toda cuenta nueva VOLUNTARIO en backend, sin permiso contextual automático ni ascenso por completar perfil. Solo ADMIN global asigna/cambia roles internos mediante operación de usuarios separada y autenticada; el perfil conserva el rol legítimo existente. Revisar default/privilegios de DB y todas las vías de alta. Preparar matriz de usuarios existentes y resolución explícita de excepciones; no convertir masivamente GENERAL o COORDINADOR. ADMIN global conserva acceso transversal sin filas de permiso por ámbito y se identifica una vez en miembros como «Administrador · Acceso global»; la proyección no modifica logística ni participantes históricos. PWA antigua: migrar o rechazar explícitamente comandos incompatibles; una ruta anterior no queda como bypass. Contratos definitivos/implementación pendientes.

## 5. Entregas por repositorio

| Entrega | Trabajo y archivos de referencia | Criterio de salida |
|---|---|---|
| PA-T-INT01 · revisión técnica | Preparación y aceptación D01–D12 completadas; DTO/errores, zona/fecha, persistencia, transición, bloqueos y retención definidos. Catálogo/manifest se cotejan por entrega; PA-DI07 conserva revisión de efectos propios. | Decisión por propuesta, responsable y pendientes explícitos; bloqueos de cada entrega identificados. D01–D12 aceptadas el 13, con ajustes D02/D07. Catálogo y manifest concreto de transición se comprueban en su entrega; efectos específicos PA-S04 siguen por revisar. |
| PA-T-INT02 · identidad/acceso | Backend: guard JWT, auth services, contexto/equipo/usuarios; migraciones de permiso/versiones/grants. Referencias completas en plan de integración §6. | Cuenta participante opera solo en ámbito autorizado, sin facultades internas adicionales; último administrador y retiro concurrente verificados en DB. |
| PA-T-INT03 · registro recuperable | Backend: `RegistrarPlantacionDto`, creación/evidencias, RPC nueva, comando/consulta, LIFO. | Mismo intento produce un registro/consumo y recibo; foto ajena rechazada; retiro/stock/PostGIS reales probados. |
| PA-T-INT04 · formulario | Frontend: `RegistrarPlantacionScreen`, hook de creación/contexto, servicio de plantaciones, resumen y comprobante. | Tres pasos aprobados, observaciones en paso 2/resumen condicional, preservación de datos y recuperación del intento. |
| PA-T-INT05 · consulta | Backend `impact` y DTO de detalle propio; frontend Impacto/Mi participación; snapshots históricos. | Totales efectivos sin multiplicar participantes ni contar reversiones como plantaciones; proyecciones por audiencia. |
| PA-T-INT06 · gestión visual | Frontend gestión contextual sobre CT07/PA-S03; capacidades verificadas. | Selección actual todo-o-nada, sin herencia ni gestión de administradores por autoridad contextual. |
| PA-T-INT07 · correcciones/reversiones | Backend comandos por caso, líneas compensatorias y lecturas efectivas; frontend motivo/resumen/confirmación/historial. | Casos de PA-S04 resolubles por autoridad propia, originales intactos y stock/totales reconciliados una vez. |
| PA-T-INT08 · integración | Entorno aislado PostGIS, ensayo de migración/personas, compatibilidad PWA y regresiones. | Evidencia navegador → API → DB en versiones fijadas; autorización separada para producción/piloto. |

## 6. Matriz mínima de pruebas

Son pruebas a implementar y ejecutar después de revisar los contratos; esta documentación no registra resultados ficticios.

| Prueba | Preparación / acción | Resultado verificable |
|---|---|---|
| PA-Q01 · identidad/ámbito | JWT ausente/vencido; header de otra persona; Norte intenta operar Sur; llamadas directas y legadas. | Sin registro, lectura privada ni consumo ajeno. VOLUNTARIO habilitado registra en Norte; no recibe operaciones de Vivero/plan/cierre. |
| PA-Q01b · alta/roles/global | Alta sin rol o rol manipulado; perfil de GENERAL/ADMIN; administrador contextual intenta asignar rol interno; ADMIN global sin equipo en subcampaña actual/nueva. | Cuenta nueva VOLUNTARIO; perfil no eleva ni restablece autoridad; solo ADMIN global cambia roles internos. Acceso global y una presencia derivada en miembros, sin permisos por ámbito, COORDINADOR ni participantes históricos automáticos. Reglas de ACTIVA/stock/evidencia vigentes. |
| PA-Q02 · retiro | Barreras DB: retiro antes de autorización; autorización antes de retiro. | Primer orden sin efecto; segundo con un guardado válido si cumple demás reglas; luego solo recuperación histórica. |
| PA-Q03 · último administrador | Dos retiros/baja de cuenta simultáneos; selección Norte/Sur con un ámbito inválido. | Nunca cero administradores activos por carrera; todo-o-nada sin cambios parciales. |
| PA-Q04 · stock/LIFO | 100 entregadas, registros 30 y 20; meta 40 y registro 50 con saldo 50; dos comandos por últimas 10. | Saldo 50 y plantadas 50 en primer caso; meta no bloquea; consumo no negativo y LIFO verificable por asignación; vivero sin segundo débito. |
| PA-Q05 · intento | Doble clic/peticiones simultáneas; timeout antes/después de commit; misma clave y contenido diferente. | Un ID/recibo/consumo; consulta pendiente no crea otro; conflicto de huella no muta. Recuperar después de revocación no expone stock/equipo. |
| PA-Q06 · fotos/GPS/fecha | Foto ajena/vinculada/tipo inválido, respuesta upload perdida; interior/exterior, evaluador caído, coordenada manual; fechas en extremos y antes de entrega. | Fotos propias una vez; limpieza no borra confirmado; PostGIS real, exterior advertido y fallo confirmado sin efecto; límites coherentes API/DB/UX. |
| PA-Q07 · formulario/privacidad | Volver desde paso 3, cambiar observaciones, sesión vencida/cambio de cuenta, saldo/participante cambiado. | Resumen conserva última versión; observaciones vacías no se muestran; no ajustes silenciosos ni borrador/caché privados de otra cuenta. |
| PA-Q08 · cantidades/participantes | 10→12 con saldo 5; 12→10 con confirmación física; participante histórico sin permiso; ámbito ajeno/cierre concurrente. | Saldo 3 en aumento; reducción libera 2 trazables, sin devolver a vivero; participante corregido sin cambiar autor/cantidad/acceso; rechazo seguro por autoridad/estado. |
| PA-Q09 · duplicado/inexistente | Dos registros de 30 del mismo trabajo; revertir uno con referencia válida; anular registro erróneo; repetir/competir. | Un registro efectivo, total 30/disponible 70 para entrega 100; inexistente deja de sumar y compensa su consumo una vez; original/historial íntegros. |
| PA-Q10 · baja/reposición errónea | Baja 4 y reposición 5 erróneas, reversiones separadas; bajas reales posteriores/devolución concurrente. | Baja revierte solo mortalidad; reposición libera 5 de REPOSICION, sin cambio de entrega/vivero; dependencias incompatibles no se borran ni compensan silenciosamente. |
| PA-Q11 · lectura/regresión | Impacto/mapa/Mis registros tras corrección; tres participantes/dos organizaciones; cambio posterior de perfil; plan/cierre/reposición internos. | Totales efectivos deduplicados, afiliación histórica conservada, privado fuera de payload/cache públicos; facultades/transiciones internas preservadas. |

Para concurrencia y geografía usar PostgreSQL aislado con PostGIS y barreras explícitas; mocks y tests de UI no acreditan esas garantías. Anotar actor, IDs, saldos antes/después, recibo, auditoría y versión de repos. Reutilizar comandos/pruebas existentes indicados en plan de integración §8, añadiendo suites reales para registro/corrección. No usar producción como fixture.

Agregar PA-Q12 al conjunto de aceptación, sin renumerar PA-Q01..11:

| Prueba | Preparación / acción | Resultado verificable |
|---|---|---|
| PA-Q12 · Impacto público compartido | Abrir global y enlaces de campaña/subcampaña/plantación/foto pública en incógnito sin cuenta/token; repetir con VOLUNTARIO sin asignación, sesión vencida y fallo de capacidades. | Mismo contenido público y destino, sin login/alta/perfil obligatorios ni 401 de lectura pública. Registrar y datos privados sí verifican sesión/autoridad. Sin campos privados en JSON/archivos/caché. |

## 7. Revisión técnica aceptada y cotejos de ejecución

- [x] D01–D12 aceptadas por Pablo el 13, con D02 catálogo/«Otra» opcional y D07 LIFO del stock de subcampaña sin otra recepción. [Contrato concreto](../contrato-identidad-permisos-backend-propuesta.md) y [acta](revision-tecnica-2026-10-13.md).
- [x] Identidad/alta/perfil/roles, permisos/versiones, formatos API, fecha/zona, snapshots, comandos/cargas/retención y disciplina de concurrencia definidos en ese contrato. Esta casilla acredita revisión de diseño.
- [ ] Cotejar catálogo, funciones/constraints/fechas legadas, grants/RLS/Storage y consumidores antes de migraciones nuevas.
- [ ] Completar y revisar manifest concreto de personas/ámbitos, preservando coordinación/logística y roles internos; no conversión masiva.
- [ ] Implementar y verificar orden real de bloqueos, LIFO, idempotencia, cargas/cleanup, errores y proyecciones con entorno/fixtures identificados.
- [ ] Cerrar contratos propios CT09/10 de PA-S04: efectos por asignación/grupo, historial y dependencias especiales; sin cascada de hechos reales ni reapertura.
- [ ] Integrar UI/lecturas y registrar pruebas de autorización, stock, pérdida de respuesta, datos públicos y regresión interna. Despliegue/piloto requieren su evidencia y habilitación propias.

El punto 3 se cerró como preparación documental el 12 y D01–D12 se aceptaron como diseño el 13. PA-DI07 y cotejos concretos de catálogo/transición permanecen separados; ninguna casilla de revisión acredita una prueba ejecutada o migración aplicada.
