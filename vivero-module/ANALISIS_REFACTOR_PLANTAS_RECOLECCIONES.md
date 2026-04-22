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

* **Código Activo:** El método `createV2` en `recolecciones.service.ts` representa el estándar deseado. Valida la existencia de la planta antes de registrar la recolección, garantizando que no se cree "basura técnica".
* **Código Legacy (P0):** El método `create` original contiene lógica de inserción directa en la tabla `planta` (**Línea 483**). 
    * **Riesgo:** Genera **transacciones acopladas**. Si la validación botánica falla, se cae el registro de la recolección, o peor, deja registros huérfanos de ubicaciones y fotos.

---

## 4. Inconsistencias Técnicas (Hallazgos Críticos)

### 4.1. Inconsistencia de Esquema (DB vs DTO)
* **Evidencia DB:** `migrations/005_update_planta_table_structure.sql` define `tipo_planta` como `TEXT`.
* **Evidencia Código:** El DTO `CreatePlantaDto` exige un `tipo_planta_id` de tipo `number`.
* **Impacto:** Riesgo inminente de **Errores 500** al intentar estandarizar los catálogos botánicos si los tipos de datos no coinciden en la ejecución.

### 4.2. Riesgo de Seguridad (Autenticación)
* **Evidencia:** `recolecciones.controller.ts:536` -> `const userRole = 'ADMIN';`.
* **Impacto:** Se fuerza un rol con privilegios elevados por código, ignorando las políticas de Supabase y permitiendo un bypass de las restricciones de acceso reales.

### 4.3. Acoplamiento en Frontend (UI/UX)
* **UI "Secuestrada" (RecoleccionFormDatosScreen.tsx:240):** El formulario de recolección gestiona estados y modales de creación de plantas. Si el proceso de "Agregar al catálogo" falla, la experiencia de usuario se interrumpe por un dominio ajeno.
* **God Hook (useCatalogosRecoleccion.ts:20, 40):** El hook carga plantas, viveros y especies simultáneamente. 
    * **Impacto Viveros:** El módulo de Viveros necesita el catálogo de especies, pero al usar este hook se ve obligado a cargar también "Métodos de Recolección", ralentizando la App innecesariamente (Carga Ineficiente).
* **Corrupción Silenciosa (recoleccionForm.ts:101):** Uso de `planta_id: form.planta_id || 1` como fallback. 
    * **Riesgo Crítico:** Si un usuario no selecciona planta, el sistema asigna el ID 1 (Especie genérica), destruyendo la veracidad de la trazabilidad desde el origen.

---

## 5. Propuesta de Refactor por Fases

### Fase 1: Extracción y Delegación (P0)
1. Migrar la lógica de creación de planta de `RecoleccionesService` a un método dedicado en `PlantasService`.
2. Eliminar el *hardcoding* del rol `ADMIN` en el controlador para respetar la sesión activa del usuario.

### Fase 2: Estandarización de Contratos (P1)
1. Implementar **Creación Atómica**: El Frontend debe registrar primero la planta en el catálogo y, solo tras obtener un ID real, proceder con el registro de la recolección.
2. Sincronizar la columna `tipo_planta` en la DB para admitir IDs numéricos estandarizados.

### Fase 3: Independencia de UI (P2)
1. **Fragmentación de Hooks:** Dividir `useCatalogosRecoleccion` en `usePlantasCatalog` y `useRecoleccionMethods`.
2. Habilitar el CRUD completo en la ruta `PlantasScreen.tsx` para gestión independiente de especies.

---

## 6. Priorización de Riesgos (Matriz de Impacto)

| Nivel | Hallazgo | Razón del Impacto |
| :--- | :--- | :--- |
| **P0** | **Fallback ID 1** | Corrompe la verdad de los datos y la trazabilidad origen-destino. |
| **P0** | **Hardcoding Admin** | Brecha de seguridad que permite saltar restricciones de acceso. |
| **P1** | **Inconsistencia de Tipos** | Bloquea la escalabilidad y genera inestabilidad en el servidor. |
| **P2** | **God Hook (Front)** | Afecta el rendimiento y la reutilización en el módulo de Viveros. |

---

## 7. Respuestas Estratégicas (Q&A)

**¿Deberíamos tener un `plantas.service.ts`?** Sí. Actualmente `RecoleccionesService` excede las 800 líneas. Un servicio independiente permitirá que módulos como **Viveros** consuman datos botánicos de forma limpia.

**¿Qué tendríamos que tener en la UI de Planta?** Un inventario independiente, buscador global de especies y una vista de edición para corregir datos técnicos sin "ensuciar" el flujo de una recolección.

**¿Qué SÍ debería ir en Recolección y por qué?** Únicamente la referencia (`planta_id`) y los datos operativos (fecha, cantidad, fotos). La planta es una entidad de catálogo; la recolección es un evento sobre esa entidad.