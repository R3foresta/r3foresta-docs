# PA-T-INT04 — Formulario participante y recuperación en frontend

**Archivo del encargo completado:** conserva el corte de pruebas previo al commit local de código `94f62a9`. [Acta, commits y pendientes actuales](cierre-pa-t-int04.md). El [tablero vigente](../implementacion/README.md) mantiene la continuación; el texto siguiente conserva los criterios originales de FE01–FE08.

**Fecha:** 17 de octubre de 2026. **Estado:** cierre técnico local de FE01–FE08, implementadas/verificadas contra D; árbol PWA sin commit/push ni despliegue de esta entrega. **Responsable:** frontend en `pwa-r3foresta`. **Incremento:** PA-F01. **Capacidades:** PA-S01 y entrada/contexto de PA-S00. [Tablero](../implementacion/README.md).

## Resultado y dependencia de backend

Integrar el registro participante de tres pasos sobre las APIs verificadas de INT03-A/D, con identidad/contexto vigentes, fotos recuperables, resumen/confirmación, recibo y detalle propio. Reutilizar formulario y capacidades/primitivas de INT06, conservando las herramientas internas autorizadas y el recorrido de reposición.

**Orden autorizado: [INT02-D](../implementacion/pa-t-int02-d.md) → INT04.** D completó BE01–BE08 en el alcance técnico local y entregó matriz de compatibilidad/DTO y entorno reproducible; la dependencia para comenzar integración local está satisfecha. [Cierre y límites D](cierre-pa-t-int02-d.md). Aplicación/cotejo SQL/Storage remotos, revisión visual INT06, WebAuthn real y piloto conservan sus evidencias separadas.

Leer [PA-S01 spec](../01-registro-plantacion-inicial/spec.md), [plan](../01-registro-plantacion-inicial/plan.md), [tareas](../01-registro-plantacion-inicial/tasks.md) y [boceto aprobado](../boceto-registro-resultado.md); [PA-S00 spec](../00-experiencia-participante/spec.md), [tareas](../00-experiencia-participante/tasks.md), [PA-S02](../02-consulta-impacto-y-registros/spec.md) y [PA-S03](../03-gestion-acceso-subcampania/spec.md). El [contrato backend aceptado](../contrato-identidad-permisos-backend-propuesta.md) §2/§4/§6/§7 fija DTO, autoridad, fechas/cargas y recuperación.

Entradas de implementación: [informe de cierre local D](../../../../../Backend-r3foresta/docs/pa-int02d-entrega-local.md), [compatibilidad D](../../../../../Backend-r3foresta/docs/pa-int02d-compatibilidad.md), [preview D para INT04](../../../../../Backend-r3foresta/docs/pa-int02d-preview.md), [cierre INT03-A](cierre-pa-t-int03-a.md), [ejemplos HTTP](../../../../../Backend-r3foresta/docs/pa-int03a-ejemplos.json), [INT06](../implementacion/pa-t-int06.md) y [módulo de participación PWA](../../../../../pwa-r3foresta/src/modules/participacion/README.md). Comprobar HEAD/árbol actual y entrega D antes de editar. Usar el launcher D con 077–080, PostGIS y objetos sintéticos en localhost:3303; el launcher A no cubre las rutas internas de la regresión D. No supone una sesión WebAuthn ni Supabase productivo.

## Entrega local — 17 de octubre

PWA `20157dc` más árbol INT04; backend `a045d9d` más árbol D. **553 pruebas/39 suites**, lint y build aprobados; **60 comprobaciones integradas** (30 registro/recuperación, 18 reposición, 12 fotos adversarias) con Chromium, API D, PostgreSQL/PostGIS y objetos privados sintéticos. Tres confirmaciones con un registro/consumo/vínculo por intención; rechazos sin efectos parciales. [Informe, versiones y reproducción](../../../../../pwa-r3foresta/docs/QA_REGISTRO_PARTICIPANTE_INT04.md).

Entrada/selector por cuenta, tres pasos, IndexedDB privado, recuperación del mismo comando y detalle propio implementados. Se retiró el contexto/FIFO legado y se adaptó el cliente de reposición sin otra pantalla. Continúan por separado SQL/Storage/corte remotos, WebAuthn, revisión humana, INT05/07/08 y piloto; no se cierran PA-S00/PA-S01 ni tareas padre de QA.

## Tareas para frontend

| Estado | ID de ejecución | Trabajo y trazabilidad | Depende de | Salida verificable |
|---|---|---|---|---|
| [x] | PA-T-INT04-FE01 | Cotejar contratos D/INT03-A y reutilización de formulario/capacidades/almacenamiento. PA-T06-FE, PA-T-ENT05-FE. | Cierre técnico local D. | Matriz de rutas/componentes, contratos runtime y cambios de cliente interno/reposición identificados. |
| [x] | PA-T-INT04-FE02 | Integrar entrada/selector/contexto por cuenta y ámbito. PA-T-ENT05-FE, PA-T06-FE. | FE01. | Solo ACTIVA con capacidad; contexto privado mínimo, saldo cero separado de permiso ausente/error; no facultades internas por contexto. |
| [x] | PA-T-INT04-FE03 | Integrar preparación y fotos con UUID estable por archivo. PA-T06-FE / PA-T04-BE consumidor. | FE01/02 y APIs de cargas. | 1–10 fotos propias, carga/preview/listado recuperables, estado y errores por archivo; original fuera de caché pública. |
| [x] | PA-T-INT04-FE04 | Implementar ubicación, especies/cantidades/fecha y observaciones en tres pasos. PA-T06-FE. | FE02/03. | GPS capturado/manual, fecha de servidor, stock por especie, retorno con datos conservados y sin selector de vivero/lote. |
| [x] | PA-T-INT04-FE05 | Integrar participantes y resumen/confirmación final. PA-T06-FE. | FE04 y participantes seleccionables. | Responsable de sesión, participantes opcionales del ámbito, resumen coherente y POST solo al confirmar. |
| [x] | PA-T-INT04-FE06 | Extender recuperación durable y comprobante/detalle propio. PA-T06-FE / PA-T-ENT05-FE. | FE03–FE05. | Mismo comando/contenido ante incertidumbre, recuperación tras recarga/cambio de sesión y estados terminales verificados. |
| [x] | PA-T-INT04-FE07 | Adaptar clientes internos afectados por D y verificar recorrido integrado. PA-T05-QA / PA-T-ENT06-QA parciales. | FE01–FE06, backend D verificado. | Navegador→API→DB con fotos/saldos/recibos, regresión de registro/reposición interna y aislamiento entre cuentas. |
| [x] | PA-T-INT04-FE08 | Entregar documentación, evidencia y cierre por capa. Tareas anteriores. | FE01–FE07 en alcance probado. | Informe PWA, guías de componentes/recuperación y ficha/tablero/ESTADO actualizados con versión/entorno/pendientes. |

### FE01–FE02 — Contratos, entrada y autoridad

Usar DTO estrictos y envelopes completos de la versión implementada; BIGINT/revisiones como cadenas sin `Number()` para IDs v1. Reutilizar cliente privado, capacidades y aislamiento de cuenta de INT06, verificando que sus hooks actuales tipados para C04–C09 se extiendan con contratos de inicial, sin casts que omitan validación.

Conservar dos experiencias sobre el mismo dominio. Cuenta sin permiso entiende cómo obtener habilitación; sesión vencida/error no se convierten en lista vacía ni abren acciones por defecto. Selección «Dónde puedo plantar» usa ACTIVA + capacidad; contexto informa `SIN_STOCK` por separado. Campaña/subcampaña permanecen visibles. Acceder por URL ajena no descarga stock/equipo. La preferencia de campaña/ámbito se separa por cuenta y no sustituye autorización. Consulta pública no espera sesión/capacidades ni cambia de destino por estas preferencias; las nuevas pantallas públicas de Impacto/Mis registros se completan en INT05.

### FE03–FE05 — Recorrido de captura aprobado

1. **Fotos y ubicación.** Preparar una identidad `comando_id` para la captura y conservarla en carga, confirmación y recuperación. Persistir actor/ámbito/comando antes de pedir preparación y el `carga_id` estable de cada archivo antes de su PUT. La respuesta de preparación se discrimina: envelope PREPARADO permite continuar; recibo terminal se concilia/muestra y no habilita nuevas cargas ni confirmación con esa clave. Mostrar subida/listado/preview y recuperación de respuestas perdidas sin upload ciego. Admitir formatos/límites D09 con validación real del backend, sin dar por cargado por generar una miniatura local. Confirmar/reajustar GPS; ante denegación o fallo, permitir coordenadas manuales accesibles además del mapa. Coordenada válida obligatoria; exterior permitido con evaluación/advertencia, separado de fallo del evaluador.
2. **Especies, cantidades y fecha.** Solo especies del contexto, saldo elegible y metas orientativas, sin selección de lote/vivero ni stock por persona. Se puede superar meta dentro del saldo. «Hoy» procede de `hoy_operativo`/zona del servidor; fecha modificable en ventana inclusiva, con restricciones finales revalidadas por backend. Observaciones opcionales hasta 2000 caracteres después de fecha y antes de continuar.
3. **Participantes, resumen y confirmar.** Responsable autenticado visible/no editable; adicionales opcionales, registrados/habilitados del mismo ámbito y sin actor duplicado. Listado paginado mínimo y revalidación del conjunto. Seleccionar personas no guarda ni multiplica cantidades. Resumen compacto con ubicación, fecha, fotos, especies/cantidades, personas y observaciones solo si tienen contenido; volver conserva datos. Botón explícito «Confirmar plantación» al final, sin cuarta pantalla ni aprobación de cada envío.

No hacer afiliación obligatoria ni añadir aviso de visibilidad pública descartado. Si se ofrece declaración específica de afiliación retroactiva, debe ser opcional y usar el DTO aceptado; su ausencia tiene representación histórica en backend y no bloquea el registro.

### FE06 — Identidad del intento, incertidumbre y detalle

La clave preparada antes de subir fotos es la que se confirma; no generar otra en el clic final. Persistir identidad/ámbito y referencias de archivos antes de preparación/PUT; antes del POST final, persistir y congelar además la intención/payload completo. Tras recarga durante captura, sin haber intentado confirmar, PREPARADO/202 permite listar cargas y reanudar edición: no es prueba de un guardado en curso ni autoriza enviar un payload incompleto. Si ya se intentó el POST final, la incertidumbre conserva ese payload y bloquea una intención nueva hasta conciliación. Cambiar sesión/logout oculta datos, sin eliminar una clave incierta ni consultarla como otro actor. Extender las primitivas de INT06 para exclusión entre pestañas y conciliación, sin un segundo motor incompatible. Archivos/UUID privados no se guardan en caché pública/service worker ni en documentos/logs de evidencia.

| Estado del servidor | Comportamiento requerido |
|---|---|
| CONFIRMADO válido | Mostrar ID/código y datos reales; misma recarga recupera el comprobante sin POST nuevo. Abrir detalle propio permitido, con observaciones solo del autor y sin contexto operativo tras retiro. |
| RECHAZADO durable | Conservar borrador permitido, explicar cambio y exigir revisión explícita; no reducir cantidades ni retirar personas automáticamente. Nueva confirmación usa clave nueva. |
| Timeout/5xx/recibo inválido/GET 202 o 404 inconcluso | Mantener clave y contenido, mostrar resultado pendiente y consultar/repetir conforme §7.3; no afirmar ausencia de efectos ni regenerar identidad. |
| PREPARACION_CANCELADA terminal | Conservar su resultado; no reabrir la preparación ni tratarla como conflicto genérico de clave. |
| Sesión vencida / permiso retirado | Recuperar sesión del actor original para conciliar; una lectura propia no concede permiso para nuevo envío. |

La estrategia backend entregada es conservar fotos locales y volver a subirlas con claves nuevas de comando/carga **solo después de rechazo terminal y nueva confirmación explícita**; no existe transferencia entre preparaciones en INT03-A. Abandono/descarte clausura preparación mediante su API antes de eliminar bytes permitidos; una carga omitida se limpia por el mecanismo del servidor, sin intentar borrar evidencias vinculadas. Si hubo envío incierto, conciliarlo antes de tratar sus fotos como abandonadas.

## FE07 — Verificación integrada y regresión

Verificar PA-S01-CA01–14 en la porción de interfaz y PA-S00-CA02–12/16–19 en lo que se integra, con frontend y backend D identificados. Cubrir responsable/participantes, meta superable dentro del saldo, fecha/ubicación manual/exterior, retorno entre pasos, observaciones, fotos inválidas/ajenas y lectura propia tras retiro. Cambios de plan/stock/participantes requieren rechazo y revisión explícita, no adaptación silenciosa.

Simular pérdida de respuesta tras commit en navegador y confirmar por DB: un registro, consumo, vínculo y recibo; recarga recupera sin otro efecto. Probar recarga/pérdida de respuesta durante preparación y PUT antes del POST final, fallo del evaluador confirmado frente a timeout, respuesta de preparación terminal, dos pestañas y cambio de cuenta. Regresión INT06 y herramientas internas: el corte de D no debe dejar al formulario interno ni a reposición enviando DTO/upload antiguos; adaptar sus clientes sin conceder permisos contextuales de reposición ni recortar gestión legítima. El rechazo del contrato legado de inicial no introduce por sí mismo un comando nuevo de reposición.

Mocks prueban estados/contratos, no reemplazan navegador→API→PostGIS/Storage de prueba. Verificar fotos/nombres/observaciones y borradores privados sin exposición entre cuentas. La ceremonia WebAuthn real, audiencias/URLs remotas, QA público completo de INT05 e INT08 conservan evidencia propia; si no se ejecutan, registrar el límite sin declararlos cumplidos.

**Consumidores concretos identificados:** `RegistrarPlantacionScreen` aún usa contexto legado/FIFO y upload al enviar; sustituir su orquestación por v1 preservando componentes reutilizables. La ruta contextual actual debe admitir VOLUNTARIO con capacidad sin abrirle el módulo interno completo. En `DetalleSubcampanaScreen.refreshPlanIndicators`, retirar la consulta obsoleta a contexto: su resultado se descarta y el 409 genera una advertencia falsa; conservar las demás lecturas de detalle/plan/campaña/métricas/resumen. No crear una pantalla de reposición nueva: adaptar y verificar el cliente interno existente. Revisar GPS manual y etiquetas accesibles para que una captura manual válida no siga mostrando «Sin señal GPS».

## FE08 — Entrega y cierre

Entregar `docs/QA_REGISTRO_PARTICIPANTE_INT04.md` con revisiones PWA/backend, entorno, casos/capturas, saldos/IDs y resultados de build/lint/tests pertinentes. Actualizar guía frontend, documentación del módulo compartido y reglas de borradores/recuperación. Actualizar ficha, PA-T06-FE/PA-T-ENT05-FE y QA solo en el alcance acreditado, tablero y ESTADO; preservar tareas padre y pendientes de INT05/07/08.

**Cierre técnico local:** FE01–FE08 implementadas/verificadas contra D, captura y recuperación reales sobre entorno aislado y regresiones aprobadas. Publicación Git, aplicación SQL, despliegue y piloto son hechos distintos. La aplicación 074–076 en desarrollo confirmada por Pablo conserva cotejo posterior pendiente; no se repite por esta ficha. El cierre D acredita su alcance backend local; INT04 acredita ahora FE01–FE08 sólo en el entorno local descrito en el [informe](../../../../../pwa-r3foresta/docs/QA_REGISTRO_PARTICIPANTE_INT04.md).
