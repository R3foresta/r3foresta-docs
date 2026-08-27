# Análisis crítico de R3Foresta

## Trazabilidad operativa, problema real y relación efectiva con bonos de carbono

**Fecha de corte:** 20 de julio de 2026; estado histórico aclarado el 25 de agosto de 2026.
**Documento base relacionado:** [`antecedentes_r3foresta_enfoque_eventos_saldos.md`](antecedentes_r3foresta_enfoque_eventos_saldos.md)
**Propósito:** establecer lineamientos críticos para estructurar un proyecto de grado en Ingeniería de Sistemas.
**Alcance de la auditoría:** documentación canónica, esquema de datos, migraciones SQL y estado de implementación consignado en este repositorio. No constituye una auditoría del despliegue productivo ni una validación independiente de datos de campo.

> **Documento histórico — no utilizar como plan vigente.** Conserva el análisis técnico y de carbono realizado en julio. Los lineamientos vigentes están en [`base_perfil_proyecto_grado.md`](../01_lineamientos/base_perfil_proyecto_grado.md), la metodología en [`metodologia_desarrollo.md`](../04_metodologia/metodologia_desarrollo.md) y el entregable en el [`Perfil oficial`](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md). Las prescripciones de las secciones 1 y 7–10 —diagnóstico investigativo, comparación antes–después, estudio de caso, muestra, saturación, SUS, hipótesis y roadmap— quedaron superadas por la decisión de desarrollar el producto mediante RUP adaptado, SDD asistido por IA y comprobación de Ingeniería de Software. La sección 11 se conserva como conclusión crítica histórica, no como formulación del alcance actual. Los mecanismos técnicos analizados siguen siendo candidatos de diseño y no compromisos del Perfil.

---

## 1. Dictamen ejecutivo

R3Foresta **sí aborda un problema plausible y relevante**: la fragmentación de la información entre recolección, vivero y plantación; la dificultad para reconstruir el origen y destino de un lote; y el riesgo de inconsistencias cuando una misma transferencia física se registra de forma separada en distintos módulos.

Sin embargo, con la evidencia disponible todavía no puede afirmarse que ese problema esté **empíricamente demostrado en la organización o población objetivo**. El repositorio contiene un modelo técnico detallado, pero no presenta todavía una línea base obtenida mediante observación de campo, entrevistas, expedientes históricos o mediciones de errores, pérdidas, tiempos de conciliación y costos de auditoría. Por ello, la formulación académica correcta es:

> R3Foresta resuelve técnicamente un problema operativo razonable, pero el proyecto de grado debe demostrar primero su magnitud real y luego medir si la solución produce una mejora observable.

Respecto de los bonos de carbono, el dictamen es más restrictivo:

> R3Foresta no genera, certifica ni demuestra créditos de carbono. En su estado actual es, como máximo, una infraestructura digital potencialmente útil para una parte limitada del MRV: procedencia, actividad de plantación, cantidades operativas y ubicación. El monitoreo de supervivencia no forma parte del alcance vigente.

La cadena lógica que debe preservarse en toda la redacción es:

```text
registro digital
    ≠ trazabilidad veraz
    ≠ árbol vivo
    ≠ biomasa medida
    ≠ remoción neta adicional de CO₂
    ≠ crédito de carbono verificado
```

El aporte defendible no es “impactar positivamente los bonos de carbono”, sino **mejorar la integridad, recuperabilidad y consistencia de datos operativos que podrían alimentar un futuro sistema MRV**, siempre que después se incorporen metodología de carbono, medición forestal, verificación independiente y requisitos legales.

---

## 2. Qué problema pretende resolver realmente

### 2.1. Problema operativo subyacente

La arquitectura documentada responde a cuatro fallas frecuentes en cadenas físicas distribuidas:

1. **Ruptura de la genealogía del material:** no poder relacionar una plantación con el lote de vivero y la recolección de origen.
2. **Descuadre de cantidades:** registrar entregas, pérdidas, devoluciones o plantaciones en un módulo sin reflejar el mismo hecho en el otro.
3. **Pérdida del historial:** sobrescribir estados y cantidades sin conservar quién hizo qué, cuándo y con qué evidencia.
4. **Evidencia descontextualizada:** fotografías, coordenadas y archivos que existen, pero no están vinculados al hecho de negocio que pretenden respaldar.

R3Foresta responde mediante lotes identificados, snapshots, movimientos/eventos, evidencia vinculada, georreferenciación y transacciones que agrupan los efectos de una transferencia.

### 2.2. Por qué el problema es verosímil, pero todavía no está probado

Los antecedentes muestran que otros sistemas de vivero han mejorado inventarios y despachos, y que la literatura considera esenciales la unidad trazable, la genealogía y los eventos. Eso justifica investigar el problema, pero **no sustituye el diagnóstico del caso R3Foresta**.

Falta evidencia primaria sobre preguntas como:

- ¿Cómo se registran actualmente recolecciones, mermas, despachos y plantaciones: papel, hojas de cálculo, mensajería o memoria del operador?
- ¿Con qué frecuencia no puede reconstruirse el origen de una plantación?
- ¿Qué porcentaje de registros presenta cantidades contradictorias, información incompleta o evidencia sin ubicación?
- ¿Cuánto tarda una persona en conciliar un lote desde recolección hasta campo?
- ¿Qué decisiones o auditorías se ven afectadas por la falta de información?
- ¿Quién utilizaría el sistema diariamente y bajo qué condiciones de conectividad, dispositivo y alfabetización digital?
- ¿Cuál es el costo operativo de capturar fotografías y datos para cada evento?

Sin responder estas preguntas, existe el riesgo de haber construido una solución técnicamente sofisticada para un problema cuya frecuencia, severidad y prioridad no han sido medidas.

### 2.3. Formulación crítica del problema

La formulación no debería partir de “se necesita blockchain” ni de “se necesitan bonos de carbono”. Debería partir de una incapacidad observable:

> La gestión fragmentada de los registros de recolección, vivero y plantación dificulta reconstruir la cadena de custodia del material vegetal y verificar la coherencia de las cantidades transferidas, reduciendo la calidad y auditabilidad de la información operativa de reforestación.

Esta formulación es válida solo si el diagnóstico de campo confirma la fragmentación y permite medirla.

---

## 3. Lectura crítica de la implementación actual

### 3.1. Fortalezas técnicas reales

#### a. El lote funciona como unidad trazable

El enlace `RECOLECCION → LOTE_VIVERO → ASIGNACION_VIVERO_SUBCAMPANIA → REGISTRO_PLANTACION_DETALLE` permite recuperar genealogía. Los snapshots evitan que cambios posteriores en catálogos reescriban la identidad histórica.

Este es un aporte real para cadena de custodia. Resulta más defendible que afirmar que un código, NFT o fotografía aislada “garantiza” trazabilidad.

#### b. Las transferencias críticas están modeladas como operaciones atómicas

Las RPC de inicio de vivero, asignación física, plantación, devolución y merma concentran validaciones y escrituras relacionadas. El uso de bloqueos de fila y bloqueos cooperativos reduce condiciones de carrera en consumos concurrentes.

La asignación física M2→M3 está conceptualmente bien resuelta: el saldo baja al salir del vivero y la plantación posterior consume stock que ya se encuentra en la subcampaña. Esto evita descontar dos veces el mismo material.

#### c. Se separan cantidades con significados físicos distintos

El sistema distingue:

- material recolectado;
- material en proceso;
- plantas vivas desde `EMBOLSADO`;
- plantas que permanecen físicamente en vivero;
- plantas entregadas a una subcampaña;
- plantas consumidas, devueltas o perdidas;
- plantas inicialmente plantadas, repuestas y reportadas como muertas.

Esta separación es necesaria y demuestra modelado de dominio, no solo construcción de pantallas CRUD.

#### d. Existe una base útil de evidencia y geografía

La asociación polimórfica de evidencias, los hashes previstos, los archivos originales, el polígono de subcampaña y la validación PostGIS son una base razonable para auditoría y control de ubicación.

#### e. La solución reconoce que blockchain no debe bloquear la operación

Aunque la narrativa histórica aún lo sobredimensiona, las reglas vigentes tratan el anclaje como metadata opcional. Esta es una decisión correcta: la continuidad del proceso no debe depender de una red externa.

### 3.2. Debilidades conceptuales y técnicas

#### a. No es *event sourcing* estricto

La documentación presenta los eventos como fuente de verdad, pero el sistema mantiene y actualiza estado materializado en columnas como `saldo_vivo_actual`, `cantidad_consumida`, `total_plantado_inicial` y acumulados de mortandad/reposición. El comportamiento real se aproxima a:

> modelo transaccional híbrido con bitácora de eventos y saldos materializados.

Esto no es una falla en sí misma; puede ser la mejor solución para el caso. La debilidad es académica: denominarlo *event sourcing* estricto expone el proyecto a una objeción fácil si el estado no se reconstruye exclusivamente reproduciendo eventos.

#### b. “Append-only” está declarado con mayor amplitud que la protección visible

Las migraciones incluidas bloquean explícitamente `UPDATE`, `DELETE` y `TRUNCATE` en `recoleccion_historial` y `subcampania_historial`. No se observa la misma protección explícita en todas las tablas descritas como inmutables, entre ellas `evento_lote_vivero`, `evento_plantacion`, `registro_plantacion` y `recoleccion_movimiento`.

Las RPC se conceden a `service_role`, lo que reduce exposición directa, pero no reemplaza una política de inmutabilidad verificable en base de datos para cada registro crítico. La tesis debería comprobar permisos, RLS, triggers y vías de escritura reales en el entorno desplegado.

#### c. Inmutabilidad no equivale a veracidad

Un evento erróneo, una cantidad digitada incorrectamente o una fotografía ajena al hecho puede quedar inmutable. El MVP además excluye correcciones auditadas. Esto produce una tensión:

- impedir edición protege el pasado frente a manipulación;
- impedir corrección deja errores conocidos incorporados al pasado.

Un sistema auditable necesita eventos de reversión/corrección, separación de funciones y revisión de excepciones. “No se puede editar” no basta para afirmar “el dato es verdadero”.

#### d. La conservación no es única de extremo a extremo

R3Foresta recibe semillas por `G` o `UNIDAD`, pero el saldo vivo nace posteriormente en `UNIDAD` como observación de `EMBOLSADO`. El propio sistema, correctamente, no convierte automáticamente gramos en plantas. Por tanto, no existe una sola igualdad cuantitativa homogénea desde recolección hasta árbol vivo.

La afirmación “conservación de saldos de extremo a extremo” debe reformularse como:

> conservación por etapa y por transferencia dentro de una unidad compatible, con una transformación observada y no reversible entre material de propagación y plantas vivas.

Esta precisión fortalece la defensa. Evita presentar como conservación física lo que en realidad son invariantes contables distintas antes y después de la germinación/embolsado.

#### e. Las fotografías y el GPS prueban un registro, no necesariamente el hecho

Una coordenada enviada al backend y una foto vinculada demuestran que el sistema recibió esos datos. No demuestran por sí solas:

- que la fotografía fue tomada en el lugar indicado;
- que la fecha declarada corresponde a la captura;
- que no se reutilizó una fotografía;
- que la cantidad visible coincide con la registrada;
- que el plantín fotografiado corresponde al lote indicado;
- que el árbol continúa vivo después de la visita.

El hash protege integridad posterior del archivo, no autenticidad de origen. Se requiere, según el riesgo, captura controlada, metadata técnica, validación independiente, detección de duplicados, muestreo y segregación de roles.

#### f. El GPS dentro de un polígono tiene valor limitado

La función PostGIS verifica que un punto esté dentro o cerca del polígono. Esto es útil para bloquear ubicaciones manifiestamente equivocadas, pero un punto puede representar un grupo de muchas plantas. No prueba distribución, densidad, superficie efectivamente plantada ni correspondencia individual entre árbol y coordenada.

La tolerancia sugerida de 50 m debe justificarse empíricamente por precisión de dispositivos y condiciones de campo; no debe asumirse como criterio universal.

#### g. La simplificación de lotes puede no representar la práctica

Prohibir mezcla, división y fusión reduce complejidad y favorece la genealogía, pero puede divergir del trabajo real de un vivero. Si en la operación se consolidan semillas, se dividen bandejas, se mezclan procedencias o se redistribuyen lotes, el personal podría crear registros artificiales o trabajar fuera del sistema.

La restricción es válida para un MVP solo si se valida con usuarios y se declara como límite, no como representación universal del dominio.

#### h. La operación de campo aún presenta brechas

El estado documental informa:

- migraciones pendientes de aplicar/confirmar en Supabase;
- pruebas E2E de base de datos pendientes de ejecutar contra un entorno migrado;
- despliegue coordinado pendiente;
- frontend parcial para asignaciones, devoluciones y algunos flujos de vivero;
- ausencia de flujo de merma de stock entregado pero aún no plantado;
- transición automática a monitoreo histórico pendiente;
- *offline-first* fuera del MVP.

Por ello, los 388 tests unitarios son evidencia positiva de corrección del código revisado, pero no demuestran por sí solos operación integral en campo, adopción, disponibilidad ni consistencia del despliegue.

#### i. La publicación irrestricta introduce riesgos

La regla que hace pública “toda la información” puede exponer nombres de operadores, ubicaciones exactas, comunidades o especies sensibles. Transparencia no significa publicación indiscriminada. Debe existir una clasificación de datos: público, operativo, personal, sensible y auditable bajo autorización.

#### j. La documentación todavía contradice su nueva delimitación

El perfil excluye blockchain y bonos de carbono del objetivo central, pero el README raíz, `CLAUDE.md`, requisitos y mockups aún describen el sistema como blockchain y califican numerosos requisitos como de alta relevancia para carbono. La auditoría documental previa, además, puntúa la consistencia global en 3/10 y la salud ponderada en aproximadamente 4,5/10.

En un sistema cuya promesa es conservar historia coherente, la divergencia entre especificaciones es un riesgo técnico y un hallazgo académico relevante.

---

## 4. ¿Responde a resolver un problema real?

### 4.1. Respuesta breve

**Sí, potencialmente**, para control de inventario, procedencia, rendición operativa y reconstrucción de transferencias.

**Todavía no está demostrado**, porque falta medir el problema inicial y el resultado posterior en una organización o proceso real.

### 4.2. Criterio de decisión

R3Foresta responderá a un problema real si se demuestra que:

1. existe una brecha observable de trazabilidad o conciliación;
2. esa brecha produce errores, demoras, pérdidas o incapacidad de auditoría;
3. los usuarios pueden capturar los datos requeridos en condiciones reales;
4. el sistema reduce la brecha con un costo y carga operativa aceptables;
5. los datos recuperados son suficientemente completos y confiables para el propósito definido.

No bastará demostrar que la aplicación guarda registros y que los tests pasan. Eso demuestra calidad técnica del producto, no utilidad ni impacto.

### 4.3. Riesgo de solución dirigida por tecnología

El proyecto nació con blockchain, NFT e IPFS como elementos centrales. Aunque el enfoque fue corregido, persisten rastros de una lógica “tecnología primero”. El proyecto de grado debe invertir ese orden:

```text
problema observado → requisitos mínimos → solución → evaluación → posibles extensiones
```

Blockchain solo tendría sentido si existe un problema verificable de desconfianza entre organizaciones que no pueda resolverse adecuadamente con controles de base de datos, firmas, hashes, segregación de roles y auditoría externa. Ese problema no está demostrado en los documentos actuales.

---

## 5. Relación real con MRV y bonos de carbono

### 5.1. Qué exige un crédito de carbono de alta integridad

Los Principios Fundamentales del Carbono del ICVCM incluyen, entre otros, adicionalidad, permanencia, cuantificación robusta y ausencia de doble conteo. Una trazabilidad de plantines no satisface automáticamente ninguno de ellos ([ICVCM, Core Carbon Principles](https://icvcm.org/core-carbon-principles/)).

En proyectos de aforestación, reforestación y revegetación, la metodología VM0047 de Verra cuantifica remociones mediante enfoques basados en área o censo. El enfoque por área utiliza parcelas y teledetección para línea base/adicionalidad; el enfoque censal puede usar coordenadas GPS o marcadores para identificar árboles en proyectos elegibles de menor escala ([Verra, VM0047 v1.1](https://verra.org/methodologies/vm0047-afforestation-reforestation-and-revegetation-v1-1/)).

Además, el proyecto debe definir escenario de línea base, adicionalidad, parámetros de monitoreo y estimaciones de remociones, y someterse a validación y verificación por un organismo independiente autorizado ([Verra, Project Description and Monitoring Report](https://verra.org/programs/verified-carbon-standard/project-description-and-monitoring-report/); [Verra, Validation and Verification](https://verra.org/validation-verification/)).

Los proyectos AFOLU también deben tratar el riesgo de reversión y contribuir a un *buffer*. Verra exige análisis de no permanencia y, para nuevas solicitudes bajo las reglas indicadas desde 2024, una longevidad de proyecto de 40 años con acuerdos de monitoreo y compensación ([Verra, AFOLU Non-Permanence Risk Tool](https://verra.org/verra-releases-updated-afolu-non-permanence-risk-tool/); [recordatorio de longevidad de 40 años](https://verra.org/program-notice/reminder-new-vcs-program-rules-and-requirements-related-to-afolu-non-permanence-risk-tool-effective-january-1-2024/)).

Al 20 de julio de 2026, Verra ya publicó VCS v5.0, mientras VCS v4.7 continúa activo durante su transición hasta el 1 de enero de 2027; cualquier integración futura debe seleccionar una versión y metodología vigentes, no diseñarse contra una idea genérica de “bonos” ([Verra, VCS Program Details](https://verra.org/programs/verified-carbon-standard/vcs-program-details/)).

### 5.2. Qué cubre R3Foresta y qué no cubre

| Requisito o capacidad | Cobertura actual | Juicio crítico |
|---|---|---|
| Identidad/procedencia del material | Alta en diseño | Útil para cadena de custodia y calidad de restauración; no cuantifica CO₂. |
| Cantidad entregada y plantada | Media-alta | Útil como dato de actividad, sujeto a veracidad de captura. |
| Ubicación de plantación | Media | Punto dentro de polígono; no equivale a área efectivamente establecida ni censo de árboles. |
| Supervivencia | Baja-media | Se deriva de mortandad reportada; falta protocolo periódico de observación/muestreo y verificación. |
| Biomasa/crecimiento | Nula | No se registran DAP/DBH, altura, parcelas, ecuaciones alométricas ni teledetección. |
| Línea base | Nula | No existe escenario contrafactual ni benchmark dinámico. |
| Adicionalidad | Nula | No demuestra que la remoción no ocurriría sin ingresos de carbono. |
| Fugas (*leakage*) | Nula | No modela desplazamiento de actividades o emisiones fuera del límite. |
| Permanencia/reversiones | Muy baja | Tres años de mantenimiento no equivalen al tratamiento de permanencia exigido por programas AFOLU. |
| Incertidumbre y conservadurismo | Nula | No existen intervalos, error de muestreo ni descuentos conservadores. |
| Derechos sobre tierra y carbono | Nula | No se modelan tenencia, derecho a operar ni titularidad de remociones. |
| Salvaguardas y participación | Nula | No existe flujo de consulta, reclamos o salvaguardas socioambientales. |
| Doble conteo y emisión/retiro | Nula | No hay serialización de unidades de carbono ni integración con registro acreditado. |
| Validación/verificación independiente | Nula | El rol `VALIDADOR` interno no es un organismo de validación/verificación de un estándar. |

### 5.3. Qué aporte positivo podría tener

R3Foresta podría reducir costos y errores de MRV en el futuro al ofrecer:

- una lista trazable de actividades de plantación;
- procedencia y especie del material;
- fechas, responsables y evidencias;
- polígonos y puntos de intervención;
- historial de mortalidad y reposición;
- mecanismos de consistencia y deduplicación de cantidades;
- exportación de datos para muestreo, auditoría o teledetección.

Este aporte es **habilitante e indirecto**. Debe demostrarse mediante compatibilidad con una metodología seleccionada y mediante evaluación de calidad de datos. No debe traducirse en afirmaciones como “R3Foresta aumenta los bonos”, “garantiza carbono” o “cada árbol genera un crédito”.

### 5.4. La métrica `saldo_vivo_grupo` no es captura de carbono

La fórmula:

```text
plantado inicial + reposiciones − mortandad reportada
```

es un estimador contable del número de plantas no reportadas como muertas. No mide diámetro, altura, biomasa, carbono almacenado ni CO₂ equivalente. Tampoco incluye árboles vivos no detectados como muertos, diferencias por especie/edad, incertidumbre o remociones de línea base.

Debe denominarse **saldo operativo estimado de plantas vivas**, no “métrica de captura de carbono”.

### 5.5. Particularidad boliviana

Bolivia presentó su NDC 3.0 en septiembre de 2025 ([CMNUCC, Bolivia NDC 3.0](https://unfccc.int/documents/650130)). Esto aporta contexto climático nacional, pero no autoriza por sí solo un mercado, una metodología o la titularidad privada de remociones. Antes de una futura implementación comercial se requiere un análisis jurídico e institucional específico y actualizado sobre tierra, bosques, derechos sobre resultados de mitigación y reglas de transferencia. Ese análisis está fuera del alcance razonable del presente proyecto de grado de software.

---

## 6. Qué tiene potencial y qué está de sobra

### 6.1. Componentes con potencial alto

| Componente | Potencial defendible |
|---|---|
| Genealogía recolección→vivero→plantación | Núcleo del problema de trazabilidad. |
| Snapshots de identidad | Evitan reescritura retrospectiva por cambios de maestros. |
| Consistencia de transferencias y operaciones simultáneas | Propiedad de ingeniería para evitar doble consumo, saldos incoherentes y estados parciales; el mecanismo se definirá en el diseño. |
| Saldos separados por ubicación física | Representan mejor vivero, subcampaña y campo. |
| Evidencia vinculada al hecho | Mejora la recuperabilidad de soporte documental. |
| PostGIS y límites espaciales | Control útil de coherencia geográfica. |
| Mortandad y reposición append-only | Base inicial para seguimiento de supervivencia, si se acompaña de protocolo de monitoreo. |
| Pruebas de invariantes | Permiten evaluar propiedades objetivas del software. |

### 6.2. Componentes útiles, pero sobredimensionados en la narrativa

| Componente | Conclusión |
|---|---|
| Blockchain/NFT/IPFS | No resuelve la calidad del dato de entrada ni la medición de carbono. Mantener fuera del núcleo y solo como experimento futuro sujeto a necesidad. |
| “Transparencia pública total” | Sustituir por transparencia por capas, con privacidad y protección de ubicaciones/datos personales. |
| Etiqueta *event sourcing* | Usar “modelo híbrido de eventos y saldos materializados” salvo que se implemente reconstrucción completa desde eventos. |
| “Relevancia carbono: alta” en casi todas las reglas | Eliminar o reemplazar por una matriz explícita de contribución a trazabilidad, MRV o ninguna. |
| Dashboard de CO₂ proyectado | No implementar hasta adoptar metodología, variables forestales y modelo validado. |
| Tres años como horizonte de mantenimiento | Puede ser una regla operativa, pero no presentarse como permanencia de carbono. |
| Inmutabilidad sin correcciones | Añadir eventos correctivos auditados antes de uso serio de auditoría. |
| Prohibición absoluta de división/fusión | Mantener como límite MVP solo si la práctica real lo admite; de lo contrario modelar transformaciones de lote. |

### 6.3. Elementos que hoy perjudican la credibilidad académica

- afirmar impacto en bonos sin cuantificación ni metodología;
- confundir tests unitarios con validación del problema;
- afirmar trazabilidad “verificable” sin precisar quién verifica y con qué independencia;
- presentar fotos y GPS como prueba concluyente;
- llamar inmutable a tablas sin demostrar protección en todas las vías de escritura;
- usar una igualdad de conservación única cuando existen cambios de unidad y transformación biológica;
- mantener contradicciones entre documentación académica y canónica.

---

## 7. Enfoque recomendado para el proyecto de grado

### 7.1. Delimitación recomendada

El proyecto debe centrarse en:

> trazabilidad operativa y conservación de saldos por etapa en la cadena recolección–vivero–registro de plantación.

Carbono debe aparecer como **contexto y posible uso futuro de los datos**, no como resultado del proyecto.

Se recomienda excluir del objetivo principal:

- emisión o certificación de bonos de carbono;
- cálculo de CO₂;
- blockchain, NFT e IPFS;
- monitoreo forestal de largo plazo;
- teledetección y modelos alométricos;
- despliegue de un registro público irrestricto.

### 7.2. Título recomendado

> **Sistema de trazabilidad operativa para la cadena de custodia de material vegetal en reforestación, mediante registro de eventos y conservación transaccional de saldos — Caso R3Foresta**

Este título evita prometer *event sourcing* estricto, carbono o certificación, y mantiene el aporte técnico.

### 7.3. Pregunta de investigación/problema

> ¿En qué medida un sistema que conserva eventos y relaciones entre etapas permite mantener la integridad de cantidades y reconstruir la cadena de custodia del material vegetal entre recolección, vivero y plantación en el caso R3Foresta?

### 7.4. Objetivo general recomendado

> **Nota de vigencia (2026-08-05):** las recomendaciones de §§7.4–7.5 corresponden a una etapa exploratoria y fueron superadas por la versión consolidada de cinco objetivos del [`perfil oficial`](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md) §4. Se conservan como antecedente del análisis y no deben copiarse al entregable.

> Desarrollar y evaluar un sistema de trazabilidad operativa para la cadena de custodia de material vegetal destinado a reforestación, que registre los hechos críticos de recolección, vivero y plantación y preserve la consistencia de los saldos mediante operaciones transaccionales, en el caso R3Foresta.

El verbo **evaluar** es imprescindible: convierte la implementación existente en objeto de estudio y evita que el proyecto termine siendo solo una descripción de software ya construido.

### 7.5. Objetivos específicos recomendados

1. **Diagnosticar** el proceso actual y cuantificar sus problemas de completitud, conciliación, recuperación de trazas y evidencia.
2. **Modelar** la unidad trazable, las transformaciones, transferencias y reglas de cantidad de cada etapa.
3. **Diseñar** un modelo híbrido de eventos, snapshots y saldos materializados con controles de inmutabilidad y corrección auditada.
4. **Implementar** los flujos críticos de recolección, vivero y plantación inicial con evidencia y validación espacial.
5. **Verificar** mediante pruebas unitarias, de integración, concurrencia y manipulación que las invariantes técnicas se preservan.
6. **Evaluar** mediante escenarios y usuarios del dominio la mejora en tiempo, completitud, exactitud y recuperación de trazas respecto del proceso de referencia.
7. **Analizar** la brecha entre los datos generados por el sistema y los requisitos de un MRV de carbono, sin atribuir generación de créditos.

### 7.6. Aporte de ingeniería defendible

El aporte debe expresarse como integración y validación de tres mecanismos:

1. **Modelo de genealogía:** identidad y relaciones entre lotes, asignaciones y registros de plantación.
2. **Consistencia transaccional:** una transferencia física produce todos sus efectos o ninguno, incluso bajo concurrencia.
3. **Auditoría contextual:** cada hecho crítico conserva actor, tiempo, cantidad, ubicación y evidencia, con capacidad de corrección no destructiva.

---

## 8. Diseño de evaluación propuesto

### 8.1. Fase 1 — Diagnóstico del problema real

Aplicar un estudio de caso con:

- entrevistas semiestructuradas a recolectores, responsables de vivero, coordinadores de plantación y responsables administrativos;
- observación de uno o más flujos reales;
- revisión de una muestra de registros históricos;
- caracterización de la situación actual del proceso;
- identificación de fallas y sus efectos mediante causa–efecto o FMEA.

La cantidad de participantes y expedientes debe justificarse por disponibilidad y saturación, no elegirse solo por conveniencia.

### 8.2. Fase 2 — Verificación técnica

Casos mínimos:

- doble consumo concurrente del mismo saldo;
- fallo deliberado a mitad de una transferencia;
- intento de saldo negativo;
- intento de editar/eliminar cada registro declarado inmutable;
- reconstrucción de genealogía desde plantación hasta recolección;
- devolución y reapertura del lote;
- cambio posterior de datos maestros sin alterar snapshots;
- evidencia faltante, duplicada, eliminada o con hash diferente;
- punto fuera del polígono y prueba de tolerancia;
- migraciones aplicadas en un entorno limpio y prueba E2E real.

### 8.3. Fase 3 — Evaluación funcional y operativa

| Dimensión | Métrica sugerida |
|---|---|
| Recuperación de traza | % de casos en que se reconstruye origen→destino sin ambigüedad. |
| Completitud | % de campos y evidencias obligatorias presentes. |
| Integridad de saldos | Número de violaciones detectadas en escenarios normales y concurrentes; objetivo técnico: 0. |
| Tiempo de auditoría | Minutos para responder una consulta de trazabilidad antes y después. |
| Exactitud | Diferencia entre conteo físico/muestra validada y registro digital. |
| Duplicidad | Registros o evidencias reutilizadas por cada 100 operaciones. |
| Éxito de tareas | % de usuarios que completa cada flujo sin asistencia. |
| Usabilidad | SUS u otro instrumento validado, complementado con observación cualitativa. |
| Carga operativa | Tiempo y número de interacciones para registrar cada evento. |
| Disponibilidad de campo | % de operaciones realizables bajo conectividad real; registrar fallos por ausencia de *offline*. |
| Auditabilidad | % de mutaciones no autorizadas rechazadas y eventos correctivos recuperables. |

No deben fijarse mejoras porcentuales antes de obtener la línea base. Los umbrales técnicos, como cero saldos negativos, sí pueden definirse a priori.

### 8.4. Evaluación de preparación para MRV, no de carbono

Como resultado secundario puede elaborarse una matriz de correspondencia contra **una metodología elegida** —por ejemplo VM0047 si el caso cumple su aplicabilidad— con tres estados:

- dato disponible y con calidad suficiente;
- dato disponible pero insuficiente/no verificado;
- dato inexistente.

El indicador resultante debe denominarse “cobertura de datos para MRV” o “preparación de información”, nunca toneladas de CO₂ ni créditos potenciales.

---

## 9. Hipótesis de valor que el proyecto debe poner a prueba

El proyecto no necesita una hipótesis estadística formal si la modalidad académica no la exige, pero sí debe declarar y evaluar sus supuestos:

1. Los actores tienen actualmente dificultad para reconstruir la genealogía del material.
2. Los errores de saldo y la información incompleta ocurren con frecuencia suficiente para justificar el sistema.
3. El costo de capturar evidencia por evento no supera el beneficio operativo.
4. Los mecanismos de consistencia seleccionados reducen inconsistencias que realmente se producían en el proceso anterior.
5. La granularidad por lote representa la operación sin forzar trabajo paralelo.
6. La conectividad disponible permite usar el sistema o justifica incorporar soporte offline.
7. Los datos de trazabilidad tienen un consumidor real: operación, financiador, auditor o responsable público.

Si estos supuestos no se confirman, el proyecto deberá reducir alcance o reformular su propuesta de valor. Esa posibilidad no debilita una investigación; la hace honesta.

---

## 10. Roadmap priorizado

### Prioridad 1 — Antes de congelar el perfil

1. Ejecutar diagnóstico de campo y obtener línea base.
2. Cambiar la narrativa de “bonos de carbono” por “trazabilidad operativa con potencial de soporte a MRV”.
3. Adoptar el título, problema y objetivos medibles propuestos.
4. Definir la unidad de análisis y los usuarios evaluados.
5. Seleccionar métricas y protocolo de evaluación.

### Prioridad 2 — Para cerrar la validez técnica

1. Aplicar y verificar migraciones en un entorno controlado.
2. Ejecutar E2E de base de datos y pruebas de concurrencia.
3. Auditar inmutabilidad efectiva de todas las tablas críticas.
4. Diseñar eventos correctivos/reversiones con autorización y evidencia.
5. Separar permisos de captura, validación y administración.
6. Corregir inconsistencias documentales antes de usarlas como anexos académicos.

### Prioridad 3 — Para uso real en campo

1. Evaluar y, si corresponde, implementar operación offline/sincronización.
2. Validar carga de trabajo por evidencia y simplificar campos sin valor.
3. Justificar tolerancia GPS y calidad mínima de captura.
4. Implementar clasificación de privacidad y vista pública agregada.
5. Confirmar si división, fusión o transformación de lotes ocurren en la práctica.

### Prioridad 4 — Solo si se decide evolucionar hacia carbono

1. Seleccionar estándar y metodología vigentes y comprobar aplicabilidad.
2. Incorporar límite de proyecto, línea base, adicionalidad y fugas.
3. Diseñar inventario forestal: parcelas/censo, DAP, altura, especie, edad y ecuaciones alométricas.
4. Integrar teledetección y estimación de incertidumbre cuando corresponda.
5. Implementar monitoreo de largo plazo, riesgos de reversión y permanencia.
6. Documentar derechos de tierra y de resultados de mitigación, salvaguardas y reclamos.
7. Preparar exportación auditable para un VVB y un registro reconocido.
8. Evaluar blockchain únicamente si un requisito de interoperabilidad o confianza lo justifica.

---

## 11. Conclusión final

R3Foresta tiene un núcleo con potencial académico y operativo: **la genealogía de lotes y la conservación transaccional de cantidades entre actores y etapas**. Ese núcleo puede constituir un proyecto de grado sólido porque combina modelado de dominio, bases de datos, concurrencia, geoinformación, evidencia digital y evaluación de calidad.

Lo que sobra no es necesariamente código, sino **promesa**. Sobran las afirmaciones de carbono no medidas, la centralidad narrativa de blockchain, la equivalencia entre inmutabilidad y verdad, y la idea de que un saldo de plantas vivas equivale a CO₂ capturado.

La conclusión más defendible es:

> R3foresta App no debe presentarse como sistema de bonos de carbono. Debe presentarse y evaluarse como sistema de trazabilidad operativa de material vegetal. Si demuestra en campo que mejora la integridad, completitud y recuperación de información, podrá convertirse en una capa de datos útil para un futuro MRV; pero la contribución climática y la emisión de créditos requerirán procesos científicos, normativos y de verificación que hoy no están implementados.

Este encuadre no reduce el proyecto. Lo vuelve comprobable, técnicamente preciso y defendible ante un tribunal de Ingeniería de Sistemas.
