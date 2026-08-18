# Lineamiento estratégico del Perfil de Proyecto de Grado

> **Versión 5 — 18 de agosto de 2026.**
> Este lineamiento fija las decisiones que deben mantenerse coherentes en toda la documentación académica. El texto entregable vive en [PERFIL_PROYECTO_GRADO.md](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md).

## 1. Enfoque del proyecto

R3Foresta tiene como objetivo organizacional de largo plazo fortalecer la confianza y explorar mecanismos de financiamiento ambiental. El Proyecto de Grado no intenta resolver ese objetivo completo. Se concentra en una capa anterior y necesaria: registrar y reconstruir la cadena de custodia del material biológico utilizado para reforestación.

El resultado académico es un sistema de trazabilidad con evidencia contrastable. No es una certificación de plantación, supervivencia, captura de carbono ni crédito de carbono.

### Vocabulario adoptado

- **Trazabilidad:** posibilidad de recuperar información relacionada con un objeto a lo largo de su recorrido.
- **Cadena de custodia:** relaciones de procedencia, transferencia y responsabilidad sobre el material.
- **Trazabilidad reconstruible:** capacidad de recomponer una traza desde registros relacionados.
- **Evidencia contrastable:** fotografías, datos temporales, geográficos o documentales vinculados con el hecho al que respaldan.
- **Invariante:** condición de consistencia que debe preservarse antes y después de una operación.

No calificar los registros como “certificados”, “certificables”, “auditables” o “verificables”. El término “verificación” se reserva para requerimientos e invariantes sometidos a pruebas.

## 2. Título propuesto

> **Sistema de trazabilidad de material biológico para reforestación: caso R3Foresta**

El título es deliberadamente simple y no anticipa la arquitectura. Está pendiente de aprobación de la tutora, Ph.D. Marisol Téllez Ramírez.

No incluir en el título eventos, contratos atómicos, blockchain, NFT, IPFS, bonos de carbono ni MRV.

## 3. Problema

La práctica actual conserva fotografías, mensajes, redes sociales, cuadernos y memoria de los responsables, pero no una estructura común para vincular procedencia, manejo, cantidades, responsables, evidencia y plantación.

El material puede provenir de:

- recolección propia;
- adquisición de plantines externos.

La adquisición externa admite dos recorridos:

1. proveedor → vivero para adaptación → asignación → plantación;
2. proveedor → plantación directa.

La falta de relaciones comunes limita la reconstrucción de la cadena, la consistencia de saldos y la información presentada a patrocinadores y aliados.

## 4. Objetivos vigentes

### Objetivo general

Desarrollar y evaluar un sistema de trazabilidad para la cadena de custodia del material biológico utilizado por R3Foresta, desde su recolección o recepción externa hasta su manejo en vivero y plantación, que permita reconstruir con evidencia contrastable su procedencia, movimientos, cantidades, responsables y destino.

### Objetivos específicos

1. **Analizar** procesos, actores, datos, estados, eventos, unidades, requerimientos y reglas.
2. **Diseñar** el modelo de trazabilidad, integridad, invariantes y transferencias.
3. **Implementar** Recolección, Vivero y Plantación, incorporando la recepción externa como flujo.
4. **Verificar** requerimientos e invariantes mediante pruebas.
5. **Evaluar** capacidad de reconstrucción y carga operativa mediante línea base y piloto.

Cada objetivo mantiene un verbo rector y produce una sección principal de resultados.

## 5. Alcance funcional

### Incluido

- M1 Recolección;
- M2 Vivero;
- M3 Plantación;
- recepción externa como flujo transversal de ingreso;
- proveedor/origen, especie, cantidad, fecha y fotografía como datos mínimos preliminares;
- comprobante opcional;
- genealogía de lotes y asignaciones;
- eventos e historial;
- saldos materializados;
- transacciones y control de concurrencia;
- evidencia fotográfica, temporal y geográfica;
- ajustes de interfaz necesarios para el piloto;
- pruebas unitarias, de integración, concurrencia, fallo y E2E;
- comparación AS-IS/TO-BE.

### Excluido

- créditos de carbono y certificaciones;
- cuantificación de biomasa o CO₂;
- adicionalidad, permanencia y línea base de carbono;
- monitoreo ecológico de largo plazo;
- garantía de supervivencia;
- blockchain, NFT, contratos inteligentes e IPFS;
- autenticidad forense de evidencia;
- despliegue nacional;
- cuarto módulo de compras.

## 6. Aporte de ingeniería

El aporte no es el número de pantallas. Se encuentra en la combinación de:

- modelo de genealogía y procedencia;
- hechos operativos registrados como eventos;
- saldos derivados y disponibles para la operación;
- contratos de integración atómicos;
- invariantes de cantidad y consumo;
- control de concurrencia;
- evidencia vinculada con su hecho;
- trazabilidad desde requerimiento y regla hasta prueba.

La solución es un modelo transaccional basado en eventos con saldos materializados. No se presenta como *event sourcing* estricto.

## 7. Metodología

### Investigación

- aplicada y tecnológica;
- ciencia del diseño;
- estudio de caso único en R3Foresta;
- enfoque mixto descriptivo;
- sin generalización estadística.

### Desarrollo

- ejecución formal prospectiva del 17 de agosto al 15 de noviembre de 2026;
- iterativo e incremental organizado en ocho sprints;
- especificaciones, reglas y decisiones versionadas;
- desarrollo y cierre formal de Recolección, Vivero y Plantación;
- integración M1→M2 y M2→M3;
- recepción externa con sus dos recorridos;
- integración transversal, calidad, piloto y documentación final;
- prototipos previos tratados como insumos, no como objetivos académicos cumplidos.

### Autoría y asistencia

Pablo Andrés Fernández Cari es el autor académico y responsable principal del trabajo. La colaboración externa fue puntual y se delimitará en el documento final. Los agentes de IA Claude Code y Codex apoyarán la descomposición de tareas, implementación, revisión, pruebas y redacción. Toda salida será revisada y validada por el postulante; las decisiones del dominio y la responsabilidad son humanas.

## 8. Diseño de evaluación

### Línea base AS-IS

- 8 a 12 actividades o recorridos históricos;
- inventario de fuentes;
- reconstrucción primero con documentos y luego con memoria;
- registro de fuente, completitud y tiempo.

Los casos históricos no deben llamarse “eventos de software”.

### Piloto TO-BE

- actividad real coordinada con R3Foresta;
- hasta cinco usuarios;
- mismo instrumento AS-IS/TO-BE;
- reconstrucción por una persona distinta de quien capturó cuando sea posible;
- rutas no observadas tratadas como casos controlados.

### Métricas

- requerimientos e invariantes cumplidos;
- saldos negativos, doble consumo y estados parciales;
- completitud de genealogía;
- proporción de ítems con evidencia;
- tiempo de reconstrucción;
- tiempo y acciones de captura;
- reintentos y dificultades percibidas.

## 9. Justificación

- **Técnica:** integridad de operaciones y transferencias bajo concurrencia y fallos.
- **Operativa:** disponibilidad, pérdidas, asignaciones y responsables reconstruibles.
- **Comercial:** información más consistente para patrocinadores y aliados.
- **Académica:** vínculo entre análisis, diseño, implementación, verificación y evaluación.
- **Económica:** infraestructura de bajo costo y medición del tiempo antes de afirmar ahorro.
- **Social y ambiental:** mejor rendición de cuentas sin atribuir éxito ecológico al software.

## 10. Cronograma rector

- Sprint 0, 17–23 de agosto: perfil, backlog, arquitectura, criterios de terminado y levantamiento AS-IS;
- Sprint 1, 24 de agosto–6 de septiembre: Recolección;
- Sprint 2, 7–20 de septiembre: Vivero e integración M1→M2;
- Sprint 3, 21 de septiembre–4 de octubre: Plantación e integración M2→M3;
- Sprint 4, 5–18 de octubre: recepción externa y genealogía completa;
- Sprint 5, 19 de octubre–1 de noviembre: integración, calidad y despliegue;
- Sprint 6, 2–8 de noviembre: piloto y evaluación;
- Sprint 7, 9–15 de noviembre: documento y entrega final.

## 11. Recursos

- agentes de IA mediante una suscripción alternada entre Claude Code y Codex: USD 80 por 4 meses;
- transporte, alimentación, datos e Internet: Bs 1.060–1.360;
- Supabase, Vercel, Render, GitHub y subdominio: planes gratuitos;
- equipos y horas: aporte en especie;
- financiamiento monetario: 100 % del postulante;
- gastos exploratorios previos a agosto: no imputados al presupuesto formal.

## 12. Reglas de consistencia documental

Antes de cerrar cualquier versión:

1. problema, pregunta y objetivo general deben referirse a origen propio y externo;
2. deben conservarse exactamente tres módulos;
3. la recepción externa debe aparecer como flujo;
4. no deben reaparecer blockchain o créditos de carbono dentro del alcance;
5. AS-IS debe significar casos históricos y TO-BE el piloto;
6. no se deben prometer mejoras, ahorros o certificaciones antes de medirlos;
7. deben diferenciarse validación de software y validación de campo;
8. debe mantenerse la declaración transparente de autoría y asistencia;
9. presupuesto y cronograma deben coincidir con el perfil oficial;
10. los prototipos previos deben describirse como insumos y no como objetivos ya cumplidos;
11. los ocho sprints deben contener los tres módulos, ambas integraciones, recepción externa, calidad, piloto y cierre;
12. los agentes de IA deben aparecer como apoyo bajo validación humana;
13. cualquier cambio académico acordado con la docente o la tutora debe propagarse al perfil, estructura y TODO.

---

*Lineamiento actualizado el 18 de agosto de 2026.*
