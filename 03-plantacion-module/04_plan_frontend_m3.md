# Plan frontend - Modulo 3 Plantacion

> Documento operativo para planificar implementacion frontend. No reemplaza reglas de negocio ni contrato backend. La fuente canonica sigue en `01_reglas_de_negocio_plantacion.md`, `02_Procesos_Modulo_3_Plantacion.md` y `../90-contratos-integracion/02_contrato_vivero_a_plantacion.md`.
>
> Actualizado contra el frontend real de `pwa-r3foresta` y contrastado contra backend `Backend-r3foresta` el 2026-07-21.
>
> Documentacion backend revisada:
> - `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/api-reference.md`
> - `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/modulos/campanias.md`
> - `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/modulos/subcampanias.md`
> - `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/modulos/plantaciones.md`
> - `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/modulos/lotes-vivero-m3.md`
> - `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/guia-migracion-asignacion-fisica.md`

## 1. Lectura ejecutiva

El frontend de Plantacion no parte de cero. Ya existe una base funcional para planificacion administrativa de campanias y subcampanias, y parte del nuevo flujo de asignacion fisica ya esta construido desde el modulo Vivero.

La direccion practica para el MVP es:

1. No rehacer la navegacion actual.
2. Usar las rutas protegidas existentes bajo `/app/planting`.
3. Convertir el detalle de subcampania en el centro operativo.
4. Reutilizar la asignacion fisica que ya vive en Vivero.
5. Construir primero plantacion inicial contra stock asignado.
6. Dejar mortandad y reposicion despues de tener plantacion inicial funcionando.
7. Pedir endpoints faltantes antes de inventar estados o calcular saldos en el front.

### Estado global verificado

| Area | Estado | Realidad actual |
|---|---|---|
| Stack frontend | COMPLETADO | React + TypeScript + Vite + Tailwind. |
| Capa API Plantacion | PARCIAL | Existe para campanias, subcampanias, equipo, poligono, plan, activar, cancelar, contexto de plantacion y registro via `POST /registros-plantacion`. Faltan historial/mortandad HTTP y asignaciones agregadas por subcampania. |
| Campanias admin | COMPLETADO | Listado, creacion, edicion, detalle/dashboard, metricas y actividad reciente. |
| Subcampanias admin | COMPLETADO/PARCIAL | Wizard, detalle, equipo, mapa, activación, cancelación y CTA de registro de plantación están conectados. El detalle todavía no agrega una vista de asignaciones/historial. |
| Asignacion fisica M2 -> M3 | COMPLETADO/PARCIAL | Crear/listar/asignar con evidencia y propósito funciona desde el detalle de lote de Vivero. Falta una vista agregada por subcampaña. |
| Devolucion fisica | COMPLETADO/PARCIAL | La UI de devolución funciona desde el detalle de lote de Vivero; falta reflejar el desglose agregado en el detalle de subcampaña. |
| Plantacion inicial en campo | COMPLETADO | Ruta y flujo mobile de 3 pasos en `/app/planting/subcampanias/:subcampaniaId/plantaciones/new` (`src/modules/plantacion`). Consume `GET /subcampanias/:id/plantacion/context` (ya implementado en backend), `POST/DELETE /registros-plantacion/evidencias-pendientes` y `POST /registros-plantacion`. QA 2026-07-08 sin bloqueantes. |
| Mortandad | PENDIENTE | No hay frontend ni endpoints conectados en Plantacion. |
| Reposicion | PENDIENTE/PARCIAL | Backend puede registrar reposicion con `POST /registros-plantacion` usando `es_reposicion=true`, pero faltan UI, contexto y mortandad/origen visible. |
| Finalizada parcial | PENDIENTE/PARCIAL | Backend real: `POST /subcampanias/:id/cerrar` con `estado_final=FINALIZADA_PARCIAL`. Falta accion frontend conectada. |
| Vista publica | FUERA DE MVP | Mantener fuera de alcance por ahora. |

## 2. Alcance MVP ajustado

El MVP debe permitir operar el ciclo minimo privado, no toda la experiencia publica ni todos los reportes perfectos.

### MVP funcional minimo

Debe quedar funcionando:

- admin crea y edita campanias;
- admin crea subcampanias con zona, meta, plan por especie, poligono y equipo;
- admin activa subcampanias aunque no tengan stock completo;
- admin o coordinador entrega stock fisico desde Vivero a subcampania con evidencia;
- coordinador u operario del equipo registra plantacion inicial con foto, GPS y cantidades por especie; un ADMIN global solo puede registrar si tambien pertenece al equipo operativo de la subcampania;
- el backend consume stock asignado y devuelve `consumos`; el frontend reconsulta subcampania/asignaciones/progreso;
- admin o coordinador devuelve stock asignado no consumido al vivero;
- admin cancela subcampanias sin plantaciones;
- admin finaliza parcialmente subcampanias activas con motivo;
- cada pantalla muestra loading, empty, error, exito y mensajes de negocio legibles.

### MVP despues del minimo

Construir despues de cerrar plantacion inicial:

- mortandad;
- reposicion;
- historial operativo completo M3;
- home mobile de campo mas pulida;
- dashboards por coordinador;
- vistas publicas.

### Fuera de alcance por ahora

- `/impacto`;
- mapa publico;
- KPIs publicos;
- detalle publico de campania;
- detalle publico de subcampania;
- blockchain como bloqueo para guardar una operacion base;
- edicion de registros append-only;
- seleccion manual obligatoria de lote en la primera version del flujo mobile, salvo que backend no pueda resolver la asignacion.

## 3. Rutas reales del frontend

El plan anterior usaba rutas conceptuales como `/plantacion/...` y `/campo`. La app actual usa rutas protegidas bajo `/app`.

Rutas ya implementadas:

- `/app/planting`
- `/app/planting/campanias/new`
- `/app/planting/campanias/:campaniaId`
- `/app/planting/campanias/:campaniaId/edit`
- `/app/planting/campanias/:campaniaId/subcampanias/new`
- `/app/planting/subcampanias/:subcampaniaId`
- `/app/planting/subcampanias/:subcampaniaId/plantaciones/new`

Rutas todavía no implementadas:

- `/app/planting/subcampanias/:subcampaniaId/mortandad/new`
- `/app/planting/subcampanias/:subcampaniaId/reposiciones/new`
- `/app/planting/subcampanias/:subcampaniaId/asignaciones` (requiere endpoint agregado por subcampaña)
- `/app/campo` solo si se decide crear un home mobile especifico para operarios.

Regla practica: no crear rutas publicas ni rutas fuera de `/app` para operaciones privadas.

## 4. Lo ya implementado

### 4.1 Campanias

Estado: COMPLETADO para MVP base.

Ya existe:

- listado de campanias;
- creacion de campania;
- edicion de campania;
- detalle/dashboard de campania;
- asociacion visual de organizaciones;
- metricas agregadas si backend las entrega;
- actividad reciente;
- bloqueo de acciones por rol ADMIN;
- bloqueo de desactivacion cuando hay subcampanias no canceladas.

Archivos principales:

- `src/modules/plantacion/screens/PlantacionDashboardScreen.tsx`
- `src/modules/plantacion/screens/CrearCampanaScreen.tsx`
- `src/modules/plantacion/screens/EditarCampanaScreen.tsx`
- `src/modules/plantacion/screens/CampaniaAdminDashboardScreen.tsx`
- `src/api/plantacion.api.ts`
- `src/services/plantacion.service.ts`

Pendiente menor:

- pulir textos que todavia hablan de "sub-campaña" con guion si se decide normalizar;
- no bloquear el MVP por estilos o copy no perfecto.

### 4.2 Wizard de subcampania

Estado: COMPLETADO/PARCIAL.

Ya existe:

- paso base: nombre, zona/comunidad, coordinador, fechas;
- paso meta/especies: meta total, catalogo de especies, porcentajes, calculo de cantidades;
- paso poligono: mapa, GPS, vertices, area estimada/local y sync con backend;
- paso equipo: coordinador y operarios;
- paso resumen: visualizacion, guardar borrador y activar;
- rehidratacion desde backend y draft local;
- activacion con precondiciones;
- manejo de loading/error/submitting.

Pendiente para MVP:

- asegurar que `GET /subcampanias/:id` devuelva siempre `poligono` para eliminar el fallback local;
- revisar si el plan por especie debe poder editarse en `ACTIVA` o queda fuera del MVP;
- conectar desde el detalle las acciones operativas, no solo configuracion.

### 4.3 Detalle de subcampania

Estado: PARCIAL.

Ya existe:

- header con estado;
- resumen;
- equipo;
- mapa;
- activacion desde BORRADOR;
- cancelacion de BORRADOR o ACTIVA sin plantaciones segun dato `total_plantado_inicial`;
- refetch al activar;
- aviso de cobertura/stock recibido desde backend.

Pendiente:

- tab `Plantaciones`;
- tab `Historial`;
- CTA `Finalizar parcial`;
- mostrar fase de mantenimiento separada del estado operativo;
- mostrar progreso por especie real, no solo meta total.

El CTA `Registrar plantacion` ya está conectado. El comentario TODO de `DetalleSubcampanaScreen.tsx` sigue siendo válido para la futura vista agregada de asignaciones cuando exista `GET /subcampanias/:id/asignaciones`.

### 4.4 Asignacion fisica desde Vivero

Estado: COMPLETADO para el flujo actual desde Vivero; falta la vista agregada por subcampaña.

Ya existe desde el detalle de lote de Vivero:

- tab `asignaciones`;
- listado de asignaciones activas por lote;
- seleccion de subcampania;
- proposito `PLANTACION_INICIAL` o `REPOSICION`;
- cantidad absoluta;
- fecha;
- evidencia obligatoria;
- upload de evidencias pendientes;
- `POST /lotes-vivero/:loteId/asignaciones`;
- refetch del lote despues de asignar;
- baja del saldo vivo del lote por respuesta backend;
- success dialog.

Archivos principales:

- `src/modules/vivero/components/ViveroLotAsignacionesTab.tsx`
- `src/api/lotes-vivero.api.ts`
- `src/services/lotes-vivero.service.ts`
- `src/modules/vivero/types/contracts.ts`

Pendiente para una experiencia centrada en Plantacion:

- una vista por subcampania que muestre todas sus asignaciones;
- selector de lotes asignables filtrado por especie/estado/saldo;
- cobertura por especie contra el plan;
- vista agregada por subcampaña;
- lenguaje consistente: "entregado/asignado a subcampania", no "reserva logica".

### 4.5 Devolucion fisica

Estado: COMPLETADO para la operación desde Vivero; integración agregada en Plantación pendiente.

Ya existe:

- `POST /lotes-vivero/:loteId/asignaciones/:asignacionId/devolucion`;
- `LotesViveroService.devolverAsignacion`;
- validaciones frontend basicas de cantidad, motivo y fecha.

La UI de devolución valida cantidad, motivo y fecha, muestra confirmación, reconsulta el lote y comunica si el lote se reabrió (`lote_reabierto`). La cancelación transaccional del backend devuelve físicamente las asignaciones activas; queda pendiente mostrar el desglose agregado por lote/subcampaña.

## 5. Flujos pendientes del MVP

### 5.1 Asignaciones desde detalle de subcampania

Objetivo: que admin/coordinador pueda gestionar el stock entregado a una subcampania sin entrar lote por lote desde Vivero.

Construir sobre:

- `DetalleSubcampanaScreen`;
- `LotesViveroService.listAsignaciones`;
- `LotesViveroService.crearAsignacion`;
- `LotesViveroService.devolverAsignacion`;
- componentes ya existentes de Vivero: uploader, cantidad stepper, fecha, success dialog.

Vista MVP:

- resumen de subcampania;
- estado operativo;
- plan por especie;
- stock entregado por especie;
- stock disponible para plantar por especie;
- asignaciones activas;
- lote origen, vivero, especie, cantidad entregada, consumida, devuelta, mermada y disponible;
- CTA `Entregar stock`;
- CTA `Devolver al vivero` si `saldo_asignado_disponible > 0`.

No hacer en MVP:

- graficos complejos;
- filtros avanzados;
- gestion masiva;
- edicion de asignaciones.

ENDPOINTS reales disponibles hoy para entregar stock:

```text
POST /lotes-vivero/evidencias-pendientes
POST /lotes-vivero/:loteId/asignaciones
GET /lotes-vivero/:loteId/asignaciones
GET /lotes-vivero/:loteId/saldos
GET /lotes-vivero/stock/especies
```

Payload real de `POST /lotes-vivero/:loteId/asignaciones`:

```json
{
  "subcampania_id": 123,
  "cantidad_asignada": 100,
  "proposito": "PLANTACION_INICIAL",
  "fecha_asignacion": "2026-07-07",
  "evidencia_ids": [501],
  "observaciones": "Entrega fisica a cuadrilla"
}
```

ENDPOINT recomendado, aun no implementado en backend:

```text
GET /subcampanias/:id/asignaciones
```

Datos minimos:

```json
{
  "subcampania_id": 123,
  "estado": "ACTIVA",
  "plan_por_especie": [
    {
      "planta_id": 10,
      "nombre_comun_principal": "Molle",
      "nombre_cientifico": "Schinus molle",
      "cantidad_objetivo": 200,
      "plantado_inicial": 40,
      "stock_asignado_disponible": 80
    }
  ],
  "asignaciones": [
    {
      "id": 55,
      "lote_vivero_id": 31,
      "codigo_lote": "VIV-000031",
      "vivero_nombre": "Vivero Central",
      "planta_id": 10,
      "nombre_comun_principal": "Molle",
      "proposito": "PLANTACION_INICIAL",
      "fecha_asignacion": "2026-07-07",
      "cantidad_asignada": 100,
      "cantidad_consumida": 20,
      "cantidad_devuelta": 0,
      "cantidad_mermada": 0,
      "saldo_asignado_disponible": 80,
      "creador_nombre": "Usuario"
    }
  ]
}
```

Estado verificado 2026-07-21: este endpoint agregado no existe. Lo real hoy es `GET /lotes-vivero/:loteId/asignaciones`, que lista asignaciones por lote y ya se usa desde la vista de Vivero. Para la pantalla operativa de subcampaña conviene pedir `GET /subcampanias/:id/asignaciones` antes de construir un workaround grande en frontend.

### 5.2 Registrar plantacion inicial

Estado verificado 2026-07-21: COMPLETADO. Implementado en `pwa-r3foresta` (`src/modules/plantacion`): ruta `/app/planting/subcampanias/:subcampaniaId/plantaciones/new`, flujo de 3 pasos, resolucion automatica de `detalles` por asignacion (`utils/resolverDetallesAsignacion.ts`), guardado transaccional con limpieza de evidencias pendientes y comprobante con `consumos`. El endpoint de contexto `GET /subcampanias/:id/plantacion/context` ya existe en backend. QA inicial cerrado sin bloqueantes.

Objetivo: registrar desde campo lo que se planto, consumiendo stock ya asignado fisicamente a la subcampania.

Entrada:

- desde detalle de subcampania activa;
- desde futuro home `/app/campo`;
- desde campania si hay que seleccionar una subcampania activa.

Flujo MVP en 3 pasos:

1. Evidencia y GPS.
2. Cantidades por especie.
3. Resumen y confirmacion.

Datos a cargar antes de abrir el formulario:

- subcampania;
- estado operativo;
- fase de mantenimiento;
- permisos del usuario;
- equipo;
- poligono/tolerancia GPS;
- plan por especie;
- plantado previo por especie;
- stock asignado disponible por especie con proposito `PLANTACION_INICIAL`;
- reglas de evidencia.

Bloquear apertura completa si:

- subcampania no esta `ACTIVA`;
- usuario no pertenece al equipo como `COORDINADOR` u `OPERARIO`;
- no hay plan por especie;
- no hay stock asignado disponible;
- backend no puede entregar contexto suficiente.

Paso 1 - Evidencia y GPS:

- minimo 1 foto;
- GPS obligatorio;
- mostrar estado: buscando, capturado, baja precision, error;
- permitir reintentar GPS;
- mostrar mapa pequeno si ya existe componente reutilizable;
- no decidir validez final del poligono en frontend.

Paso 2 - Cantidades por especie:

- listar especies del plan;
- mostrar meta, plantado previo, pendiente, stock disponible y total proyectado;
- input entero por especie;
- sumar total automaticamente;
- bloquear total 0;
- bloquear cantidad mayor al stock disponible;
- bloquear cantidad mayor a pendiente de meta por especie;
- no mostrar tablas internas por defecto.

Decision practica:

- el flujo principal puede capturar por especie y cantidad, pero el request real del backend exige `detalles` por `asignacion_id` + `lote_vivero_id` + `planta_id`;
- si hay una unica asignacion valida para la especie, el frontend puede mapear automaticamente esa especie a esa asignacion;
- si hay multiples asignaciones validas para la misma especie/proposito, abrir un panel avanzado para elegir lote/asignacion o pedir un endpoint de contexto que resuelva la distribucion;
- no enviar `cantidades_por_especie` directamente a backend: ese payload no existe hoy.

Paso 3 - Resumen:

- subcampania;
- fecha/hora;
- ubicacion;
- fotos;
- desglose por especie;
- total;
- observaciones;
- advertencias de GPS si aplica.

Al guardar:

- bloquear doble submit;
- subir evidencias si el contrato lo exige antes;
- enviar `detalles` reales por asignacion/lote/planta;
- backend consume asignaciones y devuelve `consumos`;
- reconsultar subcampania, asignaciones y progreso;
- mostrar confirmacion.

Permiso real: el endpoint exige rol global `ADMIN`, `VALIDADOR` o `GENERAL`, pero la RPC valida que el responsable autenticado pertenezca al equipo de la subcampania como `COORDINADOR` u `OPERARIO`.

ENDPOINTS confirmados:

```text
POST /registros-plantacion/evidencias-pendientes
POST /registros-plantacion
```

ENDPOINT recomendado, aun no implementado:

```text
GET /subcampanias/:id/plantacion/context
```

No existen en backend:

```text
POST /subcampanias/:id/plantaciones
POST /plantaciones/evidencias-pendientes
```

Payload real de `POST /registros-plantacion`:

```json
{
  "subcampania_id": 123,
  "es_reposicion": false,
  "fecha_plantacion": "2026-07-07",
  "latitud": -16.5,
  "longitud": -68.15,
  "observaciones": "Notas de campo opcionales",
  "coresponsable_ids": [],
  "detalles": [
    {
      "asignacion_id": 55,
      "lote_vivero_id": 31,
      "planta_id": 10,
      "cantidad": 30
    }
  ],
  "evidencia_ids": [1]
}
```

Respuesta real resumida:

```json
{
  "success": true,
  "data": {
    "message": "Plantacion registrada correctamente.",
    "registro_plantacion_id": 77,
    "codigo_trazabilidad": "PLT-001-SUB-001-CMP-2026-001",
    "cantidad_total_plantada": 30,
    "gps_dentro_poligono": true,
    "gps_distancia_a_poligono_m": 0,
    "consumos": [
      {
        "asignacion_id": 55,
        "lote_vivero_id": 31,
        "cantidad_consumida": 30,
        "saldo_asignado_antes": 80,
        "saldo_asignado_despues": 50,
        "estado_final": "ACTIVA"
      }
    ],
    "coresponsable_ids_vinculados": [],
    "evidencia_ids_vinculadas": [1]
  }
}
```

Errores con UX clara:

- stock insuficiente;
- especie fuera del plan;
- supera meta por especie;
- GPS no evaluable;
- GPS fuera de poligono no aborta segun doc backend vigente: se guarda `gps_dentro_poligono=false` y debe mostrarse como advertencia;
- falta evidencia;
- subcampania cambio de estado;
- usuario sin permiso;
- otro usuario consumio stock antes.

### 5.3 Devolucion al vivero

Objetivo: devolver stock asignado no consumido.

MVP:

- disponible desde tab `Asignaciones`;
- solo si `saldo_asignado_disponible > 0`;
- cantidad entera;
- motivo obligatorio;
- fecha obligatoria;
- observaciones opcionales si backend las acepta;
- sin fotos en MVP, segun contrato;
- confirmacion explicita porque aumenta saldo vivo del lote.

La UI ya existe desde el tab `Asignaciones` del detalle de lote de Vivero (`ViveroLotAsignacionesTab`). Falta integrarla en una vista agregada del detalle de subcampaña cuando exista el endpoint correspondiente.

ENDPOINT confirmado:

```text
POST /lotes-vivero/:loteId/asignaciones/:asignacionId/devolucion
```

Payload real:

```json
{
  "cantidad_devuelta": 25,
  "motivo_devolucion": "SOBRANTE_OPERATIVO",
  "fecha_devolucion": "2026-07-07",
  "observaciones": "Sobrante no plantado"
}
```

Respuesta real resumida:

```json
{
  "success": true,
  "data": {
    "asignacion_id": 55,
    "estado": "DEVUELTA",
    "cantidad_devuelta": 25,
    "cantidad_devuelta_total": 25,
    "saldo_asignado_disponible": 0,
    "lote_vivero_id": 31,
    "saldo_vivo_antes": 400,
    "saldo_vivo_despues": 425,
    "lote_reabierto": false,
    "evento_lote_vivero_id": 460,
    "evento_plantacion_id": 795
  }
}
```

### 5.4 Cancelacion y finalizacion parcial

Cancelacion:

- ya existe cancelacion simple desde detalle de subcampania;
- la confirmación muestra que la cancelación resuelve asignaciones activas; todavía no hay desglose visual de lotes/unidades devueltos;
- `POST /subcampanias/:id/cancelar` ya es transaccional: si no hay plantaciones iniciales, cancela y devuelve fisicamente al vivero el saldo disponible de las asignaciones activas;
- aclaracion de alineacion: la doc backend antigua que diga "devolucion logica/no genera evento M2" esta desactualizada por la migracion `054_m3_devolucion_fisica.sql`; lo vigente es devolucion fisica con eventos M2/M3;
- como la respuesta de cancelar no trae desglose de lotes/unidades devueltas, el frontend debe mostrar confirmacion previa y refetch posterior.

Finalizada parcial:

- pendiente;
- solo ADMIN;
- solo desde `ACTIVA`;
- motivo obligatorio;
- confirmacion fuerte;
- no reabrir;
- despues del cierre, no permitir plantacion inicial;
- permitir mantenimiento/reposicion segun reglas.

ENDPOINT confirmado:

```text
POST /subcampanias/:id/cerrar
```

No existe en backend:

```text
POST /subcampanias/:id/finalizar-parcial
```

Payload para finalizada parcial:

```json
{
  "estado_final": "FINALIZADA_PARCIAL",
  "fecha_cierre_operativo": "2026-08-31",
  "fecha_fin_mantenimiento": "2026-09-30",
  "motivo_cierre_parcial": "FALTA_STOCK",
  "observaciones_cierre": "No se conseguira mas stock esta temporada"
}
```

### 5.5 Mortandad

Estado: pendiente despues de plantacion inicial.

MVP:

- seleccionar subcampania;
- seleccionar registro/grupo de plantacion;
- mostrar plantados, muertos previos, repuestos previos y vivos estimados;
- foto + GPS obligatorio;
- delta de muertos;
- causa obligatoria;
- confirmacion;
- append-only.

ENDPOINTS a pedir para mortandad:

```text
GET /subcampanias/:id/mortandad/context
POST /subcampanias/:id/mortandad
```

Endpoint de evidencias ya confirmado y reutilizable:

```text
POST /registros-plantacion/evidencias-pendientes
```

Estado backend 2026-07-07: los endpoints de mortandad no existen en controller HTTP. No construir UI completa hasta tener contexto/listado de registros de plantacion y contrato de evento de mortandad.

No construir antes de tener `REGISTRO_PLANTACION` visible en frontend.

### 5.6 Reposicion

Estado: pendiente despues de mortandad.

MVP:

- seleccionar subcampania;
- seleccionar grupo con mortandad pendiente;
- mostrar `cantidad_pendiente_reposicion`;
- foto + GPS obligatorio;
- cantidades por especie;
- consumir solo stock asignado con proposito `REPOSICION`;
- bloquear si supera pendiente;
- append-only.

ENDPOINT confirmado para guardar reposicion:

```text
POST /registros-plantacion
POST /registros-plantacion/evidencias-pendientes
```

Payload diferencial:

```json
{
  "subcampania_id": 123,
  "es_reposicion": true,
  "registro_plantacion_origen_id": 77,
  "fecha_plantacion": "2026-07-07",
  "latitud": -16.5,
  "longitud": -68.15,
  "detalles": [
    {
      "asignacion_id": 88,
      "lote_vivero_id": 31,
      "planta_id": 10,
      "cantidad": 20
    }
  ],
  "evidencia_ids": [1]
}
```

ENDPOINTS recomendados, aun no implementados:

```text
GET /subcampanias/:id/reposicion/context
```

No existe en backend:

```text
POST /subcampanias/:id/reposiciones
```

## 6. Componentes reutilizables a crear o extraer

Priorizar componentes chicos y utiles. No crear una libreria interna grande antes de necesitarlos.

Necesarios para el siguiente tramo:

- `EstadoSubcampaniaBadge`
- `FaseMantenimientoBadge`
- `BusinessErrorAlert`
- `SubcampaniaProgress`
- `ProgresoPorEspecie`
- `StockPorEspecieSummary`
- `SubcampaniaAsignacionesTab`
- `AsignacionSubcampaniaCard`
- `DevolucionAsignacionModal`
- `PlantacionInicialFlow`
- `PlantacionCantidadesPorEspecie`
- `GpsCaptureCard`
- `EvidenceUploader`
- `ConfirmActionModal`

Reutilizar o adaptar:

- `FotosUploader` desde Vivero;
- `CantidadStepper` desde Vivero;
- `FechaCard` desde Vivero;
- componentes de mapa ya usados en subcampania;
- `CancelarSubcampaniaModal`;
- servicios de `LotesViveroService`.

Evitar por ahora:

- timeline complejo antes de tener eventos M3 reales;
- tablas densas en mobile;
- graficos;
- paneles publicos.

## 7. Contratos API confirmados, aclaraciones y faltantes

Base runtime confirmada: `src/main.ts` aplica `app.setGlobalPrefix('api')`. En este plan se listan los paths sin host; en desarrollo son `http://localhost:3000/api/...`.

### 7.1 Fuentes backend para leer

Documentacion frontend del backend:

- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/api-reference.md`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/modulos/campanias.md`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/modulos/subcampanias.md`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/modulos/plantaciones.md`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/modulos/lotes-vivero-m3.md`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/documentacion/frontend/guia-migracion-asignacion-fisica.md`

Controladores fuente:

- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/campanias/api/campanias.controller.ts`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/subcampanias/api/subcampanias.controller.ts`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/plantaciones/api/plantaciones.controller.ts`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/src/lotes-vivero/api/lotes-vivero.controller.ts`

Migraciones utiles para resolver contradicciones:

- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/054_m3_devolucion_fisica.sql`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/053_m3_registrar_plantacion_sin_despacho.sql`
- `/Users/pabloandresfernandezcari/Projects/R3foresta/Backend-r3foresta/migrations/052_vivero_asignar_stock_subcampania_rpc.sql`

### 7.2 Confirmados por backend

Campanias:

- `GET /campanias`
- `POST /campanias`
- `GET /campanias/:id`
- `PATCH /campanias/:id`
- `DELETE /campanias/:id`
- `POST /campanias/:id/organizaciones`
- `DELETE /campanias/:id/organizaciones/:orgId`
- `GET /campanias/:id/subcampanias`
- `GET /campanias/:id/metrics`
- `GET /campanias/:id/activity?limit=5`

Subcampanias:

- `GET /subcampanias`
- `POST /subcampanias`
- `GET /subcampanias/:id`
- `PATCH /subcampanias/:id`
- `DELETE /subcampanias/:id`
- `POST /subcampanias/:id/poligono`
- `POST /subcampanias/:id/activar`
- `POST /subcampanias/:id/cerrar`
- `POST /subcampanias/:id/cancelar`
- `GET /subcampanias/:id/plan`
- `PUT /subcampanias/:id/plan`
- `GET /subcampanias/:id/equipo`
- `POST /subcampanias/:id/equipo`
- `DELETE /subcampanias/:id/equipo/:usuarioId`

Asignacion fisica M2 -> M3:

- `GET /lotes-vivero`
- `GET /lotes-vivero/:id`
- `GET /lotes-vivero/stock/especies`
- `GET /lotes-vivero/:id/saldos`
- `POST /lotes-vivero/evidencias-pendientes`
- `POST /lotes-vivero/:id/asignaciones`
- `GET /lotes-vivero/:id/asignaciones`
- `POST /lotes-vivero/:id/asignaciones/:asignacionId/devolucion`
- `GET /lotes-vivero/:id/timeline`

Plantacion y reposicion:

- `GET /subcampanias/:id/plantacion/context`
- `POST /registros-plantacion/evidencias-pendientes`
- `POST /registros-plantacion`

### 7.3 Confirmados, pero incompletos para UX de subcampania

- `GET /lotes-vivero/:id/asignaciones` sirve para un lote, no para ver todo el stock de una subcampania.
- `POST /registros-plantacion` exige `detalles` por asignacion/lote/planta. Si la UI captura solo por especie, necesita contexto previo para mapear cantidades a asignaciones.
- `POST /registros-plantacion` no devuelve progreso actualizado de subcampania; devuelve `consumos`. El frontend debe reconsultar `GET /subcampanias/:id`, `GET /subcampanias/:id/plan` y asignaciones.
- `POST /subcampanias/:id/cancelar` devuelve fisicamente stock disponible de asignaciones activas, pero su response no incluye desglose de lotes/unidades devueltas.
- `GET /subcampanias/:id` devuelve `poligono`, `fase_mantenimiento`, contadores agregados y estado, pero no trae progreso por especie ni asignaciones.
- Alineacion pendiente backend: `documentacion/frontend/modulos/lotes-vivero-m3.md` dice que los GET de Lotes de Vivero requieren `x-auth-id`, pero `src/lotes-vivero/api/lotes-vivero.controller.ts` tiene un TODO indicando que hoy los GET son publicos y no exigen header. El frontend deberia seguir enviando `x-auth-id` por consistencia, pero no asumir que backend lo valida hasta que se cierre ese TODO.
- Alineacion corregida por migracion: cualquier texto antiguo que diga que cancelar subcampania libera asignaciones de forma "logica" esta superado por `migrations/054_m3_devolucion_fisica.sql`; la cancelacion vigente devuelve fisicamente al lote y crea eventos M2/M3.

### 7.4 No existen en backend aunque aparecian como conceptuales

- `GET /subcampanias/:id/asignaciones`
- `GET /subcampanias/:id/progreso`
- `GET /subcampanias/:id/historial`
- `POST /subcampanias/:id/plantaciones`
- `POST /plantaciones/evidencias-pendientes`
- `POST /subcampanias/:id/finalizar-parcial`
- `GET /usuarios/me/subcampanias-operativas`
- `GET /subcampanias/:id/mortandad/context`
- `POST /subcampanias/:id/mortandad`
- `GET /subcampanias/:id/reposicion/context`
- `POST /subcampanias/:id/reposiciones`

### 7.5 Endpoints a pedir antes de tickets grandes

Prioridad alta para operar desde detalle de subcampania:

```text
GET /subcampanias/:id/asignaciones
GET /subcampanias/:id/progreso
GET /subcampanias/:id/historial
```

Prioridad media para campo:

```text
GET /usuarios/me/subcampanias-operativas
```

Post-MVP:

```text
GET /subcampanias/:id/mortandad/context
POST /subcampanias/:id/mortandad
GET /subcampanias/:id/reposicion/context
```

## 8. Validaciones visuales esperadas

Estas validaciones son ayuda UX. El backend sigue siendo autoridad.

- Campania sin subcampanias se puede desactivar.
- Campania con subcampanias no canceladas no se desactiva.
- Subcampania sin poligono no activa.
- Subcampania sin coordinador no activa.
- Plan por especie debe sumar 100%.
- Suma de cantidades del plan debe igualar meta total.
- Activacion con stock parcial o cero se permite, pero se advierte.
- Asignacion `PLANTACION_INICIAL` solo en subcampania `ACTIVA`.
- Asignacion `REPOSICION` en `ACTIVA`, `COMPLETADA` o `FINALIZADA_PARCIAL`.
- Plantacion inicial solo en `ACTIVA`.
- Plantacion inicial requiere foto y GPS.
- Plantacion inicial no supera stock asignado disponible.
- Plantacion inicial no supera meta pendiente por especie.
- Plantacion inicial debe enviar `detalles` por asignacion/lote/planta; `cantidades_por_especie` es solo shape interno de UI si se mapea antes de guardar.
- GPS fuera del poligono no debe bloquear por frontend; backend responde `gps_dentro_poligono=false`.
- Devolucion no supera `saldo_asignado_disponible`.
- Cancelacion no se permite con plantaciones iniciales.
- Cancelacion con asignaciones disponibles dispara devolucion fisica automatica en backend; pedir confirmacion y refetch.
- Finalizada parcial usa `POST /subcampanias/:id/cerrar`, requiere `estado_final=FINALIZADA_PARCIAL`, motivo y confirmacion.
- Mortandad no supera vivos estimados del grupo.
- Reposicion no supera mortandad pendiente.

## 9. Orden practico de implementacion

Este orden evita construir pantallas que no tengan contrato suficiente.

### Paso 1 - Consolidar detalle de subcampania

Estado inicial: existe.

Hacer:

- agregar tabs `Asignaciones`, `Plantaciones`, `Historial`;
- mostrar fase de mantenimiento;
- mostrar progreso total y por especie si backend lo entrega;
- agregar CTA contextual segun estado y permisos.

Resultado esperado:

- la subcampania se vuelve la pantalla central de operacion.

### Paso 2 - Asignaciones por subcampania

Hacer:

- consumir `GET /subcampanias/:id/asignaciones` si backend lo expone;
- si no existe, pedirlo antes de hacer workaround grande;
- fallback temporal: operar desde `GET /lotes-vivero/:id/asignaciones` solo en pantallas de Vivero, no como fuente completa de subcampania;
- crear vista de cobertura por especie;
- crear UI de devolucion usando el service existente;
- reutilizar uploader/stepper/fecha de Vivero.

Resultado esperado:

- admin/coordinador ve y corrige stock entregado sin ir lote por lote.

### Paso 3 - Plantacion inicial mobile

Hacer:

- crear flujo en `/app/planting/subcampanias/:id/plantaciones/new`;
- evidencia + GPS;
- cantidades por especie;
- resolver `detalles` por `asignacion_id`, `lote_vivero_id`, `planta_id`;
- resumen;
- `POST /registros-plantacion/evidencias-pendientes`;
- `POST /registros-plantacion`;
- refetch de subcampania/asignaciones.

Resultado esperado:

- primer flujo completo de campo funcionando.

### Paso 4 - Home simple de campo

Hacer solo si mejora la operacion:

- `/app/campo`;
- listar subcampanias donde el usuario es coordinador u operario;
- acciones rapidas: plantar, mortandad, reposicion;
- sin dashboard complejo.

Resultado esperado:

- el operario no depende de navegar por campanias.

### Paso 5 - Finalizada parcial

Hacer:

- boton solo ADMIN en subcampania `ACTIVA`;
- motivo obligatorio;
- enviar `POST /subcampanias/:id/cerrar`;
- confirmacion;
- refetch.

Resultado esperado:

- cierre manual sin romper trazabilidad.

### Paso 6 - Mortandad

Hacer despues de tener registros de plantacion:

- contexto por grupos;
- foto + GPS;
- delta y causa;
- resumen;
- POST.

### Paso 7 - Reposicion

Hacer despues de mortandad:

- grupos con pendiente;
- stock `REPOSICION`;
- cantidades;
- foto + GPS;
- POST.

## 10. Criterios de cierre del frontend MVP

El MVP frontend se considera cerrado cuando:

- admin puede crear campania;
- admin puede crear, guardar, editar y activar subcampania;
- admin/coordinador puede entregar stock fisico a subcampania con evidencia;
- admin/coordinador puede ver asignaciones por subcampania;
- admin/coordinador puede devolver stock no consumido;
- operario/coordinador del equipo puede registrar plantacion inicial con foto y GPS;
- la plantacion consume stock asignado y no genera despacho automatico;
- subcampania refleja progreso actualizado despues de plantar;
- admin puede cancelar subcampania sin plantaciones;
- admin puede finalizar parcialmente una subcampania activa;
- todas las mutaciones criticas tienen loading, error, exito y refetch;
- la UI no usa `AUTOMATICO_PLANTACION` como flujo vigente;
- no hay botones para editar o borrar eventos append-only;
- no se recalculan saldos como fuente de verdad;
- lo que no tenga endpoint queda registrado como pendiente, no simulado.

## 11. Notas para tickets siguientes

Para convertir esto a tickets, evitar tickets enormes como "Construir modulo Plantacion". Dividir por capacidad verificable:

1. Detalle de subcampania: tabs operativas y CTAs.
2. Endpoint/contexto de asignaciones por subcampania.
3. UI de asignaciones por subcampania.
4. UI de devolucion.
5. Endpoint/contexto de plantacion inicial o mapeo frontend de asignaciones a `detalles`.
6. Flujo mobile de plantacion inicial usando `POST /registros-plantacion`.
7. Home simple de campo.
8. Finalizacion parcial usando `POST /subcampanias/:id/cerrar`.
9. Contexto y UI de mortandad.
10. Contexto y UI de reposicion.
11. QA mobile-first y errores backend.

Cada ticket debe declarar:

- endpoint usado;
- estados permitidos;
- rol/permiso esperado;
- evidencia requerida;
- refetch despues de mutacion;
- verificacion minima.
