# Plan — PA-S03

**Estado:** diseño propuesto para revisión; no autoriza implementación, migración ni cambios de acceso real. **Fecha:** 10 de octubre de 2026.

## 1. Orden de trabajo

| Paso estable | Trabajo y motivo | Evidencia para avanzar |
|---|---|---|
| PA-T12 | Proponer correspondencia/migración frente al modelo vigente, incluida alta y personal interno de PA-S00. Resolver PA-DI01/02/03/09 antes de cambiar autorización. | Inventario de capacidades/consumidores y tabla de transición revisada. Cada permiso tiene fuente, actor y ámbito; no hay herencia organizacional ni equivalencia automática de COORDINADOR. |
| PA-T13 | Modelar transiciones y protección del último administrador; ordenar autorización de registro y retiro. | Contratos de comandos y pruebas concurrentes con orden controlado. Incluir primera designación, cambio a plantador, retiro completo y conservación de historia. |
| PA-T14 | Verificar selección masiva sin herencia futura. | Propuesta revisada de atomicidad y respuesta por selección; lista explícita de IDs actuales y validación de autoridad en todos. |

El motor de permisos es una dependencia de PA-S01. La pantalla completa de gestión puede implementarse después de su contrato, pero el primer recorrido de registro necesita ya una persona habilitada, retiro comprobable e identidad confiable. La fecha del piloto no permite posponer esas garantías.

## 2. Reparto por capa

| Capa | Trabajo propuesto | Comprobación |
|---|---|---|
| Frontend | Reutilizar componentes de equipo/búsqueda donde sirvan; presentar responsabilidades en lenguaje comprensible, ámbitos seleccionados y consecuencias de retirar/cambiar acceso. Integrar capacidades de PA-S00, estados de guardado y recuperación. | Cuenta nueva sin módulos internos; administrador contextual sin acciones centrales; personal interno mantiene sus herramientas autorizadas. No descargar equipos ajenos para filtrarlos en cliente. |
| Backend | Identidad JWT verificada, política contextual por acción y ámbito, búsqueda mínima de personas registradas, listado autorizado y comandos explícitos. Revisar rutas legadas equivalentes y asignación de roles desde perfil. | Llamadas directas/IDs ajenos rechazadas; alta/perfil no autoasignan privilegios; gestionar plantadores no habilita plan, cierre, Vivero o Recolección. |
| Base de datos | Elegir estructura contextual y transición según PA-DI01/02; unicidad del acceso vigente persona/subcampaña, referencias de identidad/ámbito y auditoría. Comandos atómicos para cambio de permisos e invariante del último administrador. | No duplicación de permisos activos; bloqueo consistente con registro; historial preservado y ningún retiro eludible desde rutas/RPC legadas. |

La propuesta de tablas y contratos vive en [diseño técnico compartido](../diseno-tecnico-compartido.md). Una tabla contextual separada puede convivir con responsabilidades internas legadas, pero debe quedar inequívoco cuál autoriza el nuevo registro y cómo se resuelve cada consumidor. No crear otra tabla de usuarios o permisos por organización para este piloto.

## 3. Transacción y concurrencia

Propuesta técnica: serializar cambios de permiso y autorización del registro por subcampaña dentro de PostgreSQL, con un orden estable compatible con bloqueos de plan, asignaciones y stock. El punto de autorización se produce con identidad/permiso vigente comprobados dentro de ese orden. El mecanismo exacto debe revisarse antes de implementar.

Para retirar o cambiar un administrador, comprobar autoridad central y existencia de otro administrador dentro de la misma transacción que modifica el permiso y registra auditoría. Una consulta de conteo previa en la aplicación no evita que dos retiros simultáneos eliminen a ambos. Las inactivaciones indirectas requieren política propia; no permitir que el diseño ignore ese riesgo.

Para una acción masiva, fijar los IDs antes de confirmar y revalidarlos durante ejecución. Se recomienda todo-o-nada para el piloto, con bloqueo por IDs en orden estable; la elección espera revisión humana. Una subcampaña creada después queda fuera. No usar comodín de campaña ni recalcular «todas» para ampliar el conjunto enviado.

La auditoría propuesta conserva actor, fecha, acción, persona afectada, subcampaña y responsabilidad anterior/nueva, vinculada al comando. Campos y necesidad de motivo se concretan en el contrato. Un retiro no borra membresías históricas necesarias para leer registros. No toca plantaciones, consumos físicos, metas ni saldos.

## 4. Contratos y migración a revisar

- Consulta autenticada de capacidades propias por subcampaña, separada de impacto común y caché pública; la sesión/perfil del cliente no es fuente de autoridad.
- Búsqueda de personas registradas con autorización, campos mínimos y paginación; no incluir creación de usuario, invitaciones o solicitudes. El alta/perfil de PA-S00 no permite elegir permisos globales o contextuales.
- Incorporar/retirar plantador y designar/cambiar/retirar administrador como acciones diferenciadas, con ámbito explícito y resultado recuperable. Definir repetición idéntica, versión/conflicto y recuperación tras respuesta perdida.
- Permiso contextual retirado frente a lectura propia y recuperación del intento de PA-S01: recuperar un resultado guardado no requiere reautorizar una escritura nueva.
- Transición de COORDINADOR/OPERARIO y roles globales: ensayar sobre copia controlada, conservar historia y facultades internas revisadas; no alterar la restricción legada ni trasladar usuarios masivamente sin decidir responsabilidades de activación/entregas/devoluciones.
- Primera designación por autoridad central y preparación de ámbitos legados antes de activar el nuevo modelo. Documentar compatibilidad de clientes/versiones y cierre de rutas antiguas que evitarían la política nueva.

## 5. Verificación y salida

Preparar PA-S03-CA01..14 con usuarios sintéticos: cuenta nueva, plantador de Norte, administrador de Norte/Sur, autoridad central, usuario ajeno y personal interno con facultades existentes. Incluir una persona global VOLUNTARIO autorizada contextualmente, una independiente y una de otra organización.

Las pruebas unitarias/HTTP validan políticas y contratos; las garantías de último administrador y retiro/registro requieren PostgreSQL aislado con ejecución concurrente real. Probar ambos órdenes de autorización y retiro, además de dos retiros concurrentes y selección masiva con autoridad obsoleta. La UI debe coincidir con el resultado persistido.

Salida: comportamiento y transición revisados por el usuario; contratos aprobados; implementación posterior verificada por capas; migración ensayada y regresión de usuarios internos, plan, activación, entregas/devoluciones y lectura propia. No declarar despliegue o permiso real aplicado a partir de este documento.
