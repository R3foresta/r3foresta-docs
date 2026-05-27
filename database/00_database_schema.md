erDiagram

  PAIS {
    bigint id PK
    text nombre
    character codigo_iso2 "UNIQUE"
    character codigo_iso3
    boolean activo
    timestamptz created_at
  }

  DIVISION_TIPO {
    bigint id PK
    bigint pais_id FK
    text nombre
    int orden
    boolean activo
    timestamptz created_at
  }

  DIVISION_ADMINISTRATIVA {
    bigint id PK
    bigint pais_id FK
    bigint parent_id FK "self"
    bigint tipo_id FK "en MVP la comunidad usa DIVISION_TIPO = Comunidad - Localidad (id 4)"
    text nombre
    text codigo_externo
    boolean activo
    bigint reemplazada_por_id FK "self"
    timestamptz created_at
    timestamptz updated_at
  }

  UBICACION {
    bigint id PK
    numeric latitud
    numeric longitud
    timestamptz created_at
    bigint pais_id FK
    bigint division_id FK
    text nombre
    int precision_m
    text fuente
    text referencia
    timestamptz updated_at
  }

  USUARIO {
    bigint id PK
    text nombre
    text apellido
    text doc_identidad "UNIQUE"
    text wallet_address "UNIQUE"
    text organizacion
    text contacto
    ENUM(rol_usuario) rol
    timestamptz created_at
    text username "UNIQUE"
    text auth_id
    text correo "UNIQUE"
    text foto_perfil_url
  }

  USUARIO_CREDENCIAL {
    bigint id PK
    bigint usuario_id FK
    text credential_id "UNIQUE"
    text public_key
    text algorithm
    int counter
    ARRAY transports
    timestamptz created_at
    timestamptz last_used_at
  }

  TIPOS_ENTIDAD_EVIDENCIA {
    smallint id PK
    text codigo "UNIQUE"
    text descripcion
    boolean activo
    timestamptz creado_en
  }

  EVIDENCIAS_TRAZABILIDAD {
    bigint id PK
    smallint tipo_entidad_id FK
    bigint entidad_id "polimórfico"
    text codigo_trazabilidad
    text bucket
    text ruta_archivo
    uuid storage_object_id
    text tipo_archivo
    text mime_type
    bigint tamano_bytes
    text hash_sha256
    text titulo
    text descripcion
    jsonb metadata
    boolean es_principal
    int orden
    timestamptz tomado_en
    timestamptz creado_en
    timestamptz actualizado_en
    timestamptz eliminado_en
    bigint creado_por_usuario_id FK
    bigint actualizado_por_usuario_id FK
    bigint eliminado_por_usuario_id FK
  }

  VIVERO {
    bigint id PK
    text codigo "UNIQUE"
    text nombre
    bigint ubicacion_id FK "UNIQUE"
    timestamptz created_at
  }

  TIPO_PLANTA {
    int id PK
    text nombre "UNIQUE"
    timestamptz created_at
  }

  PLANTA {
    bigint id PK
    text especie
    text nombre_cientifico
    text variedad
    timestamptz created_at
    text nombre_comun_principal "fuente viva oficial de naming operativo para poblar nombre_comercial_snapshot"
    text nombres_comunes "fuera de alcance funcional en MVP"
    text imagen_url
    text notas
    int tipo_planta_id FK
  }

  METODO_RECOLECCION {
    bigint id PK
    text nombre
    text descripcion
  }

  RECOLECCION {
    bigint id PK
    date fecha
    ENUM(tipo_material_origen) tipo_material
    text nombre_cientifico_snapshot "NOT NULL - snapshot oficial se congela al VALIDAR"
    text nombre_comercial_snapshot "NOT NULL - snapshot se congela al VALIDAR; en MVP se alimenta desde PLANTA.nombre_comun_principal"
    text variedad_snapshot "NOT NULL - snapshot oficial se congela al VALIDARr"
    text nombre_comunidad_snapshot "NOT NULL - comunidad donde se recolectó; snapshot oficial se congela al VALIDAR"
    text nombre_recolector_snapshot "NOT NULL - snapshot oficial se congela al VALIDAR"
    boolean especie_nueva
    text observaciones
    bigint usuario_id FK
    bigint ubicacion_id FK
    bigint vivero_id FK
    bigint metodo_id FK
    bigint planta_id FK
    timestamptz created_at
    timestamptz updated_at "nullable - ultima edicion de ficha en BORRADOR o RECHAZADO"
    bigint updated_by FK "nullable"
    timestamptz deleted_at "nullable - soft delete solo para BORRADOR"
    bigint deleted_by FK "nullable"
    text codigo_trazabilidad "UNIQUE"
    text blockchain_url
    text token_id
    text transaction_hash
    ENUM(estado_registro_recoleccion) estado_registro
    ENUM(unidad_medida) unidad_canonica
    numeric cantidad_inicial_canonica
    bigint usuario_validacion_id FK "nullable - solo cuando la solicitud fue aprobada"
    timestamptz fecha_validacion "nullable - solo cuando pasa a VALIDADO"
    numeric saldo_actual
    ENUM(estado_operativo_recoleccion) estado_operativo
  }

  RECOLECCION_HISTORIAL {
    bigint id PK
    bigint recoleccion_id FK
    ENUM(tipo_historial_recoleccion) tipo_historial
    ENUM(estado_registro_recoleccion) estado_origen
    ENUM(estado_registro_recoleccion) estado_destino
    text observaciones
    jsonb metadata
    bigint actor_user_id FK
    timestamptz created_at
  }

  RECOLECCION_MOVIMIENTO {
    bigint id PK
    bigint recoleccion_id FK
    ENUM(tipo_movimiento_recoleccion) tipo_movimiento
    numeric delta
    ENUM(unidad_medida) unidad_medida_movimiento
    ENUM(motivo_movimiento_recoleccion) motivo
    text motivo_otro
    bigint lote_vivero_id "FK a LOTE_VIVERO"
    jsonb detalle_cambios "nullable - solo para correcciones o ajustes tecnicos futuros"
    bigint created_by FK
    timestamptz created_at
    text transaction_hash
  }

  LOTE_VIVERO {
    bigint id PK
    bigint recoleccion_id FK "NOT NULL - origen único por lote, sin UNIQUE"
    bigint planta_id FK "NOT NULL"
    bigint vivero_id FK "NOT NULL - vivero operativo seleccionado para este lote, no heredado desde Recolección"
    bigint responsable_id FK "NOT NULL"
    text nombre_cientifico_snapshot "NOT NULL - congelado al crear, heredado desde Recolección"
    text nombre_comercial_snapshot "NOT NULL - congelado al crear, heredado desde Recolección; su fuente original viva en MVP es PLANTA.nombre_comun_principal"
    ENUM(tipo_material_origen) tipo_material_snapshot "NOT NULL - congelado al crear, heredado desde Recolección"
    text variedad_snapshot "NOT NULL - congelado al crear, heredado desde Recolección"
    text nombre_comunidad_origen_snapshot "NOT NULL - congelado al crear y también lo hereda"
    text nombre_responsable_snapshot "NOT NULL - congelado al crear"
    date fecha_inicio "NOT NULL"
    numeric cantidad_inicial_en_proceso "NOT NULL - lectura operativa de inicio"
    ENUM(unidad_medida) unidad_medida_inicial "NOT NULL - UNIDAD | G"
    int plantas_vivas_iniciales "nullable - materializado al registrar EMBOLSADO"
    int saldo_vivo_actual "nullable - caché controlada, nunca editar directo"
    ENUM(subetapa_adaptabilidad) subetapa_actual "nullable - SOMBRA | MEDIA_SOMBRA | SOL_DIRECTO"
    ENUM(estado_lote_vivero) estado_lote "NOT NULL - ACTIVO | FINALIZADO, default ACTIVO"
    ENUM(motivo_cierre_lote) motivo_cierre "nullable - DESPACHO_TOTAL | PERDIDA_TOTAL | MIXTO"
    text codigo_trazabilidad "NOT NULL - UNIQUE - formato VIV-{codigo_lote_vivero}-{RECOLECCION.codigo_trazabilidad}"
    timestamptz created_at "NOT NULL"
    timestamptz updated_at "NOT NULL"
}

EVENTO_LOTE_VIVERO {
    bigint id PK
    bigint lote_id FK "NOT NULL"
    ENUM(tipo_evento_vivero) tipo_evento "NOT NULL - INICIO | EMBOLSADO | ADAPTABILIDAD | MERMA | DESPACHO | CIERRE_AUTOMATICO"
    date fecha_evento "NOT NULL"
    timestamptz created_at "NOT NULL - inmutable, cuándo se guardó realmente"
    bigint responsable_id FK "NOT NULL"
    numeric cantidad_afectada "nullable - plantas o unidades según tipo_evento"
    ENUM(unidad_medida) unidad_medida_evento "nullable - UNIDAD | G"
    ENUM(causa_merma_vivero) causa_merma "nullable - solo aplica en MERMA"
    ENUM(destino_tipo_vivero) destino_tipo "nullable - solo aplica en DESPACHO; incluye PLANTACION_CAMPANIA"
    ENUM(origen_despacho_vivero) origen_despacho "nullable - solo aplica en DESPACHO; MANUAL | AUTOMATICO_PLANTACION; default MANUAL"
    text destino_referencia "nullable - solo aplica en DESPACHO manual; texto libre"
    bigint subcampania_id FK "nullable - obligatorio cuando origen_despacho = AUTOMATICO_PLANTACION; FK fisico pendiente de ALTER en BD"
    bigint campania_id FK "nullable - obligatorio cuando origen_despacho = AUTOMATICO_PLANTACION; FK fisico pendiente de ALTER en BD"
    bigint registro_plantacion_id FK "nullable - obligatorio cuando origen_despacho = AUTOMATICO_PLANTACION; FK fisico pendiente de ALTER en BD"
    bigint comunidad_destino_id FK "nullable - referencia a DIVISION_ADMINISTRATIVA(id), solo aplica en DESPACHO"
    ENUM(subetapa_adaptabilidad) subetapa_destino "nullable - SOMBRA | MEDIA_SOMBRA | SOL_DIRECTO"
    int saldo_vivo_antes "nullable - calculado por sistema"
    int saldo_vivo_despues "nullable - calculado por sistema"
    ENUM(motivo_cierre_lote) motivo_cierre_calculado "nullable - DESPACHO_TOTAL | PERDIDA_TOTAL | MIXTO"
    bigint ref_evento_trigger_id FK "nullable - autorreferencia, solo aplica en CIERRE_AUTOMATICO"
    jsonb metadata_blockchain "nullable - solo aplica en DESPACHO con anclaje activo"
    text observaciones "nullable"
}

ASIGNACION_VIVERO_SUBCAMPANIA {
    bigint id PK
    bigint subcampania_id FK "NOT NULL - FK fisico pendiente de ALTER en BD"
    bigint lote_vivero_id FK "NOT NULL - el lote de vivero que reserva"
    ENUM(proposito_asignacion) proposito "NOT NULL - PLANTACION_INICIAL | REPOSICION"
    ENUM(estado_asignacion_vivero) estado "NOT NULL - ACTIVA | AGOTADA | DEVUELTA; default ACTIVA; derivado por trigger"
    int cantidad_asignada "NOT NULL - inmutable, > 0, siempre UNIDAD"
    int cantidad_consumida "NOT NULL default 0 - aumenta con cada DESPACHO automatico que consume de esta asignacion"
    int cantidad_devuelta "NOT NULL default 0 - aumenta con cada DEVOLUCION_A_VIVERO en M3"
    int cantidad_mermada "NOT NULL default 0 - aumenta cuando una MERMA del lote agota saldo no asignado y desborda a esta asignacion por LIFO (la mas nueva primero)"
    int saldo_asignado_disponible "GENERATED ALWAYS AS (cantidad_asignada - cantidad_consumida - cantidad_devuelta - cantidad_mermada) STORED"
    bigint usuario_asignacion_id FK "NOT NULL - ADMIN o COORDINADOR de la subcampania"
    timestamptz fecha_asignacion "NOT NULL default now()"
    timestamptz updated_at "NOT NULL"
}

ORGANIZACION {
    bigint id PK
    text nombre "NOT NULL"
    boolean activo "NOT NULL default true"
    timestamptz created_at
    timestamptz updated_at
    text logo_url
    ENUM(tipo_organizacion) tipo "NOT NULL -ONG | EMPRESA_PRIVADA | INSTITUCION_PUBLICA | COMUNIDAD | OTRO"
}
%% Placeholder defensivo (modulo General aun no la define). Reemplazar cuando exista la version oficial.

CAMPANIA {
    bigint id PK
    text nombre "UNIQUE"
    text descripcion
    ENUM(tipo_subcampania) tipo "NOT NULL - REFORESTACION | ARBORIZACION | FORESTACION; define el tipo de toda subcampania hija"
    date fecha_estimada_inicio
    date fecha_estimada_fin
    text codigo_trazabilidad "UNIQUE - formato CMP-YYYY-NNN"
    timestamptz created_at
    timestamptz updated_at
    bigint created_by FK
    bigint updated_by FK
    timestamptz deleted_at "nullable - soft delete"
    bigint deleted_by FK "nullable"
    jsonb metadata_blockchain "nullable"
}
%% Sin columna de estado: el estado se deriva via vista campania_estado (invariante CLAUDE.md).
%% tipo es inmutable una vez creada la campania (no se puede cambiar si ya tiene subcampanias). El enum tipo_subcampania se reusa porque ambos representan el mismo concepto.

CAMPANIA_ORGANIZACION {
    bigint id PK
    bigint campania_id FK "NOT NULL - ON DELETE CASCADE"
    bigint organizacion_id FK "NOT NULL"
    timestamptz created_at
    bigint created_by FK
}

SUBCAMPANIA {
    bigint id PK
    bigint campania_id FK "NOT NULL"
    text nombre
    text descripcion
    ENUM(tipo_subcampania) tipo "NOT NULL - REFORESTACION | ARBORIZACION | FORESTACION; CHECK debe coincidir con CAMPANIA.tipo de la campania padre"
    ENUM(estado_subcampania) estado "NOT NULL default BORRADOR"
    ENUM(fase_mantenimiento_subcampania) fase_mantenimiento "NOT NULL default NO_APLICA"
    bigint zona_id FK "NOT NULL - DIVISION_ADMINISTRATIVA"
    geometry poligono_geom "nullable - Polygon WGS84; obligatorio para activar (CHECK)"
    numeric area_hectareas "nullable"
    int meta_total_arboles "NOT NULL > 0"
    date fecha_estimada_inicio "nullable"
    date fecha_estimada_fin "nullable"
    timestamptz fecha_cierre_operativo "nullable - obligatorio si estado en (COMPLETADA, FINALIZADA_PARCIAL)"
    date fecha_fin_mantenimiento "nullable - obligatorio si estado en (COMPLETADA, FINALIZADA_PARCIAL)"
    ENUM(motivo_cierre_parcial) motivo_cierre_parcial "nullable - obligatorio si estado = FINALIZADA_PARCIAL"
    text observaciones_cierre
    int tolerancia_gps_metros "NOT NULL default 50"
    text nombre_zona_snapshot "nullable - congelado al activar"
    text nombre_coordinador_snapshot "nullable - congelado al activar"
    ARRAY nombres_organizaciones_snapshot "text[] - congelado al activar"
    text codigo_trazabilidad "UNIQUE - formato SUB-NNN-CMP-YYYY-NNN"
    int total_plantado_inicial "NOT NULL default 0 - materializado por trigger (tarea pendiente)"
    int total_repuesto "NOT NULL default 0 - materializado por trigger (tarea pendiente)"
    int total_muerto_acumulado "NOT NULL default 0 - materializado por trigger (tarea pendiente)"
    int saldo_vivo_actual "GENERATED ALWAYS AS (total_plantado_inicial + total_repuesto - total_muerto_acumulado) STORED"
    timestamptz created_at
    timestamptz updated_at
    bigint created_by FK
    bigint updated_by FK
    timestamptz deleted_at "nullable"
    bigint deleted_by FK "nullable"
    jsonb metadata_blockchain "nullable"
}
%% Indice GIST sobre poligono_geom para PostGIS. Sin columna coordinador_id (membresia via SUBCAMPANIA_EQUIPO).

SUBCAMPANIA_EQUIPO {
    bigint id PK
    bigint subcampania_id FK "NOT NULL - ON DELETE CASCADE"
    bigint usuario_id FK "NOT NULL"
    ENUM(rol_en_subcampania) rol "NOT NULL - COORDINADOR | OPERARIO"
    timestamptz agregado_at "NOT NULL default now()"
    bigint agregado_by FK "NOT NULL"
}
%% Unique parcial WHERE rol = COORDINADOR garantiza 1 coordinador por subcampania. VOLUNTARIO no puede ser miembro (validacion en handler).

REGISTRO_PLANTACION {
    bigint id PK
    bigint subcampania_id FK "NOT NULL"
    boolean es_reposicion "NOT NULL default false"
    bigint registro_plantacion_origen_id FK "self - NOT NULL si es_reposicion=true; NULL si false (CHECK)"
    date fecha_plantacion "NOT NULL"
    bigint responsable_id FK "NOT NULL - USUARIO miembro de SUBCAMPANIA_EQUIPO (handler valida)"
    numeric latitud "NOT NULL"
    numeric longitud "NOT NULL"
    boolean gps_dentro_poligono "NOT NULL - calculado con gps_dentro_poligono_con_tolerancia"
    numeric gps_distancia_a_poligono_m "nullable"
    int cantidad_total_plantada "NOT NULL > 0"
    int cantidad_muerta_acumulada "NOT NULL default 0 - materializado por trigger (tarea pendiente)"
    int cantidad_repuesta_acumulada "NOT NULL default 0 - materializado por trigger (tarea pendiente)"
    int saldo_vivo_grupo "GENERATED ALWAYS AS (cantidad_total_plantada + cantidad_repuesta_acumulada - cantidad_muerta_acumulada) STORED"
    text nombre_subcampania_snapshot "nullable - congelado al insertar"
    text nombre_zona_snapshot "nullable - congelado al insertar"
    text nombre_responsable_snapshot "nullable - congelado al insertar"
    text observaciones
    text codigo_trazabilidad "UNIQUE - formato PLT-NNN-SUB-NNN"
    timestamptz created_at
    bigint created_by FK
    jsonb metadata_blockchain "nullable"
}
%% es_reposicion = true cuelga del grupo origen via registro_plantacion_origen_id. Sin mix de especies en MVP.

REGISTRO_PLANTACION_DETALLE {
    bigint id PK
    bigint registro_plantacion_id FK "NOT NULL - ON DELETE CASCADE"
    bigint asignacion_id FK "NOT NULL - ASIGNACION_VIVERO_SUBCAMPANIA"
    bigint lote_vivero_id FK "NOT NULL - redundante con asignacion.lote_vivero_id; debe coincidir"
    bigint planta_id FK "NOT NULL"
    int cantidad "NOT NULL > 0"
    text nombre_cientifico_snapshot
    text nombre_comercial_snapshot
    text variedad_snapshot
    bigint evento_lote_vivero_despacho_id FK "nullable solo en intermedio de transaccion; FK al DESPACHO automatico que crea tarea 03"
    timestamptz created_at
}
%% Unique (registro_plantacion_id, asignacion_id, planta_id). Una linea por (registro, asignacion, planta).

REGISTRO_PLANTACION_CORESPONSABLE {
    bigint id PK
    bigint registro_plantacion_id FK "NOT NULL - ON DELETE CASCADE"
    bigint usuario_id FK "NOT NULL - subset de SUBCAMPANIA_EQUIPO (handler valida)"
    timestamptz created_at
}

EVENTO_PLANTACION {
    bigint id PK
    ENUM(tipo_evento_plantacion) tipo_evento "NOT NULL - ASIGNACION_VIVERO | DEVOLUCION_A_VIVERO | MORTANDAD_REPORTADA"
    bigint subcampania_id FK "NOT NULL"
    bigint registro_plantacion_id FK "nullable - obligatorio en MORTANDAD_REPORTADA"
    bigint asignacion_id FK "nullable - obligatorio en DEVOLUCION_A_VIVERO y ASIGNACION_VIVERO"
    timestamptz fecha_evento "NOT NULL"
    bigint responsable_id FK "NOT NULL"
    text observaciones "nullable"
    int cantidad_muerta_delta "nullable - solo MORTANDAD_REPORTADA, > 0"
    ENUM(causa_mortandad_plantacion) causa_mortandad "nullable - solo MORTANDAD_REPORTADA"
    numeric latitud "nullable - solo MORTANDAD_REPORTADA"
    numeric longitud "nullable - solo MORTANDAD_REPORTADA"
    int cantidad_devuelta "nullable - solo DEVOLUCION_A_VIVERO, > 0"
    ENUM(motivo_devolucion_plantacion) motivo_devolucion "nullable - solo DEVOLUCION_A_VIVERO"
    int cantidad_asignada_evento "nullable - solo ASIGNACION_VIVERO, > 0; fuente de verdad es ASIGNACION_VIVERO_SUBCAMPANIA"
    timestamptz created_at
    bigint created_by FK
    jsonb metadata_blockchain "nullable"
}
%% Append-only. PLANTACION_INICIAL y REPOSICION NO van aqui; viven como filas en REGISTRO_PLANTACION con es_reposicion = false | true. CHECKs por tipo_evento garantizan coherencia.

  %% === Relaciones sin cambio ===

  PAIS ||--o{ DIVISION_TIPO : tiene
  PAIS ||--o{ DIVISION_ADMINISTRATIVA : tiene
  PAIS ||--o{ UBICACION : tiene
  DIVISION_TIPO ||--o{ DIVISION_ADMINISTRATIVA : clasifica
  DIVISION_ADMINISTRATIVA ||--o{ DIVISION_ADMINISTRATIVA : parent
  DIVISION_ADMINISTRATIVA ||--o{ DIVISION_ADMINISTRATIVA : reemplaza
  UBICACION }o--|| DIVISION_ADMINISTRATIVA : pertenece_a
  UBICACION ||--|| VIVERO : ubicacion_unica
  USUARIO ||--o{ USUARIO_CREDENCIAL : tiene
  USUARIO ||--o{ RECOLECCION : registra
  UBICACION ||--o{ RECOLECCION : ocurre_en
  VIVERO ||--o{ RECOLECCION : almacena_en
  METODO_RECOLECCION ||--o{ RECOLECCION : metodo
  PLANTA ||--o{ RECOLECCION : identifica
  RECOLECCION ||--o{ RECOLECCION_HISTORIAL : historial_ciclo_vida
  USUARIO ||--o{ RECOLECCION_HISTORIAL : actor
  RECOLECCION ||--o{ RECOLECCION_MOVIMIENTO : movimientos
  USUARIO ||--o{ RECOLECCION_MOVIMIENTO : creado_por
  TIPOS_ENTIDAD_EVIDENCIA ||--o{ EVIDENCIAS_TRAZABILIDAD : tipo
  USUARIO ||--o{ EVIDENCIAS_TRAZABILIDAD : creado_por
  USUARIO ||--o{ EVIDENCIAS_TRAZABILIDAD : actualizado_por
  USUARIO ||--o{ EVIDENCIAS_TRAZABILIDAD : eliminado_por

  %% === Relaciones módulo vivero — actualizadas ===

  RECOLECCION ||--o{ LOTE_VIVERO : "origen único"
  PLANTA ||--o{ LOTE_VIVERO : planta
  VIVERO ||--o{ LOTE_VIVERO : contiene
  USUARIO ||--o{ LOTE_VIVERO : responsable

  LOTE_VIVERO ||--o{ EVENTO_LOTE_VIVERO : "historial append-only"
  USUARIO ||--o{ EVENTO_LOTE_VIVERO : responsable
  EVENTO_LOTE_VIVERO ||--o| EVENTO_LOTE_VIVERO : "ref_evento_trigger"

  RECOLECCION_MOVIMIENTO }o--|| LOTE_VIVERO : "registra consumo en M1"

  %% === Relaciones vivero ↔ plantación (integración M2 ↔ M3) ===

  LOTE_VIVERO ||--o{ ASIGNACION_VIVERO_SUBCAMPANIA : "reserva logica para subcampania"
  USUARIO ||--o{ ASIGNACION_VIVERO_SUBCAMPANIA : "asigna"
  SUBCAMPANIA ||--o{ ASIGNACION_VIVERO_SUBCAMPANIA : "lotes asignados"
  %% FK fisico asignacion.subcampania_id -> subcampania(id) pendiente de ALTER en BD
  EVENTO_LOTE_VIVERO }o--o| SUBCAMPANIA : "DESPACHO automatico (subcampania_id)"
  EVENTO_LOTE_VIVERO }o--o| CAMPANIA : "DESPACHO automatico (campania_id)"
  EVENTO_LOTE_VIVERO }o--o| REGISTRO_PLANTACION : "DESPACHO automatico (registro_plantacion_id)"
  %% FKs fisicos evento_lote_vivero -> {subcampania, campania, registro_plantacion} pendientes de ALTER en BD

  TIPOS_ENTIDAD_EVIDENCIA ||--o{ EVIDENCIAS_TRAZABILIDAD : tipo

  %% === Relaciones modulo plantacion (M3) ===

  ORGANIZACION ||--o{ CAMPANIA_ORGANIZACION : participa_en
  CAMPANIA ||--o{ CAMPANIA_ORGANIZACION : tiene_organizaciones
  USUARIO ||--o{ CAMPANIA : created_by
  USUARIO ||--o{ CAMPANIA_ORGANIZACION : created_by

  CAMPANIA ||--o{ SUBCAMPANIA : contiene
  DIVISION_ADMINISTRATIVA ||--o{ SUBCAMPANIA : zona
  USUARIO ||--o{ SUBCAMPANIA : created_by

  SUBCAMPANIA ||--o{ SUBCAMPANIA_EQUIPO : tiene_equipo
  USUARIO ||--o{ SUBCAMPANIA_EQUIPO : participa

  SUBCAMPANIA ||--o{ REGISTRO_PLANTACION : "registros de plantacion"
  USUARIO ||--o{ REGISTRO_PLANTACION : responsable
  REGISTRO_PLANTACION ||--o{ REGISTRO_PLANTACION : "reposicion (self)"
  REGISTRO_PLANTACION ||--o{ REGISTRO_PLANTACION_DETALLE : detalle
  REGISTRO_PLANTACION ||--o{ REGISTRO_PLANTACION_CORESPONSABLE : coresponsables
  USUARIO ||--o{ REGISTRO_PLANTACION_CORESPONSABLE : firma

  ASIGNACION_VIVERO_SUBCAMPANIA ||--o{ REGISTRO_PLANTACION_DETALLE : "consumida via detalle"
  LOTE_VIVERO ||--o{ REGISTRO_PLANTACION_DETALLE : "lote consumido"
  PLANTA ||--o{ REGISTRO_PLANTACION_DETALLE : especie
  EVENTO_LOTE_VIVERO ||--o{ REGISTRO_PLANTACION_DETALLE : "despacho automatico generado"

  SUBCAMPANIA ||--o{ EVENTO_PLANTACION : "historial append-only"
  REGISTRO_PLANTACION ||--o{ EVENTO_PLANTACION : "evento sobre grupo"
  ASIGNACION_VIVERO_SUBCAMPANIA ||--o{ EVENTO_PLANTACION : "evento sobre asignacion"
  USUARIO ||--o{ EVENTO_PLANTACION : responsable

ENUMS
RECOLECCION
tipo_material_origen = [SEMILLA, ESQUEJE]

estado_registro_recoleccion = [BORRADOR, PENDIENTE_VALIDACION, VALIDADO, RECHAZADO]

tipo_movimiento_recoleccion = [
  CONSUMO_A_VIVERO, DESECHO, CORRECCION, AJUSTE_MIGRACION
]

motivo_movimiento_recoleccion = [
CONSUMO_PARA_VIVERO, DESECHO_MALA_CALIDAD, DESECHO_PLAGA, DESECHO_HONGO, DESECHO_PUDRICION, DESECHO_DANO_TRANSPORTE, DESECHO_DANO_MANIPULACION, DESECHO_CONTAMINACION, DESECHO_CADUCIDAD, DESECHO_OTRO, CORRECCION_CONTEO_FISICO, CORRECCION_ERROR_DIGITACION, CORRECCION_CAMBIO_UNIDAD, CORRECCION_OTRO, AJUSTE_MIGRACION, AJUSTE_INTEGRIDAD_DATOS, AJUSTE_REVERSA_OPERACION, AJUSTE_OTRO, OTRO
]
motivo_movimiento_recoleccion se mantiene en DB como enum oficial, pero debe documentarse y tratarse en tres grupos:
Motivos funcionales: usados en la operación normal del negocio.
Motivos correctivos: usados para correcciones auditadas.
Motivos técnicos: usados para migraciones, integridad o reversas técnicas.

LOTE VIVIERO
estado_lote_vivero = [ACTIVO, FINALIZADO]

tipo_evento_vivero = [
  INICIO, EMBOLSADO, ADAPTABILIDAD, MERMA, DESPACHO, CIERRE_AUTOMATICO
]

subetapa_adaptabilidad = [SOMBRA, MEDIA_SOMBRA, SOL_DIRECTO]

causa_merma_vivero = [
  PLAGA, ENFERMEDAD, SEQUIA, DANO_FISICO,
  MUERTE_NATURAL, OTRO
]

destino_tipo_vivero = [
  PLANTACION_CAMPANIA, PLANTACION_PROPIA, PLANTACION_COMUNIDAD, DONACION, VENTA, OTRO
]
// Nota: PLANTACION_CAMPANIA se agrega por integracion con Modulo 3.
// Solo aplica cuando origen_despacho = AUTOMATICO_PLANTACION.
// El renombrado de PLANTACION_COMUNIDAD/DONACION a DONACION_COMUNIDAD queda como decision abierta.

origen_despacho_vivero = [MANUAL, AUTOMATICO_PLANTACION]
// MANUAL: despacho registrado directamente desde Vivero por usuario autorizado.
// AUTOMATICO_PLANTACION: generado por el sistema desde Modulo 3 al guardar PLANTACION_INICIAL o REPOSICION.

proposito_asignacion = [PLANTACION_INICIAL, REPOSICION]
estado_asignacion_vivero = [ACTIVA, AGOTADA, DEVUELTA]
// AFECTADA_POR_MERMA no se modela como estado; se muestra como badge derivado cuando cantidad_mermada > 0.

motivo_cierre_lote = [DESPACHO_TOTAL, PERDIDA_TOTAL, MIXTO]
estado_operativo_recoleccion = [ABIERTO, CERRADO]

PLANTACION (M3)
tipo_subcampania = [REFORESTACION, ARBORIZACION, FORESTACION]
// Compartido por CAMPANIA.tipo y SUBCAMPANIA.tipo. La campania declara el tipo al crearse y todas sus subcampanias hijas deben heredarlo (CHECK constraint o trigger). El nombre del enum se conserva por compatibilidad con migracion 027.

estado_subcampania = [
  BORRADOR, ACTIVA, COMPLETADA, FINALIZADA_PARCIAL,
  PAUSADA,   // reservado, sin flujo en MVP
  CANCELADA  // reservado, sin flujo en MVP
]

tipo_organizacion = [ONG, EMPRESA_PRIVADA, INSTITUCION_PUBLICA, COMUNIDAD, OTRO]

fase_mantenimiento_subcampania = [NO_APLICA, MANTENIMIENTO_ACTIVO, MONITOREO_HISTORICO]
// Persistida con default NO_APLICA. Transita a MANTENIMIENTO_ACTIVO al cerrar y a MONITOREO_HISTORICO 3 anos despues via job nocturno (pendiente).

rol_en_subcampania = [COORDINADOR, OPERARIO]
// Membresia por subcampania (no rol global). Unique parcial garantiza 1 COORDINADOR por subcampania. VOLUNTARIO no puede ser miembro.

tipo_evento_plantacion = [ASIGNACION_VIVERO, DEVOLUCION_A_VIVERO, MORTANDAD_REPORTADA]
// PLANTACION_INICIAL y REPOSICION NO van aqui; viven como filas en REGISTRO_PLANTACION con es_reposicion = false | true.

motivo_cierre_parcial = [
  FALTA_STOCK, PROBLEMAS_CLIMATICOS, CANCELACION_CONVENIO,
  CONFLICTO_SOCIAL, ACCESO_RESTRINGIDO, CAMBIO_PRIORIDAD_INSTITUCIONAL,
  RIESGO_OPERATIVO, META_REDEFINIDA, CIERRE_ADMINISTRATIVO, OTRO
]

causa_mortandad_plantacion = [
  SEQUIA, EXCESO_AGUA, HELADA, GRANIZO, PLAGA, ENFERMEDAD,
  SUELO_INADECUADO, FALTA_MANTENIMIENTO, DANO_MECANICO, PASTOREO,
  VANDALISMO, INCENDIO, COMPETENCIA_MALEZA, TRASPLANTE_DEFICIENTE,
  DESCONOCIDA, OTRO
]

motivo_devolucion_plantacion = [
  SOBRANTE_OPERATIVO, ERROR_PLANIFICACION, CAMBIO_SUBCAMPANIA,
  CIERRE_SUBCAMPANIA, PROBLEMAS_CALIDAD_LOTE, CONDICIONES_CAMPO_NO_APTAS,
  ACCESO_RESTRINGIDO, CANCELACION_ACTIVIDAD, REASIGNACION_PRIORIDAD, OTRO
]

USUARIO
rol_usuario = [ADMIN, GENERAL, VALIDADOR, VOLUNTARIO]
UNIDADES
unidad_medida = [UNIDAD, G]

OBJETOS DERIVADOS / FUNCIONES (no son tablas, no aparecen en el ER)

vista campania_estado (subcampania) -> {campania_id, estado_derivado}
// Calcula al leer el estado de CAMPANIA desde el conjunto de sus SUBCAMPANIA segun §2.2 / §5.3 del Modulo 3.
// Valores: BORRADOR | ACTIVA | EN_MANTENIMIENTO | MONITOREO_HISTORICO. No materializar.

funcion gps_dentro_poligono_con_tolerancia(p_subcampania_id, p_lat, p_lng) -> {dentro, distancia_m}
// PostGIS. Fuente de verdad para validar GPS de REGISTRO_PLANTACION contra el poligono de la subcampania
// aplicando subcampania.tolerancia_gps_metros. Turf.js en frontend es opcional, solo para feedback UX.

EXTENSIONES POSTGRES
postgis (requerida por SUBCAMPANIA.poligono_geom y gps_dentro_poligono_con_tolerancia)
