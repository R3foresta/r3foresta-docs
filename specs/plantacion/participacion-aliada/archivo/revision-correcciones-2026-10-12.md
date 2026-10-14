# PA-S04 — Acuerdo humano de correcciones, 12 de octubre de 2026

> **Acta/contraste archivado.** Conserva decisiones y observaciones de su fecha. El avance posterior se consulta en el [tablero de ejecución](../implementacion/README.md).

**Fuente:** usuario responsable del producto, en este chat y su revisión por voz. **Estado:** decisiones parciales confirmadas; no aprobación integral de PA-S04, implementación ni habilitación de campo.

## Confirmado

1. Corregir participantes u observaciones con motivo, valores anteriores/nuevos e historial, sin cambiar cantidades/stock. Inicialmente se acordó ADMIN global; la confirmación posterior amplía participantes a ADMIN global y administrador de esa subcampaña, únicamente en ACTIVA. Se permite añadir, retirar o restituir personas registradas que participaron realmente, aunque ya no estén habilitadas hoy, con hecho comprobado; no se restaura permiso operativo ni cambia responsable original. Debe guardarse y mostrarse que hubo cambio y quién lo hizo, con listas anterior/nueva, fecha y motivo según audiencia. Observaciones mantiene ejecutor central; no hay edición general.
2. ADMIN global y administrador de la subcampaña pueden aumentar o reducir cantidades de registros de plantación. El administrador contextual solo dentro de las subcampañas donde mantiene esa autoridad; no por ser autor, plantador o miembro de una organización.
3. El registro no tiene bajas **ni** reposiciones; no cambiar especies. Motivo e historial obligatorios. Sin anular y crear otro registro como operaciones separadas.
4. Aumentar consume solo la diferencia de stock elegible disponible de la subcampaña. No superar saldo disponible; no usar meta ni cantidad originalmente entregada como saldo.
5. Reducir exige confirmar error de registro y que las plantas de la diferencia siguen físicamente disponibles en la subcampaña. Solo entonces liberar el consumo correspondiente. Plantas realmente plantadas que murieron requieren baja, no reducción de la plantación inicial.
6. La asignación representa entrega física ya realizada. Corregir consumo no cambia entrega, no devuelve plantas al vivero y no crea nuevo despacho. Original, corrección, consumo e historial se conservan con efecto atómico, recuperable y no duplicado.

La decisión 2 sustituye la exclusividad central anterior **para cantidades y, por confirmación posterior, participantes**. La ejecución contextual autorizada no necesita otra aprobación central por defecto. Toda autoridad y precondición se verifican en servidor al aplicar la operación.

## Qué falta analizar

- **Estados, confirmado en continuación:** limitar correcciones de cantidad a subcampaña ACTIVA, sin reapertura, también para ADMIN global. Verificar además asignaciones elegibles y concurrencia con cierre/devolución.
- **Cero y duplicados, exclusión confirmada en continuación:** fuera del ajuste simple. No habilita eliminación de especie ni anulación total. Esta exclusión de duplicados fue sustituida por la continuación documentada abajo: quedan fuera del ajuste simple pero tienen reversión específica. Cero no es mecanismo de anulación.
- **Participantes, confirmado:** ambos administradores en ACTIVA, historia comprobada y sin exigir permiso operativo actual de la persona añadida. Falta concretar búsqueda mínima histórica y visibilidad del historial; no exponer directorio completo, contactos o motivo libre por inferencia.
- **Técnica:** revertir consumo hacia asignaciones trazables, distribución de aumentos, versiones, reintentos y concurrencia con registro de bajas/reposiciones, consumo de stock, revocación, cierre y devolución. Saldo y cantidades deben ser coherentes tras correcciones sucesivas.
- **Consulta:** cantidad efectiva sin doble conteo e historial por audiencia; no publicar motivo libre, contactos, datos internos o saldo mediante el historial público por conveniencia técnica.

## Artefactos y límites de esta actualización

[Spec](../04-correccion-excepcional/spec.md), [plan](../04-correccion-excepcional/plan.md), [tareas](../04-correccion-excepcional/tasks.md) y matriz de [accesos](../03-gestion-acceso-subcampania/spec.md).

Al registrar inicialmente este acuerdo, Git mantenía conflictos en las referencias centrales. En la continuación del 12 de octubre se revisaron y marcaron resueltos los 14 archivos no fusionados, conservando los cambios existentes; ADR-PLA-03 y CLAUDE.md ya recogen esta decisión. Las formulaciones históricas de exclusividad central se leen con el alcance actualizado aquí. No se ejecutaron cambios en aplicaciones, SQL, correcciones reales, commits ni push.

## Continuación: duplicados y eliminación de errores

**Fuente:** usuario en esta revisión escrita del 12 de octubre. Autoriza revertir duplicados devolviendo stock para que quede un solo registro válido. Para trabajo que no ocurrió, no solicita ampliar verificación del trabajo real: permite eliminar el registro. Extiende eliminación a bajas/reposiciones erróneas.

**Aclaraciones explícitas:** «admin de la campaña» significa administrador de la subcampaña donde está el registro, además de ADMIN global. «Bajas y reposiciones igual» significa eliminar registros de esos eventos hechos por error; no autoriza revertir automáticamente una plantación con bajas/reposiciones reales vinculadas.

**Representación documental conforme a invariantes vigentes:** eliminación lógica con original, motivo, actor/fecha e historial; sin DELETE físico. Duplicados liberan consumo efectivo a sus asignaciones de subcampaña y conservan referencia al registro válido. Baja errónea revierte mortalidad, no stock disponible; reposición errónea revierte aporte y consumo hacia REPOSICION. Sin cambio de entrega ni devolución al vivero. Conservar ACTIVA como límite del alcance actual; compensaciones/versiones/concurrencia y dependencias requieren revisión técnica.

Esta continuación sustituye la exclusión previa de duplicados como caso sin tratamiento. No elimina condiciones del ajuste simple de cantidad ni aprueba borrado en cascada de hechos reales. [PA-S04](../04-correccion-excepcional/spec.md) y [propuesta implementable](instrucciones-implementacion.md) contienen casos y pruebas; revisión integral/implementación pendientes.
