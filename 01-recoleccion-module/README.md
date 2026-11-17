# Módulo 1 - Recolección

Este directorio documenta captura, recepción física conforme o rechazo, saldo y consumo del material que alimenta Vivero. La actualización funcional del 16 de noviembre de 2026 conserva RF-REC-01–05 y añade RF-REC-06 para el banco público de semillas.

## Orden de lectura

1. `01_reglas_de_negocio_recoleccion.md`
   Fuente canónica de reglas del dominio.

2. `02_flujo_operativo_recoleccion.md`
   Flujo práctico del módulo: estados, proceso operativo, diagramas, acciones, casos borde y lectura del historial.

3. `00_requerimientos_recoleccion.json`
   Requerimientos funcionales estructurados `RF-REC-*`.

4. `03_checklist_validacion_recoleccion.md`
   Checklist para desarrollo, QA y validación antes de cerrar el módulo.

## Fuentes de verdad

- Reglas de negocio del módulo: `01_reglas_de_negocio_recoleccion.md`
- Esquema, tablas y enums: `../database/00_database_schema.md`
- Contrato Recolección -> Vivero: [`../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md`](../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md)

El README solo funciona como índice. Las reglas de dominio deben mantenerse en el documento canónico para evitar duplicación.

La [recepción única 100](../../Backend-r3foresta/docs/t4-recepcion-semillas.md) es el contrato vigente frente a los cortes históricos 096–099. La validación backend de 1–5 fotos por sección, el recorrido PWA de fechas conservadas mayores a 45 días y el historial propio completo conservan sus pendientes de verificación. Aplicación SQL, publicación y despliegue se acreditan con su evidencia de entorno.
