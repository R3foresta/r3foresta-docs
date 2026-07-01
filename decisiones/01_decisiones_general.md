# ADR-GEN — Decisiones cerradas — Módulo General (MVP)

> Parte del registro de decisiones del proyecto: ver [índice](README.md). Migrado desde el antiguo documento de decisiones cerradas que vivía en `general-module/`.

## ADR-GEN-01 — Comunidad: decision cerrada para MVP

### Situacion actual

El esquema ya tiene:

* `PAIS`
* `DIVISION_TIPO`
* `DIVISION_ADMINISTRATIVA`
* `UBICACION`

Se usara `DIVISION_ADMINISTRATIVA` con `DIVISION_TIPO = Comunidad - Localidad` (`id = 4`) como fuente oficial de comunidad para este proceso.

### Decision tomada

No se crea una tabla separada `COMUNIDAD` en el MVP.

---

## ADR-GEN-02 — Naming oficial de planta: decision cerrada para MVP

### Situacion actual

La documentacion operativa ya usa:

* `nombre_comercial_snapshot`

Pero el esquema actual de `PLANTA` habla de:

* `nombre_comun_principal` se mantiene como fuente viva oficial porque ya es el campo que esta programado.
* `nombres_comunes` no se toma en cuenta en el MVP.

### Decision tomada

En catalogo maestro se usa `PLANTA.nombre_comun_principal`.

En snapshots operativos se mantiene el nombre de campo `nombre_comercial_snapshot`, pero su fuente viva para el MVP es `PLANTA.nombre_comun_principal`.

---

## ADR-GEN-03 — Tipo de material permitido por planta

### Situacion actual

Los modulos operativos trabajan con `SEMILLA` y `ESQUEJE`, pero no esta completamente claro si ese comportamiento vive solo en reglas de proceso o tambien en el maestro de planta.

### Decision tomada

Se agrega una regla maestra por planta para indicar material permitido:

* `SEMILLA`
* `ESQUEJE`

No se usa `AMBOS` en el MVP. Cada planta queda configurada como esqueje o semilla.

---

## ADR-GEN-04 — Roles oficiales del sistema

### Situacion actual

Existe `USUARIO.rol`, pero no esta cerrado el catalogo oficial de roles.

### Decision tomada

Los roles oficiales del MVP quedan en:

* `ADMIN`
* `GENERAL`
* `VALIDADOR`
* `VOLUNTARIO`

---

## ADR-GEN-05 — Alta de nuevas comunidades y zonas

### Situacion actual

En la documentacion de Recoleccion ya aparece la idea de proponer nuevas comunidades o zonas por usuarios con aprobacion administrativa.

### Decision tomada

Solamente `ADMIN` puede crear nuevas comunidades o zonas. Los usuarios operativos no pueden hacerlo desde sus flujos funcionales.

---

## ADR-GEN-06 — Ubicacion reutilizable vs ubicacion embebida

### Situacion actual

`UBICACION` ya existe como entidad reutilizable, pero no esta totalmente decidido si todos los puntos deben normalizarse o si algunos eventos futuros podrian guardar coordenadas directas.

### Decision tomada

Siempre se va a usar la tabla `UBICACION` para guardar coordenadas y comunidad. No se van a guardar coordenadas directas en eventos operativos.

---

## ADR-GEN-07 — Evidencia: politica de eliminacion y reemplazo

### Situacion actual

Existe `eliminado_en` en `EVIDENCIAS_TRAZABILIDAD`, pero no esta formalizada la politica funcional.

### Decision tomada

`eliminado_en` queda solo para futuro. No se usa en el MVP como parte del flujo funcional.

---

## Estado actual

Con estas definiciones, los puntos base del modulo general quedan cerrados para el MVP.

Todavia pueden existir decisiones futuras de ampliacion, pero ya no quedan abiertos como bloqueo para documentacion o desarrollo base:

* comunidad se resuelve con `DIVISION_ADMINISTRATIVA` (ADR-GEN-01),
* el naming maestro vivo de planta es `nombre_comun_principal` (ADR-GEN-02),
* los snapshots conservan `nombre_comercial_snapshot` (ADR-GEN-02),
* los roles oficiales estan cerrados (ADR-GEN-04),
* y las coordenadas viven siempre en `UBICACION` (ADR-GEN-06).
