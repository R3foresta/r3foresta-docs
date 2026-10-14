# PA-S04 — Corrección excepcional vinculada al original

**Seguimiento de implementación:** [entregas, tareas y cobertura actual](../implementacion/README.md). El estado funcional/de diseño de este documento se distingue de la ejecución.

**Estado:** correcciones acotadas y ampliación de reversión/eliminación lógica confirmadas; revisión integral y contratos pendientes antes de implementar. **Actualización:** 12 de octubre de 2026. **Prioridad:** P0 antes de campo. Evidencia: [acuerdo del 12 de octubre](../archivo/revision-correcciones-2026-10-12.md).

## Acuerdo de partida

Ante un error del piloto se realiza una corrección vinculada al original, registrando quién, cuándo, por qué, valores anteriores y nuevos. No hay editor general ni anulación seguida de un nuevo registro. La decisión del 12 de octubre amplía la ejecución de correcciones de cantidad a ADMIN global y al administrador contextual en su propia subcampaña. La confirmación posterior amplía también la corrección de participantes a ambos administradores, solo en subcampañas ACTIVA. Observaciones conserva ejecución central; no se presume edición general.

## Corrección de cantidades confirmada

- Solo ADMIN global o administrador vigente de la subcampaña del registro; ser autor o plantador no basta. No requiere una segunda aprobación central para la corrección contextual permitida.
- El registro no debe tener bajas ni reposiciones. Ambas condiciones son obligatorias y se revalidan al aplicar; no basta comprobarlas al abrir la pantalla. No eliminar dependencias para eludir este límite.
- Sin cambiar especies ni crear otro registro de plantación. El actor abre «Corregir cantidad», ve el valor efectivo actual, propone la cantidad correcta y un motivo, revisa el efecto y confirma.
- Aumento: consume solo la diferencia positiva del stock elegible disponible por especie en la subcampaña; requiere saldo suficiente. Ejemplo: 10 → 12 consume 2 adicionales.
- Reducción: exige confirmar que fue un error de registro y que la diferencia corresponde a plantas físicamente disponibles en la subcampaña. Ejemplo: 12 → 10 libera 2 del consumo del registro hacia ese stock, con trazabilidad a las asignaciones consumidas. No se reduce porque murieron plantas ya plantadas; eso es una baja. Si no puede confirmarse disponibilidad, no aplicar este caso simplificado.
- Ninguna dirección cambia la cantidad físicamente entregada, crea devolución/despacho ni modifica stock de vivero. Se ajusta consumo de la subcampaña, no el hecho de la entrega.
- Cantidad efectiva, efecto en consumo e historial se aplican juntos o no se aplica nada. Sin intervalo de stock liberado durante una sustitución; sin doble efecto por reintento o concurrencia. Conservar original y mostrar resultado efectivo sin duplicar el impacto.
- Confirmado: correcciones de cantidad solo en subcampaña ACTIVA, también para ADMIN global. Revalidar estado al aplicar; no reabrir ni reactivar. Cantidad cero queda fuera de este ajuste; tampoco habilita eliminación de especie. La decisión posterior del 12 autoriza revertir duplicados y eliminar registros erróneos mediante comandos propios, conservando originales e historial; no mediante cantidad cero. El contrato debe comprobar asignaciones elegibles y rechazar efectos incompatibles con devoluciones/inactivaciones.

La ampliación de reversión se describe a continuación y en [instrucciones implementables](../archivo/instrucciones-implementacion.md). Estos son comportamientos exigidos, no mecanismos ya implementados. Contrato de versión/intento, distribución/reversión por asignación, representación original/efectiva y visibilidad del historial siguen en diseño. No concede facultad para anular mortandad.

## Reversión y eliminación de registros erróneos — ampliación del 12

**Evidencia:** el usuario permite revertir duplicados y recuperar stock para dejar un solo registro válido; permite eliminar registros de trabajo no ocurrido y de bajas/reposiciones hechas por error. Aclara que el administrador autorizado es el de **esa subcampaña**, además de ADMIN global, y que bajas/reposiciones refiere a eliminar eventos erróneos, no a revertir una plantación con todos sus hechos posteriores.

- «Eliminar» se representa como eliminación lógica/reversión auditable, conforme al principio vigente de conservar historial; no DELETE físico ni eliminación de fotos/originales. Mantener motivo, quién/cuándo, estado anterior/nuevo y referencia al registro válido cuando hay duplicado.
- Duplicado: dejar vigente el registro válido, invalidar lógicamente el duplicado y liberar únicamente su consumo efectivo trazable hacia asignaciones de la subcampaña. Stock liberado no vuelve a vivero, no modifica entrega ni constituye una devolución física.
- Plantación errónea: retirar su efecto de los agregados y compensar consumo efectivo según hechos comprobados. No ampliar el producto a comprobar físicamente todo trabajo declarado; la persona administradora responde por el motivo y caso.
- Baja errónea: revertir su efecto de mortalidad en el grupo; no aumenta stock para nuevas plantaciones.
- Reposición errónea: revertir aporte y consumo hacia sus asignaciones de REPOSICION; no borrar el grupo inicial ni devolver plantas al vivero.
- Aplicación atómica e idempotente de estado lógico, efectos e historial. No compensar dos veces el original después de correcciones previas.
- Conservar ACTIVA como límite de PA-S04 y validar autoridad/estado/dependencias al ejecutar. Revertir una plantación con bajas/reposiciones reales dependientes, o reabrir cerradas, sigue sin autorización de cascada; requiere tratamiento propio.

Contratos/representación física son propuestas para revisar en [instrucciones implementables](../archivo/instrucciones-implementacion.md), CT09/10. Esta ampliación sustituye la exclusión anterior de duplicados como caso atendible; conserva su exclusión del ajuste simple de cantidades.

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
3. El ejecutor autorizado según el caso confirma alcance, motivo y efecto antes del comando: ADMIN global para observaciones; ADMIN global o administrador de esa subcampaña para participantes, cantidades y las reversiones/eliminaciones lógicas confirmadas. Los casos sin tratamiento acordado se escalan sin mutación improvisada.
4. El sistema valida autoridad, versión/estado del original y efectos; conserva original, corrección e historial de forma atómica. Una pérdida de respuesta se comprueba antes de repetir.
5. Se comunica el resultado confirmado y se muestra la corrección según PA-S02. Un aviso o un caso en revisión no cambia por sí solo registro, stock, totales o estado.

El canal humano evita construir un sistema de tickets o una cola de aprobación de plantaciones. El comando de corrección, su acceso y la forma de consultar su resultado sí necesitan diseño y verificación antes del piloto. No se sustituye ese mecanismo por un UPDATE manual sin controles ni auditoría.

## Matriz de casos propuesta — PA-DI07

La tabla distingue acuerdos confirmados de casos pendientes; no autoriza edición general.

| Caso | Propuesta para revisar | Efectos que deben probarse |
|---|---|---|
| Observación incorrecta, con cantidades reales correctas | Corrección central aceptada, con motivo e historial; no ampliar a cualquier dato descriptivo. | No cambia stock, cantidades físicas, especie, asignación ni estado. Conservar valor anterior. |
| Persona participante omitida/incorrecta | ADMIN global o administrador vigente de esa subcampaña puede añadir, retirar o restituir participantes reales registrados con motivo, solo si la subcampaña sigue ACTIVA; no exige habilitación operativa actual del participante para reconocer un hecho pasado comprobado. | Mantener responsable original, cantidades y stock. Conservar lista anterior/nueva, actor y fecha; mostrar que hubo cambio y quién lo realizó, con detalle por audiencia. No concede permisos al participante. |
| Fecha o ubicación incorrecta | Caso especial: revalidar ventana, entrega y GPS; no permitir que la corrección evada reglas del registro. | Confirmar efectos geográficos/temporales e históricos. No alterar cantidades ni devolver plantas automáticamente. |
| Cantidad registrada distinta de la plantada | Aumento/reducción aprobados con las condiciones de la sección anterior; ADMIN global o administrador contextual de esa subcampaña. | Diferencia por especie, sin bajas/reposiciones; aumento con saldo y reducción con disponibilidad física confirmada; sin efecto en vivero. |
| Registro duplicado | Reversión por ADMIN global o administrador de esa subcampaña. Identificar registro duplicado y registro válido que permanece; conservar ambos originales e historial. | Revertir consumo efectivo del duplicado hacia sus asignaciones de subcampaña y excluir su contribución efectiva; un solo registro válido, sin devolución física al vivero. |
| Registro de plantación erróneo / trabajo que no ocurrió | El usuario no amplía verificación del trabajo real; permite eliminar el registro por esos administradores. Eliminación lógica con motivo, sin borrar evidencia/original. | Excluir su contribución efectiva y compensar consumo trazable acorde al hecho declarado y dependencias. No eliminar hechos posteriores reales por cascada. |
| Baja o reposición registrada por error | El usuario aclara que permite eliminar esos registros erróneos, no revertir automáticamente una plantación con dependencias reales. Mismos administradores y eliminación lógica auditable. | Baja: revertir mortalidad efectiva, sin aumentar stock disponible. Reposición: revertir su aporte y consumo de asignaciones de REPOSICION, sin devolver a vivero. |
| Plantación con mortandad o reposiciones reales posteriores | Revisión especial; la aclaración humana sobre eventos erróneos no autoriza revertir toda la cadena. | Preservar eventos reales y consumo; rechazar dependencias incompatibles en el contrato propuesto. No borrar eventos para eludir límites. |

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
| PA-S04-CA09 | Registro de 10, sin bajas/reposiciones, saldo elegible 5; ejecutor autorizado corrige a 12 con motivo. | Cantidad efectiva 12, saldo 3 e historial de 10 → 12 en una operación; vivero y entrega intactos. Repetir el mismo intento no vuelve a consumir. |
| PA-S04-CA10 | Registro de 12 se corrige a 10, con confirmación de error y de 2 plantas físicamente disponibles. | Se liberan 2 hacia el saldo de las asignaciones de subcampaña conforme al contrato de reversión, conservando original/historial. Sin confirmación o si se trata de mortandad, rechazar este caso. |
| PA-S04-CA11 | Admin de Norte intenta corregir registro de Sur; plantador intenta corregir el suyo. | Rechazo sin efecto salvo autoridad ADMIN global independiente verificada. La autoría no concede capacidad de corrección. |
| PA-S04-CA12 | Hay una baja o reposición, o aparece mientras se prepara la corrección. | No aplicar corrección de cantidad con esta capacidad. Serializar y revalidar corrección y eventos dependientes para impedir combinaciones inválidas. No borrar dependencias. |
| PA-S04-CA13 | Saldo insuficiente para el aumento, cambio de especies o cantidad cero mediante ajuste simple. | Sin mutación parcial; rechazar esos supuestos. Duplicado/registro erróneo usa el comando específico de reversión y su revisión, nunca cantidad cero en el original. |
| PA-S04-CA14 | Entrega 100; dos registros de 30 del mismo trabajo; uno identificado como duplicado, con otro registro válido. | ADMIN global o administrador de esa subcampaña revierte el duplicado: total efectivo 30, disponible 70 en subcampaña, vivero intacto y ambos originales/historial conservados. Repetir no vuelve a liberar 30. |
| PA-S04-CA15 | Registro erróneo de trabajo no ocurrido, sin dependencias incompatibles. | Eliminación lógica por autoridad admitida, exclusión de impacto y compensación del consumo efectivo una vez, con motivo y original intacto. No crea plantación negativa. |
| PA-S04-CA16 | Baja de 4 registrada por error. | Revertir su delta efectivo de mortalidad y recalcular grupo; no liberar 4 al stock disponible ni alterar vivero. Conservar evento original. |
| PA-S04-CA17 | Reposición de 5 registrada por error y consumo reversible comprobado. | Eliminarla lógicamente, revertir contribución al grupo y liberar exactamente 5 a sus asignaciones de REPOSICION; sin trasladarlas a stock inicial o vivero. |
| PA-S04-CA18 | Autor sin facultad, administrador de otro ámbito o dependencias reales incompatibles intentan revertir. | Rechazo íntegro; no eliminación física/cascada ni ajuste de saldo sin controles. Probar repetición, cierre, retiro y devolución concurrentes. |

**Casos adicionales de participantes:** probar alta/restauración/retiro por ambos administradores en ACTIVA, rechazo en ámbito ajeno o subcampaña cerrada (incluido cierre concurrente), participante histórico ya sin permiso vigente, y preservación de responsable original/cantidades/stock. El resultado muestra que hubo una corrección y su actor; la consulta pública no expone contactos ni motivos libres internos.

## Fuera del alcance actual: reapertura de subcampaña

Tras revisar los requerimientos, el usuario descarta la reapertura por cierre erróneo y conserva las transiciones vigentes, también para ADMIN global. [ADR-PLA-06](../../../../decisiones/02_decisiones_plantacion.md#adr-pla-06--reapertura-excepcional-por-cierre-erroneo) registra el acuerdo previo como sustituido; RN-PLA-07 mantiene ausencia de reapertura. No hay comando de reapertura que diseñar en PA-S04. Los casos/campos de corrección de REGISTRO_PLANTACION de PA-DI07 siguen pendientes de revisión y no se amplían con esta discusión.

## Decisiones y revisión

PA-DI07 parcialmente resuelta: observaciones por autoridad central; participantes y cantidades por ADMIN global o administrador de la subcampaña en ACTIVA, bajo condiciones explícitas. La decisión posterior autoriza reversión de duplicados y eliminación lógica de plantación, baja o reposición erróneas por ambos administradores; «admin de campaña» queda aclarado como administrador de esa subcampaña. Cero permanece fuera del ajuste simple. Antes del cierre integral: revisar búsqueda histórica/visibilidad, contratos de compensación por asignación y grupo, versión/repetición/concurrencia y lectura pública/privada del historial. ACTIVA se conserva como límite actual de PA-S04; no se aprueba cascada de hechos reales ni reapertura. No se aprueba editor general ni anulación de bajas reales; las bajas registradas por error admiten reversión lógica con los controles del caso. ADR-PLA-03 y CLAUDE.md sincronizados el 12 de octubre tras resolver los conflictos documentales; no acredita implementación.

Fuentes: [LCO](../../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md), [ADR-PLA-03](../../../../decisiones/02_decisiones_plantacion.md), [contrato M2→M3](../../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md), [diseño compartido](../archivo/diseno-tecnico-compartido.md). Leer [plan](plan.md) y [tareas](tasks.md) después de revisar estos casos.
