# PA-S02 — Consulta de impacto y registros

**Estado:** borrador para revisión humana; no aprobado para implementación. **Actualización:** 10 de octubre de 2026. **Prioridad de elaboración:** P1; la política de lectura y los contratos que utiliza el registro son dependencias tempranas.

## 1. Resultado y relación con las otras specs

Una persona entiende el impacto de las plantaciones y puede llegar a los registros que lo explican sin recorrer las herramientas internas de Recolección, Vivero o gestión de campañas. Una persona que registró una plantación también puede recuperar su resultado guardado, incluso después del retiro de su permiso operativo.

[PA-S00 — Experiencia participante](../00-experiencia-participante/spec.md) define la entrada, navegación y separación de experiencias. Esta spec define qué se consulta y cómo se interpreta. [PA-S03](../03-gestion-acceso-subcampania/spec.md) resuelve permisos operativos; [PA-S01](../01-registro-plantacion-inicial/spec.md), el guardado. La lectura de un registro no vuelve a registrarlo ni consume stock.

**Decisión pendiente PA-DI08:** conservar consulta común de impacto o limitar la experiencia participante a campañas con subcampañas asignadas. La consulta común acordada en ADR-PLA-03 es la referencia de este borrador. Se propone conservar el contenido de impacto autorizado para esa audiencia y separar claramente «dónde puedo plantar»; esta aplicación de la propuesta al nuevo ingreso necesita revisión humana. Ni la asignación a una campaña ni la afiliación organizacional definen por sí solas la política de lectura.

Esto no introduce un estado «publicada» en `CAMPANIA`: su estado sigue siendo derivado. Una eventual decisión de restringir todas las lecturas a ámbitos asignados exige revisar explícitamente los contratos afectados, incluido el acceso autenticado a GET /plan de ADR-PLA-05; no queda hecha mediante esta spec.

## 2. Historias de usuario

| ID | Historia | Resultado verificable |
|---|---|---|
| PA-S02-US01 | Como persona recién registrada y sin permisos operativos, quiero ver una consulta de impacto comprensible para entender el trabajo realizado. | Ve contenido autorizado para su audiencia y una explicación si no hay resultados; no recibe equipo, stock interno ni acciones operativas por crear su cuenta. |
| PA-S02-US02 | Como participante de una subcampaña, quiero reconocer su zona y registros sin revisar toda la administración. | Desde el mapa abre resumen y luego detalle; las acciones adicionales dependen de capacidades vigentes en esa subcampaña. |
| PA-S02-US03 | Como responsable de un registro, quiero volver a consultar lo que quedó guardado para comprobar cantidades y resultado. | Abre el mismo registro persistido, con identificador y datos permitidos, también después de una revocación. |
| PA-S02-US04 | Como persona que figura como corresponsable, quiero encontrar las plantaciones en las que consto sin que se atribuya todo el grupo como trabajo individual mío. | Propuesta para «Mis contribuciones»: agrupar por registros únicos y distinguir «registré» de «figuro como participante». Alcance y campos pendientes de PA-DI05. |
| PA-S02-US05 | Como persona que consulta, quiero entender qué significan el mapa y sus cantidades para no confundir zona de trabajo, árboles plantados y supervivencia. | Un punto representa un registro grupal; las etiquetas distinguen plantación inicial, reposiciones y saldo vivo cuando esos indicadores se incluyan. |

«Observador» describe la experiencia de consulta; no crea un rol global ni un permiso contextual asignable.

## 3. Alcance y recorrido

1. Entrar en Impacto con mapa y total de plantación inicial del conjunto consultado. El texto debe nombrar el indicador; no sumar reposiciones bajo una etiqueta ambigua de cumplimiento de meta.
2. Tocar un polígono y abrir su resumen en la misma vista, manteniendo el contexto del mapa. El polígono representa la zona de trabajo, no la superficie efectivamente plantada.
3. Abrir progresivamente detalle de subcampaña y registros. Cada punto corresponde a un registro grupal; agrupar puntos visualmente por proximidad no debe cambiar su identidad ni multiplicar cantidades.
4. Mostrar registro/stock relevante solo a quien tenga la capacidad operativa correspondiente; gestión de plantadores solo al administrador contextual autorizado. Consultar no concede esas capacidades.
5. Permitir volver al mapa conservando el filtro y la selección, como propuesta de UX. El registro rápido de PA-S00/PA-S01 no exige completar este recorrido.

Organización y campaña sirven como contexto o filtros opcionales. No es obligatorio recorrer organización → campaña → subcampaña ni tener afiliación. Queda pendiente el filtro inicial con varias afiliaciones o ninguna; un filtro de consulta no debe ocultar la vía para registrar en otras subcampañas autorizadas. La experiencia interna existente se conserva para el personal con facultades propias.

Fuera de alcance: alta de campañas, edición del plan, gestión de entregas, operación de Recolección/Vivero, editor general de plantaciones, reparto de crédito financiero y cálculo de superficie realmente plantada. No se promete composición viva por especie: la mortandad actual se registra por grupo y las reposiciones pueden usar otra especie.

## 4. Matriz de visibilidad propuesta — PA-DI05

La matriz es una propuesta para revisar campo por campo, no una autorización de publicación. La regla general es entregar desde backend solo la proyección permitida; ocultar un elemento de la pantalla no basta. Las respuestas públicas existentes de impacto no aprueban automáticamente campos de perfiles, stock o nuevas consultas privadas.

| Dato | Consulta común | Detalle propio autenticado | Consulta operativa/gestión contextual |
|---|---|---|---|
| Campaña, subcampaña, contexto y total inicialmente plantado | Mostrar contenido autorizado para esa audiencia. Aplicar estados públicos elegibles de RN-PLA-34; no incorporar borradores/canceladas en la consulta común. | Identificar el ámbito y registro propios conservados, sin abrir toda la gestión del ámbito. | Mismo contexto y capacidades actuales del actor. |
| Polígono y puntos de registros | Mapa acordado; precisión del GPS, campos de coordenadas y forma de acceso todavía por cerrar. | Proponer ubicación del registro propio, con campos exactos por revisar. | Información necesaria para la operación autorizada; no implica publicar coordenadas fuera de esa audiencia. |
| Identificador, fecha y cantidades iniciales por especie | Proponer detalle progresivo, sin datos técnicos de lotes por defecto. | Proponer recibo persistido con identificador, fecha y cantidades registradas. | Reutilizar hechos del mismo registro, sin copia por usuario. |
| Responsable y participantes históricos | Mostrar quién consta realmente, conforme al acuerdo; formato de nombres/identificadores y detalle de participantes pendiente. No inferirlos desde el equipo actual. | Identificar al responsable; revisión explícita de qué datos de otras personas aparecen. Lectura ampliada del corresponsable pendiente. | Selección/gestión usa personas habilitadas actuales; no sustituye el historial del registro. |
| Fotografías, sus metadatos y observaciones | Pendiente; no incorporarlos automáticamente al nuevo contrato. Publicar una foto no autoriza publicar sus metadatos completos. | Proponer evidencia y observaciones propias; resolver accesos/URLs y datos de terceros antes de implementar. | Solo lo necesario para la función autorizada; ser administrador contextual no publica la evidencia. |
| Roster actual, contactos y perfiles completos | No incluir roster ni contactos en la consulta común propuesta. Colaboradores históricos no equivalen a equipo actual. | El historial propio no concede roster ni perfiles completos. | Búsqueda/lista mínima según PA-S03 y selección de participantes de PA-S01. Campos exactos pendientes. |
| Stock, asignaciones y herramientas de M1/M2 | No incluir el contexto operativo interno en la nueva respuesta de impacto. | No se obtiene por autoría histórica ni tras revocación. | Solo stock pertinente a la acción autorizada. No implica gestionar entregas ni acceder a todo Vivero/Recolección. |
| Meta/progreso y plan de especies | Presentación simplificada por revisar; separar meta orientativa de stock disponible. | Leer un plan no amplía permisos. | GET /plan mantiene la lectura para cualquier usuario autenticado existente según ADR-PLA-05; su edición sigue reservada a ADMIN global. |

RN-PLA-34 describe una transparencia pública amplia del modelo previo. ADR-PLA-03 dejó pendientes los campos concretos de este incremento. Antes de implementar se debe conciliar esa base con esta matriz y con los endpoints existentes: una reducción de navegación no equivale a revocar APIs públicas, y una restricción de API requiere una decisión explícita. No cambiar silenciosamente contratos previos.

## 5. Estados de experiencia

| Estado | Comportamiento esperado |
|---|---|
| Cargando | Indicar carga; no mostrar ceros como si fueran resultados confirmados. |
| Contenido disponible | Mapa, total y resumen corresponden al mismo alcance de consulta. |
| Sin resultados del filtro | Explicar el filtro aplicado y ofrecer limpiarlo; no afirmar que no hay plantaciones en todo el sistema. |
| Sin subcampañas asignadas | Puede consultar según PA-DI08; no aparece acceso operativo por defecto. PA-S00 explica cómo continuar con el equipo conocido. |
| Error de lectura o desconexión | Mostrar que no se pudo actualizar y permitir reintentar; no reemplazar un total desconocido por cero ni confirmar un guardado. |
| Sesión vencida en lectura propia | Solicitar recuperar sesión sin mostrar datos privados de otro usuario ni degradar esa lectura a una respuesta pública ampliada. |
| Acceso retirado o URL no autorizada | Actualizar capacidades; conservar lectura propia acordada y rechazar contexto interno. El tratamiento 403/404 se concreta en el contrato. |
| Registro con corrección excepcional | Presentar vínculo e historial según PA-S04 y audiencia aprobada, sin sobrescribir silenciosamente el original. |

## 6. Escenarios de aceptación para revisión

| ID | Dado / cuando | Entonces |
|---|---|---|
| PA-S02-CA01 | Una cuenta nueva sin permisos abre Impacto. | Ve solo la proyección autorizada para su audiencia; no obtiene menús ni payloads de stock/equipo/operación interna por el alta. El conjunto de campañas se decide en PA-DI08. |
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

Los casos con propuestas pendientes se convierten en pruebas ejecutables después de aprobar la decisión correspondiente; esta lista no acredita pruebas realizadas.

## 7. Decisiones y evidencia necesarias

- PA-DI08 en [PA-S00](../00-experiencia-participante/spec.md): conjunto consultable en la nueva experiencia y coherencia con los contratos de lectura existentes.
- PA-DI05 en el [plan de integración](../plan-reutilizacion-integracion.md): campos, fotos, precisión/acceso a GPS, roster frente a historia, filtro inicial y detalle propio de corresponsables. Revisar ejemplos de payload por audiencia y pantallas sin datos personales reales.
- Definir etiquetas/fórmulas de los indicadores, tratamiento de correcciones y comportamiento ante datos legados incompletos. No inventar participantes ni snapshots que no existan.
- Revisar [plan](plan.md), [tareas](tasks.md) y [diseño técnico compartido](../diseno-tecnico-compartido.md) antes de construir los contratos afectados.

## 8. Trazabilidad

- [ADR-PLA-03, acuerdos y aclaración del 8 de octubre; ADR-PLA-04/05](../../../../decisiones/02_decisiones_plantacion.md).
- [Ficha LCO, alcance y objetivo](../../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md).
- [RN-PLA-01/17/18/19/25/31/34/36](../../../../03-plantacion-module/01_reglas_de_negocio_plantacion.md). La limitación de composición viva por especie de ADR-PLA-03 prevalece sobre cualquier promesa no sustentada por datos.
