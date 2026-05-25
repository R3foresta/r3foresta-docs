# Tarea 09 — Integrar addendum al MD y JSON oficiales del Módulo 2

**Área:** Documentación
**Severidad:** Mejora
**Depende de:** —
**Referencias:** Addendum sección 14.3

---

## 1. Contexto

[vivero-module/03_Addendum_Modulo_2_por_Modulo_3.md](../../vivero-module/03_Addendum_Modulo_2_por_Modulo_3.md) consolida los cambios necesarios para integrar M2 con M3. Es un documento de transición: una vez que las tareas técnicas estén en marcha, sus contenidos deben absorberse en los documentos oficiales del Módulo 2.

Mientras el addendum exista como archivo separado, los lectores tienen que cruzar dos fuentes para entender el comportamiento real del módulo. Eso vence el propósito de la documentación canónica.

---

## 2. Cambio requerido

### 2.1. Actualizar [vivero-module/00_Requerimientos-Modulo_2_Vivero.json](../../vivero-module/00_Requerimientos-Modulo_2_Vivero.json)

- **RF-VIV-03 (mermas):** agregar la política LIFO sobre asignaciones. Mencionar que `cantidad_asignada` es inmutable y que se usa `cantidad_mermada` separado.
- **RF-VIV-05 (despachos):** agregar `origen_despacho`, los nuevos FKs (`subcampania_id`, `campania_id`, `registro_plantacion_id`), el valor `PLANTACION_CAMPANIA` en `destino_tipo_vivero`, y las restricciones por origen.
- **RF-VIV-06 (evidencia):** documentar la excepción de evidencia heredada en despachos automáticos.
- **RF-VIV-09 (vista operativa):** ampliar con los saldos derivados (`saldo_asignado_total`, `saldo_vivo_disponible_asignacion`).
- **Nuevo RF-VIV-NN (asignaciones):** agregar la asignación vivero ↔ subcampaña como capacidad explícita del módulo 2 (es entidad puente con M3, no es exclusiva de M3).

### 2.2. Actualizar [vivero-module/01_regas_de_negocio_vivero.md](../../vivero-module/01_regas_de_negocio_vivero.md)

Agregar reglas nuevas (manteniendo numeración estable, sin renumerar existentes):

- `RN-VIV-NN` — Asignación es reserva lógica que no toca `saldo_vivo_actual`.
- `RN-VIV-NN` — Devolución desde M3 no genera evento en M2.
- `RN-VIV-NN` — `cantidad_asignada` es inmutable; las mermas usan `cantidad_mermada`.
- `RN-VIV-NN` — Mermas afectan asignaciones por LIFO (más nueva primero) cuando el saldo no asignado no alcanza.
- `RN-VIV-NN` — Despacho automático hereda evidencia del `REGISTRO_PLANTACION` asociado.
- `RN-VIV-NN` — Despacho manual no puede usar `destino_tipo = PLANTACION_CAMPANIA`.

Asignar los números próximos disponibles en orden. **No renumerar** reglas existentes.

### 2.3. Actualizar [vivero-module/02_doc_guia_viviero.md](../../vivero-module/02_doc_guia_viviero.md)

- Sección "Eventos y movimientos": agregar despacho automático como caso especial.
- Sección "Integración con módulos vecinos": expandir con el contrato M2 ↔ M3.
- Diagramas/tablas: actualizar para incluir asignación como entidad puente.

### 2.4. Actualizar [database/00_database_schema.md](../../database/00_database_schema.md)

- `EVENTO_LOTE_VIVERO`: agregar columnas nuevas (`origen_despacho`, `subcampania_id`, `campania_id`, `registro_plantacion_id`).
- Nueva entidad: `ASIGNACION_VIVERO_SUBCAMPANIA`.
- Sección ENUMS: agregar `origen_despacho_vivero` y `PLANTACION_CAMPANIA` en `destino_tipo_vivero`.
- Sección de relaciones: agregar las nuevas FKs (sin marcar como existentes en BD hasta que M3 esté implementado).

### 2.5. Mover o marcar el addendum

Cuando todas las absorciones anteriores estén hechas, **mover** el addendum a `vivero-module/archive/` o agregar al inicio del archivo:

```
> Estado: ABSORBIDO en MD/JSON principales el YYYY-MM-DD.
> Se mantiene como referencia histórica.
```

No borrarlo, porque las tareas en `tareas/modulo-2-integracion-modulo-3/` lo referencian.

---

## 3. Criterios de aceptación

- [ ] Un lector que solo abre el MD principal del Módulo 2 entiende el contrato con M3 sin necesitar el addendum.
- [ ] Las reglas de negocio nuevas tienen códigos `RN-VIV-NN` únicos y no rompen referencias existentes.
- [ ] El JSON de requerimientos refleja el comportamiento real del módulo extendido.
- [ ] El esquema en `database/00_database_schema.md` queda alineado con las migraciones de las tareas 01 y 02.
- [ ] El addendum queda explícitamente marcado como absorbido (o movido a `archive/`).

---

## 4. Choques con el sistema actual

- **Riesgo bajo:** es trabajo de documentación. El único riesgo es introducir incoherencias entre el JSON y el MD si se edita uno y no el otro. Mitigar haciendo todas las ediciones en el mismo PR.
- **Coordinar con docs de M3:** la documentación de Plantación referencia "ver addendum del Módulo 2". Tras la absorción, esas referencias deben actualizarse a las secciones nuevas del MD principal del Módulo 2.

---

## 5. Archivos a tocar

- [vivero-module/00_Requerimientos-Modulo_2_Vivero.json](../../vivero-module/00_Requerimientos-Modulo_2_Vivero.json)
- [vivero-module/01_regas_de_negocio_vivero.md](../../vivero-module/01_regas_de_negocio_vivero.md)
- [vivero-module/02_doc_guia_viviero.md](../../vivero-module/02_doc_guia_viviero.md)
- [database/00_database_schema.md](../../database/00_database_schema.md)
- [plantacion-module/02_Procesos_Modulo_3_Plantacion.md](../../plantacion-module/02_Procesos_Modulo_3_Plantacion.md) — actualizar referencias al addendum.
