# Tabla compartida de comandos: elección y explicación del flujo

> **Planificación anterior archivada.** Conserva trazabilidad y propuestas de su fecha. Para ejecutar, leer el [tablero actual](../implementacion/README.md) y el [contrato D01–D12 aceptado](../contrato-identidad-permisos-backend-propuesta.md). Las propuestas de PA-S04 conservan su revisión propia.

**Fecha:** 12 de octubre de 2026; revisión técnica del 13. **Estado:** registro común de comandos elegido por el usuario y diseño concreto aceptado en D09–D11 del contrato backend. `participacion_comando`, preparación/terminal/huella/cancelación y retención del piloto están definidos; catálogo, migraciones, código y ejecución pendientes. Implementar primero plantación.

**Revisión técnica aceptada el 13 de octubre:** D01–D12 del [contrato backend](../contrato-identidad-permisos-backend-propuesta.md) quedan aceptadas por Pablo, con ajustes D02/D07. La inicial consume LIFO del stock disponible de su subcampaña (`fecha_asignacion DESC, id DESC`), sin nueva recepción por organización/administradores ni segundo débito de Vivero. Afiliación opcional: organización existente del catálogo o «Otra»; snapshots históricos conservados. Esa versión concreta prevalece sobre los nombres/candidatos anteriores; la aceptación de diseño no marca implementación, migraciones o pruebas como completadas.

## 1. Responsabilidad de la tabla

Un comando es una solicitud concreta de cambiar datos: registrar una plantación, otorgar un permiso o realizar una corrección. La tabla compartida conserva su identidad y resultado para que repetir la solicitud recupere el mismo resultado sin repetir los efectos.

Plantación sigue en `registro_plantacion`; permisos y correcciones siguen en sus estructuras de dominio. El registro común apunta a sus resultados. Compartir infraestructura de recuperación no comparte automáticamente permisos entre operaciones y no crea una cola, un worker ni una aprobación administrativa.

## 2. Datos lógicos mínimos

| Dato | Propósito |
|---|---|
| Clave `comando_id` | UUID generado por frontend y conservado para la misma operación. Unificar el nombre hoy alternado con `intento_id` en CT04; DTO final pendiente. |
| `actor_id` | Usuario resuelto por backend desde JWT verificado. No confiar en actor del body. |
| `operacion` | Tipo cerrado que selecciona validación/autorización específica; por ejemplo registro inicial, cambio de acceso o corrección. |
| `huella` | Hash de contenido canónico calculado en servidor. Distingue repetición equivalente de reutilización de clave con otros datos. |
| Resultado terminal | Confirmación con referencia/recibo mínimo o rechazo de negocio durable sin efectos. |
| Fechas | Tiempos del servidor para trazabilidad y política de retención. |

Restricción esencial: unicidad `(actor_id, operacion, comando_id)`. La huella comprende campos con efecto de negocio y referencias de evidencias, con normalización explícita de listas, fechas y valores. No copiar archivos, perfiles completos ni contactos en el recibo. El hash de una foto no sustituye la huella del comando completo.

## 3. Paso a paso: registrar 30 plantas

1. **Preparar.** Usuario revisa el formulario y confirma. Frontend crea una clave UUID una vez para ese envío y conserva clave/contenido/referencias de fotos por cuenta. Doble clic, timeout o recarga no generan otra clave para la misma solicitud incierta. Una modificación tras rechazo confirmado o un trabajo nuevo sí tiene una identidad nueva.
2. **Acreditar identidad.** Backend verifica JWT, resuelve usuario y calcula huella normalizada. No toma actor/rol desde el navegador. Las cargas previas tienen referencias recuperables y propiedad verificable; la pérdida de respuesta del upload no debe provocar otra carga ciega.
3. **Buscar resultado anterior.** Si ya hay comando terminal del mismo actor/operación/clave, comparar huella. Coincide: devolver el resultado guardado. Difiere: conflicto sin escribir. Esta recuperación propia sucede antes de exigir permiso actual para una nueva escritura; no entrega stock/equipo ni permite registrar después de revocación.
4. **Ordenar una operación nueva.** Si aún no hay resultado terminal, entrar a la transacción PostgreSQL con la disciplina de bloqueos común de cuentas/ámbitos/comando de las instrucciones. Reclamar la clave con unicidad y volver a comprobar si otro proceso ya confirmó. Ausencia en la consulta anterior no demuestra que nadie esté ejecutando.
5. **Autorizar y validar.** Bajo bloqueos, revisar rol/permiso vigente, ACTIVA, plan, fecha, coordenadas/PostGIS, personas, propiedad/tipo/estado de fotos y stock. Backend resuelve LIFO por especie. Ninguna validación del frontend reserva stock o permiso.
6. **Guardar todo junto.** Crear registro/detalles/participantes, consumir 30 de las asignaciones elegibles, vincular fotos y escribir comando confirmado con el comprobante mínimo dentro de la misma transacción. No descontar nuevamente Vivero. Commit publica ambos: hecho y resultado recuperable.
7. **Devolver.** Frontend recibe confirmación, muestra comprobante y actualiza contexto. Si se pierde la respuesta, mantiene la clave y muestra resultado pendiente de confirmar; consulta el comando y recupera el registro original.
8. **Reintentar con identidad estable.** Si todavía no hay resultado verificable, conservar/repetir la misma clave y contenido conforme al contrato. Unicidad y transacción hacen que las peticiones converjan en un resultado. No crear una nueva solicitud para repetir una operación incierta ni eliminar sus fotos por timeout.

Ejemplo: disponible 100, comando A registra 30, quedan 70. Se pierde la respuesta. Consultar/repetir A devuelve ese registro y el saldo sigue 70. A con 35 produce conflicto sin efecto. Otro trabajo de 10 usa B y, si cumple las reglas actuales, deja 60.

## 4. Tres situaciones que deben distinguirse

| Situación | Qué significa | Qué hace frontend |
|---|---|---|
| CONFIRMADO durable | Efectos y recibo guardados juntos | Mostrar el comprobante original; no volver a consumir. |
| RECHAZADO durable | Validación de negocio concluyó sin efectos | Mostrar causa; mismo comando recupera el rechazo. Corregir contenido y confirmar otra acción usa clave nueva. |
| Sin resultado concluyente | Puede haber transacción en curso o rollback por infraestructura | Mantener clave/datos y consultar/repetir según contrato. Ni timeout ni 404 aislado prueban rechazo. |

El desconocimiento del cliente no debe guardarse como si fuera un rechazo del servidor. Un estado EN_CURSO visible y sus códigos HTTP solo pueden prometerse si el mecanismo permite observarlo; no asumir que se ve una fila insertada dentro de una transacción aún sin commit.

Para conservar un rechazo de negocio, la implementación puede guardar el comando y usar una subtransacción/savepoint para revertir todos los efectos de dominio antes de confirmar el recibo de rechazo. Un fallo inesperado de infraestructura puede revertir la transacción completa: no inventar un rechazo durable ni una confirmación. Esta técnica sigue por verificar mediante pruebas PostgreSQL.

## 5. Fotos, permisos y correcciones

Storage no participa en la transacción PostgreSQL. Subida recuperable, propiedad, limpieza y retención requieren contrato propio; pueden reutilizar referencias/infraestructura del comando donde corresponda. La vinculación DB y el comprobante sí se confirman con la plantación. Revisar objetos pendientes privados y no limpiar cargas mientras el resultado es incierto.

Cambios de acceso y correcciones usan el mismo registro de comandos con políticas específicas: una repetición de otorgamiento no crea otra vigencia/auditoría, y una repetición de corrección no compensa stock dos veces. La autoridad de PLANTADOR no se amplía por conocer una clave ni por poder consultar su recibo.

Antes de implementar: fijar DTO/rutas y estados observables, esquema/índices/RLS/grants, canonicalización, rechazos durables, retención de claves y recuperación de fotos, compatibilidad de clientes y bloqueos con las RPC actuales. Probar dos solicitudes simultáneas, timeout antes/después de commit, contenido distinto, revocación, foto ajena y competencia por stock. Claves mínimas conservadas durante el piloto sigue siendo propuesta de retención, no nueva decisión de esta elección.

Fuentes: [contraste actual y opciones](revision-contratos-2026-10-12.md#6-definición-propuesta-para-consulta-del-mismo-intento), [instrucciones CT04/05 y secuencia](instrucciones-implementacion.md), [PA-S03](../03-gestion-acceso-subcampania/contratos.md) y [PA-S04](../04-correccion-excepcional/spec.md).
