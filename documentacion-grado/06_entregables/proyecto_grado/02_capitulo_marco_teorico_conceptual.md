# Capítulo II — Marco teórico y conceptual

> **Estado:** estructura inicial autorizada para desarrollo progresivo. Este capítulo deberá sustentar las decisiones del proyecto; no será un catálogo de tecnologías ni una repetición de los antecedentes o de la metodología.

## Función y límite del capítulo

El Marco teórico y conceptual desarrollará los conceptos del dominio y de Ingeniería de Software necesarios para comprender, diseñar y evaluar el artefacto. La investigación aplicada, la ciencia del diseño, DSRM, el caso único embebido, el enfoque mixto, el desarrollo iterativo e incremental y el seguimiento por sprints se explicarán en el Diseño metodológico del Capítulo I. En este capítulo se desarrollarán las bases conceptuales que esos métodos utilizan para formular requisitos, diseñar propiedades y evaluar resultados.

## 2.1. Material vegetal y procesos de reforestación

### 2.1.1. Material reproductivo forestal y procedencia

Definir el material vegetal considerado y la relevancia de conservar la información de origen disponible.

### 2.1.2. Etapas de recolección, vivero y plantación

Describir conceptualmente las etapas que producen cambios de estado, ubicación, responsable, agrupación o unidad de medida.

### 2.1.3. Transformación biológica observada

Explicar por qué el paso de semillas o unidades de propagación a plantas no es una conversión aritmética automática y debe registrarse como un resultado observado.

## 2.2. Trazabilidad y cadena de custodia

### 2.2.1. Definición y propósito de la trazabilidad

Comparar las definiciones pertinentes y adoptar una definición operativa para R3Foresta.

### 2.2.2. Trazabilidad interna y trazabilidad entre etapas

Explicar la diferencia y justificar la necesidad de relaciones que atraviesen Recolección, Vivero y Plantación.

### 2.2.3. Cadena de custodia

Desarrollar procedencia, transferencias, responsabilidad y límites de las declaraciones registradas.

### 2.2.4. Unidad trazable y granularidad

Definir lote, unidad de material, división, agrupación y criterios de identificación.

## 2.3. Eventos, transformaciones y procedencia

### 2.3.1. Evento de trazabilidad

Definir el hecho registrado y sus atributos mínimos: qué ocurrió, sobre qué entidad, cuándo, dónde, quién intervino y qué evidencia se asoció.

### 2.3.2. Transferencias y transformaciones

Distinguir el cambio de custodia o ubicación de la generación de una entidad resultante a partir de otra.

### 2.3.3. Relaciones de entrada y salida

Explicar cómo las relaciones entre entidades y eventos permiten reconstruir ramificaciones, agrupaciones y genealogías.

### 2.3.4. Procedencia, actividades y responsables

Desarrollar la relación entre entidades, actividades y agentes sin afirmar que el registro informático demuestra por sí mismo la verdad física.

## 2.4. Integridad de cantidades y saldos

### 2.4.1. Cantidades, unidades de medida y saldos

Definir cantidad registrada, saldo vivo, saldo disponible, cantidad reservada, merma, descarte, devolución y consumo.

### 2.4.2. Conciliación cuantitativa y doble contabilización

Explicar los principios aplicables para evitar consumos o asignaciones superiores a lo disponible y para conservar la explicación de cada cambio.

### 2.4.3. Invariantes de consistencia

Definir las propiedades que deben mantenerse antes y después de cada operación crítica.

### 2.4.4. Atomicidad y consistencia transaccional

Explicar por qué una transferencia o transformación crítica debe completarse como una unidad lógica, sin adelantar todavía el mecanismo concreto de implementación.

### 2.4.5. Diseño por contrato y trazabilidad de requerimientos

Desarrollar cómo precondiciones, poscondiciones e invariantes permiten expresar obligaciones observables de una operación y cómo la trazabilidad de requerimientos relaciona esas obligaciones con reglas, decisiones, componentes y pruebas. Mantener separadas la propiedad deseada, el mecanismo elegido y la forma de comprobarla.

## 2.5. Evidencia e información geográfica

### 2.5.1. Evidencia asociada con eventos

Definir la función de fotografías, documentos, fecha, responsable y ubicación como elementos vinculados con un registro.

### 2.5.2. Información geográfica

Desarrollar coordenadas, puntos, polígonos y criterios básicos de validez espacial pertinentes al registro de plantación.

### 2.5.3. Límites probatorios

Distinguir consistencia y recuperabilidad de la información de certificación, autenticidad forense o comprobación absoluta del hecho físico.

## 2.6. Reconstrucción y evaluación de la trazabilidad

### 2.6.1. Reconstrucción de una traza

Definir qué significa recuperar el origen, los eventos, las cantidades, los responsables, la ubicación, las pérdidas y el destino de una unidad trazable.

### 2.6.2. Completitud, coherencia y tiempo de recuperación

Definir dimensiones observables para comparar la práctica actual y la solución propuesta.

### 2.6.3. Carga operativa

Definir el esfuerzo de registro y recuperación sin suponer anticipadamente que el sistema lo reducirá.

### 2.6.4. Calidad del producto software pertinente al caso

Desarrollar únicamente las características de calidad que se utilizarán para evaluar la solución, como adecuación funcional, fiabilidad, capacidad de interacción, seguridad y mantenibilidad. Explicar cómo cada característica se convertirá en criterios observables sin presentar ISO/IEC 25010 como una certificación del sistema.

## 2.7. Bonos de carbono y alcance de la proyección

### 2.7.1. Bonos o créditos de carbono

Definir el término incorporado al título mediante fuentes de programas o estándares reconocidos, diferenciándolo de la sola existencia de registros de plantación.

### 2.7.2. Relación indirecta con la trazabilidad operativa

Explicar qué datos de procedencia y actividad podría aportar el sistema a un proceso futuro y por qué no sustituyen una metodología de carbono, cuantificación de reducciones o remociones, monitoreo, validación, verificación ni emisión de créditos.

## 2.8. Síntesis conceptual adoptada por R3Foresta

Cerrar el capítulo con:

1. las definiciones operativas adoptadas;
2. las relaciones entre unidad trazable, evento, transferencia, transformación, saldo, responsable y evidencia;
3. las propiedades que el diseño deberá preservar;
4. los límites de lo que la solución puede afirmar.

Esta síntesis servirá como puente hacia el marco metodológico y el desarrollo de la solución.

## Correspondencia entre método y fundamento conceptual

| Componente metodológico | Fundamento que debe desarrollarse en este capítulo | Uso posterior |
|---|---|---|
| Ciencia del diseño y objetivos del artefacto | Trazabilidad, cadena de custodia, eventos, procedencia, integridad y evidencia | Derivar requisitos y justificar el modelo propuesto |
| Caso único embebido | Unidad trazable y reconstrucción de una traza | Delimitar y analizar las unidades embebidas |
| Desarrollo iterativo e incremental | Reglas, invariantes, contratos y calidad del software | Definir el contenido verificable de cada incremento |
| Verificación técnica | Cantidades, saldos, atomicidad, consistencia y trazabilidad de requerimientos | Diseñar la matriz de pruebas críticas |
| Evaluación operativa | Completitud, coherencia, evidencia recuperable, tiempo y carga | Construir los instrumentos de situación actual y piloto |

La metodología explica **cómo** se investigará y construirá; este capítulo explica **qué conceptos y relaciones** hacen posible diseñar y evaluar el artefacto. El Marco aplicativo mostrará después **cómo se materializaron** esas decisiones en el sistema.

## Fuentes prioritarias para la redacción

La selección y las advertencias de uso se encuentran en:

- `03_investigacion/biblioteca_fuentes_trazabilidad_eventos_integridad.md`;
- `05_recursos/indice_fuentes_bibliograficas.md`;
- sección 7 del Perfil de Proyecto de Grado;
- documentación oficial del programa de acreditación seleccionado para delimitar bonos de carbono y su relación con el alcance.
