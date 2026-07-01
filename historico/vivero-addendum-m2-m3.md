# Addendum al Módulo 2 (Vivero) — Integración con Módulo 3 (Plantación)

> **Estado:** ABSORBIDO en la documentación oficial del Módulo 2 el 2026-05-21.
>
> - JSON de requerimientos actualizado: RF-VIV-03, RF-VIV-05, RF-VIV-06, RF-VIV-09 extendidos; agregados RF-VIV-11 (asignación), RF-VIV-12 (devolución), RF-VIV-13 (saldos derivados), RF-VIV-14 (política de urgencia de mermas).
> - Reglas de negocio agregadas: RN-VIV-47 a RN-VIV-59 (sección 13 del MD de reglas).
> - Guía operativa: sección 13 nueva con resumen del contrato M2 ↔ M3.
> - Documento operativo dedicado: [04_consumo_de_vivero.md](../vivero-module/04_consumo_de_vivero.md).
> - Esquema ER: `EVENTO_LOTE_VIVERO` extendido y nueva entidad `ASIGNACION_VIVERO_SUBCAMPANIA` agregadas en [database/00_database_schema.md](../database/00_database_schema.md).
>
> Este archivo se conserva como **referencia histórica del contrato negociado**. **No es la fuente operativa**: para uso diario, ir a los documentos oficiales del módulo.

---

> Este documento consolida las correcciones, agregados y aclaraciones que el Módulo 2 (Vivero) necesita incorporar para integrarse correctamente con el Módulo 3 (Plantación).
>
> Los cambios complementan los requerimientos originales del Módulo 2 y permiten soportar subcampañas, asignaciones, reservas lógicas, despachos automáticos, devoluciones y trazabilidad completa hacia Plantación.

---

## 1. Resumen de cambios

| # | Cambio | Severidad | Requerimiento original afectado |
|---|--------|-----------|---------------------------------|
| 1 | Agregar `PLANTACION_CAMPANIA` al enum `destino_tipo_vivero` | Crítico | RF-VIV-05 |
| 2 | Agregar campo `origen_despacho` al evento `DESPACHO` | Crítico | RF-VIV-05 |
| 3 | Agregar referencias tipadas `subcampania_id`, `campania_id` y `registro_plantacion_id` al `DESPACHO` automático | Crítico | RF-VIV-05 |
| 4 | Definir saldo derivado `saldo_vivo_disponible_asignacion` | Importante | Conceptos clave + RF-VIV-09 |
| 5 | Definir política de mermas sobre saldo asignado usando `cantidad_mermada`, sin sobrescribir `cantidad_asignada` | Importante | RF-VIV-03 |
| 6 | Definir evidencia heredada en `DESPACHO` automático como excepción controlada a la evidencia propia de M2 | Importante | RF-VIV-05 + RF-VIV-06 |
| 7 | Aclarar que las devoluciones del Módulo 3 no generan evento en Módulo 2 | Aclaración | RF-VIV-05 |
| 8 | Ampliar la vista operativa de lotes con columnas derivadas de asignación | Mejora | RF-VIV-09 |
| 9 | Agregar restricciones de consistencia según el origen del despacho | Crítico | RF-VIV-05 |

---

## 2. Principio general de integración M2 ↔ M3

La integración entre Vivero y Plantación se basa en una separación clara:

- **Asignar** árboles desde Vivero a una subcampaña es una **reserva lógica**.
- **Devolver** árboles asignados es una **liberación de reserva lógica**.
- **Plantar** árboles en campo es una **salida real** del vivero.
- **Reposicionar** árboles en campo también es una **salida real** del vivero.
- **Reportar mortandad en Plantación** no modifica el vivero, porque ocurre después del despacho.

Por tanto:

| Operación del Módulo 3 | ¿Genera evento en Módulo 2? | Efecto sobre `LOTE_VIVERO.saldo_vivo_actual` |
|------------------------|------------------------------|----------------------------------------------|
| `ASIGNACION_VIVERO` | No | No cambia |
| `DEVOLUCION_A_VIVERO` | No | No cambia |
| `PLANTACION_INICIAL` | Sí, genera `DESPACHO` automático | Disminuye |
| `REPOSICION` | Sí, genera `DESPACHO` automático | Disminuye |
| `MORTANDAD_REPORTADA` | No | No cambia |

---

## 3. Nuevo valor `PLANTACION_CAMPANIA` en `destino_tipo_vivero`

### 3.1. Decisión de naming

Se usa `PLANTACION_CAMPANIA` sin `Ñ` para mantener compatibilidad técnica con SQL, APIs, serialización JSON, frontend y migraciones.

No se debe usar `PLANTACION_CAMPAÑA` como valor de enum.

### 3.2. Cambio requerido

Agregar el valor `PLANTACION_CAMPANIA` al enum `destino_tipo_vivero`.

Valores consolidados recomendados (propuesta original de este addendum):

```txt
PLANTACION_CAMPANIA
PLANTACION_PROPIA
DONACION_COMUNIDAD
VENTA
OTRO
```

> **Nota (2026-07-01):** la fusión a `DONACION_COMUNIDAD` propuesta arriba **no se adoptó**. Decisión cerrada: se mantienen `PLANTACION_COMUNIDAD` y `DONACION` como valores separados. Enum canónico vigente (6 valores) en `database/00_database_schema.md`.

### 3.3. Comportamiento

Cuando `destino_tipo = PLANTACION_CAMPANIA`:

- El evento debe ser generado automáticamente desde el Módulo 3.
- `origen_despacho` debe ser `AUTOMATICO_PLANTACION`.
- `registro_plantacion_id` debe apuntar al `REGISTRO_PLANTACION.id` del Módulo 3.
- `subcampania_id` debe apuntar a la subcampaña donde se realizó la plantación o reposición.
- `campania_id` debe apuntar a la campaña padre.
- `comunidad_destino_id` se hereda automáticamente desde la subcampaña.
- El operario de vivero no registra este despacho manualmente.

Los demás valores de `destino_tipo_vivero` se reservan para despachos manuales fuera del flujo de campañas.

---

## 4. Nuevo campo `origen_despacho` en `EVENTO_LOTE_VIVERO`

### 4.1. Cambio requerido

Agregar al evento `DESPACHO` un campo `origen_despacho`.

Enum recomendado:

```txt
MANUAL
AUTOMATICO_PLANTACION
```

Default recomendado:

```txt
MANUAL
```

### 4.2. Significado de valores

| Valor | Descripción |
|-------|-------------|
| `MANUAL` | Despacho registrado directamente desde el Módulo 2 por un usuario autorizado del vivero. |
| `AUTOMATICO_PLANTACION` | Despacho generado por el sistema desde el Módulo 3 al registrar una plantación inicial o reposición. |

### 4.3. Reglas por origen

| Aspecto | `MANUAL` | `AUTOMATICO_PLANTACION` |
|---------|----------|--------------------------|
| Quién lo registra | Operario o usuario autorizado de Vivero | Sistema, desde Módulo 3 |
| Acción que lo origina | Despacho manual | `PLANTACION_INICIAL` o `REPOSICION` |
| Evidencia | Evidencia propia obligatoria en M2 | Evidencia heredada desde M3 |
| `destino_tipo` permitido | Todos excepto `PLANTACION_CAMPANIA` | Solo `PLANTACION_CAMPANIA` |
| `subcampania_id` | Debe ser `NULL` | Obligatorio |
| `campania_id` | Debe ser `NULL` | Obligatorio |
| `registro_plantacion_id` | Debe ser `NULL` | Obligatorio |

---

## 5. Referencias adicionales en `DESPACHO` automático

### 5.1. Campos nuevos en `EVENTO_LOTE_VIVERO`

Cuando `origen_despacho = AUTOMATICO_PLANTACION`, el evento debe almacenar referencias tipadas hacia Módulo 3:

```txt
subcampania_id
campania_id
registro_plantacion_id
```

También puede mantenerse `destino_referencia` como texto de compatibilidad o lectura humana, pero no debe ser la única referencia fuerte.

### 5.2. Regla de referencia

Cuando el despacho viene desde Plantación:

```txt
EVENTO_LOTE_VIVERO.registro_plantacion_id = REGISTRO_PLANTACION.id
EVENTO_LOTE_VIVERO.subcampania_id = REGISTRO_PLANTACION.subcampania_id
EVENTO_LOTE_VIVERO.campania_id = SUBCAMPANIA.campania_id
EVENTO_LOTE_VIVERO.comunidad_destino_id = SUBCAMPANIA.zona_id
EVENTO_LOTE_VIVERO.destino_tipo = PLANTACION_CAMPANIA
EVENTO_LOTE_VIVERO.origen_despacho = AUTOMATICO_PLANTACION
```

Esto permite drill-down bidireccional:

```txt
Lote de vivero -> Despacho -> Registro de plantación -> Subcampaña -> Campaña
Campaña/Subcampaña -> Registro de plantación -> Despacho -> Lote de vivero -> Recolección origen
```

---

## 6. Saldo derivado `saldo_vivo_disponible_asignacion`

### 6.1. Concepto

`saldo_vivo_disponible_asignacion` representa la cantidad de plantas vivas de un lote que todavía pueden asignarse a nuevas subcampañas.

No representa necesariamente todo lo que existe físicamente en el vivero. Para eso ya existe `saldo_vivo_actual`.

### 6.2. Naturaleza del dato

Este saldo debe ser derivado, no persistido como fuente de verdad.

Puede exponerse como:

- vista SQL,
- consulta calculada,
- endpoint de lectura,
- columna materializada controlada si se justifica por rendimiento.

Pero la fuente real debe seguir siendo:

- `LOTE_VIVERO.saldo_vivo_actual`,
- asignaciones activas del Módulo 3,
- consumos,
- devoluciones,
- mermas que afectaron asignaciones.

### 6.3. Fórmula recomendada

A nivel de lote:

```txt
saldo_vivo_disponible_asignacion =
  LOTE_VIVERO.saldo_vivo_actual
  - SUM(saldo_asignado_disponible de asignaciones activas del lote)
```

A nivel de asignación:

```txt
saldo_asignado_disponible =
  cantidad_asignada
  - cantidad_consumida
  - cantidad_devuelta
  - cantidad_mermada
```

Donde:

- `cantidad_asignada`: cantidad originalmente reservada para una subcampaña.
- `cantidad_consumida`: cantidad usada en plantaciones o reposiciones.
- `cantidad_devuelta`: cantidad liberada por devolución.
- `cantidad_mermada`: cantidad afectada por una merma de vivero sobre esa asignación.

### 6.4. Ejemplo

Lote A:

```txt
saldo_vivo_actual = 500
```

Asignaciones activas:

```txt
San Miguel: cantidad_asignada 200, consumida 40, devuelta 0, mermada 10 -> saldo disponible 150
Cota Cota:  cantidad_asignada 100, consumida 0,  devuelta 20, mermada 0  -> saldo disponible 80
```

Entonces:

```txt
saldo_vivo_disponible_asignacion = 500 - (150 + 80) = 270
```

El admin o coordinador solo puede asignar hasta 270 plantas adicionales de ese lote.

---

## 7. Política de mermas sobre saldo asignado

### 7.1. Problema

Cuando ocurre una `MERMA` en un lote de vivero que tiene asignaciones activas en Módulo 3, el sistema debe decidir qué saldo se ve afectado.

### 7.2. Política MVP aprobada

La política recomendada para el MVP es:

1. La merma afecta primero el saldo no asignado del lote.
2. Si la merma excede el saldo no asignado, el excedente afecta asignaciones activas.
3. Las asignaciones se afectan ordenando por `subcampania.fecha_estimada_inicio DESC NULLS FIRST`: la subcampaña con inicio más lejano absorbe primero; la más próxima queda protegida (es la más urgente). Sin fecha = absorbe antes que cualquier fecha concreta.
4. No se debe sobrescribir ni reducir `cantidad_asignada`.
5. La afectación debe registrarse en `cantidad_mermada`.
6. El sistema debe notificar al coordinador de cada subcampaña afectada.

### 7.3. Fórmulas

Saldo no asignado:

```txt
saldo_no_asignado =
  LOTE_VIVERO.saldo_vivo_actual
  - SUM(saldo_asignado_disponible de asignaciones activas del lote)
```

Si:

```txt
cantidad_merma <= saldo_no_asignado
```

Entonces la merma solo afecta saldo no asignado y no toca asignaciones.

Si:

```txt
cantidad_merma > saldo_no_asignado
```

Entonces:

```txt
excedente_merma = cantidad_merma - saldo_no_asignado
```

Ese excedente se distribuye sobre las asignaciones activas ordenando por `subcampania.fecha_estimada_inicio DESC NULLS FIRST, asignacion.id DESC`, aumentando `cantidad_mermada` en cada asignación afectada.

### 7.4. Regla de auditoría

No se debe modificar `cantidad_asignada`, porque representa la reserva original.

Correcto:

```txt
cantidad_asignada = se conserva
cantidad_mermada = aumenta
saldo_asignado_disponible = se recalcula
```

Incorrecto:

```txt
reducir cantidad_asignada para simular la merma
```

Modificar `cantidad_asignada` borra información histórica y dificulta auditorías.

### 7.5. Restricciones

La política de mermas no puede dejar:

```txt
LOTE_VIVERO.saldo_vivo_actual < 0
cantidad_mermada < 0
cantidad_asignada < cantidad_consumida + cantidad_devuelta + cantidad_mermada
saldo_asignado_disponible < 0
```

### 7.6. Justificación

Esta política es adecuada para el MVP porque:

- evita decisiones manuales complejas en campo,
- mantiene trazabilidad de la reserva original,
- conserva auditoría,
- evita decimales en unidades,
- es predecible para el coordinador,
- permite explicar claramente por qué una subcampaña perdió stock reservado.

---

## 8. Evidencia heredada en `DESPACHO` automático

### 8.1. Regla general original

En Módulo 2, los eventos críticos como `DESPACHO` requieren evidencia obligatoria.

### 8.2. Excepción controlada

Los `DESPACHO` con:

```txt
origen_despacho = AUTOMATICO_PLANTACION
```

no requieren evidencia propia en `EVENTO_LOTE_VIVERO`, porque su evidencia obligatoria proviene del `REGISTRO_PLANTACION` asociado en Módulo 3.

### 8.3. Condición obligatoria

Esta excepción solo es válida si el `REGISTRO_PLANTACION` asociado tiene evidencia válida.

Si el registro de plantación o reposición no tiene evidencia válida, no debe guardarse el registro de M3 y, por tanto, tampoco debe generarse el `DESPACHO` automático en M2.

### 8.4. Matriz de evidencia

| Caso | Evidencia requerida |
|------|---------------------|
| `DESPACHO` + `MANUAL` | Evidencia propia obligatoria en M2 |
| `DESPACHO` + `AUTOMATICO_PLANTACION` | Evidencia heredada desde M3 |
| `PLANTACION_INICIAL` en M3 | Evidencia propia obligatoria en M3 |
| `REPOSICION` en M3 | Evidencia propia obligatoria en M3 |

### 8.5. Visualización

En el historial del lote de vivero, un despacho automático debe mostrar la evidencia del registro de plantación asociado.

Ejemplo de lectura:

```txt
DESPACHO automático a campaña
Evidencia: ver fotos del REGISTRO_PLANTACION asociado
```

---

## 9. Devoluciones del Módulo 3 no generan evento en Módulo 2

### 9.1. Aclaración

Cuando el Módulo 3 procesa una `DEVOLUCION_A_VIVERO`, no se genera ningún evento en Módulo 2.

### 9.2. Razones

- Los árboles nunca salieron físicamente del vivero.
- La asignación era solo una reserva lógica.
- `LOTE_VIVERO.saldo_vivo_actual` no cambia.
- Solo cambia el saldo disponible para nuevas asignaciones.

### 9.3. Efecto real

La devolución reduce:

```txt
ASIGNACION_VIVERO_SUBCAMPANIA.saldo_asignado_disponible
```

liberando disponibilidad para otras subcampañas.

No debe crear:

```txt
EVENTO_LOTE_VIVERO
```

---

## 10. Vista operativa de lotes de vivero

### 10.1. Nuevas columnas derivadas

La vista operativa de lotes de vivero debe mostrar:

| Columna | Descripción |
|---------|-------------|
| `saldo_vivo_actual` | Plantas vivas físicamente disponibles según M2. |
| `saldo_asignado_total` | Suma de saldos disponibles ya reservados por subcampañas. |
| `saldo_vivo_disponible_asignacion` | Saldo libre para nuevas asignaciones. |
| `asignaciones_activas` | Desglose expandible por subcampaña. |

### 10.2. Desglose recomendado

Por cada asignación activa, mostrar:

```txt
Subcampaña
Campaña
Propósito: PLANTACION_INICIAL | REPOSICION
Cantidad asignada
Cantidad consumida
Cantidad devuelta
Cantidad mermada
Saldo asignado disponible
Coordinador
Fecha de asignación
```

Esto permite que el admin o coordinador vea rápidamente qué tan comprometido está un lote.

---

## 11. Cambios recomendados al esquema

### 11.1. Cambios en `EVENTO_LOTE_VIVERO`

Agregar campos:

```txt
origen_despacho ENUM(origen_despacho_vivero) DEFAULT MANUAL
subcampania_id bigint NULL
campania_id bigint NULL
registro_plantacion_id bigint NULL
```

Representación en Mermaid:

```mermaid
EVENTO_LOTE_VIVERO {
  bigint id PK
  bigint lote_id FK
  ENUM(tipo_evento_vivero) tipo_evento "INICIO | EMBOLSADO | ADAPTABILIDAD | MERMA | DESPACHO | CIERRE_AUTOMATICO"
  ENUM(destino_tipo_vivero) destino_tipo "PLANTACION_CAMPANIA | PLANTACION_PROPIA | PLANTACION_COMUNIDAD | DONACION | VENTA | OTRO (ver enum canónico en database/00_database_schema.md)"
  ENUM(origen_despacho_vivero) origen_despacho "MANUAL | AUTOMATICO_PLANTACION"
  bigint subcampania_id FK "solo si origen_despacho = AUTOMATICO_PLANTACION"
  bigint campania_id FK "solo si origen_despacho = AUTOMATICO_PLANTACION"
  bigint registro_plantacion_id FK "solo si origen_despacho = AUTOMATICO_PLANTACION"
  int cantidad_afectada
  ENUM(unidad_medida) unidad_medida_evento "UNIDAD | G"
}
```

### 11.2. Cambios en `ASIGNACION_VIVERO_SUBCAMPANIA`

Agregar campo:

```txt
cantidad_mermada int DEFAULT 0
```

Actualizar fórmula de `saldo_asignado_disponible`:

```txt
saldo_asignado_disponible =
  cantidad_asignada
  - cantidad_consumida
  - cantidad_devuelta
  - cantidad_mermada
```

Representación en Mermaid:

```mermaid
ASIGNACION_VIVERO_SUBCAMPANIA {
  bigint id PK
  bigint subcampania_id FK
  bigint lote_vivero_id FK
  int cantidad_asignada "mayor a cero siempre UNIDAD"
  ENUM(proposito_asignacion) proposito "PLANTACION_INICIAL | REPOSICION"
  ENUM(estado_asignacion) estado "ACTIVA | AGOTADA | DEVUELTA | AFECTADA_POR_MERMA"
  int cantidad_consumida "materializado"
  int cantidad_devuelta "materializado"
  int cantidad_mermada "materializado por mermas de vivero"
  int saldo_asignado_disponible "materializado"
  bigint usuario_asignacion FK
  timestamptz fecha_asignacion
  timestamptz updated_at
}
```

> Nota: `AFECTADA_POR_MERMA` puede manejarse como estado visual o derivado. Si se quiere mantener el enum simple, puede omitirse y mostrarse como badge cuando `cantidad_mermada > 0`.

---

## 12. Restricciones recomendadas de consistencia

### 12.1. Restricción por origen de despacho

Regla lógica:

```sql
CHECK (
  (
    origen_despacho = 'MANUAL'
    AND destino_tipo <> 'PLANTACION_CAMPANIA'
    AND subcampania_id IS NULL
    AND campania_id IS NULL
    AND registro_plantacion_id IS NULL
  )
  OR
  (
    origen_despacho = 'AUTOMATICO_PLANTACION'
    AND destino_tipo = 'PLANTACION_CAMPANIA'
    AND subcampania_id IS NOT NULL
    AND campania_id IS NOT NULL
    AND registro_plantacion_id IS NOT NULL
  )
)
```

### 12.2. Restricción de cantidad mermada

```sql
CHECK (cantidad_mermada >= 0)
```

### 12.3. Restricción de saldo asignado no negativo

```sql
CHECK (
  cantidad_asignada >= cantidad_consumida + cantidad_devuelta + cantidad_mermada
)
```

### 12.4. Restricción de unidad en despachos de plantación

Para despachos automáticos:

```txt
unidad_medida_evento = UNIDAD
```

---

## 13. Invariantes M2 ↔ M3

Para mantener consistencia entre módulos, estas invariantes deben respetarse:

1. **Asignación es reserva lógica:**

   ```txt
   LOTE_VIVERO.saldo_vivo_actual no cambia al asignar.
   ```

2. **Devolución es liberación de reserva lógica:**

   ```txt
   LOTE_VIVERO.saldo_vivo_actual no cambia al devolver.
   ```

3. **Plantación es despacho real:**

   ```txt
   Cada REGISTRO_PLANTACION inicial genera N eventos DESPACHO en M2, uno por lote afectado.
   ```

4. **Reposición es despacho real:**

   ```txt
   Cada REGISTRO_PLANTACION con es_reposicion = true genera N eventos DESPACHO en M2, uno por lote afectado.
   ```

5. **Conservación por registro de plantación:**

   ```txt
   SUM(DESPACHO.cantidad_afectada) por registro_plantacion
   = REGISTRO_PLANTACION.cantidad_total
   ```

6. **Consistencia de unidades:**

   ```txt
   DESPACHO.unidad_medida_evento = UNIDAD
   ```

7. **Saldo disponible para asignar:**

   ```txt
   saldo_vivo_disponible_asignacion =
     LOTE_VIVERO.saldo_vivo_actual
     - SUM(saldo_asignado_disponible de asignaciones activas)
   ```

8. **Conservación de asignación:**

   ```txt
   saldo_asignado_disponible =
     cantidad_asignada
     - cantidad_consumida
     - cantidad_devuelta
     - cantidad_mermada
   ```

9. **Mermas no rompen saldos:**

   ```txt
   Una merma no puede dejar saldo_vivo_actual < 0.
   Una merma no puede dejar saldo_asignado_disponible < 0.
   ```

10. **Evidencia heredada:**

    ```txt
    Los DESPACHO con origen_despacho = AUTOMATICO_PLANTACION no tienen evidencia propia en M2.
    Su evidencia se obtiene desde REGISTRO_PLANTACION.
    ```

---

## 14. Acciones recomendadas para integración técnica

### 14.1. Backend / Base de datos

1. Agregar `PLANTACION_CAMPANIA` a `destino_tipo_vivero`.
2. Crear enum `origen_despacho_vivero` con:

   ```txt
   MANUAL
   AUTOMATICO_PLANTACION
   ```

3. Agregar a `EVENTO_LOTE_VIVERO`:

   ```txt
   origen_despacho
   subcampania_id
   campania_id
   registro_plantacion_id
   ```

4. Agregar a `ASIGNACION_VIVERO_SUBCAMPANIA`:

   ```txt
   cantidad_mermada
   ```

5. Actualizar cálculo de:

   ```txt
   saldo_asignado_disponible
   saldo_vivo_disponible_asignacion
   ```

6. Implementar constraints o validaciones equivalentes según origen de despacho.
7. Implementar generación atómica de `DESPACHO` desde M3 al guardar `PLANTACION_INICIAL` o `REPOSICION`.
8. Implementar política de urgencia de mermas sobre asignaciones cuando corresponda.

### 14.2. Frontend

1. En Vivero, mostrar si un lote tiene saldo reservado por subcampañas.
2. En el historial del lote, diferenciar:

   ```txt
   DESPACHO manual
   DESPACHO automático por plantación
   ```

3. En despacho automático, mostrar enlace a:

   ```txt
   Registro de plantación
   Subcampaña
   Campaña
   ```

4. En asignaciones afectadas por merma, mostrar advertencia visual al coordinador.

### 14.3. Documentación

1. Integrar este addendum al MD principal del Módulo 2.
2. Actualizar el JSON de requerimientos del Módulo 2.
3. Actualizar el esquema ERD general.
4. Actualizar los contratos del Módulo 3 donde se consume saldo asignado.

### 14.4. Notificaciones

Implementar notificación al coordinador cuando una merma de vivero afecte una asignación de su subcampaña.

Contenido mínimo recomendado:

```txt
Subcampaña afectada
Lote de vivero afectado
Cantidad mermada sobre su asignación
Nuevo saldo asignado disponible
Fecha de la merma
Causa de la merma
```

---

## 15. Estado final del addendum

Este addendum queda aprobado conceptualmente con las siguientes decisiones clave:

- `PLANTACION_CAMPANIA` se usa sin `Ñ`.
- `AUTOMATICO_PLANTACION` distingue despachos generados desde M3.
- `registro_plantacion_id` se agrega como referencia tipada obligatoria en despachos automáticos.
- La evidencia del despacho automático se hereda desde M3.
- Las devoluciones no generan evento en M2.
- Las mermas no reducen `cantidad_asignada`; se registran en `cantidad_mermada`.
- El saldo disponible para asignar es derivado y debe recalcularse desde asignaciones activas.
