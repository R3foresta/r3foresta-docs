# Modelo físico de la base de datos de R3Foresta

**Actualización documental del 16 de noviembre de 2026.** El esquema aportado por Pablo y confirmado en el chat como la última versión contiene **57 tablas y 622 columnas**. La fecha identifica esta recepción documental. El adjunto carece de identificador de proyecto y fecha de exportación. Su estructura se representa con esa procedencia y las capacidades se consultan en los módulos, contratos y [ESTADO.md](../ESTADO.md).

[Diagrama completo en SVG](diagramas/modelo-fisico-completo.svg) · [Fuente Mermaid completa](diagramas/modelo-fisico-completo.mmd)

## Vistas del mismo modelo

| Vista | Tablas | Uso |
|---|---:|---|
| [Recorrido principal](diagramas/modelo-fisico-nucleo.svg) · [Mermaid](diagramas/modelo-fisico-nucleo.mmd) | 16 | Recolección, recepción, movimientos, lotes, incorporación, campañas, asignaciones y registros de Plantación. |
| [General](diagramas/modelo-fisico-general.svg) · [Mermaid](diagramas/modelo-fisico-general.mmd) | 13 | Usuarios, credenciales, organizaciones, plantas, territorio y evidencias. |
| [Participación](diagramas/modelo-fisico-participacion.svg) · [Mermaid](diagramas/modelo-fisico-participacion.mmd) | 11 | Permisos, equipo logístico, comandos, auditoría de autoridad y cargas. |
| [Correcciones](diagramas/modelo-fisico-correcciones.svg) · [Mermaid](diagramas/modelo-fisico-correcciones.mmd) | 13 | Originales, revisiones, estado efectivo, participantes, créditos y compensaciones. |
| [Operación por vivero](diagramas/modelo-fisico-operacion.svg) · [Mermaid](diagramas/modelo-fisico-operacion.mmd) | 20 | Accesos M1/M2, recepción, contexto de fotografías e incorporación. |

Las vistas temáticas repiten tablas compartidas y conservan todas sus columnas. Cada vista dibuja relaciones con ambos extremos incluidos. El completo incluye `spatial_ref_sys`, tabla técnica de PostGIS. Los campos históricos de blockchain y las tablas de corrección conservan su presencia física y su alcance funcional propio.

## Fuentes y correspondencia

1. [Extracto contextual recibido el 16 de noviembre](fuentes/supabase-estructura-2026-11-16.sql). Se preservan exactamente los bytes del adjunto y su advertencia de uso contextual. De aquí proceden nombres, orden, tipos declarados, nulabilidad, claves primarias, unicidad individual, identidad y las restricciones visibles.
2. [Procedencia de relaciones y huella SHA-256](fuentes/supabase-relaciones-2026-11-16.json). El extracto contiene 190 filas de referencias que representan **175 relaciones**, distribuidas en 160 simples y 15 compuestas. Las compuestas aparecen divididas bajo un mismo nombre de restricción. Se agrupan por tabla y nombre y se contrastan sus pares de columnas con las migraciones locales 070, 072, 074, 082, 092, 094 y 100. El archivo identifica la migración de cada una.
3. El [extracto del 4 de noviembre](fuentes/supabase-estructura-2026-11-04.md) y sus [metadatos](fuentes/supabase-relaciones-2026-11-04.json) conservan el corte histórico de 51 tablas y 564 columnas, incluidas las 139 referencias simples de PostgREST cotejadas entonces y las siete compuestas documentadas en ese corte. Esa consulta conserva su fecha y entorno propios.

La revisión actual utilizó el adjunto y las migraciones locales. El catálogo remoto, los cuerpos RPC, índices completos, triggers, grants, RLS, Storage y replay de migraciones mantienen su comprobación independiente. Las migraciones 111–113 afectan altas y funciones cuya aplicación completa no puede establecerse mediante este inventario de tablas. Las claves compuestas agrupadas describen una sola restricción por nombre y tabla.

## Lectura de la notación

- `PK` identifica columnas de clave primaria. Varios componentes forman una sola clave compuesta.
- `UK` identifica unicidad individual visible. Una clave compuesta conserva su conjunto de columnas.
- `FK` identifica componentes de referencias explícitas del extracto y del contraste documentado.
- `NN`, `NULL` e `IDENTITY` conservan obligatoriedad e identidad. Una PK implica obligatoriedad.
- `USER_DEFINED` representa el literal `USER-DEFINED` del adjunto. El tipo enumerado o dominio concreto queda sin resolver en esta fuente. Los nombres históricos del extracto del 4 de noviembre mantienen su procedencia histórica.
- Los tipos con espacios utilizan guiones bajos para ser legibles por Mermaid, como `timestamp_with_time_zone` y `character_varying`. Las expresiones originales permanecen en la fuente SQL.
- La línea continua identifica relaciones cuyas columnas FK pertenecen a la PK hija. La discontinua identifica las restantes.
- La opcionalidad del padre depende de la nulabilidad de la FK. La cardinalidad hija cero-a-uno se representa cuando PK o unicidad individual visible la sustentan. Las demás relaciones se dibujan cero-a-muchos, pendientes de índices y restricciones adicionales ausentes del extracto.

## Cambios frente al corte del 4 de noviembre

Se incorporan catorce tablas al inventario recibido.

| Familia | Tablas |
|---|---|
| Acceso M1 | `recoleccion_acceso_comando`, `usuario_acceso_recoleccion`, `usuario_acceso_recoleccion_revision`, `usuario_acceso_recoleccion_historial` |
| Acceso M2 | `vivero_acceso_comando`, `usuario_vivero`, `usuario_vivero_revision`, `usuario_vivero_historial` |
| Evidencia operativa | `m2_evidencia_contexto` |
| Recepción | `recoleccion_recepcion_comando`, `recoleccion_recepcion`, `recoleccion_recepcion_evidencia_contexto`, `recoleccion_recepcion_evidencia` |
| Incorporación | `vivero_incorporacion` |

Las ocho tablas `plantacion`, `plantacion_usuario`, `plantacion_riego`, `plantacion_abono`, `plantacion_foto`, `plantacion_monitoreo`, `tipo_riego` y `tipo_abono` están ausentes del extracto actual. El [diagrama legado del 4 de noviembre](diagramas/modelo-fisico-legado.svg) y su [fuente](diagramas/modelo-fisico-legado.mmd) conservan aquella observación. La ausencia en un extracto acredita la diferencia entre fuentes y deja pendiente el acto y fecha de retirada en cada entorno.

## Precisiones físicas relevantes

- `recoleccion.revision_captura` es NN y permite vincular fotografías y decisiones a la revisión correspondiente. `usuario_validacion_id` y `fecha_validacion` dejan de figurar en Recolección. El hecho inmutable de recepción contiene `fecha_recepcion`, `recibido_por` y `registrado_en`.
- `lote_vivero.recoleccion_id`, `tipo_material_snapshot`, `cantidad_inicial_en_proceso` y `unidad_medida_inicial` son nullable. El contrato limita esos nulos al camino incorporado. `vivero_id` y `planta_id` permanecen NN.
- `vivero_incorporacion` extiende el evento por `evento_id` PK/FK y contiene modalidad, procedencia, tercero/referencia opcionales, solicitud UUID única, huella y instante de registro. La base viva única corresponde a las restricciones y transacciones de T5.
- `m2_evidencia_contexto` admite el contexto `INCORPORACION` y `solicitud_id`. El permiso de lectura o escritura exige su contrato de audiencia.
- `recoleccion_movimiento.lote_vivero_id` permanece como columna sin una FK explícita al lote en este extracto. Su vínculo semántico se consulta en el contrato M1→M2.
- `evidencias_trazabilidad.entidad_id` conserva su asociación polimórfica. El diagrama representa las FKs que figuran expresamente en la fuente.
- Permisos de participación y equipo logístico conservan tablas distintas. El rol global permanece en `usuario.rol`.
- `campania` conserva estado derivado. Las vistas y funciones no aparecen como tablas adicionales.
- Las columnas de saldo generadas conservan la nulabilidad exportada. Las fórmulas, CHECK y DEFAULT visibles permanecen en el SQL contextual.

## Regeneración

```sh
node database/scripts/generar-modelo-fisico.mjs
node database/scripts/renderizar-modelo-fisico.mjs
```

El primer script valida las referencias y sus columnas, genera seis fuentes Mermaid y publica conteos por vista. El segundo requiere Mermaid CLI (`mmdc`) o `--cli /ruta/a/mermaid-cli/src/cli.js` y regenera los seis SVG actuales. El diagrama legado histórico queda accesible por separado. Las modificaciones se realizan en las fuentes y el generador antes de regenerar los SVG.

El [esquema anterior al 4 de noviembre](archivo/00_database_schema-antes-2026-11-04.md) conserva la documentación histórica previa a ambos contrastes.
