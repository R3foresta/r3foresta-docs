# Handoff UI — Registrar plantación inicial

> Alcance estricto para adaptar una interfaz de referencia al producto R3foresta.
> Este documento describe únicamente el registro de **plantación inicial en campo**.
> No autoriza copiar otros módulos, pantallas o reglas de la aplicación de referencia.

## 1. Resultado esperado

La interfaz debe permitir que un miembro operativo de una subcampaña registre lo que realmente plantó en una micro-ubicación, con evidencia, GPS y cantidades por especie, consumiendo stock que ya fue entregado físicamente desde Vivero a esa subcampaña.

Ruta del frontend:

```text
/app/planting/subcampanias/:subcampaniaId/plantaciones/new
```

Ejemplo local con una subcampaña concreta:

```text
http://localhost:5173/app/planting/subcampanias/123/plantaciones/new
```

La URL local anterior supone el puerto estándar de Vite. Si el proyecto se ejecuta en otro host o puerto, se conserva exactamente el path y solo se reemplaza el origen.

## 2. Límites de alcance

### Incluido

- Plantación inicial (`es_reposicion = false`).
- Flujo mobile de 3 pasos.
- Evidencia fotográfica y GPS.
- Cantidades enteras por especie.
- Distribución automática de cantidades entre asignaciones/lotes.
- Resumen, confirmación y comprobante final.

### Excluido

- Crear o editar campañas y subcampañas.
- Asignar plantas desde Vivero.
- Devolver plantas al Vivero.
- Mortandad.
- Reposición.
- Cierre parcial o cancelación de subcampañas.
- Vista pública, impacto, blockchain o bonos de carbono.
- Edición o eliminación de una plantación ya registrada.
- Selección manual de lotes en el flujo principal.

No ampliar el alcance aunque la aplicación usada como referencia muestre esas capacidades.

## 3. Quién puede registrar

El usuario debe cumplir simultáneamente:

1. Tener rol global operativo: `ADMIN`, `VALIDADOR` o `GENERAL`.
2. Pertenecer a `SUBCAMPANIA_EQUIPO` de la subcampaña como `COORDINADOR` u `OPERARIO`.

Un `ADMIN` que no pertenece al equipo de esa subcampaña **no puede registrar**. El responsable real es el usuario autenticado; no se ofrece un selector para registrar en nombre de otra persona.

Los co-responsables son opcionales, pero cualquier ID enviado debe pertenecer al mismo equipo. No existe porcentaje de participación.

## 4. Precondiciones que bloquean la apertura

Antes de mostrar el formulario operativo se consulta el contexto. Bloquear el flujo completo cuando ocurra cualquiera de estos casos:

- la subcampaña no existe o fue eliminada;
- la subcampaña no está `ACTIVA`;
- el usuario no cumple los dos niveles de permiso;
- no existe plan por especie;
- el polígono no puede evaluarse;
- no existe al menos una asignación `ACTIVA`, con propósito `PLANTACION_INICIAL` y saldo disponible;
- el backend no puede entregar contexto suficiente.

No permitir plantación inicial en `BORRADOR`, `COMPLETADA`, `FINALIZADA_PARCIAL`, `CANCELADA` ni `PAUSADA`.

## 5. Flujo de interfaz: exactamente 3 pasos

### Paso 1 — Evidencia y ubicación

Campos y límites:

- mínimo 1 foto y máximo 10;
- enviar los archivos en `multipart/form-data`, campo `fotos`;
- GPS obligatorio: latitud `[-90, 90]` y longitud `[-180, 180]`;
- mostrar estados de GPS: buscando, capturado, baja precisión y error;
- advertir baja precisión desde 50 m, usando la regla entregada por contexto;
- permitir reintentar la captura;
- fecha de plantación obligatoria en formato `YYYY-MM-DD`;
- la fecha no puede ser anterior a la entrega más reciente de las asignaciones que serán consumidas;
- la ventana retroactiva vigente es de 10 días;
- observaciones opcionales, máximo 2000 caracteres.

El frontend puede mostrar una advertencia si el punto cae fuera del polígono, pero no decide la validez final. El backend debe evaluar el GPS. En el contrato implementado vigente, estar fuera del polígono **no bloquea**: se conserva `gps_dentro_poligono=false` y la distancia al polígono. Un GPS imposible de evaluar sí bloquea.

Las fotos son evidencia auditable. No reemplazar el original por una versión comprimida; se puede usar un preview o thumbnail separado.

### Paso 2 — Cantidades por especie

Mostrar únicamente especies incluidas en `plan_por_especie`. Para cada una mostrar:

- meta de la especie;
- plantado inicial acumulado;
- pendiente de meta;
- stock asignado disponible;
- cantidad que se registrará ahora;
- total proyectado después de guardar.

Reglas duras:

- cantidades enteras;
- cada detalle enviado debe ser `>= 1`;
- el total del registro debe ser mayor a 0;
- cantidad por especie `<= pendiente_meta`;
- cantidad por especie `<= stock_asignado_disponible`;
- no aceptar especies fuera del plan;
- una plantación inicial nunca puede exceder la meta por especie, aunque exista stock sobrante.

El operario captura una cantidad agregada por especie. La UI la distribuye automáticamente entre las asignaciones de esa especie usando:

```text
fecha_asignacion ASC, asignacion_id ASC
```

Si una asignación no alcanza, se consume su saldo y se continúa con la siguiente. No preguntar al operario qué lote usar. El request final sí debe contener el desglose real por `asignacion_id`, `lote_vivero_id`, `planta_id` y `cantidad`.

### Paso 3 — Resumen y confirmación

Mostrar antes de confirmar:

- subcampaña y campaña de contexto;
- fecha;
- ubicación y estado del GPS;
- fotos;
- cantidades por especie;
- cantidad total;
- co-responsables, si existen;
- observaciones;
- advertencia si el GPS está fuera del polígono o tiene baja precisión.

Bloquear doble envío. No mostrar tablas internas de asignaciones por defecto; esos datos son trazabilidad técnica, no la tarea principal del operario.

## 6. Secuencia HTTP obligatoria

Con backend local documentado en `http://localhost:3000`:

1. Cargar contexto:

   ```text
   GET http://localhost:3000/api/subcampanias/:subcampaniaId/plantacion/context
   ```

2. Pre-subir evidencia:

   ```text
   POST http://localhost:3000/api/registros-plantacion/evidencias-pendientes
   ```

3. Si el usuario cancela o el registro no se completará, limpiar la evidencia pendiente:

   ```text
   DELETE http://localhost:3000/api/registros-plantacion/evidencias-pendientes
   ```

4. Confirmar la plantación:

   ```text
   POST http://localhost:3000/api/registros-plantacion
   ```

Todos los requests autenticados usan:

```text
x-auth-id: <Supabase auth_id del usuario>
```

No usar `POST /api/plantaciones`: esa mención en un ejemplo antiguo de contexto es un typo documental. El endpoint vigente es `POST /api/registros-plantacion`.

## 7. Payload final mínimo

```json
{
  "subcampania_id": 123,
  "es_reposicion": false,
  "fecha_plantacion": "2026-07-11",
  "latitud": -16.2902,
  "longitud": -68.1193,
  "observaciones": "Plantación inicial sector A",
  "coresponsable_ids": [9],
  "detalles": [
    {
      "asignacion_id": 55,
      "lote_vivero_id": 31,
      "planta_id": 5,
      "cantidad": 70
    }
  ],
  "evidencia_ids": [50]
}
```

No enviar `cantidades_por_especie`: el backend no acepta ese contrato. La transformación desde cantidades agregadas hacia `detalles` ocurre en el frontend antes del POST.

## 8. Efectos correctos del guardado

El guardado debe ocurrir atómicamente:

- crea `REGISTRO_PLANTACION`;
- crea sus `REGISTRO_PLANTACION_DETALLE`;
- vincula evidencias y co-responsables;
- aumenta `cantidad_consumida` de cada asignación usada;
- actualiza `total_plantado_inicial` de la subcampaña;
- devuelve el desglose `consumos`;
- si se alcanza la meta total, el backend puede cerrar automáticamente la subcampaña como `COMPLETADA`;
- conserva snapshots y código de trazabilidad;
- el registro queda append-only: no se edita ni elimina en el MVP.

Invariante:

```text
SUM(detalles.cantidad) = cantidad_total_plantada
```

Plantar **no** debe:

- crear un nuevo `EVENTO_LOTE_VIVERO` de despacho;
- usar `AUTOMATICO_PLANTACION`;
- modificar `LOTE_VIVERO.saldo_vivo_actual`;
- consumir asignaciones con propósito `REPOSICION`.

La salida física del Vivero ocurrió antes, al crear la asignación física.

## 9. Resultado de éxito

Después de un `201`:

- mostrar código de trazabilidad;
- mostrar total plantado;
- mostrar estado del GPS y distancia al polígono;
- mostrar consumos realizados y saldos resultantes de forma resumida;
- reconsultar contexto/progreso para evitar saldos obsoletos;
- limpiar estado local y evidencias pendientes ya vinculadas;
- impedir que un refresh repita el POST.

## 10. Manejo de errores

- `401`: falta `x-auth-id`; enviar al flujo de sesión.
- `403`: rol global insuficiente o usuario fuera del equipo; mostrar “No perteneces al equipo operativo de esta subcampaña”.
- `404`: usuario o subcampaña no encontrados.
- `409` al cargar contexto: subcampaña no `ACTIVA`.
- `422` al cargar contexto: falta plan, polígono evaluable o stock inicial disponible.
- `400` al guardar: mostrar el mensaje de negocio del backend y conservar el formulario para corregirlo.

Ante conflicto de saldo o meta por concurrencia, el backend es la autoridad. Reconsultar contexto antes de permitir un nuevo intento.

## 11. Fuentes para consultar dudas

Rutas absolutas y líneas relevantes en esta máquina:

1. Reglas propias de plantación:
   - `/Users/pabloandresfernandezcari/Projects/R3foresta/r3foresta-docs/03-plantacion-module/01_reglas_de_negocio_plantacion.md`
   - líneas 163–187: equipo, consumo, topes, append-only y ausencia de despacho M2.
   - líneas 217–223: regla conceptual de GPS; leer junto con la aclaración de vigencia de §12.

2. Flujo funcional de campo:
   - `/Users/pabloandresfernandezcari/Projects/R3foresta/r3foresta-docs/03-plantacion-module/02_Procesos_Modulo_3_Plantacion.md`
   - líneas 356–403: flujo de plantación inicial y datos visibles.
   - líneas 405–414: cierre automático al alcanzar la meta.

3. Plan frontend ya implementado:
   - `/Users/pabloandresfernandezcari/Projects/R3foresta/r3foresta-docs/03-plantacion-module/04_plan_frontend_m3.md`
   - líneas 344–381: ruta, pasos, contexto y bloqueos de apertura.
   - líneas 383–430: campos, límites, confirmación y permisos.

4. Contrato físico Vivero ↔ Plantación:
   - `/Users/pabloandresfernandezcari/Projects/R3foresta/r3foresta-docs/90-contratos-integracion/02_contrato_vivero_a_plantacion.md`
   - líneas 48–56: significado de asignación, saldo y plantación.
   - líneas 79–99: fórmula del saldo asignado disponible.
   - líneas 160–210: validaciones, efectos e invariantes del registro.

5. Contrato HTTP de registros:
   - `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/modulos/plantaciones.md`
   - líneas 14–80: pre-subida y limpieza de evidencias.
   - líneas 84–155: payload, respuesta y errores del registro.
   - líneas 210–230: reglas resumidas y secuencia típica.

6. Endpoint de contexto:
   - `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/postman/plantacion-context.md`
   - líneas 1–18: objetivo y precondiciones.
   - líneas 20–98: respuesta completa y límites dinámicos.
   - líneas 100–128: distribución automática y errores.

7. Implementación SQL de autoridad:
   - `/Users/pabloandresfernandezcari/Projects/R3foresta/r3foresta-docs/database/migrations/053_m3_registrar_plantacion_sin_despacho.sql`
   - líneas 97–149: parámetros y evidencia obligatoria.
   - líneas 162–215: estado y evaluación GPS.
   - líneas 430–507: consistencia especie/lote, saldo, meta y fecha.
   - líneas 522–656: creación, detalles, consumos y contadores.
   - líneas 659–723: evidencias, invariantes y respuesta.

## 12. Jerarquía ante contradicciones documentales

Para adaptar la UI, usar este orden de autoridad:

1. Contrato HTTP e implementación backend vigentes de julio de 2026.
2. Plan frontend actualizado y probado el 8 de julio de 2026.
3. Reglas de negocio y procesos conceptuales.
4. Mockups o textos históricos.

Aclaraciones obligatorias:

- **GPS fuera del polígono:** una regla conceptual antigua dice que bloquea; el backend y el endpoint de contexto vigentes declaran `gps_fuera_poligono_bloquea=false`. Implementar advertencia y conservar la bandera, no bloqueo.
- **Elección de lote:** textos anteriores admitían selección manual. El contexto vigente ordena por `fecha_asignacion ASC, asignacion_id ASC` y dice expresamente que no se pregunta al operario.
- **Endpoint final:** usar `/api/registros-plantacion`; no `/api/plantaciones`.

Si se desea cambiar cualquiera de estas tres decisiones, requiere una decisión de producto y alineación previa de backend, documentación y frontend. No cambiarla solo para parecerse a la aplicación de referencia.
