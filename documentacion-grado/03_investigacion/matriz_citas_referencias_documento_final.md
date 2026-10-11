# Matriz interna de citas y referencias — Documento final

> **Uso interno:** este control permite comprobar que cada fuente usada por los capítulos del documento final tenga una entrada en la bibliografía consolidada. No se inserta como capítulo ni como anexo de la versión académica, salvo que la tutora solicite evidencia del control editorial.

## Fuente bibliográfica única

La lista recuperable que se incorporará al final del documento está en [`../06_entregables/proyecto_grado/04_referencias_bibliograficas.md`](../06_entregables/proyecto_grado/04_referencias_bibliograficas.md). Los artefactos internos se controlan exclusivamente en el registro técnico de esta matriz y mediante rutas exactas en las notas de las tablas y figuras del Capítulo III; no se añaden después de la bibliografía del manuscrito.

## Correspondencia por capítulo

| Capítulo | Fuentes o grupos de fuentes citados | Control aplicado |
|---|---|---|
| I — Marco introductorio | R3Foresta; Salamanca Contreras; Mayorga Vásquez et al.; Thakur et al.; Quispe Tola y Condori Zapana; Limachi Mamani; Valdez Alvarado; Olsen y Borit; ISO 22095; ISO 14064-2; Verra; Kruchten; IBM; GitHub; Tabassi. | Todas cuentan con una entrada recuperable en la bibliografía consolidada. La fuente institucional se limita al contexto que documenta. |
| II — Marco teórico y conceptual | FAO; Olsen y Borit; Moe; Dabbene et al.; ISO 22095 e ISO 22095-2; GS1; Solanki y Brewster; W3C PROV-O; Elmasri y Navathe; Härder y Reuter; Meyer; Gotel y Finkelstein; OGC; Donnelly et al.; ISO/IEC 25010; IEEE 1012; ISO 14064-2; Verra; Kruchten; IBM; Fowler; OMG; GitHub; Wiegers y Beatty; Tabassi. | Cada concepto técnico se vincula con una fuente académica, normativa, institucional o técnica primaria; las tecnologías reales se atribuyen a la documentación técnica interna de la implementación. |
| III — Marco aplicativo | Fuentes primarias FP-01 y FP-02, observación FO-01, dossier FD-01, documentación operativa y arquitectura, esquema de base de datos, contratos de integración y estado técnico. | Las fuentes primarias no recuperables se identifican por código en el capítulo. Los documentos internos recuperables se registran abajo y se enlazan directamente desde las notas, sin alterar la bibliografía final. |

## Registro técnico de artefactos internos y fuentes primarias

> **Uso interno:** estas rutas permiten recuperar la evidencia que se cita en notas de tablas y figuras. No son referencias APA ni se incorporan después de la bibliografía final del manuscrito.

| Artefacto o fuente | Ruta o identificación | Uso de control |
|---|---|---|
| Organigrama institucional de R3Foresta | Fuente primaria no recuperable proporcionada por la Fundación R3Foresta; imagen local [`organigrama_r3foresta.png`](../06_entregables/perfil/figuras/organigrama_r3foresta.png) | sustenta la Figura 1.1; no se incorpora a la lista APA por no ser recuperable |
| Perfil de Proyecto de Grado | [`PERFIL_PROYECTO_GRADO.md`](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md) | alcance, decisiones de proyecto y reglas académicas |
| Registro de avance metodológico RUP y SDD | [`registro_avance_rup_sdd.md`](../04_metodologia/registro_avance_rup_sdd.md) | estado de iteraciones, hitos y evidencia disponible |
| Arquitectura y estado técnico | [`ARCHITECTURE.md`](../../ARCHITECTURE.md) y [`ESTADO.md`](../../ESTADO.md) | componentes, riesgos y contraste de implementación |
| Mapa estructurado del sistema | [`mapa_sistema_trazable_2026-09-10.md`](mapa_sistema_trazable_2026-09-10.md) | inventario de componentes efectivamente observados |
| Esquema de base de datos | [`database/00_database_schema.md`](../../database/00_database_schema.md) | modelo lógico/físico y restricciones documentadas |
| Contratos de integración | [`01_contrato_recoleccion_a_vivero.md`](../../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md) y [`02_contrato_vivero_a_plantacion.md`](../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md) | transferencias M1→M2 y M2→M3 |

## Regla de mantenimiento

1. Al incorporar una cita nueva en los capítulos, añadir su referencia a la bibliografía consolidada antes de cerrar la revisión.
2. Al retirar una cita, comprobar si su referencia sigue siendo utilizada por otro capítulo; si no, retirarla de la bibliografía consolidada.
3. Las fuentes de planificación, lineamientos y corpus de investigación son instrumentos de trabajo, no bibliografías de capítulos; solo pasan a la lista final si sustentan una cita del manuscrito.
4. Antes de exportar a PDF, contrastar este control con la búsqueda de citas de autor-fecha y con las notas de tablas y figuras.
