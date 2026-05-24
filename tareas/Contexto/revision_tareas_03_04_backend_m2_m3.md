# Revision de tareas 03 y 04 - Backend despacho automatico y mermas FIFO

## Objetivo

Revisar si las tareas:

- `tareas/modulo-2-integracion-modulo-3/03_backend_despacho_automatico_atomico.md`
- `tareas/modulo-2-integracion-modulo-3/04_backend_politica_mermas_fifo.md`

estan suficientemente bien establecidas para implementacion, y marcar lo que debe corregirse o aclararse antes de pasar a codigo.

## Resultado corto

Las dos tareas estan bien encaminadas y respetan la idea principal del addendum M2 <-> M3:

- La plantacion en M3 debe generar `DESPACHO` automatico en M2.
- El despacho automatico debe ser atomico con el registro de plantacion.
- Las mermas deben afectar primero saldo libre y luego asignaciones activas por FIFO.
- `cantidad_asignada` no debe modificarse; se usan `cantidad_consumida`, `cantidad_devuelta` y `cantidad_mermada`.

Pero todavia hay partes no totalmente cerradas. Si se implementan tal como estan, pueden aparecer inconsistencias de saldos, problemas de concurrencia, fallas de esquema o dudas entre responsabilidades de M2 y M3.

---

# 1. Tarea 03 - Generacion atomica de DESPACHO desde M3

## Lo que esta bien

- La tarea exige una sola transaccion para crear `REGISTRO_PLANTACION`, actualizar asignaciones y crear eventos `DESPACHO`.
- Define correctamente que no puede existir plantacion sin sus despachos, ni despachos automaticos sin plantacion.
- Usa `origen_despacho = AUTOMATICO_PLANTACION`, alineado con el addendum.
- Mantiene la evidencia fotografica en `REGISTRO_PLANTACION`, no duplicada en `EVENTO_LOTE_VIVERO`.
- Exige bloqueo pesimista con `SELECT ... FOR UPDATE` sobre asignaciones.
- Separa correctamente despacho manual M2 de despacho automatico generado desde M3.
- Los criterios de aceptacion cubren casos importantes: varios lotes, saldo insuficiente, concurrencia, reposicion vs plantacion inicial.

## Lo que no esta bien establecido

### 1.1. Falta aclarar la frontera transaccional entre M2 y M3

La tarea dice que todo ocurre en una sola transaccion de base de datos. Eso solo es viable si M2 y M3 comparten la misma base de datos o si el backend que registra plantacion puede escribir directamente en tablas de M2.

Debe aclararse antes de implementar:

```text
M3 y M2 comparten base de datos?
El handler de M3 puede insertar directamente en EVENTO_LOTE_VIVERO?
O M3 llama a una API de M2?
```

Si M3 llama a una API de M2, la transaccion atomica real no esta garantizada sin patron adicional, por ejemplo outbox, saga o endpoint interno transaccional.

### 1.2. `cantidad_total_plantada` no coincide claramente con el addendum

La tarea usa:

```text
registro_plantacion.cantidad_total_plantada
```

El addendum habla de:

```text
REGISTRO_PLANTACION.cantidad_total
```

Debe unificarse el nombre real del campo para evitar que tests y backend implementen contratos distintos.

### 1.3. Validacion por especie esta ambigua

La tarea habla de validar cada:

```text
(lote_vivero_id, especie, cantidad)
```

Pero la tabla `ASIGNACION_VIVERO_SUBCAMPANIA` propuesta no guarda `especie` como campo propio. La especie probablemente se deriva desde `LOTE_VIVERO`.

Debe definirse una de estas reglas:

```text
Opcion A: la especie se valida derivandola desde lote_vivero.
Opcion B: la asignacion tambien guarda especie, si el modelo M3 la necesita de forma directa.
```

Para MVP conviene Opcion A, siempre que `LOTE_VIVERO` tenga especie confiable.

### 1.4. Debe agruparse por asignacion/lote antes de validar y actualizar

Si el request trae el mismo lote o asignacion repetido en varias lineas, validar linea por linea puede permitir sobreconsumo.

Antes de validar saldos se debe consolidar:

```text
group by asignacion_id / lote_vivero_id / proposito
sum(cantidad)
```

Luego validar:

```text
sum(cantidad_solicitada) <= saldo_asignado_disponible bloqueado
```

### 1.5. Falta definir como se vinculan fotos antes de tener `REGISTRO_PLANTACION.id`

La tarea exige al menos 1 foto valida antes del commit, pero tambien dice que las fotos se vinculan al `REGISTRO_PLANTACION`, cuyo id existe despues de insertar el registro.

Debe establecerse el mecanismo:

```text
1. El cliente sube evidencias temporales.
2. El request envia tokens/ids temporales.
3. Dentro de la transaccion se crea REGISTRO_PLANTACION.
4. Se vinculan las evidencias temporales a tipo_entidad = REGISTRO_PLANTACION y entidad_id = nuevo id.
5. Si no hay evidencia valida, rollback.
```

Sin esta regla, la validacion de evidencia queda incompleta.

### 1.6. `comunidad_destino_id = subcampania.zona_id` debe confirmarse

En M2, `comunidad_destino_id` referencia `DIVISION_ADMINISTRATIVA(id)`. La tarea asume que `subcampania.zona_id` tambien apunta a esa tabla.

Debe quedar escrito:

```text
SUBCAMPANIA.zona_id debe ser DIVISION_ADMINISTRATIVA(id)
```

Si `zona_id` representa otra entidad, el campo destino quedaria mal tipado.

### 1.7. Falta idempotencia ante reintentos

Si el cliente reintenta el guardado por timeout despues de que el commit si ocurrio, podria duplicarse la plantacion y duplicarse el despacho.

Recomendacion:

```text
Agregar client_request_id / idempotency_key al registro de plantacion,
con unique por usuario/subcampania.
```

No es obligatorio para MVP si el backend ya tiene estrategia de idempotencia, pero debe quedar decidido.

## Correcciones recomendadas para la tarea 03

- Agregar seccion "Frontera transaccional M2/M3".
- Unificar el nombre de `cantidad_total` vs `cantidad_total_plantada`.
- Aclarar que la especie se valida desde `LOTE_VIVERO` o agregar especie a la asignacion.
- Agregar consolidacion de lineas repetidas antes de validar saldos.
- Definir flujo de evidencia temporal y vinculacion dentro de la transaccion.
- Confirmar que `SUBCAMPANIA.zona_id` referencia `DIVISION_ADMINISTRATIVA(id)`.
- Considerar idempotencia del request.

---

# 2. Tarea 04 - Politica FIFO de mermas sobre asignaciones

## Lo que esta bien

- La politica principal esta alineada con el addendum:
  - primero saldo no asignado,
  - luego asignaciones activas,
  - orden FIFO,
  - no modificar `cantidad_asignada`,
  - aumentar `cantidad_mermada`.
- El pseudocodigo es claro para el caso normal.
- La tarea conserva el endpoint actual de `MERMA`, sin crear un flujo paralelo.
- Incluye validaciones basicas de cantidad y rollback.
- Considera notificacion al coordinador si hay asignaciones afectadas.

## Lo que no esta bien establecido

### 2.1. `metadata` no existe en `EVENTO_LOTE_VIVERO`

La tarea recomienda guardar:

```text
metadata.afectacion_asignaciones
```

Pero el esquema actual de `EVENTO_LOTE_VIVERO` solo documenta:

```text
metadata_blockchain
```

No hay un `metadata jsonb` general en el evento de vivero. Por tanto, la Opcion A no es realmente "sin migracion"; requiere agregar una columna nueva o cambiar la estrategia.

Se debe decidir:

```text
Opcion A corregida:
Agregar EVENTO_LOTE_VIVERO.metadata jsonb default '{}'
y guardar metadata.afectacion_asignaciones.

Opcion B:
Crear tabla merma_afectacion_asignacion(evento_id, asignacion_id, cantidad).
```

Para auditoria y consultas, la tabla relacional es mas fuerte. Para MVP, `metadata jsonb` sirve, pero debe existir una migracion explicita.

### 2.2. El bloqueo de concurrencia es insuficiente si solo bloquea asignaciones

El pseudocodigo bloquea asignaciones activas, pero tambien lee y modifica indirectamente:

```text
lote.saldo_vivo_actual
```

Ademas, si un lote no tiene asignaciones activas, `lock_filas_asignacion_activa(lote_id)` no bloquea ninguna fila. Dos mermas simultaneas podrian validar contra el mismo `saldo_vivo_actual`.

Debe bloquearse tambien el lote:

```sql
select id, saldo_vivo_actual
from lote_vivero
where id = $1
for update;
```

Luego bloquear asignaciones:

```sql
select *
from asignacion_vivero_subcampania
where lote_vivero_id = $1
  and estado = 'ACTIVA'
order by fecha_asignacion asc, id asc
for update;
```

### 2.3. El FIFO necesita desempate estable

La tarea dice ordenar por `fecha_asignacion asc`. Si dos asignaciones tienen la misma fecha, el orden puede variar.

Debe usarse:

```text
fecha_asignacion asc, id asc
```

### 2.4. La evidencia de MERMA no esta mencionada

En M2, `MERMA` requiere evidencia minima de 1 foto valida. La tarea 04 cambia el handler de `MERMA`, pero no recuerda esta validacion.

Debe agregarse:

```text
La MERMA sigue requiriendo evidencia fotografica propia en EVIDENCIAS_TRAZABILIDAD asociada al EVENTO_LOTE_VIVERO.
```

Esto es distinto al despacho automatico, que hereda evidencia desde M3.

### 2.5. Notificaciones deben dispararse despues del commit, no dentro de la transaccion

La tarea dice "al final del commit exitoso", lo cual esta bien, pero debe quedar mas concreto para evitar notificaciones de una merma que luego haga rollback.

Recomendacion:

```text
Guardar outbox/notificacion_pendiente dentro de la transaccion,
procesar/envia despues del commit.
```

Si no existe sistema de notificaciones, la tarea 08 ya propone una vista de alertas.

### 2.6. La tarea 04 depende funcionalmente de saldos derivados

Aunque la tarea 04 depende formalmente de 01 y 02, su formula usa el mismo concepto que la tarea 05:

```text
saldo_no_asignado = saldo_vivo_actual - sum(saldo_asignado_disponible activo)
```

Debe aclararse si la tarea 04:

```text
usa la vista v_lote_vivero_saldos de tarea 05
o calcula la formula inline dentro del handler.
```

Si usa la vista, entonces la dependencia real incluye tarea 05.

## Correcciones recomendadas para la tarea 04

- Agregar migracion para `EVENTO_LOTE_VIVERO.metadata jsonb`, o cambiar a tabla relacional de afectaciones.
- Bloquear tambien `LOTE_VIVERO` con `FOR UPDATE`.
- Ordenar FIFO por `fecha_asignacion asc, id asc`.
- Mantener validacion de evidencia obligatoria de `MERMA`.
- Definir outbox o post-commit para notificaciones.
- Aclarar dependencia con tarea 05 o duplicar la formula en el handler.

---

# 3. Inconsistencias entre archivos

## 3.1. README dice que tarea 04 bloquea a 07, pero la tarea 04 dice que bloquea a 08

En el README de `modulo-2-integracion-modulo-3`, la fila de la tarea 04 aparece como bloqueando a 07.

Pero la tarea 04 realmente alimenta la tarea 08:

```text
04 mermas FIFO -> 08 notificaciones por merma
```

La tarea 07 es historial diferenciado y depende principalmente de 01 y 03.

Correccion recomendada:

```text
Actualizar README:
Tarea 04 bloquea a 08, no a 07.
```

## 3.2. Tarea 04 usa `metadata`, pero tarea 01 no crea esa columna

Si se conserva la Opcion A de la tarea 04, la tarea 01 o una nueva migracion debe agregar:

```sql
alter table evento_lote_vivero
  add column if not exists metadata jsonb not null default '{}'::jsonb;
```

Si no se quiere tocar `EVENTO_LOTE_VIVERO` con metadata general, entonces usar tabla relacional.

---

# 4. Tarea recomendada para cerrar antes de implementar

## Nombre sugerido

```text
10_saneamiento_contratos_backend_03_04.md
```

## Alcance

Antes de implementar las tareas 03 y 04, cerrar:

- frontera transaccional M2/M3,
- nombre canonico de cantidad total en `REGISTRO_PLANTACION`,
- estrategia de evidencia temporal para plantacion,
- origen de especie en validaciones,
- esquema de auditoria para afectaciones de merma,
- locks necesarios sobre lote y asignaciones,
- dependencia real con saldos derivados,
- correccion del README.

## Criterios de aceptacion

- [ ] Tarea 03 define si M3 escribe directo en BD compartida o si hay API interna de M2.
- [ ] Tarea 03 unifica `cantidad_total` / `cantidad_total_plantada`.
- [ ] Tarea 03 documenta agrupacion previa de lotes/asignaciones repetidas.
- [ ] Tarea 03 documenta el flujo de evidencia temporal.
- [ ] Tarea 04 define si usa `metadata jsonb` o tabla `merma_afectacion_asignacion`.
- [ ] Si usa `metadata jsonb`, existe migracion explicita.
- [ ] Tarea 04 bloquea `LOTE_VIVERO` y asignaciones activas con `FOR UPDATE`.
- [ ] Tarea 04 usa FIFO estable: `fecha_asignacion asc, id asc`.
- [ ] Tarea 04 mantiene evidencia obligatoria de `MERMA`.
- [ ] README queda consistente: tarea 04 bloquea a 08.

## Prioridad

Alta. No es una tarea grande de desarrollo, pero evita implementar reglas ambiguas en dos flujos criticos: plantacion automatica y mermas.
