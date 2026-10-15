# R3Foresta — documentación

Base documental de la trazabilidad de material vegetal: `General → Recolección → Vivero → Plantación`. El Proyecto de Grado no incluye medición, certificación ni comercialización de bonos de carbono.

## Empezar aquí

| Necesito… | Leer |
|---|---|
| Saber qué existe, qué se verificó y qué falta | [ESTADO.md](ESTADO.md) |
| Continuar el incremento actual de Participación aliada | [PA-F01: índice](specs/plantacion/participacion-aliada/README.md) → [tablero de ejecución](specs/plantacion/participacion-aliada/implementacion/README.md) |
| Entender cómo se relacionan specs, tareas y entregas INT | [Guía de specs](specs/README.md) |
| Trabajar como agente | [AGENTS.md](AGENTS.md), luego las fuentes de la entrega |

PA-F01 tiene cierre local parcial de [INT02-C](specs/plantacion/participacion-aliada/implementacion/pa-t-int02-c.md): APIs/comandos de acceso y rol/baja verificados; 072/073 confirmadas aplicadas y superficie REST comprobada en desarrollo. Cuerpos SQL remotos, despliegue/entorno frontend e INT03-A/D siguen pendientes. [Informe y pruebas](../Backend-r3foresta/docs/pa-int02c-entrega-local.md).

## Fuentes de dominio

| Área | Contenido |
|---|---|
| [General](00-general-module/README.md) | Usuarios, organizaciones, territorios, especies y demás catálogos maestros. |
| [Recolección](01-recoleccion-module/README.md) | Origen del material, evidencia, validación y saldo. |
| [Vivero](02-vivero-module/README.md) | Lote, maduración, eventos y saldo físico. |
| [Plantación](03-plantacion-module/README.md) | Campaña/subcampaña, plan, registro en campo y mantenimiento. |
| [Contratos entre módulos](90-contratos-integracion/README.md) | Recolección → Vivero y Vivero → Plantación. |
| [Decisiones ADR](decisiones/README.md) | Decisiones transversales e invariantes aceptados. |
| [Datos y SQL](database/README.md) | Esquema documentado y copias/scripts de soporte; la aplicación en un entorno se acredita en ESTADO. |

Las reglas de los módulos y los ADR definen la base; las [specs](specs/README.md) precisan el incremento. El estado de implementación y la evidencia se consultan por separado. Un diseño aceptado no acredita despliegue.

## Referencias y archivo

- [ARCHITECTURE.md](ARCHITECTURE.md): arquitectura observada, con su fecha y límites.
- [Glosario](glosario.md) y [CLAUDE.md](CLAUDE.md): vocabulario y convenciones/invariantes adicionales.
- [Documentación de grado](documentacion-grado/README.md): investigación, metodología y entregables académicos. [Capítulo I](documentacion-grado/06_entregables/proyecto_grado/01_capitulo_marco_introductorio.md).
- [Post-MVP](post-mvp/README.md): trabajo expresamente fuera del alcance actual.
- [Archivo general](archivo/README.md): estados acumulados y auditorías fechadas. [Archivo de PA-F01](specs/plantacion/participacion-aliada/archivo/README.md): actas, planes anteriores y entregas cerradas.

`bridge/`, `tmp/` y `output/` conservan material de intercambio o generado; sus copias no sustituyen las fuentes anteriores. Los archivos Excalidraw se gestionan aparte y no forman parte de esta ruta de consulta.
