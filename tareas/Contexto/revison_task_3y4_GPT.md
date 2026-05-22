Sí, revisando **solo la Tarea 03 y la Tarea 04**, encontré varias inconsistencias. La más delicada es la **Tarea 04 de FIFO**, porque puede ser técnicamente posible, pero funcionalmente puede no representar la realidad de una merma.

---

# Conclusión rápida

La **Tarea 03** está bien encaminada, pero le faltan validaciones y algunos campos críticos para que sea realmente segura.

La **Tarea 04** es la que yo revisaría más fuerte. La política FIFO puede ser injusta o falsa operativamente, porque una merma no necesariamente debe afectar a la asignación más antigua. Eso solo tendría sentido si el vivero maneja las plantas físicamente en el mismo orden en que fueron asignadas, cosa que no está demostrada en la tarea.

---

# 1. Problemas encontrados en la Tarea 03 — Despacho automático desde M3

La tarea dice que cada `PLANTACION_INICIAL` o `REPOSICION` debe generar automáticamente uno o más eventos `DESPACHO` en `EVENTO_LOTE_VIVERO`, con `origen_despacho = AUTOMATICO_PLANTACION`. También dice que todo debe ocurrir en una sola transacción. Eso está bien como idea base. 

## Problema 1: falta mencionar explícitamente `lote_vivero_id` en el insert del despacho

La tarea dice que por cada lote afectado se inserta un `DESPACHO`, pero en la lista de campos del insert no aparece explícitamente:

```text
lote_vivero_id
```

Eso es crítico. Sin ese campo, el evento no sabe a qué lote de vivero pertenece.

Debe quedar claro:

```text
EVENTO_LOTE_VIVERO.lote_id = asignacion.lote_vivero_id
```

---

## Problema 2: se bloquean asignaciones, pero no se bloquea el lote de vivero

La tarea propone usar `SELECT ... FOR UPDATE` sobre `asignacion_vivero_subcampania`, lo cual evita doble consumo sobre la misma asignación. 

Pero no dice que se bloquee también:

```text
LOTE_VIVERO
```

Eso puede causar problemas si al mismo tiempo ocurre:

```text
M3 registra plantación
M2 registra merma
M2 registra despacho manual
```

Recomendación:

```sql
select *
from lote_vivero
where id = ?
for update;
```

Además de bloquear las asignaciones.

---

## Problema 3: no queda claro si el request debe mandar `asignacion_id`

La tarea dice que se valida por:

```text
(lote_vivero_id, especie, cantidad)
```

Pero si una subcampaña tiene varias asignaciones activas del mismo lote o de la misma especie, eso se vuelve ambiguo.

Mejor que el request de plantación mande:

```text
asignacion_id
lote_vivero_id
cantidad_plantada
```

Así no hay duda de qué asignación se está consumiendo.

---

## Problema 4: `comunidad_destino_id = subcampania.zona_id` puede estar mal

La tarea propone:

```text
comunidad_destino_id = subcampania.zona_id
```

Pero `comunidad_destino_id` suena a comunidad o división administrativa, mientras que `zona_id` podría representar otra cosa.

Hay que confirmar si:

```text
subcampania.zona_id
```

realmente apunta a una comunidad válida. Si no, debería ser algo como:

```text
subcampania.comunidad_id
```

o una FK clara hacia `DIVISION_ADMINISTRATIVA`.

---

## Problema 5: no se guarda si el despacho viene de plantación inicial o reposición

La tarea valida que una reposición solo consuma asignaciones con `proposito = REPOSICION`, y una plantación inicial solo asignaciones con `proposito = PLANTACION_INICIAL`. 

Pero al insertar el `DESPACHO` automático no se especifica dónde quedará guardado ese propósito.

Eso es necesario para el historial.

Debería guardarse en `metadata`, por ejemplo:

```json
{
  "proposito_asignacion": "PLANTACION_INICIAL"
}
```

o

```json
{
  "proposito_asignacion": "REPOSICION"
}
```

---

## Problema 6: evidencia heredada está bien, pero puede chocar con reglas actuales de Vivero

La tarea dice que el `DESPACHO` automático no tendrá fotos propias y que la evidencia vive en `REGISTRO_PLANTACION`. 

Eso está bien, pero hay que revisar si el backend actual de Vivero obliga evidencia para todo `DESPACHO`.

Si el backend actual dice:

```text
DESPACHO requiere evidencia propia
```

entonces el despacho automático va a fallar.

Debe quedar una regla explícita:

```text
DESPACHO automático por Plantación no exige evidencia propia en EVENTO_LOTE_VIVERO.
Su evidencia válida es la del REGISTRO_PLANTACION asociado.
```

---

# 2. Problemas encontrados en la Tarea 04 — Política FIFO de mermas

Aquí está el punto más fuerte. La tarea dice que cuando hay una merma, primero se afecta el saldo no asignado, y si no alcanza, se afectan asignaciones activas por FIFO, o sea, la asignación más antigua primero. 

## Mi observación principal

No estoy convencido de que **FIFO sea correcto** para una merma.

FIFO significa:

```text
La asignación más antigua absorbe primero la pérdida.
```

Pero una merma no ocurre necesariamente por orden de asignación. Una merma ocurre por causas físicas:

```text
se secaron plantas
hubo plaga
se dañaron plantas
murieron por manipulación
hubo daño en una bandeja o zona específica
```

Entonces, si una merma ocurre en un sector del vivero, no tiene por qué afectar automáticamente a la subcampaña más antigua.

---

# 3. Por qué FIFO puede estar mal

## Caso ejemplo

```text
Lote Vivero tiene 100 plantas.

Asignación A: 50 plantas para Subcampaña 1, creada el lunes.
Asignación B: 50 plantas para Subcampaña 2, creada el martes.

Ocurre merma de 20 plantas.
```

Con FIFO, el sistema afecta a la Asignación A.

Pero en la realidad puede que las 20 plantas muertas hayan estado físicamente separadas y correspondan a la Asignación B.

Entonces el sistema estaría inventando una pérdida sobre la subcampaña equivocada.

---

# 4. Problema técnico en el cálculo de `saldo_no_asignado`

La tarea calcula:

```text
saldo_no_asignado =
lote.saldo_vivo_actual - sum(asignacion.saldo_asignado_disponible)
```

Eso puede funcionar si todo está perfecto. Pero si por cualquier inconsistencia el resultado queda negativo, el algoritmo se rompe.

Ejemplo:

```text
saldo_vivo_actual = 80
saldo asignado disponible = 100
saldo_no_asignado = -20
```

Antes de aplicar merma, el backend debería validar:

```text
saldo_no_asignado >= 0
```

Si no, debe fallar con error de integridad, no continuar.

---

# 5. Problema de concurrencia en Tarea 04

La tarea dice que se bloquean las asignaciones activas con `FOR UPDATE`. 

Pero si el lote no tiene asignaciones activas, no se bloquea nada.

Entonces podrían entrar dos mermas paralelas sobre el mismo lote y ambas leer el mismo `saldo_vivo_actual`.

Recomendación obligatoria:

```text
Siempre bloquear LOTE_VIVERO con FOR UPDATE.
Luego bloquear asignaciones activas.
```

No solo las asignaciones.

---

# 6. Problema: `metadata` puede ser muy débil para auditoría

La tarea recomienda guardar las afectaciones en `metadata jsonb` con:

```json
[
  {
    "asignacion_id": 10,
    "cantidad": 5
  }
]
```

Eso sirve para MVP, pero es poco fuerte para auditoría.

Mínimo debería guardar también:

```json
{
  "asignacion_id": 10,
  "subcampania_id": 3,
  "cantidad_mermada": 5,
  "saldo_asignado_antes": 50,
  "saldo_asignado_despues": 45
}
```

Si no se guarda el antes/después, después será más difícil defender el historial.

---

# 7. Problema: no se menciona evidencia obligatoria para `MERMA`

La tarea 04 se enfoca en saldos y FIFO, pero no menciona evidencia.

Una merma en Vivero debería seguir exigiendo:

```text
causa
cantidad
responsable
fecha
evidencia
```

Si no se agrega esa validación, se podría registrar una pérdida que afecta asignaciones de campañas sin respaldo fotográfico.

---

# 8. Qué cambiaría yo en la Tarea 04

Yo no dejaría FIFO como regla automática principal.

## Opción recomendada

Usaría esta política:

```text
1. La merma afecta primero saldo libre/no asignado.
2. Si la merma supera el saldo libre, el sistema NO debería aplicar FIFO automáticamente.
3. Debe pedir una decisión explícita:
   - afectar una asignación específica,
   - distribuir proporcionalmente entre asignaciones,
   - o bloquear la operación hasta que el coordinador/admin resuelva.
```

---

# 9. Mejor alternativa al FIFO

## Alternativa A — Merma dirigida

El usuario indica qué asignación fue afectada.

Esto es mejor si las plantas están físicamente separadas por campaña/subcampaña.

```text
Merma de 20 plantas
Asignación afectada: Subcampaña B
```

Ventaja:

```text
Representa mejor la realidad física.
```

Desventaja:

```text
Requiere que el operario sepa qué asignación fue afectada.
```

---

## Alternativa B — Merma proporcional

Si no se sabe qué asignación fue afectada, se reparte proporcionalmente.

Ejemplo:

```text
Asignación A: 50 plantas
Asignación B: 50 plantas
Merma: 20 plantas
```

Resultado:

```text
A pierde 10
B pierde 10
```

Ventaja:

```text
Más justo que FIFO si no hay identificación física.
```

Desventaja:

```text
Más complejo de implementar.
```

---

## Alternativa C — Bloqueo si toca asignaciones

Esta es la más segura para MVP.

```text
Si la merma <= saldo libre:
    registrar merma normal.

Si la merma > saldo libre:
    bloquear y pedir resolución manual.
```

Mensaje:

```text
La merma supera el saldo libre y afectaría asignaciones activas.
Debe seleccionar asignaciones afectadas o liberar reservas antes de continuar.
```

Esta opción evita que el sistema invente automáticamente qué campaña perdió plantas.

---

# 10. Recomendación final

Para mí, la mejor corrección sería:

## Tarea 03

Mantenerla, pero corregir:

```text
- Agregar lote_vivero_id explícito en el DESPACHO.
- Bloquear LOTE_VIVERO además de asignaciones.
- Usar asignacion_id en el request.
- Guardar proposito_asignacion en metadata.
- Validar que el lote está ACTIVO y con saldo suficiente.
- Confirmar que evidencia heredada no choca con reglas actuales de DESPACHO.
```

## Tarea 04

No dejaría FIFO como automático por defecto.

Cambiaría la política a:

```text
La merma afecta primero saldo libre.
Si no alcanza, se requiere resolución explícita sobre asignaciones.
```

Y si el equipo insiste en automatizar, usaría:

```text
proporcional
```

antes que FIFO.

---

## Frase para decirle al equipo

> La Tarea 03 está bien como base, pero necesita bloquear también el lote, recibir asignacion_id y guardar el propósito de la asignación. La Tarea 04 es la más discutible: FIFO no representa necesariamente la realidad de una merma, porque las plantas no mueren por orden de asignación. Para MVP sería más seguro afectar primero saldo libre y, si la merma toca reservas, pedir resolución manual o aplicar una distribución proporcional, pero no FIFO automático.
