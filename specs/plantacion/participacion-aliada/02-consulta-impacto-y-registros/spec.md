# PA-S02 — Consulta de impacto y registros

**Estado:** spec en revisión; consulta pública y selección principal de campos confirmadas el 11 de octubre de 2026, contrato/presentación y otros pendientes por cerrar. No aprobada para implementación completa. **Prioridad de elaboración:** P1; los contratos que utiliza el registro son dependencias tempranas. Evidencia: [revisión humana](../revision-humana-2026-10-11.md).

## 1. Resultado y relación con las otras specs

Una persona entiende el impacto de las plantaciones y puede llegar a los registros que lo explican sin recorrer las herramientas internas de Recolección, Vivero o gestión de campañas. Una persona que registró una plantación también puede recuperar su resultado guardado, incluso después del retiro de su permiso operativo.

[PA-S00 — Experiencia participante](../00-experiencia-participante/spec.md) define la entrada, navegación y separación de experiencias. Esta spec define qué se consulta y cómo se interpreta. [PA-S03](../03-gestion-acceso-subcampania/spec.md) resuelve permisos operativos; [PA-S01](../01-registro-plantacion-inicial/spec.md), el guardado. La lectura de un registro no vuelve a registrarlo ni consume stock.

**PA-DI08 confirmada:** consulta pública sin autenticación ni perfil, accesible por enlace para cualquier persona y no limitada a ámbitos asignados. La habilitación por subcampaña solo limita operación/gestión. Login, alta, documento, wallet y afiliación no son requisitos de esta consulta.

Esto no introduce un estado «publicada» en `CAMPANIA`: su estado sigue siendo derivado. Se mantienen estados públicos elegibles de RN-PLA-34; no se decidió ampliar publicación a borradores/canceladas. La proyección pública incluye sus campos aprobados sin retirar automáticamente la autenticación del GET /plan técnico de ADR-PLA-05.

## 2. Historias de usuario

| ID | Historia | Resultado verificable |
|---|---|---|
| PA-S02-US01 | Como visitante con el enlace y sin cuenta, quiero consultar el impacto de campañas/subcampañas. | Ve mapa, registros y campos públicos sin autenticarse; no recibe equipo, stock interno ni facultades operativas. |
| PA-S02-US02 | Como participante de una subcampaña, quiero reconocer su zona y registros sin revisar toda la administración. | Desde el mapa abre resumen y luego detalle; las acciones adicionales dependen de capacidades vigentes en esa subcampaña. |
| PA-S02-US03 | Como responsable de un registro, quiero volver a consultar lo que quedó guardado para comprobar cantidades y resultado. | Abre el mismo registro persistido, con identificador y datos permitidos, también después de una revocación. |
| PA-S02-US04 | Como persona que figura como corresponsable, quiero encontrar las plantaciones en las que consto sin que se atribuya todo el grupo como trabajo individual mío. | Propuesta para «Mis contribuciones»: agrupar por registros únicos y distinguir «registré» de «figuro como participante». Alcance y campos pendientes de PA-DI05. |
| PA-S02-US05 | Como persona que consulta, quiero entender qué significan el mapa y sus cantidades para no confundir zona de trabajo, árboles plantados y supervivencia. | Un punto representa un registro grupal; las etiquetas distinguen plantación inicial, reposiciones y saldo vivo cuando esos indicadores se incluyan. |
| PA-S02-US06 | Como visitante o plantador, quiero ver el impacto global de R3Foresta, cambiar de campaña y profundizar solo cuando lo necesito. | Resumen global del alcance público, selección de campañas y detalle progresivo de subcampañas/registros en la misma experiencia reducida, sin abrir gestión interna. |

«Observador» describe la experiencia de consulta; no crea un rol global ni un permiso contextual asignable.

## 3. Alcance y recorrido

1. Ofrecer un resumen global del impacto público de R3Foresta y permitir seleccionar/cambiar campaña para consultar su estado, subcampañas y registros. Mostrar primero información reducida; la selección exacta de indicadores iniciales y su disposición se revisan en el boceto. Mapa y total de plantación inicial corresponden al conjunto consultado, cuyo alcance debe estar visible. El texto debe nombrar el indicador; no sumar reposiciones bajo una etiqueta ambigua de cumplimiento de meta.
2. Tocar un polígono y abrir su resumen en la misma vista, manteniendo el contexto del mapa. El polígono representa la zona de trabajo, no la superficie efectivamente plantada.
3. Abrir progresivamente detalle de campaña, subcampaña y registros, sin volcar todos los campos en el resumen. Profundizar mantiene pantallas y respuestas públicas reducidas; no enlaza a fichas de administración interna. Cada punto corresponde a un registro grupal; agrupar puntos visualmente por proximidad no debe cambiar su identidad ni multiplicar cantidades.
4. Mostrar públicamente el registro con sus campos aprobados; stock operativo solo a quien tenga capacidad contextual correspondiente y gestión de plantadores solo al administrador autorizado. Si alguien intenta registrar, explicar autenticación y habilitación necesarias conforme a PA-S00.
5. Permitir volver al mapa conservando el filtro y la selección, como propuesta de UX. El registro rápido de PA-S00/PA-S01 no exige completar este recorrido.

Organización y campaña sirven como contexto o filtros opcionales. No es obligatorio recorrer organización → campaña → subcampaña ni tener afiliación; los enlaces directos pueden abrir un nivel concreto sin atravesar el resumen global. Queda pendiente el filtro inicial con varias afiliaciones o ninguna; un filtro de consulta no debe ocultar la vía para registrar en otras subcampañas autorizadas. Visitante y plantador comparten esta experiencia; sus acciones adicionales se autorizan por contexto, no por el filtro elegido. La experiencia interna existente conserva su estructura y herramientas para el personal con facultades propias y sigue evolucionando para esa operación.

El resumen global usa únicamente campañas/subcampañas y hechos elegibles para consulta pública según RN-PLA-34. No incluye datos internos ocultos en los totales ni amplía por sí mismo los estados publicables. Agregados, mapa y detalle deben ser coherentes y contar cada hecho una vez; «global» no promete métricas de carbono, superficie plantada u otros indicadores sin fuente y regla aprobadas.

Fuera de alcance: alta de campañas, edición del plan, gestión de entregas, operación de Recolección/Vivero, editor general de plantaciones, reparto de crédito financiero y cálculo de superficie realmente plantada. No se promete composición viva por especie: la mortandad actual se registra por grupo y las reposiciones pueden usar otra especie.

## 4. Matriz de visibilidad — PA-DI05

La selección principal de campos públicos fue confirmada el 11 de octubre. Los detalles marcados pendientes/propuestos requieren revisión; esta decisión de diseño no publica datos reales por sí misma. Backend/Storage deben entregar la proyección acordada, sin exponer campos adicionales por reutilizar un perfil o una respuesta interna completos.

| Dato | Consulta pública sin sesión | Detalle propio autenticado | Consulta operativa/gestión contextual |
|---|---|---|---|
| Campaña, subcampaña, contexto y total inicialmente plantado | Confirmado; estados públicos elegibles de RN-PLA-34, sin filtro de pertenencia. No incorporar borradores/canceladas por inferencia. | Identificar ámbito y registro propios conservados sin abrir toda su gestión. | Mismo contexto y capacidades vigentes. |
| Polígono, ubicación y GPS de registros | Confirmados como información pública. Contrato/presentación por concretar, sin inventar coordenadas ni insinuar que el polígono es superficie plantada. | Mismos hechos; recuperación propia no depende de conservar permiso operativo. | La evaluación de GPS no da permisos ni acceso global a otras evidencias. |
| Fecha, identificador y cantidades plantadas | Fechas y cantidades confirmadas, con detalle progresivo; identificador permite referenciar el registro sin publicar datos técnicos de lotes por defecto. | Recibo persistido con ID y datos confirmados; contrato por concretar. | Un mismo hecho, sin copia por usuario. |
| Responsable y participantes históricos | Nombres y participantes confirmados; mostrar los realmente vinculados, no el equipo actual ni contactos/documentos. | Misma autoría pública; lectura privada ampliada del corresponsable pendiente. | Selección/gestión usa personas habilitadas actuales; no sustituye historia. |
| Organización/comunidad/empresa | Confirmada la distinción: organizaciones de la campaña y afiliaciones opcionales de cada participante se muestran por separado. Admitir contextos mixtos sin inferir una relación desde la otra ni atribuir todo el grupo a una organización. Representación histórica/actual pendiente. | No inferir financiación ni permiso desde afiliación. | Afiliación no altera autoridad, stock ni habilitación. |
| Fotografías de plantación | Fotos confirmadas; exclusión de metadatos de fotos confirmada. La entrega pública del archivo no expone EXIF u otros metadatos privados, bucket completo ni archivos pendientes. El GPS público del registro es un dato distinto. | Misma evidencia pública; campos privados adicionales sujetos al contrato. | Accesos/ciclo de vida de evidencia deben respetar alcance y propiedad. |
| Observaciones libres | No confirmadas; fuera del contrato público hasta decidir. Los metadatos de fotos ya están excluidos por decisión, no pendientes de aprobación pública. | Lectura propia según política a concretar. | Solo datos necesarios para la función autorizada. |
| Faltantes, reposiciones y bajas | Visibilidad confirmada; etiquetas/fórmulas por cerrar. Propuesta: faltan para meta inicial = máximo(meta − plantación inicial, 0); reposiciones y mortandad reportada por separado. | Los mismos indicadores, sin sumar correcciones o participantes como nuevas plantaciones. | Stock disponible es otro indicador; bajas no lo restauran automáticamente. |
| Roster actual, contactos y perfiles completos | Confirmado: no publicar contactos ni perfiles completos. Roster operativo fuera del contrato; colaboradores históricos no equivalen a equipo actual. | El historial propio no concede roster ni perfiles completos. | Búsqueda/lista mínima según PA-S03 y selección de participantes de PA-S01. Campos exactos pendientes. |
| Stock, asignaciones y herramientas de M1/M2 | Confirmado: no publicar stock disponible, tampoco detrás de «Ver más». No incluir contexto operativo interno en las respuestas públicas. | No se obtiene por autoría histórica ni tras revocación. | Solo stock pertinente a la acción autorizada, separado de bajas e indicadores públicos. No implica gestionar entregas ni acceder a todo Vivero/Recolección. |
| Meta/progreso y plan de especies | Proponer referencia orientativa que explique «faltan»; no confundirla con stock. Publicar la proyección necesaria, no abrir indiscriminadamente un contrato interno. | Leer un plan no amplía permisos. | GET /plan mantiene lectura autenticada según ADR-PLA-05; editar sigue reservado a ADMIN global. |

RN-PLA-34 ya contempla consulta sin autenticación; ADR-PLA-03 y la revisión de esta fecha delimitan esta experiencia. Revisar contratos y URLs existentes sin revocar silenciosamente trazabilidad pública previa ni exponer datos internos. Proponer aviso al registrar de que nombres, afiliación declarada, fotos y ubicación serán públicos. Mostrar indicadores reportados, no supervivencia comprobada por inspección inexistente. Esta consulta no incorpora nuevos flujos de escritura de mortandad/reposición al primer piloto.

## 5. Estados de experiencia

**Propuesta de presentación:** resumen de impacto con opción «Ver más» para indicadores/detalle públicos, distinguiendo plantación inicial, faltantes para meta, reposiciones y bajas. La ubicación y las etiquetas se revisan en el boceto; no se aprobó una fórmula adicional ni convertir stock en un dato público al desplegar detalles.

| Estado | Comportamiento esperado |
|---|---|
| Cargando | Indicar carga; no mostrar ceros como si fueran resultados confirmados. |
| Contenido disponible | Mapa, total y resumen corresponden al mismo alcance de consulta. |
| Sin resultados del filtro | Explicar el filtro aplicado y ofrecer limpiarlo; no afirmar que no hay plantaciones en todo el sistema. |
| Sin sesión o sin subcampañas asignadas | Puede consultar todo el impacto público. Si intenta registrar, PA-S00 explica iniciar sesión y/o habilitación según lo que falte; no se concede acceso operativo por defecto. |
| Error de lectura o desconexión | Mostrar que no se pudo actualizar y permitir reintentar; no reemplazar un total desconocido por cero ni confirmar un guardado. |
| Sesión vencida en lectura propia | Solicitar recuperar sesión sin mostrar datos privados de otro usuario ni degradar esa lectura a una respuesta pública ampliada. |
| Acceso retirado o URL no autorizada | Actualizar capacidades; conservar lectura propia acordada y rechazar contexto interno. El tratamiento 403/404 se concreta en el contrato. |
| Registro con corrección excepcional | Presentar vínculo e historial según PA-S04 y audiencia aprobada, sin sobrescribir silenciosamente el original. |

## 6. Escenarios de aceptación para revisión

| ID | Dado / cuando | Entonces |
|---|---|---|
| PA-S02-CA01 | Un visitante sin sesión abre un enlace a Impacto o al detalle de una campaña ajena. | Consulta los campos públicos confirmados sin login/perfil/asignación; no obtiene stock/equipo ni operaciones internas. También funciona con sesión expirada. |
| PA-S02-CA02 | Una persona abre un polígono y luego un registro. | Mantiene el contexto del recorrido; entiende «zona de trabajo» y «registro grupal». No se etiqueta el área del polígono como superficie plantada. |
| PA-S02-CA03 | Un registro de 30 plantas tiene tres participantes y dos organizaciones asociadas. | Aporta 30 al total físico, una sola vez, y conserva un identificador; un filtro o unión de tablas no lo convierte en 90 o 180. |
| PA-S02-CA04 | La persona consulta una organización y tiene permiso para plantar en una subcampaña de otra. | El filtro no altera permisos ni oculta la entrada operativa independiente a su ámbito autorizado. Cambiar afiliación no reasigna registros históricos. |
| PA-S02-CA05 | Se retira el permiso después de guardar. | El responsable abre su detalle y recibo; no obtiene equipo, stock ni nuevos envíos por ser autor. Para corresponsables se ejecuta la política específica que se apruebe en PA-DI05. |
| PA-S02-CA06 | Un usuario manipula un ID o llama directamente a una lectura privada. | Backend valida identidad y audiencia; no entrega campos prohibidos aunque la ruta visual esté oculta. Una respuesta privada nunca queda en una caché pública compartida. |
| PA-S02-CA07 | «Mis contribuciones» incluye un registro donde la persona es responsable y también figura entre participantes. | Si se aprueba esa vista, el registro aparece una sola vez y no se presenta como crédito individual exclusivo. No se reconstruye la participación desde membresías actuales. |
| PA-S02-CA08 | La meta es 40 y existen 50 plantas iniciales válidas. | La consulta puede mostrar 125% de avance, sin truncarlo a 100%, modificar la meta ni deducir cierre automático. Stock disponible se muestra como indicador distinto cuando está autorizado. |
| PA-S02-CA09 | Hay mortandad y reposición de otra especie en un grupo. | No se inventa composición viva por especie ni se suman reposiciones al avance de la meta inicial. Todo indicador expuesto tiene fórmula y fuente acordadas. |
| PA-S02-CA10 | Falla la lectura o no hay resultados con un filtro. | Se distinguen error, vacío filtrado y falta de asignación; ninguno se presenta como prueba de que un registro no se guardó. |
| PA-S02-CA11 | Una persona autenticada sin membresía consulta GET /plan. | Se conserva el contrato de ADR-PLA-05: puede leer; no puede editar, plantar ni gestionar acceso por esa lectura. Cualquier cambio exige revisión explícita. |
| PA-S02-CA12 | La persona consulta nombres, fotos, GPS, fechas, cantidades y afiliación por enlace público. | Se sirve la proyección confirmada sin contactos/perfil completo ni evidencias pendientes. Ausencia de afiliación se presenta como no declarada, sin inventarla. |
| PA-S02-CA13 | Meta 40, inicial 30, reposiciones 3, bajas reportadas 5. | Bajo la fórmula propuesta, «faltan para meta inicial» muestra 10; reposiciones 3 y bajas 5 se muestran por separado. No se presenta 10 como stock ni se cambia la cantidad inicial por reposiciones. Confirmar etiquetas/fórmulas antes del contrato. |
| PA-S02-CA14 | Hay un registro público de 30 en una campaña y otro de 20 en otra; también existen ámbitos internos no publicables. | El resumen global público muestra 50 plantas iniciales; al elegir cada campaña muestra 30 o 20. Mapa, totales y detalle comparten alcance; ni ámbitos internos ni uniones con personas/organizaciones inflan los indicadores. |
| PA-S02-CA15 | Un visitante o plantador profundiza desde el resumen global hasta el registro o abre su enlace directo. | Sigue en la experiencia reducida con campos públicos progresivos; nunca se le entrega una ficha interna completa. El plantador solo obtiene contexto privado adicional al acceder a una acción para la que está autorizado. |
| PA-S02-CA16 | La campaña está asociada a una organización y un registro reúne personas de Scouts, Palca y una sin afiliación declarada. | Organizaciones de campaña y afiliaciones personales se identifican por separado; no se afilia automáticamente a todos a la campaña ni se atribuye toda la cantidad a cada organización. No se inventa afiliación para quien no la declaró. |
| PA-S02-CA17 | Se consulta el detalle público, se despliega «Ver más» si existe y se descarga una foto mediante su URL pública. | No se entregan stock disponible, contactos o perfiles completos. El archivo público tampoco expone metadatos fotográficos excluidos: verificar imagen y URLs, no solo campos JSON. El mecanismo técnico debe preservar los originales y la evidencia histórica donde corresponda. |

Los casos con propuestas pendientes se convierten en pruebas ejecutables después de aprobar la decisión correspondiente; esta lista no acredita pruebas realizadas.

## 7. Decisiones y evidencia necesarias

- PA-DI08 cerrada: implementar y verificar consulta pública por enlace sin login; no queda pendiente elegir entre común y asignadas.
- PA-DI05 parcialmente cerrada: campos principales y exclusiones públicas confirmados; organizaciones de campaña distintas de afiliaciones personales. Precisar payloads, afiliación histórica/actual, presentación de GPS, entrega de fotos sin metadatos excluidos, observaciones libres, filtro inicial y lectura personalizada de corresponsables. Ver [acta](../revision-humana-2026-10-11.md).
- Definir etiquetas/fórmulas de los indicadores, tratamiento de correcciones y comportamiento ante datos legados incompletos. No inventar participantes ni snapshots que no existan.
- Revisar [plan](plan.md), [tareas](tasks.md) y [diseño técnico compartido](../diseno-tecnico-compartido.md) antes de construir los contratos afectados.

## 8. Trazabilidad

- [ADR-PLA-03, acuerdos y aclaración del 8 de octubre; ADR-PLA-04/05](../../../../decisiones/02_decisiones_plantacion.md).
- [Ficha LCO, alcance y objetivo](../../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md).
- [RN-PLA-01/17/18/19/25/31/34/36](../../../../03-plantacion-module/01_reglas_de_negocio_plantacion.md). La limitación de composición viva por especie de ADR-PLA-03 prevalece sobre cualquier promesa no sustentada por datos.
