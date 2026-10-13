# PA-S01 — Registro de plantación inicial

**Estado:** borrador para revisión humana propia. **Prioridad:** P0. **No acredita implementación.**

**Actualización:** 11 de octubre de 2026. Entrada/cuenta: [PA-S00](../00-experiencia-participante/spec.md); permisos: [PA-S03](../03-gestion-acceso-subcampania/spec.md). Se reutiliza el formulario actual, no se crea otro registro de negocio para participantes.

## Resultado

Una persona con permiso vigente en una subcampaña registra una plantación real una sola vez, revisa participantes y cantidades antes de confirmar y recibe un resultado inequívoco. El responsable autenticado queda conservado; los corresponsables son opcionales y realmente identificados.

## Historias de usuario

| ID | Historia | Qué debe poder comprobar la persona |
|---|---|---|
| PA-S01-US01 | Como plantador autorizado, quiero registrar en mi subcampaña sin recorrer herramientas internas. | La entrada muestra campaña/subcampaña correctas y no exige pasar por el mapa. |
| PA-S01-US02 | Como responsable del trabajo grupal, quiero declarar cantidades y personas una sola vez. | El responsable se obtiene de mi sesión; las demás personas no multiplican la cantidad plantada. |
| PA-S01-US03 | Como persona que está registrando, quiero revisar y corregir antes de confirmar. | Volver entre pasos conserva datos; el resumen refleja las últimas cantidades/personas. |
| PA-S01-US04 | Como persona que perdió conexión, quiero saber si mi registro quedó guardado sin duplicarlo. | Recupero el mismo intento y un comprobante persistido; no se me obliga a empezar otra plantación. |
| PA-S01-US05 | Como responsable que detecta un error después, quiero una vía clara para resolverlo. | Consulto el original y sigo PA-S04; no creo otro registro para sustituirlo. |

## Precondiciones y recorrido

Sesión verificada y autorización vigente para plantar: permiso contextual en la subcampaña o autoridad ADMIN global verificada, que puede registrar directamente sin asignación contextual según PA-S03. En ambos casos se exige subcampaña ACTIVA, especies iniciales del plan y stock físicamente asignado elegible. Una persona global VOLUNTARIO autorizada debe poder usar el recorrido sin ascender a GENERAL. Ninguna precondición queda reservada al abrir la pantalla: se revalida al guardar.

1. **Fotos y ubicación:** 1–10 fotos y GPS automático/manual con estado comprensible. Una coordenada manual válida no debe seguir rotulada como ausencia total de ubicación. Servidor/PostGIS decide la validación geográfica.
2. **Cantidades, personas y fecha:** elegir cantidad por especie; distribución por asignaciones automática. Fecha dentro de la ventana vigente, observaciones opcionales hasta 2000 caracteres y otras personas participantes habilitadas según contrato pendiente PA-DI04. Responsable visible y derivado de sesión, no editable como autor ajeno. No pedir una organización para autorizar.
3. **Revisar y confirmar:** mostrar campaña, subcampaña, especies/cantidades, responsable, otras personas, fecha, ubicación y fotos. Corregir vuelve al paso correspondiente conservando datos. Confirmar guarda directamente; no pasa por aprobación administrativa.
4. **Resultado:** mostrar código/ID real devuelto por servidor, datos confirmados y acceso al detalle persistido. Tras guardar, no hay editor general para autor o administrador contextual.

La ventana de fecha de la base revisada es de 10 días y no anterior a las asignaciones consumidas; PA-DI04 debe cerrar límites exactos, zona horaria y relación con reglas vigentes antes del contrato final. PA-DI10 confirmó el 11 de octubre no pedir wallet/documento en el piloto y afiliación opcional; esas ausencias no bloquean por sí solas registrar.

**GPS confirmado el 11 de octubre:** aceptar punto fuera del polígono con evaluación/advertencia; permitir indicar una ubicación manual válida cuando falla la captura automática. No autoriza omitir coordenadas ni inventar resultado del evaluador. RN-PLA-32 se alineó para este registro inicial. Contrato/mensajes ante fallo técnico del servidor siguen por precisar y verificar. Consulta de fotos, GPS y autoría será pública conforme a PA-S02; proponer aviso claro antes de confirmar.

## Criterios para revisión

- **PA-C01 Acceso:** la persona autorizada encuentra una entrada rápida propuesta al registro sin que el mapa sea requisito.
- **PA-C02 Evidencia:** captura GPS, fecha dentro de ventana, observaciones hasta 2000 y entre 1 y 10 fotos según el handoff vigente; el estado de GPS debe respetar la decisión técnica pendiente.
- **PA-C03 Cantidades:** registra especies incluidas en el plan, mostrando meta orientativa, pendiente referencial y stock elegible; permite superar las metas total/por especie dentro del stock y conserva ACTIVA hasta cierre manual por ADMIN; no selecciona lotes manualmente y la asignación sigue FIFO fecha/id.
- **PA-C04 Revisión:** antes de confirmar puede corregir formulario y lista de participantes; después del guardado no existe edición general en esta unidad.
- **PA-C05 Autorización:** la operación comprueba permiso vigente en el orden definido por implementación; permiso retirado antes de autorización rechaza sin registro ni consumo.
- **PA-C06 Consumo:** consume stock asignado de subcampaña una sola vez; no crea despacho ni segundo débito del lote de vivero.
- **PA-C07 Idempotencia:** reenvío del mismo intento no duplica registro ni consumo; dos personas con el mismo hecho físico requieren pauta operativa aparte.
- **PA-C08 Resultado:** muestra guardado exitoso con identificador/comprobante; distingue guardando, resultado incierto y reintento seguro.

## Estados de experiencia

`edición → validando → guardando → éxito`.

Ramas explícitas: `validación rechazada`, `permiso retirado`, `stock cambiante`, `abandono`, `resultado incierto`; ninguna de ellas debe sugerir que se guardó si no existe confirmación verificable.

| Estado | Respuesta de la experiencia |
|---|---|
| Rechazo confirmado sin efecto | Explicar el campo/permiso/stock y conservar el borrador. Si cambia el contenido, volver a revisar antes de otro envío según el contrato de intento. |
| Sesión vencida | Recuperar sesión; no afirmar que un envío anterior no se guardó. Resolver su intento si estaba en curso. |
| Resultado incierto | Conservar identidad y contenido del intento. «Comprobar guardado» consulta o reintenta la misma operación conforme al contrato; nunca genera otra clave a ciegas. |
| Guardado confirmado | Abrir el mismo registro; no reenviarlo por recargar, volver atrás o repetir el clic. |
| Abandono antes de enviar | No existe plantación ni consumo; evidencias pendientes siguen política de limpieza. Si hubo envío incierto, resolverlo antes de tratar sus fotos como abandonadas. |

Los casos de retiro contextual que bloquean una nueva escritura presuponen pérdida de autorización efectiva; no revocan por sí mismos la facultad de ADMIN global mientras siga vigente, conforme a PA-S03.

## Escenarios de aceptación

| ID | Dado / cuando | Entonces |
|---|---|---|
| PA-S01-CA01 | Palca Norte autorizada y Palca Sur ajena; se cambia el ID de la petición. | Backend rechaza el ámbito ajeno sin exponer contexto ni consumir. Tener permiso en Norte no habilita hermanas/futuras subcampañas. |
| PA-S01-CA02 | Carlos declara 30 de Queñua con Ana y otra persona. | Se crea un registro de 30, con Carlos responsable y participantes reales; no 90 ni una copia por organización. |
| PA-S01-CA03 | En revisión cambia 30 a 29 y quita a Ana, luego vuelve al resumen. | Resumen y envío usan 29 y la lista corregida; foto, GPS y fecha se conservan. No se ha consumido stock antes de confirmar. |
| PA-S01-CA04 | Meta 40, stock elegible 50; registra 50 de especies planificadas. | Se admite si cumplen las demás reglas; meta no limita, subcampaña sigue ACTIVA. Con 51 o especie fuera del plan se rechaza. |
| PA-S01-CA05 | Dos registros diferentes compiten por stock insuficiente para ambos. | La transacción admite solo consumos válidos, sin saldo negativo ni segundo débito de Vivero. El rechazado recibe motivo y contexto actualizable. |
| PA-S01-CA06 | Retiro de permiso antes de autorizar / autorización válida antes del retiro. | Primer orden: rechazo sin efecto. Segundo: puede finalizar conforme a las demás validaciones. Se prueban ambos órdenes en DB, no con el tiempo del clic. |
| PA-S01-CA07 | Doble clic, peticiones simultáneas o respuesta perdida después del commit. | Misma clave/contenido produce un único registro/consumo y recupera su comprobante. Contenido diferente con la misma clave genera conflicto. |
| PA-S01-CA08 | Se revoca permiso tras guardar y la persona intenta recuperar el resultado. | Recupera su recibo conforme a PA-S02; no recibe stock/equipo ni permiso para otra plantación. |
| PA-S01-CA09 | Foto ajena, ya vinculada o de tipo no permitido. | Rechazo sin asociación indebida. La recuperación/limpieza no elimina fotos de un registro confirmado. |
| PA-S01-CA10 | GPS dentro, fuera y no evaluable; GPS manual tras fallo del dispositivo. | Backend y mensajes siguen la decisión PA-DI04. Se prueba geografía real en PostGIS; mocks no cierran esta verificación. |
| PA-S01-CA11 | Dos personas registran por separado el mismo trabajo real. | La idempotencia de un intento no promete detectarlo. El piloto acuerda una persona registradora por grupo y deriva duplicados detectados a PA-S04. |

## Decisiones antes del código afectado

- PA-DI04: verificar GPS exterior/manual ya confirmado, manejo de fallos técnicos, fecha y personas seleccionables, incluida revocación de un participante durante la captura.
- PA-DI06: contrato durable de intento/recibo, huella, concurrencia, retención y evidencias; no basta deshabilitar el botón.
- PA-DI01/02/03/09: identidad y autorización contextual de PA-S00/03. El usuario confirmó registro directo por ADMIN global en cualquier subcampaña ACTIVA, sin asignación contextual y con las mismas validaciones. Los mecanismos de identidad/autorización y transición siguen pendientes.
- Contrato de distribución FIFO: frontend ayuda hoy; definir resolución o comprobación en servidor para garantizarla frente a cualquier cliente.

El [boceto](../boceto-registro-resultado.md), [plan](plan.md), [tareas](tasks.md) y [diseño compartido](../diseno-tecnico-compartido.md) desarrollan estas propuestas. Los escenarios son pruebas previstas, no resultados obtenidos.

## Límites

Esta spec fija comportamiento, no nombres definitivos de tablas/HTTP. Su plan diseña esas integraciones con PA-S00/03 y el diseño compartido. Publicación exacta de fotos/GPS corresponde a PA-S02; corrección excepcional a PA-S04; mortandad/reposición completa queda fuera del nuevo recorrido, preservando compatibilidad existente.

## Trazabilidad

LCO §§2–8 y §10; ADR-PLA-03; handoff §§3–12; RN-PLA-32 y reglas de registro/stock; contrato M2→M3; migración 053 como evidencia histórica de la base y 060/061 del backend local para especies/metas vigentes; ADR-PLA-04. La alineación documental no acredita despliegue ni aprueba esta spec completa.
