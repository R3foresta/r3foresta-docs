# Registro de avance metodológico RUP y SDD

**Corte:** 15 de septiembre de 2026

## 1. Propósito

Este registro compara el plan metodológico del Proyecto de Grado con la evidencia que puede localizarse al corte. Separa la existencia de artefactos técnicos de su verificación y aceptación formal. También incorpora las capacidades implementadas antes de la iteración prevista, sin presentarlas como incrementos cerrados hasta que se revaliden dentro de la secuencia RUP.

## 2. Estados utilizados

| Estado | Criterio de uso |
|---|---|
| Planificado | la actividad o el resultado tiene periodo y criterio previstos, pero todavía no corresponde ejecutarlo o no existe evidencia de ejecución |
| En curso | existen actividades del periodo vigente y productos parciales, sin revisión de cierre |
| Evidencia técnica disponible | existe un artefacto, cambio, prueba o despliegue localizable, pero falta integrarlo al expediente de la iteración o repetir su comprobación sobre la versión evaluada |
| Verificado | existe un resultado reproducible, vinculado con una versión, datos, prueba y evidencia identificables |
| Aceptado | la persona competente revisó el resultado y registró la decisión y sus condiciones |

*Nota.* Un mismo incremento puede contener componentes en estados distintos. La categoría más avanzada no se extiende automáticamente a toda la iteración.

## 3. Avance por fase e iteración

| Fase e iteración | Resultado planificado | Evidencia disponible al corte | Vacío para el cierre | Estado metodológico |
|---|---|---|---|---|
| Inicio, IN-1 | visión, alcance, actores, requisitos iniciales, riesgos y plan | Perfil, Capítulo I, mapa de actores, necesidades y planificación RUP | consolidar identificadores, responsables, riesgos, revisión de iteración y decisión LCO | evidencia técnica disponible; cierre formal pendiente |
| Elaboración, EL-1 | modelo de dominio y datos, arquitectura base, contratos, invariantes y especificaciones prioritarias | arquitectura, esquema canónico, requisitos y reglas por módulo, contratos M1→M2 y M2→M3 y matrices del Marco aplicativo | cerrar ingresos externos, GPS, identidad y reproducibilidad; consolidar especificaciones y decisión LCA | evidencia técnica disponible; cierre formal pendiente |
| Construcción, CO-1 | incremento 1, M1 Recolección funcional y probado | requisitos, reglas, flujo, implementación integrada con M2 y casos de prueba referidos en la documentación técnica | auditar versión, migraciones, frontend, backend y pruebas; demostrar el incremento y registrar su aceptación | periodo concluido; cierre no demostrado |
| Construcción, CO-2 | incremento 2, M2 Vivero e integración M1→M2 | flujo de Vivero, contrato, descarte pre-embolsado, timeline, movimientos y pruebas técnicas disponibles | completar ingreso externo, matriz SPEC/TASK/prueba, regresión de M1, demostración y revisión de cierre | en curso |
| Construcción, CO-3 | incremento 3, M3 Plantación e integración M2→M3 | asignación física, devolución, plantación inicial, migraciones 051–057, pruebas de base de datos y QA de interfaz reportados | revalidar durante CO-3, cerrar ingreso externo directo, GPS e identidad; vincular versión, casos y resultados | planificada; evidencia adelantada disponible |
| Construcción, CO-4 | incremento 4, trazabilidad transversal, regresión y versión candidata | eventos, snapshots y relaciones permiten recorridos parciales; el Marco aplicativo define consultas y escenarios | implementar y probar reconstrucción transversal, resolver deuda crítica, congelar versión candidata y decidir IOC | planificada; evidencia parcial disponible |
| Transición, TR-1 | pruebas de sistema, validación operativa, despliegue, manuales y aceptación | instrumento, escenarios y criterios de evaluación definidos en el Marco aplicativo | ejecutar escenarios sobre versión identificada, registrar resultados, defectos, aceptación y decisión PR | planificada |

*Fuentes de control:* `metodologia_desarrollo.md`, `../02_planificacion/TODO_PROYECTO_GRADO.md`, `../../ESTADO.md`, `../../ARCHITECTURE.md` y Capítulo III.

## 4. Estado de los hitos

| Hito | Evidencia que debe sustentar la decisión | Evidencia disponible | Estado al corte |
|---|---|---|---|
| LCO | visión, alcance, actores, casos de uso principales, requisitos iniciales, riesgos y plan | Perfil, Capítulo I, necesidades y planificación disponibles | no existe acta o decisión de cierre consolidada |
| LCA | arquitectura base ejecutable, modelo de datos, contratos, especificaciones prioritarias y riesgos técnicos tratados | arquitectura, esquema, contratos y línea integrada con implementación adelantada | no existe acta de cierre; permanecen riesgos críticos y vacíos de especificación |
| IOC | versión candidata integrada, regresión, defectos conocidos, manual preliminar y demostración | todavía no corresponde por cronograma; existen componentes integrados reutilizables | no alcanzado |
| PR | versión liberable, pruebas finales, manuales, incidencias residuales y aceptación | todavía no corresponde por cronograma | no alcanzado |

## 5. Cobertura actual de la cadena SDD

| Capacidad o recorrido | Necesidad y requisito | Especificación y diseño | Tarea y cambio | Prueba y resultado | Aceptación |
|---|---|---|---|---|---|
| alcance y análisis inicial | necesidades `NEC-01` a `NEC-08` y requisitos por módulo disponibles | análisis y matrices del Capítulo III disponibles | falta consolidar identificadores de tareas | evidencia documental disponible | revisión de tutora pendiente |
| M1 Recolección | `RF-REC-*` y `RN-REC-*` disponibles | flujo y contrato M1→M2 disponibles | implementación referida por la integración | casos prioritarios definidos; expediente de CO-1 pendiente | no registrada |
| M1→M2 | `RF-VIV-01`, reglas de saldo e invariantes disponibles | contrato atómico disponible | función, endpoint y persistencia referidos en la evidencia técnica | pruebas técnicas disponibles; falta matriz académica vinculada | no registrada |
| M2 Vivero | `RF-VIV-*` y `RN-VIV-*` disponibles | flujo, eventos y reglas de saldo disponibles | implementación de timeline, descarte, movimientos y asignación disponible | unitarias y e2e referidas; falta consolidar versión y resultados | no registrada |
| M2→M3 | `RF-VIV-11`, `RF-VIV-12` y requisitos de Plantación disponibles | contrato de asignación física, consumo y devolución disponible | migraciones 051–057 y cambios backend/frontend disponibles | e2e de base de datos y QA reportados; requieren revalidación en CO-3 | no registrada |
| M3 Plantación | `RF-PLA-*` y `RN-PLA-*` disponibles | procesos, plan frontend y reglas disponibles | registro inicial, asignación y devolución implementados | QA de interfaz y pruebas técnicas reportados; matriz académica pendiente | no registrada |
| ingresos externos | necesidad y alcance confirmados | diseño técnico incompleto | sin cambio integrado demostrado | sin resultados | no registrada |
| reconstrucción transversal | `NEC-08`, `RF-VIV-07` y `RF-PLA-14` disponibles | relaciones y escenarios definidos | consultas transversales completas pendientes | ejecución prevista para CO-4 y TR-1 | no registrada |

La cobertura anterior no sustituye la matriz principal. El siguiente cierre debe asignar identificadores `SPEC-*`, `TASK-*`, `TEST-*` y `ACT-*` a los elementos materiales y enlazarlos con la versión o cambio correspondiente. No se crearán identificadores retroactivos sin revisar el contenido y la fecha de cada evidencia.

## 6. Registro de contribuciones asistidas por IA

El expediente consolidado de contribuciones materiales asistidas por IA todavía está pendiente. Las referencias generales a análisis o redacción asistida no bastan para demostrar el control definido en la metodología. Cada registro deberá utilizar, como mínimo, la siguiente estructura:

| ID | Fecha | Herramienta y versión disponible | Tarea | Artefacto afectado | Salida adoptada, modificada o rechazada | Revisión humana | Prueba o contraste | Cambio o evidencia |
|---|---|---|---|---|---|---|---|---|
| por asignar | por registrar | por registrar | por registrar | por registrar | por registrar | por registrar | por registrar | por registrar |

## 7. Actualización del registro

El registro se actualiza al iniciar y cerrar cada iteración, después de una prueba relevante y cuando cambia el estado de un riesgo o de una aceptación. Cada actualización debe conservar la fecha, la versión evaluada y la evidencia localizable. Los estados se elevan solo con la evidencia requerida: la implementación no implica verificación y la verificación no implica aceptación.
