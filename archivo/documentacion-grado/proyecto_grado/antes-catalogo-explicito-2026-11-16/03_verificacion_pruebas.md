## 3.4. Verificación y pruebas

> Parte del [Capítulo III](03_capitulo_marco_aplicativo.md). Corte documental actualizado al 16 de noviembre de 2026. Los resultados conservan las fechas, versiones y entornos de sus fuentes.

Esta sección reúne los resultados de OBJ-04 y la evidencia de verificación relacionada con la [implementación por iteraciones](03_3_fase_construccion.md). En RUP adaptado, las pruebas son una disciplina transversal que acompaña Inicio, Elaboración, Construcción y Transición. Su presentación en una sección propia permite examinar las propiedades comprobadas, los casos y los límites de cobertura dentro de esas cuatro fases.

Las iteraciones CO-1–CO-4 conservaron los cambios y comprobaciones que originaron estos resultados. La [validación y aceptación](03_4_fase_transicion.md) utiliza la evidencia técnica para evaluar los recorridos representativos y preparar la revisión del producto.

### 3.4.1. Propósito y enfoque

La verificación atendió el cuarto objetivo específico: **verificar que las funciones implementadas cumplan los requerimientos definidos y que los registros mantengan coherencia entre las cantidades y los movimientos del material vegetal**. Se examinaron pruebas de reglas y servicios, operaciones transaccionales, concurrencia, transporte HTTP, archivos e interacción desde el navegador.

La propiedad comprobada se distinguió del mecanismo utilizado. Por ejemplo, la existencia de una transacción no se tomó como prueba suficiente de integridad: se examinaron fallos y operaciones competidoras y se contrastaron los saldos y los registros resultantes. Las pruebas con servicios simulados se distinguieron de las ejecutadas contra PostgreSQL/PostGIS y de las confirmaciones aportadas por el usuario.

### 3.4.2. Resultados técnicos documentados

**Tabla 3.22**

*Resultados de verificación por entrega, versión y entorno*

| Entrega y fecha | Versión o base identificada | Resultado registrado | Entorno y alcance |
|---|---|---|---|
| INT02-D, 16–17 de octubre | base backend a045d9d más árbol D; entrega 75a57eb | 64 suites y 787 pruebas unitarias; 33 grupos SQL, 28 carreras y 25 pruebas HTTP/Storage aprobados | PostgreSQL/PostGIS y archivos sintéticos aislados; permisos, rutas equivalentes, locks y regresión compartida |
| INT04, 17 de octubre | base PWA 20157dc más árbol; entrega 94f62a9; backend D | 39 suites y 553 pruebas; lint/build y 60 comprobaciones integradas aprobados | navegador, API, PostgreSQL/PostGIS y archivos privados locales; captura, fotos, recuperación y compatibilidad |
| INT05 backend, 17 de octubre; consolidación del 19 | base 10e5dc5 más árbol; entrega 8dc8efc | 65 suites y 816 pruebas unitarias; 16 casos HTTP/SQL/Storage aprobados | entorno sintético; proyecciones públicas, agregados y consulta propia |
| INT05 frontend, 18–19 de octubre | base 6a2c955 más árbol; entrega a3a4b28 | 48 suites y 691 pruebas; lint/build y 111 comprobaciones integradas/SQL aprobados | navegación pública y propia, con regresiones de registro y acceso en entornos locales |
| guardado de plantación, 26 de octubre | backend local en puerto 3000 y PWA en 5173, identificados por el informe | 87 pruebas focales aprobadas; confirmación humana y lectura posterior de un comando CONFIRMADO vinculado al registro 13 | caso real de reintento mediante backend local; sin identificador de liberación remota en esta evidencia |
| administración de roles, 3 de noviembre | bases backend f26cbfa y PWA c684ad9 más árbol; entregas 5fb723b y 37cec4d | 1.190 unitarios backend, 1.129 pruebas frontend, 26 grupos SQL, ocho carreras, 15 HTTP y 27 comprobaciones de navegador aprobados | entorno sintético aislado; administración global y protección del último ADMIN |
| T5, 16 de noviembre | PWA c6bdec9; backend 3cb82e4 incluido en b57192c | reconstrucción inversa ADMIN del registro 20 a la asignación 53 y lote 125; historial y foto consultados | Chrome local; teléfono físico, otros recorridos y despliegue externo pendientes |

*Nota.* Elaboración propia a partir de los informes [INT02-D](../../../../../Backend-r3foresta/docs/pa-int02d-entrega-local.md), [INT04](../../../../../pwa-r3foresta/docs/QA_REGISTRO_PARTICIPANTE_INT04.md), [INT05 backend](../../../../../Backend-r3foresta/docs/pa-int05-entrega-local.md), [INT05 frontend](../../../../../pwa-r3foresta/docs/QA_IMPACTO_INT05.md), [guardado del 26 de octubre](../../../../../pwa-r3foresta/docs/QA_REGISTRO_GUARDADO_51.md) y [roles globales](../../../../../pwa-r3foresta/docs/QA_USUARIOS_ADMINISTRACION.md) y [QA T5](../../../../../pwa-r3foresta/docs/QA_T5_ITERACION_3.md), contrastados con ESTADO.md. Los conteos pertenecen a ejecuciones distintas y se solapan; no se agregaron como un total de pruebas únicas. La consolidación documental no constituyó una nueva ejecución.

INT04 comprobó, entre otros casos, una respuesta perdida después de confirmar la transacción. La consulta SQL identificó tres comandos confirmados con un registro, detalle de consumo y vínculo de fotografía por cada uno, y dos rechazos sin efectos parciales. El intento cuya respuesta se perdió consumió dos plantas una sola vez. Los ensayos conservaron los saldos del vivero, lo que respaldó la separación entre entrega física y consumo de Plantación.

INT05 comprobó en su corte de octubre la navegación sin cuenta, la lista propia por autoría o participación histórica y la separación de fotografías y datos por audiencia. Los ensayos utilizaron identidad sintética de arranque y no acreditaron una ceremonia WebAuthn real. La aplicación SQL, el catálogo del entorno destino y el despliegue conservaron sus evidencias específicas.

La regla refinada el 16 de noviembre exige autoría o participación efectiva para la consulta propia: retirar una participación mediante corrección extingue ese acceso, salvo otra relación efectiva o autoría. El original y su auditoría se conservan. Participantes085 está implementado en backend `41026ae`, pero su [evidencia HTTP](../../../../../Backend-r3foresta/docs/evidencia/pa-int07-participantes-local.json) registra `FALLIDO`. BE03/BE07 siguen parciales y la interfaz de correcciones y la aceptación integral de PA-S04 permanecen pendientes. El [contrato](../../../../../Backend-r3foresta/docs/pa-int07-participantes.md) y [ESTADO.md](../../../../ESTADO.md) conservan estos límites; INT05 no acredita por sí solo el comportamiento posterior a las correcciones.

La recepción única conserva también AUD-036: la PWA bloquea ciertas correcciones de fichas mayores de 45 días aunque mantengan su fecha original. El [QA de recepción](../../../../../pwa-r3foresta/docs/QA_RECEPCION_UNICA.md) registra la advertencia pendiente; no se declara resuelta por actualizar el requisito.

### 3.4.3. Correspondencia con los casos prioritarios

**Tabla 3.23**

*Casos de verificación y alcance de la evidencia examinada*

| Caso | Referencia | Propiedad y operación | Resultado o cobertura documentada |
|---|---|---|---|
| TC-01 | RF-REC-04 | solicitar validación sin fotografías o ubicación completas | criterio definido en el checklist M1; el expediente revisado no aportó un resultado completo para este caso |
| TC-02 | INV-01 | consumir o desechar más del saldo de Recolección | regla y contrato conservados; sin cierre individual acreditado en la matriz de CO-1 |
| TC-03 | INV-02 e INV-04 | interrumpir la transferencia M1→M2 y contrastar cantidad y unidad | contrato transaccional identificado; sin ejecución integral de fallo acreditada aquí |
| TC-04 | INV-03 | iniciar propagación con semillas en gramos | diseño y operación distinguieron entrada y saldo vivo observado; no se atribuyó una conversión entre magnitudes |
| TC-05 | RF-VIV-02A | descartar antes y después de EMBOLSADO | implementación y pruebas técnicas históricas referidas; el descarte previo y la merma conservaron tratamientos distintos |
| TC-06 | INV-05 | entregar stock y registrar una plantación parcial | INT04 cotejó consumos confirmados sin nuevo débito de Vivero; el ejemplo 100 entregadas y 60 plantadas quedó como dato de prueba ilustrativo |
| TC-07 | INV-06 | competir por el mismo saldo elegible | INT03-A/D registraron carreras SQL y comprobaciones de saldos y rollback en sus fixtures |
| TC-08 | INV-07 | contrastar total plantado y detalles por asignación | INT03-A/INT04 cotejaron registro y detalle de consumo por comando confirmado; sin atribuir ejecución a toda variante negativa |
| TC-09 | INV-08 | devolver el remanente y rechazar exceso | contrato físico y ensayos compartidos D respaldaron retorno único, saldos y ausencia de consumo indebido en los casos documentados |
| TC-10 | INV-09 | conservar interpretación histórica ante cambios de catálogo | snapshots y lecturas históricas comprobados en el alcance PA; cobertura completa de M1/M2 no acreditada por esos ensayos |
| TC-11 | INV-10 | vincular fotografías propias y rechazar las de otro intento | INT04 rechazó fotografía de otra preparación sin consumo y cotejó vínculos de confirmados; recorrido fotográfico M1→M3 no acreditado íntegramente |
| TC-12 | INV-11 | evaluar coordenadas y fallo del evaluador | INT03-A/INT04 cubrieron PostGIS y rechazo del evaluador; exterior válido con advertencia conservó la decisión PA-S01-CA10 |
| TC-13 | RDI-02 y RNF-INI-01 | actuar sin JWT, con identidad discordante o sin autoridad | guards y ensayos HTTP D y T1–T3 respaldaron rechazos en rutas cubiertas; cotejo, corte y comprobación del entorno destino permanecen pendientes |
| TC-14 | RDI-03 | reconstruir la base desde cero | fixtures y migraciones de entrega reproducidos en su alcance; replay integral y restauración de datos/archivos no acreditados |
| TC-15 | RDI-01 | iniciar el recorrido mediante incorporaciones externas | T5 acredita un recorrido ADMIN local con historial y foto; falta la evaluación integrada y de otros recorridos. La recepción directa en Plantación continúa pendiente |

*Nota.* Elaboración propia a partir de INV-01–INV-11 y RNF-INI de la Tabla 3.19, RDI-01–RDI-08, el checklist de Recolección y los informes de la Tabla 3.22. TC-01–TC-15 conservan sus identificadores. La cobertura se atribuyó al ensayo y a la propiedad efectivamente descritos, sin convertir pruebas parciales en aprobación de todos los casos.

### 3.4.4. Interpretación de los resultados

Los resultados respaldaron la consistencia de las operaciones de Plantación cubiertas: autoridad vigente, consumo de stock elegible, confirmación sin efectos parciales, vínculo de evidencia y recuperación del mismo intento. También respaldaron la separación de las consultas pública, propia e interna. La presencia de pruebas automatizadas de la PWA sustituyó la afirmación histórica de septiembre que indicaba su ausencia.

La revisión diferenció dos riesgos que ya habían cambiado de situación: la identidad de los controladores inspeccionados utilizó JWT verificado y la regla de GPS exterior contó con decisión funcional aceptada. La evaluación mantuvo los límites de entorno y del corte de autorización específica por vivero, en lugar de repetir aquellos hallazgos históricos como si continuaran sin tratamiento.

OBJ-04 contó con resultados técnicos positivos para los casos documentados y con cobertura desigual del recorrido completo. Los informes no aportaron una regresión única de todas las variantes sobre una misma versión final. La reproducibilidad integral, la recuperación conjunta de datos y archivos de RNF-INI-05 y la evaluación humana de uso de RNF-INI-06 conservaron su tratamiento residual.

### 3.4.5. Balance de salida y enlace con Transición

La construcción entregó módulos relacionados, operaciones de saldo y evidencia técnica de su integración. La revisión organizó esa evidencia por propiedad, caso, versión y entorno y dejó identificadas las diferencias entre implementación, verificación y aceptación. Ese balance constituyó la entrada documental de Transición.

El expediente de salida de IOC comprendió código y migraciones identificados, configuración, resultados de regresión, defectos conocidos y demostración del recorrido. La documentación revisada aportó cierres locales y confirmaciones parciales de entorno; la decisión global de IOC se mantuvo en el [tablero académico](../../../../documentacion-grado/02_planificacion/TODO_PROYECTO_GRADO.md#54-iteración-co-4-e-incremento-4--trazabilidad-transversal-y-versión-candidata--19-de-octubre-al-1-de-noviembre). La [sección 3.5](03_4_fase_transicion.md) presentó la evaluación de la reconstrucción y las condiciones de entrega sin convertir este cierre de redacción en aceptación del producto.
