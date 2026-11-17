## 3.2. Análisis y diseño del sistema

Para maquetar las figuras en hojas carta verticales, usar las [láminas por figura](figuras/paginas/README.md). Los bloques Mermaid conservan la fuente completa; los diagramas extensos continúan en paneles legibles.

> Parte del [Capítulo III](03_capitulo_marco_aplicativo.md). Consolidación del 4 de noviembre de 2026, exclusivamente con RUP adaptado. Integra los refinamientos de Inicio, las decisiones aceptadas de Participación aliada y los diagramas actualizados en `445f24f`. El refinamiento aprobado el 16 de noviembre actualiza los requisitos y el modelo físico mediante el nuevo extracto aportado. Las evidencias de implementación y entorno conservan sus fechas propias.

### 3.2.1. Propósito y correspondencia con la metodología

Esta sección responde al segundo objetivo específico: **diseñar la organización de la información y las relaciones necesarias para reconstruir el recorrido registrado del material vegetal desde su origen registrado hasta el registro de su plantación**. Toma como entrada el análisis de requisitos de la sección 3.1: las necesidades NEC-01 a NEC-08, los casos CU-01 a CU-12, los requisitos no funcionales RNF-INI-01 a RNF-INI-06 y los riesgos de Inicio. La confirmación del autor del 4 de noviembre da por terminada Inicio/LCO y habilita la continuación documental en Elaboración; no atribuye a julio una revisión que no está registrada.

En RUP adaptado, Elaboración concentra las disciplinas de requisitos, análisis y diseño, con implementación y pruebas cuando permiten reducir un riesgo arquitectónico. Se relaciona con EL-1 del plan adoptado el 25 de agosto. Los refinamientos de octubre y noviembre conservan sus fechas: la presencia de código anterior o posterior no acredita por sí sola el cierre de esa iteración ni del hito LCA.

El trabajo selecciona escenarios por su efecto sobre la continuidad del recorrido: consumo parcial del origen, resultado observado de propagación, incorporación de plantas ya vivas, entrega física, consumo concurrente y recuperación de una respuesta perdida. La línea arquitectónica M1→M2→M3 permite contrastar identidad, cantidades, autorización e historial. Las variantes de incorporación amplían el diseño donde la estructura física actual todavía no ofrece ese recorrido.

La exposición sigue **requerimientos → casos de uso → procesos → interacciones → modelo de datos → implementación**. Los contratos y las especificaciones existentes aportan reglas y criterios verificables; no se exige otra familia de documentos o identificadores para justificar el proceso. Las entregas INT aportan evidencia técnica a las iteraciones académicas y no las sustituyen.

**Tabla 3.16**

*Productos de Elaboración y uso de su evidencia*

| Producto | Decisión que sustenta | Fuente y correspondencia | Uso posterior |
|---|---|---|---|
| Requerimientos y capacidades (3.2.3) | qué información debe conservarse y qué operación se permite | NEC, RF y CU existentes; RNF iniciales | criterios de aceptación e identificación de vacíos |
| Casos de uso (3.2.4–3.2.5) | quién interactúa y con qué objetivo | catálogo CU-01–CU-12; PA-S01/02/03; acuerdos de Vivero | interfaz, autorización y escenarios |
| Procesos (3.2.6) | qué hechos explican estados y cantidades | flujos, reglas y ADR vigentes | implementación y reconstrucción del recorrido |
| Interacciones (3.2.7) | dónde se confirman efectos conjuntos y cómo se recupera el resultado | contratos M1→M2, M2→M3 y D01–D12 | operaciones transaccionales y pruebas de integración |
| Modelos de datos (3.2.8) | cómo se relacionan procedencia, stock, consumo e historial | modelo conceptual y lógico; exportación física y fuentes de relaciones | migraciones y contraste de versiones |
| Invariantes, arquitectura y riesgos (3.2.9–3.2.12) | qué propiedades deben sostenerse para evaluar LCA | INV, RNF y RDI; arquitectura y evidencia técnica | verificación arquitectónica y decisión de salida |
| Implementación (3.3) | qué parte está materializada en una versión y entorno | código, migraciones, pruebas y ESTADO | evaluación de los incrementos y preparación de IOC |

*Nota.* Elaboración propia a partir de Inicio, los módulos, contratos, ADR y el [tablero académico](../../02_planificacion/TODO_PROYECTO_GRADO.md). Las disciplinas se revisitan cuando cambia una regla o aparece evidencia nueva; el orden expositivo no representa una ejecución lineal de todo el desarrollo.

### 3.2.2. Recorrido registrado y límites del diseño

El recorrido es una secuencia de origen, ingreso, cambios observados, movimientos y destino, con cantidades, unidades, fechas, responsables, ubicaciones y evidencia. General mantiene referencias compartidas; Recolección, Vivero y Plantación representan las tres etapas operativas. El historial y las consultas son capacidades transversales.

La propagación comienza en una recolección registrada. Las compras, donaciones y existencias previas de plantines comienzan en su recepción o conteo actual. La modalidad «inventario inicial» explica cuándo se incorpora una existencia al sistema; la procedencia explica de dónde proviene. Una compra antigua no se transforma en una compra actual ni permite inferir pérdidas anteriores a partir de la diferencia entre documentos y conteo.

**Figura 3.6. Recorrido del diseño integrado y variantes de ingreso**

<!-- diagrama: 03_2_fase_elaboracion-01 -->
```mermaid
flowchart TB
    subgraph ORIGEN["Entradas al recorrido"]
        REC["Semillas o esquejes<br/>registrados en Recolección"]
        COMP["Plantines comprados"]
        DON["Plantines donados"]
        EXIST["Plantines existentes<br/>al comenzar el sistema"]
    end

    REC --> VAL["Recepción y validación<br/>de Recolección"]
    VAL --> INI["INICIO de lote<br/>consumo atómico del origen"]
    INI --> PROC["Material en proceso<br/>sin saldo vivo"]
    PROC --> RES{"Resultado observado"}
    RES -->|"Plantas vivas"| EMB["EMBOLSADO<br/>crea saldo vivo"]
    RES -->|"Sin plantas viables"| PRE["DESCARTE_PRE_EMBOLSADO<br/>y cierre"]

    COMP --> RECEP["Recepción de plantines<br/>registrada por ADMIN"]
    DON --> RECEP
    EXIST --> INVENT["Inventario inicial<br/>conteo actual registrado por ADMIN"]

    RECEP --> IDENT["Especie, procedencia y fecha<br/>cantidad contada, responsable<br/>y foto privada obligatoria"]
    INVENT --> IDENT
    IDENT --> INC["INCORPORACIÓN<br/>crea saldo vivo una sola vez"]

    EMB --> LOTE["Lote trazable de plantas vivas"]
    INC --> LOTE

    LOTE --> MAN["Manejo y adaptabilidad"]
    MAN --> MER["Merma real registrada"]
    MAN --> SAL["Saldo físico disponible"]
    MER --> SAL

    SAL --> ENTREGA["Entrega física a subcampaña"]
    ENTREGA --> ASIG["Asignación con lote,<br/>especie, cantidad y propósito"]
    ASIG --> PLANT["Plantación inicial autorizada<br/>consumo LIFO de asignaciones"]
    PLANT --> TRAZA["Registro + detalles + participantes<br/>ubicación + evidencia + recibo"]

    ASIG --> DEV["Remanente devuelto físicamente"]
    DEV --> SAL

    DIRECTA["Recepción externa directa en campo<br/>diseño por concretar"] -.-> CAMPO["Stock de subcampaña<br/>sin entrada ficticia a Vivero"]
    CAMPO -.-> PLANT
    TRAZA --> PUBLICO["Información pública elegible"]
    TRAZA --> PROPIO["Consulta propia autorizada"]
    TRAZA --> CUSTODIA["Reconstrucción del recorrido registrado"]
```

*Nota.* Adaptación de los diagramas del 4 de noviembre a NEC-01–NEC-08 y a los contratos del recorrido. La incorporación y el acceso por vivero cuentan con implementación y pruebas en el alcance documentado en ESTADO; sus condiciones de entorno y aceptación permanecen abiertas. La recepción directa requiere completar origen, custodia y remanentes. Las líneas discontinuas sitúan esta última variante sin atribuirle una solución física ya aplicada. Etapa y variedad de incorporación conservan diferencias pendientes de revisión.

GENERAL y VALIDADOR activos manejan material en viveros asignados; la recepción y validación de semillas corresponde a ADMIN o VALIDADOR habilitado para el almacenamiento, distinto del recolector. La incorporación de plantines vivos y del inventario inicial se reserva a ADMIN. No se adopta una aptitud adicional de entrega. [Contrato M1→M2](../../../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md).

**Figura 3.7. Genealogía del material vegetal en la ruta principal**

<!-- diagrama: 03_2_fase_elaboracion-02 -->
```mermaid
flowchart TB
  O[Origen registrado<br/>recolección validada]
  LR[Lote de Recolección<br/>cantidad y unidad de origen]
  LV1[Lote de Vivero A<br/>material en proceso]
  LV2[Lote de Vivero B<br/>consumo parcial del mismo origen]
  EV1[Eventos de Vivero<br/>INICIO, EMBOLSADO, MERMA]
  EV2[Eventos de Vivero<br/>INICIO, EMBOLSADO]
  A1[Asignación física<br/>a subcampaña]
  A2[Asignación física<br/>a subcampaña]
  P[Registro de plantación]
  D1[Detalle plantado<br/>lote A, especie y cantidad]
  D2[Detalle plantado<br/>lote B, especie y cantidad]

  O --> LR
  LR -->|movimiento de consumo| LV1
  LR -->|movimiento de consumo| LV2
  LV1 --> EV1
  LV2 --> EV2
  EV1 -->|saldo vivo entregado| A1
  EV2 -->|saldo vivo entregado| A2
  A1 --> D1
  A2 --> D2
  P --> D1
  P --> D2
```

*Nota.* Elaboración propia a partir de los contratos M1→M2 y M2→M3. Un origen puede abastecer varios lotes y una plantación puede consumir varios orígenes, conservando su detalle. La incorporación de plantines sustituye el antecedente de Recolección por su recepción o conteo real; no inventa propagación anterior. La consulta integral de esta genealogía requiere sus pruebas en CO-4 y TR-1.

En propagación el lote referencia una recolección; en incorporación `recoleccion_id` queda nulo y el origen es la recepción o conteo. La estructura por sí sola no acredita el funcionamiento de una variante. Las plantaciones ya realizadas necesitan un tratamiento histórico separado: no constituyen stock para volver a plantar. La recepción directa y su eventual traslado real a un vivero deben conservar su procedencia sin registrar entradas o despachos ficticios.

### 3.2.3. Capacidades y realización de los requisitos

El análisis de requisitos de la sección 3.1 relaciona HAL→NEC→RF/CU e identifica los actores generales. Aquí se conserva el catálogo para precisar la realización de cada capacidad, sus contratos y la distribución de responsabilidades en el diseño. Los RF de los módulos conservan sus IDs; PA-S01 y PA-S03 refinan el registro inicial y su autorización, y PA-S02 distingue consulta pública y propia. D01–D12 están aceptadas y sus decisiones no se vuelven a presentar como preguntas de diseño.

**Tabla 3.17**

*Capacidades seleccionadas y resultados de diseño*

| Código | Capacidad | Actor principal | Requisitos relacionados | Resultado esperado |
|---|---|---|---|---|
| CU-01 | administrar datos maestros | ADMIN | RF-GEN-01–RF-GEN-07 | referencias compartidas, usuarios y roles globales controlados |
| CU-02 | registrar y completar una recolección | operador de Recolección o ADMIN, según autoría y estado | RF-REC-01–RF-REC-03 | origen, material, cantidad, unidad, ubicación y evidencia |
| CU-03 | recibir y validar una recolección | ADMIN o VALIDADOR asignado al almacenamiento, distinto del recolector | RF-REC-04 | recepción conforme, snapshots y resultado recuperable conjuntos, o rechazo motivado con historial |
| CU-04 | afectar el saldo de Recolección | actor autorizado por operación | RF-REC-05 | desecho autorizado o consumo iniciado por CU-05, sin saldo negativo |
| CU-05 | iniciar un lote de vivero | operario autorizado o ADMIN | RF-VIV-01 y RF-VIV-15; contrato M1→M2 | propagación confirma lote, INICIO y consumo de origen juntos; incorporación por ADMIN crea lote y base viva con procedencia propia |
| CU-06 | registrar resultado observado | operario autorizado o ADMIN | RF-VIV-02 y RF-VIV-02A | plantas vivas observadas o descarte pre-embolsado con causa |
| CU-07 | registrar movimientos de Vivero | operario autorizado o ADMIN | RF-VIV-03–RF-VIV-09 | manejo, pérdidas y salidas con saldo e historial explicables |
| CU-08 | planificar campaña y subcampaña | ADMIN | RF-PLA-01–RF-PLA-03 y RF-PLA-18 | zona, coordinación, polígono, meta y plan por especie |
| CU-09 | asignar plantas a subcampaña | ADMIN o coordinación autorizada | RF-PLA-04; RF-VIV-11 | entrega física y stock disponible en campo |
| CU-10 | devolver plantas no consumidas | ADMIN o coordinación autorizada | RF-PLA-05; RF-VIV-12 | retorno físico al lote de origen, sin superar el remanente |
| CU-11 | registrar plantación inicial | PLANTADOR, ADMINISTRADOR_SUBCAMPANIA o ADMIN | RF-PLA-06 y RF-PLA-13; PA-S01/03 | cantidades por especie, consumo LIFO, GPS, fotos, participantes y recibo |
| CU-12 | reconstruir un recorrido | persona autorizada para la vista | RF-REC-03/05, RF-VIV-07, RF-PLA-14; NEC-08 | origen, eventos, cantidades, responsables, evidencia y destino recuperables |
| RF-REC-06 | consultar el banco público de semillas | visitante sin cuenta | RF-REC-06 | resumen, filtros, listado y detalle de semillas no eliminadas en todos los estados; fotografías públicas solo de VALIDADO |

*Nota.* Elaboración propia a partir de los requisitos de los módulos y los refinamientos aceptados. RF-VIV-11 y RF-VIV-12 se definen en el contrato M2→M3. CU-04 no crea un descuento manual paralelo al inicio de Vivero. Los permisos de participación no se deducen del equipo logístico. La autoridad por vivero y su alcance acreditado se distinguen en 3.2.13.

RF-REC-06 conserva una consulta pública específica de Recolección. Incluye BORRADOR, PENDIENTE_VALIDACION, VALIDADO y RECHAZADO; separa G y UNIDAD, limita las fotografías sanitizadas a VALIDADO y distingue indisponibilidad de un banco vacío. Esta proyección no concede operaciones, acceso a originales privados ni una consulta pública integral M1→M2→M3. Su presencia sitúa las audiencias, sin ampliar los criterios de evaluación académica.

En RF-REC-01/03/04, la ventana de 45 días se comprueba al crear la ficha o cambiar explícitamente su fecha. Una corrección de otros datos puede conservar la fecha original aunque haya envejecido. AUD-036 mantiene pendiente corregir el bloqueo de ese recorrido en la PWA; la aprobación de la regla no acredita su cumplimiento completo.

Las nuevas capacidades se nombran sin renumerar CU-01–CU-12: **asignar operarios por vivero**, **incorporar plantines vivos** y **registrar inventario inicial**. Se relacionan con NEC-01–NEC-08 y con los contratos T2–T5. RF-VIV-15 exige vivero, especie activa, cantidad viva, fecha, procedencia, responsable y al menos una foto privada; tercero y referencia documental son opcionales y las observaciones dependen de la procedencia. Las diferencias sobre etapa y variedad mantienen revisión pendiente.

Los criterios de integridad se desarrollan en 3.2.9. Los límites académicos se mantienen: el resultado evaluable termina en la plantación y su trazabilidad. Las vistas de Impacto y Mis registros sitúan las audiencias de consulta; no acreditan una consulta pública integral de todos los módulos. Mantenimiento posterior, carbono y blockchain quedan fuera del cumplimiento académico.

### 3.2.4. Realización de casos de uso: vista general

La Figura 3.5 de Inicio conserva la vista general UML actualizada en `445f24f`. La Figura 3.8 desarrolla su distribución funcional, incorporando los permisos contextuales, la consulta propia y las capacidades de Vivero. Una asociación señala interacción y no concede por sí sola autoridad. Una persona puede desempeñar varias funciones sin tener varios roles globales.

**Figura 3.8. Actores y capacidades del diseño integrado**

<!-- diagrama: 03_2_fase_elaboracion-03 -->
```mermaid
flowchart TB
    ADM["ADMIN global"]
    REC["Operador de Recolección"]
    REV["Revisor de Recolección"]
    VIV["Operario de Vivero"]
    COO["Coordinador de Plantación"]
    PLA["Plantador autorizado"]
    ASC["Administrador de subcampaña"]
    PUB["Persona consultante"]
    PRO["Autor o participante autenticado"]
    CON["Persona autorizada<br/>para consulta operativa"]

    subgraph SYS["R3Foresta · límite del sistema"]
        C1(["CU-01<br/>Administrar datos maestros"])
        UR(["Administrar usuarios<br/>y roles globales"])
        AV(["Asignar operarios<br/>a viveros"])

        C2(["CU-02<br/>Registrar y completar recolección"])
        C3(["CU-03<br/>Revisar recolección"])
        C4(["CU-04<br/>Afectar saldo de Recolección"])

        C5(["CU-05<br/>Iniciar lote desde Recolección"])
        C6(["CU-06<br/>Registrar resultado observado"])
        C7(["CU-07<br/>Registrar movimientos de Vivero"])
        INC(["Incorporar plantines<br/>e inventario inicial"])

        C8(["CU-08<br/>Planificar campaña y subcampaña"])
        C9(["CU-09<br/>Asignar plantas a subcampaña"])
        C10(["CU-10<br/>Devolver plantas"])
        C11(["CU-11<br/>Registrar plantación inicial"])

        ACC(["Gestionar permisos<br/>por subcampaña"])
        C12(["CU-12<br/>Reconstruir recorrido autorizado"])
        IMP(["Consultar Impacto público"])
        BAN(["RF-REC-06<br/>Consultar banco público de semillas"])
        MIS(["Consultar Mis registros"])
    end

    ADM --- C1
    ADM --- UR
    ADM --- AV
    ADM --- C2
    ADM --- C3
    ADM --- C4
    ADM --- C5
    ADM --- C6
    ADM --- C7
    ADM --- INC
    ADM --- C8
    ADM --- C9
    ADM --- C10
    ADM --- C11
    ADM --- ACC
    ADM --- C12

    REC --- C2
    REC --- C4
    REV --- C3
    VIV --- C5
    VIV --- C6
    VIV --- C7
    COO --- C9
    COO --- C10
    PLA --- C11
    ASC --- C11
    ASC --- ACC
    PUB --- IMP
    PUB --- BAN
    PRO --- MIS
    CON --- C12

    %% Orden visual; estos enlaces invisibles no son relaciones del dominio.
    C1 ~~~ UR ~~~ AV ~~~ C2 ~~~ C3 ~~~ C4 ~~~ C5 ~~~ C6 ~~~ C7 ~~~ INC ~~~ C8 ~~~ C9 ~~~ C10 ~~~ C11 ~~~ ACC ~~~ C12 ~~~ IMP ~~~ MIS
```

*Nota.* Adaptación de los diagramas revisados el 4 de noviembre y de la Figura 3.5 vigente. CU-01–CU-12 mantienen sus IDs. Las incorporaciones y el acceso por vivero se interpretan con el alcance acreditado por sus entregas; la gestión de permisos y las consultas conservan los contratos PA-S02/03. En cada operación se comprueban cuenta, ámbito, estado y reglas del dominio.

### 3.2.5. Realización de casos de uso específicos y relaciones incluidas o extendidas

Las asociaciones actor–caso se dibujan sin dirección. «include» apunta del caso base al comportamiento obligatorio reutilizado; «extend» apunta del comportamiento opcional al caso base e indica su condición. Los resultados excluyentes de revisión se explican en el proceso, sin convertir una elección en una extensión obligatoria.

**Figura 3.9. Casos de uso específicos de Recolección**

<!-- diagrama: 03_2_fase_elaboracion-04 -->
```mermaid
flowchart TB
    %%{init: {"flowchart": {"rankSpacing": 160}}}%%
    OP["Operador de Recolección"]
    RV["VALIDADOR o ADMIN"]
    AD["ADMIN"]
    VIS["Visitante sin cuenta"]

    subgraph M1["M1 · Recolección"]
        CRE(["Crear recolección"])
        EDI(["Editar ficha permitida"])
        DAT(["Registrar especie, material,<br/>cantidad, unidad y ubicación"])
        ENV(["Solicitar validación"])
        VAL(["Comprobar ficha y evidencia"])
        REV(["Revisar recolección"])
        APR(["Recibir, validar y congelar identidad"])
        REJ(["Rechazar con motivo"])
        COR(["Corregir rechazo y reenviar"])
        DEL(["Eliminar lógicamente<br/>un BORRADOR"])
        DES(["Registrar DESECHO"])
        SAL(["Validar estado,<br/>unidad y saldo"])
        HIS(["Registrar historial"])
        CONH(["Consultar historial autorizado"])
        ESP(["Consultar historial administrativo<br/>por especie"])
        BAN(["RF-REC-06<br/>Consultar banco público de semillas"])
    end

    OP --- CRE
    OP --- EDI
    OP --- ENV
    OP --- COR
    OP --- DEL
    OP --- DES
    OP --- CONH

    AD --- CRE
    AD --- EDI
    AD --- DEL
    AD --- DES
    AD --- ESP

    VIS --- BAN

    RV --- REV
    RV --- APR
    RV --- REJ

    CRE -.->|"«include»"| DAT
    ENV -.->|"«include»"| VAL
    COR -.->|"«include»"| VAL
    REV -.->|"«include»"| VAL
    REJ -.->|"«include»"| HIS
    APR -.->|"«include»"| HIS
    DEL -.->|"«include»"| HIS
    DES -.->|"«include»"| SAL
    DES -.->|"«include»"| HIS

    %% Orden visual; estos enlaces invisibles no son relaciones del dominio.
    CRE ~~~ EDI ~~~ ENV ~~~ COR ~~~ REV ~~~ APR ~~~ REJ ~~~ DEL ~~~ DES ~~~ CONH ~~~ ESP
```

*Nota.* Adaptación de RF-REC-01–RF-REC-06. La consulta pública admite los cuatro estados y fotografías sanitizadas solo de VALIDADO; aplica su proyección y distingue fallo de vacío. La eliminación lógica se limita a BORRADOR y conserva historial; aprobar o rechazar no habilita a editar un registro validado. La inclusión de «Registrar historial» representa escritura del hecho, no una consulta que el usuario deba abrir.

**Figura 3.10. Casos de uso específicos de Vivero**

<!-- diagrama: 03_2_fase_elaboracion-05 -->
```mermaid
flowchart TB
    %%{init: {"flowchart": {"rankSpacing": 160}}}%%
    OP["Operario de Vivero<br/>operación autorizada"]
    AD["ADMIN global"]

    subgraph M2["M2 · Vivero"]
        SEM(["Consultar semillas elegibles<br/>del vivero"])
        INI(["Iniciar lote desde Recolección"])
        CON(["Consumir origen y crear INICIO<br/>en una transacción"])

        INC(["Incorporar plantines"])
        INV(["Registrar inventario inicial"])
        ID(["Identificar especie, procedencia,<br/>fecha, cantidad y foto privada"])
        BASE(["Crear lote, saldo vivo<br/>e historial de incorporación"])
        DOC(["Adjuntar comprobante<br/>o nota opcional"])

        EMB(["Registrar EMBOLSADO"])
        PRE(["Registrar descarte<br/>pre-embolsado"])
        ADA(["Registrar ADAPTABILIDAD"])
        MER(["Registrar MERMA"])
        DES(["Registrar despacho manual"])
        SAL(["Validar saldo físico<br/>y condiciones del lote"])
        EVI(["Vincular evidencia operativa"])
        HIS(["Consultar lote e historial"])
    end

    OP --- SEM
    OP --- INI
    OP --- EMB
    OP --- PRE
    OP --- ADA
    OP --- MER
    OP --- DES
    OP --- HIS

    AD --- INI
    AD --- INC
    AD --- INV
    AD --- EMB
    AD --- PRE
    AD --- ADA
    AD --- MER
    AD --- DES
    AD --- HIS

    INI -.->|"«include»"| SEM
    INI -.->|"«include»"| CON
    INI -.->|"«include»"| EVI

    INC -.->|"«include»"| ID
    INV -.->|"«include»"| ID
    INC -.->|"«include»"| BASE
    INV -.->|"«include»"| BASE
    INC -.->|"«include»"| EVI
    INV -.->|"«include»"| EVI

    DOC -.->|"«extend»<br/>si se aporta respaldo adicional"| INC
    DOC -.->|"«extend»<br/>si se aporta respaldo adicional"| INV

    EMB -.->|"«include»"| EVI
    PRE -.->|"«include»"| EVI
    MER -.->|"«include»"| SAL
    MER -.->|"«include»"| EVI
    DES -.->|"«include»"| SAL
    DES -.->|"«include»"| EVI

    %% Orden visual; estos enlaces invisibles no son relaciones del dominio.
    SEM ~~~ INI ~~~ INC ~~~ INV ~~~ DOC ~~~ EMB ~~~ PRE ~~~ ADA ~~~ MER ~~~ DES ~~~ HIS
```

*Nota.* Adaptación de RF-VIV-15 y de los acuerdos refinados el 16 de noviembre. Incorporación e inventario inicial exigen foto privada y están reservados a ADMIN. La recepción de semillas exige ADMIN o VALIDADOR asignado, distinto del recolector; el manejo ordinario sigue la autoridad M2. No se añade un embolsado o aptitud ficticios para plantas ya vivas.

**Figura 3.11. Casos de uso específicos de Plantación**

<!-- diagrama: 03_2_fase_elaboracion-06 -->
```mermaid
flowchart TB
    %%{init: {"flowchart": {"rankSpacing": 160}}}%%
    AD["ADMIN global"]
    CO["Coordinador logístico autorizado"]
    PL["PLANTADOR"]
    AS["ADMINISTRADOR_SUBCAMPANIA"]
    VI["Visitante"]
    AU["Autor o participante autenticado"]

    subgraph M3["M3 · Plantación"]
        PLAN(["Crear campaña y planificar subcampaña"])
        ACT(["Activar subcampaña"])
        META(["Validar zona, coordinador,<br/>polígono y plan por especie"])
        ENT(["Asignar plantas físicamente"])
        DEV(["Registrar devolución física"])
        FIS(["Validar autoridad logística<br/>y saldo disponible"])

        REG(["Registrar plantación inicial"])
        CTX(["Revalidar autoridad, ACTIVA,<br/>plan, fecha y stock"])
        GEO(["Registrar GPS y evaluar<br/>relación con polígono"])
        FOT(["Vincular fotografías"])
        LIFO(["Consumir asignaciones elegibles<br/>y guardar detalles"])
        COL(["Añadir colaboradores opcionales"])

        EQU(["Consultar equipo"])
        GP(["Gestionar plantadores"])
        GA(["Gestionar administradores contextuales"])
        CIE(["Cerrar subcampaña"])
        PUB(["Consultar Impacto público"])
        PRO(["Consultar registro propio"])
    end

    AD --- PLAN
    AD --- ACT
    AD --- ENT
    AD --- DEV
    AD --- REG
    AD --- GP
    AD --- GA
    AD --- CIE
    CO --- ENT
    CO --- DEV

    PL --- REG
    PL --- EQU
    AS --- REG
    AS --- EQU
    AS --- GP
    VI --- PUB
    AU --- PRO

    ACT -.->|"«include»"| META
    ENT -.->|"«include»"| FIS
    DEV -.->|"«include»"| FIS
    REG -.->|"«include»"| CTX
    REG -.->|"«include»"| GEO
    REG -.->|"«include»"| FOT
    REG -.->|"«include»"| LIFO
    COL -.->|"«extend»<br/>si participan otras personas"| REG

    %% Orden visual; estos enlaces invisibles no son relaciones del dominio.
    PLAN ~~~ ACT ~~~ CIE ~~~ ENT ~~~ DEV ~~~ REG ~~~ COL ~~~ EQU ~~~ GP ~~~ GA ~~~ PUB ~~~ PRO
```

*Nota.* Adaptación de RF-PLA, PA-S01–PA-S03 y D01–D12. PLANTADOR y ADMINISTRADOR_SUBCAMPANIA son permisos por persona y ámbito; COORDINADOR es una responsabilidad logística. Entrega y devolución requieren ADMIN o coordinación con autoridad M2 sobre el vivero; T2 verificó localmente esta intersección, con límites de corte y entorno. El punto exterior se admite con evaluación y advertencia según el acuerdo vigente; el fallo técnico del evaluador impide confirmar el registro.

### 3.2.6. Procesos: estados, eventos y cambios de cantidad

El estado actual facilita la operación; los movimientos, eventos e historiales explican cómo se obtuvo. Ambos deben actualizarse en una misma transacción cuando representan una sola operación. Una corrección excepcional conserva el original y su historial conforme a PA-S04; no habilita edición libre del pasado ni resuelve los casos de esa spec que siguen pendientes.

En Recolección se separan la calidad de la ficha y la disponibilidad del saldo. Validar congela la identidad, mientras el consumo posterior modifica cantidad e historial.

**Figura 3.12. Estados de Recolección y saldo operativo**

<!-- diagrama: 03_2_fase_elaboracion-07 -->
```mermaid
stateDiagram-v2
    direction TB
  [*] --> BORRADOR
  BORRADOR --> PENDIENTE_VALIDACION: enviar o reenviar para validación
  PENDIENTE_VALIDACION --> VALIDADO: recibir, validar y congelar snapshots
  PENDIENTE_VALIDACION --> RECHAZADO: rechazar
  RECHAZADO --> BORRADOR: guardar corrección
  VALIDADO --> VALIDADO: consumo a Vivero o desecho
  state "Saldo operativo" as SALDO {
    [*] --> ABIERTO
    ABIERTO --> CERRADO: saldo igual a cero
  }
```

*Nota.* Elaboración propia a partir de RF-REC y RN-REC. ABIERTO/CERRADO describen el saldo operativo y no reemplazan el estado de revisión. El borrado lógico de un borrador tampoco se representa como desaparición de su historial.

En la ruta de propagación, INICIO conserva material y unidad de origen; EMBOLSADO crea el saldo vivo observado. En la incorporación de plantas vivas, la recepción o conteo de plantines constituye la única base inicial del saldo. Registrar plantas vivas no requiere reconstruir una germinación previa.

**Figura 3.13. Bases iniciales y movimientos del lote de vivero**

<!-- diagrama: 03_2_fase_elaboracion-08 -->
```mermaid
flowchart TB
    I["INICIO desde Recolección<br/>material en proceso, saldo vivo nulo"] --> R{"¿Se observan plantas vivas?"}
    R -->|"Sí"| E["EMBOLSADO<br/>base viva observada"]
    R -->|"No, se descarta"| D["DESCARTE_PRE_EMBOLSADO<br/>cierre con causa y evidencia"]
    IN["Incorporación de plantines<br/>o inventario inicial por ADMIN"] --> B["Base viva contada y procedencia<br/>foto privada y resultado recuperable"]
    E --> L["Lote con plantas vivas"]
    B --> L
    L --> A["Adaptabilidad<br/>no crea otra base de saldo"]
    L --> M["Merma física en vivero"]
    L --> S["Despacho manual o entrega física"]
    S --> DEV["Devolución real desde subcampaña"]
    DEV --> L
    M --> C["Recalcular saldo y condición de cierre"]
    S --> C
```

*Nota.* Adaptación del flujo de Vivero y de los acuerdos de incorporación. Una salida total no es mortalidad. La devolución puede aumentar el saldo del lote de origen según el contrato; no vuelve a crear su base inicial. T5 contempla INCORPORACION como base alternativa; la cobertura y la aceptación dependen de las pruebas y el entorno documentados.

La campaña conserva un estado derivado; la subcampaña concentra plan, polígono, coordinación y operación. Alcanzar la meta no cierra automáticamente ni impide registrar una cantidad superior dentro del stock elegible.

**Figura 3.14. Estados operativos de la subcampaña pertinentes al recorrido**

<!-- diagrama: 03_2_fase_elaboracion-09 -->
```mermaid
stateDiagram-v2
    direction TB
    [*] --> BORRADOR
    BORRADOR --> ACTIVA: ADMIN activa con plan, coordinación y polígono
    BORRADOR --> CANCELADA: ADMIN cancela sin plantaciones
    ACTIVA --> ACTIVA: registro inicial, incluso al superar meta
    ACTIVA --> CANCELADA: ADMIN cancela sin plantaciones
    ACTIVA --> COMPLETADA: cierre manual por ADMIN
    ACTIVA --> FINALIZADA_PARCIAL: cierre manual por ADMIN con motivo
    COMPLETADA --> [*]
    FINALIZADA_PARCIAL --> [*]
    CANCELADA --> [*]
```

*Nota.* Elaboración propia a partir de RN-PLA-06/07/10/37, ADR-PLA-04 y PA-S01. No hay reapertura, tampoco por ADMIN. El cierre no representa devolución automática de todo remanente: el contrato vigente conserva stock sobrante y sus operaciones permitidas. La recepción externa directa exige desarrollar su tratamiento sin sustituir silenciosamente estas reglas.

#### 3.2.6.1. Diagramas de actividad de los flujos operativos

**Figura 3.15. Actividad de Recolección**

<!-- diagrama: 03_2_fase_elaboracion-10 -->
```mermaid
flowchart TB
  I([Inicio]) --> B[Crear recolección en BORRADOR]
  B --> D[Registrar especie, material, cantidad,<br/>unidad, fecha, responsable y ubicación]
  D --> E[Adjuntar evidencia requerida]
  E --> S[Solicitar validación]
  S --> C{¿Ficha completa y<br/>evidencia suficiente?}
  C -- No --> R[Rechazar con observaciones]
  R --> D
  C -- Sí --> V[Recibir y validar por revisor autorizado<br/>distinto del recolector; congelar snapshots]
  V --> O{¿Destino del saldo?}
  O -- Vivero --> T[Consumir cantidad mediante<br/>contrato M1→M2]
  O -- Desecho --> X[Registrar movimiento de desecho]
  T --> Z{¿Saldo igual a cero?}
  X --> Z
  Z -- No --> O
  Z -- Sí --> F([Cerrar saldo del lote])
```

*Nota.* Elaboración propia a partir de RF-REC-01–RF-REC-05 y M1→M2. El consumo se ejecuta al iniciar Vivero; no se añade una segunda operación manual que descuente el mismo material.

**Figura 3.16. Actividad de Vivero por modalidad de ingreso**

<!-- diagrama: 03_2_fase_elaboracion-11 -->
```mermaid
flowchart TB
    I(["Inicio"]) --> MOD{"Modalidad de ingreso"}
    MOD -->|"Desde Recolección"| O["Consultar origen validado, unidad y saldo<br/>con autorización vigente"]
    O --> T["Crear lote, INICIO y consumo<br/>en una transacción"]
    T --> P["Observar resultado de propagación"]
    P --> R{"¿Hay plantas vivas?"}
    R -->|"Sí"| E["Registrar EMBOLSADO observado"]
    R -->|"No, se descarta"| X["Registrar descarte, causa y evidencia"]
    MOD -->|"Plantines o existencias previas"| AD["ADMIN registra especie, procedencia,<br/>fecha, cantidad y foto privada"]
    AD --> N["Crear base inicial una sola vez<br/>sin consumo M1 ni embolsado ficticio"]
    E --> SAL["Consultar saldo físico e historial"]
    N --> SAL
    SAL --> OP["Registrar manejo, merma, despacho<br/>o entrega según autorización y saldo"]
    OP --> SAL
    OP --> FIN(["Fin de la operación"])
    X --> FIN
```

*Nota.* Adaptación del diseño integrado y RF-VIV-15. La incorporación T5 cuenta con pruebas por tramos y conserva pendiente la evaluación integrada y su aceptación. No se infieren pérdidas históricas ni conversiones de gramos a plantas.

**Figura 3.17. Actividad de Plantación y recuperación del resultado**

<!-- diagrama: 03_2_fase_elaboracion-12 -->
```mermaid
flowchart TB
    I(["Inicio"]) --> C["Consultar capacidades, subcampaña ACTIVA,<br/>plan y stock elegible por especie"]
    C --> F["Capturar 1–10 fotos y coordenada válida<br/>GPS o entrada manual; confirmar ubicación"]
    F --> Q["Indicar cantidades, fecha y observaciones<br/>meta orientativa; stock limita"]
    Q --> P["Añadir participantes habilitados opcionales<br/>y revisar resumen"]
    P --> K["Confirmar con identidad del mismo intento"]
    K --> V{"Validación transaccional"}
    V -->|"Cuenta, permiso, plan, stock<br/>o datos no válidos"| R["Rechazo confirmado sin efecto<br/>revisar captura permitida"]
    V -->|"Evaluador espacial falla"| R
    V -->|"Coordenada evaluada<br/>interior o exterior advertido"| T["Consumir LIFO y guardar registro,<br/>detalles, participantes, evidencia y recibo"]
    T --> RESP{"¿Respuesta conocida?"}
    RESP -->|"Sí"| OK["Abrir el mismo comprobante"]
    RESP -->|"No"| U["Resultado pendiente de confirmar"]
    U --> REC["Recuperar con misma clave y contenido"]
    REC --> TERM{"¿Hay resultado terminal?"}
    TERM -->|"Confirmado"| OK
    TERM -->|"Rechazado"| R
    TERM -->|"Aún inconcluso"| U
    OK --> FIN(["Fin"])
```

*Nota.* Elaboración propia a partir de PA-S01, sus escenarios CA01–CA14 y D07–D09. Abrir el formulario no reserva stock ni autoridad; ambos se revalidan al guardar. Un timeout también puede ocurrir antes de conocerse la ejecución y sigue el mismo camino de recuperación. El punto exterior evaluado no se confunde con fallo del evaluador. Las cantidades pertenecen al registro, no se multiplican por participantes.

### 3.2.7. Interacciones: contratos entre módulos

#### 3.2.7.1. Contrato entre Recolección y Vivero

El contrato M1→M2 se activa cuando Vivero inicia un lote desde una recolección validada, abierta y con saldo suficiente. El lote de Vivero selecciona su vivero operativo, hereda los snapshots oficiales de la recolección y registra evidencia propia del evento `INICIO`. Un origen puede abastecer varios lotes, pero cada lote de vivero conserva una sola recolección de procedencia.

La creación del lote, el evento `INICIO` y el movimiento `CONSUMO_A_VIVERO` forman una sola operación de negocio. El diseño exige que se completen juntos o que ninguno quede persistido. Además, mantiene las siguientes igualdades dentro de la unidad canónica de la recolección:

```text
abs(delta del movimiento CONSUMO_A_VIVERO)
= cantidad_inicial_en_proceso del lote de vivero
= cantidad_afectada del evento INICIO

unidad del movimiento
= unidad inicial del lote
= unidad del evento INICIO
```

**Figura 3.18. Secuencia diseñada para el contrato M1→M2**

<!-- diagrama: 03_2_fase_elaboracion-13 -->
```mermaid
sequenceDiagram
  actor U as Operario autorizado o ADMIN
  participant A as API
  participant B as PostgreSQL
  participant R as Recolección
  participant V as Vivero
  U->>A: iniciar lote con origen, cantidad y evidencia
  A->>B: ejecutar operación atómica
  B->>R: bloquear y validar estado, unidad y saldo
  B->>R: insertar CONSUMO_A_VIVERO
  B->>V: crear lote y evento INICIO
  B->>V: vincular snapshots y evidencia
  alt todas las condiciones se cumplen
    B-->>A: confirmar lote y saldo resultante
    A-->>U: mostrar operación registrada
  else falla una condición o escritura
    B-->>A: revertir todos los efectos
    A-->>U: informar rechazo sin cambios parciales
  end
```

*Nota.* Elaboración propia a partir de `01_contrato_recoleccion_a_vivero.md`, `RN-REC-23` y `RN-REC-24A`.

El contrato no convierte gramos de semillas en unidades de plantas. La cantidad transferida en `INICIO` conserva la unidad del origen. El dato de plantas vivas aparece después, cuando el responsable registra el resultado observado en `EMBOLSADO`.

El contrato vigente exige recepción conforme y restringe el camino ordinario al vivero de almacenamiento con autorización vigente. ADMIN puede seleccionar explícitamente un destino distinto. T2 verificó localmente esta frontera; sus límites de catálogo, corte y entorno se conservan en [ESTADO](../../../ESTADO.md).

#### 3.2.7.2. Contrato entre Vivero y Plantación

Asignar representa entrega física: disminuye el saldo del lote y crea stock de subcampaña. Plantar consume ese stock, sin una segunda salida de Vivero. La cantidad asignada es inmutable y el disponible se obtiene de sus afectaciones:

```text
saldo_asignado_disponible
= cantidad_asignada - cantidad_consumida - cantidad_devuelta - cantidad_mermada
```

El registro inicial utiliza cantidades por especie y distribución LIFO en servidor (`fecha_asignacion DESC, id DESC`) entre asignaciones elegibles. La fecha operativa excluye entregas posteriores al hecho registrado; no basta que el stock exista hoy. Los locks siguen su orden común independiente del orden de reparto. La persona no elige un lote ni recibe stock personal. Meta orientativa y saldo físico tienen funciones distintas.

**Figura 3.19. Entrega física, consumo de stock y resultado recuperable**

<!-- diagrama: 03_2_fase_elaboracion-14 -->
```mermaid
sequenceDiagram
    actor C as ADMIN o coordinación autorizada
    actor P as Persona autorizada para plantar
    participant UI as PWA
    participant API as API NestJS
    participant DB as PostgreSQL y PostGIS
    participant ST as Storage

    C->>API: Asignar plantas de un lote a subcampaña
    API->>DB: Revalidar autoridad, ACTIVA y saldo físico
    DB->>DB: Descontar lote, crear asignación y salida enlazada
    DB-->>API: Entrega confirmada en una transacción
    API-->>C: Resultado de la entrega

    P->>UI: Preparar registro inicial
    UI->>API: Consultar contexto autorizado y preparar comando
    API->>DB: Leer plan, revisión, fecha y stock elegible
    DB-->>API: Cantidades disponibles por especie
    API-->>UI: Contexto autorizado
    UI->>API: Enviar fotografías del mismo comando
    API->>ST: Preparar originales y derivadas privadas
    API->>DB: Registrar cargas y generaciones disponibles
    P->>UI: Confirmar ubicación, fecha, cantidades y participantes
    UI->>API: Enviar identidad y contenido del intento
    API->>DB: Ejecutar comando del actor
    alt Ya existe resultado terminal
        DB-->>API: Recuperar el mismo recibo
    else Nueva intención por validar
        DB->>DB: Revalidar autoridad, ACTIVA, plan, fotos y geografía
        DB->>DB: Bloquear stock elegible y consumir LIFO
        DB->>DB: Guardar registro, detalles, snapshots y vínculos de evidencia
        DB->>DB: Guardar resultado terminal en la misma transacción
        DB-->>API: Confirmación o rechazo durable
    end
    Note over API,DB: Plantar no vuelve a disminuir el lote de Vivero
    API-->>UI: Resultado del intento
    opt Respuesta perdida o inconclusa
        UI->>API: Recuperar mismo actor, operación y UUID
        API->>DB: Consultar recibo sin repetir efectos
        DB-->>API: Resultado terminal o todavía inconcluso
        API-->>UI: Resultado de recuperación
    end
    opt Devolución física de remanente de Vivero
        C->>API: Devolver cantidad y motivo al lote de origen
        API->>DB: Validar disponible, aumentar devuelta y reponer lote
        DB-->>API: Devolución y eventos confirmados juntos
        API-->>C: Resultado de la devolución
    end
```

*Nota.* Adaptación de los diagramas actualizados a M2→M3 y D01–D12. Storage se prepara antes de la confirmación; la transacción SQL vincula cargas válidas y resultado, sin simular una transacción distribuida con el almacenamiento. La idempotencia corresponde a una intención, no detecta por sí sola que dos personas registraron el mismo trabajo real. El contrato M2→M3 exige ADMIN o la intersección de acceso operativo al vivero y coordinación de la subcampaña para la entrega o devolución explícita. T2 acredita implementación local; cotejo, corte y despliegue conservan sus verificaciones por entorno.

#### 3.2.7.3. Incorporación de plantines y continuidad operativa

RF-VIV-15 registra modalidad, procedencia disponible, especie, cantidad viva, fecha, responsable y foto privada; la diferencia de etapa y variedad frente al diseño previo permanece en revisión. Debe confirmar juntos el lote, la base inicial, los snapshots, los vínculos de evidencia exigibles y un resultado recuperable. No consume Recolección ni utiliza EMBOLSADO para eludir la exigencia de un origen. Un segundo embolsado no puede recrear las plantas incorporadas.

El diseño requiere revisar las dependencias que hoy presuponen Recolección y EMBOLSADO: nulabilidad y campos de material en proceso, código trazable, enum de eventos, unicidad de base inicial, constraints de aumento de saldo, adaptabilidad, merma, despacho, asignación, lecturas y timeline. Cambiar solo el formulario de alta no daría continuidad al recorrido. Las propuestas técnicas se consultan desde 3.2.13; sus alternativas anteriores de aptitud y cierre de remanentes no sustituyen las reglas aceptadas.

La recepción directa debe crear stock en su lugar real de custodia y conservar la procedencia al consumirlo. Su relación con el lote, las devoluciones a un vivero que efectivamente recibe y el destino de los remanentes permanecen por concretar. No se adopta por esta redacción un bloqueo nuevo del cierre de subcampaña.

### 3.2.8. Modelo de datos: conceptual, lógico, físico y diccionario

Las tres vistas cumplen funciones diferentes. La conceptual expresa los conceptos del negocio; la lógica organiza relaciones e integridad del diseño integrado; la física conserva los objetos que aparecen en la exportación y las fuentes de relaciones. No se agregan al catálogo físico entidades nuevas por el hecho de necesitarlas en el diseño.

#### 3.2.8.1. Modelo conceptual

La siguiente [vista vertical resumida](figuras/modelos-datos/modelo-conceptual.svg) presenta los conceptos principales del recorrido; la Figura 3.20 desarrolla actores, permisos y evidencias. Su [fuente editable](figuras/modelos-datos/modelo-conceptual.mmd) conserva las relaciones representadas.

![Modelo conceptual vertical del recorrido](figuras/modelos-datos/modelo-conceptual.svg)

**Figura 3.20. Modelo conceptual del recorrido y sus modalidades de origen**

<!-- diagrama: 03_2_fase_elaboracion-15 -->
```mermaid
classDiagram
    direction TB

    class Persona
    class RolGlobal
    class AccesoVivero
    class PermisoSubcampania
    class ResponsabilidadLogistica
    class Vivero
    class Campania
    class Subcampania
    class Especie
    class Recoleccion
    class Lote
    class LoteDesdeRecoleccion
    class LoteIncorporado
    class Incorporacion
    class EventoLote
    class Asignacion
    class Plantacion
    class DetalleConsumo
    class ParticipacionHistorica
    class Evidencia

    Persona "0..*" --> "1" RolGlobal : tiene
    Persona "1" -- "0..*" AccesoVivero : recibe
    Vivero "1" -- "0..*" AccesoVivero : delimita
    Persona "1" -- "0..*" PermisoSubcampania : recibe
    Subcampania "1" -- "0..*" PermisoSubcampania : delimita
    Persona "1" -- "0..*" ResponsabilidadLogistica : asume
    Subcampania "1" -- "0..*" ResponsabilidadLogistica : organiza

    Campania "1" -- "0..*" Subcampania : agrupa

    Lote <|-- LoteDesdeRecoleccion
    Lote <|-- LoteIncorporado
    Recoleccion "1" -- "0..*" LoteDesdeRecoleccion : origina
    Incorporacion "1" -- "1" LoteIncorporado : inicia
    Especie "1" -- "0..*" Lote : identifica
    Lote "1" -- "0..*" EventoLote : historiza

    Lote "1" -- "0..*" Asignacion : abastece
    Subcampania "1" -- "0..*" Asignacion : recibe
    Subcampania "1" -- "0..*" Plantacion : contiene
    Plantacion "1" -- "1..*" DetalleConsumo : desglosa
    Asignacion "1" -- "0..*" DetalleConsumo : consume
    Plantacion "1" -- "0..*" ParticipacionHistorica : conserva
    Persona "1" -- "0..*" ParticipacionHistorica : participa

    EventoLote "0..1" -- "0..*" Evidencia : documenta
    Plantacion "0..1" -- "1..*" Evidencia : documenta

    note for Lote "Una especie y un origen homogéneo. Identidad histórica conservada."
    note for Incorporacion "Recepción o inventario inicial; procedencia y foto del ingreso."
    note for Evidencia "Cada evidencia pertenece a un solo hecho según su tipo. Evento y plantación son vínculos excluyentes."
```

*Nota.* Adaptación del modelo conceptual actualizado el 4 de noviembre. Las especializaciones de Lote no exigen dos tablas ni dos motores de consumo. AccesoVivero e Incorporacion representan capacidades con implementación local y límites documentados; la custodia directa en campo requiere concretar su relación con el lote. Un mismo usuario puede asumir funciones diferentes, manteniendo una identidad.

#### 3.2.8.2. Modelo lógico

La [vista vertical resumida](figuras/modelos-datos/modelo-logico.svg) destaca relaciones y cardinalidades del recorrido. Las dos relaciones opcionales de origen se interpretan conjuntamente: cada lote tiene exactamente un origen. La [fuente editable](figuras/modelos-datos/modelo-logico.mmd) y la Figura 3.21 completan esta vista.

![Modelo lógico vertical del recorrido](figuras/modelos-datos/modelo-logico.svg)

**Figura 3.21. Relaciones lógicas del diseño integrado**

<!-- diagrama: 03_2_fase_elaboracion-16 -->
```mermaid
erDiagram
    direction TB
    USUARIO ||--o{ ACCESO_VIVERO : recibe
    VIVERO ||--o{ ACCESO_VIVERO : delimita
    USUARIO ||--o{ PERMISO_SUBCAMPANIA : recibe
    SUBCAMPANIA ||--o{ PERMISO_SUBCAMPANIA : delimita
    USUARIO ||--o{ EQUIPO_SUBCAMPANIA : integra
    SUBCAMPANIA ||--o{ EQUIPO_SUBCAMPANIA : organiza

    CAMPANIA ||--o{ SUBCAMPANIA : contiene
    SUBCAMPANIA ||--o{ META_ESPECIE : planifica
    PLANTA ||--o{ META_ESPECIE : identifica

    RECOLECCION |o--o{ LOTE : origen_condicional
    INCORPORACION |o--|| LOTE : ingreso_alternativo
    PLANTA ||--o{ LOTE : especie
    VIVERO |o--o{ LOTE : custodia_fisica
    LOTE ||--o{ EVENTO_LOTE : historial

    LOTE ||--o{ ASIGNACION : abastece
    SUBCAMPANIA ||--o{ ASIGNACION : recibe
    SUBCAMPANIA ||--o{ PLANTACION : contiene
    PLANTACION ||--|{ DETALLE_CONSUMO : desglosa
    ASIGNACION ||--o{ DETALLE_CONSUMO : procedencia
    PLANTA ||--o{ DETALLE_CONSUMO : identifica

    USUARIO ||--o{ PLANTACION : responsable
    PLANTACION ||--o{ PARTICIPANTE : conserva
    USUARIO ||--o{ PARTICIPANTE : participa

    USUARIO ||--o{ OPERACION_RECUPERABLE : ejecuta
    OPERACION_RECUPERABLE ||--o{ CARGA_EVIDENCIA : prepara
    CARGA_EVIDENCIA }o--o| EVIDENCIA : vincula

    INCORPORACION {
        string modalidad
        string procedencia
        string referencia_procedencia
        date fecha_recepcion_o_conteo
        int cantidad_viva
        string identidad_vegetal_snapshot
        string responsable_snapshot
    }

    ACCESO_VIVERO {
        bigint usuario_id
        bigint vivero_id
        datetime otorgado_en
        datetime retirado_en
        bigint otorgado_por
    }
```

*Nota.* Adaptación del modelo lógico del chat de diagramas. ACCESO_VIVERO, INCORPORACION y LOTE son nombres de representación del diseño; no sustituyen los nombres físicos ni acreditan tablas nuevas. Las relaciones de procedencia se interpretan con la exclusión de origen indicada a continuación. La asociación polimórfica de evidencia se valida por tipo de hecho y no se convierte en varias FKs físicas desde entidad_id.

Cada lote utiliza exactamente una base de origen: una Recolección, con su consumo, o una incorporación de plantas vivas. Las referencias opcionales del diagrama no autorizan que falten ambas o existan ambas a la vez. Cada incorporación inicia un lote homogéneo y conserva la especie; fecha y cantidad corresponden al hecho observado. La variedad de incorporación mantiene su revisión pendiente. La custodia de Vivero solo puede omitirse en la variante directa cuando su contrato haya definido dónde se mantiene el stock.

La procedencia plantada se recupera por detalle→asignación→lote→origen. Los totales agregados no sustituyen esos enlaces. Retirar acceso o cambiar un catálogo no borra las autorías ni los snapshots anteriores. La revisión técnica de incorporación también exige cotejar la herencia de variedad y la lectura de responsables: un nombre actual del catálogo no debe presentarse como snapshot del hecho.

#### 3.2.8.3. Modelo físico y contraste con la base de datos documentada

El modelo físico se actualizó documentalmente el 16 de noviembre de 2026 con el esquema aportado por el autor y confirmado como última versión. Contiene 57 tablas y 622 columnas. Sus 175 relaciones comprenden 160 referencias simples y quince compuestas agrupadas por restricción y contrastadas con SQL local. La fuente preserva tipos declarados, nulabilidad, claves y restricciones visibles. El adjunto carece de identificador de proyecto y fecha de exportación. El corte anterior del 4 de noviembre y su consulta PostgREST conservan su procedencia histórica. El [modelo físico y sus fuentes](../../../database/00_database_schema.md) documentan ambos cortes. La reproducción integral y el catálogo remoto conservan los pendientes de RDI-03.

**Modelo físico vertical del recorrido registrado**

![Modelo físico vertical de diez tablas y sus relaciones seleccionadas](figuras/modelos-datos/modelo-fisico.svg)

La vista resume diez tablas, columnas y relaciones seleccionadas; su [fuente editable](figuras/modelos-datos/modelo-fisico.mmd) y el [detalle de alcance](figuras/modelos-datos/README.md) explican la selección. Las vistas completas de [núcleo](../../../database/diagramas/modelo-fisico-nucleo.svg) y [permisos, comandos y cargas](../../../database/diagramas/modelo-fisico-participacion.svg) se conservan como apoyo de consulta.

*Nota.* Elaboración propia a partir del extracto recibido el 16 de noviembre y del contraste local de claves compuestas identificado en el modelo físico. Las vistas completas de consulta conservan todas las columnas de sus tablas y relaciones con extremos incluidos; la vista vertical selecciona solo una parte. El completo contiene 57 tablas, incluida PostGIS. `USER_DEFINED` conserva el tipo sin resolver del adjunto. La presencia estructural de accesos, recepción, incorporación y correcciones mantiene su acreditación funcional y de entorno por separado.

**Tabla 3.18**

*Correspondencia del modelo físico con la exportación de Supabase*

| Componente físico documentado | Claves y campos de trazabilidad | Relación o restricción relevante | Estado del contraste |
|---|---|---|---|
| RECOLECCION | id; planta_id, ubicacion_id y vivero_id; cantidad_inicial_canonica, unidad_canonica, saldo_actual, snapshots, eliminación lógica y motivo_rechazo | conserva origen, estado, saldo y revision_captura; recepción guarda día físico, receptor e instante registrado | columnas del extracto recibido; replay y pruebas conservan su verificación propia |
| RECOLECCION_MOVIMIENTO | id; recoleccion_id, lote_vivero_id, tipo_movimiento, delta, unidad_medida_evento y unidad_operativa | la unidad física es unidad_medida_evento; lote_vivero_id existe como columna, pero el catálogo consultado no lo identifica como FK | columnas contrastadas; el enlace semántico con el lote no se dibuja como FK física |
| LOTE_VIVERO y EVENTO_LOTE_VIVERO | recoleccion_id, planta_id, vivero_id, saldo_vivo_actual; lote_id, tipo_evento, cantidad_afectada y saldos antes/después | recoleccion_id es nullable para incorporación y vivero_id permanece NN; el evento referencia el lote mediante lote_id | extracto recibido y contraste SQL local de relaciones documentados; integridad funcional conforme al contrato |
| CAMPANIA, SUBCAMPANIA, SUBCAMPANIA_META_ESPECIE y SUBCAMPANIA_EQUIPO | campania_id, zona_id, poligono_geom, meta_total_arboles, plan_revision y membresías | CAMPANIA no almacena estado; SUBCAMPANIA sí conserva estado y contadores; coordinación es una fila de equipo | estructura contrastada; no se confunden contadores materializados con valores derivados |
| ASIGNACION_VIVERO_SUBCAMPANIA | lote_vivero_id, subcampania_id, cantidades asignada, consumida, devuelta, mermada, saldo_asignado_disponible y fecha_entrega_operativa | representa la entrega física del lote; saldo disponible figura nullable en la exportación | columnas y referencias simples contrastadas; la fórmula y la atomicidad requieren su evidencia SQL y de pruebas |
| REGISTRO_PLANTACION y REGISTRO_PLANTACION_DETALLE | subcampania_id, responsable_id, latitud, longitud, cantidad_total_plantada y revision_registro; asignacion_id, lote_vivero_id, planta_id y cantidad | el detalle conserva asignación, lote, especie y snapshots; GPS pertenece al registro | columnas y referencias simples contrastadas; esto no acredita el comportamiento de la validación espacial |
| TIPOS_ENTIDAD_EVIDENCIA y EVIDENCIAS_TRAZABILIDAD | tipo_entidad_id, entidad_id, bucket, ruta_archivo y metadata | tipo_entidad_id tiene FK; entidad_id participa en un vínculo polimórfico | columnas contrastadas; no se inventan FKs a cada tabla operativa |
| USUARIO, SUBCAMPANIA_PERMISO y SUBCAMPANIA_PERMISO_REVISION | rol, activo, revision_autoridad, organizacion_id; persona, ámbito, vigencias y revisión del permiso | autorización contextual separada de SUBCAMPANIA_EQUIPO | presentes en la exportación; referencias compuestas identificadas con fuente SQL |
| PARTICIPACION_COMANDO, USUARIO_AUTORIDAD_HISTORIAL y tablas de cargas | actor, operación, UUID, resultado, auditoría, generaciones y referencias de evidencia | claves de operación y de generación pueden ser compuestas; no son UUID globalmente únicos por inferencia | presentes; columnas contrastadas y procedencia de relaciones documentada |
| Tablas de acceso M1/M2, recepción e incorporación | vigencias, revisiones, comandos, evidencia contextual, recepción inmutable y procedencia de plantas vivas | catorce tablas añadidas frente al corte del 4 de noviembre | presentes en el extracto recibido; la comparación de tablas mantiene pendiente catálogo remoto, RPC, RLS y Storage |
| Tablas de corrección, estado efectivo y compensaciones | original, revisiones, participantes efectivos, créditos y compensaciones | preservan estructuras del original y su interpretación efectiva | siete tablas presentes; no acredita ejecución completa de todos los casos de PA-S04 |

*Nota.* Elaboración propia a partir del esquema contextual confirmado como última versión por el autor el 16 de noviembre y [database/00_database_schema.md](../../../database/00_database_schema.md). El corte del 4 de noviembre conserva su catálogo histórico. El extracto actual incluye algunas expresiones CHECK, DEFAULT y generadas, y mantiene pendiente la inspección completa de restricciones, índices, triggers y políticas de seguridad. Durante la maquetación en carta vertical, dividir la tabla en bloques y repetir su encabezado si continúa en otra página.

#### 3.2.8.4. Diccionario de datos seleccionado

Este diccionario define campos físicos seleccionados que permiten interpretar origen, custodia, saldo, consumo y evidencia. Los nombres, tipos, nulabilidad y claves proceden del [SQL contextual recibido el 16 de noviembre de 2026](../../../database/fuentes/supabase-estructura-2026-11-16.sql); su significado se contrasta con los contratos [M1→M2](../../../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md) y [M2→M3](../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md), y con los requisitos de los módulos. Es una selección para el recorrido académico: el inventario completo conserva 57 tablas y 622 columnas en el [modelo físico y sus fuentes](../../../database/00_database_schema.md).

`NN` indica que el campo no admite nulos en el extracto; `NULL`, que los admite. `PK`, `FK` y `UK` identifican clave primaria, referencia explícita y unicidad individual, respectivamente. `USER-DEFINED` conserva el tipo no resuelto del adjunto, sin sustituirlo por un enum supuesto. Las reglas funcionales se distinguen de las restricciones físicas visibles.

| Tabla y campo | Significado en el recorrido | Tipo y nulabilidad | Clave o regla relevante |
|---|---|---|---|
| `recoleccion`<br>`codigo_trazabilidad` | Identidad legible del origen registrado. | `text`, NN | UK; se conserva al corregir y reenviar la misma ficha. |
| `recoleccion`<br>`unidad_canonica` | Unidad en la que se interpreta la cantidad y el saldo del origen. | `USER-DEFINED`, NN | El contrato utiliza G o UNIDAD; no permite convertir masa en plantas. |
| `recoleccion`<br>`saldo_actual` | Material de origen que queda disponible después de sus movimientos. | `numeric`, NN | CHECK ≥ 0; consumo y desecho requieren recepción conforme y autoridad. |
| `recoleccion_recepcion`<br>`fecha_recepcion` | Día del hecho físico de recepción conforme. | `date`, NN | No se confunde con `registrado_en`, sello temporal de persistencia. |
| `lote_vivero`<br>`recoleccion_id` | Origen del lote cuando nace por propagación. | `bigint`, NULL | FK a `recoleccion.id`; RF-VIV-15 reserva el nulo al camino incorporado. |
| `lote_vivero`<br>`saldo_vivo_actual` | Plantas vivas que permanecen físicamente en el vivero. | `integer`, NULL | CHECK nulo o ≥ 0; es nulo antes de la base viva y no incluye stock ya entregado. |
| `evento_lote_vivero`<br>`lote_id` | Lote cuyo hecho se registra en el historial. | `bigint`, NN | FK a `lote_vivero.id`; el evento conserva el hecho, no otro lote independiente. |
| `evento_lote_vivero`<br>`tipo_evento` | Naturaleza del hecho de origen, manejo o movimiento. | `USER-DEFINED`, NN | El contrato distingue INICIO, EMBOLSADO e INCORPORACION y sus efectos de saldo. |
| `vivero_incorporacion`<br>`evento_id` | Evento que documenta la base viva incorporada. | `bigint`, NN | PK y FK a `evento_lote_vivero.id`; extiende ese hecho con su procedencia. |
| `vivero_incorporacion`<br>`solicitud_id` | Identidad de la solicitud de incorporación recuperable. | `uuid`, NN | UK; repetir la intención propia confirmada recupera el resultado según RF-VIV-15. |
| `vivero_incorporacion`<br>`modalidad` | Distingue recepción de plantas e inventario contado al incorporarse. | `text`, NN | CHECK: RECEPCION o SALDO_INICIAL; no demuestra la crianza anterior. |
| `subcampania`<br>`campania_id` | Campaña que agrupa la operación y su plan. | `bigint`, NN | FK a `campania.id`; estado y meta de campaña se derivan, no se añaden aquí como hechos nuevos. |
| `subcampania`<br>`plan_revision` | Versión del plan utilizada para detectar revisiones concurrentes. | `bigint`, NN | CHECK ≥ 0; una revisión obsoleta requiere conciliación, conforme a ADR-PLA-05. |
| `asignacion_vivero_subcampania`<br>`cantidad_asignada` | Plantas entregadas físicamente desde un lote a una subcampaña. | `integer`, NN | CHECK > 0; RN-VIV-49 conserva inmutable la entrega original. |
| `asignacion_vivero_subcampania`<br>`saldo_asignado_disponible` | Remanente de la entrega aún disponible en campo. | `integer`, NULL | RF-VIV-13: asignada − consumida − devuelta − mermada; la exportación conserva su nulabilidad y expresión visible. |
| `registro_plantacion`<br>`cantidad_total_plantada` | Total efectivamente registrado en el hecho de plantación. | `integer`, NN | CHECK > 0; debe coincidir con la suma de sus detalles, sin multiplicarse por participantes. |
| `registro_plantacion_detalle`<br>`asignacion_id` | Entrega efectivamente consumida por una parte del registro. | `bigint`, NN | FK a `asignacion_vivero_subcampania.id`; permite reconstruir detalle → asignación → lote → origen. |
| `registro_plantacion_detalle`<br>`cantidad` | Plantas consumidas de esa procedencia dentro del registro. | `integer`, NN | CHECK > 0; su confirmación afecta stock de la asignación, sin segundo débito de Vivero. |
| `evidencias_trazabilidad`<br>`tipo_entidad_id` | Tipo del hecho al que pertenece el archivo. | `smallint`, NN | FK a `tipos_entidad_evidencia.id`; delimita la interpretación de `entidad_id`. |
| `evidencias_trazabilidad`<br>`entidad_id` | Identificador del hecho documentado por la evidencia. | `bigint`, NN | Vínculo polimórfico por tipo; el extracto no acredita una FK hacia cada tabla operativa. |

Este diccionario no pretende cubrir los 622 campos ni amplía la porción dibujada en el modelo físico resumido. Las restricciones, RPC, permisos, archivos y reglas necesitan sus comprobaciones propias; describir un campo no acredita implementación aceptada, aplicación SQL o despliegue. El adjunto conserva los límites de procedencia y contraste indicados en 3.2.8.3 y en RDI-03.

Las subsecciones 3.2.9 a 3.2.12 forman un bloque transversal de control del diseño. Explican las propiedades, la arquitectura, los riesgos y el resultado que condicionan los productos ya presentados; no añaden una etapa entre el modelo de datos y la implementación, que continúa en la sección 3.3.

### 3.2.9. Invariantes, mecanismos y pruebas previstas

Las propiedades se contrastan con mecanismos y escenarios observables. La existencia de una RPC o una tabla no equivale a una prueba aprobada. Los informes de [ESTADO](../../../ESTADO.md) y del [tablero PA-F01](../../../specs/plantacion/participacion-aliada/implementacion/README.md) conservan versión, entorno y límites de las comprobaciones ya realizadas; esta matriz define su correspondencia académica y lo que aún debe demostrarse.

**Tabla 3.19**

*Propiedades de diseño y criterio de comprobación*

| Código | Propiedad | Mecanismo o decisión de diseño | Comprobación requerida |
|---|---|---|---|
| INV-01 | saldo de Recolección no negativo | movimientos y operación transaccional | consumir/desechar el saldo exacto, excederlo y competir por el último saldo |
| INV-02 | M1→M2 conserva cantidad y unidad | igualdad movimiento–lote–INICIO | comparar las tres cantidades/unidades en consumos parciales y totales |
| INV-03 | no convertir masa a plantas ni inventar propagación | INICIO en unidad de origen; EMBOLSADO observado; incorporación viva diferenciada | 500 g y 320 plantas permanecen magnitudes distintas; conteo inicial 210 no infiere una pérdida histórica de 90 |
| INV-04 | operaciones críticas sin efectos parciales | transacción, locks y resultado conjunto | inducir fallos en pasos intermedios y comprobar rollback; Storage conserva su ciclo separado |
| INV-05 | salida física se descuenta una sola vez | asignación reduce lote; plantación consume asignación | entregar y plantar, verificando que el segundo paso no disminuya de nuevo Vivero |
| INV-06 | consumo no supera stock elegible | saldo derivado, locks y reparto LIFO | solicitudes competidoras; excluir otra subcampaña, otro propósito y entregas posteriores a la fecha |
| INV-07 | detalle explica el total plantado | suma de detalles y snapshots de procedencia | suma igual al total; participantes no multiplican plantas; reparto multiorigen reconstruible |
| INV-08 | devolución no supera remanente | actualización conjunta de asignación y lote de origen | devolver saldo exacto; rechazar exceso; comprobar retorno físico sin editar cantidad_asignada |
| INV-09 | catálogos no reescriben historia | snapshots y corrección trazable | cambiar nombres/variedad o inactivar cuentas y recuperar la interpretación anterior |
| INV-10 | evidencia corresponde al hecho y audiencia | cargas, vínculo polimórfico y permisos | rechazar foto ajena/ya vinculada; preservar fotos confirmadas durante limpieza y recuperación |
| INV-11 | ubicación válida y evaluación espacial distinguible | PostGIS; exterior con advertencia, fallo técnico sin efecto | interior, borde, exterior, captura manual y evaluador fallido según PA-S01-CA10 |
| RNF-INI-01 | autorización vigente por operación y ámbito | JWT, actividad, rol global, acceso M1, asignación M2 y permiso contextual, revalidados al confirmar | ámbitos ajenos, cambio de ID, retirada concurrente, cuenta inactiva y recuperación propia según contrato; PA-S01-CA01/06 |
| RNF-INI-02 | interpretación histórica conservada | INV-09 y original/estado efectivo cuando corresponda | cambio de catálogo y rectificación sin desaparición del original |
| RNF-INI-03 | concurrencia y reintentos coherentes | comandos recuperables en PA, accesos, recepción única e incorporación; altas 111–113 con atomicidad y consulta posterior | mismo actor/operación/UUID recupera resultado y otra intención produce conflicto; las altas sin recibo requieren consulta tras respuesta perdida; PA-S01-CA05/07 |
| RNF-INI-04 | datos, evidencia y orígenes autorizados según finalidad | proyecciones públicas, propias e internas, claves de servicio en servidor y lista exacta compartida CORS/WebAuthn | revisar respuestas, originales/derivadas, URLs por audiencia y HTTPS/configuración del destino conforme a PA-S02 y D12 |
| RNF-INI-05 | recuperación de registros y archivos | respaldo y restauración coordinados por definir | restaurar un conjunto y comprobar genealogía y evidencia; RPO/RTO requieren definición y no tienen valores aprobados |
| RNF-INI-06 | registro y consulta utilizables | estados de carga, vacío, fallo e incertidumbre diferenciados, conservación de captura y recuperación del intento | tareas con usuarios/dispositivos representativos, errores y tiempos; conectividad, carga y suficiencia aún por medir |

*Nota.* Elaboración propia a partir de los contratos, PA-S01/02/03 y RNF de Inicio. INV-01–INV-11 conservan sus IDs y se precisan con acuerdos posteriores. El refinamiento de RNF-INI-01/03/04/06 fue aprobado el 16 de noviembre. Las evidencias de acceso, recepción e incorporación se consultan con su fecha y alcance en ESTADO.md. La aprobación del requisito y el resultado de cada ensayo conservan acreditaciones propias. Los RNF sin umbrales mantienen explícita su especificación pendiente.

### 3.2.10. Arquitectura de la solución

La solución utiliza PWA React/TypeScript/Vite, API REST NestJS como monolito modular y PostgreSQL/PostGIS con Storage en Supabase. El cliente guía la captura; la API autentica, autoriza y organiza la operación; las funciones y restricciones de la base protegen relaciones, saldos y confirmación atómica. PostGIS calcula la relación espacial. Storage mantiene los archivos y la base conserva sus vínculos y estado.

**Figura 3.22. Componentes y responsabilidades de la arquitectura académica**

<!-- diagrama: 03_2_fase_elaboracion-17 -->
```mermaid
flowchart TB
    U["Persona usuaria"] --> PWA["PWA React y TypeScript<br/>captura, consulta y recuperación"]
    PWA -->|"HTTPS y Bearer en privado"| API["API NestJS<br/>identidad, autoridad y operación"]
    API --> RPC["RPC transaccionales<br/>locks, saldos y resultado"]
    RPC --> DB[("PostgreSQL<br/>datos, eventos, snapshots y comandos")]
    RPC --> GIS["PostGIS<br/>evaluación espacial"]
    API --> ST[("Storage<br/>originales y derivadas de evidencia")]
    DB -.->|"Referencias y ciclo de cargas"| ST
    PUB["Consulta pública elegible<br/>sin sesión"] --> API
```

*Nota.* Elaboración propia a partir de ARCHITECTURE, los contratos aceptados y la lectura estática del backend `be62df0` y PWA `dbcedc5` del 4 de noviembre. El catálogo físico corresponde a las fuentes de 3.2.8.3. Blockchain e IPFS no participan en la arquitectura académica evaluada. El enlace con Storage es una relación de gestión, no una transacción SQL que abarque los archivos.

El monolito modular permite compartir identidad y transacciones sin introducir coordinación entre microservicios. El modelo combina estado materializado e historia, con snapshots para conservar interpretación. Los comandos de Participación añaden un resultado durable que permite recuperar el mismo intento tras una respuesta perdida.

La observación de julio sobre confianza exclusiva en x-auth-id no describe los controllers actuales de Recolección y Vivero: usan InternalActorGuard, que verifica Bearer y cuenta activa, rechaza un header discordante y adapta la identidad verificada para código legado. El [contrato T2](../../../../Backend-r3foresta/docs/t2-acceso-viveros.md) documenta la autorización por establecimiento implementada localmente y sus límites; la propuesta anterior conserva su carácter de antecedente. La revisión de todas las rutas equivalentes, permisos de base y entorno destino conserva su evidencia separada.

La PWA instalable no promete operación completa sin conexión. Recuperar un envío o conservar una captura no equivale a tener cola de operaciones, sincronización diferida y resolución general de conflictos. Las condiciones de conectividad y validación humana corresponden a RNF-INI-06.

### 3.2.11. Riesgos y vacíos que condicionan el cierre del diseño

Se conservan RDI-01–RDI-08 de la revisión de septiembre y se actualiza su tratamiento al 4 de noviembre. Una decisión aceptada puede cerrar una discrepancia de especificación y seguir requiriendo verificación de implementación. Los responsables indicados son funciones de seguimiento; su designación y la decisión de riesgo residual deben constar en la revisión LCA.

**Tabla 3.20**

*Tratamiento actual de los riesgos de diseño*

| Código | Estado y efecto sobre el diseño | Tratamiento y evidencia de salida | Seguimiento propuesto |
|---|---|---|---|
| RDI-01 | refinamiento aprobado el 16 de noviembre y núcleo T5 implementado con origen nullable y base viva alternativa; conserva diferencias de etapa/variedad y aceptación | verificar continuidad de RF-VIV-15 y su evidencia por entorno, conservar las diferencias de diseño pendientes y desarrollar custodia directa en campo y remanentes de esa variante | autor con responsables de Vivero/Plantación |
| RDI-02 | acceso M1/M2 y recepción por operación refinados e implementados en los contratos locales T1–T4; corte y verificación externa pendientes | conservar guard JWT/actividad y autoridad por operación, accesos por ID/agregados/evidencia y logística entre ámbitos; cotejar rutas y permisos del destino | responsable backend y revisión de seguridad |
| RDI-03 | contraste documental del 16 de noviembre con 57 tablas/622 columnas y relaciones del adjunto; proyecto y fecha de exportación sin identificar, reproducibilidad integral pendiente | replay limpio y actualización de base existente, incluidos TIPO_PLANTA/destinos; cotejar restricciones, índices, RPC, grants y RLS que el extracto no enumera | responsable de base y backend |
| RDI-04 | decisión funcional resuelta el 11–12 de octubre: exterior evaluado con advertencia; fallo técnico sin guardado | mantener RN-PLA-32 y PA-S01 alineados; vincular CA10 y pruebas PostGIS reales a versión y entorno; no reabrir la decisión como bloqueo/advertencia | responsable backend/PWA y QA |
| RDI-05 | diferencia histórica de campos de DONACION en despacho manual sin nuevo cierre acreditado aquí | cotejar matriz canónica, DTO, RPC y pruebas del despacho vigente; separar despacho saliente de incorporación entrante | responsable M2 y QA |
| RDI-06 | recuperación por comandos disponible en PA, accesos, recepción e incorporación; altas111–113 conservan respuesta incierta y consulta posterior | verificar cada frontera y sus operaciones legadas, repetir el mismo intento conforme a su contrato y conciliar duplicados físicos del inventario | backend/PWA y QA de concurrencia |
| RDI-07 | expediente académico de CO-1 sin cierre equivalente al de las entregas PA | consolidar versión M1, migraciones, pruebas, demostración y revisión; la eliminación de borradores y el inventario físico aportan evidencia parcial | autor y responsable M1 |
| RDI-08 | control de alcance vigente; estructuras físicas incluyen legado y mantenimiento | evaluar solo recorrido hasta plantación; usar PA-S02/03 para situar consulta/autorización, sin atribuir cobertura transversal total ni sumar mantenimiento, carbono o blockchain | autor y revisión académica |

*Nota.* Elaboración propia a partir de ESTADO, las fuentes físicas del 4 de noviembre, PA-S01/02/03, D01–D12 y las propuestas de Vivero. El estado se refiere a evidencia documental y estática identificada; no representa nuevas pruebas, migraciones ejecutadas o certificación de despliegue.

### 3.2.12. Resultado del diseño y evaluación de LCA

El diseño vincula origen registrado, identidad del lote, eventos, custodia, entrega física y detalle de consumo plantado. En la propagación conserva cantidad y unidad entre M1 y M2, y observa las plantas vivas sin conversión automática. La incorporación de plantines comienza en el hecho real de recepción o conteo. En M2→M3 la entrega y la plantación afectan saldos diferentes y conservan procedencia multiorigen. La autorización se evalúa por función y ámbito, y el resultado recuperable distingue rechazo, confirmación e incertidumbre.

La consolidación reúne casos de uso, procesos, interacciones, modelos conceptual/lógico, el modelo físico contrastado y la matriz INV/RNF. Integra los diagramas existentes sin mantener el corte de septiembre como una segunda descripción vigente. La [versión anterior](../../../archivo/documentacion-grado/proyecto_grado/elaboracion-rup-2026-11-04/README.md) conserva los textos sustituidos y sus pendientes históricos.

LCA (*Lifecycle Architecture*, arquitectura del ciclo de vida) requiere revisar estos productos junto con evidencia ejecutable y riesgos residuales. La evaluación actual es la siguiente:

1. **Casos prioritarios y variantes.** La ruta M1→M2→M3 tiene contratos y criterios; incorporación, acceso por vivero y recepción directa requieren completar los puntos de RDI-01/02. La foto obligatoria, los documentos opcionales y el comienzo del historial están acordados; las diferencias de etapa y variedad conservan su revisión.
2. **Arquitectura base ejecutable.** Existe implementación y pruebas técnicas referidas en ESTADO y PA-F01. Falta seleccionar una versión y entorno de evaluación académica y enlazar una demostración completa de identidad, propagación, entrega, consumo y reconstrucción; el inventario físico no la reemplaza.
3. **Integridad y riesgos técnicos.** INV-01–INV-11 y RNF-INI tienen mecanismos y escenarios. Deben vincularse los resultados disponibles y completar concurrencia/recuperación, exposición de datos, replay y restauración según los límites de cada informe. GPS tiene decisión vigente; su verificación no exige otra decisión funcional.
4. **Viabilidad de Construcción.** El tablero mantiene CO-1–CO-4 y TR-1. Es necesario estimar el trabajo residual de variantes y verificación, asignar responsables y registrar ajustes del plan con fecha real; no se crean iteraciones académicas por cada migración o entrega INT.
5. **Decisión humana.** Registrar fecha, versión y entorno, productos y resultados revisados, participantes competentes, decisión y condiciones residuales. No se dispone de una nueva decisión LCA por esta actualización documental.

**Cierre de redacción de Elaboración — 4 de noviembre de 2026:** el autor dio por terminado este texto y dispuso continuar con Construcción y concluir el Capítulo III con una exposición retrospectiva del sistema desarrollado. Los refinamientos posteriores de incorporación y autorización por vivero y sus verificaciones pendientes se conservan en RDI-01/02 y el tablero académico; la evidencia integral del recorrido sigue pendiente. La decisión de continuar la redacción se distinguió de la revisión formal de LCA y de los cierres de implementación, pruebas y entorno. Los resultados se desarrollaron en [Construcción](03_3_fase_construccion.md) y [Transición](03_4_fase_transicion.md).

### 3.2.13. Correspondencia de actores, permisos y fuentes de continuidad

Cada cuenta tiene un único rol global: ADMIN, GENERAL, VALIDADOR o VOLUNTARIO. Los permisos de subcampaña, las responsabilidades logísticas y la afiliación a organización son relaciones diferentes. ADMINISTRADOR_SUBCAMPANIA permite plantar y gestionar plantadores de su ámbito según PA-S03; no concede asignar roles globales, designar otros administradores contextuales ni afectar cualquier vivero. El permiso PLANTADOR no deriva de pertenecer a una organización o equipo logístico.

El refinamiento aprobado el 16 de noviembre distingue operación M2 y recepción de semillas. GENERAL/VALIDADOR activos operan en viveros asignados según capacidad. Recibir y validar exige ADMIN o VALIDADOR con asignación vigente al almacenamiento y una persona distinta del recolector. ADMIN administra accesos y conserva alcance global. Entrega/devolución exige ADMIN o la intersección entre autoridad M2 del vivero y coordinación de la subcampaña. Los contratos T1–T4 y las reglas vigentes conservan su implementación local y los límites de aplicación, corte y verificación externa en ESTADO.md.

<!-- diagrama: 03_2_fase_elaboracion-18 -->
```mermaid
classDiagram
    direction TB

    class PersonaConsultante
    class Visitante
    class UsuarioAutenticado
    class AdministradorGlobal
    class OperadorRecoleccion
    class RevisorRecoleccion
    class OperarioVivero
    class CoordinadorPlantacion
    class Plantador
    class AdministradorSubcampania

    PersonaConsultante <|-- Visitante
    PersonaConsultante <|-- UsuarioAutenticado

    UsuarioAutenticado <|-- AdministradorGlobal
    UsuarioAutenticado <|-- OperadorRecoleccion
    UsuarioAutenticado <|-- RevisorRecoleccion
    UsuarioAutenticado <|-- OperarioVivero
    UsuarioAutenticado <|-- CoordinadorPlantacion
    UsuarioAutenticado <|-- Plantador
    UsuarioAutenticado <|-- AdministradorSubcampania

    note for AdministradorGlobal "Rol global ADMIN. Administración transversal y operación sujeta a reglas del dominio."
    note for OperadorRecoleccion "GENERAL o VALIDADOR con acceso M1, o ADMIN. Edición y envío según autoría y estado."
    note for RevisorRecoleccion "VALIDADOR o ADMIN."
    note for OperarioVivero "Acceso por vivero. Recepción según rol, asignación y separación del recolector."
    note for CoordinadorPlantacion "Responsabilidad logística en una subcampaña."
    note for Plantador "Permiso PLANTADOR en una subcampaña."
    note for AdministradorSubcampania "Permiso contextual. Planta y gestiona plantadores de su ámbito."
```

*Nota.* La vista conserva la distribución de actores del 4 de noviembre. Las generalizaciones organizan funciones de interacción. La matriz y los contratos refinados el 16 de noviembre precisan autoridad vigente por operación, recepción y logística. La evidencia de aplicación y corte se consulta en ESTADO.md.

La continuidad se consulta desde las fuentes existentes:

- [Análisis de requerimientos, 3.1.6 y 3.1.8](03_1_fase_inicio.md): últimas precisiones del autor sobre recepción, incorporación y audiencias.
- [Antecedente de acceso por vivero](../../../../Backend-r3foresta/documentacion/tareas/propuesta-permisos-por-vivero.md) y [contrato T2](../../../../Backend-r3foresta/docs/t2-acceso-viveros.md). Ámbitos, consumo de semillas y frontera logística, con sus entregas y límites de entorno.
- [Plan de incorporación y procedencia](../../../../Backend-r3foresta/documentacion/tareas/plan-incorporacion-plantas-procedencia.md): dependencias técnicas y alternativas anteriores. La copia local termina en el apartado 16; prevalecen las respuestas del autor consolidadas en Inicio frente a aptitud adicional o reglas de cierre aún no conciliadas.
- [Contrato D01–D12](../../../specs/plantacion/participacion-aliada/contrato-identidad-permisos-backend-propuesta.md) y [tablero PA-F01](../../../specs/plantacion/participacion-aliada/implementacion/README.md): decisiones aceptadas, tareas y límites de cada entrega; PA-S04 conserva su cierre propio pendiente.
- [Modelo físico y sus fuentes](../../../database/00_database_schema.md): exportación de Supabase, relaciones contrastadas y vistas vectoriales. Las 57 tablas del último extracto no equivalen a 57 capacidades terminadas.
- [Tablero académico, fase de Elaboración](../../02_planificacion/TODO_PROYECTO_GRADO.md#4-fase-de-elaboración--iteración-el-1--20-de-julio-al-16-de-agosto): control de ejecución y salida LCA, sin otro plan general.

Los diagramas se adaptan del chat [Genera diagramas del capítulo 3](codex://threads/01a0abb2-d8eb-7b62-bd57-05c969959b11), incluida su actualización versionada en `445f24f`. El texto conserva los acuerdos humanos frente a elecciones de representación de la IA. La revisión de implementación y pruebas corresponde a Construcción; la validación operativa y la aceptación del producto integrado corresponden a Transición.
