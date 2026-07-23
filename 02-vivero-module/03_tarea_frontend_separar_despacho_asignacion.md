# Tarea frontend - Separar Despacho y Asignacion en Vivero

> **Estado:** COMPLETADA
>
> **Repositorio objetivo:** `pwa-r3foresta`
>
> **Alcance:** solo frontend. No modificar Backend, base de datos, endpoints, enums SQL ni datos historicos.
>
> **Implementacion:** commit frontend `562a97e1ab6050ba44a3ba57d3c69edddabaa250` (`feat(vivero): separar Despacho manual y Asignación a subcampaña`).
>
> **Verificacion:** `npm run lint` y `npm run build` ejecutados correctamente el 2026-07-23.

## 1. Objetivo

Eliminar la confusion operativa entre dos acciones que producen una salida fisica de plantas del vivero, pero tienen destinos y efectos de negocio diferentes:

- **Despacho manual:** salida hacia un destino que no pertenece a una campania.
- **Asignacion:** entrega fisica de plantas a una subcampania especifica para que posteriormente sean consumidas en Plantacion.

Aunque una asignacion genera internamente un evento M2 `DESPACHO` con origen `ASIGNACION_SUBCAMPANIA`, la interfaz debe presentarla como una accion independiente llamada **Asignacion**.

## 2. Decision de producto para el MVP

### 2.1 Despacho manual

El formulario de Despacho debe mostrar solamente estos tipos de destino:

| Valor enviado al backend | Label de UI | Comportamiento |
|---|---|---|
| `DONACION` | Donacion | Mantener seleccion de comunidad destino y referencia adicional opcional. |
| `VENTA` | Venta | Solicitar referencia del destino/comprador. |
| `OTRO` | Otro | Solicitar descripcion o referencia del destino. |

No mostrar como opciones de Despacho:

- `PLANTACION_PROPIA`;
- `PLANTACION_COMUNIDAD`;
- `PLANTACION_CAMPANIA`;
- `DONACION_COMUNIDAD` (no es un valor valido del contrato backend).

Esta restriccion aplica a las opciones de nuevas operaciones en la UI. No se deben ocultar ni alterar eventos historicos que ya existan en el timeline.

El formulario de Despacho debe explicar que:

- registra una salida fuera de campanias;
- descuenta el saldo vivo del lote;
- exige evidencia fotografica;
- no selecciona campania ni subcampania.

### 2.2 Asignacion a subcampania

Asignacion debe aparecer como una accion/formulario propio junto a los formularios operativos de Vivero.

Debe conservar el formulario ya implementado, incluyendo:

- campania destino;
- subcampania destino;
- proposito `PLANTACION_INICIAL` o `REPOSICION`;
- cantidad de plantas;
- fecha de asignacion/entrega;
- minimo una foto como evidencia;
- saldo vivo actual y efecto de la operacion;
- validaciones, estados de carga, error y exito existentes.

El texto principal debe usar **Asignacion** o **Asignacion a subcampania**. Puede aclarar que la asignacion constituye una entrega fisica y descuenta inmediatamente el saldo vivo del vivero.

Debe continuar consumiendo los contratos existentes:

```text
POST /lotes-vivero/evidencias-pendientes
POST /lotes-vivero/:loteId/asignaciones
```

No crear endpoints nuevos ni simular la operacion desde el frontend.

## 3. Cambios de interfaz requeridos

### 3.1 Pantalla de formularios del lote

Agregar `asignacion` como `StageKey` y permitir la ruta existente:

```text
/app/vivero/:loteId/event/asignacion
```

Incluir una pestaña visible llamada `Asignacion` en `ViveroEventScreen`, junto a:

- Adaptabilidad;
- Merma;
- Despacho.

La asignacion solo debe estar disponible cuando:

- existe `EMBOLSADO`;
- el lote esta `ACTIVO`;
- `saldo_vivo_actual > 0`.

La elegibilidad final sigue siendo responsabilidad del backend.

### 3.2 Acciones rapidas

Agregar una accion rapida `Asignacion` en el resumen del lote, con navegacion a:

```text
/app/vivero/:loteId/event/asignacion
```

Debe respetar las mismas condiciones visuales de disponibilidad del formulario y no deteriorar el layout mobile de las acciones existentes.

### 3.3 Pestaña Asignaciones del detalle

La pestaña `Asignaciones` del detalle del lote debe dejar de contener el formulario de creacion.

Debe conservar:

- listado devuelto actualmente por `GET /lotes-vivero/:loteId/asignaciones`;
- loading, error y empty state;
- cantidades entregadas, consumidas, devueltas, mermadas y disponibles;
- campania, subcampania, fecha, proposito y coordinador;
- accion y modal de devolucion al vivero;
- dialogs de resultado que correspondan al listado/devolucion.

En este alcance, la pestaña muestra exactamente la informacion que entrega el endpoint actual. No debe prometer un historial exhaustivo de asignaciones agotadas o inactivas.

### 3.4 Finalizacion de una asignacion

Despues de crear exitosamente una asignacion:

1. refrescar el detalle/saldo del lote;
2. mostrar confirmacion de exito;
3. facilitar el regreso al detalle del lote, preferentemente abriendo la pestaña `Asignaciones`.

Si se utiliza un query param, la ruta sugerida es:

```text
/app/vivero/:loteId?tab=asignaciones
```

`ViveroDetailScreen` debe leerlo de forma defensiva y mantener `resumen` como valor por defecto.

## 4. Orientacion de implementacion

Reutilizar el codigo actual y evitar duplicar las reglas del formulario.

Separacion sugerida:

- extraer la seccion de creacion que hoy vive en `ViveroLotAsignacionesTab.tsx`;
- crear un formulario enfocado, por ejemplo `components/event/forms/AsignacionForm.tsx`;
- dejar `ViveroLotAsignacionesTab.tsx` enfocado en consulta y devolucion;
- adaptar un contrato de props minimo o el mapper existente para que el formulario pueda utilizarse desde `ViveroEventScreen` sin duplicar fetches ni modelos de dominio.

Archivos principales a revisar:

```text
src/modules/vivero/screens/ViveroEventScreen.tsx
src/modules/vivero/screens/ViveroDetailScreen.tsx
src/modules/vivero/components/event/StageTabs.tsx
src/modules/vivero/components/event/forms/DespachoForm.tsx
src/modules/vivero/components/ViveroLotAsignacionesTab.tsx
src/modules/vivero/components/QuickActions.tsx
src/modules/vivero/types/contracts.ts
```

Capas API y service ya disponibles:

```text
src/api/lotes-vivero.api.ts
src/services/lotes-vivero.service.ts
```

Correccion contractual obligatoria en frontend:

```text
DONACION_COMUNIDAD -> DONACION
```

El selector de comunidad puede conservarse como comportamiento condicionado de `DONACION`; solo cambia el valor enviado al backend.

## 5. Criterios de aceptacion

### Despacho

- El selector muestra exactamente `Donacion`, `Venta` y `Otro`.
- No aparecen `Plantacion propia`, `Plantacion comunidad` ni `Plantacion campania`.
- Donacion envia `destino_tipo = DONACION`, nunca `DONACION_COMUNIDAD`.
- Donacion conserva la seleccion de comunidad destino.
- Despacho no solicita campania ni subcampania.
- Cantidad, fecha, foto, referencia condicionada, observaciones y confirmacion siguen funcionando.
- El despacho exitoso sigue descontando saldo y reflejando el cierre automatico devuelto por backend.

### Asignacion

- Existe una accion rapida visible llamada `Asignacion`.
- `/app/vivero/:loteId/event/asignacion` abre el formulario.
- La pestaña de formulario se deshabilita o no se expone operativamente sin `EMBOLSADO`, con lote finalizado o sin saldo vivo.
- El formulario conserva seleccion de campania, subcampania, proposito, cantidad, fecha y foto.
- La operacion sigue utilizando el endpoint de asignacion existente.
- El guardado exitoso refresca el saldo y permite ver la asignacion registrada.
- No se presenta la asignacion como una reserva logica.

### Detalle del lote

- La pestaña `Asignaciones` ya no contiene campos ni boton para crear una asignacion.
- El listado de asignaciones activas sigue cargando.
- La devolucion al vivero sigue funcionando sin regresiones.
- Los empty/error/loading states permanecen visibles.

### Calidad

- No se modifican archivos del repositorio Backend.
- No se agregan valores de enum inventados.
- No se ocultan eventos historicos del timeline.
- No se introducen llamadas `fetch` dentro de componentes.
- No se agregan dependencias.
- La UI se mantiene usable en el ancho mobile actual.
- `npm run lint` pasa.
- `npm run build` pasa.

## 6. Escenarios de verificacion manual

1. Lote activo, embolsado y con saldo:
   - abrir `Asignacion`;
   - completar campania, subcampania, proposito, cantidad, fecha y foto;
   - guardar;
   - comprobar confirmacion, saldo actualizado y registro visible en `Asignaciones`.

2. Lote activo, embolsado y con saldo:
   - abrir `Despacho`;
   - comprobar que solo existen Donacion, Venta y Otro;
   - registrar una Donacion y verificar que el request envia `DONACION`.

3. Lote sin embolsado:
   - comprobar que Asignacion y Despacho no permiten operar.

4. Lote sin saldo o finalizado:
   - comprobar que no se puede iniciar una nueva Asignacion ni un nuevo Despacho.

5. Pestaña `Asignaciones`:
   - comprobar que no existe formulario de alta;
   - comprobar listado, empty/error/loading;
   - ejecutar una devolucion disponible y verificar el refetch.

6. Timeline:
   - comprobar que eventos historicos, incluidos destinos antiguos si existen, continúan visibles.

## 7. Fuera de alcance

- modificar Backend o base de datos;
- eliminar valores de enums backend;
- hacer que la API rechace `PLANTACION_PROPIA` o `PLANTACION_COMUNIDAD`;
- obtener historial completo de asignaciones agotadas/inactivas;
- crear una vista agregada de asignaciones por subcampania;
- cambiar reglas de permisos o elegibilidad de asignaciones;
- modificar el consumo de asignaciones desde Plantacion;
- borrar, editar o migrar eventos historicos;
- actualizar `ESTADO.md` antes de que la implementacion sea confirmada.

## 8. Cierre

Tarea completada y confirmada el 2026-07-23.

Resultado implementado:

- Despacho manual expone solo `DONACION`, `VENTA` y `OTRO`.
- `DONACION` reemplaza al valor frontend invalido `DONACION_COMUNIDAD` y conserva el selector de comunidad.
- `AsignacionForm` vive como formulario propio en `/app/vivero/:loteId/event/asignacion`.
- Asignacion aparece en las acciones rapidas y respeta `EMBOLSADO` + lote `ACTIVO` + saldo vivo positivo.
- Al guardar, vuelve al detalle mediante `?tab=asignaciones`.
- `ViveroLotAsignacionesTab` queda enfocado en consulta y devolucion.
- No se modificaron Backend, endpoints, enums SQL ni datos historicos.
- `lint` y `build` pasan.
