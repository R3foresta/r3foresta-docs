# PA-F01 — Participación aliada en Plantación

**Actualización:** 14 de octubre de 2026. **Estado:** PA-S00/01/02/03 aprobadas en comportamiento; PA-S01 cerrada integralmente en revisión funcional. D01–D12 aceptadas como diseño técnico del backend el 13, con ajustes en D02 y D07. PA-S04 conserva alcance confirmado y cierre integral/contratos propios pendientes. LCO cerrado y Elaboración autorizada; avance de implementación y pruebas separado en [ESTADO.md](../../../ESTADO.md).

## Acuerdos vigentes

- **Impacto público y compartible:** global, campaña, subcampaña, registro, mapa y fotos públicas elegibles se consultan sin cuenta, registro o login. VOLUNTARIO sin asignación ve la misma proyección pública. Registrar, gestionar y consultar datos privados exige sesión/autoridad; los enlaces públicos conservan su destino sin redirigir obligatoriamente al login.
- **Dos experiencias y un dominio:** Impacto y participación es reducido y progresivo; la gestión interna conserva herramientas/datos/facultades legítimas. No duplicar campañas, plantaciones ni stock; profundizar en Impacto no abre datos internos.
- **Alta, perfil y acceso:** toda cuenta nueva empieza VOLUNTARIO. Solo ADMIN global asigna roles internos mediante operación administrativa separada; el perfil no cambia autoridad. PLANTADOR y ADMINISTRADOR_SUBCAMPANIA son permisos por persona/subcampaña, distintos de coordinación/logística. ADMIN global tiene acceso transversal actual/futuro y presencia derivada deduplicada en miembros, sin filas por ámbito ni participación histórica automática.
- **Afiliación opcional:** elegir una organización existente del catálogo o «Otra» con texto libre; también puede omitirse. No concede permisos ni crea automáticamente una organización maestra. Conservar nombre/afiliación histórica en el registro según el contrato aceptado.
- **Registro inicial:** fotos/ubicación → especies/cantidades/fecha/observaciones → participantes/resumen/confirmación. Observaciones después de fecha en paso 2, en resumen solo si hay contenido y corregibles antes de confirmar. Sin aviso público adicional ni cuarta pantalla. Resultado incierto se recupera con el mismo comando.
- **Stock:** consumir el saldo elegible que ya tiene la subcampaña. D07 acepta **LIFO en servidor**, sustituyendo FIFO propuesto anteriormente para este incremento; validar plan/fecha/stock atómicamente. No añadir recepción por organización/administrador, otra entrega, despacho o segundo débito de Vivero. La asignación física previa conserva su contrato M2→M3.
- **Comandos:** tabla común elegida para plantación, acceso y correcciones, empezando por plantación. Diseño de comando/cargas/recuperación aceptado en D01–D12; la compartición no concede autoridad ni aprueba efectos específicos de PA-S04.
- **Correcciones:** ADMIN global y administrador de esa subcampaña corrigen cantidades/participantes en ACTIVA con sus límites. Reversión de duplicados y eliminación lógica de plantación/baja/reposición erróneas conserva original e historial. Liberar consumo hacia asignaciones de la subcampaña no devuelve físicamente a Vivero; baja errónea revierte mortalidad, no stock. No cascada de hechos reales ni reapertura.

Fuentes de aceptación: [acta funcional](revision-humana-2026-10-11.md), [correcciones](revision-correcciones-2026-10-12.md), [roles y permisos](acuerdo-roles-y-permisos-2026-10-12.md), [acta técnica del 13](revision-tecnica-2026-10-13.md) y [ADR de Plantación](../../../decisiones/02_decisiones_plantacion.md).

## Estado por capacidad

| Spec | Revisión funcional completada | Qué sigue |
|---|---|---|
| [PA-S00 · Entrada](00-experiencia-participante/spec.md) | Entrada pública, perfil mínimo, alta/roles y acceso por ámbito aprobados. | INT02-A completado en identidad/alta/perfil y desarrollo; siguen capacidades e Impacto público en frontend. |
| [PA-S01 · Registro inicial](01-registro-plantacion-inicial/spec.md) | Cierre integral el 12, incluidas observaciones; LIFO y diseño backend aceptados el 13. | Guardado recuperable, evidencias, autorización/stock y QA sobre el contrato aceptado. |
| [PA-S02 · Consulta](02-consulta-impacto-y-registros/spec.md) | Primera versión aprobada: global/detalle, faltantes por subcampaña, Mis registros, afiliación histórica y consulta compartible sin login. | Boceto final, lecturas efectivas/fórmulas de seguimiento, integración y pruebas; correcciones según PA-S04. |
| [PA-S03 · Acceso](03-gestion-acceso-subcampania/spec.md) | Autoridad/ámbito, BORRADOR, selección todo-o-nada, reemplazo/último administrador y gestión por estado aprobados; contrato backend aceptado. | Cotejo de catálogo, transición, persistencia, comandos de acceso y pruebas reales antes de habilitar personas. |
| [PA-S04 · Correcciones](04-correccion-excepcional/spec.md) | Cantidades/participantes y duplicados/eliminación lógica errónea confirmados. | Cierre integral de fecha/ubicación y dependencias especiales; contratos de compensación/historial y QA propios. D01–D12 no cierran PA-DI07. |

Las carpetas e IDs se conservan; su numeración no impone orden de implementación. Cada carpeta mantiene spec, plan y tareas por capacidad. Un cierre funcional o técnico no marca tareas de código como ejecutadas.

## Trabajo ya realizado y tareas asociadas

| Trabajo | Entrega / evidencia | Estado exacto |
|---|---|---|
| Revisión funcional del registro | PA-T01/PA-T01-UX; [boceto](boceto-registro-resultado.md) y acta de cierre. | Cerrada en revisión funcional; frontend adaptado al incremento todavía por verificar. |
| Contraste de APIs, DTO, SQL y consumidores | [Revisión de contratos](revision-contratos-2026-10-12.md). | Lectura estática completada; preserva hallazgos del código vigente. |
| Inventario de rutas/facultades/regresión | [Inventario y segunda lectura](inventario-endpoints-y-regresion-participacion.md); aporta a ENT02, PA-T15 e INT01. | Inventario documental completado; pruebas y migración de personas no ejecutadas. |
| Acuerdos de alta/permisos y comandos | [Roles](acuerdo-roles-y-permisos-2026-10-12.md) y [comandos compartidos](diseno-comandos-compartidos.md). | Decisiones de producto/enfoque confirmadas; infraestructura pendiente de implementación. |
| Instrucciones por capas | [Instrucciones implementables](instrucciones-implementacion.md), PA-CT/PA-Q y entregas INT01–08. | Preparación documental entregada; el contrato backend aceptado precisa sus rutas/DTO/datos. |
| Diseño técnico de identidad/acceso/registro/cargas | [Contrato backend](contrato-identidad-permisos-backend-propuesta.md) y acta del 13; contribuye a INT01 y prepara INT02/03. | D01–D12 aceptadas con ajustes. Cotejo del entorno y ejecución pendientes; no repetir la revisión como tarea abierta. |
| Diagramas locales | [Fuentes Mermaid y SVG](diagramas/README.md). | Cinco renders del 12 existentes; incorporar cambios posteriores del 13 en la próxima actualización de diagramas. No representan migraciones aplicadas. |

PA-T-ENT02, PA-T12/15 e INT01 tienen componentes de preparación completados y componentes de transición/verificación pendientes. No marcar completas esas entregas enteras por el inventario o por redactar el contrato. Conservar evidencias y fechas al cerrar cada componente.

## Entrega completada y siguiente paso

**PA-T-INT02-A — COMPLETADO el 14 de octubre de 2026.** Identidad/alta/perfil, adaptación PWA y cierre de privacidad comprobados en desarrollo; 064–067 aplicadas. Código publicado en main: backend `57e5b71`, PWA `cf13036`. [Estado y límites](../../../ESTADO.md#cierre-de-pa-t-int02-a--14-de-octubre-de-2026). La mejora posterior de UI/UX tiene pruebas sintéticas; su repetición integrada, despliegue y piloto conservan sus controles propios.

Después: INT02-B permisos/versiones/transición → INT03-A registro con comandos/cargas/recibo → INT02-C gestión contextual/roles → INT02-D regresiones y corte sin vías legadas que eludan autorización. Integrar PWA/consulta/gestión en INT04/05/06, casos propios de corrección en INT07 y QA/despliegue en INT08. Autorización, retiro y último administrador deben verificarse antes de habilitar registro participante real.

El objetivo de campo del 15 de octubre sigue condicionado a registro, acceso, consulta y corrección disponibles y verificados; la aceptación del diseño no acredita preparación del piloto.

## Mapa de fuentes de verdad

| Documento | Autoridad / uso |
|---|---|
| [Specs PA-S00–04](#estado-por-capacidad) y actas | Comportamiento aprobado y límites específicos por capacidad. |
| [Contrato backend aceptado](contrato-identidad-permisos-backend-propuesta.md) + [acta técnica](revision-tecnica-2026-10-13.md) | D01–D12, DTO/errores, datos, concurrencia, cargas/retención y secuencia de implementación. Su nombre de archivo conserva «propuesta» por compatibilidad. |
| [Revisión de contratos](revision-contratos-2026-10-12.md) e [inventario](inventario-endpoints-y-regresion-participacion.md) | Evidencia estática del código existente; no reinterpretar como código ya actualizado o verificación remota. |
| [Plan inicial](plan-inicial.md), [integración](plan-reutilizacion-integracion.md), [diseño compartido](diseno-tecnico-compartido.md) e [instrucciones](instrucciones-implementacion.md) | Orden, responsabilidades, archivos y tareas; referencias históricas de diseño se subordinan a decisiones posteriores aceptadas. |
| [LCO](../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md) y [handoff](../../../03-plantacion-module/05_handoff_registro_plantacion_inicial.md) | Alcance y base interna reutilizada; adaptación participante conforme a spec/contrato posteriores. |
| [ADR de Plantación](../../../decisiones/02_decisiones_plantacion.md) y [reglas M3](../../../03-plantacion-module/01_reglas_de_negocio_plantacion.md) | Decisiones transversales e invariantes del dominio. |
| [Contrato Vivero→Plantación](../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md) | Entrega física, consumo por asignación, devolución y saldos; el incremento no incorpora otra recepción. |
| [Esquema documentado](../../../database/00_database_schema.md) | Base estructural existente; nuevas estructuras aceptadas se cotejan/preparan como migraciones antes de acreditar su aplicación. |
| [ESTADO.md](../../../ESTADO.md) | Qué código, pruebas, migraciones y despliegue están realmente acreditados. |

Las actas conservan historia; una propuesta FIFO anterior o un inventario del cliente existente no sustituye LIFO aceptado el 13. Perfil/afiliación, organizaciones de campaña y autoridad operativa siguen siendo relaciones distintas.
