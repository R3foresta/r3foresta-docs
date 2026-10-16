# Ejecución de PA-F01

**Corte:** 15 de octubre de 2026. **Ejecución actual:** [PA-T-INT06](pa-t-int06.md) con FE01–FE05 implementadas/verificadas localmente sobre [INT02-C](pa-t-int02-c.md); FE06 parcial y UI revisable, sin revisión humana acreditada. C tiene BE01–BE06 y entorno local verificados; 072/073 confirmadas y superficie REST comprobada, cuerpos SQL remotos y despliegue externo pendientes. B conserva catálogo complementario y correspondencia real pendientes. C anticipó motor común sin fotos; INT03-A ya verifica registro/cargas localmente; formulario INT04, carreras D, Impacto/INT05, WebAuthn y QA integrado/piloto continúan pendientes. [Informe PWA](../../../../../pwa-r3foresta/docs/QA_GESTION_ACCESOS_INT06.md). [Evidencia general](../../../../ESTADO.md).

**Entrega local backend:** [PA-T-INT03-A](pa-t-int03-a.md), BE01–BE08 verificadas sobre B/C con 074–076 y 22 grupos SQL/PostGIS, 10 carreras y 16 HTTP/Storage. [Informe](../../../../../Backend-r3foresta/docs/pa-int03a-entrega-local.md). INT04 puede integrar el launcher sintético; INT02-D conserva corte/rutas equivalentes y la puerta de habilitación real. La revisión humana INT06 sigue separada.

## Cómo se conectan specs y entregas

`PA-F01` es el incremento Participación aliada en Plantación. `PA-S00`–`PA-S04` describen capacidades del producto. Los IDs `PA-T-ENT*` y `PA-T01`–`PA-T21`, con sus sufijos, son tareas por capacidad. `PA-T-INT*` agrupa esas tareas en entregas que se pueden integrar y verificar. Se conserva cada ID.

**INT02-B pertenece principalmente a PA-S03 (acceso)** y prepara la autorización que necesitan PA-S00 (entrada) y PA-S01 (registro). El usuario y su perfil son transversales, pero su uso en este incremento sigue bajo PA-F01. La afiliación a una organización es opcional; no es el ámbito que otorga permisos.

## Encargos por equipo

| Equipo / repositorio | Ficha y tareas específicas | Cuándo ejecutar | Qué entrega |
|---|---|---|---|
| Backend/DB · `Backend-r3foresta` | [INT02-B: BE01–BE07](pa-t-int02-b.md#tareas-para-backenddb) | Ahora, tras comprobar revisiones y catálogo. | Migraciones/FKs, privilegios, manifest de transición y ensayo aislado reproducible. |
| Backend/DB · `Backend-r3foresta` | [INT02-C: BE01–BE06](pa-t-int02-c.md#tareas-para-backenddb) | BE01–BE06 verificados localmente sobre B y motor sin fotos anticipado aquí; entorno sintético persistente disponible. Integración local con INT03-A verificada; cotejo remoto pendiente. | Capacidades, miembros, búsqueda/revisión, C04–C09 y roles/baja; OpenAPI/ejemplos y evidencia local disponibles. |
| Backend/DB · `Backend-r3foresta` | [INT03-A: BE01–BE08](pa-t-int03-a.md#tareas-para-backenddb) | BE01–BE08 verificadas localmente sobre B/C; PostGIS y objetos sintéticos reales. Sin aplicación remota ni habilitación real. | Contexto, cargas recuperables, registro atómico LIFO/snapshots, recibo/detalle propio y contrato para INT04. |
| Frontend · `pwa-r3foresta` | [INT06: FE01–FE06](pa-t-int06.md#tareas-para-frontend) | FE01–FE05 implementadas/verificadas localmente sobre C; FE06 parcial, con QA integrado sujeto a D y al resto del recorrido. | Gestión contextual, selección/confirmación y recuperación; evidencia local navegador → API → DB, sin revisión humana de UX ni cierre de QA/piloto. |

**Primero backend y después integración frontend.** B aporta persistencia; la PWA consume las APIs de C. El plan situaba INT03-A como primer consumidor del motor; C anticipó su parte sin fotos e INT03-A la extiende ahora con registro/cargas verificados localmente. D completa la autorización y las carreras compartidas antes de habilitar el recorrido participante. La entrada/selector de PA-S00 y el formulario continúan en INT04; Impacto/Mis registros en INT05.

Los IDs BE/FE son subtareas de ejecución de su entrega; las fichas enlazan los IDs de capacidad originales. Las casillas detalladas se mantienen en cada ficha y el avance resumido en este tablero. Preparar el encargo o pasar un caso aislado no completa la entrega ni su tarea padre.

## Orden y avance

| Entrega | Qué integra / tareas relacionadas | Estado al corte |
|---|---|---|
| PA-T-INT01 | Preparación técnica de todas las specs; PA-T-ENT02, PA-T12-REV/PA-T15. | Contrato D01–D12 e inventario estático completados. Catálogo y transición concretos se comprueban por entrega. |
| PA-T-INT02-A | PA-S00: parte de ENT04-BE/DB y ENT05-FE/ENT06-QA; PA-S03: base de identidad de PA-T12-BE. | **Completada** en identidad/alta/perfil, privacidad e integración de desarrollo. [Cierre y límites](../archivo/cierre-pa-t-int02-a.md). |
| [PA-T-INT02-B](pa-t-int02-b.md) | PA-S03: PA-T12-DB, cotejo PA-T12-REV/PA-T15 y preparación de PA-T13-DB. PA-S00: parte pendiente de ENT02/ENT04-DB. Ejecución: BE01–BE07. | **Parcial · base local implementada y ensayada.** 068–071, bootstrap/manifest sintéticos, 53 casos DB/78 denegaciones y 594 pruebas backend. 068–071 confirmadas y SQL compacto/REST cotejados en PG17.6; BE01 complementario y BE05 real pendientes. Base para iniciar INT03-A. [Informe](../../../../../Backend-r3foresta/docs/pa-int02b-entrega-local.md). |
| [PA-T-INT03-A](pa-t-int03-a.md) | PA-S01: PA-T02/03-BE y PA-T04-BE/DB; QA parcial PA-T05/PA-T16. Ejecución: BE01–BE08. | **Verificada localmente · BE01–BE08.** 074–076, diez rutas nuevas, registro LIFO/snapshots/cargas/recuperación; 22 grupos SQL/PostGIS, 10 carreras y 16 HTTP/Storage. Launcher INT04 disponible; backend publicado en `main` (`a045d9d`, 16 de octubre). [Informe](../../../../../Backend-r3foresta/docs/pa-int03a-entrega-local.md). SQL remoto/conciliación real y habilitación D pendientes. |
| [PA-T-INT02-C](pa-t-int02-c.md) | PA-S03: PA-T12-BE, PA-T13-BE/DB y PA-T14-BE; PA-S00: capacidades/roles/baja de ENT04-BE/DB. Ejecución: BE01–BE06. | **Verificada para integración local · BE01–BE06. Cotejo/despliegue remoto pendientes.** 14 rutas, 22 grupos DB/8 carreras, 13 HTTP y 636 unitarias. 072/073 confirmadas y REST 35/35; entorno sintético local con ocho perfiles/30 comprobaciones HTTP; aplicación completa/Supabase 18 probes y cotejador SQL 26 pruebas. Integración local INT03-A verificada; cuerpos SQL remotos y despliegue externo pendientes. [Informe](../../../../../Backend-r3foresta/docs/pa-int02c-entrega-local.md). |
| PA-T-INT02-D | Políticas, rutas equivalentes y locks compartidos de PA-S00/01/03; PA-T16-QA y parte de INT08. | Pendiente en alcance completo. INT02-A adelantó el cierre de privacidad; falta autorización por objeto y concurrencia con plan/stock/logística/cierre. |
| PA-T-INT04 | PA-S01: PA-T06-FE y entrada pendiente de PA-S00: ENT05-FE. | Pendiente. Formulario participante con recuperación y contratos v1. El registro interno anterior se reutiliza. |
| PA-T-INT05 | PA-S02: PA-T07-BE/DB, PA-T08/09-FE, PA-T10/11; navegación pública de PA-S00. | Pendiente como entrega participante completa. Las regresiones públicas existentes de INT02-A no completan Impacto/Mis registros. |
| [PA-T-INT06](pa-t-int06.md) | PA-S03: PA-T13-UX, PA-T13/14-FE y QA parcial PA-T16; coordinación con ENT05-FE de PA-S00. Ejecución: FE01–FE06. | **FE01–FE05 implementadas/verificadas localmente; FE06 parcial.** PWA `cf130365` más árbol, backend `57e5b715` más árbol C y docs `89dfdb2` más árbol. UI revisable; revisión humana no acreditada. [Informe/evidencia](../../../../../pwa-r3foresta/docs/QA_GESTION_ACCESOS_INT06.md). Pendientes D, integración del registro/cargas en INT04, Impacto/WebAuthn, entorno externo y QA integrado/piloto. |
| PA-T-INT07 | PA-S04: PA-T17–21 y sus desgloses. | Pendiente. Casos de corrección y efectos propios por cerrar/verificar; D01–D12 no los aprueban en bloque. |
| PA-T-INT08 | ENT06-QA, PA-T05-QA, PA-T11-QA, PA-T16-QA y QA de PA-S04. | Pendiente para PA-F01 completo. Ensayo de corte, QA integrada, despliegue y decisión de piloto. |

INT02 agrupa A/B/C/D: cerrar A no completa INT02. El orden backend aceptado fue **B → INT03-A → C → D**, con bocetos y preparación de frontend/correcciones cuando sus contratos lo permitan. La ejecución de C anticipó solo el motor sin fotos; INT03-A acredita ahora registro/stock/cargas en entorno aislado; ese avance no acredita D ni aplicación remota. Las interfaces INT04/05/06 integran sus contratos verificados; INT06 ya integra localmente las APIs verificadas de C en FE01–FE05, mientras FE06 conserva evidencia parcial y D sigue siendo requisito para la habilitación y QA completo del recorrido. Las garantías críticas de autorización, retirada, último administrador y recuperación deben estar verificadas antes de habilitar el registro participante real.

## Qué parte de las specs está implementada

| Spec / tareas | Cobertura acreditada | Qué falta para cumplirla |
|---|---|---|
| [PA-S00 · Entrada y perfil](../00-experiencia-participante/tasks.md) | A: identidad/alta/perfil y navegación. C: capacidades/autoridad administrativa verificadas por HTTP/DB local. INT06: cliente compartido de capacidades/entrada a gestión y aislamiento de cuenta implementados/verificados localmente. | Cotejo y entorno remoto C; entrada/registro participante INT04, Impacto público completo, WebAuthn del nuevo recorrido y QA integrado. No se cierra ENT05/ENT06 completo. |
| [PA-S01 · Registro inicial](../01-registro-plantacion-inicial/tasks.md) | INT03-A: contexto, registro inicial, cargas, LIFO, snapshots, recibo/detalle propio y pruebas aisladas sobre B/C. | Formulario INT04, aplicación/conciliación remota, corte/regresiones D y QA completo. |
| [PA-S02 · Consulta](../02-consulta-impacto-y-registros/tasks.md) | Comportamiento aprobado; APIs públicas existentes conservadas en el QA de INT02-A. | Proyección completa por audiencia, snapshots, Mis registros y pantallas/enlaces públicos PWA; INT05. |
| [PA-S03 · Acceso](../03-gestion-acceso-subcampania/tasks.md) | Diseño/A, base 068–071 B y gestión C local: capacidades/búsqueda/miembros, C04–C09, rol/baja, atomicidad/replay y continuidad concurrente. INT06-FE01–FE05: interfaz de gestión y recuperación implementada/verificada localmente; FE06 parcial. | Revisión humana de UX, cotejo complementario/transición real B; cuerpos SQL/despliegue/entorno C, integración frontend INT04, regresiones D y QA integrado, incluido Impacto/WebAuthn. [INT06](pa-t-int06.md) no completa PA-S03 ni el piloto. |
| [PA-S04 · Correcciones](../04-correccion-excepcional/tasks.md) | Acuerdos parciales confirmados. | Cierre de casos/contratos propios e implementación INT07 con evidencia de efectos e historial. |

La implementación sigue las specs por partes. El seguimiento anterior hace explícita la cobertura; ninguna spec se declara completada por tener un plan o por cerrar INT02-A.

## Fuentes para ejecutar

1. Ficha de la entrega: alcance, dependencias, tareas y salida verificable.
2. `spec.md` y `tasks.md` de las capacidades indicadas; `plan.md` para responsabilidades.
3. [Contrato backend aceptado](../contrato-identidad-permisos-backend-propuesta.md): §3–5 identidad/permisos, §6–8 registro/comandos/locks, §9 transición, §10 aceptación, §11 secuencia.
4. [Inventario de endpoints](../inventario-endpoints-y-regresion-participacion.md): mapa estático del 13 de octubre; contrastar contra el código actual antes de modificar rutas.

El [archivo](../archivo/README.md) conserva las actas y el plan técnico anterior con referencias a código, PA-DI, PA-CT y PA-Q. Se consulta para el detalle citado; el siguiente trabajo se mantiene en este tablero.

Al cerrar una entrega, actualizar las casillas de su ficha, esta tabla y las tareas de capacidad afectadas; enlazar código/pruebas/SQL con versión y entorno desde `ESTADO.md` y archivar su encargo/cierre. Una base técnica ensayada con manifest real aún pendiente se registra como cierre parcial; no acredita transición aplicada. La publicación Git, el despliegue y el piloto conservan evidencias separadas.
