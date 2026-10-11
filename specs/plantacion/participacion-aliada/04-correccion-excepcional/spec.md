# PA-S04 — Corrección excepcional vinculada al original

**Estado:** borrador para revisión, con decisiones pendientes antes de implementar. **Actualización:** 10 de octubre de 2026. **Prioridad:** P0 para el campo si se mantiene el objetivo del 15 de octubre.

## Acuerdo de partida

Ante un error del piloto, el administrador revisa el caso y R3Foresta realiza una corrección vinculada al original, registrando quién, cuándo, por qué e historial. No hay editor general para plantador/administrador, no se deshace la plantación física y no se devuelve stock automáticamente. Cambios de cantidad requieren comprobar hechos y efectos en saldos/estados.

Pendientes obligatorios: casos admitidos, campos corregibles, límites, autoridad exacta, representación del original/corrección, efectos sobre cantidades/saldos/seguimientos y comportamiento ante correcciones concurrentes. No concede al administrador facultad para anular mortandad.

## Historias de usuario

| ID | Historia | Resultado esperado |
|---|---|---|
| PA-S04-US01 | Como responsable que descubre un error, quiero comunicarlo indicando el registro exacto para evitar duplicarlo. | Encuentra el código/detalle y el canal acordado; sabe que avisar no significa que ya se corrigió. |
| PA-S04-US02 | Como administrador contextual, quiero revisar qué ocurrió para derivar un caso fundado a R3Foresta. | Describe dato incorrecto, hecho comprobado y corrección solicitada; no recibe por ello edición general ni acceso indiscriminado a evidencia privada. |
| PA-S04-US03 | Como responsable central autorizado, quiero aplicar una corrección acotada y auditable. | El original queda vinculado a quién corrigió, cuándo, por qué y qué cambió; los efectos coinciden con los hechos. |
| PA-S04-US04 | Como persona que consulta el resultado, quiero entender que hubo una corrección sin contar dos plantaciones. | Ve el estado/dato efectivo y trazabilidad permitida por su audiencia, sin una nueva contribución física ficticia. |

## Recorrido mínimo propuesto

1. La persona obtiene el identificador del registro y comunica el error por el canal humano del piloto. No vuelve a registrar para «arreglarlo».
2. El administrador revisa el caso dentro del acceso que se acuerde, identifica el dato, el hecho real y las dependencias. Si no dispone de evidencia autorizada, interviene R3Foresta; ser administrador no abre todos los perfiles/fotos.
3. R3Foresta decide si el caso pertenece al catálogo de correcciones admitidas. Confirma alcance y motivo antes de ejecutar un comando acotado, con identidad verificada.
4. El sistema valida autoridad, versión/estado del original y efectos; conserva original, corrección e historial de forma atómica. Una pérdida de respuesta se comprueba antes de repetir.
5. Se comunica el resultado confirmado y se muestra la corrección según PA-S02. Un aviso o un caso en revisión no cambia por sí solo registro, stock, totales o estado.

El canal humano evita construir un sistema de tickets o una cola de aprobación de plantaciones. El comando de corrección, su acceso y la forma de consultar su resultado sí necesitan diseño y verificación antes del piloto. No se sustituye ese mecanismo por un UPDATE manual sin controles ni auditoría.

## Matriz de casos propuesta — PA-DI07

Esta tabla acota la discusión; no concede todavía facultad de corregir estos campos.

| Caso | Propuesta para revisar | Efectos que deben probarse |
|---|---|---|
| Observación o dato descriptivo incorrecto, con cantidades reales correctas | Candidato al primer mecanismo central: corrección documental vinculada al original. Definir lista blanca de campos. | No cambia stock, cantidades físicas, especie, asignación ni estado. Conservar valor anterior y motivo. |
| Persona participante omitida/incorrecta | Evaluar corrección central excepcional con hecho comprobado; no abrir edición de lista al autor/administrador. | Mantener responsable original, cantidades e historia; precisar representación de participantes efectivos y originales, además de su visibilidad. |
| Fecha o ubicación incorrecta | Caso especial: revalidar ventana, entrega y GPS; no permitir que la corrección evada reglas del registro. | Confirmar efectos geográficos/temporales e históricos. No alterar cantidades ni devolver plantas automáticamente. |
| Cantidad registrada distinta de la plantada | Verificar diferencia física, asignaciones y operaciones posteriores. Diseñar ajuste específico con trazabilidad antes de admitirlo. | Una cifra menor no prueba que las plantas estén disponibles: pueden seguir en campo, haberse perdido o haberse registrado en otro lugar. No cambiar disponibilidad a ciegas. |
| Registro duplicado o trabajo que no ocurrió | Investigar y diseñar tratamiento central de invalidez lógica/compensación si se aprueba. No borrar físicamente ni crear una plantación negativa improvisada. | Evitar doble impacto y reconciliar saldos con hechos reales y dependencias; conservar todos los originales. |
| Registro con mortandad o reposiciones posteriores | Revisión especial, fuera de una corrección documental simple. | Preservar reposiciones reales y su consumo. No eliminar eventos dependientes ni restaurar stock por anular una declaración. |

No basta resolver solo el caso descriptivo y declarar que todo error ya está cubierto. Para campo, acordar qué casos representativos se pueden resolver realmente y cómo se trata uno no soportado: escalar sin mutación improvisada, mostrar su situación y revisar la habilitación/alcance del piloto si impide confiar en los datos.

## Escenarios de aceptación

| ID | Dado / cuando | Entonces |
|---|---|---|
| PA-S04-CA01 | Autor o administrador intenta modificar/eliminar directamente un registro confirmado. | Se rechaza; puede comunicar/revisar el caso por la vía acordada. La revisión del error no cambia el original. |
| PA-S04-CA02 | R3Foresta corrige un campo documental admitido. | Original y valor anterior conservados; actor/fecha/motivo y vínculo presentes; ninguna variación de stock/cantidades. |
| PA-S04-CA03 | Falta motivo, autoridad o el campo no está permitido. | Rechazo completo sin cambio ni corrección parcial. La identidad central no se toma de un rol enviado por cliente. |
| PA-S04-CA04 | Se repite la operación por respuesta perdida o compiten dos correcciones del mismo estado. | No se duplica efecto; conflicto o resultado previo verificable según contrato, sin pisar historia. |
| PA-S04-CA05 | Cambia cantidad o hay un duplicado, con situación física no comprobada. | No devuelve stock automáticamente ni permite un ajuste genérico. Exige el caso/efecto aprobado y la comprobación correspondiente. |
| PA-S04-CA06 | Existen reposiciones reales basadas en información que ahora se corrige. | Mantiene hechos y consumos de esas reposiciones; no elimina dependencias. Solo ejecuta el tratamiento específicamente aprobado. |
| PA-S04-CA07 | Se consulta el mapa/detalle después de una corrección aplicada. | Se presenta el dato efectivo autorizado y la trazabilidad prevista, sin sumar original y corrección como dos plantaciones. |
| PA-S04-CA08 | El caso no puede resolverse con el mecanismo del piloto. | Se informa que sigue sin resolver, se escala y no se presenta como dato corregido. Se revisa el impacto en la preparación/continuidad del piloto. |

## Decisiones y revisión

Cerrar PA-DI07: lista de casos/campos, evidencia requerida, revisión del administrador, mapeo de ejecutor central PA-DI03, efectos por caso, representación original/efectiva, concurrencia/repetición y visibilidad PA-DI05. No se aprueba un editor general, una reversión automática, ni anulación de bajas por administrador.

Fuentes: [LCO](../../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md), [ADR-PLA-03](../../../../decisiones/02_decisiones_plantacion.md), [contrato M2→M3](../../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md), [diseño compartido](../diseno-tecnico-compartido.md). Leer [plan](plan.md) y [tareas](tasks.md) después de revisar estos casos.
