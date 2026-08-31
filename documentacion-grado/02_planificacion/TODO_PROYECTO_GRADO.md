# TODO — ejecución del Proyecto de Grado

> **Fecha de apertura:** 19 de agosto de 2026.
> **Última decisión metodológica:** 31 de agosto de 2026.
> **Ventana académica:** 6 de julio–15 de noviembre de 2026.
> **Propósito:** controlar la ejecución de RUP adaptado, sus fases e iteraciones, los incrementos de los tres módulos, sus integraciones, la verificación, la validación, la entrega y el documento final.
>
> La metodología se consolidó documentalmente el 25 de agosto dentro de una ventana ya iniciada. Toda reconstrucción de actividades anteriores conservará su fecha real y sus fuentes; no se retrofecharán artefactos, commits, pruebas, resultados ni aprobaciones.

> La revisión y cierre específicos de los capítulos I y II se controlan en [`TODO_CAPITULOS_1_Y_2.md`](TODO_CAPITULOS_1_Y_2.md).

## 1. Decisiones vigentes

- [x] Adoptar como título **Sistema de trazabilidad del material vegetal para reforestación con proyección hacia bonos de carbono: caso R3Foresta**.
- [x] Mantener exactamente tres módulos: M1 Recolección, M2 Vivero y M3 Plantación.
- [x] Permitir que el recorrido académico se inicie en una recolección registrada o en el ingreso directo, en Vivero o Plantación, de material vegetal adquirido o recibido de terceros; esta variante permanece dentro de los tres módulos.
- [x] Mantener fuera del alcance monitoreo posterior, CO₂, MRV, certificación, emisión o comercialización de bonos de carbono, blockchain, NFT, contratos inteligentes e IPFS.
- [x] Adoptar **Rational Unified Process (RUP) adaptado** como metodología de desarrollo.
- [x] Complementar RUP con **Spec-Driven Development asistido por inteligencia artificial**.
- [x] Eliminar los sprints y organizar el trabajo mediante fases e iteraciones RUP, con incrementos ejecutables en Construcción.
- [x] Retirar ciencia del diseño, DSRM, estudio de caso único embebido, FEDS y demás componentes de metodología de investigación.
- [x] Tratar la verificación, la validación operativa y la aceptación como actividades de Ingeniería de Software.
- [x] Demostrar la construcción académica desde una referencia inicial del repositorio dentro de la ventana autorizada.
- [x] Conservar desarrollos anteriores únicamente como referencia técnica y factibilidad.

## 2. Productos y evidencia transversales

- [ ] Definir el repositorio, las ramas y el entorno de la referencia inicial académica.
- [ ] Crear y documentar la etiqueta o commit de referencia inicial.
- [ ] Preparar una base de datos reproducible mediante migraciones académicas.
- [ ] Registrar el inventario inicial de capacidades existentes y pendientes.
- [ ] Mantener el registro de riesgos con impacto, respuesta, responsable, estado y efecto sobre el plan.
- [ ] Mantener la lista priorizada de requisitos, defectos y tareas.
- [ ] Mantener la matriz principal:
  `necesidad → requisito → especificación → decisión de diseño → tarea → cambio → prueba → resultado → aceptación`.
- [ ] Mantener para las reglas críticas:
  `requisito → regla → invariante → mecanismo → prueba → resultado`.
- [ ] Asignar identificadores estables a objetivos, casos de uso, requisitos, reglas, especificaciones, decisiones, tareas, pruebas y actas.
- [ ] Definir para LCO, LCA, IOC y PR la evidencia mínima, las personas que revisan según su competencia, la decisión de salida y los riesgos o defectos residuales.
- [ ] Conservar por iteración, además del incremento cuando corresponda:
  - referencia de inicio y cierre;
  - especificaciones y criterios de aceptación;
  - plan técnico y tareas;
  - decisiones relevantes;
  - código y migraciones;
  - pruebas y resultados;
  - revisión de la iteración, demostración e integración;
  - defectos, desviaciones y acciones correctivas.
- [ ] Registrar por iteración `resultado o incremento → planificado → realizado → evidencia → desviación → decisión → riesgo residual → estado del hito`.
- [ ] Registrar horas académicas por fase, iteración, incremento y actividad transversal.
- [ ] Diferenciar siempre referencia técnica previa, construcción académica y estado desplegado.

## 3. Fase de Inicio — iteración IN-1 — 6 al 19 de julio

### 3.1. Alcance y actores

- [ ] Cerrar alcance, límites y relación con los cinco objetivos específicos.
- [ ] Confirmar responsables de Recolección, Vivero y Plantación.
- [ ] Identificar actores institucionales que priorizan o aceptan requisitos.
- [ ] Confirmar que el alcance operativo se inicia en una recolección registrada o en el ingreso directo de material adquirido o recibido de terceros en Vivero o Plantación, y concluye con el registro de la plantación.
- [ ] Confirmar que la trazabilidad, las consultas y las evidencias son capacidades transversales y no un cuarto módulo.

### 3.2. Productos de Inicio

- [ ] Cerrar la visión y el alcance del producto.
- [ ] Cerrar el glosario inicial.
- [ ] Preparar el modelo inicial de casos de uso.
- [ ] Preparar la lista priorizada de requisitos y riesgos.
- [ ] Preparar el plan de fases, iteraciones, incrementos, productos y criterios de salida.
- [ ] Establecer la referencia inicial académica.
- [ ] Revisar y cerrar el hito **LCO — Objetivos del ciclo de vida**.

## 4. Fase de Elaboración — iteración EL-1 — 20 de julio al 16 de agosto

### 4.1. Dominio y arquitectura

- [ ] Especificar entidades, eventos, estados, cantidades, unidades, saldos, responsables y evidencias.
- [ ] Diferenciar transferencia de transformación biológica u operativa.
- [ ] Definir invariantes de cantidad, disponibilidad, asignación y consumo.
- [ ] Diseñar la arquitectura base y el modelo de datos.
- [ ] Definir los contratos M1→M2 y M2→M3.
- [ ] Definir la procedencia y el historial del recorrido Recolección→Vivero→Plantación y de los ingresos externos en Vivero o Plantación.
- [ ] Preparar una línea vertical arquitectónica mínima M1→M2→M3 para comprobar identidad, procedencia, contratos, integridad e historial.

### 4.2. Especificaciones y riesgos

- [ ] Priorizar escenarios por valor, dependencia y riesgo.
- [ ] Especificar y probar anticipadamente saldo no negativo, transferencia consistente, asignación coherente y ausencia de estados parciales.
- [ ] Establecer los criterios de aceptación para cada incremento.
- [ ] Actualizar el plan y el registro de riesgos.
- [ ] Revisar y cerrar el hito **LCA — Arquitectura del ciclo de vida**.

## 5. Fase de Construcción

Cada capacidad priorizada dentro de una iteración seguirá el flujo:

`seleccionar → especificar → clarificar → planificar → descomponer → implementar → integrar → probar → demostrar → actualizar`.

### 5.1. Iteración CO-1 e incremento 1 — M1 Recolección — 17 de agosto al 6 de septiembre

- [ ] Especificar casos de uso, reglas, excepciones y criterios de aceptación de M1.
- [ ] Diseñar datos, interfaz, servicios, migraciones y pruebas de M1.
- [ ] Implementar actividades, lotes, especies, cantidades, unidades, responsables, ubicación y evidencia.
- [ ] Implementar cierre o entrega del lote hacia Vivero.
- [ ] Verificar procedencia, cantidades, estados e historial de M1.
- [ ] Demostrar M1 y registrar los resultados del incremento.

### 5.2. Iteración CO-2 e incremento 2 — M2 Vivero e integración M1→M2 — 7 al 27 de septiembre

- [ ] Especificar la recepción desde Recolección y el ingreso de material externo.
- [ ] Especificar transformaciones observadas, mermas, descartes, saldo vivo, asignaciones, despachos, devoluciones y cierre.
- [ ] Diseñar e implementar M2 y el contrato M1→M2.
- [ ] Registrar para ingresos externos procedencia, especie, cantidad, unidad, fecha, responsable y evidencia disponible.
- [ ] Verificar transferencia consistente, transformación observada, merma y saldo.
- [ ] Ejecutar regresión de M1 e integración M1→M2.
- [ ] Demostrar el incremento integrado y registrar resultados.

### 5.3. Iteración CO-3 e incremento 3 — M3 Plantación e integración M2→M3 — 28 de septiembre al 18 de octubre

- [ ] Especificar asignación, recepción, plantación, devolución, descarte, ubicación y evidencia.
- [ ] Especificar el ingreso externo directo en Plantación y su procedencia.
- [ ] Diseñar e implementar M3 y el contrato M2→M3.
- [ ] Verificar cantidad recibida, plantada, devuelta o descartada.
- [ ] Verificar rechazo de consumo o asignación superior al disponible y de duplicados concurrentes.
- [ ] Ejecutar regresión de M1 y M2 e integración M2→M3.
- [ ] Demostrar los tres módulos integrados y registrar resultados.

### 5.4. Iteración CO-4 e incremento 4 — Trazabilidad transversal y versión candidata — 19 de octubre al 1 de noviembre

- [ ] Especificar la consulta y reconstrucción de una traza completa M1→M2→M3.
- [ ] Implementar la recuperación de procedencia, eventos, cantidades, responsables, ubicaciones, evidencias y destino.
- [ ] Completar consultas y reportes estrictamente necesarios para la reconstrucción.
- [ ] Ejecutar pruebas de integración y regresión de los tres módulos.
- [ ] Corregir deuda técnica crítica de seguridad, configuración y reproducibilidad.
- [ ] Congelar código, migraciones, configuración y datos de la versión candidata.
- [ ] Revisar y cerrar el hito **IOC — Capacidad operativa inicial**.

## 6. Fase de Transición — iteración TR-1 — 2 al 15 de noviembre

### 6.1. Verificación y validación — 2 al 8 de noviembre

- [ ] Ejecutar la matriz de pruebas funcionales, integración, regresión, concurrencia y fallos críticos.
- [ ] Ejecutar escenarios de aceptación para:
  - recorrido propio M1→M2→M3;
  - ingreso externo en Vivero;
  - ingreso externo directo en Plantación;
  - transferencia parcial;
  - transformación observada;
  - merma o descarte;
  - devolución;
  - intento de consumo superior al saldo;
  - reconstrucción completa con evidencia.
- [ ] Identificar claramente si cada escenario utiliza una operación real disponible o datos controlados.
- [ ] Registrar resultado esperado, resultado observado, defectos y decisión de aceptación.
- [ ] Corregir defectos de la versión candidata y repetir las pruebas afectadas.

### 6.2. Despliegue, aceptación y cierre — 9 al 15 de noviembre

- [ ] Preparar y comprobar migraciones, secretos, configuración y datos iniciales.
- [ ] Desplegar la versión final en el entorno autorizado.
- [ ] Preparar manual técnico, manual de usuario y guía de operación.
- [ ] Obtener el registro de aceptación o de observaciones pendientes.
- [ ] Cerrar el registro de riesgos, cambios y defectos.
- [ ] Etiquetar la liberación final.
- [ ] Revisar y cerrar el hito **PR — Liberación del producto**.

## 7. Controles técnicos mínimos

- [ ] Derivar identidad desde credenciales validadas y eliminar confianza productiva en identificadores no autenticados.
- [ ] Proteger o retirar endpoints privilegiados y de diagnóstico fuera del alcance.
- [ ] Eliminar sesiones o datos mock del flujo productivo entregado.
- [ ] Exigir configuración segura de secretos.
- [ ] Reconstruir la base académica desde cero mediante migraciones.
- [ ] Alinear contratos, especificaciones e implementación.
- [ ] Incorporar pruebas frontend mínimas para los recorridos de aceptación.
- [ ] Confirmar que componentes históricos excluidos no intervienen en el flujo académico.

## 8. Spec-Driven Development y asistencia de IA

### 8.1. Productos SDD

- [ ] Mantener una especificación canónica por incremento o conjunto coherente de casos de uso.
- [ ] Incluir actores, precondiciones, flujo principal, alternativas, reglas, invariantes y criterios de aceptación.
- [ ] Mantener el plan técnico sincronizado con arquitectura, datos, interfaces, migraciones y pruebas.
- [ ] Mantener tareas identificables y vinculadas con la especificación y el plan.
- [ ] Actualizar especificaciones y decisiones cuando cambie el comportamiento implementado.
- [ ] Utilizar los productos SDD para materializar requisitos, diseño detallado y planificación de capacidades, sin duplicarlos.
- [ ] Conservar por separado los productos RUP transversales cuya finalidad no cubra SDD: visión, arquitectura, riesgos, configuración, revisión de iteraciones, hitos y despliegue.

### 8.2. Control de IA

- [ ] Registrar para cada aporte material: fecha, herramienta y modelo o versión disponible, tarea, artefacto afectado, salida adoptada, modificada o rechazada, revisión humana, prueba y referencia al cambio o evidencia.
- [ ] Revisar todo cambio generado o modificado por IA antes de aceptarlo.
- [ ] No permitir que un agente apruebe requisitos, reglas, arquitectura crítica, pruebas, incrementos o despliegues.
- [ ] No proporcionar datos personales, sensibles o institucionales no autorizados a los agentes.
- [ ] No atribuir a la IA decisiones que requieran conocimiento del contexto organizacional.
- [ ] Mantener al postulante como único responsable académico de los resultados.

## 9. Coherencia documental

- [x] Propagar RUP, SDD asistido por IA, fases, iteraciones, incrementos e hitos al Perfil, Capítulo I y Capítulo II.
- [ ] Aplicar la misma estructura al Marco aplicativo cuando se redacte el Capítulo III.
- [x] Mantener exactamente tres módulos y las integraciones M1→M2 y M2→M3.
- [x] Mantener trazabilidad, consultas, historial y evidencias como capacidades transversales.
- [x] Sustituir toda referencia activa a sprint por fase, iteración o incremento, según corresponda.
- [x] Sustituir la matriz DSR por la matriz de trazabilidad de desarrollo.
- [x] Retirar de documentos activos ciencia del diseño, DSRM, estudio de caso único embebido y FEDS.
- [x] Diferenciar verificación, validación operativa y aceptación.
- [x] Mantener el límite respecto de carbono y de los componentes tecnológicos excluidos.
- [ ] Aplicar los [`criterios editoriales`](../01_lineamientos/criterios_editoriales_proyecto_grado.md) antes de cerrar cada sección.

## 10. Documento final y defensa

- [ ] Integrar las versiones aprobadas de los capítulos I y II.
- [ ] Desarrollar el Capítulo III por fases e iteraciones RUP, mostrando especificaciones, diseño, incrementos, integraciones, pruebas y resultados.
- [ ] Relacionar cada objetivo con productos y evidencia verificable.
- [ ] Redactar conclusiones que respondan a cada objetivo sin generalizaciones no respaldadas.
- [ ] Redactar recomendaciones separadas de los resultados.
- [ ] Cerrar referencias y anexos.
- [ ] Redactar resumen y palabras clave cuando el documento completo esté estabilizado.
- [ ] Preparar la versión para revisión, maquetación y defensa.

---

*Tablero reestructurado el 25 de agosto de 2026 conforme a la selección definitiva de RUP.*
