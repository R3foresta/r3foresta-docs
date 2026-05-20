# Guía de Mockups — Módulo 3: Plantación

> Documento orientado a diseño visual (Claude Design / Figma).
> Describe pantallas, componentes y flujos UX **sin reglas técnicas de backend**.
> Para reglas de negocio y modelo de datos, ver el MD y JSON de procesos del módulo.

---

## 1. Contexto del módulo

El **Módulo 3 (Plantación)** es donde se concreta el objetivo del proyecto: **reforestar, arborizar o forestar** zonas y comunidades.

Los árboles vienen del **Módulo 2 (Vivero)** y se plantan dentro de **campañas** que organiza el administrador o un coordinador de proyecto.

El módulo es un **proyecto blockchain de transparencia**, por lo tanto los datos son públicos y auditables.

---

## 2. Tipos de usuario y sus necesidades

### 2.1. Administrador
**Qué necesita ver y hacer:**
- Crear y planificar nuevas campañas (zona, meta de árboles, mix de especies, polígono del área).
- Asignar árboles desde lotes de vivero hacia campañas.
- Ver el progreso global de todas las campañas.
- Designar coordinadores y operarios a las campañas.
- Cerrar, pausar o cancelar campañas.

**Tono de la interfaz:** densa en datos, orientada a planificación, tablas y dashboards.

### 2.2. Coordinador de campaña
**Qué necesita ver y hacer:**
- Gestionar las campañas a su cargo.
- Asignar/devolver árboles entre vivero y su campaña.
- Ver el progreso detallado de su campaña.
- Ver el desempeño de los operarios de su equipo.
- También puede operar (plantar y registrar como un operario).

**Tono de la interfaz:** intermedio entre admin y operario, foco en su campaña.

### 2.3. Operario
**Qué necesita ver y hacer:**
- Ver las campañas disponibles donde puede plantar hoy.
- Registrar plantaciones de forma rápida en campo (foto + GPS + especies + cantidades).
- Ver cuánto plantó él/su equipo en el día y en la campaña.
- Reportar mortandad de plantaciones anteriores cuando hace visitas.
- Registrar reposiciones.

**Tono de la interfaz:** mobile-first, muy operativa, pocos pasos, botones grandes, optimizada para uso en exterior con sol.

### 2.4. Público general (alcaldes, ciudadanos, donantes)
**Qué necesita ver:**
- Cuánto se ha plantado y dónde (mapa interactivo).
- Estimación de captura de carbono.
- Detalle de cada campaña activa o histórica.
- Evidencia: fotos, ubicaciones, especies plantadas.
- Datos de transparencia: quién plantó, cuándo, de dónde vinieron los árboles.

**Tono de la interfaz:** atractiva, narrativa, visual, mapa central, gráficos y barras de progreso. No requiere login. Es la cara pública del proyecto.

---

## 3. Pantallas principales

### 3.1. PWA pública — Home sin autenticación

**Objetivo:** mostrar el impacto del proyecto a cualquier visitante.

**Componentes clave:**
- **Hero / encabezado:** título del proyecto, totalizadores grandes (árboles plantados, captura estimada de CO₂, campañas activas, comunidades alcanzadas).
- **Mapa interactivo principal:**
  - Polígonos de las zonas/comunidades con campañas activas o completadas.
  - Pines GPS dentro de los polígonos por cada registro de plantación.
  - Color del polígono según % de avance.
  - Click en polígono → panel lateral con resumen de la campaña.
  - Click en pin → mini-tarjeta con foto, fecha, especies, cantidad, operario.
- **Barras de progreso destacadas:** listado de campañas activas con su avance ("Arborización San Miguel: 340/1000 árboles plantados").
- **Sección de campañas completadas:** mosaico de campañas terminadas con fotos.
- **Sección de transparencia:** "Este proyecto vive en blockchain. Todos los datos son auditables." → link a explorador blockchain.

### 3.2. Detalle público de campaña

Cuando el visitante hace click en una campaña desde la home.

**Componentes:**
- Cabecera con nombre, tipo (reforestación / arborización / forestación), zona, estado, fechas, polígono del área.
- Barra de progreso grande: árboles plantados / meta, % completado.
- Mini-barras del mix de especies: cada especie con su % real vs % planificado.
- Mapa con los pines de las plantaciones realizadas dentro del polígono.
- Timeline visual de plantaciones (por día/semana).
- Galería de fotos.
- Métricas: árboles vivos actuales, mortandad acumulada, reposiciones realizadas, captura estimada de CO₂.
- Trazabilidad: link a "ver origen de estos árboles" (lleva a vivero/recolección si el usuario quiere profundizar).
- Equipo: coordinador y operarios que participaron.

### 3.3. Dashboard del administrador

**Objetivo:** vista de comando central.

**Componentes:**
- KPIs en tarjetas superiores: total de árboles plantados, campañas activas, árboles asignados sin plantar, mortandad acumulada del mes.
- Tabla de campañas activas con: nombre, zona, coordinador, meta, plantados, % avance, estado, acciones.
- Filtros: por estado, por zona, por coordinador.
- Botón destacado: "Crear nueva campaña".
- Acceso rápido a: gestión de coordinadores, asignaciones pendientes, alertas.

### 3.4. Crear / editar campaña (admin)

Wizard de varios pasos.

**Paso 1: Datos generales**
- Nombre de la campaña.
- Tipo (selector: reforestación / arborización / forestación).
- Descripción opcional.
- Coordinador asignado (selector de usuario).
- Operarios del equipo (selector múltiple).
- Campaña padre (opcional, si es una fase de otra campaña).

**Paso 2: Zona y polígono**
- Selector de país/departamento/provincia/comunidad o zona (jerárquico, desde catálogo).
- Posibilidad de agregar **múltiples zonas** con sub-metas por zona.
- Componente de mapa para **dibujar el polígono** del área a intervenir (obligatorio).
- Vista previa del polígono con su área calculada en hectáreas (referencial).

**Paso 3: Meta de árboles y especies**
- Meta total de árboles.
- Si hay múltiples zonas: distribución de la meta entre zonas (sub-metas).
- Mix de especies: agregar especies del catálogo y asignar % máximo a cada una (ej: Jacarandá 40%, Molle 40%, otras 20%).
- Validación visual: la suma de % no debe pasar el 100%.

**Paso 4: Asignación inicial de árboles desde vivero (opcional en creación)**
- Listado de lotes de vivero disponibles con stock vivo.
- Selección de cantidades a asignar desde cada lote.
- Esta asignación puede ampliarse después.

**Paso 5: Revisión y publicación**
- Resumen visual de toda la campaña.
- Botones: "Guardar como borrador" / "Activar campaña".

### 3.5. Detalle de campaña (admin/coordinador)

**Componentes:**
- Cabecera con estado de la campaña (BORRADOR / ACTIVA / PAUSADA / COMPLETADA / CANCELADA) y acciones según el estado.
- Tabs:
  - **Resumen:** progreso, mapa con pines, métricas clave.
  - **Plantaciones:** listado de cada registro de plantación con filtros (operario, fecha, zona, especie). Cada fila expandible muestra fotos, GPS, cantidades por especie.
  - **Asignaciones:** tabla de lotes de vivero asignados a la campaña, cuánto se plantó de cada uno, cuánto queda disponible. Botón "Asignar más árboles" y "Devolver al vivero".
  - **Mortandad y reposiciones:** registro de mortandades reportadas por grupo, reposiciones realizadas, % de supervivencia.
  - **Equipo:** coordinador y operarios participantes con sus aportes individuales.
  - **Historial:** timeline append-only de todos los eventos de la campaña.

### 3.6. Vista del operario (mobile-first, PWA)

**Objetivo:** registrar plantaciones en campo de forma ultra rápida.

#### 3.6.1. Home del operario
- Saludo + nombre.
- Tarjetas grandes de **campañas activas donde puede plantar**.
- Cada tarjeta muestra: nombre de la campaña, zona, % de avance, "X árboles disponibles para plantar hoy".
- Botón destacado en cada tarjeta: **"Registrar plantación"**.
- Acceso rápido: "Reportar mortandad", "Mi historial del día".

#### 3.6.2. Registrar plantación (flujo principal)
**Diseño:** pasos cortos, un dato por pantalla idealmente, validación inmediata.

**Paso 1: Selección de campaña**
- Si entró desde la tarjeta de una campaña, se asume preseleccionada.
- Sino, selector grande.

**Paso 2: Captura de foto + GPS**
- Botón gigante para tomar foto.
- Permite tomar **varias fotos** (galería del grupo plantado).
- GPS se captura automáticamente en cada foto.
- Indicador visible de "GPS capturado ✓" o "Activando GPS...".

**Paso 3: Especies y cantidades plantadas**
- Lista de especies disponibles para esa campaña (basadas en el mix planificado).
- Para cada especie: input numérico con +/- para sumar cantidad.
- Total visible en grande arriba.
- Si la especie supera su % máximo: advertencia visible pero **permite continuar** (es guía, no bloqueo en MVP).

**Paso 4: Co-responsables (opcional)**
- "¿Plantaste con alguien más hoy?"
- Selector múltiple del equipo de la campaña.

**Paso 5: Observaciones (opcional)**
- Campo de texto libre, corto.

**Paso 6: Confirmar**
- Resumen: campaña, cantidad total, especies, ubicación en mini-mapa, fotos.
- Botón grande "Registrar plantación".
- Confirmación visual + animación al guardar.

#### 3.6.3. Reportar mortandad
- Selector de campaña.
- Selector del **grupo de plantación** (lista de registros previos con foto, fecha y ubicación).
- Al seleccionar grupo: muestra histórico ("plantados: 50, ya reportados muertos: 10, vivos estimados: 40").
- Input: "¿Cuántos más murieron?" (delta).
- Foto opcional de evidencia.
- Observación opcional (causa probable).
- Confirmar.

#### 3.6.4. Registrar reposición
- Similar a registrar plantación, pero con flag visual "REPOSICIÓN".
- Pide vincular al grupo original que está reponiendo.
- Misma captura de foto, GPS, especies y cantidades.
- Se descuenta del saldo asignado a la campaña como cualquier plantación.

#### 3.6.5. Mi historial del día / semana
- Lista cronológica de lo que registró.
- Por cada registro: campaña, hora, cantidad, foto miniatura.
- Acumulado: "Hoy plantaste 87 árboles en 2 campañas".

### 3.7. Vista del coordinador

Combinación de:
- Su panel de campañas (similar al admin pero filtrado a sus campañas).
- Vista del operario (porque también puede plantar).
- Vista de equipo: desempeño individual de sus operarios.

### 3.8. Gestión de asignaciones (admin / coordinador)

**Objetivo:** mover árboles entre vivero y campañas.

**Componentes:**
- Tabla de asignaciones activas: campaña, lote de vivero origen, especie, cantidad asignada, cantidad plantada, cantidad disponible.
- Acción "Asignar árboles a campaña":
  - Selector de campaña destino.
  - Listado de lotes de vivero con stock vivo disponible.
  - Input de cantidad a asignar por lote.
  - Confirmar.
- Acción "Devolver al vivero":
  - Permitido solo sobre cantidad **no plantada todavía**.
  - Confirmación con motivo de devolución.

---

## 4. Componentes recurrentes / patrones visuales

- **Barra de progreso de campaña:** muy presente, debe ser visual y atractiva. Mostrar plantados / meta y % en grande.
- **Mini-barras de especies:** barras horizontales agrupadas que muestren % real vs % planificado por especie.
- **Tarjetas de plantación:** miniatura de foto + cantidad + especie + fecha + ubicación. Reutilizable en muchas pantallas.
- **Mapa con polígonos y pines:** componente clave reutilizado en home pública, detalle de campaña, dashboard. Debe ser interactivo y responsivo.
- **Timeline / historial append-only:** lista vertical de eventos con icono por tipo de evento (plantación, mortandad, reposición, asignación, cierre).
- **Badge de estado:** ACTIVA, PAUSADA, COMPLETADA, CANCELADA, BORRADOR. Colores diferenciados.
- **Badge de tipo de campaña:** REFORESTACIÓN, ARBORIZACIÓN, FORESTACIÓN.

---

## 5. Estados y feedback visual

- **Borrador:** gris, badge "BORRADOR", acciones limitadas.
- **Activa:** verde, badge "ACTIVA", todas las acciones operativas habilitadas.
- **Pausada:** ámbar, badge "PAUSADA", solo lectura para operarios.
- **Completada:** azul, badge "COMPLETADA", solo permite reposiciones.
- **Cancelada:** rojo claro, badge "CANCELADA", solo lectura.

Para la mortandad: mostrar siempre el porcentaje de supervivencia con colores semáforo (verde >85%, ámbar 70-85%, rojo <70%).

---

## 6. Consideraciones mobile

La PWA debe funcionar bien en celulares de gama media-baja, posiblemente con conexión intermitente en campo. Los mockups deben mostrar:

- Botones grandes, mínimo 48x48px touch target.
- Tipografía generosa para uso en exteriores.
- Alto contraste.
- Indicadores claros de "guardando..." y "guardado ✓".
- Eventual indicador de "sin conexión, se sincronizará después" (offline-first queda fuera del MVP pero el diseño puede anticiparlo visualmente).

---

## 7. Datos referenciales para mockups

Para que los mockups se vean realistas, usar estos datos como base:

**Campañas de ejemplo:**
- "Arborización La Paz 2026" — tipo arborización — zonas: Cota Cota, San Miguel, Hernán — meta: 3000 árboles (1000 por zona) — coordinador: Ing. María López.
- "Reforestación Hampaturi Fase 1" — tipo reforestación — comunidad Hampaturi — meta: 5000 árboles — mix: Queñua 40%, Kewiña 40%, otras nativas 20%.

**Especies de ejemplo:**
- Jacarandá, Molle, Ceibo, Queñua, Kewiña, Aliso, Pino radiata.

**Operarios de ejemplo:**
- Juan Mamani, Rosa Quispe, Carlos Apaza, Ana Condori.

**Métricas de ejemplo a mostrar:**
- "12,847 árboles plantados en total"
- "Captura estimada: 235 toneladas de CO₂ proyectadas"
- "8 campañas activas"
- "92% de supervivencia promedio"

---

## 8. Tono visual sugerido

- Colores: verdes naturales como primario, terracota o tierra como secundario, blancos amplios.
- Estética: limpia, moderna, con foco en la transparencia y la naturaleza.
- Inspiración: dashboards de proyectos de impacto, apps de cripto/blockchain con foco en transparencia, plataformas de ciencia ciudadana.
- Evitar: estética corporativa fría, demasiado tecnológica sin alma, o demasiado infantil.

---

## 9. Pantallas prioritarias para los primeros mockups

Si hay que priorizar, este es el orden sugerido para validar primero con el dueño del proyecto:

1. **Home pública con mapa** (es la cara del proyecto, lo que verá el alcalde/ciudadanos).
2. **Detalle público de campaña** (drill-down del mapa).
3. **Vista mobile del operario — registrar plantación** (el flujo más crítico operativamente).
4. **Dashboard del administrador** (planificación y comando).
5. **Crear nueva campaña (wizard del admin)** (planificación inicial).
6. **Detalle de campaña para admin/coordinador** (gestión diaria).
7. **Reportar mortandad y reposición desde mobile.**
8. **Gestión de asignaciones vivero → campaña.**
