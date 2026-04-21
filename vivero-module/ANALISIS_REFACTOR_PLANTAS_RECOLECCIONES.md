# Análisis de Refactor: Desacoplamiento Plantas y Recolecciones

## 1. Introducción
El presente documento detalla el análisis técnico realizado sobre el acoplamiento existente entre los módulos de **Recolecciones** y **Plantas**. Se ha identificado una arquitectura monolítica que compromete la mantenibilidad del sistema y la integridad de la trazabilidad forestal en r3foresta. 

Este análisis propone un camino de **desacoplamiento estructural** para permitir que la gestión botánica sea independiente de la operativa de campo.

---

## 2. Auditoría de Endpoints (Backend)

Se ha mapeado la distribución de responsabilidades en los controladores actuales, detectando una duplicidad crítica en la lógica de creación de entidades.

### 2.1. Módulo: Plantas (`/plantas`)
| Método | Endpoint | Acción | Estado |
| :--- | :--- | :--- | :--- |
| **GET** | `/plantas` | Listado general de especies | Activo |
| **GET** | `/plantas/search` | Búsqueda por término (Query) | Activo |
| **POST** | `/plantas` | Crear nueva planta (Catálogo) | Activo (Contrato V2) |

### 2.2. Módulo: Recolecciones (`/recolecciones`)
| Método | Endpoint | Relación con Plantas | Observación |
| :--- | :--- | :--- | :--- |
| **POST** | `/recolecciones` | Creación embebida | **Legacy (Riesgo):** Crea plantas durante el flujo. |
| **POST** | `/recolecciones/v2` | Referencia por ID | **Activo:** Requiere `planta_id` pre-existente. |
| **GET** | `/:id` | Enriquecimiento | Inyecta datos de planta en la respuesta. |

---

## 3. Mapeo de Código: Activo vs. Legacy

* **Código Activo:** El método `createV2` en `recolecciones.service.ts` representa el estándar deseado. Valida la existencia de la planta en la base de datos antes de permitir el registro, garantizando que no se cree "basura" técnica durante la recolección.
* **Código Legacy (P0):** El método `create` original contiene lógica de inserción directa en la tabla `planta` (Línea 483). Esto genera **transacciones acopladas**: si la validación botánica falla, se interrumpe el registro de la actividad, dejando potencialmente datos de ubicación huérfanos.

---

## 4. Inconsistencias Técnicas (Hallazgos Críticos)

### 4.1. Inconsistencia de Esquema (DB vs DTO)
* **Evidencia DB:** `migrations/005_update_planta_table_structure.sql` define `tipo_planta` como `TEXT`.
* **Evidencia Código:** El DTO `CreatePlantaDto` exige un `tipo_planta_id` de tipo `number`.
* **Impacto:** Riesgo inminente de errores 500 al intentar estandarizar los catálogos botánicos si los tipos de datos no coinciden en la ejecución.

### 4.2. Riesgo de Seguridad (Autenticación)
* **Evidencia:** `recolecciones.controller.ts:536` -> `const userRole = 'ADMIN';`.
* **Impacto:** Se fuerza un rol con privilegios elevados por código, ignorando las políticas de Supabase y permitiendo un bypass de las restricciones de acceso reales.

### 4.3. Acoplamiento en Frontend (UI/UX)
* **UI "Secuestrada":** `RecoleccionFormDatosScreen.tsx` (Línea 240) gestiona modales de creación de plantas, interrumpiendo el flujo operativo con lógica ajena al módulo.
* **God Hook:** `useCatalogosRecoleccion.ts` carga plantas, tipos y métodos simultáneamente (Línea 20), degradando el rendimiento de la PWA.
* **Corrupción de Datos:** `recoleccionForm.ts` (Línea 101) asigna por defecto el **ID 1** si no se selecciona una planta, destruyendo la veracidad de la trazabilidad desde el origen.

---

## 5. Propuesta de Refactor por Fases

### Fase 1: Extracción y Delegación (P0)
1.  Migrar la lógica de creación de planta de `RecoleccionesService` a un método dedicado en `PlantasService`.
2.  Eliminar el *hardcoding* del rol `ADMIN` en el controlador para respetar la sesión activa.

### Fase 2: Estandarización de Contratos (P1)
1.  Unificar DTOs para que el Frontend realice **operaciones atómicas**: primero registra la planta y, con el ID obtenido, procede a la recolección.
2.  Sincronizar la columna `tipo_planta` en la DB para admitir IDs numéricos según el nuevo estándar.

### Fase 3: Independencia de UI (P2)
1.  Habilitar el CRUD completo en la ruta `PlantasScreen.tsx` (actualmente vacía).
2.  Fragmentar `useCatalogosRecoleccion` en hooks especializados (ej. `usePlantas`, `useMethods`).

---

## 6. Priorización de Riesgos

| Nivel | Hallazgo | Razón del Impacto |
| :--- | :--- | :--- |
| **P0** | **Fallback ID 1** | Invalida la integridad de la cadena de custodia pre-plantación. |
| **P0** | **Hardcoding Admin** | Brecha de seguridad crítica en el control de acceso. |
| **P1** | **Inconsistencia de Tipos** | Bloquea la escalabilidad y genera errores de servidor. |
| **P2** | **God Hook (Front)** | Genera deuda técnica y afecta la experiencia de usuario. |

---

## 7. Respuestas Estratégicas (Q&A)

**¿Deberíamos tener un `plantas.service.ts`?** Sí. Actualmente `RecoleccionesService` excede las 800 líneas. Un servicio independiente permitirá que módulos como **Viveros** consuman datos botánicos de forma limpia sin arrastrar lógica de trazabilidad operativa.

**¿Qué tendríamos que tener en la UI de Planta?** Un inventario independiente, buscador global de especies y una vista de edición para corregir datos técnicos sin necesidad de iniciar un flujo de recolección ficticio.

**¿Qué SÍ debería ir en Recolección y por qué?** Únicamente la referencia (`planta_id`) y los datos operativos (fecha, cantidad, fotos). La planta es una entidad de catálogo; la recolección es un evento que ocurre sobre esa entidad.