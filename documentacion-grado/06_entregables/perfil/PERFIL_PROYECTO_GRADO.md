# Sistema de trazabilidad del material vegetal para reforestación con proyección hacia bonos de carbono: caso R3Foresta

## Índice general

<!-- toc -->

- [1. Introducción](#1-introducción)
- [2. Antecedentes](#2-antecedentes)
- [3. Planteamiento del problema](#3-planteamiento-del-problema)
- [4. Objetivos](#4-objetivos)
- [5. Justificación](#5-justificación)
- [6. Alcances y límites](#6-alcances-y-límites)
- [7. Marco teórico preliminar](#7-marco-teórico-preliminar)
- [8. Marco Metodológico](#8-marco-metodológico)
- [9. Índice tentativo](#9-índice-tentativo)
- [10. Cronograma de actividades](#10-cronograma-de-actividades)
- [11. Referencias bibliográficas](#11-referencias-bibliográficas)
- [12. Anexos](#12-anexos)

<!-- tocstop -->

<!-- Índice regenerable a partir de los encabezados Markdown; no editar sus entradas de forma aislada. -->

## 1. Introducción

La reforestación moviliza material vegetal entre lugares, responsables y etapas con propósitos distintos. Una semilla o unidad de propagación puede ser recolectada, trasladada al vivero, atravesar procesos biológicos, integrarse en lotes de plantas y finalmente ser asignada a una actividad de plantación. R3Foresta también utiliza material vegetal adquirido o recibido de terceros, que puede ingresar al vivero o dirigirse directamente a una plantación. En cualquiera de estos recorridos es necesario conservar la relación entre la procedencia, las cantidades, los responsables, las fechas, las ubicaciones y las evidencias. En adelante, se utilizará *material vegetal* como denominación general para las semillas, plantas y demás unidades de propagación comprendidas en estas etapas.

La trazabilidad no consiste únicamente en almacenar inventarios, formularios o fotografías de forma aislada. Requiere conservar la información y las relaciones necesarias para reconstruir el recorrido de un objeto a través de las etapas de una cadena (Olsen & Borit, 2013). En una cadena de custodia, además, los movimientos y cambios deben registrarse bajo reglas explícitas; sin embargo, la existencia de un sistema no demuestra por sí sola la veracidad de las declaraciones registradas (International Organization for Standardization, 2020). Por ello, el proyecto plantea registros reconstruibles con evidencia contrastable y no una certificación independiente de los hechos físicos.

El caso corresponde a la **Fundación R3Foresta para la Bioregeneración de Ecosistemas y la Economía Circular**, que desarrolla actividades de reforestación con comunidades, voluntarios y organizaciones patrocinadoras. Actualmente, la información y las evidencias de estas actividades se conservan en fotografías, publicaciones en redes sociales, conversaciones de mensajería, cuadernos, notas y el conocimiento de las personas involucradas. Aunque estas fuentes documentan las actividades realizadas, se encuentran dispersas y no comparten una estructura, identificadores ni relaciones comunes para reconstruir de extremo a extremo el recorrido del material vegetal, conciliar cantidades y saldos, identificar responsables y recuperar la evidencia asociada.

Ante esta situación, el proyecto desarrollará un sistema de trazabilidad como componente operativo de **R3foresta App**, desde la recolección o recepción externa del material vegetal hasta el registro de su plantación. La solución comprenderá los módulos de **Recolección, Vivero y Plantación**. El material adquirido o recibido de terceros se tratará como una variante de ingreso en Vivero o Plantación y conservará sus datos de procedencia, sin constituir un módulo adicional.

R3foresta App representa una pieza fundamental para la gestión de la Fundación porque organiza la cadena operativa que comienza con el origen del material vegetal y concluye con su plantación. La relación transparente entre procedencia, movimientos, cantidades, responsables, ubicaciones y evidencias permitirá reconstruir la cadena de custodia, respaldar la gestión interna y presentar información consistente ante patrocinadores, aliados y otros actores. La proyección hacia bonos de carbono señalada en el título se limita al posible uso posterior de estos registros dentro de procesos institucionales que requerirían metodología, cuantificación, monitoreo y verificación independientes; dichos procesos no forman parte del producto académico.

El alcance concluye con el registro de la plantación. El sistema no realiza monitoreo posterior de supervivencia, no mide captura de dióxido de carbono, no implementa una metodología de monitoreo, reporte y verificación de carbono, no certifica plantaciones y no genera, emite ni comercializa bonos o créditos de carbono.

## 2. Antecedentes

### 2.1. Antecedentes institucionales

R3Foresta fue creada en 2019 como una iniciativa y plataforma de acción socioambiental orientada a la bioregeneración de ecosistemas estratégicos y al fortalecimiento de las comunidades vinculadas con ellos. Su modelo evolucionó desde la acción ambiental directa hacia la integración de reforestación, agua, biodiversidad, residuos, alimentación, tecnología y comunidades. Actualmente articula las dimensiones ecológica, comunitaria, científico-tecnológica y económica mediante los componentes R3Carbon, R3Water, R3Bio y R3F10 — Reciclaje y Economía Circular (R3Foresta, 2026).

**Figura 1. Estructura organizacional de R3Foresta.**

![Organigrama institucional de R3Foresta](figuras/organigrama_r3foresta.png)

*Fuente: organigrama institucional proporcionado por la Fundación R3Foresta.*

En la dimensión científico-tecnológica, R3Foresta integra medición, monitoreo, trazabilidad, digitalización e innovación. Dentro de R3Carbon desarrolla **R3foresta App**, destinada a registrar y relacionar el recorrido del material vegetal desde la recolección de semillas o su recepción externa, pasando por el manejo en vivero, hasta el registro de su plantación. Esta función convierte a la aplicación en la base operativa de la cadena de custodia del material vegetal y organiza la información y las evidencias utilizadas por la Fundación para su gestión y rendición de cuentas.

### 2.2. Antecedentes internacionales

En Perú, Salamanca Contreras (2024) implementó un sistema web para el control interno y el seguimiento del inventario de un vivero comercial. El trabajo abordó la administración de existencias y despachos y reportó mejoras en la exactitud del inventario. Su aporte demuestra la utilidad de centralizar los movimientos de un vivero, pero su alcance permanece en la gestión comercial interna y no reconstruye la procedencia del material ni su transferencia hacia actividades de reforestación.

En Ecuador, Mayorga Vásquez et al. (2022) propusieron un sistema web para los procesos administrativos y productivos de viveros. La solución integró información de producción y administración, mostrando que estos procesos pueden gestionarse mediante una plataforma común. Su diferencia respecto de R3foresta App radica en que no relaciona de extremo a extremo la recolección o recepción externa, el manejo en vivero y la evidencia geográfica de la plantación.

En el ámbito internacional de la trazabilidad, Thakur et al. (2011) utilizaron eventos para representar estados, movimientos y transformaciones dentro de una cadena y separar los datos maestros de los hechos ocurridos. Este antecedente aporta un mecanismo para conservar relaciones históricas y recuperar el recorrido de unidades identificadas. Su dominio es agroalimentario y no contempla los cambios biológicos, las unidades de medida ni las reglas operativas propias del material vegetal utilizado por R3Foresta.

### 2.3. Antecedentes en Bolivia

Quispe Tola y Condori Zapana (2020) desarrollaron para la Autoridad de Fiscalización y Control Social de Bosques y Tierra un sistema de inventario y registro de iniciativas de manejo integral sustentable de los bosques y la Madre Tierra. La solución centralizó el registro de iniciativas e incorporó consultas, mapas y reportes por niveles. Su unidad principal es la iniciativa o proyecto forestal, por lo que no registra la cadena operativa de semillas y plantas ni las relaciones entre recolección, vivero y plantación.

### 2.4. Antecedentes en La Paz

Limachi Mamani (2020) desarrolló un sistema de registro y geolocalización de viveros para la Autoridad de Fiscalización y Control Social de Bosques y Tierra en el departamento de La Paz. El sistema administra viveros, especies y volúmenes de producción y ofrece una vista espacial para apoyar decisiones. Su unidad principal es el vivero, de modo que no reconstruye el recorrido de cada conjunto de material vegetal desde su procedencia hasta la plantación.

Valdez Alvarado (2023) desarrolló un sistema web para la gestión y control de viveros de la Unidad de Forestación del Gobierno Autónomo Municipal de El Alto. La solución centralizó información sobre plantines, responsables, solicitudes y plantaciones y permitió conocer el estado de los plantines durante su crecimiento. Este trabajo es el antecedente local más cercano al recorrido Vivero–Plantación; R3foresta App se diferencia al incorporar también la Recolección, la recepción externa, la cadena de custodia y las relaciones necesarias para reconstruir el origen, los movimientos, las cantidades y las evidencias.

En conjunto, los trabajos revisados resuelven partes del problema: inventarios de vivero, geolocalización, producción, solicitudes, iniciativas forestales o representación de eventos. No se identificó, dentro del alcance de la búsqueda, una solución que integre la procedencia propia o externa del material vegetal, sus movimientos y cambios entre Recolección, Vivero y Plantación, la consistencia de cantidades y saldos y la evidencia vinculada con el destino. Esta conclusión se limita a las fuentes revisadas y no afirma la inexistencia absoluta de soluciones similares.

## 3. Planteamiento del problema

### 3.1. Situación problemática

R3Foresta realiza actividades de reforestación con comunidades, voluntarios y organizaciones patrocinadoras. La información y las evidencias de estas actividades se conservan actualmente en fotografías, publicaciones en redes sociales, conversaciones de mensajería, cuadernos, notas y el conocimiento de las personas involucradas. Estos registros se encuentran dispersos y no comparten una estructura, identificadores ni relaciones comunes que permitan reconstruir de extremo a extremo la procedencia y el recorrido del material vegetal, las cantidades administradas, los responsables de cada etapa, las ubicaciones y las evidencias asociadas.

El material vegetal utilizado por R3Foresta puede ser de origen propio o externo. En el primer caso, la organización recolecta semillas u otro material de propagación, lo traslada al vivero, registra los procesos biológicos y obtiene plantas destinadas a la plantación. En el segundo, adquiere o recibe plantas y otros materiales vegetales de proveedores o terceros, que pueden ingresar al vivero o dirigirse directamente a una plantación. En ambos casos, la cadena requiere relacionar la procedencia, la especie, las cantidades, las fechas, los responsables y las evidencias con los hechos posteriores hasta el destino del material.

Durante este recorrido cambian la ubicación, el responsable, el estado, la agrupación y, en determinados procesos, la unidad de medida del material vegetal. Las semillas recolectadas pueden registrarse en gramos o unidades de propagación, mientras que el saldo vivo del vivero y la plantación se expresa en unidades de plantas. El paso de semillas a plantas no constituye una conversión aritmética automática, sino un resultado biológico observado. El proceso también comprende mermas, descartes, devoluciones, cierres, transferencias y asignaciones parciales.

Actualmente, las entradas, salidas, transformaciones, transferencias y modificaciones de saldo se documentan en fuentes separadas y no conforman un historial común que explique cada cambio. Esta fragmentación dificulta conciliar las cantidades entre etapas, determinar la disponibilidad real del material y reconocer registros incompletos, asignaciones repetidas o consumos duplicados. De igual manera, las fotografías, fechas o coordenadas almacenadas fuera del hecho operativo quedan desvinculadas de la especie, la cantidad, el responsable y la actividad que deben respaldar.

Como consecuencia, la reconstrucción de una cadena de custodia exige buscar y contrastar manualmente diferentes fuentes y recurrir a la memoria de las personas involucradas. Esto incrementa el tiempo necesario para responder consultas, favorece omisiones y contradicciones y dificulta determinar qué material se encontraba disponible, qué cantidades se perdieron o trasladaron, quién fue responsable de cada movimiento y cuál fue el destino registrado. La dispersión también limita la elaboración de reportes consistentes y la capacidad de explicar los saldos entre las etapas de Recolección, Vivero y Plantación.

La misma situación afecta la rendición de cuentas. R3Foresta dispone de evidencias sobre sus actividades, pero no de una cadena informacional común que las vincule sistemáticamente con el origen, los responsables, las cantidades y el destino del material vegetal. En consecuencia, la Fundación tiene menor capacidad para presentar a patrocinadores, aliados y comunidades un recorrido transparente y contrastable, y carece de una base operativa consolidada para procesos institucionales posteriores que requieran demostrar la cadena de suministro. El proyecto no realizará esos procesos posteriores, pero atiende la información fundamental que los precede.

El árbol de causas y efectos que sintetiza esta situación se presenta en el **Anexo A**.

### 3.2. Problema central

> En la práctica actual de R3Foresta, la información sobre la procedencia, los movimientos, las transformaciones, las cantidades, los responsables, las evidencias y el destino del material vegetal de origen propio o externo se conserva en registros dispersos que no comparten una estructura, identificadores ni relaciones comunes; esta fragmentación limita la reconstrucción de la cadena de custodia, la consistencia de cantidades y saldos y la presentación de evidencia contrastable a los actores interesados.

### 3.3. Formulación del problema

#### Pregunta general

> ¿Cómo asegurar, en el caso de R3Foresta, la trazabilidad de la cadena de custodia del material vegetal desde su recolección o recepción externa, pasando por el vivero, hasta el registro de su plantación, de manera que puedan reconstruirse su procedencia, movimientos, cantidades, responsables, evidencias y destino?

#### Preguntas específicas

1. ¿Qué procesos, actores, datos, estados, eventos, unidades de medida, requerimientos y reglas de negocio caracterizan Recolección, Vivero y Plantación, incluidas las variantes de ingreso de material vegetal adquirido o recibido de terceros?
2. ¿Qué modelo de trazabilidad e integridad permite relacionar orígenes, entidades, eventos, transformaciones, cantidades, saldos, responsables y evidencias, y formalizar las reglas aplicables a las transferencias y transformaciones entre etapas?
3. ¿Cómo implementar e integrar los módulos de Recolección, Vivero y Plantación, incorporando el ingreso de material vegetal adquirido o recibido de terceros directamente en Vivero o Plantación, con sus datos de procedencia y su registro en el historial?
4. ¿En qué medida la solución cumple los requerimientos y preserva las invariantes definidas mediante pruebas funcionales y técnicas?
5. ¿Qué capacidad presenta la solución, en el contexto del estudio de caso, para reconstruir trazas con evidencia contrastable y qué carga operativa genera en comparación con la práctica actual caracterizada en R3Foresta?

## 4. Objetivos

### 4.1. Objetivo general

Desarrollar un sistema de trazabilidad para la cadena de custodia del material vegetal utilizado por R3Foresta, desde su recolección o recepción externa hasta el registro de la plantación, con información relacionada sobre procedencia, movimientos, cantidades, responsables, evidencias y destino.

### 4.2. Objetivos específicos

1. **Analizar** los procesos, actores, datos, estados, eventos, unidades de medida, requerimientos y reglas de negocio de Recolección, Vivero y Plantación, incluidas las variantes de ingreso de material vegetal adquirido o recibido de terceros.
2. **Diseñar** un modelo de trazabilidad e integridad que relacione orígenes, entidades, eventos, transformaciones, cantidades, saldos, responsables y evidencias, y que formalice las reglas aplicables a las transferencias y transformaciones entre etapas.
3. **Implementar** los módulos de Recolección, Vivero y Plantación, incorporando el ingreso de material vegetal adquirido o recibido de terceros directamente en Vivero o Plantación, con sus datos de procedencia y su registro en el historial.
4. **Verificar** el cumplimiento de los requerimientos y de las invariantes de consistencia mediante pruebas funcionales y técnicas.
5. **Evaluar**, en el contexto del estudio de caso, la capacidad de reconstrucción con evidencia contrastable y la carga operativa de la solución, comparándolas con la práctica actual caracterizada en R3Foresta.

## 5. Justificación

R3Foresta necesita reconstruir el recorrido del material vegetal que recibe o produce para conocer su procedencia, las cantidades disponibles, las pérdidas ocurridas, las asignaciones y transferencias realizadas y su destino final. Cuando esta información se conserva en registros y evidencias independientes, resulta difícil establecer posteriormente qué ocurrió con una cantidad o lote a medida que atravesó las etapas de Recolección, Vivero y Plantación. Por ello, la organización requiere una cadena informacional común que relacione el origen, los movimientos y el destino del material vegetal.

La solución es necesaria desde el punto de vista operativo porque permitirá que los registros de cada módulo formen parte de un mismo recorrido. La procedencia, las cantidades, los responsables, las fechas, las ubicaciones y las evidencias podrán consultarse de forma relacionada, reduciendo la dependencia de búsquedas manuales y de la memoria de las personas. Esta capacidad fortalecerá la toma de decisiones sobre disponibilidad, movimientos, pérdidas y destino del material.

Desde la perspectiva institucional, R3foresta App constituye la base operativa para transparentar la cadena de suministro del material vegetal. La Fundación podrá respaldar con información consistente las actividades comunicadas a comunidades, voluntarios, patrocinadores y aliados. Una cadena de custodia organizada es además un insumo fundamental para eventuales procesos posteriores de verificación o certificación; sin embargo, el sistema académico no ejecutará esos procesos ni afirmará que la información registrada equivale a una certificación.

Desde la perspectiva tecnológica y académica, el proyecto relacionará el análisis del dominio con un modelo de trazabilidad, reglas de integridad, tres módulos integrados y evidencia de verificación. Su desarrollo permitirá aplicar principios de Ingeniería de Software a un caso real en el que las unidades cambian de estado, cantidad, agrupación y responsabilidad. Los beneficios de tiempo, carga o calidad de información no se asumirán de antemano, sino que corresponderán al objetivo específico de evaluación del documento final.

## 6. Alcances y límites

### 6.1. Alcance funcional

El alcance funcional comprende exclusivamente los siguientes tres módulos:

1. **Recolección.** Registrará el origen del material vegetal recolectado por R3Foresta. Incluirá la especie, la cantidad y unidad de medida, la fecha, el responsable, la ubicación y la evidencia disponible. Permitirá identificar el lote de origen y documentar su entrega o transferencia al vivero. El módulo comenzará con el registro de la actividad de recolección y concluirá con el cierre del lote o su vinculación con el material recibido en Vivero.

2. **Vivero.** Registrará la recepción y el manejo del material vegetal procedente de Recolección o adquirido o recibido de terceros. Para los ingresos externos conservará el tipo de ingreso, el proveedor u organización de procedencia, la especie, la cantidad y unidad, la fecha, el responsable y la evidencia documental disponible. Durante el manejo registrará los hechos biológicos y operativos observados, las mermas, los descartes, los cambios de cantidad, el saldo vivo y la salida o asignación hacia Plantación. El módulo concluirá con el despacho, cierre o agotamiento explicado del material.

3. **Plantación.** Registrará el material procedente de Vivero y el material externo que se dirija directamente a una actividad de plantación. Relacionará la asignación con la campaña o subcampaña correspondiente y conservará la cantidad recibida, plantada, devuelta o descartada, los responsables, la fecha, la ubicación y la evidencia disponible. El módulo concluirá con el registro de la plantación y permitirá consultar la procedencia y el recorrido relacionado del material utilizado.

Los tres módulos compartirán identificadores y relaciones suficientes para reconstruir el recorrido del material vegetal. El historial distinguirá los movimientos entre responsables o etapas de los cambios biológicos u operativos que modifican cantidades o unidades, y permitirá explicar los saldos a partir de los registros relacionados. La recepción externa permanecerá como variante de Vivero o Plantación y no constituirá un cuarto módulo.

### 6.2. Límites

- El alcance temporal del material vegetal concluye con el registro de la plantación. No comprende monitoreo posterior, mantenimiento, crecimiento, reposición ni seguimiento de supervivencia.
- El sistema no calcula biomasa, dióxido de carbono equivalente, adicionalidad, permanencia ni líneas base de carbono y no implementa una metodología de monitoreo, reporte y verificación.
- El proyecto no certifica plantaciones y no genera, emite, certifica ni comercializa bonos o créditos de carbono.
- Las fotografías, coordenadas, fechas y documentos respaldan el registro con el que se relacionan, pero no constituyen autenticación forense ni certificación independiente del hecho físico.
- Blockchain, NFT, contratos inteligentes, IPFS, anclajes criptográficos y componentes equivalentes quedan fuera del aporte académico, de la verificación y de los resultados.
- No se implementarán integraciones con mercados de carbono, certificadoras o plataformas externas de intercambio de créditos.
- El producto se desarrollará para el caso y los procesos de R3Foresta; no incluye una operación nacional, un despliegue masivo ni la generalización automática a otras organizaciones.

## 7. Marco teórico preliminar

### 7.1. Sistema

Un sistema es un conjunto de elementos interrelacionados o que interactúan entre sí (International Organization for Standardization, 2026). En el proyecto, el término se refiere a una solución de software cuyos módulos, datos, reglas y usuarios actúan de forma coordinada para registrar el recorrido del material vegetal. La utilidad del sistema no depende únicamente de cada módulo por separado, sino de las relaciones que permiten explicar el paso de la información entre Recolección, Vivero y Plantación.

### 7.2. Trazabilidad

La trazabilidad es la capacidad de acceder a información relacionada con un objeto a lo largo de su ciclo de vida o de las etapas definidas para su seguimiento (Olsen & Borit, 2013). Moe (1998) diferencia la trazabilidad interna de aquella que enlaza diferentes etapas de una cadena, mientras que Dabbene et al. (2014) destacan la importancia de la identificación, la granularidad y la recuperación de las relaciones históricas. En R3Foresta, la trazabilidad abarcará desde la recolección o recepción externa hasta el registro de la plantación.

### 7.3. Material vegetal

La Organización de las Naciones Unidas para la Alimentación y la Agricultura incluye dentro del material reproductivo forestal las semillas, las partes de plantas y las plantas producidas a partir de ellas. Para iniciativas forestales recomienda documentar la fuente, la cantidad, los tratamientos, la distribución y los lugares donde el material se utiliza, además de conservar información del proveedor cuando es adquirido (Food and Agriculture Organization of the United Nations, s. f.). En este proyecto, *material vegetal* comprende esas unidades durante el periodo definido por el alcance.

### 7.4. Reforestación

La reforestación corresponde al restablecimiento de bosque mediante plantación o siembra deliberada en terrenos clasificados como bosque (Food and Agriculture Organization of the United Nations, 2023). Para este proyecto, el término delimita el propósito de las actividades en las que se utiliza el material vegetal, pero no implica que el sistema mida recuperación ecológica, supervivencia o captura de carbono. El producto registra la plantación como último hecho de la cadena operativa considerada.

### 7.5. Bonos de carbono

En el título, la expresión *bonos de carbono* se emplea como denominación usual de los créditos asociados con reducciones o remociones cuantificadas de gases de efecto invernadero. En el programa Verified Carbon Standard, por ejemplo, cada unidad verificada representa una tonelada métrica de dióxido de carbono equivalente reducida o removida y su emisión depende de procesos de validación, verificación y revisión (Verra, s. f.). La proyección indicada en el título es institucional y futura: la trazabilidad del material vegetal podría aportar registros de procedencia y de actividad de plantación, pero el sistema académico no cuantifica reducciones o remociones, no implementa una metodología de carbono ni produce unidades acreditadas.

### 7.6. Cadena de custodia

La cadena de custodia conserva la relación entre el material, los actores responsables y los movimientos o cambios registrados durante un recorrido. ISO 22095:2020 proporciona terminología y modelos generales para representar cadenas de custodia y advierte que un sistema de este tipo no demuestra por sí solo la veracidad de las declaraciones incorporadas (International Organization for Standardization, 2020). En R3Foresta, la cadena de custodia se utilizará para relacionar la procedencia, las cantidades, los responsables, las evidencias y el destino del material vegetal, sin atribuir al sistema funciones de certificación.

## 8. Marco Metodológico

### 8.1. Proceso Unificado Ágil

El desarrollo utilizará el **Proceso Unificado Ágil**, adaptación ligera del Proceso Unificado que conserva un ciclo de vida por fases y un trabajo iterativo dentro de cada fase. Ambler (2005) caracteriza el Proceso Unificado mediante las fases de Inicio, Elaboración, Construcción y Transición, con actividades de requisitos, análisis, diseño, implementación, pruebas, despliegue, gestión de cambios y seguimiento que se ejecutan con distinta intensidad a lo largo del proyecto.

Esta metodología se selecciona porque permite organizar un proyecto académico individual sin reducirlo a una sucesión genérica de incrementos. Sus fases proporcionan hitos verificables; su carácter iterativo permite revisar requisitos y modelos a medida que se construyen los módulos; y su orientación a riesgos es pertinente para las relaciones entre cantidades, saldos, transferencias y transformaciones. La adaptación conservará únicamente las actividades y productos necesarios para el alcance de R3foresta App, de acuerdo con el principio de adecuar el proceso al proyecto (Ambler, 2005).

### 8.2. Aplicación al proyecto

**Tabla 1. Aplicación del Proceso Unificado Ágil.**

| Fase | Actividades principales | Productos e hito de cierre |
|---|---|---|
| Inicio | Delimitar el problema, los actores, los tres módulos, los ingresos externos, los requisitos iniciales y los riesgos | Visión, alcance, glosario, lista inicial de requisitos y aprobación del alcance |
| Elaboración | Detallar procesos y reglas; diseñar el modelo de trazabilidad, la arquitectura, las relaciones entre etapas y las pruebas críticas | Modelo de dominio y trazabilidad, arquitectura base, requisitos priorizados y revisión de viabilidad técnica |
| Construcción | Implementar e integrar Recolección, Vivero y Plantación; ejecutar pruebas funcionales y técnicas; corregir defectos y documentar decisiones | Incrementos operativos, integraciones, migraciones, matriz requisito–prueba y versión candidata |
| Transición | Preparar el despliegue, ejecutar la verificación y evaluación previstas en los objetivos específicos, ajustar la solución y consolidar la documentación | Versión final, evidencia de resultados, manuales, conclusiones y entrega académica |

En cada fase se aplicarán, según corresponda, actividades de requisitos, análisis y diseño, implementación, pruebas, gestión de configuración y documentación. Los procesos de ciclo de vida de software y las prácticas de Ingeniería de Software servirán como referencias para seleccionar y controlar estas actividades (International Organization for Standardization et al., 2026; IEEE Computer Society, 2025).

### 8.3. Seguimiento y evidencia

El trabajo se organizará mediante una lista priorizada vinculada con los objetivos específicos. Cada elemento deberá identificar el requisito o regla atendida, el cambio realizado, la prueba o revisión aplicada y la evidencia disponible. Al cierre de cada fase se revisarán los productos previstos y se registrarán decisiones, riesgos, desviaciones y ajustes al plan.

La construcción partirá de una referencia inicial académica del repositorio. Los prototipos anteriores podrán utilizarse como referencia técnica y evidencia de factibilidad, pero no como construcción formal ni como objetivos cumplidos. El postulante será responsable del análisis, diseño, implementación y documentación; los colaboradores y agentes de inteligencia artificial brindarán apoyo delimitado bajo revisión y responsabilidad autoral humana.

## 9. Índice tentativo

```text
Resumen
Palabras clave

Introducción

Capítulo I — Marco introductorio
  1.1 Antecedentes institucionales y trabajos similares
  1.2 Planteamiento del problema
  1.3 Objetivos
  1.4 Justificación
  1.5 Alcances y límites
  1.6 Diseño metodológico
  1.7 Organización del documento

Capítulo II — Marco teórico y conceptual
  2.1 Material vegetal y procesos de reforestación
  2.2 Trazabilidad y cadena de custodia
  2.3 Eventos, transformaciones y procedencia
  2.4 Integridad de cantidades y saldos
  2.5 Evidencia e información geográfica
  2.6 Reconstrucción y evaluación de la trazabilidad
  2.7 Bonos de carbono y alcance de la proyección
  2.8 Síntesis conceptual adoptada

Capítulo III — Marco aplicativo
  3.1 Análisis de procesos, actores y requisitos
  3.2 Diseño del modelo de trazabilidad e integridad
  3.3 Implementación e integración de los tres módulos
  3.4 Verificación funcional y técnica
  3.5 Evaluación de la solución
  3.6 Presentación y discusión de resultados

Conclusiones
Recomendaciones
Referencias bibliográficas
Anexos
```

**Tabla 2. Correspondencia entre objetivos y secciones del documento final.**

| Objetivo específico | Resultado principal | Ubicación prevista |
|---|---|---|
| 1. Analizar | Procesos, actores, requisitos y reglas definidos | Capítulo III, sección 3.1 |
| 2. Diseñar | Modelo de trazabilidad, relaciones e invariantes | Capítulo III, sección 3.2 |
| 3. Implementar | Recolección, Vivero y Plantación integrados | Capítulo III, sección 3.3 |
| 4. Verificar | Matriz de pruebas y resultados técnicos | Capítulo III, sección 3.4 |
| 5. Evaluar | Reconstrucción, evidencia y carga operativa analizadas | Capítulo III, secciones 3.5 y 3.6 |

## 10. Cronograma de actividades

El cronograma se organiza por objetivos específicos. Se propone como inicio formal el **6 de julio de 2026**, dentro de la primera semana de julio, sujeto a ratificación dla Doctora Tellez. Mientras no exista una fecha distinta confirmada, los periodos siguientes se utilizarán como planificación de trabajo del Perfil.

**Tabla 3. Cronograma por objetivos.**

| Periodo | Objetivo o actividad | Actividades principales | Producto verificable |
|---|---|---|---|
| 6–24 jul | Objetivo 1 — Analizar | Procesos, actores, datos, estados, unidades, requisitos, reglas e ingresos externos | Especificación del dominio y requisitos priorizados |
| 27 jul–14 ago | Objetivo 2 — Diseñar | Modelo de trazabilidad, arquitectura, relaciones entre etapas, cantidades, saldos e invariantes | Modelo de diseño y arquitectura base |
| 17 ago–2 oct | Objetivo 3 — Implementar | Recolección, Vivero, Plantación, ingresos externos e integración entre módulos | Tres módulos integrados y versión candidata |
| 5–23 oct | Objetivo 4 — Verificar | Pruebas funcionales, de integración, consistencia y reconstrucción | Matriz requisito–prueba y resultados técnicos |
| 26 oct–8 nov | Objetivo 5 — Evaluar | Reconstrucción de trazas, valoración de la evidencia disponible y análisis de carga operativa | Resultados de evaluación y contraste descriptivo |
| 9–15 nov | Cierre transversal | Consolidación del documento, conclusiones, recomendaciones, referencias y anexos | Documento final para revisión |

**Figura 2. Diagrama de Gantt por objetivos, julio–noviembre de 2026.**

```mermaid
gantt
    title Perfil y Proyecto de Grado — cronograma por objetivos
    dateFormat YYYY-MM-DD
    axisFormat %d/%m

    section Objetivos
    Objetivo 1 · Analizar     :o1, 2026-07-06, 19d
    Objetivo 2 · Diseñar      :o2, 2026-07-27, 19d
    Objetivo 3 · Implementar  :o3, 2026-08-17, 47d
    Objetivo 4 · Verificar    :o4, 2026-10-05, 19d
    Objetivo 5 · Evaluar      :o5, 2026-10-26, 14d

    section Cierre
    Documento final          :crit, cierre, 2026-11-09, 7d

    section Transversal
    Documentación y seguimiento :doc, 2026-07-06, 2026-11-16
```

## 11. Referencias bibliográficas

Ambler, S. W. (2005). *A manager’s introduction to the Rational Unified Process (RUP).* Ambysoft. https://ambysoft.com/downloads/managersIntroToRUP.pdf

Dabbene, F., Gay, P., & Tortia, C. (2014). Traceability issues in food supply chain management: A review. *Biosystems Engineering, 120*, 65–80. https://doi.org/10.1016/j.biosystemseng.2013.09.006

Food and Agriculture Organization of the United Nations. (2023). *Terms and definitions: FRA 2025* (Forest Resources Assessment Working Paper No. 194). https://www.fao.org/3/cc4691en/cc4691en.pdf

Food and Agriculture Organization of the United Nations. (s. f.). *Forest reproductive material*. Sustainable Forest Management Toolbox. Recuperado el 19 de agosto de 2026, de https://www.fao.org/sustainable-forest-management-toolbox/modules/forest-reproductive-material/en

IEEE Computer Society. (2025). *Guide to the Software Engineering Body of Knowledge (SWEBOK Guide), version 4.0a*. https://www.computer.org/education/bodies-of-knowledge/software-engineering/v4

International Organization for Standardization. (2020). *Chain of custody—General terminology and models* (ISO Standard No. 22095:2020). https://www.iso.org/standard/72532.html

International Organization for Standardization. (2026). *Quality management—Fundamentals and vocabulary* (ISO Standard No. 9000:2026). https://www.iso.org/standard/9000

International Organization for Standardization, International Electrotechnical Commission, & Institute of Electrical and Electronics Engineers. (2026). *Systems and software engineering—Software life cycle processes* (ISO/IEC/IEEE Standard No. 12207:2026). https://www.iso.org/standard/90219.html

Limachi Mamani, F. Z. (2020). *Sistema de registro geolocalización de viveros en el departamento de La Paz. Caso ABT* [Proyecto de grado, Universidad Pública de El Alto]. https://repositorio.upea.bo/jspui/handle/123456789/172

Mayorga Vásquez, L. C., Riccardi Martillo, G. A., Bermeo Almeida, O. X., & Guevara Arias, V. I. (2022). Sistema web para los procesos administrativos y de producción en viveros del cantón Milagro. *Revista Ingeniería, 6*(16), 200–213. https://doi.org/10.33996/revistaingenieria.v6i16.100

Moe, T. (1998). Perspectives on traceability in food manufacture. *Trends in Food Science & Technology, 9*(5), 211–214. https://doi.org/10.1016/S0924-2244(98)00037-5

Olsen, P., & Borit, M. (2013). How to define traceability. *Trends in Food Science & Technology, 29*(2), 142–150. https://doi.org/10.1016/j.tifs.2012.10.003

Quispe Tola, M. R., & Condori Zapana, J. C. (2020). *Sistema inventario registro de iniciativas de manejo integral sustentables de los bosques y la Madre Tierra* [Proyecto de grado, Universidad Pública de El Alto]. https://repositorio.upea.bo/jspui/bitstream/123456789/64/1/PDG-MARLIEN%20RUTH%20QUISPE%20TOLA-JUAN%20CARLOS%20CONDORI%20ZAPANA.pdf

R3Foresta. (2026, 23 de agosto). *Resumen ejecutivo institucional: Modelo integral de bioregeneración, innovación ambiental y desarrollo comunitario* [Documento institucional no publicado].

Salamanca Contreras, F. R. (2024). *Influencia del sistema web con notificaciones en el proceso de control interno y seguimiento del inventario en el vivero Tu Semilla E.I.R.L. sede Tacna, 2022* [Tesis, Universidad Privada de Tacna]. https://repositorio.upt.edu.pe/handle/20.500.12969/3690

Thakur, M., Sørensen, C. F., Bjørnson, F. O., Forås, E., & Hurburgh, C. R. (2011). Managing food traceability information using EPCIS framework. *Journal of Food Engineering, 103*(4), 417–433. https://doi.org/10.1016/j.jfoodeng.2010.11.012

Valdez Alvarado, G. R. (2023). *Desarrollo de un sistema de información web para la gestión y control de viveros en la ciudad de El Alto. Caso: Unidad de Forestación del Gobierno Autónomo Municipal de El Alto* [Proyecto de grado, Universidad Pública de El Alto]. https://repositorio.upea.bo/jspui/bitstream/123456789/1019/1/PROYECTO%20DE%20GRADO%20-%20%20GADIEL%20RANDALL.pdf

Verra. (s. f.). *Verified carbon units (VCUs).* Recuperado el 25 de agosto de 2026, de https://verra.org/programs/verified-carbon-standard/verified-carbon-units-vcus/

## 12. Anexos

### Anexo A — Árbol de causas y efectos

**Figura A1. Árbol de causas y efectos de la situación problemática.**

```mermaid
flowchart BT
    C1["Registros dispersos en fotografías,<br/>mensajería, cuadernos,<br/>redes sociales y conocimiento de responsables"]
    C2["Ausencia de identificadores y<br/>relaciones comunes entre etapas"]
    C3["Ingresos externos y cambios de custodia<br/>sin un historial uniforme de procedencia"]
    C4["Entradas, salidas, transferencias y saldos<br/>registrados mediante operaciones separadas"]
    C5["Evidencia fotográfica, temporal o geográfica<br/>desvinculada del hecho operativo"]

    P(["PROBLEMA CENTRAL<br/><br/>La información sobre la procedencia y el recorrido<br/>del material vegetal de origen propio o externo<br/>no se encuentra integrada bajo una cadena de custodia<br/>reconstruible con evidencia contrastable"])

    E1["Mayor tiempo y menor completitud<br/>al reconstruir el recorrido del material vegetal"]
    E2["Inconsistencias en cantidades,<br/>saldos, transferencias y asignaciones"]
    E3["Decisiones operativas basadas<br/>en información incompleta"]
    E4["Menor capacidad para respaldar la información<br/>comunicada a patrocinadores y aliados"]

    C1 --> P
    C2 --> P
    C3 --> P
    C4 --> P
    C5 --> P
    P --> E1
    P --> E2
    P --> E3
    P --> E4
```

*Versión de contenido del Perfil actualizada el 25 de agosto de 2026. La fuente oficial se conserva únicamente en Markdown; no requiere una copia DOCX ni saltos de página después de cada encabezado principal.*
