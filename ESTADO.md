# Estado de implementación

**Corte documental:** 19 de octubre de 2026. Registra implementación acreditada por capa y entorno. El [estado previo a esta consolidación](archivo/estado-2026-10-17-antes-consolidacion.md) conserva los cortes y comprobaciones anteriores; el [registro hasta el 14](archivo/estado-2026-10-14.md) mantiene el detalle histórico.

## Trabajo actual — PA-F01

**INT02-D e INT04 cerradas en alcance técnico local. INT05 BE01–BE06 y FE01–FE06 cerradas y versionadas localmente (`8dc8efc`/`a3a4b28`); push, QA externo y piloto pendientes.** [Contrato, entorno y evidencia backend](../Backend-r3foresta/docs/pa-int05-entrega-local.md). [Tablero único](specs/plantacion/participacion-aliada/implementacion/README.md).

| Entrega | Implementación y evidencia | Pendiente conservado |
|---|---|---|
| INT02-A | Identidad/alta/perfil y desarrollo cerrados; [acta y versiones](specs/plantacion/participacion-aliada/archivo/cierre-pa-t-int02-a.md). | WebAuthn/persistencia de las mejoras posteriores y foto real; no acredita piloto de PA-F01. |
| INT02-B/C | Permisos/revisiones y gestión local verificadas; [B](../Backend-r3foresta/docs/pa-int02b-entrega-local.md), [C](../Backend-r3foresta/docs/pa-int02c-entrega-local.md). B/C publicados con `e9777f8`; la regresión C bajo D está en el runner compartido. | Catálogo complementario, manifest real revisado y transición B; cuerpos SQL/entorno remoto/despliegue C. Basales históricos separados de pruebas bajo D. |
| INT03-A | Registro/cargas/LIFO/snapshots verificados y publicados con `a045d9d`; [cierre](specs/plantacion/participacion-aliada/archivo/cierre-pa-t-int03-a.md). | Cotejo posterior de desarrollo, conciliación de fechas/permisos y habilitación real. |
| INT02-D | BE01–BE08; código en commit local `75a57eb`. Build, 64 suites/787 unitarios, 33 grupos SQL, 28 carreras y 25 HTTP/Storage; [cierre](specs/plantacion/participacion-aliada/archivo/cierre-pa-t-int02-d.md), [informe/manifest](../Backend-r3foresta/docs/pa-int02d-entrega-local.md). | Push y aplicación/cotejo remotos 077–080, Storage/PostgREST/URLs/CDN, transición y corte/drenaje del destino. |
| INT04 | FE01–FE08; código en commit local `94f62a9`. Lint/build, 39 suites/553 pruebas y 60 checks integrados; [cierre archivado](specs/plantacion/participacion-aliada/archivo/cierre-pa-t-int04.md), [informe PWA](../pwa-r3foresta/docs/QA_REGISTRO_PARTICIPANTE_INT04.md). | Push, UX humana, WebAuthn del nuevo recorrido, entorno remoto/despliegue y QA completo. El perfil de arranque del QA integrado es sintético. |
| INT05 backend | BE01–BE06 en commit local `8dc8efc`; corte original de pruebas sobre `10e5dc5` más árbol; 081, 65 suites/816 unitarios, 16 casos HTTP/SQL/Storage, preview INT05 y regresión D. [Cierre backend](specs/plantacion/participacion-aliada/archivo/cierre-pa-t-int05-backend.md), [contrato/entorno](../Backend-r3foresta/docs/pa-int05-entrega-local.md). | Push, SQL/cotejo remoto081 (y antecedentes pendientes), Storage/WebAuthn, despliegue y piloto. |
| INT05 frontend | FE01–FE06 en commit local `a3a4b28`; corte original de pruebas sobre `6a2c955` más árbol; 48 suites/691 pruebas, lint/build y 111 checks integrados/SQL, con nuevas regresiones INT04/INT06. [Informe/versiones](../pwa-r3foresta/docs/QA_IMPACTO_INT05.md), [cierre](specs/plantacion/participacion-aliada/archivo/cierre-pa-t-int05-frontend.md). | Push, revisión humana, WebAuthn real, entorno remoto/despliegue/corte y piloto. |
| INT06 | FE01–FE05 verificadas localmente, gestión por capacidades y recuperación C04–C09; [informe](../pwa-r3foresta/docs/QA_GESTION_ACCESOS_INT06.md). | FE06 parcial: revisión humana de UX, WebAuthn, entorno externo y QA completo/piloto; Impacto y regresión local acreditados en INT05. El cierre de INT04 no cierra todo el hilo frontend. |

D incluye el orden campaña → hija con FKs reales y seis carreras adicionales; la expectativa de activación ante `40001` ya devuelve 503 inconcluso. 080 respeta diez tablas, una vista y cuatro catálogos del alcance autorizado; preflight/postflight abortan ante exposición adicional o pérdida de privilegios del servicio, sin ampliar objetos ni grants. La garantía de locks es cooperativa entre RPC y no cubre SQL privilegiado que la omita.

Las revisiones de D/INT04 y la consolidación de INT05 no encontraron defectos bloqueantes. INT05 cotejó 30 huellas backend, 50 PWA y seis referencias backend de su manifest frontend; las fuentes coinciden con las pruebas originales, salvo los ajustes documentales de consolidación. OpenAPI se reprodujo y una comprobación adicional backend aprobó 3 suites/40 pruebas. Sus informes conservan las bases originales de las pruebas y registran los commits de entrega posteriores. Los commits documentales posteriores no representan pruebas nuevas. **Commit local, push, aplicación SQL y despliegue son hechos distintos.**

## SQL y entorno acreditados

| Migraciones | Entorno y evidencia |
|---|---|
| 064–067 | Desarrollo Supabase `vyrjlehkhabydkhjxagx`, aplicadas/verificadas durante A; 39 cuentas/roles conservados. |
| 068–071 | Aplicación sin errores confirmada por Pablo; SQL compacto/REST cotejados en desarrollo. Catálogo complementario y correspondencias reales pendientes. |
| 072–073 | Aplicación sin errores confirmada por Pablo y superficie REST comprobada. Igualdad de cuerpos SQL/catálogo remoto y despliegue pendientes. |
| 074–076 | Pablo confirmó el 16 de octubre su ejecución sin errores en desarrollo `vyrjlehkhabydkhjxagx`. Confirmación humana; cotejo posterior de definiciones/privilegios/Storage y conciliación pendientes. No repetirlas por esa ausencia de cotejo. |
| 077–080 | Instalación/repetición probadas exclusivamente en clústeres sintéticos aislados de D/INT04. Sin aplicación/cotejo remoto acreditados. Los fixtures parciales no prueban replay completo del esquema. |

081 está instalada/repetida únicamente en clúster sintético aislado de INT05; sin aplicación/cotejo remoto acreditados. No crea tablas ni permisos públicos raw.

No hay despliegue ni habilitación del piloto acreditados por estos cierres. La escritura inicial normal sigue pausada por omisión hasta la configuración/corte revisados; el preview habilita únicamente su fixture.

## Continuación y revisión humana

[INT05](specs/plantacion/participacion-aliada/implementacion/pa-t-int05.md) verificó backend de proyecciones/agregados públicos y lista propia por autoría/participación; frontend completó sus pantallas/navegación pública y QA integrado local el 18 de octubre ([informe PWA](../pwa-r3foresta/docs/QA_IMPACTO_INT05.md)); no se copian respuestas internas al visitante ni se vuelve a implementar el formulario INT04. INT07 conserva el cierre de casos/contratos propios de PA-S04; INT08 conserva QA/corte/despliegue/piloto.

La revisión humana puede comprobar en paralelo comprensión y uso móvil de los tres pasos/fotos/GPS, claridad de resultado pendiente/rechazo/comprobante y gestión contextual INT06 con cuentas representativas. La ceremonia WebAuthn real y la operación en el entorno destino requieren su evidencia específica. No se vuelven a presentar D01–D12 aceptadas como decisiones abiertas.

INT02, PA-S00/01/02/03/04, tareas padre de QA y PA-F01 no se declaran completos por estos cierres locales. Se archivan las fichas terminadas y se mantienen activas las que conservan pendientes.

## Otros pendientes conservados

El [estado anterior](archivo/estado-2026-10-17-antes-consolidacion.md#base-existente-y-pendientes-conservados) conserva evidencia y rutas de la integración física M2→M3, QA completo del plan, aplicación 046 no acreditada en su registro, despacho/replay SQL/TIPO_PLANTA, job de ciclo de vida/estado público, merma y mantenimiento fuera de este cierre, lint global backend y ramas anteriores sin fusionar/eliminar. Ninguno se cierra por esta consolidación.

Para registrar otra entrega, actualizar su ficha, tareas de capacidad y tablero; enlazar evidencia/versiones/entorno aquí. Archivar el estado previo antes de sustituir detalle extenso y mantener visibles los pendientes sin cierre.
