# Guía de consulta para agentes

Repositorio de documentación de R3Foresta. Trabajar en español y conservar IDs de requisitos, specs, tareas y decisiones.

## Lectura mínima

1. `README.md`: mapa del repositorio.
2. `ESTADO.md`: implementación acreditada, entorno y pendientes.
3. Para Participación aliada, `specs/plantacion/participacion-aliada/README.md` y su `implementacion/README.md`.
4. Leer la ficha de entrega, las specs y las secciones del contrato que esa ficha referencia antes de implementar.

## Fuentes y actualización

- Los módulos y ADR conservan reglas e invariantes del dominio. `CLAUDE.md` reúne convenciones adicionales; ignorar los archivos `.excalidraw`.
- `spec.md` define el comportamiento y los criterios de aceptación; `plan.md` distribuye responsabilidades; `tasks.md` desglosa trabajo por capacidad. Las entregas INT agrupan tareas de varias specs: no son funcionalidades independientes.
- El tablero `implementacion/README.md` mantiene el orden y avance de PA-F01. Actualizar la fila y las tareas afectadas al cerrar una entrega; enlazar su evidencia desde `ESTADO.md`.
- Aprobación de diseño, código, pruebas, aplicación SQL, publicación Git y despliegue son hechos distintos. Registrar versión y entorno; un cierre parcial no completa la spec ni su tarea padre.
- `archivo/` conserva actas, planes anteriores y evidencia fechada. Las actas siguen acreditando decisiones; los planes anteriores no definen el siguiente trabajo. Consultarlos cuando una referencia concreta lo requiera.
- Si una ruta antigua de PA-F01 ya no existe, buscar el mismo nombre de archivo dentro de `specs/plantacion/participacion-aliada/archivo/`; su índice registra los traslados.
- D01–D12 están aceptadas. Mantener sus decisiones y los límites pendientes de PA-S04; no volver a presentar acuerdos aceptados como preguntas abiertas.
- Al mover documentos, actualizar enlaces relativos y referencias de rutas. Archivar el contenido previo antes de sustituir estados extensos. Mantener accesibles los pendientes aún sin resolver.

Aplicar Pareto: una entrada, un tablero de ejecución y enlaces a detalle. Evitar otro plan general o copias del contrato por cada chat. Un encargo de organización documental se completa aquí; la implementación de aplicación continúa en sus repositorios cuando corresponda al encargo.
