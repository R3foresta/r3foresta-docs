## Table `usuario`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `nombre` | `text` |  |
| `doc_identidad` | `text` |  Nullable Unique |
| `wallet_address` | `text` |  Nullable Unique |
| `organizacion` | `text` |  Nullable |
| `contacto` | `text` |  Nullable |
| `rol` | `rol_usuario` |  |
| `created_at` | `timestamptz` |  |
| `username` | `text` |  Nullable Unique |
| `auth_id` | `text` |  |
| `correo` | `text` |  Nullable Unique |
| `apellido` | `text` |  Nullable |
| `foto_perfil_url` | `text` |  Nullable |
| `activo` | `bool` |  |
| `revision_autoridad` | `int8` |  |
| `organizacion_id` | `int8` |  Nullable |

## Table `ubicacion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `latitud` | `numeric` |  Nullable |
| `longitud` | `numeric` |  Nullable |
| `created_at` | `timestamptz` |  |
| `pais_id` | `int8` |  Nullable |
| `division_id` | `int8` |  Nullable |
| `nombre` | `text` |  Nullable |
| `precision_m` | `int4` |  Nullable |
| `fuente` | `text` |  Nullable |
| `referencia` | `text` |  Nullable |
| `updated_at` | `timestamptz` |  Nullable |

## Table `vivero`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `codigo` | `text` |  Unique |
| `nombre` | `citext` |  |
| `ubicacion_id` | `int8` |  Unique |
| `created_at` | `timestamptz` |  |

## Table `planta`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `especie` | `text` |  |
| `nombre_cientifico` | `text` |  |
| `variedad` | `text` |  |
| `created_at` | `timestamptz` |  |
| `nombre_comun_principal` | `text` |  Nullable |
| `nombres_comunes` | `text` |  Nullable |
| `imagen_url` | `text` |  Nullable |
| `notas` | `text` |  Nullable |
| `tipo_planta_id` | `int4` |  |
| `activo` | `bool` |  |
| `updated_at` | `timestamptz` |  |

## Table `metodo_recoleccion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `nombre` | `citext` |  Unique |
| `descripcion` | `text` |  Nullable |

## Table `recoleccion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `fecha` | `date` |  |
| `tipo_material` | `tipo_material_origen` |  |
| `especie_nueva` | `bool` |  |
| `observaciones` | `text` |  Nullable |
| `usuario_id` | `int8` |  |
| `ubicacion_id` | `int8` |  |
| `vivero_id` | `int8` |  Nullable |
| `metodo_id` | `int8` |  |
| `planta_id` | `int8` |  Nullable |
| `created_at` | `date` |  |
| `codigo_trazabilidad` | `text` |  Unique |
| `blockchain_url` | `text` |  Nullable |
| `token_id` | `text` |  Nullable |
| `transaction_hash` | `text` |  Nullable |
| `estado_registro` | `estado_registro_recoleccion` |  |
| `unidad_canonica` | `unidad_medida` |  |
| `cantidad_inicial_canonica` | `numeric` |  |
| `usuario_validacion_id` | `int8` |  Nullable |
| `fecha_validacion` | `date` |  Nullable |
| `saldo_actual` | `numeric` |  |
| `estado_operativo` | `estado_operativo_recoleccion` |  |
| `nombre_cientifico_snapshot` | `text` |  Nullable |
| `nombre_comercial_snapshot` | `text` |  Nullable |
| `variedad_snapshot` | `text` |  Nullable |
| `nombre_comunidad_snapshot` | `text` |  Nullable |
| `nombre_recolector_snapshot` | `text` |  Nullable |
| `eliminado_en` | `date` |  Nullable |
| `eliminado_por_usuario_id` | `int8` |  Nullable |
| `motivo_eliminacion` | `text` |  Nullable |
| `motivo_rechazo` | `text` |  Nullable |

## Table `usuario_credencial`

Almacena las credenciales de WebAuthn (passkeys) para autenticación biométrica

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `usuario_id` | `int8` |  |
| `credential_id` | `text` |  Unique |
| `public_key` | `text` |  |
| `algorithm` | `text` |  |
| `counter` | `int4` |  |
| `transports` | `_text` |  Nullable |
| `created_at` | `timestamptz` |  |
| `last_used_at` | `timestamptz` |  Nullable |

## Table `tipo_riego`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int4` | Primary |
| `nombre` | `text` |  Unique |
| `descripcion` | `text` |  Nullable |

## Table `tipo_abono`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int4` | Primary |
| `nombre` | `text` |  Unique |
| `descripcion` | `text` |  Nullable |

## Table `plantacion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `codigo_trazabilidad` | `text` |  Unique |
| `destino` | `text` |  |
| `ubicacion_id` | `int4` |  |
| `cantidad_arboles` | `int4` |  |
| `fecha_plantacion` | `date` |  |
| `superficie_m2` | `numeric` |  Nullable |
| `tamano_promedio_cm` | `numeric` |  Nullable |
| `propietario` | `text` |  Nullable |
| `origen_propiedad` | `text` |  Nullable |
| `frecuencia_monitoreo_dias` | `int4` |  Nullable |
| `created_by` | `int4` |  Nullable |
| `created_at` | `timestamptz` |  |

## Table `plantacion_usuario`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `plantacion_id` | `int8` | Primary |
| `usuario_id` | `int4` | Primary |
| `rol` | `text` |  Nullable |

## Table `plantacion_riego`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `plantacion_id` | `int8` | Primary |
| `tipo_riego_id` | `int4` | Primary |

## Table `plantacion_abono`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `plantacion_id` | `int8` | Primary |
| `tipo_abono_id` | `int4` | Primary |

## Table `plantacion_foto`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `plantacion_id` | `int8` |  |
| `url` | `text` |  |
| `peso_bytes` | `int4` |  Nullable |
| `formato` | `text` |  Nullable |
| `descripcion` | `text` |  Nullable |

## Table `plantacion_monitoreo`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `plantacion_id` | `int8` |  |
| `fecha_monitoreo` | `date` |  |
| `arboles_vivos` | `int4` |  Nullable |
| `arboles_muertos` | `int4` |  Nullable |
| `arboles_reemplazados` | `int4` |  Nullable |
| `notas` | `text` |  Nullable |
| `usuario_id` | `int4` |  Nullable |
| `created_at` | `timestamptz` |  |

## Table `tipo_planta`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int4` | Primary |
| `nombre` | `text` |  Unique |
| `created_at` | `timestamptz` |  Nullable |

## Table `pais`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `nombre` | `text` |  |
| `codigo_iso2` | `bpchar` |  Unique |
| `codigo_iso3` | `bpchar` |  Nullable |
| `activo` | `bool` |  |
| `created_at` | `timestamptz` |  |

## Table `division_tipo`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `pais_id` | `int8` |  |
| `nombre` | `text` |  |
| `orden` | `int4` |  |
| `activo` | `bool` |  |
| `created_at` | `timestamptz` |  |

## Table `division_administrativa`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary |
| `pais_id` | `int8` |  |
| `parent_id` | `int8` |  Nullable |
| `tipo_id` | `int8` |  |
| `nombre` | `text` |  |
| `codigo_externo` | `text` |  Nullable |
| `activo` | `bool` |  |
| `reemplazada_por_id` | `int8` |  Nullable |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  Nullable |

## Table `tipos_entidad_evidencia`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int2` | Primary Identity |
| `codigo` | `text` |  Unique |
| `descripcion` | `text` |  Nullable |
| `activo` | `bool` |  |
| `creado_en` | `timestamptz` |  |

## Table `evidencias_trazabilidad`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `tipo_entidad_id` | `int2` |  |
| `entidad_id` | `int8` |  |
| `codigo_trazabilidad` | `text` |  Nullable |
| `bucket` | `text` |  |
| `ruta_archivo` | `text` |  |
| `storage_object_id` | `uuid` |  Nullable |
| `tipo_archivo` | `text` |  |
| `mime_type` | `text` |  |
| `tamano_bytes` | `int8` |  Nullable |
| `hash_sha256` | `text` |  Nullable |
| `titulo` | `text` |  Nullable |
| `descripcion` | `text` |  Nullable |
| `metadata` | `jsonb` |  |
| `es_principal` | `bool` |  |
| `orden` | `int4` |  |
| `tomado_en` | `timestamptz` |  Nullable |
| `creado_en` | `date` |  |
| `actualizado_en` | `date` |  |
| `eliminado_en` | `date` |  Nullable |
| `creado_por_usuario_id` | `int8` |  |
| `actualizado_por_usuario_id` | `int8` |  Nullable |
| `eliminado_por_usuario_id` | `int8` |  Nullable |

## Table `recoleccion_movimiento`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `recoleccion_id` | `int8` |  |
| `tipo_movimiento` | `tipo_movimiento_recoleccion` |  |
| `delta` | `numeric` |  |
| `unidad_medida_evento` | `unidad_medida` |  |
| `motivo` | `motivo_movimiento_recoleccion` |  Nullable |
| `motivo_otro` | `text` |  Nullable |
| `lote_vivero_id` | `int8` |  Nullable |
| `detalle_cambios` | `jsonb` |  Nullable |
| `created_by` | `int8` |  |
| `created_at` | `date` |  |
| `transaction_hash` | `text` |  Nullable |
| `unidad_operativa` | `unidad_medida` |  Nullable |

## Table `lote_vivero`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `recoleccion_id` | `int8` |  |
| `planta_id` | `int8` |  |
| `vivero_id` | `int8` |  |
| `responsable_id` | `int8` |  |
| `nombre_cientifico_snapshot` | `text` |  |
| `nombre_comercial_snapshot` | `text` |  |
| `tipo_material_snapshot` | `tipo_material_origen` |  |
| `fecha_inicio` | `date` |  |
| `cantidad_inicial_en_proceso` | `numeric` |  |
| `unidad_medida_inicial` | `unidad_medida` |  |
| `plantas_vivas_iniciales` | `int4` |  Nullable |
| `saldo_vivo_actual` | `int4` |  Nullable |
| `subetapa_actual` | `subetapa_adaptabilidad` |  Nullable |
| `estado_lote` | `estado_lote_vivero` |  |
| `motivo_cierre` | `motivo_cierre_lote` |  Nullable |
| `codigo_trazabilidad` | `text` |  Unique |
| `created_at` | `date` |  |
| `updated_at` | `date` |  |
| `variedad_snapshot` | `text` |  Nullable |
| `nombre_comunidad_origen_snapshot` | `text` |  Nullable |
| `nombre_responsable_snapshot` | `text` |  Nullable |

## Table `evento_lote_vivero`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `lote_id` | `int8` |  |
| `tipo_evento` | `tipo_evento_vivero` |  |
| `fecha_evento` | `date` |  |
| `created_at` | `date` |  |
| `responsable_id` | `int8` |  |
| `cantidad_afectada` | `numeric` |  Nullable |
| `unidad_medida_evento` | `unidad_medida` |  Nullable |
| `causa_merma` | `causa_merma_vivero` |  Nullable |
| `destino_tipo` | `destino_tipo_vivero` |  Nullable |
| `destino_referencia` | `text` |  Nullable |
| `comunidad_destino_id` | `int8` |  Nullable |
| `subetapa_destino` | `subetapa_adaptabilidad` |  Nullable |
| `saldo_vivo_antes` | `int4` |  Nullable |
| `saldo_vivo_despues` | `int4` |  Nullable |
| `motivo_cierre_calculado` | `motivo_cierre_lote` |  Nullable |
| `ref_evento_trigger_id` | `int8` |  Nullable |
| `metadata_blockchain` | `jsonb` |  Nullable |
| `observaciones` | `text` |  Nullable |
| `origen_despacho` | `origen_despacho_vivero` |  Nullable |
| `subcampania_id` | `int8` |  Nullable |
| `campania_id` | `int8` |  Nullable |
| `registro_plantacion_id` | `int8` |  Nullable |
| `metadata` | `jsonb` |  Nullable |
| `causa_descarte_pre_embolsado` | `causa_descarte_pre_embolsado` |  Nullable |
| `asignacion_id` | `int8` |  Nullable |

## Table `recoleccion_historial`

Historial append-only del ciclo de vida del registro de recoleccion. No registra movimientos de saldo.

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `recoleccion_id` | `int8` |  |
| `tipo_historial` | `tipo_historial_recoleccion` |  |
| `estado_origen` | `estado_registro_recoleccion` |  Nullable |
| `estado_destino` | `estado_registro_recoleccion` |  Nullable |
| `observaciones` | `text` |  Nullable |
| `metadata` | `jsonb` |  |
| `actor_user_id` | `int8` |  Nullable |
| `created_at` | `date` |  |

## Table `asignacion_vivero_subcampania`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `subcampania_id` | `int8` |  |
| `lote_vivero_id` | `int8` |  |
| `proposito` | `proposito_asignacion` |  |
| `estado` | `estado_asignacion_vivero` |  |
| `cantidad_asignada` | `int4` |  |
| `cantidad_consumida` | `int4` |  |
| `cantidad_devuelta` | `int4` |  |
| `cantidad_mermada` | `int4` |  |
| `saldo_asignado_disponible` | `int4` |  Nullable |
| `usuario_asignacion_id` | `int8` |  |
| `fecha_asignacion` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `fecha_entrega_operativa` | `date` |  Nullable |

## Table `spatial_ref_sys`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `srid` | `int4` | Primary |
| `auth_name` | `varchar` |  Nullable |
| `auth_srid` | `int4` |  Nullable |
| `srtext` | `varchar` |  Nullable |
| `proj4text` | `varchar` |  Nullable |

## Table `organizacion`

Placeholder modulo General. Reemplazar/ampliar cuando el modulo General defina su esquema.

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `nombre` | `text` |  Unique |
| `activo` | `bool` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `logo_url` | `text` |  Nullable |
| `tipo` | `tipo_organizacion` |  |

## Table `campania`

Contenedor estrategico de subcampanias. No persiste estado: el estado es derivado via vista campania_estado.

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `nombre` | `text` |  Unique |
| `descripcion` | `text` |  Nullable |
| `fecha_estimada_inicio` | `date` |  Nullable |
| `fecha_estimada_fin` | `date` |  Nullable |
| `codigo_trazabilidad` | `text` |  Unique |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `created_by` | `int8` |  |
| `updated_by` | `int8` |  |
| `deleted_at` | `timestamptz` |  Nullable |
| `deleted_by` | `int8` |  Nullable |
| `metadata_blockchain` | `jsonb` |  Nullable |
| `tipo` | `tipo_subcampania` |  |

## Table `campania_organizacion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `campania_id` | `int8` |  |
| `organizacion_id` | `int8` |  |
| `created_at` | `timestamptz` |  |
| `created_by` | `int8` |  |

## Table `subcampania`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `campania_id` | `int8` |  |
| `nombre` | `text` |  |
| `descripcion` | `text` |  Nullable |
| `tipo` | `tipo_subcampania` |  |
| `estado` | `estado_subcampania` |  |
| `fase_mantenimiento` | `fase_mantenimiento_subcampania` |  |
| `zona_id` | `int8` |  |
| `poligono_geom` | `geometry` |  Nullable |
| `area_hectareas` | `numeric` |  Nullable |
| `meta_total_arboles` | `int4` |  |
| `fecha_estimada_inicio` | `date` |  Nullable |
| `fecha_estimada_fin` | `date` |  Nullable |
| `fecha_cierre_operativo` | `timestamptz` |  Nullable |
| `fecha_fin_mantenimiento` | `date` |  Nullable |
| `motivo_cierre_parcial` | `motivo_cierre_parcial` |  Nullable |
| `observaciones_cierre` | `text` |  Nullable |
| `tolerancia_gps_metros` | `int4` |  |
| `nombre_zona_snapshot` | `text` |  Nullable |
| `nombre_coordinador_snapshot` | `text` |  Nullable |
| `nombres_organizaciones_snapshot` | `_text` |  Nullable |
| `codigo_trazabilidad` | `text` |  Unique |
| `total_plantado_inicial` | `int4` |  |
| `total_repuesto` | `int4` |  |
| `total_muerto_acumulado` | `int4` |  |
| `saldo_vivo_actual` | `int4` |  Nullable |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `created_by` | `int8` |  |
| `updated_by` | `int8` |  |
| `deleted_at` | `timestamptz` |  Nullable |
| `deleted_by` | `int8` |  Nullable |
| `metadata_blockchain` | `jsonb` |  Nullable |
| `plan_revision` | `int8` |  |
| `participacion_inicializada_en` | `timestamptz` |  Nullable |
| `participacion_inicializada_por` | `int8` |  Nullable |

## Table `subcampania_equipo`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `subcampania_id` | `int8` |  |
| `usuario_id` | `int8` |  |
| `rol` | `rol_en_subcampania` |  |
| `agregado_at` | `timestamptz` |  |
| `agregado_by` | `int8` |  |

## Table `registro_plantacion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `subcampania_id` | `int8` |  |
| `es_reposicion` | `bool` |  |
| `registro_plantacion_origen_id` | `int8` |  Nullable |
| `fecha_plantacion` | `date` |  |
| `responsable_id` | `int8` |  |
| `latitud` | `numeric` |  |
| `longitud` | `numeric` |  |
| `gps_dentro_poligono` | `bool` |  |
| `gps_distancia_a_poligono_m` | `numeric` |  Nullable |
| `cantidad_total_plantada` | `int4` |  |
| `cantidad_muerta_acumulada` | `int4` |  |
| `cantidad_repuesta_acumulada` | `int4` |  |
| `saldo_vivo_grupo` | `int4` |  Nullable |
| `nombre_subcampania_snapshot` | `text` |  Nullable |
| `nombre_zona_snapshot` | `text` |  Nullable |
| `nombre_responsable_snapshot` | `text` |  Nullable |
| `observaciones` | `text` |  Nullable |
| `codigo_trazabilidad` | `text` |  Unique |
| `created_at` | `timestamptz` |  |
| `created_by` | `int8` |  |
| `metadata_blockchain` | `jsonb` |  Nullable |
| `revision_registro` | `int8` |  |
| `afiliacion_responsable_snapshot` | `text` |  Nullable |
| `afiliacion_responsable_estado` | `text` |  |
| `afiliacion_responsable_tipo` | `text` |  Nullable |
| `organizacion_responsable_id_snapshot` | `int8` |  Nullable |

## Table `registro_plantacion_detalle`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `registro_plantacion_id` | `int8` |  |
| `asignacion_id` | `int8` |  |
| `lote_vivero_id` | `int8` |  |
| `planta_id` | `int8` |  |
| `cantidad` | `int4` |  |
| `nombre_cientifico_snapshot` | `text` |  Nullable |
| `nombre_comercial_snapshot` | `text` |  Nullable |
| `variedad_snapshot` | `text` |  Nullable |
| `evento_lote_vivero_despacho_id` | `int8` |  Nullable |
| `created_at` | `timestamptz` |  |

## Table `registro_plantacion_coresponsable`

Co-responsables del registro. Deben ser subset del SUBCAMPANIA_EQUIPO de la subcampana (validacion en handler).

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `registro_plantacion_id` | `int8` |  |
| `usuario_id` | `int8` |  |
| `created_at` | `timestamptz` |  |
| `nombre_snapshot` | `text` |  Nullable |
| `afiliacion_snapshot` | `text` |  Nullable |
| `afiliacion_estado` | `text` |  |
| `afiliacion_tipo` | `text` |  Nullable |
| `organizacion_id_snapshot` | `int8` |  Nullable |

## Table `evento_plantacion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `tipo_evento` | `tipo_evento_plantacion` |  |
| `subcampania_id` | `int8` |  |
| `registro_plantacion_id` | `int8` |  Nullable |
| `asignacion_id` | `int8` |  Nullable |
| `fecha_evento` | `timestamptz` |  |
| `responsable_id` | `int8` |  |
| `observaciones` | `text` |  Nullable |
| `cantidad_muerta_delta` | `int4` |  Nullable |
| `causa_mortandad` | `causa_mortandad_plantacion` |  Nullable |
| `latitud` | `numeric` |  Nullable |
| `longitud` | `numeric` |  Nullable |
| `cantidad_devuelta` | `int4` |  Nullable |
| `motivo_devolucion` | `motivo_devolucion_plantacion` |  Nullable |
| `cantidad_asignada_evento` | `int4` |  Nullable |
| `created_at` | `timestamptz` |  |
| `created_by` | `int8` |  |
| `metadata_blockchain` | `jsonb` |  Nullable |

## Table `subcampania_historial`

Historial append-only del ciclo de vida de la subcampania (RN-PLA-06/37, docs §4.1).

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `subcampania_id` | `int8` |  |
| `tipo_historial` | `tipo_historial_subcampania` |  |
| `estado_origen` | `estado_subcampania` |  Nullable |
| `estado_destino` | `estado_subcampania` |  Nullable |
| `observaciones` | `text` |  Nullable |
| `metadata` | `jsonb` |  |
| `actor_user_id` | `int8` |  Nullable |
| `created_at` | `timestamptz` |  |
| `participacion_comando_id` | `int8` |  Nullable |

## Table `subcampania_meta_especie`

Plan por especie: ADMIN puede revisar en BORRADOR/ACTIVA mediante fn_subcampania_revisar_plan. SUM(%)=100 y SUM(cantidad)=meta_total_arboles. Metas orientativas; no limitan consumo de stock.

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `subcampania_id` | `int8` |  |
| `planta_id` | `int8` |  |
| `porcentaje_objetivo` | `numeric` |  |
| `cantidad_objetivo` | `int4` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `created_by` | `int8` |  |
| `updated_by` | `int8` |  |

## Table `participacion_comando`

DDL compartido PA §7.1; clave/huella/recibo sin vencimiento. No motor de comandos ni API en INT02-B.

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `actor_id` | `int8` |  |
| `operacion` | `text` |  |
| `comando_id` | `uuid` |  |
| `version_contrato` | `int2` |  |
| `version_huella` | `int2` |  |
| `huella` | `bytea` |  Nullable |
| `estado` | `text` |  |
| `subcampania_preparacion_id` | `int8` |  Nullable |
| `registro_plantacion_id` | `int8` |  Nullable |
| `resultado` | `jsonb` |  Nullable |
| `error` | `jsonb` |  Nullable |
| `http_terminal` | `int2` |  Nullable |
| `creado_en` | `timestamptz` |  |
| `finalizado_en` | `timestamptz` |  Nullable |

## Table `subcampania_permiso_revision`

PA-S03: revision estable; ausencia=0 por lectura, retiro no elimina la fila.

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `subcampania_id` | `int8` | Primary |
| `usuario_id` | `int8` | Primary |
| `revision` | `int8` |  |
| `actualizado_en` | `timestamptz` |  |
| `actualizado_por` | `int8` |  |

## Table `subcampania_permiso`

PA-S03: vigencias historicas; administrador incluye plantar. Continuidad concurrente se implementa en INT02-C/D.

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `subcampania_id` | `int8` |  |
| `usuario_id` | `int8` |  |
| `rol_contextual` | `text` |  |
| `otorgado_en` | `timestamptz` |  |
| `otorgado_por` | `int8` |  |
| `comando_otorgamiento_id` | `int8` |  |
| `revocado_en` | `timestamptz` |  Nullable |
| `revocado_por` | `int8` |  Nullable |
| `comando_retiro_id` | `int8` |  Nullable |

## Table `usuario_autoridad_historial`

Auditoría mínima inmutable de cambios reales de rol/actividad; rechazos y SIN_CAMBIOS viven solo en participacion_comando.

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `comando_id` | `int8` |  |
| `usuario_id` | `int8` |  |
| `actor_id` | `int8` |  |
| `evento` | `text` |  |
| `rol_anterior` | `rol_usuario` |  |
| `rol_nuevo` | `rol_usuario` |  |
| `activo_anterior` | `bool` |  |
| `activo_nuevo` | `bool` |  |
| `revision_anterior` | `int8` |  |
| `revision_nueva` | `int8` |  |
| `motivo` | `text` |  |
| `creado_en` | `timestamptz` |  |

## Table `participacion_carga`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `actor_id` | `int8` |  |
| `comando_interno_id` | `int8` |  |
| `comando_origen_id` | `int8` |  |
| `carga_id` | `uuid` |  |
| `subcampania_id` | `int8` |  |
| `tipo_entidad_id` | `int8` |  |
| `estado` | `text` |  |
| `hash_original_sha256` | `bytea` |  |
| `hash_derivada_sha256` | `bytea` |  |
| `tamano_original_bytes` | `int8` |  |
| `tamano_derivada_bytes` | `int8` |  |
| `mime_original` | `text` |  |
| `bucket` | `text` |  |
| `ruta_original` | `text` |  |
| `ruta_derivada` | `text` |  |
| `evidencia_id` | `int8` |  Nullable Unique |
| `lease_token` | `uuid` |  Nullable |
| `lease_hasta` | `timestamptz` |  Nullable |
| `generacion` | `int4` |  |
| `objetos_verificados_en` | `timestamptz` |  Nullable |
| `creado_en` | `timestamptz` |  |
| `actualizado_en` | `timestamptz` |  |
| `expira_en` | `timestamptz` |  Nullable |

## Table `participacion_carga_generacion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `carga_interna_id` | `int8` | Primary |
| `generacion` | `int4` | Primary |
| `bucket` | `text` |  |
| `ruta_original` | `text` |  |
| `ruta_derivada` | `text` |  |
| `lease_token` | `uuid` |  |
| `lease_hasta` | `timestamptz` |  |
| `estado` | `text` |  |
| `limpieza_estado` | `text` |  |
| `proximo_intento_en` | `timestamptz` |  Nullable |
| `borrado_verificado_en` | `timestamptz` |  Nullable |
| `creado_en` | `timestamptz` |  |

## Table `registro_plantacion_grupo_revision`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `grupo_registro_id` | `int8` | Primary |
| `revision_grupo` | `int8` |  |

## Table `registro_plantacion_correccion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `comando_interno_id` | `int8` |  Unique |
| `actor_id` | `int8` |  |
| `actor_nombre_snapshot` | `text` |  Nullable |
| `subcampania_id` | `int8` |  |
| `grupo_registro_id` | `int8` |  |
| `registro_plantacion_id` | `int8` |  Nullable |
| `evento_plantacion_id` | `int8` |  Nullable |
| `caso` | `text` |  |
| `motivo` | `text` |  |
| `anterior` | `jsonb` |  |
| `nuevo` | `jsonb` |  |
| `revision_anterior` | `int8` |  |
| `revision_nueva` | `int8` |  |
| `revision_grupo_anterior` | `int8` |  |
| `revision_grupo_nueva` | `int8` |  |
| `referencia_registro_vigente_id` | `int8` |  Nullable |
| `referencia_revision_registro` | `int8` |  Nullable |
| `referencia_revision_grupo` | `int8` |  Nullable |
| `creado_en` | `timestamptz` |  |

## Table `registro_plantacion_efectivo`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `registro_plantacion_id` | `int8` | Primary |
| `subcampania_id` | `int8` |  |
| `estado` | `text` |  |
| `cantidad_efectiva` | `int4` |  |
| `observaciones_efectivas` | `text` |  Nullable |
| `ultima_correccion_id` | `int8` |  Nullable |

## Table `evento_plantacion_efectivo`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `evento_plantacion_id` | `int8` | Primary |
| `grupo_registro_id` | `int8` |  |
| `subcampania_id` | `int8` |  |
| `estado` | `text` |  |
| `cantidad_muerta_efectiva` | `int4` |  |
| `revision_evento` | `int8` |  |
| `ultima_correccion_id` | `int8` |  Nullable |

## Table `registro_plantacion_participante_efectivo`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `registro_plantacion_id` | `int8` | Primary |
| `usuario_id` | `int8` | Primary |
| `coresponsable_original_id` | `int8` |  Nullable Unique |
| `estado` | `text` |  |
| `procedencia` | `text` |  |
| `nombre_snapshot` | `text` |  Nullable |
| `afiliacion_snapshot` | `text` |  Nullable |
| `afiliacion_estado` | `text` |  |
| `afiliacion_tipo` | `text` |  Nullable |
| `organizacion_id_snapshot` | `int8` |  Nullable |
| `snapshot_capturado_en` | `timestamptz` |  Nullable |
| `correccion_incorporacion_id` | `int8` |  Nullable |
| `ultima_correccion_id` | `int8` |  Nullable |

## Table `registro_plantacion_consumo_credito`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `registro_plantacion_id` | `int8` |  |
| `asignacion_id` | `int8` |  |
| `planta_id` | `int8` |  |
| `proposito` | `proposito_asignacion` |  |
| `cantidad` | `int4` |  |
| `detalle_original_id` | `int8` |  Nullable Unique |
| `correccion_id` | `int8` |  Nullable |
| `revision_origen` | `int8` |  |
| `creado_en` | `timestamptz` |  |

## Table `registro_plantacion_consumo_compensacion`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `int8` | Primary Identity |
| `credito_id` | `int8` |  |
| `correccion_id` | `int8` |  |
| `cantidad` | `int4` |  |
| `creado_en` | `timestamptz` |  |

## Custom Types / Enums

### `lote_estado`

`INICIO` | `EMBOLSADO` | `SOMBRA` | `LISTA_PLANTAR` | `SALIDA_VIVERO`

### `lote_accion`

`INICIO` | `EMBOLSADO` | `SOMBRA` | `LISTA_PLANTAR` | `SALIDA_VIVERO` | `AJUSTE`

### `estado_registro_recoleccion`

`BORRADOR` | `VALIDADO` | `PENDIENTE_VALIDACION` | `RECHAZADO`

### `tipo_movimiento_recoleccion`

`CONSUMO_A_VIVERO` | `DESECHO` | `CORRECCION` | `AJUSTE_MIGRACION`

### `motivo_movimiento_recoleccion`

`CONSUMO_PARA_VIVERO` | `DESECHO_MALA_CALIDAD` | `DESECHO_PLAGA` | `DESECHO_HONGO` | `DESECHO_PUDRICION` | `DESECHO_DANO_TRANSPORTE` | `DESECHO_DANO_MANIPULACION` | `DESECHO_CONTAMINACION` | `DESECHO_CADUCIDAD` | `DESECHO_OTRO` | `CORRECCION_CONTEO_FISICO` | `CORRECCION_ERROR_DIGITACION` | `CORRECCION_CAMBIO_UNIDAD` | `CORRECCION_OTRO` | `AJUSTE_MIGRACION` | `AJUSTE_INTEGRIDAD_DATOS` | `AJUSTE_REVERSA_OPERACION` | `AJUSTE_OTRO` | `OTRO`

### `rol_usuario`

`ADMIN` | `GENERAL` | `VALIDADOR` | `VOLUNTARIO`

### `estado_lote_vivero`

`ACTIVO` | `FINALIZADO`

### `tipo_evento_vivero`

`INICIO` | `EMBOLSADO` | `ADAPTABILIDAD` | `MERMA` | `DESPACHO` | `CIERRE_AUTOMATICO` | `DESCARTE_PRE_EMBOLSADO` | `DEVOLUCION_PLANTACION`

### `motivo_cierre_lote`

`DESPACHO_TOTAL` | `PERDIDA_TOTAL` | `MIXTO` | `DESCARTE_PRE_EMBOLSADO`

### `subetapa_adaptabilidad`

`SOMBRA` | `MEDIA_SOMBRA` | `SOL_DIRECTO`

### `unidad_medida`

`UNIDAD` | `G`

### `estado_operativo_recoleccion`

`ABIERTO` | `CERRADO`

### `tipo_material_origen`

`SEMILLA` | `ESQUEJE`

### `tipo_historial_recoleccion`

`BORRADOR_CREADO` | `SOLICITUD_VALIDACION` | `VALIDACION_APROBADA` | `VALIDACION_RECHAZADA` | `BORRADOR_ELIMINADO`

### `causa_merma_vivero`

`PLAGA` | `ENFERMEDAD` | `SEQUIA` | `DANO_FISICO` | `MUERTE_NATURAL` | `OTRO`

### `destino_tipo_vivero`

`PLANTACION_PROPIA` | `PLANTACION_COMUNIDAD` | `DONACION` | `VENTA` | `OTRO` | `PLANTACION_CAMPANIA`

### `origen_despacho_vivero`

`MANUAL` | `AUTOMATICO_PLANTACION` | `ASIGNACION_SUBCAMPANIA`

### `proposito_asignacion`

`PLANTACION_INICIAL` | `REPOSICION`

### `estado_asignacion_vivero`

`ACTIVA` | `AGOTADA` | `DEVUELTA`

### `tipo_subcampania`

`REFORESTACION` | `ARBORIZACION` | `FORESTACION`

### `estado_subcampania`

`BORRADOR` | `ACTIVA` | `COMPLETADA` | `FINALIZADA_PARCIAL` | `PAUSADA` | `CANCELADA`

### `fase_mantenimiento_subcampania`

`NO_APLICA` | `MANTENIMIENTO_ACTIVO` | `MONITOREO_HISTORICO`

### `motivo_cierre_parcial`

`FALTA_STOCK` | `PROBLEMAS_CLIMATICOS` | `CANCELACION_CONVENIO` | `CONFLICTO_SOCIAL` | `ACCESO_RESTRINGIDO` | `CAMBIO_PRIORIDAD_INSTITUCIONAL` | `RIESGO_OPERATIVO` | `META_REDEFINIDA` | `CIERRE_ADMINISTRATIVO` | `OTRO`

### `rol_en_subcampania`

`COORDINADOR` | `OPERARIO`

### `causa_mortandad_plantacion`

`SEQUIA` | `EXCESO_AGUA` | `HELADA` | `GRANIZO` | `PLAGA` | `ENFERMEDAD` | `SUELO_INADECUADO` | `FALTA_MANTENIMIENTO` | `DANO_MECANICO` | `PASTOREO` | `VANDALISMO` | `INCENDIO` | `COMPETENCIA_MALEZA` | `TRASPLANTE_DEFICIENTE` | `DESCONOCIDA` | `OTRO`

### `motivo_devolucion_plantacion`

`SOBRANTE_OPERATIVO` | `ERROR_PLANIFICACION` | `CAMBIO_SUBCAMPANIA` | `CIERRE_SUBCAMPANIA` | `PROBLEMAS_CALIDAD_LOTE` | `CONDICIONES_CAMPO_NO_APTAS` | `ACCESO_RESTRINGIDO` | `CANCELACION_ACTIVIDAD` | `REASIGNACION_PRIORIDAD` | `OTRO`

### `tipo_evento_plantacion`

`ASIGNACION_VIVERO` | `DEVOLUCION_A_VIVERO` | `MORTANDAD_REPORTADA`

### `tipo_organizacion`

`ONG` | `EMPRESA_PRIVADA` | `EMPRESA_PUBLICA` | `FUNDACION` | `ETFs` | `ALCALDIA` | `ASOCIACION_CIUDADANA` | `OTRO`

### `causa_descarte_pre_embolsado`

`NO_GERMINACION` | `NO_ENRAIZAMIENTO` | `CONTAMINACION` | `PERDIDA_TOTAL_MATERIAL` | `MATERIAL_NO_VIABLE` | `DANO_PRE_EMBOLSADO` | `OTRO`

### `tipo_historial_subcampania`

`BORRADOR_CREADO` | `SUBCAMPANIA_ACTIVADA` | `SUBCAMPANIA_COMPLETADA` | `SUBCAMPANIA_FINALIZADA_PARCIAL` | `SUBCAMPANIA_CANCELADA` | `TRANSICION_A_MONITOREO_HISTORICO` | `EQUIPO_AMPLIADO` | `EQUIPO_REDUCIDO` | `COORDINADOR_CAMBIADO` | `PLAN_REVISADO` | `PERMISO_OTORGADO` | `PERMISO_CAMBIADO` | `PERMISO_RETIRADO` | `ADMINISTRADOR_REEMPLAZADO`
