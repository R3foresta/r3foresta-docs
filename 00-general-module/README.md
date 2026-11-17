# Módulo General - Catálogos y Maestros Transversales

Este módulo documenta las entidades base compartidas por Recolección, Vivero y Plantación. La actualización funcional del 16 de noviembre de 2026 incorpora autoridad por operación y ámbito, alta atómica de usuario/passkey y evidencia original con audiencia definida.

## Propósito

Definir una base documental común que cubre

* usuarios, roles globales y accesos M1/M2/contextuales,
* comunidades y estructura territorial,
* ubicaciones,
* viveros,
* plantas,
* evidencias y catálogos transversales.

La idea es evitar que cada módulo vuelva a definir estos conceptos por separado y dejar un contrato claro para `RF-GEN-*`.

## Entidades base cubiertas

* `USUARIO`
* `UBICACION`
* `PAIS`
* `DIVISION_TIPO`
* `DIVISION_ADMINISTRATIVA`
* `VIVERO`
* `TIPO_PLANTA`
* `PLANTA`
* `TIPOS_ENTIDAD_EVIDENCIA`
* `EVIDENCIAS_TRAZABILIDAD`
* `METODO_RECOLECCION`
* `ORGANIZACION`

## Documentos de este módulo

* `00_Requerimientos_Modulo_General.json`: requerimientos funcionales base.
* `01_reglas_de_negocio_general.md`: reglas transversales del dominio.
* `02_guia_operativa_modulo_general.md`: cómo se administran los catálogos y maestros.

Las decisiones de diseño cerradas para el MVP (comunidad, naming de planta, roles, ubicación, evidencia) se migraron al registro unificado: ver [`../decisiones/01_decisiones_general.md`](../decisiones/01_decisiones_general.md) (índice en [`../decisiones/README.md`](../decisiones/README.md)).

## Dependencias con otros módulos

* Recolección usa este módulo para `RF-GEN-01`, `RF-GEN-02`, `RF-GEN-03`, `RF-GEN-04` y `RF-GEN-05`.
* Vivero hereda snapshots desde Recolección, pero la fuente maestra original de plantas, usuarios, viveros y territorios vive aquí.
* Plantación (Módulo 3) consume `ORGANIZACION` (`RF-GEN-07`) vía el puente `CAMPANIA_ORGANIZACION`.
* Base de datos usa este módulo como contrato semántico para tablas maestras.

Las reglas de [recepción única](../../Backend-r3foresta/docs/t4-recepcion-semillas.md) y [altas/WebAuthn](../../Backend-r3foresta/docs/revision-altas-mvp-2026-11-16.md) identifican sus contratos y límites de entorno. La actualización de requisitos no acredita aplicación SQL, despliegue ni aceptación de recorridos pendientes.
