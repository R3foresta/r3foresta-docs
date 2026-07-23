# ADR-PLA — Decisiones cerradas — Modulo Plantacion (MVP)

## ADR-PLA-01 — Edicion basica y desactivacion de campaña en MVP

Fecha: 2026-07-03
Actualizacion: 2026-07-23

### Contexto

La campaña es un contenedor estrategico y su estado se deriva desde las subcampañas. Se evaluo una regla estricta que bloqueaba toda edicion y eliminacion al existir cualquier subcampaña, pero resulto demasiado dura para el flujo real: impide corregir datos generales y desactivar campañas que solo contienen subcampañas canceladas.

Para MVP se permiten correcciones que no rompen snapshots ni trazabilidad operativa. La operación real también requiere retirar de forma segura una campaña cuyas subcampañas todavía no plantaron, sin obligar al administrador a cancelar cada hija manualmente ni dividir una operación que debe ser atómica.

### Decision

En el MVP:

- `nombre`, `descripcion`, `fecha_estimada_inicio`, `fecha_estimada_fin` y organizaciones asociadas son editables como datos generales.
- `tipo` solo se edita mientras no exista ninguna `SUBCAMPANIA` asociada.
- La desactivación estricta puede aplicarse si no hay subcampañas vivas no canceladas; no produce efectos implícitos sobre hijas.
- Existe una acción explícita de desactivación con cancelación masiva, solo para `ADMIN`, con preview y motivo obligatorio.
- La acción masiva admite hijas `BORRADOR`/`ACTIVA` únicamente con `total_plantado_inicial = 0`, considera `CANCELADA` como postcondición satisfecha, devuelve físicamente el stock disponible y aplica soft-delete a la campaña en una sola transacción.
- Una hija con plantaciones o en `COMPLETADA`, `FINALIZADA_PARCIAL` o `PAUSADA` bloquea toda la operación masiva.
- El borrado fisico (`DELETE`) solo se permite si no existe ninguna subcampaña asociada.

### Consecuencias

- Permite corregir datos visibles de campaña sin tocar registros operativos.
- Las organizaciones pueden cambiar: las subcampañas ya activadas conservan `nombres_organizaciones_snapshot`; las futuras activaciones usan la relacion actual.
- No se implementa propagacion de `tipo` a subcampañas.
- La cancelación desde campaña reutiliza la semántica canónica de `RN-PLA-37`, registra `origen = DESACTIVACION_CAMPANIA`, devuelve stock y hace rollback completo ante cualquier fallo.
- Preview y ejecución son contratos separados: el preview no reserva ni autoriza; la ejecución vuelve a validar dentro de la transacción.

### Referencias

- `RN-PLA-38`
- `database/migrations/050_m3_campania_edicion_eliminacion_estricta_mvp.sql`
- `database/migrations/056_fix_devolucion_saldo_constraint.sql`
- `database/migrations/057_m3_campania_desactivacion_masiva.sql`
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
