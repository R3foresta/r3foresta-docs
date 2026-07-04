# ADR-PLA — Decisiones cerradas — Modulo Plantacion (MVP)

## ADR-PLA-01 — Edicion basica y desactivacion de campaña en MVP

Fecha: 2026-07-03
Actualizacion: 2026-07-04

### Contexto

La campaña es un contenedor estrategico y su estado se deriva desde las subcampañas. Se evaluo una regla estricta que bloqueaba toda edicion y eliminacion al existir cualquier subcampaña, pero resulto demasiado dura para el flujo real: impide corregir datos generales y desactivar campañas que solo contienen subcampañas canceladas.

Para MVP se evita la cascada compleja, pero se permiten correcciones que no rompen snapshots ni trazabilidad operativa.

### Decision

En el MVP:

- `nombre`, `descripcion`, `fecha_estimada_inicio`, `fecha_estimada_fin` y organizaciones asociadas son editables como datos generales.
- `tipo` solo se edita mientras no exista ninguna `SUBCAMPANIA` asociada.
- La campaña puede desactivarse/inactivarse si no tiene subcampañas o si todas sus subcampañas estan `CANCELADA`.
- El borrado fisico (`DELETE`) solo se permite si no existe ninguna subcampaña asociada.

### Consecuencias

- Permite corregir datos visibles de campaña sin tocar registros operativos.
- Las organizaciones pueden cambiar: las subcampañas ya activadas conservan `nombres_organizaciones_snapshot`; las futuras activaciones usan la relacion actual.
- No se implementa propagacion de `tipo` a subcampañas ni cancelacion en cascada desde campaña.
- Si una campaña tiene subcampañas no canceladas, debe resolverse primero cada subcampaña antes de desactivar la campaña.

### Referencias

- `RN-PLA-38`
- `database/migrations/050_m3_campania_edicion_eliminacion_estricta_mvp.sql`
- `post-mvp/03-plantacion.md`
