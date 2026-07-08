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

## ADR-PLA-02 — Registro de plantacion inicial en MVP

Fecha: 2026-07-08

### Contexto

El registro inicial de plantacion consume el contrato vigente de backend para `POST /registros-plantacion` y el contexto operativo de subcampaña. El objetivo del MVP es registrar sin duplicar reglas complejas en frontend.

### Decision

En el MVP:

- La plantacion inicial no puede exceder `cantidad_objetivo` por especie, porque la RPC actual lo bloquea.
- La fecha de plantacion conserva la ventana retroactiva vigente de backend: 10 dias.
- No se implementa configuracion especial en frontend para estas reglas.

### Consecuencias

- El frontend debe respetar el limite por especie mientras backend no cambie el contrato.
- Los excedentes operativos por especie quedan fuera del MVP.
- La ventana retroactiva configurable queda fuera del MVP.

### Referencias

- `POST /registros-plantacion`
- `Backend-r3foresta/documentacion/postman/plantacion-context.md` (contexto de plantacion inicial)
- `post-mvp/03-plantacion.md`
