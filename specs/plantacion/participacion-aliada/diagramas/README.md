# Diagramas y dependencias de PA-F01

**Actualizados:** 14 de octubre de 2026. Cinco fuentes Mermaid y SVG alineados con PA-S00–04, D01–D12 aceptadas y el tablero vigente. Son vistas de apoyo; no completan implementación, despliegue ni piloto.

**Situación:** INT02-A cerró identidad/perfil/privacidad en desarrollo. La siguiente entrega es [INT02-B](../implementacion/pa-t-int02-b.md); la secuencia backend continúa B → INT03-A → C → D. Consultar el [tablero único](../implementacion/README.md) para avance/tareas y el [mapa de dependencias](DEPENDENCIAS.md) para entender las condiciones. La [versión anterior](../archivo/diagramas-antes-2026-10-14/README.md) conserva las fuentes y renders previos.

| ID | Vista | Qué explica | Fuente editable | Render |
|---|---|---|---|---|
| PA-D01 | Contexto y límite | Impacto público, participación autorizada y gestión interna preservada; un dominio/stock común. | [Mermaid](PA-D01-contexto-limite.mmd) | [SVG](svg/PA-D01-contexto-limite.svg) |
| PA-D02 | Casos de uso | Autoridad contextual/global, lectura propia, continuidad administrativa y correcciones/reversiones. | [Mermaid](PA-D02-casos-uso.mmd) | [SVG](svg/PA-D02-casos-uso.svg) |
| PA-D03 | Actividades | Tres pasos, comando/cargas, LIFO atómico y recuperación del recibo sin duplicar. | [Mermaid](PA-D03-actividades-registro.mmd) | [SVG](svg/PA-D03-actividades-registro.svg) |
| PA-D04 | Modelo conceptual | Permisos distintos de logística; registro, snapshots, consumo, comando y recibo. | [Mermaid](PA-D04-modelo-conceptual.mmd) | [SVG](svg/PA-D04-modelo-conceptual.svg) |
| PA-D05 | Dependencias | Identidad ya disponible en desarrollo, B como siguiente entrega y consumidores hasta INT08. | [Mermaid](PA-D05-dependencias-implementacion.mmd) | [SVG](svg/PA-D05-dependencias-implementacion.svg) |

## PA-D05 — Qué debe estar preparado

![Dependencias de implementación](svg/PA-D05-dependencias-implementacion.svg)

B prepara permisos/vigencias/revisiones/auditoría y transición. El nodo catálogo/manifest muestra el cotejo y revisión necesarios para completar esa entrega; B prepara la propuesta concreta antes de su revisión/aplicación. INT03-A construye motor común, cargas, inicial LIFO, snapshots y recibo; C implementa gestión/capacidades y D cierra locks/rutas equivalentes/corte. Interfaces INT04/05/06 y correcciones INT07 consumen sus contratos. INT08 integra transición, QA, despliegue y decisión de piloto. El [análisis](DEPENDENCIAS.md) explica datos operativos y pendientes sin crear otro plan general. A completada en desarrollo no significa permisos contextuales, registro participante ni producción completados.

Encargos por equipo: [B](../implementacion/pa-t-int02-b.md) y [C](../implementacion/pa-t-int02-c.md) son backend/DB; [INT06](../implementacion/pa-t-int06.md) integra la interfaz frontend después de C verificada. Su boceto puede prepararse antes; D sigue siendo condición de QA/habilitación. La flecha C→INT06 representa la dependencia de las APIs, no obliga a posponer todo el trabajo visual.

## PA-D01 — Contexto y límite

![Contexto y límite](svg/PA-D01-contexto-limite.svg)

Impacto y sus enlaces públicos no exigen cuenta, sesión, perfil ni asignación; cuenta VOLUNTARIO sin permiso recibe la misma proyección. Alta/perfil no otorga autoridad; afiliación puede ser catálogo, Otra o ninguna. Plantador/administrador contextual opera solo en su ámbito; ADMIN global activo registra en cualquier ACTIVA sin permiso contextual adicional. La gestión interna preserva herramientas/facultades legítimas; no se abre por iniciar sesión. Stock ya entregado pertenece a la subcampaña: no añade recepción organizacional ni otro débito de Vivero. Originales de fotos privados, derivados públicos sanitizados y audiencias según PA-S02/contrato.

## PA-D02 — Casos de uso

![Casos de uso](svg/PA-D02-casos-uso.svg)

ADMIN contextual incorpora/retira plantadores dentro de su ámbito; ADMIN global designa/cambia/retira administradores y gestiona roles/baja de cuenta en operación separada del perfil. Nuevas habilitaciones en BORRADOR/ACTIVA; cerradas/canceladas solo retiros/reemplazos permitidos, sin reapertura. Proteger último contextual efectivo una vez inicializado, sin contar presencia global/logística; proteger último ADMIN global activo es otra garantía.

PA-S04 incluye ajustes de cantidad/participantes y reversiones de duplicados o plantación/baja/reposición erróneas por ambos administradores, solo en ACTIVA y según el caso. Cantidades exige ausencia de bajas/reposiciones, especies intactas, aumento por diferencia y reducción con error/disponibilidad física confirmados; cero queda fuera del ajuste simple. Participantes históricos registrados pueden corregirse sin permiso operativo actual, sin cambiar autoría, stock ni acceso. Observaciones sigue central. Compensaciones no cambian entrega/Vivero, no se aplican por cascada ni reabren. Casos/contratos/efectos de INT07 siguen pendientes de cierre integral propio. El diagrama representa autoridad de producto, no operaciones ya desplegadas.

## PA-D03 — Actividades de registro

![Actividades de registro](svg/PA-D03-actividades-registro.svg)

Tres pasos aprobados: **fotos/ubicación → cantidades/fecha/observaciones → participantes/resumen/confirmación**. No hay cuarta pantalla; seleccionar participantes no guarda. Responsable fijo de sesión, personas adicionales opcionales/elegibles y revisión sin ajustes automáticos. Ubicación confirmada y reajustable, con GPS o coordenadas manuales válidas; punto exterior evaluado permitido. Fecha Hoy editable dentro de la ventana inclusive de 10 días en America/La_Paz, y no antes de entregas efectivamente consumidas. Metas orientativas, especies del plan y saldo elegible; cierre manual, nunca automático por llegar a meta.

Preparar comando/fotos no reserva permiso, stock ni revisión de plan. En v1 el navegador envía cantidades por especie y plan_revision_esperada; el servidor reparte **LIFO por timestamp completo fecha_asignacion DESC, id DESC**, excluyendo entregas posteriores a la fecha elegida. Locks ASC es un orden independiente. Registro/detalles/snapshots/vínculos/consumo y recibo se confirman juntos; no se hace selección manual de lote ni reparto FIFO en cliente.

Tras respuesta perdida, recuperar el comando propio con misma clave/contenido; recibo terminal conserva resultado histórico sin repetir efectos ni exigir autoridad contextual para una nueva escritura. Cuenta/sesión válida sigue necesaria. 202 SIN_RESULTADO o 404 COMANDO_NO_CONFIRMADO son inconclusos; no autorizan clave nueva ni afirman EN_CURSO. Conflicto de contenido con misma clave rechaza sin cambiar el recibo. Un rechazo de negocio terminal requiere revisión y nueva confirmación con clave nueva; no revive al cambiar stock/permisos. Fallo del evaluador solo es rechazo sin efecto si hay recibo durable; si no, resolver incertidumbre. El diagrama simplifica errores de guard/DTO/infraestructura y recuperación de cargas, definidos en contrato §§6–7.

Abandono clausura preparación y limpia pendientes bajo su contrato. Si hubo envío inconcluso, no asumir abandono ni borrar fotos vinculadas: consultar resultado/cancelación atómica. No es aprobación administrativa, cola de comandos ni modo offline completo. Backend/recuperación participantes están pendientes en INT03-A/C/D/INT04; aceptación del mecanismo no acredita ejecución.

## PA-D04 — Modelo conceptual

![Modelo conceptual](svg/PA-D04-modelo-conceptual.svg)

Mapa de conceptos/relaciones, no ER físico ni migración aplicada. Persona conserva rol global; permiso contextual con vigencia/revisión es distinto de responsabilidad logística COORDINADOR/OPERARIO. ADMIN global se reconoce de forma derivada, no por filas contextuales automáticas. Un registro conserva responsable, participantes y snapshots conocidos; cambios actuales de perfil/organizaciones no reescriben el pasado. Afiliación retroactiva desconocida no se inventa desde perfil o campaña; ausencia declarada e historia no disponible son distintas.

Comando y recibo propio ligan intención a efecto/resultado. Cargas propias terminan vinculadas con el registro. Corrección conserva original/resultado efectivo/historial y reutiliza el motor, con efectos específicos aún por cerrar. Total físico no se multiplica por personas u organizaciones. Crédito/financiación, composición viva por especie, superficie realmente plantada y nuevos recorridos de seguimiento no se añaden por esta actualización.

## Lectura, fuentes y mantenimiento

- PA-D01–04 muestran relaciones/comportamientos objetivo; no son diagramas de infraestructura ni prueba de despliegue. PA-D02 es una vista simplificada de casos de uso, no UML exhaustivo.
- PA-D05 muestra dependencias de integración. Flechas convergentes requieren todas las condiciones; los bocetos/preparaciones pueden solaparse sin habilitar operación antes de verificar garantías.
- Verde en A/perfil: alcance acreditado en desarrollo. Azul: base o relación descrita. Ámbar: siguiente entrega, mecanismo/efecto a implementar o verificar. Resultado verde de PA-D03 es éxito esperado del recorrido, no prueba ejecutada.
- Fuentes vigentes: [tablero](../implementacion/README.md), [ESTADO.md](../../../../ESTADO.md), [contrato D01–D12](../contrato-identidad-permisos-backend-propuesta.md), [PA-S00](../00-experiencia-participante/spec.md), [PA-S01](../01-registro-plantacion-inicial/spec.md), [PA-S02](../02-consulta-impacto-y-registros/spec.md), [PA-S03](../03-gestion-acceso-subcampania/spec.md) y [PA-S04](../04-correccion-excepcional/spec.md). Antecedentes y evidencia fechada en el archivo; el LCO conserva su cierre histórico.
- Editar .mmd y regenerar SVG juntos. [Configuración](mermaid-config.json). Fuentes/renders anteriores y su análisis se mantienen en el archivo.

Con Mermaid CLI disponible, desde la raíz del repositorio:

```sh
mmdc -i specs/plantacion/participacion-aliada/diagramas/PA-D05-dependencias-implementacion.mmd -o specs/plantacion/participacion-aliada/diagramas/svg/PA-D05-dependencias-implementacion.svg -c specs/plantacion/participacion-aliada/diagramas/mermaid-config.json -b white
```

Esta actualización verificó fuentes, enlaces y renderizado; no repitió las pruebas de aplicación ni aplicó SQL, permisos o despliegues. El [mapa de dependencias](DEPENDENCIAS.md) distingue evidencias cerradas de implementación y validación pendientes.
