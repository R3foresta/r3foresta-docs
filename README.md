# r3foresta-docs

Base documental de R3Foresta: trazabilidad de material vegetal para reforestación. En el Proyecto de Grado, la proyección hacia bonos de carbono es solo contexto: no incluye medición, certificación, emisión, comercialización ni blockchain.

La cadena del dominio: `general (maestros) → recolección (origen) → vivero (maduración) → plantación (campo)`.

## Índice

* [PLANTEAMIENTO-PROBLEMA.md](PLANTEAMIENTO-PROBLEMA.md)
  Contexto, problema central, árbol del problema, alcance y aporte de R3Foresta.

* [00-general-module/README.md](00-general-module/README.md)
  Catálogos y maestros transversales: usuarios, territorios, viveros, plantas, evidencias, `ORGANIZACION`.
* [01-recoleccion-module/README.md](01-recoleccion-module/README.md)
  Módulo 1: registro del lote origen, evidencia, validación, saldo.
* [02-vivero-module/README.md](02-vivero-module/README.md)
  Módulo 2: maduración pre-plantación, eventos append-only, saldo vivo.
* [03-plantacion-module/README.md](03-plantacion-module/README.md)
  Módulo 3: campañas/subcampañas, plantación en campo, mantenimiento, vista pública.
* [90-contratos-integracion/README.md](90-contratos-integracion/README.md)
  Contratos entre módulos: Recolección → Vivero y Vivero → Plantación.
* [database/README.md](database/README.md)
  Esquema ER canónico y scripts.
* [decisiones/README.md](decisiones/README.md)
  Registro unificado de decisiones de arquitectura y diseño (ADR) de todos los módulos.
* [post-mvp/README.md](post-mvp/README.md)
  Ideas y mejoras deliberadamente fuera del MVP, conservadas para futuras iteraciones.

## Otros documentos raíz

* [ARCHITECTURE.md](ARCHITECTURE.md) — arquitectura integral observada: PWA, Backend, Supabase, flujos M1–M3, seguridad, despliegue, calidad y riesgos.
* [database/00_database_schema.md](database/00_database_schema.md) — fuente de verdad estructural del proyecto (tablas + enums en mermaid).
* [glosario.md](glosario.md) — términos clave del dominio, con enlace a su fuente canónica.
* [ESTADO.md](ESTADO.md) — estado vivo de implementación: qué está en producción vs. pendiente.
* [CLAUDE.md](CLAUDE.md) — convenciones e invariantes de dominio del proyecto.
* [AUDITORIA-DOCUMENTACION.md](AUDITORIA-DOCUMENTACION.md) — informe de auditoría de la documentación.
