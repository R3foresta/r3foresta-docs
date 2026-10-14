# Acuerdo de alta, roles internos y permisos por subcampaña

**Fecha:** 12 de octubre de 2026. **Estado:** comportamiento confirmado por el usuario; documentación primero. Implementación de backend/DB y adaptación frontend pendientes. Complementa PA-DI03/09, PA-S00 y PA-S03; no cambia el catálogo global ni declara aplicada una migración.

**Revisión técnica aceptada el 13 de octubre:** D01–D12 del [contrato backend](contrato-identidad-permisos-backend-propuesta.md) quedan aceptadas por Pablo, con ajustes D02/D07. El [acta del 13](archivo/revision-tecnica-2026-10-13.md) sustituye la orientación FIFO anterior para la nueva inicial por LIFO de servidor, exclusivamente sobre stock de esa subcampaña y sin recepción adicional. Se conservan aquí las observaciones/decisiones históricas de su fecha. Afiliación opcional mediante catálogo o «Otra», sin acceso automático. Esa versión concreta prevalece sobre los nombres/candidatos anteriores; la aceptación de diseño no marca implementación, migraciones o pruebas como completadas.

## 1. Alta y roles globales

Toda cuenta nueva creada por el alta de usuario empieza con `rol = VOLUNTARIO`, definido por el backend. Registrarse, completar/actualizar el perfil o declarar una afiliación no convierte a la persona en GENERAL, VALIDADOR o ADMIN ni le otorga acceso a una subcampaña.

Solo ADMIN global autorizado puede asignar o cambiar los roles internos de R3Foresta, por una operación administrativa separada del perfil propio. El catálogo sigue `ADMIN | GENERAL | VALIDADOR | VOLUNTARIO`; GENERAL describe un rol interno existente, no la condición de estar registrado. No aceptar que una persona se eleve mediante `rol` enviado al alta/perfil. Actualizar el perfil también debe conservar un rol interno legítimo previamente asignado, sin restablecerlo a VOLUNTARIO o GENERAL.

El cambio de valor inicial se aplica a nuevas cuentas. Las cuentas existentes no se convierten masivamente: revisar su autoridad y preservar las facultades internas legítimas mediante la transición prevista en PA-DI03/09.

## 2. Permisos contextuales separados

El permiso de participación se asigna por persona y subcampaña; no sustituye ni modifica el rol global.

| Autoridad / condición | Capacidad acordada |
|---|---|
| Cuenta nueva VOLUNTARIO, sin permiso contextual | Consulta pública y datos propios autorizados; no registra ni gestiona plantadores. |
| PLANTADOR vigente | Registra en su subcampaña bajo las reglas de PA-S01; conserva su rol global. |
| ADMINISTRADOR_SUBCAMPANIA vigente | Puede plantar y gestionar plantadores en su ámbito según PA-S03; no asigna roles globales ni nombra administradores contextuales. |
| ADMIN global | Autoridad central sobre todas las subcampañas actuales y las creadas después, sin asignación contextual adicional. Puede designar administradores y gestionar plantadores, además de sus facultades internas existentes. |
| GENERAL / VALIDADOR existentes | Conservan sus facultades internas legítimas según la matriz de transición. Esos roles no se conceden automáticamente al alta ni por administrar una subcampaña. |

Backend calcula capacidades y verifica sesión, rol/permiso, ámbito y condiciones en cada operación. DB garantiza integridad y orden transaccional con registro/retiro; frontend presenta las capacidades devueltas. Ocultar botones no implementa la autorización.

Acceso global no permite omitir estados, stock, evidencia, fechas, GPS o invariantes. ADMIN registra plantación inicial en ACTIVA con las mismas validaciones; no obtiene reapertura ni operaciones inexistentes por este acuerdo.

## 3. ADMIN global en listas de miembros

Mostrar a ADMIN global en la lista administrativa de miembros con identificación explícita **«Administrador · Acceso global»**. Su presencia y autoridad se calculan desde su rol global; no crear una fila de membresía/permiso contextual por cada subcampaña para habilitar ese acceso. La lista evita duplicar a una misma persona si tiene otra responsabilidad registrada y conserva la identificación de su autoridad global.

La representación no asigna automáticamente COORDINADOR ni responsabilidades físicas/logísticas. Tampoco registra participación histórica en una plantación: responsables/participantes siguen siendo las personas elegidas y guardadas en ese registro. Esta lista administrativa no amplía los campos del roster público de Impacto.

Un retiro contextual no puede quitar el acceso que proviene de ADMIN global. Cambiar el rol global por la operación administrativa autorizada sí debe recalcular sus capacidades y presencia derivada. Ver a un ADMIN global en la lista no lo convierte en una designación contextual para el control del último administrador: se conserva la garantía de PA-S03, con su mecanismo técnico pendiente.

## 4. Implementación pendiente y evidencia esperada

| Responsabilidad | Entrega pendiente |
|---|---|
| Backend / usuarios | Alta VOLUNTARIO; perfil que no cambia autoridad; operación de asignación de rol exclusiva de ADMIN global, con identidad verificada y auditoría. Fijar DTO/ruta, límites y compatibilidad. |
| Backend / acceso | Permisos contextuales y capacidades privadas, validación del ámbito, gestión de plantadores/administradores y acceso directo global de ADMIN. No mantener equipo legado como bypass permanente. |
| DB | Revisar default de `usuario.rol`, políticas de escritura, grants y todas las vías de alta/cambio de rol; nuevas migraciones cuando corresponda. Permisos, vigencias, auditoría y concurrencia según PA-S03. |
| Frontend | Alta/perfil sin elección de rol; lista de miembros con acceso global derivado; acciones basadas en capacidades verificadas. Conservar experiencia interna legítima. |

Casos de aceptación: alta sin rol → VOLUNTARIO; rol manipulado en alta/perfil no eleva autoridad; actualizar perfil de GENERAL/ADMIN conserva su rol; solo ADMIN global cambia rol interno; VOLUNTARIO habilitado puede plantar en Norte y no en Sur; administrador contextual no puede nombrarse ADMIN/GENERAL; ADMIN global sin equipo puede registrar en ACTIVA y aparece una vez en miembros; una subcampaña nueva reconoce el mismo acceso global; retirar permiso contextual no anula ese acceso global; la lista no añade participantes a hechos históricos ni modifica stock/logística.

Evidencia de confirmación: el usuario acepta acceso global y presencia derivada de ADMIN, aclara VOLUNTARIO para toda cuenta nueva y asignación administrativa de GENERAL/ADMIN, y confirma «Document the agreement first». Se documenta producto; código, contratos definitivos, SQL, pruebas y despliegue permanecen pendientes. El código observado sigue descrito en [revisión de contratos](archivo/revision-contratos-2026-10-12.md), sin modificar las aplicaciones.
