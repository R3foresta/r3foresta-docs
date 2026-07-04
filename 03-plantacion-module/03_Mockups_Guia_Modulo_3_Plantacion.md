# Guía de Mockups — Módulo 3: Plantación

> Documento orientado a diseño visual (Claude Design / Figma).
> Describe pantallas, componentes y flujos UX **sin reglas técnicas de backend**.
> Para reglas de negocio y modelo de datos, ver el MD y JSON de procesos del módulo.

---

## 1. Contexto del módulo

El **Módulo 3 (Plantación)** es donde se concreta el objetivo del proyecto: **reforestar, arborizar o forestar** zonas y comunidades.

Los árboles vienen del **Módulo 2 (Vivero)** y se plantan dentro de **subcampañas operativas** que pertenecen a **campañas estratégicas** organizadas por el administrador.

El módulo es un **proyecto blockchain de transparencia**, por lo tanto los datos son públicos y auditables.

### Arquitectura de dos niveles

- **Campaña:** contenedor estratégico del proyecto. Tiene nombre, descripción, organizaciones asociadas. No tiene polígono ni meta propia.
- **Subcampaña:** unidad operativa real. Tiene polígono, meta total, plan de metas por especie, coordinador, equipo y estado propio.

Una campaña tiene N subcampañas (al menos 1).

### Estados operativos de subcampaña

- `BORRADOR` — en planificación
- `ACTIVA` — operativa, recibe plantaciones
- `COMPLETADA` — meta alcanzada (cierre automático)
- `FINALIZADA_PARCIAL` — cerrada antes de meta (cierre manual del admin)

### Fase de mantenimiento (paralela al estado)

- `MANTENIMIENTO_ACTIVO` — primeros 3 años post-cierre, se esperan reposiciones
- `MONITOREO_HISTORICO` — 3+ años post-cierre, solo seguimiento histórico

---

## 2. Tipos de usuario y sus necesidades

### 2.1. Administrador
**Qué necesita ver y hacer:**
- Crear campañas con sus organizaciones asociadas.
- Crear subcampañas dentro de cada campaña.
- Asignar coordinadores a subcampañas.
- Asignar lotes de vivero a subcampañas (con propósito).
- Ver el progreso global de todas las campañas y subcampañas.
- Cerrar subcampañas manualmente a FINALIZADA_PARCIAL.

**Tono de la interfaz:** densa en datos, orientada a planificación, tablas y dashboards.

### 2.2. Coordinador de subcampaña
**Qué necesita ver y hacer:**
- Gestionar sus subcampañas asignadas.
- Asignar/devolver árboles entre vivero y su subcampaña.
- Ver el progreso detallado de su subcampaña.
- Gestionar el equipo (agregar/remover operarios).
- También puede operar (plantar y registrar como un operario).

**Tono de la interfaz:** intermedio entre admin y operario.

### 2.3. Operario
**Qué necesita ver y hacer:**
- Ver las subcampañas donde es parte del equipo.
- Registrar plantaciones rápidas en campo (foto + GPS + especies + cantidades + selección de lote).
- Ver cuánto plantó él/su equipo en el día.
- Reportar mortandad en visitas posteriores.
- Registrar reposiciones.

**Tono de la interfaz:** mobile-first, muy operativa, botones grandes, optimizada para exterior.

### 2.4. Público general (alcaldes, ciudadanos, donantes)
**Qué necesita ver:**
- Cuánto se ha plantado y dónde (mapa interactivo).
- Estimación de captura de carbono.
- Detalle de campañas con sus subcampañas y organizaciones asociadas.
- Evidencia: fotos, ubicaciones, especies plantadas.
- Trazabilidad completa hasta el origen.

**Tono de la interfaz:** atractiva, narrativa, visual, mapa central. No requiere login.

---

## 3. Pantallas principales

### 3.1. PWA pública — Home sin autenticación

**Objetivo:** mostrar el impacto del proyecto.

**Componentes clave:**
- **Hero/encabezado:** título del proyecto, totalizadores grandes (árboles plantados, captura estimada CO₂, subcampañas activas, comunidades alcanzadas).
- **Mapa interactivo principal:**
  - Polígonos de subcampañas activas, completadas o finalizadas parciales.
  - Pines GPS dentro de los polígonos por cada registro de plantación.
  - Color del polígono según fase: ACTIVA (verde brillante), MANTENIMIENTO_ACTIVO (azul), MONITOREO_HISTORICO (gris).
  - Click en polígono → panel con resumen.
  - Click en pin → mini-tarjeta con foto, fecha, especies, cantidad, operario, lote origen.
- **Barras de progreso destacadas:** subcampañas activas con su avance.
- **Sección de campañas:** mosaico de campañas con sus subcampañas anidadas.
- **Sección de transparencia:** "Este proyecto vive en blockchain. Todos los datos son auditables."

### 3.2. Detalle público de campaña

**Componentes:**
- Cabecera con nombre, descripción, organizaciones asociadas (con logos), fechas estimadas.
- Estado derivado de la campaña (ACTIVA / EN_MANTENIMIENTO / MONITOREO_HISTORICO).
- Listado de sus subcampañas con barras de progreso individuales.
- Totalizadores agregados de toda la campaña.
- Mapa con todos los polígonos de las subcampañas.

### 3.3. Detalle público de subcampaña

Cuando el visitante hace click en una subcampaña.

**Componentes:**
- Cabecera con nombre, tipo (reforestación / arborización / forestación), zona, estado operativo, fase de mantenimiento, fechas, polígono.
- Barra de progreso grande: árboles plantados / meta, % completado.
- Si está en MANTENIMIENTO_ACTIVO: contador "X meses restantes de mantenimiento activo".
- Mini-barras de metas por especie: avance inicial vs planificado.
- Mapa con los pines de las plantaciones realizadas.
- Timeline visual de eventos (plantaciones, reposiciones, mortandad).
- Galería de fotos.
- Métricas: árboles vivos actuales, mortandad acumulada, reposiciones realizadas, captura estimada CO₂.
- Trazabilidad: link a "ver origen de estos árboles" → Vivero → Recolección.
- Equipo: coordinador y operarios participantes con sus aportes.

### 3.4. Dashboard del administrador

**Objetivo:** vista de comando central.

**Componentes:**
- KPIs superiores: total árboles plantados, subcampañas activas, en mantenimiento, asignaciones pendientes.
- Tabs:
  - **Campañas:** tabla con sus subcampañas anidadas, organizaciones, estado derivado.
  - **Subcampañas:** tabla plana con todas las subcampañas, sus coordinadores, % avance, fase de mantenimiento.
  - **Asignaciones:** tabla de asignaciones vivero → subcampaña con propósito.
  - **Alertas:** subcampañas próximas a cerrar, mantenimientos pendientes, etc.
- Botones: "Crear campaña", "Crear subcampaña", "Asignar lotes".

### 3.5. Crear campaña (admin)

**Wizard simple:**

**Paso 1: Datos generales**
- Nombre obligatorio.
- Descripción opcional.
- **Tipo obligatorio:** reforestación / arborización / forestación. _Nota: Define el tipo de todas las subcampañas hijas; en MVP solo se cambia mientras no exista ninguna subcampaña asociada._
- Fechas estimadas globales (opcional, solo futuras).

**Paso 2: Organizaciones asociadas**
- Selector múltiple del catálogo `ORGANIZACION`.
- Puede ser 1 o más, recomendado al menos 1.
- Botón "Crear nueva organización" si no existe.

**Paso 3: Revisión**
- Resumen (incluye tipo seleccionado).
- Botones: "Crear campaña vacía" (sin subcampañas) o "Crear campaña y agregar subcampaña" (continúa al wizard de subcampaña).

### 3.6. Crear / editar subcampaña (admin)

Wizard de varios pasos.

**Paso 1: Datos generales**
- Campaña padre (preseleccionada si viene del flujo anterior). _Nota: El tipo se hereda automáticamente de la campaña padre._
- Nombre de la subcampaña.
- Zona/comunidad (selector jerárquico del catálogo).
- Coordinador asignado (obligatorio).
- Fechas estimadas (solo futuras).

**Paso 2: Polígono**
- Componente de mapa para dibujar polígono (obligatorio para activar).
- Vista previa del polígono con área calculada automáticamente en hectáreas.
- **No hay input manual de área.**

**Paso 3: Meta y especies**
- Meta total de árboles.
- Plan de metas por especie: agregar especies del catálogo y asignar porcentaje objetivo.
- Cantidad objetivo calculada por especie según la meta total, editable solo para ajuste de redondeo.
- Validación visual: la suma de % debe cerrar en 100% para activar.
- Ejemplo visible: 1000 árboles = 20% Molle (200), 30% Jacarandá (300), 50% Queñua (500).

**Paso 4: Equipo (opcional al crear)**
- Selector múltiple de operarios para conformar el equipo.

**Paso 5: Revisión y activación**
- Resumen completo del borrador: datos generales, polígono con área, meta y plan por especie, equipo.
- La **asignación de lotes de vivero no se hace en este wizard**: una subcampaña en BORRADOR no acepta asignaciones. Primero se activa (o se guarda como borrador) y la asignación de stock ocurre después, en la pantalla de gestión de asignaciones (§3.10).
- Al activar sin stock aún asignado, el sistema lo permite y avisa: "Aún no hay stock asignado. Puedes activar y asignar lotes después." La cobertura de la meta (total y por especie) se muestra en la pantalla de asignaciones una vez activa.
- Botones: "Guardar como borrador" / "Activar subcampaña".

> Nota: la meta y el plan por especie (Paso 3) son la **planeación** y sí se definen aquí; la asignación de lotes es el **cumplimiento** posterior. Ver §2.13 de procesos.

### 3.7. Detalle de subcampaña (admin/coordinador)

**Componentes:**
- Cabecera con estado operativo + fase de mantenimiento (badges separados).
- Acciones según estado:
  - BORRADOR: "Editar", "Activar subcampaña", "Cancelar borrador" (pasa a CANCELADA, con confirmación + motivo).
  - ACTIVA: "Marcar como FINALIZADA_PARCIAL" (solo admin, con confirmación + motivo); "Cancelar subcampaña" **solo visible si aún no hay plantaciones** (pasa a CANCELADA).
  - COMPLETADA / FINALIZADA_PARCIAL: "Asignar más lotes para reposición".
  - CANCELADA: sin acciones (terminal); se muestra el motivo de cancelación.
- Tabs:
  - **Resumen:** progreso, mapa con pines, métricas clave, fechas clave (incluyendo `fecha_fin_mantenimiento`).
  - **Plantaciones:** listado con filtros (operario, fecha, especie, lote). Cada fila expandible con fotos, GPS, cantidades por especie y lote origen.
  - **Asignaciones:** tabla con propósito (PLANTACION_INICIAL / REPOSICION), cantidad asignada, consumida, devuelta, disponible. Botones "Asignar más", "Devolver al vivero".
  - **Mortandad y reposiciones:** registros con % supervivencia y semáforo.
  - **Equipo:** coordinador + operarios con aportes individuales. Botones "Agregar operario" / "Remover" (con confirmación).
  - **Historial:** timeline append-only completo.

### 3.8. Vista del operario (mobile-first, PWA)

#### 3.8.1. Home del operario
- Saludo + nombre.
- Tarjetas grandes de **subcampañas donde puede plantar**.
- Cada tarjeta: nombre subcampaña, nombre campaña padre (más pequeño), zona, % avance, stock disponible.
- Botón destacado: **"Registrar plantación"**.
- Accesos rápidos: "Reportar mortandad", "Registrar reposición", "Mi historial".

#### 3.8.2. Registrar plantación (flujo principal)

**Paso 1: Selección de subcampaña**
- Si entró desde la tarjeta, preseleccionada.

**Paso 2: Captura de fotos + GPS**
- Botón gigante para tomar foto.
- Permite varias fotos.
- GPS automático con indicador "GPS capturado ✓" o "Activando GPS...".

**Paso 3: Especies, cantidades y selección de lote**
- Lista de especies disponibles para la subcampaña (basadas en el plan de metas por especie).
- Para cada especie:
  - Input de cantidad con +/-.
  - Progreso visible de la especie: plantado / cantidad objetivo.
  - **Selector de lote de origen** (entre los asignados con propósito PLANTACION_INICIAL a esta subcampaña).
  - Si solo hay un lote disponible, se preselecciona.
  - Si hay varios, el operario indica cantidad por lote.
- Validación visual: stock disponible por lote.
- Si la cantidad excede la meta de esa especie: bloqueo claro y sugerencia de pedir ajuste del plan al coordinador/admin.

**Paso 4: Co-responsables (opcional)**
- "¿Plantaste con alguien más?"
- Selector múltiple del equipo de la subcampaña.

**Paso 5: Observaciones (opcional)**

**Paso 6: Confirmar**
- Resumen: subcampaña, cantidad total, especies, lotes, ubicación en mini-mapa, fotos.
- Botón "Registrar plantación".

#### 3.8.3. Reportar mortandad (mobile)
- Selector de subcampaña.
- Selector del **grupo de plantación** (lista de registros previos con foto, fecha, ubicación).
- Al seleccionar grupo: muestra histórico ("plantados: 50, muertos reportados previamente: 10, vivos estimados: 40").
- **Captura de foto + GPS obligatorios**.
- Input: "¿Cuántos más murieron?" (delta).
- Selector de causa.
- Observación opcional.
- Confirmar.

#### 3.8.4. Registrar reposición (mobile)
- Selector de subcampaña.
- Selector del grupo origen (debe tener mortandad reportada previamente).
- Muestra "puedes reponer hasta X árboles".
- Captura de foto + GPS.
- Selección de especies con cantidades.
- **Selección de lote** entre los asignados con propósito REPOSICION.
- Confirmar.
- Visual: badge "REPOSICIÓN" prominente.

#### 3.8.5. Mi historial
- Lista cronológica con filtros (hoy, esta semana, este mes).
- Por registro: subcampaña, hora, tipo (plantación / reposición / mortandad), cantidad, foto miniatura.
- Acumulado: "Esta semana: 87 árboles plantados, 5 repuestos, 12 muertos reportados".

### 3.9. Vista del coordinador

Combinación:
- Panel de sus subcampañas (filtrado).
- Vista del operario (porque también opera).
- Vista de equipo: desempeño individual de sus operarios.

### 3.10. Gestión de asignaciones (admin / coordinador)

**Objetivo:** mover árboles entre vivero y subcampañas.

**Componentes:**
- Tabla de asignaciones activas:
  - Subcampaña destino.
  - Lote de vivero origen.
  - Especie principal del lote.
  - **Propósito** (PLANTACION_INICIAL / REPOSICION).
  - Cantidad asignada.
  - Consumida.
  - Devuelta.
  - Disponible.
- Panel de cobertura por especie:
  - Meta por especie.
  - Stock inicial asignado por especie.
  - Plantado inicial por especie.
  - Estado: sin stock / parcial / cubierto / sobrecubierto.
- Acción "Asignar lotes a subcampaña":
  - Selector de subcampaña destino.
  - Listado de lotes con stock vivo disponible.
  - Por lote: cantidad absoluta + propósito.
  - El sistema impide propósito PLANTACION_INICIAL si la subcampaña ya está cerrada.
  - El sistema marca si la especie del lote no pertenece al plan de la subcampaña.
  - Confirmar.
- Acción "Devolver al vivero":
  - Solo sobre cantidad no consumida.
  - Motivo obligatorio.

### 3.11. Pantalla "marcar como FINALIZADA_PARCIAL" (solo admin)

- Solo accesible si la subcampaña está ACTIVA.
- Muestra el progreso actual ("Has plantado 700 de 1000 árboles, 70%").
- Advertencia clara: "Esta acción cierra la subcampaña antes de alcanzar la meta. Después solo podrás registrar mantenimiento (mortandad y reposiciones). No se puede deshacer ni reabrir. Si quieres continuar plantando, deberás crear una nueva subcampaña."
- Selector de motivo (catálogo + OTRO).
- Campo de observaciones.
- Confirmación con texto explícito.

---

## 4. Componentes recurrentes / patrones visuales

- **Barra de progreso de subcampaña:** muy presente, visual y atractiva. Plantados / meta y %.
- **Mini-barras de especies:** barras horizontales que muestran plantado inicial vs cantidad objetivo y composición viva actual.
- **Tarjetas de plantación:** miniatura de foto + cantidad + especie + lote origen + fecha + ubicación.
- **Mapa con polígonos y pines:** componente clave reutilizado en home pública, detalle, dashboard.
- **Timeline append-only:** lista vertical con icono por tipo de evento.
- **Badge de estado operativo:** ACTIVA, COMPLETADA, FINALIZADA_PARCIAL, BORRADOR, CANCELADA. Colores diferenciados.
- **Badge de fase de mantenimiento:** MANTENIMIENTO_ACTIVO (azul), MONITOREO_HISTORICO (gris). Visible solo cuando aplica.
- **Badge de tipo de subcampaña:** REFORESTACIÓN, ARBORIZACIÓN, FORESTACIÓN.
- **Badge de propósito de asignación:** PLANTACION_INICIAL (verde), REPOSICION (naranja).
- **Contador de mantenimiento:** "X meses restantes" en subcampañas cerradas.

---

## 5. Estados y feedback visual

### Estado operativo:
- **BORRADOR:** gris, acciones limitadas.
- **ACTIVA:** verde, todas las acciones operativas.
- **COMPLETADA:** azul, badge "META ALCANZADA", solo mantenimiento.
- **FINALIZADA_PARCIAL:** ámbar, badge "CERRADA PARCIALMENTE", solo mantenimiento.
- **CANCELADA:** gris oscuro/rojo tenue, badge "CANCELADA", sin acciones; muestra el motivo. Solo para subcampañas sin plantaciones.

### Fase de mantenimiento:
- **MANTENIMIENTO_ACTIVO:** badge azul con contador de tiempo restante.
- **MONITOREO_HISTORICO:** badge gris, sin alertas.

### Mortandad:
- Semáforo en % supervivencia: verde >85%, ámbar 70-85%, rojo <70%.

---

## 6. Consideraciones mobile

- Botones grandes, mínimo 48x48px touch target.
- Tipografía generosa para uso en exteriores.
- Alto contraste.
- Indicadores "guardando..." y "guardado ✓".
- Indicador de "sin conexión" (offline-first queda fuera del MVP pero el diseño puede anticiparlo).
- Selector de lote optimizado: si hay un solo lote disponible, preseleccionarlo.

---

## 7. Datos referenciales para mockups

**Campañas de ejemplo:**
- "Reforestación La Paz 2026" — organizaciones: Alcaldía La Paz + ONG VerdesAndinos.
  - Subcampaña: "Arborización Cota Cota" (1000 árboles, urbano).
  - Subcampaña: "Arborización San Miguel" (1000 árboles, urbano).
  - Subcampaña: "Arborización Hernán" (1000 árboles, urbano).
- "Reforestación Hampaturi 2026" — organizaciones: TIPNIS Foundation + Coca-Cola Bolivia.
  - Subcampaña: "Hampaturi Norte" (5000 árboles, nativo).

**Especies de ejemplo:**
- Jacarandá, Molle, Ceibo (urbano).
- Queñua, Kewiña, Aliso (nativo).

**Operarios de ejemplo:**
- Juan Mamani, Rosa Quispe, Carlos Apaza, Ana Condori.

**Coordinadores:**
- Ing. María López, Ing. Pedro Choque.

**Métricas de ejemplo:**
- "12,847 árboles plantados en total"
- "Captura estimada: 235 toneladas de CO₂ proyectadas"
- "5 subcampañas activas en 2 campañas"
- "92% de supervivencia promedio"
- "Hampaturi Norte: 18 meses restantes de mantenimiento activo"

---

## 8. Tono visual

- Colores: verdes naturales como primario, terracota o tierra como secundario, blancos amplios.
- Estética: limpia, moderna, transparencia y naturaleza.
- Inspiración: dashboards de proyectos de impacto, apps blockchain con foco en transparencia.

---

## 9. Pantallas prioritarias para los primeros mockups

Orden sugerido para validar primero:

1. **Home pública con mapa** (cara del proyecto).
2. **Detalle público de subcampaña** (drill-down del mapa).
3. **Vista mobile del operario — registrar plantación con selección de lote** (flujo más crítico operativamente y el más nuevo conceptualmente).
4. **Dashboard del administrador** (planificación y comando).
5. **Crear campaña + crear subcampaña** (wizards del admin).
6. **Detalle de subcampaña para admin/coordinador** (gestión diaria, incluye tabs).
7. **Reportar mortandad y reposición desde mobile.**
8. **Gestión de asignaciones vivero → subcampaña con propósito.**
9. **Pantalla "marcar como FINALIZADA_PARCIAL"** (acción delicada).
