# Selección controlada de fuentes — Capítulos I y II

> **Propósito:** documentar las fuentes que sustentan los primeros borradores de los capítulos I y II, evitar citas ornamentales y mantener fuera del texto las referencias que todavía no aportan una afirmación necesaria.

## Criterio de selección

Cada fuente se utiliza para una sola función clara: definir un concepto, distinguir dos conceptos próximos, delimitar una transferencia desde otro dominio o fundamentar un criterio que se comprobará en el Marco aplicativo. Una norma o guía no se presenta como evidencia empírica ni como certificación de R3foresta App. Las fuentes de agricultura, cadena de suministro o certificación se emplean únicamente cuando el principio transferido se explica de forma explícita.

## Capítulo I: fuentes conservadas del Perfil cerrado

El Capítulo I no incorpora bibliografía por acumulación ni modifica las decisiones del Perfil. Conserva únicamente las fuentes ya aprobadas que sostienen una afirmación concreta del contexto, los antecedentes comparados o la metodología. Las fuentes conceptuales repetidas en la metodología se desarrollan con mayor detalle en el Capítulo II, en lugar de multiplicar explicaciones en ambos capítulos.

| Fuente | Función limitada en el Capítulo I |
|---|---|
| R3Foresta (2026) | Contexto institucional, nombre de la aplicación y proyección institucional; no demuestra resultados del sistema ni viabilidad de créditos de carbono. |
| Valdez Alvarado (2023) | Antecedente local más cercano entre Vivero y Plantación; se conserva su diferencia respecto de la Recolección y de la traza transversal. |
| Salamanca Contreras (2024) y Mayorga Vásquez et al. (2022) | Comparación con soluciones de administración e inventario de viveros; no se extrapolan sus resultados al caso R3Foresta. |
| Quispe Tola y Condori Zapana (2020), y Limachi Mamani (2020) | Antecedentes bolivianos de iniciativas forestales y geolocalización de viveros; delimitan el contexto local, sin presentarse como trazabilidad operativa completa. |
| Thakur et al. (2011) | Referente para explicar eventos, movimientos y transformaciones; su uso se restringe a una transferencia conceptual desde el dominio agroalimentario. |
| Olsen y Borit (2013), ISO 22095:2020, Kruchten (2004), IBM, GitHub Spec Kit y Tabassi (2023) | Sustento puntual de trazabilidad y proceso de desarrollo ya definidos en el Perfil; el fundamento completo permanece en las secciones 2.2 y 2.8 a 2.9. |

## Fuentes incorporadas

| Sección | Fuente y función precisa |
|---|---|
| 2.1 | FAO: delimita material reproductivo forestal, procedencia, manejo, vivero y distribución; fundamenta que una transformación biológica debe observarse, no inferirse por una equivalencia aritmética, y delimita la reforestación como contexto de uso. |
| 2.2 | Olsen y Borit (2013), Moe (1998), Olsen y Borit (2018) e ISO 22095:2020: definición de trazabilidad, diferencia entre trazabilidad interna y entre etapas, unidad trazable, granularidad y límite de las declaraciones de cadena de custodia. |
| 2.3 | Thakur et al. (2011), GS1 EPCIS/CBV, Solanki y Brewster (2014) y PROV-O: hechos frente a datos maestros, relaciones entrada–evento–salida y entidad–actividad–agente. EPCIS se usa solo como referente descriptivo. |
| 2.3.5 y 2.8.6 | Elmasri y Navathe (2016), Fowler (2004) y OMG UML: distinción entre modelo entidad–relación y esquema físico; propósito complementario de las notaciones de datos, casos de uso, actividad, estados, secuencia, componentes y despliegue. |
| 2.4 | ISO 22095-2:2026, Härder y Reuter (1983), Meyer (1992) y Gotel y Finkelstein (1994): diferencia entre balance de masa y proceso biológico, atomicidad, contrato e hilo entre requisito, decisión y prueba. |
| 2.5 | PROV-O, ISO 22095:2020 y OGC Simple Features: evidencia asociada, responsabilidad, límites de las declaraciones y representación de puntos o polígonos. |
| 2.6 | Donnelly et al. (2012), ISO/IEC 25010:2023 e IEEE 1012-2024: reconstrucción mediante escenarios, criterios de calidad y diferencia entre verificación, validación y aceptación, sin certificar el producto. |
| 2.7 | Verra e ISO 14064-2:2019: definición restringida de créditos y separación respecto de metodología, cuantificación, monitoreo, validación, verificación y emisión. |
| 2.8–2.9 | Kruchten (2004), IBM, GitHub Spec Kit, Wiegers y Beatty (2013) y Tabassi (2023): RUP, SDD, requisitos, criterios de aceptación y control humano de la asistencia de IA. |

## Fuentes deliberadamente fuera del primer borrador

- UNTP Digital Traceability Events: especificación todavía en desarrollo; puede aparecer más adelante como estado del arte, no como fundamento del modelo.
- FSC-STD-40-004: útil solo si el Marco aplicativo necesita contrastar una regla cuantitativa con un estándar forestal de certificación; no define el proceso de material vegetal vivo.
- Comba et al. (2013), Byun et al. (2017), Jansen-Vullers et al. (2003), Solanki (2015), Randrup et al. (2008), Mgonja et al. (2013) y Terriault (2022): su lectura completa continúa pendiente o su aporte es redundante en esta etapa.
- Las tecnologías reales —incluidos TypeScript, React, Supabase, PostgreSQL, Storage y los componentes complementarios efectivamente observados— se inventarían de forma breve en 2.10. No fundamentan el problema ni amplían el alcance académico; la arquitectura, configuración, riesgos y evidencia de implementación permanecen en el Capítulo III.

## Pendientes antes de la revisión formal

1. Confirmar el sistema de referencia espacial, los registros que usarán punto o polígono y los criterios técnicos de validez espacial.
2. Definir para los escenarios de validación qué campos serán obligatorios, qué significa completitud y qué tiempo de recuperación se registrará.
3. Conservar de Donnelly et al. (2012) únicamente el principio general de recuperación controlada ya aplicado; no transferir detalles metodológicos adicionales de sus ejercicios sin una lectura integral y una ficha de contraste.
4. Consolidar las referencias citadas en la [`bibliografía general del documento final`](../06_entregables/proyecto_grado/04_referencias_bibliograficas.md) conforme a APA 7.

## Control de referencias para esta selección

Este archivo conserva el criterio, la función y el estado de selección de las fuentes; no duplica sus fichas bibliográficas. La referencia APA completa de cada fuente incorporada se consulta únicamente en la [bibliografía consolidada final](../06_entregables/proyecto_grado/04_referencias_bibliograficas.md). La tabla «Fuentes incorporadas» y el apartado «Fuentes deliberadamente fuera del primer borrador» constituyen el registro de uso y reserva para esta etapa.
