**diagrama Mermaid** en base a **proceso del Módulo 1 — Recolección**

```mermaid
flowchart TD
  %% =========================
  %% MODULO 1 — RECOLECCION (LOTE ORIGEN)
  %% =========================

  start([Inicio]) --> b0[Captura en campo]

  b0 --> b1[**BORRADOR** Crear recoleccion
  Fecha no futura y hasta 45 dias atras
  Tipo material SEMILLA o ESQUEJE
  Especie cientifico y comercial
  Cantidad inicial mayor a 0
  Recolector usuario autenticado
  Vivero almacenamiento
  Observacion opcional]

  b1 --> vmin{Validaciones minimas **BORRADOR**
  Tipo obligatorio
  Especie obligatoria
  Cantidad mayor a 0
  Fecha valida}

  vmin -- No --> fix1[Corregir datos y reintentar]
  fix1 --> b1
  vmin -- Si --> b2[Guardar **BORRADOR**
  Editable
  Sin blockchain]

  b2 --> evloc[Completar evidencia y ubicacion
  Fotos minimo 2
  JPG o PNG
  Max 5MB por foto
  Lat y Long obligatorias
  Niveles admin opcional
  Permite SIN ESPECIFICAR]

  evloc --> reqVal{Cumple requisitos para VALIDAR}
  reqVal -- No --> b2
  reqVal -- Si --> val[VALIDAR Sellado
  Guarda usuario_validacion
  Guarda fecha_validacion
  No editable directo]

  val --> post[Post **VALIDADO** Append only
  CONSUMO_A_VIVERO
  DESECHO
  CORRECCION]

  %% =========================
  %% CONSUMO AUTOMATICO HACIA MODULO 2
  %% =========================
  post --> m2[En Modulo 2 Crear lote vivero
  Selecciona esta recoleccion
  Indica cantidad a consumir]

  m2 --> check{Checks antes de consumir
  Estado **VALIDADO**
  Operativo ABIERTO saldo mayor a 0
  Saldo suficiente}

  check -- No --> err1[Rechazar operacion
  No crea lote M2
  No descuenta saldo]

  check -- Si --> atomic{{Transaccion atomica
  Crear lote M2 y consumir}}

  atomic --> ok1[Crear lote en Modulo 2
  Enlaza recoleccion_id con lote_vivero_id]

  ok1 --> mov1[Movimiento CONSUMO_A_VIVERO]
  mov1 --> saldo1[Descontar saldo
  saldo igual inicial menos consumos menos descartes mas o menos correcciones]

  saldo1 --> close1{Saldo igual a 0}
  close1 -- Si --> cerr[Operativo CERRADO]
  close1 -- No --> ab[Operativo ABIERTO]

  %% =========================
  %% DESECHO
  %% =========================
  post --> des[Registrar DESECHO
  Parcial o total
  Motivo obligatorio
  Catalogo mas OTRO
  Observacion opcional]

  des --> mov2[Movimiento DESECHO]
  mov2 --> saldo2[Recalcular saldo]
  saldo2 --> close2{Saldo igual a 0}
  close2 -- Si --> cerr
  close2 -- No --> ab

  %% =========================
  %% CORRECCION POST VALIDACION
  %% =========================
  post --> corr[Solicitar CORRECCION]
  corr --> adminok{Admin aprueba correccion}
  adminok -- No --> corrrej[Rechazar correccion
  Se conserva historial]
  adminok -- Si --> mov3[Movimiento CORRECCION
  Delta mas o menos
  Motivo
  Responsable
  Timestamp]

  mov3 --> saldo3[Recalcular saldo
  No puede ser negativo]
  saldo3 --> close3{Saldo igual a 0}
  close3 -- Si --> cerr
  close3 -- No --> ab

  %% =========================
  %% BLOCKCHAIN MVP
  %% =========================
  val --> bc1[(Anclar en blockchain al VALIDAR)]
  mov1 --> bc2[(Anclar en blockchain CONSUMO_A_VIVERO)]
  mov2 --> bc3[(Anclar en blockchain DESECHO)]
  mov3 --> bc4[(Anclar en blockchain CORRECCION)]
```

---

## 2) Diagrama Mermaid — Proceso operativo (BORRADOR → VALIDADO → consumo/descarte/corrección)

```mermaid id="op_m1_recoleccion"
flowchart TD
  start([Inicio]) --> b0[BORRADOR Crear recoleccion]
  b0 --> b1[Editar BORRADOR
  Completar datos base
  Guardar cambios]

  b1 --> req{Listo para VALIDAR
  Fotos minimo 2
  Lat y Long validas
  Campos min completos}

  req -- No --> b1
  req -- Si --> val[VALIDADO Sellado
  No editable directo]

  %% Consumo automatico hacia Modulo 2
  val --> m2[Modulo 2 Crear lote vivero
  Selecciona recoleccion
  Indica cantidad]

  m2 --> check{Checks
  VALIDADO
  ABIERTO saldo mayor a 0
  Saldo suficiente}

  check -- No --> rej[Rechazar operacion
  No crea lote M2
  No descuenta]
  check -- Si --> atom{{Operacion atomica}}
  atom --> ok[Crear lote M2 + registrar CONSUMO_A_VIVERO]
  ok --> sal1[Actualizar saldo]
  sal1 --> s0{Saldo igual a 0}
  s0 -- Si --> cerr[Operativo CERRADO]
  s0 -- No --> ab[Operativo ABIERTO]

  %% Descarte
  val --> des[Registrar DESECHO
  Cantidad + motivo]
  des --> sal2[Actualizar saldo]
  sal2 --> s1{Saldo igual a 0}
  s1 -- Si --> cerr
  s1 -- No --> ab

  %% Correccion
  val --> corr[Solicitar CORRECCION
  Motivo + delta]
  corr --> adm{Admin aprueba}
  adm -- No --> corrrej[No aplica correccion]
  adm -- Si --> corrOK[Registrar CORRECCION]
  corrOK --> sal3[Actualizar saldo]
  sal3 --> s2{Saldo igual a 0}
  s2 -- Si --> cerr
  s2 -- No --> ab
```

---

## 3) Diagrama Mermaid — Modelo de eventos (append-only + cálculo de saldo)

Este diagrama muestra que **no editamos el pasado**: solo agregas eventos, y el saldo sale de sumar/restar.

```mermaid id="eventos_m1_recoleccion"
flowchart TD
  a0[Recoleccion Lote Origen
  cantidad_inicial
  tipo_material
  estado_registro BORRADOR o VALIDADO
  estado_operativo ABIERTO o CERRADO] --> a1[Ledger de eventos append only]

  a1 --> e1[EVENTO VALIDACION
  usuario_validacion
  fecha_validacion
  snapshot hash opcional]

  a1 --> e2[EVENTO CONSUMO_A_VIVERO
  cantidad
  lote_vivero_id
  timestamp]

  a1 --> e3[EVENTO DESECHO
  cantidad
  motivo
  timestamp]

  a1 --> e4[EVENTO CORRECCION
  delta mas o menos
  motivo
  responsable
  timestamp]

  %% Reglas de saldo
  a1 --> calc[Calculo de saldo]
  calc --> formula[Saldo = cantidad_inicial
  - suma de consumos
  - suma de desechos
  + suma de correcciones]

  formula --> rule1[Regla 1 Saldo nunca negativo]
  formula --> rule2[Regla 2 Solo CORRECCION puede aumentar saldo]
  formula --> rule3[Regla 3 Si saldo igual a 0 => CERRADO]

  %% Blockchain MVP
  e1 --> bc1[(Blockchain ancla VALIDACION)]
  e2 --> bc2[(Blockchain ancla CONSUMO_A_VIVERO)]
  e3 --> bc3[(Blockchain ancla DESECHO)]
  e4 --> bc4[(Blockchain ancla CORRECCION)]
```

---
## 4) **Estado del registro (Web2)** vs **Estado operativo (inventario)**.
La idea clave: **VALIDADO no significa agotado**, y **CERRADO no significa borrado**.

```mermaid id="maquina_estados_m1"
flowchart LR
  %% =========================
  %% DIMENSION 1: ESTADO DEL REGISTRO (WEB2)
  %% =========================
  subgraph R[Estado del registro Web2]
    r0[BORRADOR
    Editable
    No blockchain] --> r1[VALIDADO
    Sellado
    No editable directo
    Elegible consumo]
    r1 --> r1c[CORRECCION
    Evento append only
    Requiere aprobacion admin]
    r1c --> r1
  end

  %% =========================
  %% DIMENSION 2: ESTADO OPERATIVO (INVENTARIO)
  %% =========================
  subgraph O[Estado operativo Inventario]
    o0[ABIERTO
    saldo mayor a 0] --> o1[CERRADO
    saldo igual a 0]
  end

  %% =========================
  %% TRANSICIONES QUE AFECTAN INVENTARIO (EVENTOS)
  %% =========================
  r1 --> c1[CONSUMO_A_VIVERO
  desde Modulo 2
  atomico] --> o0
  c1 --> t1[Recalcula saldo] --> o0
  t1 --> z1{Saldo igual a 0}
  z1 -- Si --> o1
  z1 -- No --> o0

  r1 --> d1[DESECHO
  motivo obligatorio] --> t2[Recalcula saldo] --> z2{Saldo igual a 0}
  z2 -- Si --> o1
  z2 -- No --> o0

  r1 --> k1[CORRECCION
  delta mas o menos] --> t3[Recalcula saldo] --> z3{Saldo igual a 0}
  z3 -- Si --> o1
  z3 -- No --> o0

  %% =========================
  %% REGLAS CLAVE
  %% =========================
  note1[Regla clave
  BORRADOR nunca se consume
  Solo VALIDADO puede alimentar Modulo 2]:::note
  note2[Regla clave
  CERRADO solo significa saldo 0
  El registro sigue existiendo]:::note

  note1 --- r0
  note1 --- r1
  note2 --- o1

  classDef note fill:#f5f5f5,stroke:#999,stroke-width:1px,color:#111;
```


