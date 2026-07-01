# Diagramas — Módulo 1 Recolección

Estos diagramas resumen el flujo principal y la separación entre estado del registro y estado operativo. Las reglas canónicas viven en `01_reglas_de_negocio_recoleccion.md`.

## 1. Flujo principal

```mermaid
flowchart TD
  start([Inicio]) --> draft[Crear BORRADOR<br/>Fotos obligatorias<br/>GPS obligatorio<br/>Ficha editable]

  draft --> ready{Listo para solicitar validación}
  ready -- No --> edit[Editar BORRADOR]
  edit --> draft

  ready -- Sí --> pending[PENDIENTE_VALIDACION<br/>Ficha congelada]
  pending --> review{Validador aprueba}

  review -- No --> rejected[RECHAZADO<br/>No consumible<br/>Corregible]
  rejected --> fixRejected[Corregir RECHAZADO]
  fixRejected --> ready

  review -- Sí --> validated[VALIDADO<br/>Snapshot oficial congelado<br/>Ficha no editable]

  validated --> consume[Módulo 2 crea lote vivero<br/>CONSUMO_A_VIVERO automático]
  consume --> atomic{Transacción atómica<br/>lote + consumo}
  atomic -- Falla --> consumeError[Rechazar operación<br/>No crear lote<br/>No descontar saldo]
  atomic -- OK --> recalc1[Recalcular saldo]

  validated --> waste[Registrar DESECHO<br/>Motivo obligatorio]
  waste --> recalc2[Recalcular saldo]

  recalc1 --> balance{Saldo = 0}
  recalc2 --> balance
  balance -- Sí --> closedState[CERRADO]
  balance -- No --> openState[ABIERTO]
```

## 2. Máquina de estados

```mermaid
flowchart LR
  subgraph registro[Estado del registro]
    draft[BORRADOR<br/>Editable<br/>Fotos + GPS obligatorios<br/>Soft delete permitido] --> pending[PENDIENTE_VALIDACION<br/>Ficha congelada]
    pending --> validated[VALIDADO<br/>Snapshot oficial congelado<br/>No editable]
    pending --> rejected[RECHAZADO<br/>No consumible<br/>Editable para corregir]
    rejected -- Corregir y reenviar --> pending
  end

  subgraph operativo[Estado operativo]
    opOpen[ABIERTO<br/>saldo > 0] --> opClosed[CERRADO<br/>saldo = 0]
  end

  validated --> movement[Movimientos append-only<br/>CONSUMO_A_VIVERO<br/>DESECHO]
  movement --> recalc[Saldo = cantidad_inicial + suma de deltas]
  recalc --> opOpen
  recalc --> opClosed

  note1[ Solo VALIDADO puede alimentar Vivero ]:::note
  note2[ CERRADO no borra el registro; solo indica saldo agotado ]:::note

  note1 --- validated
  note2 --- opClosed

  classDef note fill:#f5f5f5,stroke:#999,stroke-width:1px,color:#111;
```
