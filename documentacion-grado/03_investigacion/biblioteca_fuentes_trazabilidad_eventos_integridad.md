# Biblioteca razonada: eventos, genealogía, integridad y reconstrucción

**Proyecto:** R3Foresta

**Fecha de incorporación:** 18 de agosto de 2026; alineación terminológica actualizada el 19 de agosto de 2026

**Estado:** recurso de investigación vivo; no constituye por sí mismo bibliografía del perfil ni del documento final.

## 1. Propósito y reglas de uso

Este documento conserva y evalúa críticamente las fuentes obtenidas en dos búsquedas adicionales: representación de la trazabilidad mediante eventos e integridad, evidencia y reconstrucción de trazas. Su función es evitar que los hallazgos se pierdan y permitir recuperarlos cuando se redacten el marco teórico, el diseño del modelo, la metodología de evaluación o la discusión del Proyecto de Grado.

Se aplican las siguientes reglas:

1. La presencia de una fuente en esta biblioteca **no implica** que deba citarse en el perfil.
2. Antes de citar una fuente en un entregable, se debe revisar el texto pertinente y comprobar que respalde la afirmación concreta.
3. Los principios procedentes de alimentos, manufactura, farmacéutica u otros sectores solo se transferirán cuando sean compatibles con el recorrido del material vegetal.
4. No se trasladarán procesos, objetos ni vocabulario ajenos al dominio de R3Foresta.
5. Las normas y guías oficiales son fuentes técnicas o normativas; no se presentarán como estudios académicos ni como evidencia empírica.
6. R3Foresta puede tomar conceptos de EPCIS, PROV-O, FSC o UNTP sin afirmar que implementa o cumple esos marcos de forma integral.
7. La transformación biológica observada entre semillas y plantas no se tratará como una conversión aritmética ni como balance de masa industrial.

El índice temático para recuperar estas fuentes está en [`../05_recursos/indice_fuentes_bibliograficas.md`](../05_recursos/indice_fuentes_bibliograficas.md).

## 2. Decisión editorial para el Perfil

La búsqueda aporta más fuentes valiosas de las que necesita un perfil breve. La primera versión incorporó dos fuentes al argumento de antecedentes:

- **[EVT-02] Solanki y Brewster (2014):** incorporada a los antecedentes porque extiende directamente a Thakur et al. (2011) y sustenta las relaciones entrada–evento–salida necesarias para reconstruir procedencia.
- **[EVA-01] Donnelly et al. (2012):** incorporada a la progresión argumentativa de los antecedentes y al procedimiento de comparación entre la situación actual y la propuesta porque respalda que la capacidad de trazabilidad debe comprobarse intentando reconstruir una traza.

La revisión final del marco teórico preliminar incorporó además **Olsen y Borit (2018)** para unidades, atributos y relaciones; **W3C PROV-O** para procedencia; **FAO Forest Reproductive Material** para anclar el dominio forestal; y **Härder y Reuter (1983)** para las propiedades transaccionales. Estas fuentes cubren vacíos concretos sin comprometer una arquitectura.

Las demás fuentes quedan reservadas. En particular:

- **GS1 EPCIS 2.0** es un referente técnico útil, pero incluirlo ahora podría sugerir una decisión de implementación que todavía no se ha tomado.
- **FSC Chain of Custody** aporta reglas de conciliación cuantitativa en el ámbito forestal, aunque su objeto es la certificación de productos forestales y no la genealogía de material vegetal vivo.
- **UNTP Digital Traceability Events** resulta prometedor, pero al corte de esta revisión continúa como especificación en desarrollo y adecuada para pilotos preproductivos.

Esta selección mantiene la progresión argumentativa del perfil sin convertir los antecedentes en un catálogo de estándares.

## 3. Estado resumido de las fuentes

| ID | Fuente | Tipo | Destino principal | Estado al 18-08-2026 |
|---|---|---|---|---|
| DOM-01 | FAO, *Forest Reproductive Material* | Guía técnica oficial | Dominio forestal y procedencia | Ya citada en el marco teórico preliminar |
| EVT-01 | Thakur et al. (2011) | Artículo académico | Antecedentes y marco teórico | Ya citada en el perfil |
| EVT-02 | Solanki y Brewster (2014), transformaciones | Capítulo académico | Antecedentes y modelo | Incorporada al perfil; texto revisado |
| EVT-03 | GS1 EPCIS 2.0 | Guía técnica oficial | Marco teórico y diseño | Reservada; documento oficial revisado |
| EVT-04 | UNTP Digital Traceability Events | Especificación en desarrollo | Estado del arte reciente | Reserva; estado y versión verificados |
| EVT-05 | Byun, Woo y Kim (2017) | Artículo académico | Grafo temporal y privacidad | Reserva; lectura completa pendiente |
| GEN-01 | Olsen y Borit (2018) | Artículo académico | Componentes y unidades trazables | Ya citada en el marco teórico preliminar |
| GEN-02 | W3C PROV-O (2013) | Recomendación técnica | Procedencia y derivación | Ya citada en el marco teórico preliminar |
| GEN-03 | Jansen-Vullers et al. (2003) | Artículo académico | Genealogía en manufactura | Reserva; lectura completa pendiente |
| GEN-04 | Solanki y Brewster (2014), *linked pedigrees* | Capítulo académico | Genealogía derivada de eventos | Reserva; lectura completa pendiente |
| GEN-05 | Solanki (2015) | Ponencia/taller | Trazabilidad basada en eventos | Reserva; lectura completa pendiente |
| INT-01 | ISO 22095:2020 | Norma internacional | Cadena de custodia | Ya citada en el perfil |
| INT-02 | ISO 22095-2:2026 | Norma internacional | Balance y doble contabilización | Marco teórico/diseño; ficha oficial verificada |
| INT-03 | FSC-STD-40-004 V3-1 (2021) | Estándar de certificación | Conciliación cuantitativa | Diseño de invariantes; documento oficial revisado |
| INT-04 | Comba et al. (2013) | Artículo académico | Cantidad y procedencia en mezclas | Reserva; lectura completa pendiente |
| INT-05 | FDA (2018), integridad de datos | Guía regulatoria | Integridad y pistas de auditoría | Marco teórico; documento oficial revisado |
| INT-06 | Härder y Reuter (1983) | Artículo académico | Atomicidad y consistencia transaccional | Ya citada en el marco teórico preliminar |
| EVA-01 | Donnelly et al. (2012) | Artículo académico | Antecedentes y evaluación por reconstrucción | Incorporada al perfil; metadatos y resumen revisados |
| EVA-02 | Randrup et al. (2008) | Artículo académico | Retiro simulado | Reserva; lectura completa pendiente |
| EVA-03 | Mgonja et al. (2013) | Artículo académico | Desempeño de trazabilidad | Marco de evaluación; lectura completa pendiente |
| LIM-01 | Terriault (2022) | Tesis | Límites de los enlaces inferidos | Discusión; lectura completa pendiente |

## 4. Fichas críticas

### DOM-01 — Material reproductivo forestal y procedencia

**Fuente:** Food and Agriculture Organization of the United Nations. (s. f.). *Forest reproductive material*. [Sustainable Forest Management Toolbox](https://www.fao.org/sustainable-forest-management-toolbox/modules/forest-reproductive-material/en).

- **Aporte transferible:** incluye semillas, partes de plantas y plantas dentro del material reproductivo forestal y recomienda registrar fuente, cantidad, tratamientos, distribución y lugar de uso, también cuando el material proviene de un proveedor.
- **Uso previsto:** delimitar el término material vegetal y sustentar los datos mínimos de procedencia para compras o recepciones externas.
- **Límite:** la guía orienta la gestión forestal; no prescribe el modelo informático ni certifica la calidad del material registrado.

### EVT-01 — Eventos como representación de la cadena

**Fuente:** Thakur, M., Sørensen, C. F., Bjørnson, F. O., Forås, E., & Hurburgh, C. R. (2011). *Managing food traceability information using EPCIS framework*. *Journal of Food Engineering, 103*(4), 417–433. [DOI](https://doi.org/10.1016/j.jfoodeng.2010.11.012).

- **Aporte transferible:** permite describir estados, movimientos y transformaciones como hechos ocurridos y distinguirlos de los datos maestros.
- **Uso previsto:** base de la narrativa de eventos ya incluida en el perfil y referente para especificar el sobre común de cada evento.
- **Límite:** el contexto alimentario y EPCIS no resuelven las reglas biológicas, de saldo y geográficas de R3Foresta.

### EVT-02 — Transformaciones y relaciones entrada–salida

**Fuente:** Solanki, M., & Brewster, C. (2014). *Modelling and linking transformations in EPCIS governing supply chain business processes*. En M. Hepp & Y. Hoffner (Eds.), *E-Commerce and Web Technologies* (LNBIP 188, pp. 46–57). Springer. [DOI](https://doi.org/10.1007/978-3-319-10491-1_5) · [texto](https://cbrewster.com/papers/Solanki_ECWEB14.pdf).

- **Aporte transferible:** representa entradas consumidas, evento de transformación y salidas producidas; el enlace entre eventos permite consultar procedencia y genealogía.
- **Uso previsto:** antecedentes del perfil y posterior diseño de relaciones entre registros de origen y lotes resultantes.
- **Límite:** no justifica convertir automáticamente semillas en plantas ni demuestra reglas de conservación para un proceso biológico.
- **Decisión:** incorporada al perfil como complemento directo de Thakur et al. (2011).

### EVT-03 — EPCIS 2.0 como vocabulario técnico de eventos

**Fuente:** GS1 AISBL. (2023). *EPCIS and CBV Implementation Guideline, Release 2.0*. [Documento oficial](https://ref.gs1.org/guidelines/epcis-cbv/).

- **Aporte transferible:** organiza los hechos alrededor de qué, cuándo, dónde, por qué y cómo; distingue eventos de objeto, agregación, asociación y transformación y permite vincular entradas y salidas.
- **Uso previsto:** comparar el modelo de eventos de R3Foresta con un referente reconocido y revisar la suficiencia de atributos.
- **Límite:** una guía de implementación no es evidencia empírica; usar sus conceptos no equivale a implementar EPCIS.
- **Decisión:** reservar para el marco teórico y el diseño.

### EVT-04 — Digital Traceability Events de UNTP

**Fuente:** United Nations Transparency Protocol. (2026). *Digital Traceability Events*, versión 0.7.0. [Especificación](https://untp.unece.org/docs/specification/DigitalTraceabilityEvents/).

- **Aporte transferible:** propone eventos `MakeEvent`, `MoveEvent` y `ModifyEvent`, con actor, tiempo, lugar, productos, cantidades y evidencia relacionada.
- **Uso previsto:** estado del arte reciente y comparación conceptual con el modelo propio.
- **Límite:** al 18 de agosto de 2026 figura como *Work in Progress* y apta para pilotos preproductivos; no debe presentarse como estándar consolidado.
- **Decisión:** conservar como fuente emergente, no como fundamento principal del perfil.

### EVT-05 — Eventos enlazados como grafo temporal

**Fuente:** Byun, Woo y Kim (2017). *Efficient and privacy-enhanced object traceability based on unified and linked EPCIS events*. *Computers in Industry, 89*, 35–49. [DOI](https://doi.org/10.1016/j.compind.2017.04.001).

- **Aporte potencial:** ayuda a explicar por qué divisiones, agregaciones y transformaciones forman una red temporal y no una secuencia estrictamente lineal.
- **Uso previsto:** diseño del modelo y discusión sobre recorridos ramificados.
- **Límite:** el componente de privacidad y la arquitectura concreta solo se usarán después de revisar el texto completo y comprobar su pertinencia.

### GEN-01 — Componentes mínimos de un sistema de trazabilidad

**Fuente:** Olsen, P., & Borit, M. (2018). *The components of a food traceability system*. *Trends in Food Science & Technology, 77*, 143–149. [DOI](https://doi.org/10.1016/j.tifs.2018.05.004) · [repositorio](http://hdl.handle.net/10037/13348).

- **Aporte transferible:** identifica como componentes centrales las unidades trazables, sus atributos y las relaciones producidas cuando se unen o dividen.
- **Uso previsto:** marco teórico y comprobación de que el modelo conserva identidad y relaciones suficientes; incorporada al perfil.
- **Límite:** no prescribe las invariantes transaccionales ni las reglas biológicas de R3Foresta.
- **Decisión:** incorporada al marco teórico preliminar como complemento de la definición de Olsen y Borit (2013).

### GEN-02 — Procedencia mediante entidades, actividades y agentes

**Fuente:** World Wide Web Consortium. (2013). *PROV-O: The PROV Ontology*. [Recomendación](https://www.w3.org/TR/prov-o/).

- **Aporte transferible:** ofrece relaciones para expresar entidades usadas o generadas por actividades, derivaciones y responsabilidad de agentes.
- **Uso previsto:** vocabulario conceptual para procedencia, genealogía y autoría de eventos; incorporada al perfil sin comprometer RDF u OWL.
- **Límite:** PROV-O no controla cantidades, saldos ni reglas transaccionales; tampoco es necesario adoptar RDF u OWL para aprovechar su modelo conceptual.

### GEN-03 — Genealogía de lotes en manufactura

**Fuente:** Jansen-Vullers, van Dorp y Beulens (2003). *Managing traceability information in manufacture*. [DOI](https://doi.org/10.1016/S0268-4012(03)00066-5).

- **Aporte potencial:** relaciones padre–hijo y recuperación de genealogía a través de sucesivas transformaciones.
- **Uso previsto:** marco teórico y contraste de alternativas de modelado.
- **Límite:** no trasladar procesos industriales al ciclo de material vegetal; lectura completa pendiente antes de formular afirmaciones específicas.

### GEN-04 — Genealogías generadas desde eventos

**Fuente:** Solanki y Brewster (2014). *EPCIS Event-Based Traceability in Pharmaceutical Supply Chains via Automated Generation of Linked Pedigrees*. [DOI](https://doi.org/10.1007/978-3-319-11964-9_6).

- **Aporte potencial:** muestra cómo derivar una genealogía consultable a partir del historial enlazado de eventos.
- **Uso previsto:** diseño de consultas y discusión de la genealogía reconstruida.
- **Límite:** el dominio farmacéutico y la solución semántica no deben convertirse en requisitos implícitos.

### GEN-05 — Trazabilidad basada en eventos y procedencia

**Fuente:** Solanki (2015). *Towards Event-Based Traceability in Provenance-Aware Supply Chains*. [Texto](https://ceur-ws.org/Vol-1501/Diversity2015-InvitedPaper-MSolanki.pdf).

- **Aporte potencial:** articula explícitamente eventos, procedencia y genealogías o *pedigrees*.
- **Uso previsto:** síntesis conceptual del marco teórico.
- **Límite:** fuente de taller; se priorizarán artículos y capítulos revisados cuando respalden la misma afirmación.

### INT-01 — Terminología y modelos de cadena de custodia

**Fuente:** International Organization for Standardization. (2020). *Chain of custody—General terminology and models* (ISO 22095:2020). [Ficha oficial](https://www.iso.org/standard/72532.html).

- **Aporte transferible:** delimita modelos y terminología de cadena de custodia y advierte que el sistema no prueba por sí solo la veracidad de las declaraciones.
- **Uso previsto:** ya citada en la introducción y el marco teórico preliminar del perfil.
- **Límite:** no especifica la arquitectura, las transacciones ni la evidencia geoespacial de R3Foresta.

### INT-02 — Balance de masa y sus límites

**Fuente:** International Organization for Standardization. (2026). *Chain of custody—Part 2: Requirements and guidelines for mass balance* (ISO 22095-2:2026). [Ficha oficial](https://www.iso.org/standard/84427.html).

- **Aporte transferible:** desarrolla límites del sistema, factores de conversión y atribución de características en un modelo de balance de masa.
- **Uso previsto:** discusión de conciliación cuantitativa y prevención de doble contabilización.
- **Límite crítico:** el balance contable no equivale a identidad física exacta y no debe usarse para inferir una conversión semilla–planta.

### INT-03 — Conciliación cuantitativa en cadena de custodia forestal

**Fuente:** Forest Stewardship Council. (2021). *FSC-STD-40-004 V3-1: Chain of Custody Certification*. [Documento oficial](https://connect.fsc.org/document-centre/documents/retrieve/0229b10e-ebf8-4df1-b184-c0121051ad0c).

- **Aporte transferible:** exige registros de cantidades de entrada y salida, inventario, factores de conversión y controles para evitar contabilizar una salida más de una vez.
- **Uso previsto:** justificar y contrastar invariantes de disponibilidad, consumo y conciliación.
- **Límite crítico:** regula certificación y declaraciones sobre productos forestales; R3Foresta no certifica productos ni implementa el esquema FSC.
- **Decisión:** reservar para diseño y marco teórico, pese a su cercanía sectorial.

### INT-04 — Cantidad y procedencia en materiales a granel

**Fuente:** Comba, Belforte, Dabbene y Gay (2013). *Methods for traceability in food production processes involving bulk products*. [DOI](https://doi.org/10.1016/j.biosystemseng.2013.06.006).

- **Aporte potencial:** relaciona procedencia y cantidades cuando existen mezclas o transformaciones.
- **Uso previsto:** contraste técnico si el modelo requiere fraccionamientos, agrupaciones o contribuciones múltiples.
- **Límite crítico:** no trasladar el balance de masa a la transformación biológica semilla–planta; lectura completa pendiente.

### INT-05 — Integridad y conservación de registros electrónicos

**Fuente:** U.S. Food and Drug Administration. (2018). *Data Integrity and Compliance With Drug CGMP: Questions and Answers—Guidance for Industry*. [Documento oficial](https://www.fda.gov/media/119267/download).

- **Aporte transferible:** define integridad de datos, metadatos y *audit trail*, y enfatiza acceso individual, conservación y revisión de cambios.
- **Uso previsto:** marco teórico de autoría, temporalidad y modificación no destructiva de registros.
- **Límite:** es una guía regulatoria farmacéutica no vinculante para R3Foresta; solo se transferirán principios generales.

### INT-06 — Atomicidad y consistencia transaccional

**Fuente:** Härder, T., & Reuter, A. (1983). *Principles of transaction-oriented database recovery*. *ACM Computing Surveys, 15*(4), 287–317. [DOI](https://doi.org/10.1145/289.291).

- **Aporte transferible:** fundamenta atomicidad, consistencia, aislamiento y durabilidad como propiedades de las transacciones.
- **Uso previsto:** explicar por qué una operación crítica no debe dejar efectos parciales ni aceptar interacciones simultáneas incoherentes.
- **Límite:** sustenta propiedades generales; no decide por sí sola qué mecanismo de bloqueo, restricción o recuperación implementará R3Foresta.

### EVA-01 — Evaluación empírica mediante reconstrucción

**Fuente:** Donnelly, K. A.-M., Karlsen, K. M., & Dreyer, B. (2012). *A simulated recall study in five major food sectors*. *British Food Journal, 114*(7), 1016–1031. [DOI](https://doi.org/10.1108/00070701211241590).

- **Aporte transferible:** evalúa la trazabilidad intentando recuperar origen, lote e información relacionada, en vez de asumir la efectividad por la mera existencia de registros.
- **Uso previsto:** fundamentar la guía de reconstrucción, las fuentes recuperadas, los vacíos y la comparación de tiempos entre la situación actual y la propuesta.
- **Límite:** R3Foresta no ejecutará un retiro sanitario ni evaluará inocuidad alimentaria.
- **Decisión:** incorporada a los antecedentes y al procedimiento metodológico del perfil.

### EVA-02 — Retiros simulados como complemento metodológico

**Fuente:** Randrup et al. (2008). *Simulated recalls of fish products in five Nordic countries*. [DOI](https://doi.org/10.1016/j.foodcont.2007.11.005).

- **Aporte potencial:** complementa la evidencia sobre pruebas de recuperación de trazas en distintos actores.
- **Uso previsto:** marco metodológico del documento final si se necesita triangulación adicional.
- **Límite:** no es necesaria en el perfil mientras Donnelly et al. (2012) cubra el principio; lectura completa pendiente.

### EVA-03 — Diagnóstico del desempeño de trazabilidad

**Fuente:** Mgonja, Luning y Van der Vorst (2013). *Diagnostic model for assessing traceability system performance in fish processing plants*. [DOI](https://doi.org/10.1016/j.jfoodeng.2013.04.009).

- **Aporte potencial:** permite fundamentar que el desempeño de trazabilidad requiere dimensiones y mediciones explícitas.
- **Uso previsto:** refinamiento de métricas, discusión de resultados y límites de evaluación.
- **Límite:** el modelo y sus dimensiones deben revisarse antes de adaptarlos al piloto pequeño de R3Foresta.

### LIM-01 — Diferencia entre enlaces observados e inferidos

**Fuente:** Terriault, E. (2022). *Predicting Hidden Links in Informal Palm Oil Supply Chains* [Tesis, Polytechnique Montréal]. [Texto](https://publications.polymtl.ca/10756/1/2022_EvaTerriault.pdf).

- **Aporte potencial:** ayuda a discutir que una relación inferida no equivale a un evento observado y que no puede reconstruirse con certeza lo que nunca se registró.
- **Uso previsto:** limitaciones, calidad de evidencia y trabajo futuro.
- **Límite:** no se utilizará para atribuir certeza a enlaces inferidos; lectura completa y normalización de la referencia pendientes.

## 5. Vacíos de lectura y próximas decisiones

Antes de redactar el marco teórico definitivo se debe:

- revisar íntegramente EVT-05, GEN-03, GEN-04, GEN-05, INT-04, EVA-02, EVA-03 y LIM-01;
- normalizar en APA 7 las referencias que aún solo tienen metadatos parciales;
- decidir si el modelo propio se comparará formalmente con EPCIS/UNTP o si estos quedarán como referentes descriptivos;
- separar las reglas de identidad y genealogía de las reglas de balance o conciliación;
- derivar de cada fuente seleccionada una afirmación concreta y una limitación, evitando citas ornamentales.

## 6. Criterio de cierre

Esta biblioteca no debe copiarse completa al perfil ni al documento final. Cada capítulo incorporará únicamente las fuentes que sostengan su argumento, y su bibliografía contendrá solo las obras efectivamente citadas.
