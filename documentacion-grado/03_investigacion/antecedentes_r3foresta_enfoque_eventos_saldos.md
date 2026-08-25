# Estado del arte y antecedentes de R3Foresta

## Trazabilidad de material vegetal para reforestación mediante eventos, conservación de saldos e integración entre etapas

**Fecha de corte de la búsqueda:** 20 de julio de 2026; alineación con el perfil actualizada el 25 de agosto de 2026.

**Título seleccionado del perfil:** *Sistema de trazabilidad del material vegetal para reforestación con proyección hacia bonos de carbono: caso R3Foresta*.

> La búsqueda incluyó antecedentes sobre distintas procedencias y puntos de ingreso del material vegetal. Esos hallazgos siguen siendo aplicables. El perfil actual incorpora la adquisición o recepción de terceros en Vivero y Plantación como variantes integradas dentro de los tres módulos, sin convertirlas en un cuarto módulo o un entregable independiente.

> **Investigación complementaria:** las fuentes posteriores sobre eventos, genealogía, integridad y pruebas de reconstrucción se conservan en la [`biblioteca razonada`](biblioteca_fuentes_trazabilidad_eventos_integridad.md) y se recuperan mediante el [`índice temático`](../05_recursos/indice_fuentes_bibliograficas.md).

> **Criterio de vigencia:** este estado del arte estudia mecanismos como *append-only*, coordinación transaccional y *event sourcing* para comparar antecedentes. Su presencia en las fichas o matrices no compromete su adopción. El Perfil define propiedades de reconstrucción e integridad; la arquitectura se seleccionará y justificará posteriormente conforme a los [lineamientos vigentes](../01_lineamientos/base_perfil_proyecto_grado.md).

---

## 1. Delimitación respecto de la formulación anterior

La formulación vigente excluye blockchain, NFT, IPFS y bonos de carbono del alcance funcional. La mención de bonos de carbono en el título expresa únicamente una proyección institucional posterior. La comparación se organiza alrededor de seis problemas centrales:

1. Identificación del origen y procedencia del material forestal de reproducción.
2. Trazabilidad entre recolección, vivero y plantación.
3. Historial de eventos que permita explicar los cambios sin perder su relación con el material.
4. Conservación de cantidades y saldo vivo del lote.
5. Coherencia de cantidades y saldos durante transferencias y transformaciones entre módulos.
6. Evidencia fotográfica y geoespacial de origen y destino.

El informe anterior se conserva aparte como `antecedentes_r3foresta_enfoque_anterior_blockchain_carbono.md`.

## 2. Cómo se verificó que una fuente fuera académica

No se clasificó una fuente como académica solo porque apareciera en Google Scholar o tuviera un DOI. Se aplicaron los siguientes controles:

- **Artículos y actas:** título, autores, año, revista o conferencia, volumen/páginas y DOI se contrastaron en la editorial, el portal de la revista o un repositorio universitario. Cuando el portal declara revisión por pares, se señala expresamente.
- **Tesis y proyectos de grado:** se aceptaron cuando el archivo o ficha estaba alojado en el repositorio oficial de la universidad y mostraba carrera o programa, grado, autor, tutor/jurado y año. Una tesis es producción académica evaluada, aunque no equivale automáticamente a un artículo revisado por pares.
- **Normas, leyes y documentación pública:** se verificaron en ISO, GS1, OGC, FAO, OECD, EUR-Lex o portales gubernamentales. Son fuentes técnicas, normativas u oficiales, **no artículos académicos**.
- **Plataformas comerciales:** se verificaron en páginas del proveedor o de la organización responsable. Sus funciones son declaraciones institucionales o comerciales; cuando no existe publicación técnica independiente, se indica “tecnología no divulgada”.
- **Datos no comprobables:** no se infirió una blockchain, base de datos, lenguaje, GPS o mecanismo transaccional si la fuente no lo declara.

### Ruta de búsqueda y criterios de inclusión

- **Repositorios y portales regionales:** UMSA/DIPGIS, UPEA, Universidad Privada de Tacna, Universidad César Vallejo, Instituto Tecnológico de Costa Rica, Universidad Estatal de Bolívar, Universidad Agraria del Ecuador, ALICIA–CONCYTEC y Redalyc.
- **Literatura internacional:** portales de editoriales y revistas, DOI/Crossref, repositorios de DTU, Utrecht, Nofima, NIST, Universidad de Turín, Universidad de Lieja y organismos forestales.
- **Consultas en español:** combinaciones de “sistema trazabilidad vivero”, “cadena de custodia semillas forestales”, “material vegetal reforestación”, “inventario vivero”, “geolocalización viveros”, “eventos trazabilidad” y “saldo de lotes”.
- **Consultas en inglés:** combinaciones de “forest reproductive material traceability”, “seedlot provenance tracking”, “nursery inventory system”, “event sourcing traceability”, “EPCIS transformation event”, “geo-traceability” e “invariant conservation database”.
- **Inclusión:** relación directa con al menos una etapa o un mecanismo central de R3Foresta y metadatos comprobables en una fuente primaria.
- **Exclusión:** blogs sin autoría, agregadores sin enlace al original, documentos sin texto o metadatos verificables y páginas que repetían una misma publicación. Google Scholar/ALICIA se usaron para descubrimiento, no como sustitutos de la fuente original.

La búsqueda es una revisión de estado del arte orientada al proyecto, no una revisión sistemática PRISMA; por ello no se reportan conteos exhaustivos de todos los resultados descartados.

### Resultado específico para Bolivia y UMSA

Se buscaron combinaciones de *trazabilidad*, *material vegetal*, *semillas forestales*, *vivero*, *reforestación*, *eventos*, *inventario*, *geolocalización* y *sistemas de información*. Se halló un proyecto boliviano de Ingeniería de Sistemas directamente relacionado con viveros forestales en la UPEA y una tesis agronómica de la UMSA útil para comprender el tránsito vivero–campo. **No se localizó en los resultados públicamente indexados una tesis de Informática o Ingeniería de Sistemas de la UMSA que implemente la cadena completa recolección–vivero–plantación.** Esta afirmación describe el resultado de la búsqueda, no prueba su inexistencia; el repositorio institucional de la UMSA presentó disponibilidad e indexación irregular durante la consulta.

## 3. Trabajos académicos

### 3.1. Antecedentes bolivianos y latinoamericanos

### A1. Sistema de registro y geolocalización de viveros en el departamento de La Paz. Caso: ABT

- **Autor, año y tipo:** Félix Zenón Limachi Mamani, 2020; proyecto de grado de Ingeniería de Sistemas, Universidad Pública de El Alto (Bolivia).
- **Qué hace:** desarrolla un sistema web para registrar viveros, especies y volúmenes de producción, y ubicar geográficamente los viveros bajo el caso de estudio de la Autoridad de Fiscalización y Control Social de Bosques y Tierra.
- **Tecnologías declaradas:** PHP, Laravel, Bootstrap, MySQL y Apache; metodología UWE/UML, ISO 9126 y COCOMO II.
- **Similitudes:** mismo dominio forestal boliviano; catálogos de viveros y especies; inventario de producción y geolocalización.
- **Diferencia y vacío:** su unidad principal es el vivero, no el lote biológico a lo largo de su ciclo. No documenta captura de origen, historial *append-only*, saldo por eventos, despacho atómico a campañas ni validación del polígono de plantación.
- **Verificación académica:** PDF del repositorio oficial UPEA con portada institucional, carrera, autor, tutor, tribunales y año.
- **Referencia:** Limachi Mamani, F. Z. (2020). *Sistema de registro geolocalización de viveros en el departamento de La Paz. Caso ABT* [Proyecto de grado, Universidad Pública de El Alto]. [PDF institucional](https://repositorio.upea.bo/jspui/bitstream/123456789/1260/5/1.%20FINAL.pdf).

### A2. Evaluación del crecimiento de la Sup’u T’ula con tres niveles de vermicompost y sobrevivencia de plantines en Umala–La Paz

- **Autora, año y tipo:** Gisela Grecia Yujra Huanca, 2022; tesis de Ingeniería Agronómica, Universidad Mayor de San Andrés (Bolivia), aprobada en 2023.
- **Qué hace:** evalúa la producción de plantines de *Parastrephia lepidophylla* y su sobrevivencia después del traslado y establecimiento en campo. El trabajo aporta medidas de crecimiento, prendimiento y mortalidad en condiciones altoandinas.
- **Tecnologías declaradas:** diseño experimental agronómico, mediciones de vivero y seguimiento de supervivencia; no desarrolla software.
- **Similitudes:** material vegetal para restauración, transición vivero–campo, conteo de plantines y monitoreo posterior.
- **Diferencia y vacío:** estudia resultados biológicos, no la identidad y custodia digital del lote. R3Foresta puede vincular cada observación de supervivencia con procedencia, eventos de vivero, despacho y subcampaña.
- **Verificación académica:** tesis alojada en el portal de investigación de la UMSA, con portada, carrera, autora, asesores y tribunal.
- **Referencia:** Yujra Huanca, G. G. (2022). *Evaluación del crecimiento de la Sup’u T’ula (Parastrephia lepidophylla) con tres niveles de vermicompost en K’iphak’iphani–Viacha, y sobrevivencia de plantines en Umala–La Paz* [Tesis de grado, UMSA]. [PDF institucional](https://dipgis.umsa.bo/wp-content/uploads/2023/10/Tesis-Gisela-Yucra.pdf).

### A3. Influencia del sistema web con notificaciones en el control interno y seguimiento del inventario en el vivero Tu Semilla E.I.R.L.

- **Autora, año y tipo:** Fiorella Rosmery Salamanca Contreras, 2024; tesis de Ingeniería de Sistemas, Universidad Privada de Tacna (Perú).
- **Qué hace:** implementa un sistema web para producción, existencias, reservas, ventas y notificaciones del vivero. Reporta mejora de la exactitud del inventario de 74,26 % a 96,83 % y del cumplimiento de despachos de 71,73 % a 85,02 %.
- **Tecnologías declaradas:** PHP 8, Laravel 8, MySQL, Bootstrap, JavaScript, Apache, MVC y Scrum.
- **Similitudes:** control de stock, producción en vivero, despachos, usuarios y reportes.
- **Diferencia y vacío:** es un inventario comercial de un vivero; no conserva la línea de origen forestal ni conecta el despacho con un polígono de reforestación. Tampoco demuestra un libro de eventos inmutable o una invariante formal de conservación.
- **Verificación académica:** PDF del repositorio oficial de la UPT con portada, jurado, asesor y acta de sustentación.
- **Referencia:** Salamanca Contreras, F. R. (2024). *Influencia del sistema web con notificaciones en el proceso de control interno y seguimiento del inventario en el vivero Tu Semilla E.I.R.L. sede Tacna, 2022* [Tesis, Universidad Privada de Tacna]. [PDF institucional](https://repositorio.upt.edu.pe/bitstream/handle/20.500.12969/3690/Salamanca-Contreras-Fiorella.pdf?isAllowed=y&sequence=6).

### A4. Diseño de un sistema electrónico para medir la producción de anturios en el vivero Real Anturios

- **Autora, año y tipo:** Selenia Araya-Quesada, 2020; proyecto de graduación, Instituto Tecnológico de Costa Rica.
- **Qué hace:** diseña un sistema electrónico para identificar alrededor de 25.000 plantas, registrar crecimiento, fecha y motivo de corte y transmitir la información a un servidor.
- **Tecnologías declaradas:** etiquetas/códigos de barras, dispositivo electrónico y servidor; el resumen público no identifica el motor de base de datos.
- **Similitudes:** seguimiento de individuos en vivero y registro temporal de operaciones.
- **Diferencia y vacío:** optimiza producción ornamental dentro de un vivero. No enlaza lote recolectado, balance colectivo, despacho, campaña de plantación ni geometrías de campo.
- **Verificación académica:** registro oficial del TEC con autora, escuela, tipo de trabajo, fecha y archivo depositado.
- **Referencia:** Araya-Quesada, S. (2020). *Diseño de un sistema electrónico para medir la producción de anturios en el vivero de Real Anturios* [Proyecto de graduación, Instituto Tecnológico de Costa Rica]. [Repositorio TEC](https://repositoriotec.tec.ac.cr/items/f469c44a-0c01-4552-b801-4650cdc8f93e).

### A5. Sistema informático para el control de riego de cultivos con IoT en un vivero municipal

- **Autor, año y tipo:** Jonathan Huivín Suárez, 2017; tesis de Ingeniería de Sistemas, Universidad César Vallejo (Perú).
- **Qué hace:** implementa monitoreo y control del riego en el vivero de la Municipalidad Provincial de San Martín, con registro de especies, almácigos, cultivos, sensores y reportes.
- **Tecnologías declaradas:** Internet de las cosas, Raspberry Pi, sensores y sistema informático.
- **Similitudes:** digitalización de operaciones y catálogos dentro de un vivero.
- **Diferencia y vacío:** monitorea condiciones de cultivo, no custodia ni transferencias cuantitativas del material. R3Foresta registra cómo cada lote entra, madura, pierde unidades y sale hacia una plantación concreta.
- **Verificación académica:** tesis en repositorio oficial UCV con autor, asesor, programa y declaración de sustentación.
- **Referencia:** Huivín Suárez, J. (2017). *Implementación de un sistema informático para el control de riego de cultivos empleando IoT con Raspberry Pi en el vivero de la Municipalidad Provincial de San Martín, 2017* [Tesis, Universidad César Vallejo]. [PDF institucional](https://repositorio.ucv.edu.pe/bitstream/20.500.12692/30628/1/huevin_sj.pdf).

### A6. Sistema de trazabilidad en el proceso de elaboración de harina de trigo de Coopincosan

- **Autores, año y tipo:** Leidy Abigail Riera Alegría y Cristhian Stalin Rumiguano Santillán, 2023; trabajo de titulación de Ingeniería Agroindustrial, Universidad Estatal de Bolívar (Ecuador).
- **Qué hace:** caracteriza recepción, producción y despacho, establece procedimientos y registros y emplea identificación QR. La evaluación reportada pasa de 13,04 % a 100 % de cumplimiento del instrumento utilizado.
- **Tecnologías declaradas:** documentación de procesos, registros y códigos QR; no se presenta una arquitectura transaccional de software.
- **Similitudes:** identificación de lotes, etapas encadenadas, transformación de entradas en salidas y registros de recepción/despacho.
- **Diferencia y vacío:** es una cadena alimentaria industrial y su aporte principal es procedimental. No aborda saldos vivos, mortalidad, procedencia forestal, geografía ni operaciones atómicas entre módulos.
- **Verificación académica:** ficha y documento en el repositorio institucional de la UEB, con autores, carrera y año.
- **Referencia:** Riera Alegría, L. A., & Rumiguano Santillán, C. S. (2023). *Implementación de un sistema de trazabilidad en el proceso de elaboración de harina de trigo de la empresa Coopincosan, parroquia Santa Fé, provincia Bolívar* [Trabajo de titulación, Universidad Estatal de Bolívar]. [Repositorio UEB](https://dspace.ueb.edu.ec/items/85296109-a3f4-42fb-96b2-7c927f3ece21).

### A6.1. Sistema web para los procesos administrativos y de producción en viveros del cantón Milagro

- **Autores, año y tipo:** Luis Carlos Mayorga Vásquez, Gustavo Andrés Riccardi Martillo, Oscar Xavier Bermeo Almeida y Verónica Isabel Guevara Arias, 2022; artículo de investigación aplicada (Ecuador).
- **Qué hace:** evalúa un sistema web para optimizar procesos administrativos y de producción en viveros. Sus módulos abarcan plantas, actividades, insumos, herramientas, trabajadores, inventario y reportes; el estudio recoge datos de 86 propietarios y 64 clientes.
- **Tecnologías declaradas:** Python 3.9, Django 3.1.2 y PostgreSQL 10.
- **Similitudes:** viveros, producción vegetal, base relacional, catálogos, inventarios y actividades operativas.
- **Diferencia y vacío:** permite introducir y modificar datos y se orienta a administración/producción comercial. No documenta procedencia forestal, eventos no editables, saldos derivados, contratos atómicos con plantación ni polígonos GIS.
- **Verificación académica:** artículo original con autores/afiliaciones, fechas de recepción y aceptación, volumen, páginas, DOI y registro en la revista y Redalyc.
- **Referencia:** Mayorga Vásquez, L. C., Riccardi Martillo, G. A., Bermeo Almeida, O. X., & Guevara Arias, V. I. (2022). Sistema web para los procesos administrativos y de producción en viveros del cantón Milagro. *Revista Ingeniería, 6*(16), 200–213. [https://doi.org/10.33996/revistaingenieria.v6i16.100](https://doi.org/10.33996/revistaingenieria.v6i16.100).

### 3.2. Fundamentos de trazabilidad de cadena, lotes y eventos

### A7. Perspectives on traceability in food manufacture

- **Autora, año y tipo:** Tina Moe, 1998; artículo científico.
- **Qué hace:** distingue trazabilidad interna y trazabilidad a través de toda la cadena, y plantea la necesidad de definir una unidad rastreable para enlazar procesos y actores.
- **Tecnologías:** marco conceptual; no prescribe una plataforma.
- **Similitudes:** fundamenta el lote de material vegetal como unidad trazable y la diferencia entre seguimiento dentro del vivero y trazabilidad recolección–campo.
- **Diferencia y vacío:** no cubre reforestación, GIS ni diseño transaccional.
- **Verificación académica:** artículo en *Trends in Food Science & Technology*; el portal de investigación de DTU lo clasifica como contribución revisada por pares y enlaza el DOI.
- **Referencia:** Moe, T. (1998). Perspectives on traceability in food manufacture. *Trends in Food Science & Technology, 9*(5), 211–214. [https://doi.org/10.1016/S0924-2244(98)00037-5](https://doi.org/10.1016/S0924-2244(98)00037-5).

### A8. How to define traceability

- **Autores, año y tipo:** Petter Olsen y Melania Borit, 2013; artículo científico.
- **Qué hace:** revisa definiciones existentes y propone una definición precisa de trazabilidad basada en acceder a propiedades de objetos considerados a lo largo de su vida y cadena.
- **Tecnologías:** revisión conceptual y terminológica.
- **Similitudes:** ayuda a separar trazabilidad real de un simple inventario y exige mantener vínculos entre identificadores, transformaciones y etapas.
- **Diferencia y vacío:** no define eventos de vivero, reglas de saldo ni implementación geoespacial.
- **Verificación académica:** artículo publicado en *Trends in Food Science & Technology*, con DOI y registro institucional de Nofima.
- **Referencia:** Olsen, P., & Borit, M. (2013). How to define traceability. *Trends in Food Science & Technology, 29*(2), 142–150. [https://doi.org/10.1016/j.tifs.2012.10.003](https://doi.org/10.1016/j.tifs.2012.10.003).

### A9. Traceability issues in food supply chain management: A review

- **Autores, año y tipo:** Fabrizio Dabbene, Paolo Gay y Cristina Tortia, 2014; revisión científica.
- **Qué hace:** sintetiza modelos de trazabilidad, granularidad de lotes, identificación, recopilación de información y desempeño de sistemas en cadenas agroalimentarias.
- **Tecnologías:** revisión de sistemas de identificación, bases de datos y modelos de cadena.
- **Similitudes:** trata lotes, divisiones, mezclas, transformaciones y recuperación de genealogía en una cadena física.
- **Diferencia y vacío:** el dominio es alimentario y no propone el flujo forestal ni una arquitectura de eventos con saldo vivo.
- **Verificación académica:** registro de la Universidad de Turín en *Biosystems Engineering* con DOI, indexación Scopus/WoS y arbitraje por expertos anónimos.
- **Referencia:** Dabbene, F., Gay, P., & Tortia, C. (2014). Traceability issues in food supply chain management: A review. *Biosystems Engineering, 120*, 65–80. [https://doi.org/10.1016/j.biosystemseng.2013.09.006](https://doi.org/10.1016/j.biosystemseng.2013.09.006).

### A10. Managing food traceability information using EPCIS framework

- **Autores, año y tipo:** Mukul Thakur, Claus F. Sørensen, Frode Olav Bjørnson, E. Forås y Charles R. Hurburgh, 2011; artículo científico.
- **Qué hace:** modela estados y transiciones de productos mediante UML y eventos EPCIS, separando datos maestros de los eventos que ocurren en la cadena. Analiza cómo representar transformaciones de entradas en salidas.
- **Tecnologías declaradas:** EPCIS, UML y repositorio de eventos.
- **Similitudes:** es uno de los antecedentes arquitectónicos más cercanos: eventos de negocio, identificadores persistentes, datos maestros y vínculos de transformación entre etapas.
- **Diferencia y vacío:** su versión de EPCIS y casos alimentarios no modelan saldo vivo, merma biológica, cierre de lote ni asignación a polígonos forestales. R3Foresta aplica esas ideas con reglas de dominio y transacciones específicas.
- **Verificación académica:** artículo de *Journal of Food Engineering* con metadatos editoriales y DOI.
- **Referencia:** Thakur, M., Sørensen, C. F., Bjørnson, F. O., Forås, E., & Hurburgh, C. R. (2011). Managing food traceability information using EPCIS framework. *Journal of Food Engineering, 103*(4), 417–433. [https://doi.org/10.1016/j.jfoodeng.2010.11.012](https://doi.org/10.1016/j.jfoodeng.2010.11.012).

### A11. The Global Track&Trace System for food: General framework and functioning principles

- **Autores, año y tipo:** Teresa Pizzuti y Giovanni Mirabelli, 2015; artículo científico.
- **Qué hace:** propone un marco global para compartir trazabilidad desde productores hasta consumidores mediante modelos de cadena, procesos y datos.
- **Tecnologías declaradas:** arquitectura de información y modelado de procesos; no declara PostgreSQL/PostGIS.
- **Similitudes:** visión multiempresa y multi-etapa; estructura datos transversales y movimientos entre eslabones.
- **Diferencia y vacío:** no incorpora la biología de un vivero, evidencia GPS/fotográfica ni una prueba explícita de conservación de cantidades.
- **Verificación académica:** artículo de *Journal of Food Engineering* con volumen, páginas y DOI.
- **Referencia:** Pizzuti, T., & Mirabelli, G. (2015). The Global Track&Trace System for food: General framework and functioning principles. *Journal of Food Engineering, 159*, 16–35. [https://doi.org/10.1016/j.jfoodeng.2015.03.001](https://doi.org/10.1016/j.jfoodeng.2015.03.001).

### A12. Enabling Traceability in Agri-Food Supply Chains Using an Ontological Approach

- **Autores, año y tipo:** Farhad Ameri, Evan K. Wallace, Reid Yoder y Frank H. Riddick, 2022; artículo científico NIST/ASME.
- **Qué hace:** propone una ontología para representar unidades rastreables, actores, eventos críticos y elementos clave de datos de manera interoperable.
- **Tecnologías declaradas:** ontologías y modelado semántico de *Traceable Resource Units*, *Critical Tracking Events* y datos asociados.
- **Similitudes:** respalda catálogos maestros consistentes y contratos de intercambio con significado común entre módulos.
- **Diferencia y vacío:** se concentra en interoperabilidad semántica, no en persistencia *append-only*, transacciones SQL, viveros o geometrías de reforestación.
- **Verificación académica:** publicación de *Journal of Computing and Information Science in Engineering* con DOI y registro oficial de NIST.
- **Referencia:** Ameri, F., Wallace, E. K., Yoder, R., & Riddick, F. H. (2022). Enabling traceability in agri-food supply chains using an ontological approach. *Journal of Computing and Information Science in Engineering, 22*. [https://doi.org/10.1115/1.4054092](https://doi.org/10.1115/1.4054092).

### 3.3. Procedencia forestal y trazabilidad geoespacial

### A13. Use of DNA-Fingerprints to Control the Origin of Forest Reproductive Material

- **Autores, año y tipo:** Bernd Degen, A. Höltken y M. Rogge, 2010; artículo científico.
- **Qué hace:** evalúa huellas genéticas para comprobar si el material forestal de reproducción corresponde al origen declarado y fortalecer el control de certificación.
- **Tecnologías declaradas:** marcadores genéticos y comparación de perfiles de ADN.
- **Similitudes:** aborda exactamente la autenticidad del origen del material forestal de reproducción y la cadena de custodia desde la recolección.
- **Diferencia y vacío:** verifica procedencia genética, pero no administra inventario, vivero, pérdidas, despachos ni plantaciones. En R3Foresta una futura verificación genética podría adjuntarse como evidencia al lote de origen.
- **Verificación académica:** artículo en *Silvae Genetica*, con DOI y copia institucional del Thünen Institute.
- **Referencia:** Degen, B., Höltken, A., & Rogge, M. (2010). Use of DNA-fingerprints to control the origin of forest reproductive material. *Silvae Genetica, 59*, 268–273. [https://doi.org/10.1515/sg-2010-0038](https://doi.org/10.1515/sg-2010-0038).

### A14. Genetic diversity and parentage analysis for DNA marker-based forest reproductive material traceability in Lithuania

- **Autores, año y tipo:** Darius Kavaliauskas, Barbara Fussi, Monika Sirgėdienė, Rūta Kembrytė y Darius Danusevičius, 2021; artículo en actas científicas, publicado en el portal en 2024.
- **Qué hace:** evalúa diversidad y parentesco con microsatélites para construir un sistema de trazabilidad del material forestal de reproducción y verificar árboles parentales.
- **Tecnologías declaradas:** 12 marcadores microsatélite nucleares y software CERVUS.
- **Similitudes:** lote forestal, origen verificable, material reproductivo y evidencia científica de procedencia.
- **Diferencia y vacío:** no es un sistema de operación de vivero/campo ni mantiene saldos o contratos de transferencia. Complementa, pero no sustituye, la trazabilidad logística de R3Foresta.
- **Verificación académica:** artículo de *Rural Development* con autores, afiliaciones, resumen, fechas editoriales y DOI.
- **Referencia:** Kavaliauskas, D., Fussi, B., Sirgėdienė, M., Kembrytė, R., & Danusevičius, D. (2021). Genetic diversity and parentage analysis for DNA marker-based forest reproductive material traceability system in Lithuania. *Rural Development*. [https://doi.org/10.15544/RD.2021.040](https://doi.org/10.15544/RD.2021.040).

### A15. Geotraceability: an innovative concept to enhance conventional traceability in the agri-food chain

- **Autores, año y tipo:** Robert Oger, Alain Krafft, Dominique Buffet y Michel Debord, 2010; artículo científico.
- **Qué hace:** integra trazabilidad convencional y sistemas de información geográfica mediante geoidentificadores, geoindicadores y un conjunto mínimo de datos intercambiables.
- **Tecnologías declaradas:** GIS, geoidentificadores y bases de datos espaciales.
- **Similitudes:** justifica que ubicación y geometría no sean anexos decorativos, sino dimensiones verificables del historial del lote.
- **Diferencia y vacío:** no cubre material forestal, vivero, eventos inmutables ni balance de existencias.
- **Verificación académica:** artículo publicado por la Universidad de Lieja en *Biotechnology, Agronomy, Society and Environment*.
- **Referencia:** Oger, R., Krafft, A., Buffet, D., & Debord, M. (2010). Geotraceability: an innovative concept to enhance conventional traceability in the agri-food chain. *Biotechnology, Agronomy, Society and Environment, 14*(4). [Página de la revista](https://popups.uliege.be/1780-4507/index.php?id=6375).

### A16. Application of GNSS Based Mobile Tracking to Improve the Geo-traceability of Mango Supply Chain

- **Autores, año y tipo:** Y. M. P. Samarasinghe, C. A. K. Dissanayake y M. M. Herath, 2024; artículo científico.
- **Qué hace:** prueba seguimiento móvil con GNSS en una cadena de mango. Reporta trazado exitoso en 67 % de las cadenas estudiadas e identifica limitaciones de cobertura, dispositivo y capacidades de usuarios.
- **Tecnologías declaradas:** aplicación móvil y GNSS/GPS.
- **Similitudes:** captura georreferenciada en campo, seguimiento de un activo biológico y evidencia de factibilidad/limitaciones operativas.
- **Diferencia y vacío:** no usa polígonos, PostGIS, viveros ni balances atómicos; sigue transporte alimentario, no establecimiento forestal.
- **Verificación académica:** *Journal of Agricultural Sciences–Sri Lanka* identifica el artículo como revisado por pares y publica DOI, volumen y páginas.
- **Referencia:** Samarasinghe, Y. M. P., Dissanayake, C. A. K., & Herath, M. M. (2024). Application of GNSS based mobile tracking to improve the geo-traceability of mango supply chain: A case study. *Journal of Agricultural Sciences–Sri Lanka, 19*(1), 107–117. [https://doi.org/10.4038/jas.v19i1.9702](https://doi.org/10.4038/jas.v19i1.9702).

### 3.4. Arquitectura de eventos, atomicidad e invariantes

### A17. An empirical characterization of event sourced systems and their schema evolution—Lessons from industry

- **Autores, año y tipo:** Michiel Overeem, Marten Spoor, Slinger Jansen y Sjaak Brinkkemper, 2021; artículo científico empírico.
- **Qué hace:** estudia 19 sistemas basados en *event sourcing* y entrevista a 25 profesionales. Identifica beneficios de auditabilidad y reconstrucción, y dificultades de evolución de eventos, proyecciones, privacidad, aprendizaje y herramientas.
- **Tecnologías:** *event sourcing* y evolución de esquemas; los casos abarcan varias tecnologías.
- **Similitudes:** sustenta el historial *append-only* y la reconstrucción del estado actual desde eventos.
- **Diferencia y vacío:** no estudia trazabilidad física ni reforestación. R3Foresta aporta un caso de dominio con eventos tipados, saldo vivo y reglas de cierre; debe considerar desde el diseño versionado y evolución de eventos.
- **Verificación académica:** artículo de *Journal of Systems and Software*; el repositorio de la Universidad de Utrecht lo marca como revisado por pares.
- **Referencia:** Overeem, M., Spoor, M., Jansen, S., & Brinkkemper, S. (2021). An empirical characterization of event sourced systems and their schema evolution—Lessons from industry. *Journal of Systems and Software, 178*, 110970. [https://doi.org/10.1016/j.jss.2021.110970](https://doi.org/10.1016/j.jss.2021.110970).

### A18. Improving observability in Event Sourcing systems

- **Autores, año y tipo:** Stanley Lima, Jaime Correia, Filipe Araújo y Jorge Cardoso, 2021; artículo científico.
- **Qué hace:** propone instrumentación para observar la propagación de eventos y diagnosticar fallos en sistemas de *event sourcing*. Considera el registro de eventos como fuente de verdad y la escritura del evento/cambio asociado como operación atómica.
- **Tecnologías declaradas:** *event sourcing*, trazas distribuidas e instrumentación de observabilidad.
- **Similitudes:** auditabilidad, correlación de operaciones e interés en que un evento válido y el estado derivado no diverjan.
- **Diferencia y vacío:** resuelve observabilidad técnica en sistemas distribuidos, no cantidades biológicas ni contratos recolección–vivero–plantación.
- **Verificación académica:** artículo de *Journal of Systems and Software* con DOI y metadatos editoriales.
- **Referencia:** Lima, S., Correia, J., Araújo, F., & Cardoso, J. (2021). Improving observability in Event Sourcing systems. *Journal of Systems and Software, 181*, 111015. [https://doi.org/10.1016/j.jss.2021.111015](https://doi.org/10.1016/j.jss.2021.111015).

### A19. Principles of transaction-oriented database recovery

- **Autores, año y tipo:** Theo Härder y Andreas Reuter, 1983; artículo científico fundacional.
- **Qué hace:** formaliza las propiedades de transacciones conocidas como ACID y los mecanismos necesarios para conservar consistencia y recuperación ante fallos.
- **Tecnologías:** teoría de transacciones y recuperación de bases de datos.
- **Similitudes:** fundamenta que descontar plantas de un lote, crear el registro receptor y dejar evidencia de transferencia sean una sola unidad indivisible.
- **Diferencia y vacío:** no prescribe contratos de negocio ni un dominio forestal; R3Foresta convierte el principio general en operaciones concretas con precondiciones, efectos y errores.
- **Verificación académica:** artículo de *ACM Computing Surveys* con registro oficial ACM/IBM y DOI.
- **Referencia:** Härder, T., & Reuter, A. (1983). Principles of transaction-oriented database recovery. *ACM Computing Surveys, 15*(4), 287–317. [https://doi.org/10.1145/289.291](https://doi.org/10.1145/289.291).

### A20. Coordination Avoidance in Database Systems

- **Autores, año y tipo:** Peter Bailis, Alan Fekete, Michael J. Franklin, Ali Ghodsi, Joseph M. Hellerstein e Ion Stoica, 2014; artículo científico de conferencia/revista VLDB.
- **Qué hace:** presenta la noción de *invariant confluence* para determinar cuándo operaciones concurrentes pueden ejecutarse sin coordinación y cuándo deben coordinarse para preservar una invariante.
- **Tecnologías:** teoría de concurrencia, transacciones distribuidas y análisis de invariantes.
- **Similitudes:** sustenta la necesidad de bloquear, validar o serializar operaciones que podrían producir saldo negativo, doble asignación o pérdida de conservación.
- **Diferencia y vacío:** no define la invariante forestal. R3Foresta la concreta como entradas = saldo vivo + mermas + despachos, junto con límites por campaña/subcampaña.
- **Verificación académica:** publicación en *Proceedings of the VLDB Endowment*, con PDF oficial, volumen, páginas y DOI.
- **Referencia:** Bailis, P., Fekete, A., Franklin, M. J., Ghodsi, A., Hellerstein, J. M., & Stoica, I. (2014). Coordination avoidance in database systems. *Proceedings of the VLDB Endowment, 8*(3), 185–196. [https://doi.org/10.14778/2735508.2735509](https://doi.org/10.14778/2735508.2735509).

## 4. Sistemas, plataformas e iniciativas operativas

Estas fuentes son antecedentes tecnológicos o institucionales; **no se presentan como publicaciones académicas**.

### P1. Sistema de Monitoreo de Bosques (SIMB), Bolivia

- **Organización y año:** Ministerio de Medio Ambiente y Agua de Bolivia; creado normativamente en 2016 y operativo con información actualizada.
- **Tipo:** plataforma pública nacional.
- **Qué resuelve:** integra información geoespacial sobre cobertura boscosa, deforestación, incendios, forestación y reforestación, y produce estadísticas y reportes.
- **Tecnologías conocidas:** plataforma web y capas geoespaciales; la arquitectura interna no se divulga públicamente.
- **Similitudes:** contexto boliviano, áreas de forestación/reforestación, mapas y seguimiento territorial.
- **Diferencia/vacío:** observa superficies y resultados a escala territorial; no mantiene cadena de custodia de semillas/plantines, eventos de vivero ni conservación del saldo de un lote.
- **Enlace:** [Portal SIMB](https://apps.bits.bo/simb/welcome) y [datos oficiales SIARH/SIMB](https://datos.siarh.gob.bo/simb).

### P2. Semiyá®

- **Organización y año:** AGROSAVIA, Colombia; plataforma vigente, año inicial no indicado en la documentación pública consultada.
- **Tipo:** aplicación institucional para viveros.
- **Qué resuelve:** gestiona inventarios, lotes padre–hijo, etapas de producción, actividades, insumos, ubicaciones, disposición final, costos y etiquetas QR.
- **Tecnologías conocidas:** aplicación web y códigos QR; base de datos, GIS y patrón de persistencia no divulgados.
- **Similitudes:** es uno de los sistemas operativos más cercanos por linaje de lotes, etapas, viveros, movimientos y auditoría.
- **Diferencia/vacío:** se orienta a producción vegetal general; sus términos aclaran que los datos ingresados dependen del usuario y no constituyen certificación de exactitud. No se documentan eventos inmutables, saldo derivado, transacciones intermodulares ni validación PostGIS de plantaciones.
- **Enlace:** [Términos y descripción oficial de Semiyá](https://www.agrosavia.co/privacidad/t%C3%A9rminos-y-condiciones-de-uso-semiy%C3%A1).

### P3. FOREMATIS

- **Organización y año:** Comisión Europea y Estados miembros; sistema electrónico reglamentado en 2021.
- **Tipo:** plataforma/registo oficial de material forestal de reproducción.
- **Qué resuelve:** facilita la publicación de listas nacionales de materiales de base aprobados para producir material forestal de reproducción y armoniza información de procedencia.
- **Tecnologías conocidas:** sistema electrónico europeo; arquitectura no divulgada en el reglamento.
- **Similitudes:** procedencia, categorías de material forestal y fuentes autorizadas.
- **Diferencia/vacío:** registra materiales de base y listas regulatorias; no sigue el saldo operativo de cada lote por vivero y plantación ni registra mantenimiento posterior.
- **Enlace:** [Reglamento de ejecución (UE) 2021/1324 — EUR-Lex](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32021R1324).

### P4. Seedlot Selection Tool

- **Organización y año:** U.S. Forest Service, Oregon State University y socios; 2016.
- **Tipo:** herramienta geoespacial pública.
- **Qué resuelve:** relaciona lotes de semillas con sitios de plantación según clima actual o proyectado para apoyar restauración y adaptación climática.
- **Tecnologías conocidas:** aplicación web GIS, superficies climáticas y mapas de zonas de transferencia.
- **Similitudes:** conecta procedencia del lote con ubicación de plantación y usa análisis espacial.
- **Diferencia/vacío:** apoya la decisión “qué semilla plantar dónde”, pero no registra recolección, producción de vivero, mermas, despacho, evidencias ni cantidades transferidas.
- **Enlace:** [U.S. Forest Service — Seedlot Selection Tool](https://research.fs.usda.gov/pnw/products/dataandtools/seedlot-selection-tool).

### P5. Sistema de Información de Semillas (SIS-MX)

- **Organización y año:** Servicio Nacional de Inspección y Certificación de Semillas (SNICS), México; 2017.
- **Tipo:** sistema público sectorial.
- **Qué resuelve:** concentra información de producción, conservación, certificación y comercio de semillas procedente de múltiples unidades administrativas.
- **Tecnologías conocidas:** sistema web; detalles de implementación no divulgados.
- **Similitudes:** catálogos, lotes/semillas, autoridades y consolidación interinstitucional.
- **Diferencia/vacío:** es un sistema nacional de información y certificación; no modela el ciclo particular de una planta forestal hasta campaña/subcampaña ni un balance por eventos.
- **Enlace:** [SNICS — SIS-MX](https://www.gob.mx/snics/articulos/sistema-de-informacion-de-semillas-sis-mx).

### P6. Sistema Nacional de Trazabilidad Vegetal de Colombia

- **Organización y año:** Gobierno de Colombia/ICA; Decreto 931 de 2018.
- **Tipo:** marco y sistema nacional regulatorio.
- **Qué resuelve:** establece trazabilidad desde semilla o material de propagación hasta producto vegetal terminado y define unidades, lotes, establecimientos y etapas bajo control oficial.
- **Tecnologías conocidas:** el decreto define el sistema y obligaciones, no una arquitectura informática concreta.
- **Similitudes:** cadena vegetal de extremo a extremo, material de propagación, lote, actores y etapas.
- **Diferencia/vacío:** es un marco nacional de control fitosanitario; no especifica un libro *append-only*, algoritmo de saldo, contrato atómico ni geocerca para reforestación.
- **Enlace:** [Decreto 931 de 2018 — Función Pública](https://www.funcionpublica.gov.co/eva/gestornormativo/norma.php?i=86580).

### P7. Centro de Semillas Forestales BASFOR

- **Organización y año:** BASFOR/Universidad Mayor de San Simón, Bolivia; institución operativa de larga trayectoria, página institucional vigente.
- **Tipo:** centro universitario de semillas y vivero forestal.
- **Qué resuelve:** recolecta, procesa, almacena y comercializa semillas; produce plantas, conserva recursos genéticos y capacita en manejo de material forestal.
- **Tecnologías conocidas:** infraestructura física de semillas y vivero; no se publica una plataforma digital integral.
- **Similitudes:** reúne en Bolivia las operaciones físicas que R3Foresta pretende representar: recolección, conservación, vivero y distribución.
- **Diferencia/vacío:** es un antecedente de proceso y actor, no un sistema de trazabilidad operativa con registro de eventos y conservación de saldos. La ausencia de especificaciones digitales públicas impide atribuirle eventos, GIS o contratos transaccionales.
- **Enlace:** [UMSS — Centro de Semillas Forestales BASFOR](https://www.umss.edu.bo/centro-de-semillas-forestales-basfor-sam/).

### P8. Planting Nursery y VerdeSoft

- **Organizaciones y año:** Planting Nursery (proveedor internacional) y VerdeSoft (Brasil); productos comerciales vigentes, años iniciales no comprobados en las páginas consultadas.
- **Tipo:** software comercial de gestión de viveros.
- **Qué resuelven:** planificación de producción, inventario, lotes, campos/invernaderos, pedidos, ventas y despachos; VerdeSoft también promociona etiquetas/QR y trazabilidad por lote.
- **Tecnologías conocidas:** software web/comercial; motores, esquema de eventos y garantías transaccionales no divulgados.
- **Similitudes:** operaciones de vivero, inventario, lotes y despacho.
- **Diferencia/vacío:** la información disponible es de marketing y se orienta a gestión empresarial. No demuestra custodia recolección–restauración, eventos no editables, prueba de conservación ni control espacial PostGIS.
- **Enlaces:** [Planting Nursery](https://plantingnursery.com/es/) y [VerdeSoft](https://verdesoft.com.br/).

## 5. Estándares y marcos de referencia

### E1. ISO 22005:2007 — Traceability in the feed and food chain

- **Organización/año/tipo:** ISO, 2007; estándar internacional, confirmado como vigente en 2022.
- **Aporte:** fija principios y requisitos básicos para diseñar e implementar un sistema de trazabilidad.
- **Aplicación a R3Foresta:** aunque fue creado para alimentos, sirve para justificar objetivos, límites, flujo de información, responsabilidades y pruebas de recuperación de trazas.
- **Límite:** no prescribe arquitectura de eventos ni reglas forestales.
- **Enlace:** [ISO 22005](https://www.iso.org/standard/36297.html).

### E2. ISO 22095:2020 — Chain of custody

- **Organización/año/tipo:** ISO, 2020; estándar internacional.
- **Aporte:** define terminología y modelos generales de cadena de custodia aplicables a materiales y productos.
- **Aplicación:** permite describir con precisión identidad preservada, segregación, mezcla controlada y otros modelos; R3Foresta se aproxima a identidad preservada/segregación por lote y especie.
- **Límite:** una norma de custodia no implementa transacciones ni georreferenciación.
- **Enlace:** [ISO 22095](https://www.iso.org/standard/72532.html).

### E3. GS1 Global Traceability Standard 2.0

- **Organización/año/tipo:** GS1, versión 2.0; estándar técnico.
- **Aporte:** estructura eventos críticos de seguimiento y elementos clave de datos mediante las preguntas quién, qué, dónde, cuándo y por qué; contempla recepción, despacho, agregación y transformación.
- **Aplicación:** ofrece una plantilla para especificar cada evento de R3Foresta, incluyendo identificadores de lote, actor, lugar, fecha, cantidad y motivo.
- **Límite:** debe adaptarse a germinación, embolsado, merma, saldo vivo y subcampañas.
- **Enlace:** [GS1 Global Traceability Standard 2.0](https://ref.gs1.org/standards/global-traceability/2.0.0/).

### E4. EPCIS and Core Business Vocabulary 2.0

- **Organización/año/tipo:** GS1, 2022; estándar de datos e interfaces.
- **Aporte:** define eventos como `ObjectEvent`, `AggregationEvent`, `TransactionEvent`, `TransformationEvent` y `AssociationEvent`, más interfaces de captura/consulta y representación JSON/JSON-LD.
- **Aplicación:** es el referente más cercano para diseñar un sobre común de eventos, distinguir datos maestros de eventos y enlazar entradas/salidas en recolección–vivero–plantación.
- **Límite:** no calcula automáticamente saldo ni impone reglas biológicas; R3Foresta puede adoptar conceptos sin implementar todo EPCIS.
- **Enlace:** [EPCIS 2.0](https://ref.gs1.org/standards/epcis/2.0.0/) y [visión general GS1](https://www.gs1.org/standards/epcis).

### E5. FAO — Forest Reproductive Material

- **Organización/año/tipo:** FAO; módulo técnico del *Sustainable Forest Management Toolbox*.
- **Aporte:** describe selección de fuentes, recolección, procesamiento, almacenamiento, producción en vivero, transporte y distribución del material forestal de reproducción.
- **Aplicación:** proporciona la secuencia de dominio y los atributos que deben “congelarse” al crear un lote para no perder el contexto de procedencia.
- **Límite:** es una guía de manejo, no un modelo de software.
- **Enlace:** [FAO — Forest Reproductive Material](https://www.fao.org/sustainable-forest-management-toolbox/modules/forest-reproductive-material/en).

### E6. OECD Forest Seed and Plant Scheme

- **Organización/año/tipo:** OECD; esquema internacional de certificación, reglas vigentes publicadas por la organización.
- **Aporte:** armoniza identificación, control de origen, recolección, procesamiento, crianza, etiquetado y comercialización de semillas y plantas forestales.
- **Aplicación:** orienta catálogos de categoría, fuente, región de procedencia, proveedor y documentos/certificados asociados al lote.
- **Límite:** certifica material y procedimientos; no especifica una aplicación operativa de vivero y plantación.
- **Enlace:** [OECD Forest Seed and Plant Scheme](https://www.oecd.org/en/topics/sub-issues/forest-seed-and-plant.html).

### E7. Marco europeo de Forest Reproductive Material y FOREMATIS

- **Organización/año/tipo:** Unión Europea; Directiva 1999/105/CE y Reglamento (UE) 2026/1392 adoptado en 2026, con aplicación diferida.
- **Aporte:** exige material de base aprobado, categorías, regiones de procedencia, etiquetado y certificados para permitir trazabilidad y calidad del material forestal.
- **Aplicación:** es referencia para diseñar el lote de origen y sus instantáneas históricas aunque Bolivia tenga otro régimen jurídico.
- **Límite:** el nuevo reglamento europeo no entra en aplicación inmediata y no define la arquitectura interna de R3Foresta.
- **Enlaces:** [FOREMATIS y Reglamento 2021/1324](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32021R1324) y [Comisión Europea — nueva regulación FRM](https://food.ec.europa.eu/plants/plant-reproductive-material/eu-regulation-production-and-marketing-forest-reproductive-material_en).

### E8. OGC Simple Feature Access e ISO 19157-1:2023

- **Organización/año/tipo:** Open Geospatial Consortium e ISO; estándares geoespaciales.
- **Aporte:** OGC define geometrías y operaciones espaciales interoperables; ISO 19157-1 establece principios para describir y evaluar calidad de datos geográficos.
- **Aplicación:** sustentan el uso de polígonos válidos, sistema de referencia, precisión, completitud y controles topológicos en campañas de plantación.
- **Límite:** no cubren custodia ni inventario.
- **Enlaces:** [OGC Simple Features](https://www.ogc.org/standards/sfa/) e [ISO 19157-1:2023](https://www.iso.org/standard/78900.html).

### E9. PostGIS `ST_IsValid` y transacciones PostgreSQL

- **Organización/año/tipo:** PostGIS y PostgreSQL Global Development Group; documentación técnica oficial.
- **Aporte:** `ST_IsValid` comprueba validez topológica 2D según reglas OGC; PostgreSQL documenta aislamiento, bloqueo y comportamiento concurrente de transacciones.
- **Aplicación:** constituyen la referencia implementable para rechazar polígonos inválidos y ejecutar reserva/descuento/creación del receptor dentro de una transacción.
- **Límite:** son manuales técnicos, no evidencia académica ni especificación de las reglas de negocio.
- **Enlaces:** [PostGIS `ST_IsValid`](https://postgis.net/docs/ST_IsValid.html) y [PostgreSQL — Transaction Isolation](https://www.postgresql.org/docs/current/transaction-iso.html).

### E10. ISO/IEC 25010:2023 — Product quality model

- **Organización/año/tipo:** ISO/IEC, 2023; estándar de calidad de producto.
- **Aporte:** define nueve características de calidad para productos TIC, entre ellas adecuación funcional, confiabilidad, seguridad, mantenibilidad e interacción.
- **Aplicación:** ayuda a convertir el objetivo de validación en criterios evaluables, además de las pruebas unitarias e integrales de conservación.
- **Límite:** no define casos de prueba forestales.
- **Enlace:** [ISO/IEC 25010:2023](https://www.iso.org/standard/78176.html).

### E11. Decreto Supremo 2912 y Sistema de Monitoreo de Bosques de Bolivia

- **Organización/año/tipo:** Estado Plurinacional de Bolivia, 2016; marco jurídico y plataforma pública.
- **Aporte:** establece el Programa Nacional de Forestación y Reforestación y contempla el módulo de forestación/reforestación dentro del monitoreo oficial.
- **Aplicación:** aporta pertinencia nacional a campañas, metas, territorio y seguimiento de áreas.
- **Límite:** no define la trazabilidad informática del plantín desde su origen.
- **Enlace:** [SIMB — información oficial](https://datos.siarh.gob.bo/simb).

## 6. Tabla comparativa

**Leyenda:** ✓ = cubre explícitamente; ◐ = cubre parcialmente o a nivel conceptual; — = no cubre; ? = la fuente pública no permite comprobarlo. “Integración atómica” significa que la salida de una etapa y la entrada de la siguiente se confirman o revierten como una sola operación; no equivale a que el sistema simplemente tenga transacciones internas.

| Trabajo o sistema | Origen/FRM | Vivero | Plantación | Multi-etapa | Eventos *append-only* | Conservación de saldos | Integración atómica | GPS/SIG | Foto/evidencia |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **R3Foresta (propuesta)** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Limachi Mamani — viveros ABT | — | ✓ | — | — | — | ◐ | — | ✓ | — |
| Yujra Huanca — Sup’u T’ula | ◐ | ✓ | ✓ | ◐ | — | ◐ | — | ◐ | ◐ |
| Salamanca — Tu Semilla | — | ✓ | — | ◐ | ? | ✓ | ? | — | — |
| Araya-Quesada — anturios | — | ✓ | — | — | ◐ | ◐ | — | — | — |
| Riera/Rumiguano — trigo | — | — | — | ✓ | — | ◐ | — | — | — |
| Mayorga et al. — viveros Milagro | — | ✓ | — | ◐ | — | ◐ | ? | — | — |
| Thakur et al. — EPCIS | — | — | — | ✓ | ✓ | ◐ | — | ◐ | — |
| Pizzuti/Mirabelli — GTTS | — | — | — | ✓ | ◐ | ◐ | — | ◐ | — |
| Degen et al. — ADN/FRM | ✓ | — | — | ◐ | — | — | — | ◐ | ◐ |
| Kavaliauskas et al. — ADN/FRM | ✓ | — | — | ◐ | — | — | — | — | ✓ |
| Oger et al. — geotrazabilidad | — | — | — | ✓ | ◐ | — | — | ✓ | ◐ |
| Samarasinghe et al. — GNSS | — | — | — | ✓ | ◐ | — | — | ✓ | — |
| Overeem et al. — *event sourcing* | — | — | — | — | ✓ | — | ◐ | — | — |
| Lima et al. — observabilidad ES | — | — | — | — | ✓ | — | ✓ | — | — |
| Bailis et al. — invariantes | — | — | — | — | ◐ | ✓ | ✓ | — | — |
| SIMB Bolivia | — | — | ✓ | — | ? | — | ? | ✓ | ◐ |
| Semiyá | ◐ | ✓ | — | ✓ | ? | ◐ | ? | ◐ | ◐ |
| FOREMATIS | ✓ | — | — | ◐ | ? | — | ? | ◐ | ✓ |
| Seedlot Selection Tool | ✓ | — | ✓ | ◐ | — | — | — | ✓ | — |
| SIS-MX | ✓ | ◐ | — | ◐ | ? | ? | ? | ◐ | ◐ |

## 7. Brecha identificada y aporte de R3Foresta

La literatura y los sistemas verificados aparecen fragmentados en cuatro grupos. Los trabajos de procedencia forestal comprueban el origen genético o regulatorio, pero no administran el ciclo operativo del lote. Los sistemas de vivero controlan producción e inventario, pero normalmente terminan en la venta o despacho y no conservan la relación con el sitio de plantación. Los modelos EPCIS, *event sourcing*, ACID e invariantes explican cómo representar eventos y mantener consistencia, pero no incorporan reglas de germinación, embolsado, merma, saldo vivo y cierre. Finalmente, las herramientas GIS relacionan procedencia y territorio, pero no demuestran conservación de cantidades.

**No se encontró un antecedente verificable que integre simultáneamente**: (a) lote de origen con fotografías y GPS; (b) historial de maduración en vivero; (c) saldo vivo protegido contra valores negativos o doble asignación; (d) relaciones consistentes entre el origen, los movimientos, las transformaciones y el destino; (e) validación del polígono de plantación; y (f) pruebas de las reglas críticas de integridad y reconstrucción. La contribución defendible de R3Foresta no es inventar cada técnica por separado, sino **integrarlas y especializarlas en una cadena de custodia forestal boliviana con reglas cuantitativas verificables de extremo a extremo**. Los mecanismos concretos para preservar estas propiedades deberán justificarse durante el diseño y la implementación.

## 8. Síntesis redactable para la sección “Antecedentes”

Los antecedentes revisados muestran avances parciales en la digitalización de viveros, la identificación de procedencia forestal, la trazabilidad por eventos y la georreferenciación. En Bolivia, Limachi Mamani (2020) desarrolló para la ABT un sistema de registro y geolocalización de viveros, mientras que Yujra Huanca (2022) documentó experimentalmente la transición de plantines desde vivero hasta campo; sin embargo, ninguno implementó una cadena de custodia digital completa. En Latinoamérica, Salamanca Contreras (2024) demostró que un sistema web mejora la exactitud del inventario y los despachos de un vivero, y Semiyá de AGROSAVIA incorpora linaje de lotes y etapas productivas, pero sus fuentes públicas no documentan de manera conjunta un historial de eventos, reglas de consistencia entre etapas y validación geoespacial de la plantación. En el plano internacional, Thakur et al. (2011) mostraron que EPCIS permite representar eventos, estados y transformaciones de una cadena física; Overeem et al. (2021) analizaron empíricamente la auditabilidad y evolución de sistemas basados en eventos; y Bailis et al. (2014) formalizaron cuándo una invariante exige coordinación. Por otra parte, Degen et al. (2010) y Kavaliauskas et al. (2021) evidenciaron la importancia de comprobar la procedencia del material forestal, mientras que Oger et al. (2010) y Samarasinghe et al. (2024) sustentaron la geotrazabilidad. A pesar de estos aportes, no se identificó una solución que combine origen georreferenciado, eventos de vivero, explicación de cantidades y saldos, relaciones consistentes hasta la plantación y validación espacial. R3Foresta aborda esta brecha mediante un modelo integrado para material vegetal, con reglas de consistencia sometidas a pruebas.

## 9. Precauciones para citar este estado del arte

- No afirmar que “no existe ningún sistema similar”; la formulación académicamente defendible es “no se encontró, en las fuentes y repositorios consultados, uno que reúna todas las características”.
- No llamar “artículo científico” a una página de producto, norma o decreto.
- No presentar *append-only* como sinónimo de blockchain. Un registro de eventos puede ser inmutable a nivel de aplicación y transacción sin usar blockchain.
- No afirmar que una plataforma comercial carece de una función interna; escribir “no está documentada públicamente”.
- En la versión final de la tesis, completar cada referencia según la norma bibliográfica exigida por la carrera y registrar fecha de consulta para páginas web cambiantes.
