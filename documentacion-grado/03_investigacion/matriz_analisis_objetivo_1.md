# Matriz de análisis del objetivo específico 1

## 1. Objetivo y alcance

**OBJ-01 — Analizar la información que se genera y cómo se gestiona actualmente en las actividades de Recolección, Vivero y Plantación de R3Foresta.**

La matriz conserva la relación entre las fuentes, los hallazgos de la situación actual y las necesidades que deberán atender las etapas posteriores del proyecto. El corte principal del diagnóstico es el 22 de julio de 2026. El dossier documental del 14 de septiembre se utiliza como contraste posterior y no modifica retroactivamente el estado observado.

## 2. Fuentes

| Código | Fuente | Tipo | Contribución |
|---|---|---|---|
| FP-01 | Reunión de trabajo del 20 de julio de 2026 | Fuente primaria — levantamiento inicial | Etapas propuestas, expectativas, datos deseados y primeras decisiones de alcance |
| FP-02 | Entrevista a Hernán Lara del 22 de julio de 2026 | Fuente primaria — entrevista semiestructurada | Práctica actual, soportes utilizados, actores, flujos, dificultades y excepciones |
| FO-01 | Siete fotografías de Chasquipampa del 22 de julio de 2026 | Fuente primaria — registro visual | Evidencia parcial del manejo de plantines en ambiente protegido y sol directo |
| FD-01 | Dossier documental con corte al 14 de septiembre de 2026 | Fuente de contraste asistida por IA | Localización de publicaciones, cronología, cantidades declaradas y contradicciones documentales |
| DT-01 | Requisitos, reglas y flujos consolidados de los tres módulos | Documentación técnica | Permite enlazar las necesidades analizadas con especificaciones posteriores; no describe por sí sola la práctica anterior |

## 3. Hallazgos de la situación actual

| Código | Hallazgo | Evidencia principal | Clasificación | Grado de respaldo |
|---|---|---|---|---|
| HAL-01 | La información histórica se encuentra distribuida entre publicaciones de Facebook, fotografías, mensajes, documentos aislados y memoria de los responsables | FP-02; FD-01 | Práctica actual | Alto para la dispersión; variable para cada actividad individual |
| HAL-02 | No existe un registro estructurado que relacione de forma continua la recolección, el manejo en vivero y el destino en plantación | FP-01; FP-02 | Problema actual | Alto por convergencia de fuentes primarias |
| HAL-03 | La recolección no depende de un único cargo: pueden recolectar o entregar material el personal vinculado al vivero, miembros de comunidades y actores externos | FP-02; aclaración del autor del proyecto | Práctica actual | Medio; requiere confirmación por operación cuando se registren casos reales |
| HAL-04 | El control formal comienza de manera práctica al recibir el material en el vivero, pero el origen previo no siempre queda documentado con la misma precisión | FP-02; aclaración del autor | Práctica actual | Medio–alto |
| HAL-05 | El vivero produce observaciones sobre cantidades de entrada, germinación, plantas embolsadas, pérdidas, etapa de exposición y disponibilidad, pero estos datos no se conservaban sistemáticamente | FP-01; FP-02; FO-01 | Práctica actual y brecha | Alto |
| HAL-06 | Las fotografías del 22 de julio muestran grupos de plantas en bolsas bajo protección y a sol directo, pero no permiten determinar lotes, cantidades exactas, especies o procedencias | FO-01 | Evidencia observable y límite probatorio | Alto para lo visible; no aplicable para atributos ausentes |
| HAL-07 | Las plantaciones suelen comunicarse públicamente mediante fecha, lugar, cantidad e imágenes; la cobertura es incompleta porque no todas las actividades fueron publicadas o fotografiadas | FP-02; FD-01 | Práctica actual | Alto |
| HAL-08 | La dirección de R3Foresta centraliza coordinación, decisiones y memoria institucional, mientras las comunidades y responsables locales participan en producción, cuidado y plantación | FP-01; FP-02 | Distribución funcional actual | Medio–alto; los cargos formales varían entre proyectos |
| HAL-09 | La producción es predominantemente propia; existen donaciones de plantas y se admite la posibilidad excepcional de compra o incorporación externa | FP-02 | Práctica actual y excepción | Alto para producción propia y donaciones; compra tratada como posibilidad |
| HAL-10 | Las cifras públicas no siempre pueden conciliarse porque faltan identificadores de proyecto, parcela, cohorte y fecha de medición | FD-01 | Contraste documental | Alto como limitación del corpus público |
| HAL-11 | Chasquipampa es el proceso operativo seleccionado como referencia: allí se aplica el flujo utilizado por Hernán Lara, se enseña a otras comunidades y se realizarán las pruebas principales | Confirmación del autor del proyecto; FP-02; FO-01 | Decisión de aplicación | Alto |

## 4. Separación entre situación, propuesta y alcance

| Tema | Tratamiento en el análisis |
|---|---|
| Registro de semilla, vivero y plantación | Necesidad operativa incluida |
| Trazabilidad de procedencia, cantidades, responsables, ubicaciones y evidencia | Necesidad central incluida |
| Ingreso externo por donación o adquisición | Variante incluida dentro de Vivero o Plantación; no constituye un módulo independiente |
| Jerarquía extensa de responsables zonales y comunitarios | Necesidad de crecimiento identificada; su detalle no se presenta como estructura actual uniforme |
| Seguimiento de supervivencia después de plantar | Necesidad institucional mencionada, fuera del alcance académico vigente |
| Cálculo de CO₂, MRV o certificación | Aspiración futura, fuera del alcance |
| Blockchain, contratos inteligentes, NFT o IPFS | Propuesta histórica, fuera del alcance académico |
| Bioregeneración, agua, compostaje y lombricultura | Contexto institucional o trabajo futuro; no amplía los tres módulos |

## 5. Necesidades derivadas

| Código | Necesidad confirmada | Módulos o capacidad relacionados | Familias de requisitos que deberán demostrar respuesta |
|---|---|---|---|
| NEC-01 | Registrar el origen disponible del material, incluso cuando intervienen distintos recolectores o aportantes | Recolección; ingresos externos | `RF-REC-*`, `RF-GEN-*` y variantes de ingreso externo |
| NEC-02 | Identificar cada lote y conservar sus relaciones al cambiar de etapa | Recolección→Vivero→Plantación | Contratos M1→M2 y M2→M3; historial transversal |
| NEC-03 | Registrar cantidades y unidades sin inferir automáticamente plantas a partir de semillas o peso | Recolección y Vivero | `RF-REC-*`, `RF-VIV-01`, `RF-VIV-02` y reglas de unidades |
| NEC-04 | Registrar resultados observados, pérdidas, salidas y saldos explicables | Vivero y Plantación | `RF-VIV-*`, asignaciones y movimientos de M3 |
| NEC-05 | Relacionar cada operación con fecha, responsable, ubicación y evidencia | Capacidad transversal | `RF-GEN-*`, evidencias de los tres módulos |
| NEC-06 | Diferenciar responsabilidades de origen, recepción, manejo, coordinación y plantación | General y tres módulos | usuarios, roles, membresías y responsables por evento |
| NEC-07 | Registrar el destino de las plantas y las cantidades efectivamente plantadas | Vivero→Plantación | asignaciones, recepción y registro de plantación |
| NEC-08 | Recuperar una traza que explique origen, eventos, cantidades, responsables, evidencias y destino | Consulta transversal | historial y reconstrucción extremo a extremo |

## 6. Reglas confirmadas

La sección 3.1 del Marco aplicativo asigna los identificadores `RAN-01` a `RAN-10` a las reglas derivadas del análisis. Comprenden la separación entre actor de origen y receptor, los tipos de material del flujo estándar, el registro de cantidades y resultados observados, la conservación de procedencia externa, el abastecimiento desde varios lotes, la responsabilidad por evento, el acceso autorizado, el límite probatorio de las fotografías y el cierre del alcance en el registro de la plantación. Su correspondencia con las reglas de negocio canónicas se desarrollará en la sección 3.2.

## 7. Criterios de cierre del análisis

OBJ-01 podrá declararse cubierto en el documento final cuando:

1. los tres procesos actuales estén descritos con actores, datos y soportes;
2. las afirmaciones actuales estén separadas de propuestas futuras;
3. el proceso de Chasquipampa esté justificado como referencia operativa y no como generalización estadística;
4. las evidencias fotográficas estén descritas con sus límites;
5. los problemas observados conduzcan a necesidades y familias de requisitos identificables;
6. permanezcan registradas las contradicciones que requieren conciliación posterior;
7. el resultado pueda enlazarse con el diseño de la sección 3.2 sin anticiparlo.
