# Post-MVP — Modulo Plantacion

## PMVP-PLA-01 — Edicion flexible de campañas con subcampañas en BORRADOR

### Idea

Permitir que una campaña siga siendo editable cuando todas sus subcampañas asociadas estan en `BORRADOR`, porque todavia no hay asignaciones, plantaciones ni snapshots operativos congelados.

### Por que queda fuera del MVP

Para el MVP se permite editar datos generales, organizaciones y fechas. También existen la desactivación estricta y la desactivación atómica con cancelación masiva de subcampañas sin plantaciones. La variante flexible pendiente queda acotada al cambio de `tipo` con subcampañas en `BORRADOR`, porque exige propagacion de cambios y validaciones cruzadas.

### Reglas a evaluar despues

- Cambiar `CAMPANIA.tipo` solo si todas las subcampañas estan en `BORRADOR`, actualizando `SUBCAMPANIA.tipo` en la misma transaccion.
- Registrar evento de historial o auditoria cuando una campaña con subcampañas en borrador cambie de alcance.
- Mantener el cambio de `tipo` separado de la desactivación masiva ya implementada; desactivar una campaña no debe usarse como atajo para corregir su tipo.

### Condicion de salida

Reabrir esta mejora solo si la operacion real muestra que los admins crean subcampañas muy temprano y luego necesitan corregir con frecuencia el alcance de campaña.

## PMVP-PLA-02 — Dashboard avanzado de campaña

### Idea

Convertir el dashboard de campaña en una vista analitica mas completa, con formula de carbono validada, timeline canonico y conteo exhaustivo de eventos.

### Por que queda fuera del MVP

Para la primera version basta mostrar la idea de negocio operable: cards de subcampañas, metricas basicas, progreso y actividad reciente simple. Un dashboard tipo BI consume mas tiempo de modelado, pruebas y definiciones de producto.

### Reglas a evaluar despues

- Definir formula oficial de `co2_proyectado_ton` con producto/carbono.
- Unificar una fuente canonica de actividad para plantaciones, historial de subcampaña, asignaciones, devoluciones, mermas afectadas y cambios de equipo.
- Ampliar `eventos_count` para cubrir todos los eventos relevantes, no solo fuentes faciles del MVP.
- Agregar filtros, paginacion y agrupaciones de actividad si la pantalla empieza a usarse como auditoria real.

## PMVP-PLA-03 — Gestion avanzada de coordinador y equipo

### Idea

Agregar flujos completos para cambiar coordinador, auditar cambios de equipo y manejar reglas finas de membresia por estado.

### Por que queda fuera del MVP

El modelo base ya alcanza para operar: `SUBCAMPANIA_EQUIPO`, un `COORDINADOR` unico y N `OPERARIO`. Para MVP basta exigir coordinador al activar, mostrar equipo y validar membresia al registrar operaciones.

### Reglas a evaluar despues

- Flujo explicito de cambio de coordinador con historial.
- Auditoria de altas/bajas de operarios.
- Restricciones finas por estado de subcampaña para modificar equipo.
- Indicadores de desempeño por miembro del equipo.

## PMVP-PLA-04 — Evidencia completa para devolucion fisica al vivero

### Idea

Agregar fotos, GPS y auditoria visual a la devolucion fisica de plantas asignadas a subcampaña que vuelven al vivero.

### Por que queda fuera del MVP

Para la primera version la devolucion se registra con cantidad, motivo y usuario responsable. Esto mantiene control de stock sin agregar friccion operativa ni otro flujo fotografico.

### Reglas a evaluar despues

- Exigir minimo 1 foto de las plantas devueltas.
- Vincular evidencia a `DEVOLUCION_A_VIVERO` y/o al evento fisico de entrada en M2.
- Registrar GPS/lugar de entrega si la operacion no ocurre dentro del vivero.
- Definir si la devolucion debe pasar por validacion del responsable de vivero antes de aumentar saldo disponible.

## PMVP-PLA-05 — Excedente operativo por especie en plantacion inicial

### Idea

Permitir que una plantacion inicial exceda la meta por especie cuando exista una justificacion de campo.

### Por que queda fuera del MVP

El contrato actual de backend bloquea exceder `cantidad_objetivo` por especie. Para MVP, el frontend debe respetar ese bloqueo y evitar enviar registros que la RPC rechazaria.

### Reglas a evaluar despues

- Cambiar la validacion de meta por especie en backend.
- Requerir una justificacion cuando la cantidad plantada supere la meta de la especie.
- Mostrar advertencia en frontend en vez de bloqueo, si producto aprueba el excedente operativo.

## PMVP-PLA-06 — Ventana retroactiva configurable para plantacion

### Idea

Permitir configurar la ventana retroactiva de fechas por modulo o por operacion de Plantacion.

### Por que queda fuera del MVP

La ventana vigente de backend para fecha de plantacion es de 10 dias y es suficiente para la primera version.

### Reglas a evaluar despues

- Definir si la configuracion aplica por modulo, operacion o campania.
- Exponer la regla al frontend desde el contexto operativo.
- Auditar cambios de configuracion si afectan registros historicos o validaciones de campo.
