# PA-T-INT07 — Correcciones excepcionales y reversiones auditables

**Fecha:** 22 de octubre de 2026. **Estado:** BE01 conserva la frontera de mortandad; BE02/BE03 parciales con motor, recuperación y observaciones completas verificados localmente sobre084. 084 con Success reportado y catálogo aportado cotejado el22; backend publicado y HTTP remoto pendientes. Persistencia082 cotejada en desarrollo. Participantes, cantidades, reversiones y FE01–FE08 pendientes. **Orden:** backend/DB verificado → frontend → QA integrado local. **Capacidad principal:** PA-S04, tareas PA-T17–21; integra lecturas de PA-S02 y preserva PA-S00/01/03. [Tablero](README.md).

## Resultado y fuentes

Corregir los casos admitidos sobre un registro o evento identificado, conservando original, responsable, evidencias, motivo, actor/fecha e historial. El valor efectivo, el consumo trazable, los agregados y el recibo deben coincidir en una transacción y no duplicarse por repetición. Un caso no soportado permanece sin resolver y se deriva por el canal humano; comunicarlo no cambia datos.

Leer [PA-S04 spec](../04-correccion-excepcional/spec.md), [plan](../04-correccion-excepcional/plan.md) y [tareas](../04-correccion-excepcional/tasks.md); [acta de correcciones del 12](../archivo/revision-correcciones-2026-10-12.md); [ADR-PLA-03](../../../../decisiones/02_decisiones_plantacion.md#adr-pla-03--autorizacion-operativa-por-persona-y-subcampana-para-participacion-aliada), RN-PLA-07 y reglas de saldos de [Plantación](../../../../03-plantacion-module/01_reglas_de_negocio_plantacion.md); [contrato M2→M3](../../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md). El [contrato backend D01–D12](../contrato-identidad-permisos-backend-propuesta.md) §2/4/6–8 define identidad, audiencias, snapshots, comandos, recuperación y locks ya aceptados. CT08–10 y PA-Q08–11 de las [instrucciones archivadas](../archivo/instrucciones-implementacion.md) aportan candidatos y pruebas; sus contratos específicos de PA-S04 no están aprobados en bloque.

**Inicio de BE01, 19 de octubre:** backend `8dc8efc`, árbol inicialmente limpio y migraciones hasta081. [Cotejo y contrato candidato](../../../../../Backend-r3foresta/docs/pa-int07-contrato.md) y [evidencia local](../../../../../Backend-r3foresta/docs/evidencia/pa-int07-be01-local.json): build y 65 suites/816 unitarios aprobados; cotejador de catálogo ensayado en PostgreSQL sintético aislado. P01–P03 confirmadas por Pablo: retirada del acceso propio por participación errónea, admisión histórica de cuentas inactivas y ficha pública mínima del revertido con fotos privadas. Contratos técnicos de compensación/duplicados/lecturas definidos; continúa pendiente T03, frontera del escritor real de mortandad; no hay API ni SQL de corrección disponibles. BE01 conserva su casilla abierta.

**Continuación BE02, corte histórico del19:** Pablo confirma que el alta de mortandad todavía no está implementada. [082 de persistencia privada](../../../../../Backend-r3foresta/migrations/082_pa_int07_persistencia.sql) y [evidencia local](../../../../../Backend-r3foresta/docs/evidencia/pa-int07-be02-persistencia-local.json): 159 comprobaciones PostgreSQL aisladas y regresión build/65 suites/816 unitarios aprobadas. Sin backfill, DML de servicio, comandos o API; BE02 conserva pendientes motor/recuperación/lecturas y BE06 no acredita alta/carreras de mortandad. No hay SQL remoto aplicado.

**Cotejo de desarrollo del 21:** backend `fbf2529` publicado en main; Render/local actualizados y083→081→082 ejecutadas con Success según Pablo. [Evidencia](../../../../../Backend-r3foresta/docs/evidencia/pa-int07-cotejo-desarrollo-completo-2026-10-21.json): cinco funciones081 y siete tablas/cuatro helpers082 coinciden; cierre083 sin bloqueos, lectura territorial preservada. El complemento READ ONLY confirmó 28 comprobaciones MAINTAIN sin permisos inesperados y los límites exactos de las tres secuencias. No cierra BE02 motor/recuperación/lecturas, BE03–BE08 ni INT07 funcional.

**Motor y observaciones, corte local del 21:** [Entrega y contrato consumible](../../../../../Backend-r3foresta/docs/pa-int07-motor-observaciones.md), [evidencia SQL/HTTP/concurrencia](../../../../../Backend-r3foresta/docs/evidencia/pa-int07-motor-local.json).084 amplía el motor/recuperación y publica observaciones, contexto e historial privados; detalle propio con texto efectivo. Original, grupo y stock conservados. BE02/03 siguen parciales por los demás casos/lecturas; BE04–BE08 y frontend no se cierran. Aplicación/cotejo remoto084, push y despliegue de este corte pendientes.

**Reporte y cotejo del22:** Pablo confirma ejecución de084 con Success y aporta catálogoPG17.6. [Cotejo y límites](../../../../../Backend-r3foresta/docs/evidencia/pa-int07-084-cotejo-2026-10-22.json): cinco funciones completas, dos CHECK, una secuencia y tres tablas coinciden; sin faltantes ni overloads. El registro legado conserva GPS NOT NULL y saldo generado de030, ausentes o simplificados en el fixture. No se certifica la fórmula del generado ni igualdad universal del legado. En el corte inspeccionado el backend aún no tenía commit/publicación acreditados; HTTP remoto y demás casos INT07 pendientes. No requiere repetir SQL para este cotejo.

**Versionado del22:** motor, recuperación y observaciones guardados en el commit local backend `1585b4c`; build, OpenAPI y 71 suites/950 pruebas aprobados en la [verificación previa](../../../../../Backend-r3foresta/docs/evidencia/pa-int07-084-precommit-2026-10-22.json). Push, despliegue y HTTP remoto pendientes; este versionado no cambia el alcance parcial de INT07.

## Entrega a frontend · 22 de octubre de 2026

**Se puede comenzar la interfaz de observaciones y preparar participantes contra el contrato local.** Observaciones está en el commit backend `1585b4c`, con084 aplicada según Pablo y catálogo cotejado. Participantes085 y sus lecturas están implementados en el árbol local; build y72 suites/982 pruebas aprobaron, pero su integración SQL/HTTP y revisión de migración siguen en curso. **No dar BE03 ni085 por cerradas todavía, ni asumir estas rutas desplegadas.** Antes de conectar un entorno compartido, exigir evidencia final de085, aplicación/cotejo en destino y backend compatible publicado. Cantidades, reversiones y mortandad continúan fuera del incremento consumible. Esta entrega permite iniciar FE01/FE02 y los tramos de FE03/FE04 correspondientes, sin cerrar FE01–FE08.

Fuentes de implementación: [OpenAPI1.5.0:39 rutas/84 schemas](../../../../../Backend-r3foresta/docs/pa-int02c-openapi.json), [observaciones verificadas](../../../../../Backend-r3foresta/docs/pa-int07-motor-observaciones.md), [participantes y lecturas](../../../../../Backend-r3foresta/docs/pa-int07-participantes.md), [evidencia085 en curso](../../../../../Backend-r3foresta/docs/evidencia/pa-int07-participantes-local.json). OpenAPI incluye el incremento local085; no equivale a disponibilidad remota. Las secciones anteriores conservan los cortes históricos.

### APIs y audiencias

Base `/api/v1`. IDs/revisiones son cadenas BIGINT canónicas; campos desconocidos se rechazan. Privadas: Bearer JWT verificado, cuenta activa, `Cache-Control: private, no-store`, `Vary: Authorization`. Nunca enviar actor, rol o identidad por body/headers alternativos. Impacto público no requiere cuenta.

| Método y ruta | Uso y disponibilidad |
|---|---|
| GET `/plantaciones/:id/contexto-correccion` | Contexto autorizado: original/efectivo, ámbito, estado, revisión de registro/grupo y capacidades.084 verificada;085 amplía ambos valores con participantes y añade `corregir_participantes`. |
| GET `/plantaciones/:id/historial-correcciones` | Auditoría administrativa ID DESC; cursor firmado y `limite`20/máximo50.084 observaciones;085 une participantes. |
| POST `/plantaciones/:id/correcciones/observaciones` | Operación `CORREGIR_OBSERVACIONES_PLANTACION`, solo ADMIN global.084 verificada localmente. |
| POST `/plantaciones/:id/correcciones/participantes` | Operación `CORREGIR_PARTICIPANTES_PLANTACION`, ADMIN global o administrador vigente del ámbito exacto.085 en integración. |
| GET `/plantaciones/:id/participantes-historicos-seleccionables?q=...` |085: ID exacto desde1 carácter o nombre NFC/trim3–100; literal sin distinguir mayúsculas. Incluye inactivos, excluye responsable. Solo ID, `nombre_actual`, `activo`, `relacion_historica`. Cursor firmado ASC y límite20/máximo50; no correo/username/directorio sin filtro. |
| GET `/plantaciones/:id/estado-propio` |085: estado/revisiones, cantidades originales/efectivas, participantes con procedencia y enlace. Autoría o participación efectiva, también para ADMIN. |
| GET `/plantaciones/:id/historial-propio` |085: historia reducida sin motivo ni antes/después. Cursor firmado DESC, límite20/máximo50. |
| GET `/plantaciones/mis-registros/estado` |085: estados propios deduplicados; cursor firmado DESC y límite20/máximo50. |
| GET `/impact/registros/:id/estado` |085: señal mínima pública, sin JWT incluso bearer vencido; estado, existencia de correcciones y enlaces elegibles. `no-store`, sin datos de auditoría/personas. |
| GET `/participacion/comandos/:comando_id?operacion=...` | Recuperación común por actor original.084 admite observaciones;085 añade participantes. Conserva terminal tras retiro de autoridad, con cuenta activa. |

Contexto/historial/selector administrativos requieren ADMIN global o administrador vigente de esa subcampaña. Ambos casos de escritura exigen ACTIVA, registro VIGENTE y revisión actual. Contextual recibe observaciones originales/efectivas null y `corregir_observaciones:false`; en historial OBSERVACIONES también motivo null. En PARTICIPANTES ambas autoridades ven motivo y snapshots antes/después. No deducir permisos de equipo, organización ni afiliación.

### Entradas y confirmación

Observaciones (todos los campos obligatorios):

```json
{"comando_id":"1a370000-0000-4000-8000-000000000001","revision_esperada":"0","motivo":"Corrección de transcripción","observaciones":"Texto corregido"}
```

Participantes085 (todos los campos obligatorios):

```json
{"comando_id":"1a370000-0000-4000-8000-000000000002","revision_esperada":"1","motivo":"Corregir lista histórica","coresponsable_ids":["12","9007199254740993"]}
```

Motivo NFC/trim3–1000 caracteres. Observaciones admite null o texto hasta2000; vacío normalizado equivale a null. Lista de participantes es el conjunto completo0–100, sin duplicados y responsable excluido; backend ordena IDs numéricamente. No usar Number para ordenar/transportar BIGINT. UUIDv4 nuevo solo para una intención nueva confirmada. Mostrar propuesta y motivo antes del envío.

El recibo `CORRECCION_PLANTACION` incluye caso, ID de corrección (null en SIN_CAMBIOS), objeto/ámbito, revisiones anterior/nueva de registro/grupo, cambio, estado lógico y referencia vigente. No incluye textos ni listas. SIN_CAMBIOS no crea historia ni incrementa revisión. Observaciones/participantes no cambian revisión de grupo, cantidad, stock o permisos.

### Recuperación y estados de interfaz

Conservar actor+operación+UUID+payload exacto mientras el resultado sea inconcluso. Tras timeout/5xx/respuesta perdida recuperar GET con la misma clave; no fabricar un UUID nuevo.404 `COMANDO_NO_CONFIRMADO`,503 `RESULTADO_NO_DETERMINADO` y202 no acreditan rechazo ni éxito. Respetar `reintento` y el discriminador del sobre: un HTTP de error puede llevar recibo durable RECHAZADO o error fuera de recibo inconcluso. Replay terminal se evalúa antes de nueva autorización y conserva el resultado original.

Tras terminal, refrescar contexto, historial y lecturas efectivas. `REVISION_OBSOLETA` exige nueva lectura y nueva confirmación humana antes de otra intención; no reenviar con revisión cambiada automáticamente. `SUBCAMPANIA_NO_OPERATIVA`/`OBJETO_YA_REVERTIDO` bloquean nueva escritura.401/`CUENTA_INACTIVA` requieren recuperar sesión; un cambio de cuenta no adopta la intención de otra. Clave con contenido distinto produce `COMANDO_REUTILIZADO`. Participantes085: responsable seleccionado →422 `CASO_NO_SOPORTADO`; ID inexistente →422 `PARTICIPANTE_NO_REGISTRADO`, ambos rechazos durables.

### Snapshots, privacidad y pruebas frontend

Responsable inmutable y una sola fila. Altas históricas admiten inactivos sin reactivarlos ni conceder permiso operativo. No rotular un nombre actual como histórico: el nuevo snapshot distingue `procedencia` ORIGINAL/ALTA_CORRECCION/RESTAURACION, `capturado_en` y `nombre_capturado_correccion`. INT05 conserva sus campos; en altas de corrección `nombre_snapshot:null` y afiliación HISTORICA_NO_DISPONIBLE. Restaurar reutiliza el snapshot previo exacto, aunque cambie el perfil.

P01: retirar participación elimina lectura propia salvo autoría u otra relación efectiva; restaurar la recupera. Invalidar datos propios almacenados al recibir404 o tras corrección; revalidar cada página. No reutilizar cursores entre cuentas, objetos, consultas o audiencias. Estado/historia propios no exponen motivo, observaciones ni antes/después administrativos. Mantener fotos privadas y contratos INT04/05/06.

Verificar interfaz: capacidades global/contextual; observaciones null/vacías; participante inactivo; retirada/restauración y acceso propio; responsable protegido; revisión cambiada; pérdida de respuesta y recuperación tras recarga/cuenta/pestaña; cursor alterado; ámbito cerrado; público sin sesión; ningún cambio de cantidades/métricas/fotos. Para085 esperar el resultado final del runner antes de acreditar navegador→API→DB. No crear controles funcionales de cantidades/reversiones/mortandad contra rutas candidatas.

## Base existente y cotejo requerido

| Pieza acreditada | Reutilización y límite de INT07 |
|---|---|
| Backend `8dc8efc`, PWA `a3a4b28`; [INT05 cerrada localmente](pa-t-int05.md). | Punto de partida de lectura, no implementación de correcciones. Comprobar HEAD/árbol al recibir el encargo. Push, entorno remoto y piloto siguen separados. |
| [Registro/cargas INT03-A](../archivo/cierre-pa-t-int03-a.md), [D](../archivo/cierre-pa-t-int02-d.md) y [INT04](../archivo/cierre-pa-t-int04.md). | Motor de comandos, recibos, revisión de registro, consumo y snapshots existentes. No crear un segundo registro para sustituir el original ni otro motor de recuperación. |
| [Gestión C](../../../../../Backend-r3foresta/docs/pa-int02c-entrega-local.md) / [INT06](pa-t-int06.md). | Autoridad verificada y primitivas de revisión/confirmación; ampliar el catálogo de operaciones, resultados y recuperación para correcciones. Los DTO/stores de acceso no admiten estos casos por un cast. |
| [Proyecciones SQL 081](../../../../../Backend-r3foresta/migrations/081_pa_int05_consulta.sql) y [contrato INT05](../../../../../Backend-r3foresta/docs/pa-int05-contrato.md). | Adaptar público, propio, mapa, seguimiento y aliases a hechos efectivos. Sus validadores son estrictos: coordinar cambios de contrato con la PWA y conservar compatibilidad explícita. |
| Contexto de corrección y búsqueda histórica. | Aún no existen: detalle propio exige autoría/participación y no autoriza a un administrador sobre un registro ajeno. El selector del registro inicial exige permiso actual y no sirve para corregir historia. |
| Escritores de bajas y contadores/triggers de grupo. | El cotejo local de preparación no acredita un flujo completo de alta de mortandad. Inventariar tablas, RPC, endpoints, triggers y cualquier escritor directo real antes de afirmar que comparten locks con una corrección. Un fixture de baja no demuestra ese flujo. |

## Casos confirmados y límites

**Continuación confirmada el 19 de octubre:** [PA-S04](../04-correccion-excepcional/spec.md#continuación-confirmada-el-19-de-octubre-de-2026) registra P01–P03. [Contrato y constancia](../../../../../Backend-r3foresta/docs/evidencia/pa-int07-be01-decisiones.json): decisiones de producto aceptadas, contratos técnicos definidos y frontera de mortandad aún abierta; no acredita API/SQL implementados.

Todas las escrituras de esta entrega se limitan a subcampaña **ACTIVA**, también para ADMIN global. Actor desde JWT/cuenta activa y autoridad vigente, revalidados al ejecutar; autoría, equipo logístico o afiliación no conceden capacidad de corregir.

| Caso | Quién ejecuta | Condiciones y efecto exigido |
|---|---|---|
| Observaciones | ADMIN global. | Campo acotado, motivo y antes/después; sin cambiar cantidades, stock, responsable o estado. No extender la facultad a otros textos, fecha o GPS. |
| Participantes | ADMIN global o administrador de esa subcampaña. | Añadir, retirar o restituir participación real de personas registradas; no exigir permiso operativo actual del participante. Conservar responsable y listas anterior/nueva; no cambiar cantidades/stock ni conceder permisos. La restricción de bajas/reposiciones del ajuste de cantidad no se extiende a este caso. |
| Cantidades | Las mismas dos autoridades. | Registro inicial sin bajas ni reposiciones; mismas especies y cantidades efectivas positivas. Aumento consume solo diferencia elegible; reducción requiere confirmar error y disponibilidad física de la diferencia, restituyendo consumo trazable en subcampaña. |
| Duplicado | Las mismas dos autoridades. | Referencia distinta a registro válido compatible; revertir lógicamente solo el duplicado y compensar su consumo efectivo una vez. Mantener ambos originales y un registro vigente, sin referencias circulares. |
| Plantación que no ocurrió | Las mismas dos autoridades. | Reversión lógica del registro erróneo, exclusión efectiva y compensación trazable; rechazar dependencias incompatibles. La persona administradora responde por el caso/motivo: no crear un sistema adicional de verificación del trabajo. |
| Baja registrada por error | Las mismas dos autoridades. | Revertir solo mortalidad efectiva del evento, recalcular el grupo y conservar el original; no liberar stock disponible para plantar. No anular una muerte real. |
| Reposición registrada por error | Las mismas dos autoridades. | Revertir aporte efectivo al grupo y consumo hacia sus asignaciones de **REPOSICION**; no trasladarlo a stock inicial ni devolverlo al vivero. Preservar origen y demás hechos reales. |

Fecha/GPS y otros campos sin tratamiento aprobado se identifican como no soportados. Quedan fuera cambio de especies/responsable, cero como ajuste simple, reapertura, borrado físico de originales/fotos, cascada de hechos reales, editor genérico, tickets y segunda aprobación central por defecto para las correcciones contextuales admitidas. Corregir consumo nunca modifica entrega, devolución física, merma física o saldo de Vivero; tampoco concede crear bajas/reposiciones por tener autoridad para corregir un evento erróneo.

## Contratos propios que BE01 debe concretar

Este apartado fija salidas de diseño verificables, sin presentar candidatos como APIs ya disponibles. Registrar el contrato resultante en `Backend-r3foresta`, junto a DTO/OpenAPI y ejemplos; referenciarlo desde esta ficha antes del código dependiente. Una decisión de producto ausente se plantea de forma concreta antes de programar ese comportamiento, conservando los acuerdos de la tabla anterior.

| Tema pendiente | Definición exigida antes de implementar el caso |
|---|---|
| Contexto, localización e historial privados | Lecturas mínimas por registro/evento exacto, ámbito, caso, original/efectivo, revisión y dependencias. Capacidades explícitas por caso; lectura no reserva autoridad, versión ni saldo. Definir qué campos ve cada ejecutor sin abrir perfiles, evidencia privada o detalle propio ajeno por conveniencia. |
| CT08–10 y comandos | Concretar rutas v1 de cantidad/participantes/observaciones y reversiones de registro/evento; no PATCH libre ni despacho de RPC desde strings del cliente. Entrada estricta con `comando_id`, `revision_esperada`, motivo y campos específicos; actor, tipo real del objeto y asignaciones/efectos se derivan en servidor. ID/revisión BIGINT como cadenas. Para duplicados fijar referencia válida y revisiones de todos los objetos cuya vigencia se confirma. |
| Original, efectivo y auditoría | Cotejar `revision_registro` existente, versiones de eventos/grupo y triggers. Definir representación de estado lógico, revisiones y líneas de compensación, vínculo al comando y valores anteriores/nuevos. No sobrescribir original ni guardar cero/mortandad negativa para eludir CHECK. Incrementar la revisión pertinente de manera atómica; concretar SIN_CAMBIOS sin fabricar efectos/historia. |
| Distribución y compensación | Definir elegibilidad por especie/propósito, fecha histórica y asignación, distribución del aumento, orden de liberación parcial y correcciones sucesivas. D07 fija LIFO de inicial; no aprueba automáticamente una política de reversión. «Liberar líneas más recientes primero» sigue siendo candidata. Restituir solo consumo efectivo pendiente de cada asignación; validar devoluciones/inactivaciones y rechazar íntegro cuando no sea reversible. |
| Dependencias y contadores | Definir qué impide corregir/revertir cada objeto, coherencia de saldo vivo y contribuciones efectivas al grupo. Cotejar los escritores reales de mortandad/reposición y las consultas internas de plan, cierre/cancelación y stock que usan esos contadores; no permitir que un trigger vuelva a sumar un original revertido ni introducir transiciones nuevas. No tratar como inexistentes los hechos dependientes que solo se ocultaron. |
| Participación histórica y snapshots | Búsqueda mínima autorizada que no reutilice elegibilidad operativa del registro inicial; precisar tratamiento de cuentas históricas inactivas, altas/retiros/restauraciones y su procedencia. Definir quién conserva/adquiere lectura propia tras corregir la lista y qué muestra cada audiencia. No deducir permisos de esa relación ni copiar afiliación actual como si fuese la del día del hecho. |
| Lectura efectiva, historial y fotos | Matriz público/propio/ejecutor: valores efectivos, señal de cambio y actor según audiencia; sin motivos libres, observaciones, contactos o saldos en público. Precisar enlaces de originales revertidos, historia autorizada y elegibilidad de sus fotos sin borrar evidencia. Recibos originales siguen mostrando lo confirmado entonces; contexto/detalle posteriores muestran la versión efectiva. |
| Recuperación, errores y compatibilidad | Ampliar juntos CHECK/catálogos SQL, canonicalizador, resultado por operación, `GET` de recuperación y validadores TS. Recibo mínimo sin motivo libre/observaciones/perfiles; rechazo durable distinto de timeout/202/404 inconcluso. Replay terminal propio precede a nueva autorización; retirada posterior no cambia un recibo ni habilita otra escritura. Definir errores de versión, dependencia, reversión ya aplicada, saldo y caso no soportado; HTTP/DTO exactos en ejemplos. |

El inventario de BE01 debe identificar las migraciones nuevas necesarias según la numeración real posterior a 081, sin reservarla aquí ni modificar SQL ya aplicado. La implantación de estos contratos es trabajo de los repositorios de aplicación; preparar esta ficha no acredita su aceptación integral, código o aplicación remota.

## Tareas para backend/DB

Cada implementación incluye sus comprobaciones de política/contrato y efectos; BE08 concentra las carreras, regresiones y la entrega integrada. No marcar una casilla por documentar una intención o pasar un caso aislado.

| Estado | ID de ejecución | Trabajo y trazabilidad | Depende de | Salida verificable |
|---|---|---|---|---|
| [ ] · en curso | PA-T-INT07-BE01 | Cotejar esquema/escritores/consumidores y cerrar matriz de casos, audiencias y contratos específicos anteriores. PA-T17-REV, PA-T20, preparación de PA-T18-BE/DB. | Fuentes y base acreditada; PA-DI07 en su parte pendiente. | Contrato por caso, compensaciones por asignación/grupo, matriz original/efectivo/historial, errores/recibos y dependencias; decisiones técnicas distinguidas de acuerdos humanos, faltantes concretos visibles. |
| [ ] · parcial | PA-T-INT07-BE02 | Extender persistencia de corrección y motor común; implementar política por caso, capacidades, contexto/historial privado y búsqueda histórica mínima. PA-T18-BE/DB. | BE01 para las superficies afectadas. | Migraciones aditivas repetibles, versiones/historial/compensaciones y recibos protegidos; catálogo de operaciones/recuperación completo, actor verificado y proyecciones mínimas sin acceso SQL público raw. |
| [ ] · parcial (observaciones local) | PA-T-INT07-BE03 | Implementar observaciones centrales y participantes históricos por las autoridades admitidas. PA-T18-BE/DB y PA-T20. | BE02 y contrato de búsqueda/snapshots/audiencias. | Antes/después y motivo/actor/fecha atómicos; responsable, cantidades, stock y permisos intactos; alta/retiro/restauración histórica sin exigir permiso operativo actual ni inventar afiliación pasada. |
| [ ] | PA-T-INT07-BE04 | Implementar aumento/reducción de cantidades por especie. PA-T18-BE/DB y PA-T20. | BE02 y contrato de distribución/compensación. | Sin bajas/reposiciones, sin cambiar especies, saldo suficiente y confirmación física requerida al reducir; consumo efectivo, versión e historial juntos, sin modificar M2 ni liberar dos veces. |
| [ ] | PA-T-INT07-BE05 | Implementar reversión de duplicado y plantación inicial errónea. CT09, PA-T18-BE/DB, PA-T20. | BE02/04 y representación efectiva definida. | Originales/fotos conservados; referencia válida del duplicado verificada bajo locks; consumo pendiente compensado una vez; rechazo íntegro por dependencia o referencia incompatible/circular. |
| [ ] | PA-T-INT07-BE06 | Implementar reversiones diferenciadas de baja y reposición erróneas. CT09/10, PA-T18-BE/DB, PA-T20. | BE02 y escritores/dependencias de grupo cotejados. | Baja revierte solo mortalidad; reposición revierte aporte/consumo a REPOSICION; grupos coherentes, sin cascada ni stock físico ficticio. Concurrencia acreditada con los escritores reales, no solo con fixtures. |
| [ ] | PA-T-INT07-BE07 | Integrar lecturas efectivas e historial por audiencia, contadores y consumidores internos/públicos. PA-T19-INT, PA-T07-BE/DB, PA-T08-BE, PA-T09-DB. | BE03–BE06 en el alcance entregado. | Impacto/mapa/seguimiento/aliases/Mis registros/detalle/contextos sin doble conteo; recibo original intacto, privacidad/fotos elegibles y validadores/versionado compatibles. Plan, stock, cierre y mantenimiento conservan sus reglas. |
| [ ] | PA-T-INT07-BE08 | Verificar SQL/HTTP/concurrencia, regresiones y entregar contrato/entorno a frontend. PA-T21-QA y QA parcial de PA-S01/02/03. | BE01–BE07 verificadas. | Matriz CA01–18/participantes y PA-Q08–11, saldos por asignación/grupo, ambos órdenes de carrera y rechazos sin efecto parcial; build/unitarios, OpenAPI/ejemplos y fixture sintético reproducible, versiones y pendientes documentados. |

### Garantías transaccionales y de privacidad

Seguir el orden de locks vigente de D y §8 del contrato común: cuentas/organizaciones implicadas → campaña cuando corresponda → subcampañas → comando → permisos/revisiones → registros/eventos → asignaciones; omitir solo etapas no usadas y no volver a una anterior. Adquirir IDs de cada etapa en orden estable. Resolver scopes en servidor y releerlos bajo lock. El replay terminal rápido conserva prioridad y contenido histórico. Corregir consumo de subcampaña no requiere modificar lotes M2.

Revalidar ámbito, ACTIVA, autoridad y revisión al ejecutar. Efectos, auditoría, revisiones y terminal van en una transacción; fallo inesperado o de locks no fabrica rechazo durable. Ampliar el catálogo SQL/TS sin debilitar operaciones anteriores. RLS/grants/helpers/overloads nuevos se limitan a objetos necesarios de esta entrega y al servicio backend; revisar que no abran tablas, comandos, historial o stock a `PUBLIC`/`anon`/`authenticated`.

La exclusión cooperativa solo es garantía si participan todos los escritores equivalentes. Si falta un escritor o trigger de mortalidad en el catálogo inspeccionado, registrarlo y resolver su frontera dentro del alcance antes de declarar segura la operación afectada; no reconstruir un módulo completo de mantenimiento como cambio implícito ni habilitar una carrera no protegida. Mantener las facultades internas vigentes de GENERAL/VALIDADOR/equipo; la corrección contextual no las sustituye ni amplía.

## Tareas para frontend

Integrar con BE01–BE08 verificadas y contrato/fixture entregados. Bocetos y revisión de componentes pueden prepararse en paralelo; no acreditar correcciones con mocks ni empezar a enviar comandos candidatos.

| Estado | ID de ejecución | Trabajo y trazabilidad | Depende de | Salida verificable |
|---|---|---|---|---|
| [ ] | PA-T-INT07-FE01 | Cotejar contrato, DTO runtime, errores, capacidades e integración de comandos/lecturas. PA-T18-FE, preparación de PA-T19-INT. | Entrega backend BE08. | Matriz de rutas/componentes/audiencias y fixtures HTTP sintéticos reales; incompatibilidades de validadores INT04/05/06 resueltas sin casts que omitan campos/operaciones. |
| [ ] | PA-T-INT07-FE02 | Integrar entrada/revisión por registro o evento exacto, contexto e historial permitidos. PA-T18-FE. | FE01 y lecturas autorizadas. | Original/efectivo, ámbito, revisión, dependencias y acciones por caso; admin de registro ajeno usa contexto específico, no detalle propio abierto. Carga/vacío/error/no visible y caso no soportado distintos. |
| [ ] | PA-T-INT07-FE03 | Extender recuperación durable, confirmación y aislamiento por cuenta/pestañas para cada operación nueva. PA-T18-FE. | FE01 y catálogo común ampliado. | Identidad/actor/ámbito/revisión/payload congelados antes de POST; timeout/202/404 inconcluso conserva clave/contenido y consulta; terminal, rechazo y nueva confirmación diferenciados; recuperación posible tras retiro sin conceder escritura. |
| [ ] | PA-T-INT07-FE04 | Integrar formularios acotados de observaciones y participantes históricos. PA-T18-FE. | FE02/03. | Autoridades distintas por caso, listas anterior/propuesta y motivo; búsqueda histórica mínima, sin cambiar responsable o exigir permiso actual de la persona histórica. No presentar afiliación actual como snapshot del trabajo. |
| [ ] | PA-T-INT07-FE05 | Integrar «Corregir cantidad». PA-T18-FE. | FE02/03 y BE04. | Valor efectivo/propuesta por especie, diferencia y disponibilidad del servidor; confirmación explícita de error y disponibilidad física al reducir. Sin selector de vivero/asignación, cambio de especie ni recalcular distribución en la PWA. |
| [ ] | PA-T-INT07-FE06 | Integrar confirmaciones específicas de duplicado, plantación/baja/reposición erróneas. PA-T18-FE. | FE02/03 y BE05/06. | Duplicado identifica original y registro que permanece; cada caso explica su efecto: baja no libera stock, reposición compensa REPOSICION. Motivo, conservación del original, dependencia rechazada y resultado recuperable visibles. |
| [ ] | PA-T-INT07-FE07 | Integrar resultado efectivo e historial en consultas y navegación existentes. PA-T19-INT, PA-T08/09-FE. | BE07 y FE04–FE06. | Global/campaña/subcampaña/mapa/detalle/Mis registros coherentes tras confirmar; enlace revertido e historial según contrato; no doble conteo, motivos/observaciones fuera del público y recibos anteriores conservados. |
| [ ] | PA-T-INT07-FE08 | Verificar recorrido navegador → API → datos y entregar evidencia/documentación. PA-T21-QA y QA parcial PA-S00/01/02/03. | FE01–FE07 y fixture backend identificado. | CA01–18/participantes, cuentas/pestañas, respuesta perdida, revisión/autoridad cambiadas y regresión INT04/05/06; resultados/capturas/saldos y versiones. Revisión humana, WebAuthn y remoto separados. |

Reutilizar transporte privado, `commandLifecycle`, coordinación entre pestañas y patrones de revisión/confirmación de INT04/INT06. Sus hooks/stores de acceso tienen operaciones cerradas: extender mediante tipos/validadores/adaptadores de corrección, sin disfrazarlas de un comando de permisos ni crear otro motor de incertidumbre. Invalidar la propuesta confirmable al cambiar objeto/caso/contenido; no renovar silenciosamente una revisión obsoleta dentro de un reenvío. Conservar borradores privados por cuenta y no volcar motivos/payloads privados en caché pública o evidencias de QA; usar únicamente datos sintéticos en las pruebas.

## Matriz mínima de verificación y entrega

| Grupo / trazabilidad | Evidencia requerida |
|---|---|
| Autoridad/campos · CA01–03/11/18 | ADMIN global, administrador propio/ajeno, autor/plantador y visitante; ACTIVA frente a cerrada; observaciones centrales, prohibición de campos extra y contexto ajeno sin filtraciones. |
| Cantidad · CA05/09–13, PA-Q08 | 10→12 con saldo5 deja3; 12→10 libera2 solo con confirmación física. Multiespecie, varias asignaciones, aumento/reducción sucesivos, insuficiencia y fecha/propósito/inactivación/devolución incompatibles conforme al contrato. Entrega/Vivero intactos. |
| Participantes · casos adicionales de PA-S04 | Alta/retiro/restauración por ambas autoridades, persona histórica sin permiso actual, snapshots/procedencia, lista anterior/nueva e historial visible; responsable/stock/accesos intactos. Probar lectura propia tras corrección según matriz de audiencia. |
| Duplicado/inexistente · CA14/15, PA-Q09 | Entrega100, dos registros30: reversión deja total30/disponible70. Repetición no libera otra vez; correcciones previas no se compensan dos veces. Referencia ajena, inválida, circular y dos reversiones opuestas no dejan un duplicado sin original válido. |
| Baja/reposición · CA06/16–18, PA-Q10 | Baja4 errónea revierte mortalidad sin liberar stock; reposición5 errónea libera solo su consumo efectivo a REPOSICION. Rechazar dependencias reales incompatibles y conservar eventos/origen/evidencia. |
| Repetición/versión/carreras · CA04/12/18 | Misma clave/mismo contenido, clave reutilizada, nueva clave sobre objeto revertido, dos correcciones de una revisión, duplicados cruzados; ambos órdenes con baja/reposición, retiro/cambio de rol/baja de cuenta, cierre, plan, consumo y devolución. PostgreSQL real aislado y barreras/locks observados, no solo secuencias HTTP. |
| Incertidumbre · CA04/08 | Respuesta perdida después del commit recupera el mismo recibo sin otro efecto; recarga/cuenta/pestaña/sesión vencida conserva actor/intención. Timeout/5xx/202/404 no producen otra clave ni corrección supuestamente aplicada. Caso no soportado sigue sin resolver. |
| Lectura/regresión · CA07, PA-Q11 | Totales/listas/mapa/seguimiento efectivos, tres personas/dos organizaciones sin multiplicación, afiliaciones históricas y legacy incompleto; recibo original distinto de versión efectiva. Público sin sesión, fotos elegibles y ningún motivo/contacto/stock filtrado. Registro, acceso, plan, cierre, entregas/devoluciones y reposición interna conservados. |

Backend entrega contrato definitivo/OpenAPI, ejemplos de cada caso y error/recuperación, migraciones/ACL/overloads, fixture sin servicios externos, instrucciones de arranque/reset y evidencia con revisiones, entorno, objetos y saldos antes/después. Frontend entrega guía de acciones/estados, capturas y resultados del recorrido integrado sobre esa versión. Mantener las evidencias originales D/INT04/INT05 y guardar las nuevas regresiones por separado; pruebas de esos cierres no acreditan correcciones.

Si falta contrato o cobertura de un caso crítico, registrar entrega parcial y su pendiente; no cerrar PA-S04/INT07 completas por implementar solo observaciones o una reversión feliz. Al cerrar, actualizar casillas, PA-T17–21 y las tareas afectadas de consulta/QA, este tablero y [ESTADO](../../../../ESTADO.md); archivar encargo/cierre con versiones y entorno. Revisión humana, aplicación/cotejo SQL/Storage remoto, push, despliegue/corte y decisión de piloto INT08 se acreditan aparte. Este encargo documental no inicia implementación en los repositorios de aplicación ni autoriza corregir registros reales.
