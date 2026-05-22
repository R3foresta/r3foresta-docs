## Plan de ejecución — Modificaciones en Módulo 2 y usuarios

La idea es trabajar en este orden:

```text
1. Definir usuarios/roles operativos
2. Base de datos
3. Backend M2
4. Backend M3
5. Frontend M2
6. Frontend M3
7. Pruebas
8. Documentación
```

Esto es importante porque el Módulo 2 ya existe y está en producción; por eso los cambios deben ser extensiones, no cambios que rompan lo actual. 

---

# 0. Antes de tocar código: cerrar decisiones de usuarios

## Objetivo

Definir qué usuarios actuales van a cumplir funciones dentro de **Vivero, Campaña, Subcampaña y Plantación**.

No necesariamente se crean nuevos roles globales. Se pueden usar los roles existentes:

```text
ADMIN
GENERAL
VALIDADOR
VOLUNTARIO
```

Pero dentro del módulo se deben mapear funciones como:

```text
COORDINADOR_CAMPANIA
COORDINADOR_SUBCAMPANIA
OPERARIO_VIVERO
RESPONSABLE_PLANTACION
VOLUNTARIO_PLANTADOR
VERIFICADOR_PLANTACION
```

## Qué se debe definir

| Función                   | Qué hace                                                                   |
| ------------------------- | -------------------------------------------------------------------------- |
| `ADMIN`                   | Configura, audita y puede ver todo.                                        |
| `COORDINADOR_CAMPANIA`    | Crea campaña, administra subcampañas y asignaciones.                       |
| `COORDINADOR_SUBCAMPANIA` | Recibe plantas asignadas y controla ejecución.                             |
| `OPERARIO_VIVERO`         | Maneja eventos de vivero, mermas y despachos manuales.                     |
| `RESPONSABLE_PLANTACION`  | Registra la plantación en campo.                                           |
| `VERIFICADOR_PLANTACION`  | Valida o respalda que la plantación ocurrió.                               |
| `VOLUNTARIO_PLANTADOR`    | Participa en la jornada, pero no necesariamente registra eventos críticos. |

## Resultado esperado

Tener claro:

```text
Qué usuario puede asignar plantas.
Qué usuario puede registrar plantación.
Qué usuario puede verificar.
Qué usuario recibe notificaciones por merma.
Qué usuario puede hacer despacho manual.
```

Esto es necesario porque el despacho automático desde M3 debe validar permisos del responsable de plantación y no heredar permisos del operario de vivero. 

---

# 1. Base de datos — Primer bloque obligatorio

## 1.1. Modificar `EVENTO_LOTE_VIVERO`

Se debe extender la tabla para diferenciar:

```text
DESPACHO manual
DESPACHO automático generado desde Plantación
```

Agregar:

```text
origen_despacho
subcampania_id
campania_id
registro_plantacion_id
```

También agregar el enum:

```text
origen_despacho_vivero = MANUAL | AUTOMATICO_PLANTACION
```

Y agregar en `destino_tipo_vivero`:

```text
PLANTACION_CAMPANIA
```

Esto permite saber si un evento `DESPACHO` fue creado directamente desde Vivero o si fue generado automáticamente cuando M3 registró una plantación. 

## 1.2. Crear `ASIGNACION_VIVERO_SUBCAMPANIA`

Esta tabla es el puente principal entre M2 y M3.

Debe guardar:

```text
subcampania_id
lote_vivero_id
proposito
estado
cantidad_asignada
cantidad_consumida
cantidad_devuelta
cantidad_mermada
saldo_asignado_disponible
usuario_asignacion_id
fecha_asignacion
```

Esta tabla controla qué fue reservado, consumido, devuelto y mermado por subcampaña. 

## 1.3. Crear vista de saldos

Crear:

```text
v_lote_vivero_saldos
```

Para calcular:

```text
saldo_vivo_actual
saldo_asignado_total
saldo_vivo_disponible_asignacion
```

El sistema ya no debe validar solo contra `saldo_vivo_actual`, porque parte del saldo puede estar reservado para campañas o subcampañas. 

---

# 2. Backend M2 — Modificar Vivero

## 2.1. Validar despacho manual

El despacho manual de Vivero debe seguir existiendo, pero con reglas nuevas:

```text
origen_despacho = MANUAL
destino_tipo != PLANTACION_CAMPANIA
cantidad <= saldo_vivo_disponible_asignacion
```

Esto evita que un operario de vivero use plantas que ya están reservadas para una subcampaña.

## 2.2. Bloquear creación manual de despacho automático

El backend de M2 debe rechazar esto:

```text
origen_despacho = AUTOMATICO_PLANTACION
```

Porque ese tipo de despacho solo lo puede crear M3 al registrar una plantación. 

## 2.3. Endpoint de saldos

Crear o actualizar:

```http
GET /api/lotes-vivero/:id/saldos
```

Debe devolver:

```json
{
  "saldo_vivo_actual": 500,
  "saldo_asignado_total": 230,
  "saldo_vivo_disponible_asignacion": 270,
  "asignaciones_activas": []
}
```

Este endpoint alimentará tanto la vista de Vivero como las validaciones del backend. 

## 2.4. Modificar handler de merma

Cuando se registra una `MERMA`, debe aplicar esta política:

```text
1. Primero afecta saldo no asignado.
2. Si no alcanza, afecta asignaciones activas por FIFO.
3. No modifica cantidad_asignada.
4. Aumenta cantidad_mermada.
```

Esto protege las reservas de subcampañas y mantiene trazabilidad.

---

# 3. Backend M3 — Plantación y Campañas

## 3.1. Crear Campaña y Subcampaña

El M3 debe tener entidades como:

```text
CAMPANIA
SUBCAMPANIA
REGISTRO_PLANTACION
```

La `SUBCAMPANIA` debe tener coordinador, porque si una merma afecta su asignación, el sistema debe saber a quién notificar.

## 3.2. Crear asignación de vivero a subcampaña

Endpoint sugerido:

```http
POST /subcampanias/:id/asignaciones-vivero
```

Debe validar:

```text
lote_vivero_id existe
cantidad > 0
cantidad <= saldo_vivo_disponible_asignacion
usuario_asignacion_id válido
proposito = PLANTACION_INICIAL | REPOSICION
```

Al guardar, crea un registro en:

```text
ASIGNACION_VIVERO_SUBCAMPANIA
```

## 3.3. Registrar plantación inicial

Endpoint sugerido:

```http
POST /subcampanias/:id/registros-plantacion
```

Cuando se guarda un `REGISTRO_PLANTACION`, el backend debe hacer todo en una sola transacción:

```text
1. Validar subcampaña.
2. Validar asignaciones.
3. Insertar REGISTRO_PLANTACION.
4. Actualizar cantidad_consumida.
5. Crear DESPACHO automático en EVENTO_LOTE_VIVERO.
6. Vincular evidencia.
7. Commit.
```

Si falla cualquier paso, todo se revierte. No puede existir plantación sin despacho automático ni despacho automático sin plantación. 

## 3.4. Manejar devoluciones

Según la decisión cerrada, las devoluciones desde M3 **no generan evento en `EVENTO_LOTE_VIVERO`**. Se manejan en la asignación aumentando:

```text
cantidad_devuelta
```

Esto significa que no se agrega `DEVOLUCION` al enum de eventos de Vivero. 

---

# 4. Frontend M2 — Vivero

## 4.1. Vista operativa de lotes

La tabla de lotes debe mostrar nuevas columnas:

```text
Saldo vivo
Saldo reservado
Saldo libre
Asignaciones activas
```

El botón de despacho manual debe bloquearse si:

```text
saldo_vivo_disponible_asignacion = 0
```

## 4.2. Fila expandible

Al expandir un lote, debe mostrar las asignaciones activas:

```text
Subcampaña
Campaña
Propósito
Cantidad asignada
Consumida
Devuelta
Mermada
Saldo disponible
Coordinador
Fecha
```

## 4.3. Historial diferenciado

En el timeline del lote, un `DESPACHO` debe mostrar badge:

```text
MANUAL
POR PLANTACIÓN
```

Si es automático, debe mostrar:

```text
Campaña
Subcampaña
Registro de plantación
Evidencia heredada desde REGISTRO_PLANTACION
```

El historial actual asume que las fotos están vinculadas al evento de vivero, pero en despachos automáticos la evidencia viene desde `REGISTRO_PLANTACION`. 

---

# 5. Frontend M3 — Campañas, Subcampañas y Plantación

## Pantallas mínimas

```text
Listado de campañas
Detalle de campaña
Detalle de subcampaña
Asignar lote de vivero
Registrar plantación
Registrar reposición
Registrar devolución
Ver alertas de merma
```

## Pantalla de asignación

Debe permitir seleccionar:

```text
lote_vivero_id
cantidad_asignada
propósito
responsable
```

Y debe mostrar:

```text
saldo vivo
saldo reservado
saldo libre
```

## Pantalla de plantación

Debe permitir registrar:

```text
cantidad plantada
fecha
responsable
verificador
ubicación
evidencia
lotes usados
```

---

# 6. Notificaciones / Alertas

Si una merma en Vivero afecta una asignación activa, el coordinador de esa subcampaña debe enterarse.

Primero hay que decidir si habrá:

```text
notificación in-app
email
push
vista de alertas
```

Para MVP, si no existe sistema de notificaciones, lo más simple es una pestaña:

```text
Alertas del coordinador
```

Ahí se mostraría:

```text
Subcampaña afectada
Lote afectado
Cantidad mermada
Nuevo saldo disponible
Fecha
Causa
Responsable de la merma
```

---

# 7. Pruebas obligatorias

## Base de datos

Probar:

```text
DESPACHO manual con PLANTACION_CAMPANIA falla.
DESPACHO automático sin subcampania_id falla.
Eventos no-DESPACHO siguen funcionando.
Asignación con cantidad 0 falla.
Asignación con consumo mayor a cantidad asignada falla.
```

## Backend

Probar:

```text
Plantación con 3 lotes crea 3 despachos automáticos.
Si un lote no tiene saldo, no se guarda nada.
Dos plantaciones simultáneas no pueden consumir el mismo saldo.
Despacho manual no puede tocar saldo reservado.
Merma afecta asignaciones por FIFO.
```

## Frontend

Probar:

```text
Se ve saldo vivo, reservado y libre.
Se bloquea despacho manual si no hay saldo libre.
Timeline diferencia MANUAL vs POR PLANTACIÓN.
Despacho automático muestra evidencia heredada.
```

---

# 8. Documentación

Actualizar:

```text
00_Requerimientos-Modulo_2_Vivero.json
01_regas_de_negocio_vivero.md
02_doc_guia_viviero.md
00_database_schema.md
Documentación de Plantación M3
```

La documentación oficial debe absorber el addendum para que el comportamiento real del módulo quede en los archivos principales y no en documentos separados. 

---

# Orden final recomendado

```text
FASE 0 — Cerrar usuarios y permisos
FASE 1 — Migraciones DB de Vivero
FASE 2 — Tabla ASIGNACION_VIVERO_SUBCAMPANIA
FASE 3 — Vista de saldos derivados
FASE 4 — Backend M2: despacho manual, merma FIFO, saldos
FASE 5 — Backend M3: asignaciones y plantación con despacho automático
FASE 6 — Frontend M2: lotes, saldos e historial
FASE 7 — Frontend M3: campañas, subcampañas y registros
FASE 8 — Notificaciones o alertas
FASE 9 — Pruebas integrales
FASE 10 — Documentación final
```

## Resumen para explicar al equipo

> Primero se definen los usuarios y permisos. Luego se modifica la base de datos de Vivero para soportar despachos automáticos y asignaciones a subcampañas. Después se ajusta el backend para calcular saldos reales, bloquear despachos manuales sobre stock reservado y crear despachos automáticos desde Plantación. Finalmente se actualiza el frontend para mostrar saldos reservados/libres, historial diferenciado y alertas al coordinador.
