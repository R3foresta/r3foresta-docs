# Tarea 07 — Historial de lote diferenciado (manual vs automático + evidencia heredada)

**Área:** Frontend (Módulo Vivero)
**Severidad:** Importante
**Depende de:** 01, 03
**Referencias:** Addendum secciones 4.3, 8

---

## 1. Contexto

El historial de eventos de un lote (timeline append-only de `EVENTO_LOTE_VIVERO`) hoy no distingue despachos manuales de los automáticos generados desde M3. Tampoco sabe que los automáticos heredan evidencia desde el `REGISTRO_PLANTACION` asociado.

Esto rompe la trazabilidad para el coordinador y para la vista pública: un despacho hacia plantación no se diferencia visualmente de una donación o venta.

---

## 2. Cambio requerido

### 2.1. Badge de origen

Cada evento `DESPACHO` muestra un badge:

- `MANUAL` (gris) — el operario de vivero lo registró directamente.
- `POR PLANTACIÓN` (verde) — generado desde M3 al registrar plantación o reposición.

### 2.2. Campos visibles según origen

**`MANUAL`:**

- `destino_tipo` (PLANTACION_PROPIA / DONACION_COMUNIDAD / VENTA / OTRO)
- `destino_referencia` (texto libre)
- Fotos propias del evento (desde `EVIDENCIAS_TRAZABILIDAD`)

**`AUTOMATICO_PLANTACION`:**

- Link clickeable a la **Subcampaña** (nombre).
- Link clickeable a la **Campaña** padre.
- Link clickeable al **Registro de plantación** (con fecha y operario).
- Indicador "Evidencia heredada de plantación" con galería de fotos del `REGISTRO_PLANTACION` (no del evento).
- Si es reposición, badge adicional `REPOSICIÓN`.

### 2.3. Búsqueda de evidencia heredada

El frontend debe pedir al backend (o ya recibir en el payload del historial) la evidencia del `REGISTRO_PLANTACION` cuando `origen_despacho = AUTOMATICO_PLANTACION`. No debe buscar fotos vinculadas al `evento_lote_vivero.id` para esos eventos (no las hay).

Endpoint sugerido: `GET /api/lotes-vivero/:id/historial` ya hace JOIN o expansión de evidencia heredada.

### 2.4. Diferenciación visual en el timeline

Sugerencia de iconos:

- `INICIO` — icono semilla
- `EMBOLSADO` — icono bolsa
- `ADAPTABILIDAD` — icono sol/sombra
- `MERMA` — icono advertencia (rojo)
- `DESPACHO` manual — icono camión
- `DESPACHO` automático (plantación) — icono árbol plantado
- `CIERRE_AUTOMATICO` — icono candado

### 2.5. Drill-down completo (transparencia pública también)

Desde el historial del lote en la vista pública, click en un despacho automático debe navegar al detalle público de la subcampaña, mostrando que esos árboles terminaron plantados ahí. Cierra la cadena de custodia visible al ciudadano.

---

## 3. Criterios de aceptación

- [ ] Un `DESPACHO` manual muestra sus propias fotos.
- [ ] Un `DESPACHO` automático muestra las fotos del `REGISTRO_PLANTACION` asociado, con etiqueta "Evidencia heredada".
- [ ] Los links a subcampaña / campaña / registro abren las vistas correctas en M3.
- [ ] El badge de origen es siempre visible en eventos `DESPACHO`.
- [ ] La vista pública del lote permite drill-down hasta la subcampaña donde se plantó.

---

## 4. Choques con el sistema actual

- **Componente de timeline existente** asume que la evidencia siempre se busca por `entidad_id = evento_lote_vivero.id`. Hay que extenderlo para que, según `origen_despacho`, busque por `registro_plantacion_id`.
- **Performance:** cargar evidencia heredada por cada evento puede generar N+1. Resolver con un endpoint que ya devuelva el historial expandido en una sola query (o GraphQL si aplica).

---

## 5. Archivos a tocar

- Frontend M2: componente de timeline / historial de lote.
- Frontend M2 vista pública: mismo componente con permisos limitados.
- Backend M2: endpoint de historial que incluya evidencia heredada.
