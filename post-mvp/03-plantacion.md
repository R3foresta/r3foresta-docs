# Post-MVP — Modulo Plantacion

## PMVP-PLA-01 — Edicion flexible de campañas con subcampañas en BORRADOR

### Idea

Permitir que una campaña siga siendo editable cuando todas sus subcampañas asociadas estan en `BORRADOR`, porque todavia no hay asignaciones, plantaciones ni snapshots operativos congelados.

### Por que queda fuera del MVP

Para el MVP se permite editar datos generales, organizaciones y fechas; tambien desactivar campañas sin subcampañas o con todas sus subcampañas `CANCELADA`. La variante flexible queda acotada al cambio de `tipo` con subcampañas en `BORRADOR`, porque exige propagacion de cambios y validaciones cruzadas que no son necesarias para salir con una version consistente.

### Reglas a evaluar despues

- Cambiar `CAMPANIA.tipo` solo si todas las subcampañas estan en `BORRADOR`, actualizando `SUBCAMPANIA.tipo` en la misma transaccion.
- Registrar evento de historial o auditoria cuando una campaña con subcampañas en borrador cambie de alcance.
- Evaluar una accion separada de archivar/cancelar campaña con subcampañas en `BORRADOR`, sin borrado fisico y con reglas explicitas para sus subcampañas.

### Condicion de salida

Reabrir esta mejora solo si la operacion real muestra que los admins crean subcampañas muy temprano y luego necesitan corregir con frecuencia el alcance de campaña.
