# Revision de cierre — metas y especies de Plantacion

Fecha: 2026-10-10. Alcance: contraste documental de las dos tareas frontend/backend de ADR-PLA-05. El usuario confirma que las tareas están terminadas y solicita actualizar/comprometer la documentación. Esta revisión lee repositorios y registros de verificación; no ejecuta migraciones ni modifica código de aplicación.

## Resultado

El código local de ambos repositorios soporta el flujo acordado: ADMIN global revisa meta total y especies en BORRADOR/ACTIVA, las metas siguen siendo orientativas, las especies iniciales pertenecen al plan vigente y el cierre es manual. Se corrigen las menciones documentales que aún dejaban la implementación frontend pendiente.

Backend usa un snapshot GET y una revisión PUT con `meta_total_arboles`, `metas` y `revision_esperada`. La migración 062 valida estado/versión, coherencia y retiradas protegidas bajo bloqueo y guarda plan, auditoría y versión juntos; 063 limita RPC al backend. La revisión no modifica registros físicos ni saldos. GET/PUT validan JWT WebAuthn; GET admite cualquier usuario autenticado existente y PUT exige ADMIN global. PATCH general rechaza cambios de meta.

Frontend dispone de «Editar meta y especies» en el detalle para ADMIN/BORRADOR o ACTIVA. El editor y asistente comparten formulario de cantidades/porcentajes; se compara actual/propuesta y se confirma un solo PUT. Sin JWT no sale request y el cliente omite x-auth-id en esas dos rutas. No se habilita guardado si falta plan_revision. El asistente conserva borradores incompletos localmente y elimina el guardado separado por PATCH/PUT.

401 ofrece recuperar sesión; 403 bloquea edición sin cerrar sesión; 409 o respuesta incierta conserva la propuesta y exige consultar y revisar antes de otra escritura. El borrador temporal para recuperar sesión está vinculado a propietario/subcampaña y no guarda token ni versión para reenvío. Un fallo de actualización posterior a guardar no reenvía la revisión. Los indicadores usan el plan vigente; el porcentaje numérico puede exceder 100%.

## Evidencia consultada

- Backend `main`: ae19480, con JWT/063 en 37f9d44 y validación de pertenencia en la transacción de asignación en 90b9f53. Árbol local limpio; referencia local origin/main en el mismo commit.
- Frontend `main`: 2c8c29a, con editor, acceso y formulario compartido. Conserva ajustes adicionales sin commit de sesión/JWT, borradores y recuperación; se inspecciona ese árbol actual. No se comprometen esos archivos aquí.
- [Registro backend](../../Backend-r3foresta/documentacion/tareas/subcampanias-revision-plan-atomica.md): reporta 531 pruebas unitarias/HTTP, 46 PostgreSQL aisladas y build aprobados; acceso local 200 confirmado por el usuario tras renovar passkey, y 401 sin sesión/token válido.
- [Guía frontend, §16.6](../../pwa-r3foresta/FRONTEND_GUIDE.md) y [auditoría frontend](../../pwa-r3foresta/FRONTEND_AUDIT.md): reportan 284 pruebas en 19 suites, lint y build aprobados para los últimos ajustes. Las respuestas frontend son simuladas.

Esta revisión documental no vuelve a ejecutar esas pruebas. La coincidencia con referencias locales origin/main no es una consulta del remoto ni prueba de despliegue.

## Limites y verificacion restante

Las tareas de implementación quedan cerradas según código local y confirmación humana. La aplicación de migraciones hasta 062 y de 063 conserva la confirmación humana registrada previamente; aquí no se verifica directamente la base compartida.

QA integrado/despliegue siguen sin acreditarse: publicar los últimos ajustes frontend y comprobar versiones/configuración, permisos RPC y el flujo real con actores controlados en el entorno de prueba. [AUD-015](../../pwa-r3foresta/FRONTEND_AUDIT.md) mantiene esa verificación; AUD-016 conserva el encabezado exterior desactualizado después de un rechazo por cambio de estado, sin guardado autorizado. La gestión de acceso de participación aliada y los demás pendientes del módulo son capacidades separadas.

La validación de esta actualización comprende JSON de requisitos, códigos estables, enlaces documentales y diff sin errores de formato. El commit se limita a documentación de metas/especies; no incluye código frontend/backend, documentos de grado ni otros cambios previamente preparados.
