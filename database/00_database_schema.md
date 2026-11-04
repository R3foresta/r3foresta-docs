# Modelo físico de la base de datos de R3Foresta

**Actualización documental:** 4 de noviembre de 2026. **Cobertura:** 51 tablas y 564 columnas de la exportación de Supabase aportada por Pablo. Este modelo representa estructura física; las reglas y capacidades de aplicación se consultan en los módulos, contratos y [ESTADO.md](../ESTADO.md).

[Ver diagrama completo en SVG](diagramas/modelo-fisico-completo.svg) · [Fuente Mermaid completa](diagramas/modelo-fisico-completo.mmd)

## Vistas del mismo modelo

| Vista | Tablas | Uso |
|---|---:|---|
| [Recorrido principal](diagramas/modelo-fisico-nucleo.svg) · [Mermaid](diagramas/modelo-fisico-nucleo.mmd) | 14 | Recolección, movimientos, lotes, eventos, campañas, asignaciones y registros de plantación. |
| [General](diagramas/modelo-fisico-general.svg) · [Mermaid](diagramas/modelo-fisico-general.mmd) | 13 | Usuarios, credenciales, organizaciones, plantas, territorio y evidencias. |
| [Participación](diagramas/modelo-fisico-participacion.svg) · [Mermaid](diagramas/modelo-fisico-participacion.mmd) | 11 | Permisos, equipo logístico, comandos, auditoría de autoridad y cargas. |
| [Correcciones](diagramas/modelo-fisico-correcciones.svg) · [Mermaid](diagramas/modelo-fisico-correcciones.mmd) | 13 | Originales, revisiones, estado efectivo, participantes, créditos y compensaciones. |
| [Tablas conservadas de Plantación](diagramas/modelo-fisico-legado.svg) · [Mermaid](diagramas/modelo-fisico-legado.mmd) | 10 | Estructura anterior de plantación y tablas de riego, abono y monitoreo. |

Las vistas temáticas repiten tablas compartidas para poder leerse de forma independiente. Conservan todas las columnas de cada tabla representada y solo dibujan relaciones cuyos dos extremos aparecen en la vista. El diagrama completo incluye también `spatial_ref_sys`, tabla técnica de PostGIS. Las tablas de seguimiento y los campos históricos de blockchain permanecen en el inventario físico sin ampliar el alcance académico.

## Lectura de la notación

- `PK`: columna de la clave primaria. Cuando varias columnas tienen PK, forman una sola clave compuesta.
- `UK`: unicidad individual indicada en la exportación. No se atribuye unicidad individual a cada componente de un índice compuesto.
- `FK`: componente de una clave foránea de las fuentes identificadas abajo.
- `NN` y `NULL`: obligatoriedad y nulabilidad declaradas por la exportación; `IDENTITY` conserva su indicación de generación.
- Tipos como `int8`, `int4`, `bool`, `bpchar`, `citext`, `geometry` y `_text` conservan el nombre del extracto. `_text` representa un arreglo de texto.
- Línea continua: relación identificadora, con las columnas FK incluidas en la PK hija. Línea discontinua: relación no identificadora.
- La opcionalidad del extremo padre sigue la nulabilidad de la FK. El extremo hijo es cero-a-uno únicamente cuando la exportación acredita PK o unicidad suficiente; en los demás casos se muestra cero-a-muchos.

## Fuentes y correspondencia

1. [Exportación aportada de Supabase](fuentes/supabase-estructura-2026-11-04.md): fuente de nombres, orden, tipos, columnas, PK, unicidad individual, nulabilidad, identity y enumeraciones. Se conserva el texto recibido, con normalización del salto de línea final.
2. [Metadatos de relaciones](fuentes/supabase-relaciones-2026-11-04.json): lectura `GET /rest/v1/` del proyecto `vyrjlehkhabydkhjxagx`, realizada el 4 de noviembre. Se utilizaron 139 referencias simples entre tablas de la exportación. No se consultaron filas de negocio.
3. Las siete referencias compuestas se documentan separadamente en ese archivo, con su origen en las migraciones backend [070](../../Backend-r3foresta/migrations/070_pa_int02b_permisos_contextuales.sql), [072](../../Backend-r3foresta/migrations/072_pa_int02c_comandos_acceso.sql), [074](../../Backend-r3foresta/migrations/074_pa_int03a_cargas.sql) y [082](../../Backend-r3foresta/migrations/082_pa_int07_persistencia.sql). Los comentarios Mermaid distinguen `PostgREST` de `SQL 070/072/074/082`. No se presentan como una nueva inspección de `pg_constraint` del entorno remoto.

El extracto no proporciona longitudes, precisión/escala, expresiones DEFAULT o GENERATED, todas las restricciones CHECK, índices compuestos/parciales, triggers ni privilegios/RLS. El diagrama no inventa esos detalles ni equivale a un DDL de reconstrucción o a una certificación de replay de las 91 migraciones. El catálogo REST tampoco permite afirmar que esta lista sea una auditoría exhaustiva de todas las claves del servidor.

Las descripciones históricas de tablas se conservan literalmente en la fuente, pero no sustituyen los contratos vigentes de la aplicación. Por ejemplo, la descripción antigua de corresponsables no convierte el equipo logístico en autorización para el registro participante actual.

## Precisiones físicas relevantes

- `usuario` contiene `activo`, `revision_autoridad` y `organizacion_id`. El rol global permanece en una sola columna.
- `subcampania_permiso` y `subcampania_permiso_revision` están separadas de `subcampania_equipo`. Permisos de participación y logística no son la misma relación.
- `participacion_comando`, `usuario_autoridad_historial`, `participacion_carga` y `participacion_carga_generacion` forman parte del inventario.
- Las siete tablas de persistencia efectiva y compensaciones también se incluyen. Su existencia no acredita todos los ejecutores o interfaces de corrección.
- `lote_vivero.recoleccion_id` y `lote_vivero.vivero_id` permanecen NN. No se agregan una tabla de operarios por vivero, columnas de incorporación externa ni un evento de incorporación como si ya estuvieran desplegados.
- `recoleccion_movimiento` utiliza `unidad_medida_evento`; el campo `unidad_operativa` es adicional y nullable.
- `recoleccion_movimiento.lote_vivero_id` figura como columna, pero no se dibuja una FK hacia `lote_vivero`: el catálogo consultado no la identifica como tal.
- `evidencias_trazabilidad.entidad_id` es el identificador de una asociación polimórfica. No se dibujan FKs físicas desde esa columna a Recolección, eventos de Vivero o Plantación.
- `campania` no contiene una columna de estado. Las vistas y funciones derivadas no se representan como tablas.
- Los tres saldos generados exportados como nullable conservan esa nulabilidad; no se confunde una regla de negocio o una expresión generada con una restricción NOT NULL.

## Regeneración

Las columnas de los diagramas se generan mecánicamente con el [script](scripts/generar-modelo-fisico.mjs):

```sh
node database/scripts/generar-modelo-fisico.mjs
node database/scripts/renderizar-modelo-fisico.mjs
```

El segundo script requiere Mermaid CLI (`mmdc`) y renderiza las seis vistas. También admite `--cli /ruta/a/mermaid-cli/src/cli.js` para una instalación local. Antes de cambiar las relaciones, actualizar su fuente y conservar la distinción entre catálogo remoto y migraciones. No editar únicamente el SVG generado.

El [esquema anterior](archivo/00_database_schema-antes-2026-11-04.md) conserva el ER, comentarios, enumeraciones y funciones documentados antes de este contraste.
