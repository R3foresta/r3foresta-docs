# Plan — PA-S03

**Estado:** diseño propuesto para revisión; no autoriza implementación, migración ni cambios de acceso real. **Actualización:** 11 de octubre de 2026.

**Producto confirmado en llamada:** se pueden preparar asignaciones de acceso desde BORRADOR, incluida la primera designación de administrador por ADMIN global y la incorporación de plantadores por el administrador autorizado. Registrar plantación inicial sigue requiriendo ACTIVA. Nuevos plantadores solo en BORRADOR/ACTIVA; cerradas/canceladas admiten retiros y reemplazo central de administradores con protección del último. Cerrar mantiene las personas/asignaciones existentes y las facultades internas de mantenimiento que correspondan. Incorporar esta matriz en contratos; el mecanismo de inicialización y la transición legada siguen pendientes.

## 1. Orden de trabajo

| Paso estable | Trabajo y motivo | Evidencia para avanzar |
|---|---|---|
| PA-T12 | Proponer correspondencia/migración frente al modelo vigente, incluida alta y personal interno de PA-S00. Resolver PA-DI01/02/03/09 antes de cambiar autorización. | Inventario de capacidades/consumidores y tabla de transición revisada. Cada permiso tiene fuente, actor y ámbito; no hay herencia organizacional ni equivalencia automática de COORDINADOR. |
| PA-T13 | Modelar transiciones y protección del último administrador; ordenar autorización de registro y retiro. | Contratos de comandos y pruebas concurrentes con orden controlado. Incluir primera designación, cambio a plantador, retiro completo y conservación de historia. |
| PA-T14 | Verificar selección masiva todo-o-nada, confirmada en producto, sin herencia futura. | Contrato de respuesta y mecanismo transaccional revisados; lista explícita de IDs actuales y validación de autoridad en todos. |

El motor de permisos es una dependencia de PA-S01. La pantalla completa de gestión puede implementarse después de su contrato, pero el primer recorrido de registro necesita ya una persona habilitada, retiro comprobable e identidad confiable. La fecha del piloto no permite posponer esas garantías.

ADMIN global puede registrar directamente en cualquier subcampaña ACTIVA, sin asignación contextual, conforme al acuerdo de producto. La política efectiva distingue esa autoridad verificada de los permisos contextuales; retirar estos no revoca el rol global. No sustituye las validaciones de PA-S01. La propuesta de reapertura fue descartada del alcance actual tras revisar los requerimientos (ADR-PLA-06); se conserva el rechazo de cerrada/cancelada a ACTIVA y no se diseña un comando de reapertura.

## 2. Reparto por capa

| Capa | Trabajo propuesto | Comprobación |
|---|---|---|
| Frontend | Reutilizar componentes de equipo/búsqueda donde sirvan; presentar responsabilidades en lenguaje comprensible, ámbitos seleccionados y consecuencias de retirar/cambiar acceso. Integrar capacidades de PA-S00, estados de guardado y recuperación. | Cuenta nueva sin módulos internos; administrador contextual sin acciones centrales; personal interno mantiene sus herramientas autorizadas. No descargar equipos ajenos para filtrarlos en cliente. |
| Backend | Identidad JWT verificada, política contextual por acción y ámbito, búsqueda mínima de personas registradas, listado autorizado y comandos explícitos. Revisar rutas legadas equivalentes y asignación de roles desde perfil. | Llamadas directas/IDs ajenos rechazadas; alta/perfil no autoasignan privilegios; gestionar plantadores no habilita plan, cierre, Vivero o Recolección. |
| Base de datos | Elegir estructura contextual y transición según PA-DI01/02; unicidad del acceso vigente persona/subcampaña, referencias de identidad/ámbito y auditoría. Comandos atómicos para cambio de permisos e invariante del último administrador. | No duplicación de permisos activos; bloqueo consistente con registro; historial preservado y ningún retiro eludible desde rutas/RPC legadas. |

La propuesta de tablas y contratos vive en [diseño técnico compartido](../diseno-tecnico-compartido.md). Una tabla contextual separada puede convivir con responsabilidades internas legadas, pero debe quedar inequívoco cuál autoriza el nuevo registro y cómo se resuelve cada consumidor. No crear otra tabla de usuarios o permisos por organización para este piloto.

## 3. Transacción y concurrencia

Propuesta técnica: serializar cambios de permiso y autorización del registro por subcampaña dentro de PostgreSQL, con un orden estable compatible con bloqueos de plan, asignaciones y stock. El punto de autorización se produce con identidad/permiso vigente comprobados dentro de ese orden. El mecanismo exacto debe revisarse antes de implementar.

Para retirar o cambiar un administrador, comprobar autoridad central y existencia de otro administrador dentro de la misma transacción que modifica el permiso y registra auditoría. Una consulta de conteo previa en la aplicación no evita que dos retiros simultáneos eliminen a ambos. Para la baja administrativa de la cuenta del último administrador, el usuario exige reemplazo previo con cuenta activa y permiso vigente en cada ámbito afectado. Integrar la inactivación de cuenta en el orden transaccional y revalidar la continuidad al ejecutar, no solo antes desde la aplicación. Los demás supuestos de inactivación requieren política propia.

Para una acción masiva, fijar los IDs antes de confirmar y revalidarlos durante ejecución. El usuario confirmó todo-o-nada para el piloto: si alguna validación o ejecución falla, ningún cambio de ese comando queda aplicado y se conservan los permisos previos. El bloqueo por IDs en orden estable es una propuesta técnica por revisar, junto con el contrato de errores y recuperación. Una subcampaña creada después queda fuera. No usar comodín de campaña ni recalcular «todas» para ampliar el conjunto enviado.

La auditoría propuesta conserva actor, fecha, acción, persona afectada, subcampaña y responsabilidad anterior/nueva, vinculada al comando. Campos y necesidad de motivo se concretan en el contrato. Un retiro no borra membresías históricas necesarias para leer registros. No toca plantaciones, consumos físicos, metas ni saldos.

## 4. Contratos y migración a revisar

- Consulta autenticada de capacidades propias por subcampaña, separada de impacto común y caché pública; la sesión/perfil del cliente no es fuente de autoridad.
- Búsqueda de personas registradas por nombre y correo exacto, confirmada en producto, con autorización y paginación. Mostrar nombre y afiliación declarada opcional; usar correo para buscar sin devolver listados de contactos. Diseñar normalización, coincidencias y manejo de homónimos; no incluir creación de usuario, invitaciones o solicitudes. El alta/perfil de PA-S00 no permite elegir permisos globales o contextuales.
- Incorporar/retirar plantador y designar/cambiar/retirar administrador como acciones diferenciadas, con ámbito explícito y resultado recuperable. Definir repetición idéntica, versión/conflicto y recuperación tras respuesta perdida.
- Permiso contextual retirado frente a lectura propia y recuperación del intento de PA-S01: recuperar un resultado guardado no requiere reautorizar una escritura nueva.
- Transición de COORDINADOR/OPERARIO y roles globales: ensayar sobre copia controlada, conservar historia y facultades internas revisadas; no alterar la restricción legada ni trasladar usuarios masivamente sin decidir responsabilidades de activación/entregas/devoluciones.
- Primera designación por autoridad central y preparación de ámbitos legados antes de activar el nuevo modelo. Documentar compatibilidad de clientes/versiones y cierre de rutas antiguas que evitarían la política nueva.

## 5. Verificación y salida

Preparar PA-S03-CA01..22 con usuarios sintéticos: cuenta nueva, plantador de Norte, administrador de Norte/Sur, autoridad central, usuario ajeno y personal interno con facultades existentes. Incluir una persona global VOLUNTARIO autorizada contextualmente, una independiente y una de otra organización. Comprobar que preparar acceso en BORRADOR no permite registrar antes de ACTIVA, la baja administrativa con reemplazo previo, el registro directo de ADMIN global sin asignación contextual y ambas formas de búsqueda con datos mínimos. CA19/20 conservan las restricciones existentes de estado: sin reapertura ni plantación inicial en cerradas/canceladas. CA21/22 verifican permanencia de asignaciones al cerrar y la matriz contextual de gestión, preservando mantenimiento y gestión interna permitidos. No requieren un nuevo contrato de reapertura ni ajustes de fechas.

Las pruebas unitarias/HTTP validan políticas y contratos; las garantías de último administrador y retiro/registro requieren PostgreSQL aislado con ejecución concurrente real. Probar ambos órdenes de autorización y retiro, además de dos retiros concurrentes y selección masiva con autoridad obsoleta. La UI debe coincidir con el resultado persistido.

Salida: comportamiento y transición revisados por el usuario; contratos aprobados; implementación posterior verificada por capas; migración ensayada y regresión de usuarios internos, plan, activación, entregas/devoluciones y lectura propia. No declarar despliegue o permiso real aplicado a partir de este documento.

## 6. Elaboración de contratos autorizada en llamada

El usuario confirma preparar los contratos técnicos antes de programar/ejecutar funciones. La [propuesta de contratos](contratos.md) describe cada acción desde la confirmación en pantalla hasta el resultado guardado: entrada, identidad verificada, autoridad/estado, persistencia y auditoría, respuesta, repetición/conflicto y recuperación. Son acuerdos entre UX, backend y base de datos sobre los mismos permisos y hechos.

Preparar primero búsquedas y lectura de capacidades; después habilitar/retirar plantadores, administrar/reemplazar administradores y operación masiva todo-o-nada. Concretar los comandos junto con la fuente única de permiso y la transición PA-DI01/02, incluyendo reemplazo protegido y conservación de facultades internas. Se proponen mensajes y casos concretos para revisar consecuencias de uso; no se vuelve a pedir elección sobre las reglas ya confirmadas.
