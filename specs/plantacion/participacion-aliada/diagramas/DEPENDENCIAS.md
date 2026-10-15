# Dependencias para implementar PA-F01

**Corte:** 14 de octubre de 2026. **Fuente del avance:** [tablero único de ejecución](../implementacion/README.md) y [ESTADO.md](../../../../ESTADO.md). Esta vista explica sus dependencias; no crea otro backlog ni certifica ejecución nueva.

PA-F01 está **parcialmente implementada**. INT02-A cerró identidad, alta VOLUNTARIO, perfil/afiliación y privacidad en desarrollo. La siguiente entrega es **[PA-T-INT02-B](../implementacion/pa-t-int02-b.md)**: persistencia de permisos, revisiones, auditoría y ensayo de transición. El registro participante recuperable, LIFO y los snapshots nuevos siguen pendientes. D01–D12 están aceptadas como diseño; no se vuelven a presentar como decisiones abiertas.

La revisión anterior se conserva en el [archivo de diagramas previo al 14](../archivo/diagramas-antes-2026-10-14/README.md). Sus hallazgos de código y fechas no describen por sí solos la versión actual. Esta actualización se basa en las specs, el contrato aceptado y las evidencias de cierre registradas; no repitió pruebas de aplicación, SQL ni despliegue.

## 1. Qué existe, qué está definido y qué falta

| Dependencia | Acuerdo/base disponible al corte | Trabajo restante y fuente |
|---|---|---|
| Identidad, alta y perfil | **INT02-A completada en desarrollo**: identidad JWT, cuenta nueva VOLUNTARIO, afiliación opcional catálogo/Otra/ausencia, perfil sin mutación de autoridad y privacidad. Backend `57e5b71`, PWA `cf13036`, SQL 064–067 verificadas en desarrollo. | No repetir el diseño del guard ni el alta. Quedan autorización por objeto y regresiones de B/C/D; mejora visual posterior con passkey/persistencia y foto real pendientes. [Cierre de A](../archivo/cierre-pa-t-int02-a.md). |
| Permisos contextuales | **D03–D06 aceptadas**: permiso persona/subcampaña, vigencias, fila de revisión estable e historial; ADMIN global derivado, sin fila contextual por cada ámbito. COORDINADOR/OPERARIO conserva responsabilidad logística independiente. | **INT02-B, siguiente**: cotejar catálogo/FKs/privilegios, preparar migración aditiva e inicialización y ensayar manifest concreto. GENERAL/COORDINADOR no se convierten automáticamente. [Ficha B](../implementacion/pa-t-int02-b.md). |
| Continuidad administrativa y gestión | ADMIN contextual también planta y gestiona plantadores en su ámbito; ADMIN global designa/cambia/retira administradores y cambia roles/inactiva cuentas por una operación separada del perfil. | C implementa gestión/capacidades sobre comandos; D verifica carreras y vías equivalentes. Proteger último contextual efectivo de ámbito inicializado y último ADMIN global activo como garantías distintas. La presencia global no sustituye al contextual. [Contrato §§3–5 y 8](../contrato-identidad-permisos-backend-propuesta.md). |
| Registro común, retiro y recuperación | **D10–D12 aceptadas**: comando propio por actor/operación/clave, huella del servidor, terminal inmutable, efecto y recibo atómicos; locks compartidos con retiro y otros cambios. | **INT03-A** construye motor y primer consumidor inicial. C lo reutiliza para gestión; D cierra concurrencia/corte. Preparar o pulsar confirmar no reserva autoridad ni stock. [Contrato §§7–8](../contrato-identidad-permisos-backend-propuesta.md). |
| Datos operativos y stock | Campaña/subcampaña, plan por especie y asignaciones físicas M2→M3 son base reutilizable. La asignación ya representa la entrega; la inicial no añade acuse/recepción. | Comprobar versión y datos del entorno: ACTIVA, plan/polígono válidos y stock elegible de PLANTACION_INICIAL en esa misma subcampaña. **D07: reparto LIFO en servidor**, por timestamp completo `fecha_asignacion DESC, id DESC`; orden de locks ASC es independiente. [Contrato §6.1](../contrato-identidad-permisos-backend-propuesta.md). |
| GPS, fecha y plan | **Reglas aceptadas**: punto válido manual o capturado, exterior evaluado permitido; fecha Hoy editable, ventana inclusiva de 10 días en America/La_Paz; plan versionado, metas orientativas y cierre manual. | INT03-A verifica PostGIS real, cota según entrega de asignaciones consumidas y revisión de plan. D coordina plan/stock/logística/cierre y aliases. 062/063 y QA parcial del plan ya tienen evidencia; no declararlos íntegramente pendientes. [Estado del plan](../../../../ESTADO.md#base-existente-y-pendientes-conservados). |
| Fotos y afiliación histórica | **D08/D09 aceptadas**: snapshots de nombre y afiliación, origen catálogo/Otra/ausencia; cargas recuperables propias, originales privados y derivados públicos sanitizados. | INT03-A implementa cargas, propiedad, lease/generación, limpieza y snapshots. Verificar formatos/conversión y URLs antiguas. Un registro retroactivo no reconstruye afiliación pasada desde perfil actual. [Contrato §§6.2–6.3](../contrato-identidad-permisos-backend-propuesta.md). |
| Experiencia participante y pública | PA-S00/01/02/03 aprobadas en comportamiento. Impacto se consulta/comparte sin cuenta, login, perfil ni permiso; sesión vencida no lo bloquea. Gestión interna se conserva como experiencia separada. | INT04 formulario recuperable, INT05 proyección/páginas públicas y Mis registros, INT06 interfaz de acceso. APIs públicas/regresiones conservadas en A no completan las pantallas de PA-F01. [Specs e implementación](../README.md). |
| Correcciones y reversiones | Cantidades/participantes y reversión de duplicados o registros erróneos por ADMIN global o administrador de esa subcampaña, en ACTIVA y con límites. Observaciones sigue central; original/historial preservados, sin reapertura. | **PA-S04 conserva cierre integral propio pendiente**. INT07 concreta contratos/compensación/visibilidad y verifica sus efectos; D01–D12 no aprueban todos esos casos. [PA-S04](../04-correccion-excepcional/spec.md). |
| Integración, despliegue y piloto | A acredita desarrollo, publicación Git y SQL en ese entorno; la integración física interna previa conserva su evidencia histórica. | **INT08 pendiente para PA-F01 completo**: ensayo de transición/corte, QA navegador→API→datos, despliegue y decisión posterior de piloto. No trasladar el cierre de A al registro participante ni a producción. [ESTADO.md](../../../../ESTADO.md). |

## 2. Qué debe estar preparado para un registro participante real

1. **Cuenta activa y sesión verificadas**. VOLUNTARIO con permiso contextual vigente puede plantar; ADMIN global activo puede registrar directamente en cualquier ACTIVA sin membresía contextual adicional. Afiliación, perfil o rol GENERAL/VALIDADOR no sustituyen por sí solos esa autorización en el modelo nuevo.
2. **Ámbito y contexto privado válidos**: subcampaña ACTIVA, plan por especie/revisión y polígono evaluable. El contexto con saldo cero devuelve SIN_STOCK; no se interpreta como permiso retirado. Inicial requiere saldo suficiente al guardar. Autoridad + estado en capacidades no reserva stock.
3. **Stock físicamente entregado y elegible**: asignaciones ACTIVA/PLANTACION_INICIAL de la misma subcampaña. Para la fecha elegida, no usar entregas posteriores; conciliar su día operativo conforme a D07. Para una nueva entrega de Vivero se necesita lote ACTIVO con EMBOLSADO y saldo, pero no exigir saldo remanente del lote para consumir una asignación ya entregada.
4. **Intento y fotos propios recuperables**: preparación sin efecto de plantación, identidad de comando conservada y 1–10 fotos propias listas. Confirmar originales/derivados y propiedad; ADMIN no exceptúa la prohibición de usar cargas ajenas.
5. **Datos revisados**: cantidades enteras positivas por especie del plan, fecha y coordenadas válidas, participantes adicionales opcionales y elegibles, responsable derivado de sesión. El servidor resuelve detalles LIFO y revalida todo al ejecutar. Meta orientativa no limita consumo; stock sí. No hay cuarta pantalla ni aprobación previa administrativa.
6. **Garantías de backend/corte verificadas**: permiso/actividad/estado/plan bajo locks, retiro consistente, saldo no negativo, recibo terminal atómico y recuperación del mismo comando. Verificar rutas legadas equivalentes y permisos DB; el formulario nuevo no debe convivir con un bypass por equipo o header de identidad.

El saldo físico conserva su identidad:

```text
saldo_asignado_disponible
= cantidad_asignada − cantidad_consumida − cantidad_devuelta − cantidad_mermada
```

Inicial aumenta cantidad_consumida y contadores M3. No cambia cantidad_asignada, no crea otro despacho ni descuenta nuevamente Vivero. La asignación es stock compartido del ámbito, sin división personal u organizacional. LIFO reparte consumo elegible; locks ASC evitan órdenes contradictorios sin cambiar ese reparto.

## 3. Dependencia entre entregas

![PA-D05 — Entregas y condiciones de integración](svg/PA-D05-dependencias-implementacion.svg)

El orden vigente del backend es **INT02-B → INT03-A → INT02-C → INT02-D**. B prepara permisos/transición; INT03-A construye motor/cargas/registro como primer consumidor; C añade gestión/capacidades; D verifica políticas por objeto, carreras, aliases y corte de clientes. INT02-A ya está cerrada en su alcance de desarrollo: no se vuelve a iniciar.

INT04/05/06 consumen contratos de registro, consulta y acceso. INT07 consume el motor/autoridad, con revisión propia de casos PA-S04. Su preparación documental y visual puede avanzar cuando los contratos lo permitan; las garantías críticas de B/C/D y recuperación deben verificarse antes de habilitar registro participante real. INT08 reúne la evidencia del alcance completo. Consultar el [tablero](../implementacion/README.md) para tareas, estado y orden, y la [ficha B](../implementacion/pa-t-int02-b.md) para el siguiente trabajo.

Los encargos por equipo del tablero precisan los puntos de integración:

| Equipo | Encargo vigente | Cuándo consume su dependencia |
|---|---|---|
| Backend/DB | [INT02-B · BE01–BE07](../implementacion/pa-t-int02-b.md#tareas-para-backenddb) | Siguiente ejecución, tras comprobar revisiones/catálogo; prepara esquema y ensayo. La propuesta de transición real conserva su revisión propia antes de aplicarse. |
| Backend/DB | [INT02-C · BE01–BE06](../implementacion/pa-t-int02-c.md#tareas-para-backenddb) | Después de B y motor común probado en INT03-A; entrega APIs/comandos y evidencia a PWA. |
| Frontend | [INT06 · FE01–FE06](../implementacion/pa-t-int06.md#tareas-para-frontend) | Boceto FE01 puede prepararse; integración FE02–FE05 tras C verificada, QA FE06 con C/D comprobadas. Entrada/selector y formulario siguen en INT04; no se trasladan a INT06. |

El catálogo y el manifest de personas/ámbitos se revisan de forma concreta conforme al contrato §9 antes de aplicar la transición. Esta actualización no solicita esa aprobación ni realiza asignaciones: prepara las vistas del trabajo ya definido. La fecha original del 15 de octubre era un objetivo condicionado; no se acredita preparación por llegar a esa fecha ni se fija otra por inferencia.

## 4. Qué cambió respecto al análisis anterior

Se conservan los IDs de hallazgo para localizar la evidencia histórica; los estados siguientes se apoyan en el corte actual, no en una nueva auditoría de código.

| Hallazgo | Tratamiento vigente |
|---|---|
| **PA-DEP-01 · identidad por header** | A cerró JWT/alta/perfil/privacidad en desarrollo. El hallazgo antiguo no se afirma como descripción del endpoint actual. Las políticas por objeto y rutas equivalentes restantes se verifican por B/C/D. |
| **PA-DEP-02 · roles/equipo** | D04 define permisos separados de logística, con vigencias/revisión/historial. Modelo aceptado, implementación B pendiente; transición concreta sin promociones automáticas. |
| **PA-DEP-03 · reintentos y retiro** | D10–D12 especifican comando_id, huella/recibo durable, locks y recuperación. Ya no son mecanismos por elegir; faltan implementación y pruebas de INT03-A/C/D. |
| **PA-DEP-04 · GPS** | Regla inicial alineada en PA-S01/RN-PLA-32: manual válido y exterior evaluado admitidos. Fallo técnico solo acredita rechazo sin efecto si se persistió recibo RECHAZADO; sin recibo es inconcluso. PostGIS real y recorrido siguen por verificar. |
| **PA-DEP-05 · meta/cierre/plan** | ADR-PLA-04/05 confirman metas orientativas, cierre manual y plan editable por ADMIN global en BORRADOR/ACTIVA. Estado acredita 062/063 y QA parcial; queda QA integrada de edición/concurrencia/despliegue. Nueva inicial LIFO en servidor aún no está acreditada. |

**Recuperación aceptada:** misma clave/contenido recupera el recibo propio sin repetir efecto, incluso tras retiro contextual, con cuenta activa/sesión válida. Mismo comando con contenido diferente da conflicto. RECHAZADO terminal no revive al mejorar stock/permisos: revisar y confirmar una intención nueva usa nueva clave. Un timeout, 202 SIN_RESULTADO o 404 COMANDO_NO_CONFIRMADO no acredita fracaso ni permite cambiar de clave. No hay estado EN_CURSO observable ni modo offline completo prometidos.

**Consulta acordada:** global/campaña/subcampaña/registro/fotos públicas elegibles por enlace sin login; Mis registros autenticado une autoría y participación histórica, deduplicadas. No entregar stock, contactos, perfil completo, observaciones privadas, pendientes ni EXIF. Perder permiso conserva lectura/recibo propios permitidos, sin volver a dar equipo/stock. Nombres/afiliaciones históricos no se reconstruyen desde equipo o perfil actuales.

**Correcciones acordadas:** ajuste de cantidades sin bajas/reposiciones, sin cambiar especies y sin cantidad cero; aumento consume diferencia elegible y reducción exige error/disponibilidad física confirmados. Reversión de duplicado/registro erróneo usa su caso propio, preserva original/historial y compensa solo consumo efectivo trazable en asignaciones de subcampaña, nunca Vivero ni entrega. Baja errónea revierte mortalidad sin liberar stock; reposición errónea revierte aporte/consumo de REPOSICION. Sin cascada de hechos posteriores reales ni reapertura; efectos/contratos propios pendientes en INT07.

## Fuentes y alcance de esta actualización

Fuentes vigentes: [tablero](../implementacion/README.md), [ficha INT02-B](../implementacion/pa-t-int02-b.md), [cierre INT02-A](../archivo/cierre-pa-t-int02-a.md), [contrato aceptado D01–D12](../contrato-identidad-permisos-backend-propuesta.md), [PA-S00](../00-experiencia-participante/spec.md), [PA-S01](../01-registro-plantacion-inicial/spec.md), [PA-S02](../02-consulta-impacto-y-registros/spec.md), [PA-S03](../03-gestion-acceso-subcampania/spec.md), [PA-S04](../04-correccion-excepcional/spec.md), [ADR](../../../../decisiones/02_decisiones_plantacion.md) y [contrato físico M2→M3](../../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md).

La comprobación de este trabajo cubre fuentes, coherencia de vistas, enlaces y renders. Código, SQL y pruebas registradas por otras entregas conservan su evidencia/versiones/entorno; no se vuelven a certificar aquí. El archivo mantiene el análisis anterior sin usarlo como backlog vigente.
