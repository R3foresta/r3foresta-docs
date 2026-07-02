# Contratos de integracion entre modulos

Esta carpeta documenta los contratos entre modulos de Reforesta.

Un contrato de integracion define:

- que modulo inicia la operacion,
- que modulo recibe o consume datos,
- que entidades participan,
- que precondiciones deben cumplirse,
- que invariantes no pueden romperse,
- que operacion debe ser atomica,
- que errores de negocio pueden ocurrir,
- y que parte pertenece a cada modulo.

Estos documentos no reemplazan la documentacion interna de cada modulo.
Sirven para evitar acoplamientos ambiguos entre modulos.

## Contratos disponibles

- [`01_contrato_recoleccion_a_vivero.md`](01_contrato_recoleccion_a_vivero.md)
- [`02_contrato_vivero_a_plantacion.md`](02_contrato_vivero_a_plantacion.md)

## Relacion con modulos

- `01-recoleccion-module/` documenta el comportamiento interno de Recoleccion.
- `02-vivero-module/` documenta el nucleo operativo de Vivero.
- `03-plantacion-module/` documenta el comportamiento interno de Plantacion.

Los contratos describen solo la frontera entre esos modulos.
