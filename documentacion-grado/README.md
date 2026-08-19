# Documentación universitaria de grado — R3Foresta

> **Estado al 18 de agosto de 2026:** el alcance de trabajo vigente es únicamente el **Perfil de Proyecto de Grado**. La ejecución académica se planifica prospectivamente del 17 de agosto al 15 de noviembre mediante ocho sprints; el contenido oficial del perfil está completo en Markdown.

Espacio de trabajo para producir los dos resultados académicos del proyecto de grado de la UMSA, Carrera de Informática — mención Ingeniería de Sistemas:

1. el **Perfil de Proyecto de Grado**, que define y autoriza el trabajo; y
2. el **Proyecto de Grado**, documento final que desarrolla, verifica y evalúa la solución.

## Punto de entrada

- [`02_planificacion/TODO.md`](02_planificacion/TODO.md) — tablero vivo del perfil: bloqueantes, estado por sección, figuras y actividades pendientes.
- [`06_entregables/perfil/PERFIL_PROYECTO_GRADO.md`](06_entregables/perfil/PERFIL_PROYECTO_GRADO.md) — documento oficial del perfil.
- [`05_recursos/indice_fuentes_bibliograficas.md`](05_recursos/indice_fuentes_bibliograficas.md) — acceso temático a las fuentes del perfil y del futuro marco teórico.
- [`06_entregables/proyecto_grado/README.md`](06_entregables/proyecto_grado/README.md) — espacio reservado y guía inicial para el documento final.

## Organización

| Carpeta | Función | Contenido principal |
|---|---|---|
| [`01_lineamientos/`](01_lineamientos/) | Reglas y decisiones rectoras | Normativa UMSA y lineamiento estratégico vigente. |
| [`02_planificacion/`](02_planificacion/) | Control y diseño documental | TODO, estructura del perfil y plan histórico. |
| [`03_investigacion/`](03_investigacion/) | Sustento académico y estado del arte | Antecedentes, análisis crítico, biblioteca razonada y guía de búsqueda. |
| [`04_metodologia/`](04_metodologia/) | Método de investigación y desarrollo | Metodología adoptada y antecedentes metodológicos superados. |
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

**Portada vigente:** título propuesto, postulante, tutora, modalidad, lugar y fecha. En esta versión no se incluye línea de VoBo; cualquier requisito adicional de firma se incorporará únicamente si la tutora o la Comisión de Grado lo solicita.

### Estructura del Perfil (documento corto, ~15–25 págs., a aprobar antes de desarrollar)

1. **Carátula** — universidad, facultad (FCPN), carrera, mención, título, autor, tutora, lugar y fecha.
2. **Introducción / Antecedentes** — contexto del dominio y sistemas/trabajos previos similares.
3. **Planteamiento del problema** — situación problemática, análisis causa-efecto (árbol de problemas) y **formulación del problema** (pregunta de investigación).
4. **Objetivos** — un objetivo general + varios específicos (verbos medibles, alineados a cada capítulo).
5. **Justificación** — técnica, económica y social/operativa.
6. **Alcances y límites** — tres módulos operativos, variantes implícitas de ingreso del material vegetal, exclusiones y limitaciones de evaluación.
7. **Marco teórico/referencial preliminar** — trazabilidad, cadena de custodia, transacciones, registros de eventos, integridad de datos, geoinformación y evaluación de software. Blockchain/IPFS solo como antecedentes históricos o trabajo futuro, si corresponde.
8. **Metodología** — tipo de investigación + metodología de desarrollo de software y herramientas.
   > La enumeración "SCRUM, XP, RUP…" que aparece en las guías de perfil es orientativa, no un requisito reglamentario: el Reglamento General no exige ninguna metodología nominada. **Metodología declarada para R3Foresta:** desarrollo iterativo e incremental guiado por especificación anclada — ver [`04_metodologia/metodologia_desarrollo.md`](04_metodologia/metodologia_desarrollo.md).
9. **Índice tentativo (temario)** del proyecto final.
10. **Cronograma de actividades** (diagrama de Gantt).
11. **Presupuesto/recursos** — herramientas, infraestructura, trabajo de campo, aportes en especie y financiamiento.
12. **Bibliografía** (norma APA).

### Estructura del Proyecto final (a la que apunta el perfil)

- **Cap. 1 — Marco Introductorio / Aspectos generales** (introducción, problema, objetivos, justificación, alcances).
- **Cap. 2 — Marco Teórico.**
- **Cap. 3 — Marco Aplicativo/Práctico** (ingeniería del sistema: análisis, diseño, implementación).
- **Cap. 4 — Prueba de hipótesis / Evaluación** (costo-beneficio, calidad, seguridad).
- **Cap. 5 — Conclusiones y recomendaciones.**
- Bibliografía y anexos.

### Referencias

- Reglamento y normativas oficiales de la carrera: http://informatica.umsa.bo/tramites/ (confirmar índice exacto con el tutor; puede variar en detalles menores).
- Repositorio Institucional UMSA (trabajos similares): https://repositorio.umsa.bo/handle/123456789/1
- Guía de perfil (Farit Rojas, UMSA) y ejemplos: SlideShare "Perfil Proyecto de Grado (Informática)", Scribd "Proyecto de Grado UMSA".
