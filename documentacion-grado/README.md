# Documentación universitaria de grado — R3Foresta

> **Estado al 25 de agosto de 2026:** el Perfil se encuentra en revisión final y adopta RUP adaptado, complementado con Spec-Driven Development asistido por IA. La ejecución académica abarca del 6 de julio al 15 de noviembre de 2026; el Perfil y las versiones activas de los capítulos I y II ya incorporan esta decisión.

Espacio de trabajo para producir los dos resultados académicos del proyecto de grado de la UMSA, Carrera de Informática — mención Ingeniería de Sistemas:

1. el **Perfil de Proyecto de Grado**, que define y autoriza el trabajo; y
2. el **Proyecto de Grado**, documento final que desarrolla, verifica y evalúa la solución.

## Punto de entrada

- [`02_planificacion/TODO.md`](02_planificacion/TODO.md) — tablero mínimo de cierre del Perfil: bloqueantes y siguientes acciones.
- [`02_planificacion/TODO_CAPITULOS_1_Y_2.md`](02_planificacion/TODO_CAPITULOS_1_Y_2.md) — checklist único para validar, corregir y cerrar los capítulos I y II.
- [`02_planificacion/TODO_PROYECTO_GRADO.md`](02_planificacion/TODO_PROYECTO_GRADO.md) — tablero de ejecución por fases RUP, incrementos, integración, verificación, transición y cierre documental.
- [`06_entregables/perfil/PERFIL_PROYECTO_GRADO.md`](06_entregables/perfil/PERFIL_PROYECTO_GRADO.md) — documento oficial del perfil.
- [`01_lineamientos/base_perfil_proyecto_grado.md`](01_lineamientos/base_perfil_proyecto_grado.md) — alcance rector, principios de trazabilidad y reglas de propagación hacia el Proyecto de Grado final.
- [`01_lineamientos/criterios_editoriales_proyecto_grado.md`](01_lineamientos/criterios_editoriales_proyecto_grado.md) — criterios de claridad, nivel de detalle y separación entre propiedades, mecanismos y pruebas para la documentación posterior al Perfil.
- [`03_investigacion/ficha_institucional_r3foresta.md`](03_investigacion/ficha_institucional_r3foresta.md) — misión y visión oficiales, identidad del modelo, relación entre R3Carbon y R3foresta App, antecedentes, aspectos preliminares del diagnóstico y evidencia institucional pendiente.
- [`05_recursos/indice_fuentes_bibliograficas.md`](05_recursos/indice_fuentes_bibliograficas.md) — acceso temático a las fuentes del perfil y del futuro marco teórico.
- [`06_entregables/proyecto_grado/README.md`](06_entregables/proyecto_grado/README.md) — espacio reservado y guía inicial para el documento final.

## Organización

| Carpeta | Función | Contenido principal |
|---|---|---|
| [`01_lineamientos/`](01_lineamientos/) | Reglas y decisiones rectoras | Normativa UMSA, principios de trazabilidad, criterios editoriales y lineamiento estratégico vigente. |
| [`02_planificacion/`](02_planificacion/) | Control y diseño documental | TODO, estructura del perfil y plan histórico. |
| [`03_investigacion/`](03_investigacion/) | Sustento académico y estado del arte | Antecedentes, análisis crítico, biblioteca razonada y guía de búsqueda. |
| [`04_metodologia/`](04_metodologia/) | Metodología de desarrollo | RUP adaptado, SDD asistido por IA y antecedentes metodológicos superados. |
| [`05_recursos/`](05_recursos/) | Recursos transversales | Glosario, convenciones terminológicas e índice bibliográfico. |
| [`06_entregables/`](06_entregables/) | Documentos que se presentan | Perfil oficial y futuro Proyecto de Grado. |

La numeración expresa el flujo de trabajo académico: primero se fijan los lineamientos; después se planifica, investiga y define la metodología; finalmente esos insumos alimentan los entregables.

## Nota para la IA

- Esta carpeta forma parte del material académico que se incorporará al control de versiones. No sustituye la documentación técnica canónica del dominio.
- La documentación técnica canónica de R3Foresta vive en los módulos del repo (`00-general-module/`, `01-recoleccion-module/`, etc.) y en `database/`. Ver el `CLAUDE.md` raíz para el contexto del dominio.
- Idioma de trabajo: **español**. Preservarlo en todo documento nuevo o edición.
- Aquí se redacta el documento académico de grado (marco teórico, objetivos, metodología, análisis, diseño, implementación, conclusiones) y piezas de portafolio, apoyándose en la documentación canónica como fuente de verdad.

## Estándares del Perfil de Proyecto de Grado (UMSA — Informática, Ing. de Sistemas)

Modalidad elegida: **Defensa de Proyecto de Grado**.

**Portada vigente:** título seleccionado por el postulante y pendiente de ratificación por la tutora, postulante, tutora, modalidad, lugar y fecha. En esta versión no se incluye línea de VoBo; cualquier requisito adicional de firma se incorporará únicamente si la tutora o la Comisión de Grado lo solicita.

### Estructura vigente del Perfil

- **Carátula** — universidad, facultad (FCPN), carrera, mención, título, autor, tutora, lugar y fecha.
- **Índice general** — regenerable desde los encabezados de la fuente Markdown.
- **1. Introducción** — dominio, organización, problema, solución propuesta y límites principales.
- **2. Antecedentes** — institucionales y trabajos similares en orden internacional, Bolivia y La Paz.
- **3. Planteamiento del problema** — situación problemática, problema central y formulación mediante preguntas; el árbol de problemas se presenta en anexos.
- **4. Objetivos** — objetivo general y cinco objetivos específicos alineados con el documento final.
- **5. Justificación** — operativa, institucional, tecnológica, académica y factibilidad delimitada.
- **6. Alcances y límites** — tres módulos, recorrido desde el origen registrado —por recolección de semillas o incorporación de material adquirido externamente—, controles transversales y exclusiones reales.
- **7. Marco teórico preliminar** — conceptos esenciales del título y fundamentos de RUP, SDD e IA.
- **8. Metodología de desarrollo** — RUP adaptado como proceso rector, iteraciones e incrementos, SDD asistido por IA, seguimiento y evidencia.
- **9. Índice propuesto del Proyecto de Grado**.
- **10. Cronograma de actividades** por objetivos, fases, iteraciones e incrementos.
- **11. Referencias bibliográficas** en APA 7.
- **12. Anexos**.

> La enumeración "SCRUM, XP, RUP…" de las guías de perfil es orientativa. **Metodología declarada para R3Foresta:** proceso basado en RUP, complementado con SDD asistido por IA — ver [`04_metodologia/metodologia_desarrollo.md`](04_metodologia/metodologia_desarrollo.md).

El archivo Markdown es la fuente canónica y la única versión editable del Perfil dentro del repositorio. El documento de trabajo y presentación será el **Google Docs ubicado en Drive**: las versiones aprobadas del Markdown se transferirán directamente a ese documento, que es el que deberá utilizarse para revisar y editar en Drive. El DOCX local es un artefacto legado, no sincronizado y fuera del flujo vigente; no deberá utilizarse como fuente, destino ni intermediario. Los encabezados principales del Perfil no requieren saltos de página. En el documento final oficial del Proyecto de Grado, cada capítulo principal sí comenzará en una página nueva durante la maquetación de entrega.

### Estructura del Proyecto final (a la que apunta el perfil)

- **Introducción independiente** — se redactará al finalizar todos los capítulos.
- **Cap. 1 — Marco introductorio** (antecedentes, problema, objetivos, justificación, alcances y metodología de desarrollo).
- **Cap. 2 — Marco teórico y conceptual** (dominio, RUP, SDD y asistencia de IA).
- **Cap. 3 — Marco aplicativo** (análisis, diseño, implementación, integración, verificación, validación, aceptación y resultados).
- **Conclusiones y Recomendaciones.**
- Referencias bibliográficas y anexos.

### Referencias

- Reglamento y normativas oficiales de la carrera: http://informatica.umsa.bo/tramites/ (confirmar índice exacto con el tutor; puede variar en detalles menores).
- Repositorio Institucional UMSA (trabajos similares): https://repositorio.umsa.bo/handle/123456789/1
- Guía de perfil (Farit Rojas, UMSA) y ejemplos: SlideShare "Perfil Proyecto de Grado (Informática)", Scribd "Proyecto de Grado UMSA".
