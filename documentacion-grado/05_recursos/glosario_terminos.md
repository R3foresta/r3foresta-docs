# Glosario de términos comprometidos — Proyecto de Grado R3Foresta

> **Versión 6 — 25 de agosto de 2026**
> Este glosario no define todo el vocabulario del dominio. Define únicamente los términos que **comprometen una afirmación** ante el tribunal: los que, mal usados, prometen más de lo que el trabajo puede demostrar.
> Para cada término: qué significa aquí, qué obliga a sostener y qué **no** obliga a sostener.
> Fuente estratégica: [`../01_lineamientos/base_perfil_proyecto_grado.md`](../01_lineamientos/base_perfil_proyecto_grado.md) · Diseño de evaluación: [`../02_planificacion/estructura_perfil.md`](../02_planificacion/estructura_perfil.md)

---

## Criterio terminológico general

En las denominaciones propias se utilizarán las siguientes grafías y funciones:

- **R3Foresta:** institución y modelo socioambiental del caso de estudio;
- **R3Carbon:** componente institucional dedicado a captura de carbono, medición y trazabilidad;
- **R3foresta App:** nombre oficial de la aplicación tecnológica;
- **sistema de trazabilidad de material vegetal:** denominación académica y funcional de la solución evaluada.

El título seleccionado es **Sistema de trazabilidad del material vegetal para reforestación con proyección hacia bonos de carbono: caso R3Foresta**. La expresión **bonos de carbono** señala únicamente una proyección institucional futura. No permite denominar a R3foresta App como sistema de carbono ni atribuirle medición, MRV, validación, verificación, certificación o emisión de créditos.

No se utilizarán `APP R3Foresta`, `APPR3Foresta` ni _R3Foresta_ como nombre abreviado de la aplicación.

La primera explicación del dominio utiliza **semillas y plantas** para que el lector comprenda qué elementos atraviesan los procesos de Recolección, Vivero y Plantación. Una vez presentado ese recorrido, se adopta **material vegetal** como denominación general y delimitada para las semillas, plantas y demás unidades de propagación comprendidas en el proyecto.

**Material biológico** no debe utilizarse como término general fuera de los objetivos vigentes, que se conservan sin cambios hasta su revisión formal. **Árbol** se reserva para el contexto de una plantación o para la comunicación con patrocinadores; no sustituye a semilla, planta o material vegetal durante las etapas anteriores.

## 1. Trazabilidad reconstruible

**Definición adoptada**

> Capacidad de recomponer, a partir de registros relacionados, la procedencia, los movimientos, las cantidades, los responsables, las fechas, las ubicaciones y el destino del material vegetal.

La reconstrucción puede comenzar en el origen o en el punto donde el material vegetal ingresa al proceso. Describe lo que el sistema permite recuperar; no equivale a una certificación independiente de la verdad física declarada.

**Qué compromete**

| Compromiso | Cómo se sostiene |
|---|---|
| Cada cambio conserva el hecho que lo explica | Evento relacionado con el material, la cantidad, el momento y el responsable |
| El registro sirve a las decisiones de la propia operación | Los saldos y estados permiten operar y deben poder explicarse mediante eventos anteriores |
| Existe un responsable identificable por cada hecho | Historial con el actor asociado al evento correspondiente |

**Qué NO compromete**

- verificación por un tercero independiente;
- validez probatoria de la verdad física del material vegetal;
- calidad de dato conforme a una metodología de carbono o MRV;
- trazabilidad entre organizaciones distintas (interoperabilidad de cadena);
- que la totalidad del sistema esté desplegada y en uso.

**Primer uso definido:** [`../01_lineamientos/base_perfil_proyecto_grado.md`](../01_lineamientos/base_perfil_proyecto_grado.md) §1.1.

---

## 2. Términos proscritos

Expresiones que **no deben aparecer** aplicadas al sistema o a su trazabilidad, con el reemplazo correspondiente.

| Proscrito | Por qué | Usar en su lugar |
|---|---|---|
| **Trazabilidad verificable** | Puede interpretarse como una comprobación independiente por un tercero, que no forma parte del alcance. | Trazabilidad reconstruible con evidencia contrastable |
| **Trazabilidad auditable** | Sugiere aptitud para una auditoría formal conforme a un estándar. El trabajo evalúa recuperabilidad mediante un ejercicio propio, no una auditoría acreditada. | Trazabilidad reconstruible · recuperabilidad de trazas |
| **Trazabilidad certificada / certificable** | Certificación es un acto de un organismo acreditado. No aplica. | Trazabilidad reconstruible |
| **Demostrar que la semilla se convirtió en árbol vivo** | Afirma verdad física y supervivencia. El sistema registra lo declarado y evidenciado; no prueba la realidad ni el monitoreo posterior. | Reconstruir el recorrido registrado del material vegetal |
| **Garantiza** (aplicado a saldos o integridad) | Promesa absoluta, sin condiciones acotadas. | Preserva · asegura bajo las condiciones verificadas |
| **Genera / habilita bonos de carbono** | Requiere metodología, línea base, adicionalidad, medición y verificación independiente. Fuera de alcance. | Produce datos de actividad potencialmente reutilizables por un futuro MRV |
| **Event sourcing** (como compromiso del Perfil) | Anticipa un patrón arquitectónico que todavía debe evaluarse y justificarse durante el diseño. | Historial de eventos y saldos explicables; arquitectura por definir |
| **Blockchain / NFT / IPFS** como característica del proyecto | No participa de los objetivos ni de la evaluación vigente. | Fuera del alcance |

### 2.1. Uso legítimo de *verificable*

La palabra **sí es correcta** aplicada a proposiciones, invariantes y evidencia dentro del diseño de la verificación:

- *"invariantes formalizadas como **proposiciones verificables**"* — correcto: la proposición se puede someter a prueba;
- *"ítems respondidos con **evidencia contrastable**"* — formulación adoptada para indicar que existe una fuente vinculada que otra persona puede revisar.

Lo que se proscribe es *verificable* aplicado a **la trazabilidad o al sistema como un todo**, porque ahí sí significa "comprobable por un tercero independiente".

---

## 3. Cadena de custodia

**Definición adoptada:** secuencia de responsables, ubicaciones y transformaciones por las que atraviesa el material vegetal desde su origen o ingreso al proceso hasta el registro de su plantación, junto con las relaciones que permiten reconstruir esa secuencia.

**Qué compromete:** que cada cambio de etapa, responsable o ubicación quede registrado con origen, destino, cantidad, responsable y evidencia asociada.

**Qué NO compromete:** control físico continuo del material vegetal, ni imposibilidad de pérdida o sustitución fuera de los flujos registrados.

---

## 4. Conservación de saldos

**Definición adoptada:** propiedad por la cual, en cada transferencia entre etapas, la cantidad que sale de un origen y la que ingresa a un destino guardan correspondencia registrada, sin desapariciones ni duplicaciones no explicadas por un evento con causa y responsable.

**Precisión obligatoria:** no existe una igualdad homogénea única desde gramos de semilla hasta plantas registradas en una plantación. La conservación se verifica **dentro de cada unidad y etapa**, y el paso de unidades de propagación a plantas vivas es una **transformación biológica observada**, no una conversión aritmética de unidades. Esta salvedad debe aparecer cada vez que se enuncie la propiedad.

**Qué compromete:** ausencia de saldos negativos, de doble consumo y de estados parciales tras fallo, verificada experimentalmente.

**Qué NO compromete:** que el material vegetal no se pierda en el mundo real, ni que las cantidades declaradas por un operador sean ciertas.

---

## 5. Transferencia y transformación

### Transferencia

**Definición adoptada:** movimiento de material vegetal entre ubicaciones, responsables o etapas que conserva una relación directa entre la cantidad de origen y la cantidad de destino dentro de una misma unidad de medida.

### Transformación

**Definición adoptada:** hecho mediante el cual el material puede cambiar de estado, naturaleza, cantidad o unidad de medida y producir una nueva cantidad observable relacionada con el material de origen.

**Precisión obligatoria:** una transformación no se representa como una conversión aritmética automática. Por ejemplo, una masa de semillas sembradas y la cantidad de plantas germinadas son observaciones relacionadas por un evento biológico, no magnitudes matemáticamente equivalentes.

**Qué compromete:** que requerimientos, datos, eventos, reglas y pruebas puedan distinguir movimientos directos de cambios que generan material resultante.

**Qué NO compromete:** una fórmula universal de conversión ni una técnica particular para almacenar o ejecutar estas operaciones.

---

## 6. Historial de eventos y saldo explicable

**Definición adoptada:** capacidad transversal por la cual los hechos registrados en Recolección, Vivero y Plantación permiten explicar los cambios de estado, ubicación, cantidad y saldo del material vegetal.

El historial no es un cuarto módulo. Los módulos generan los eventos y la consulta del historial permite reconstruir posteriormente lo ocurrido.

**Qué compromete:** que los saldos actuales puedan relacionarse con los eventos anteriores que los produjeron y que una corrección no elimine la explicación del recorrido.

**Qué NO compromete:** *event sourcing*, almacenamiento *append-only*, transacciones ACID u otro mecanismo específico. Estas decisiones se justificarán durante el diseño y la implementación.

---

## 7. Recuperabilidad de trazas

**Definición adoptada:** proporción de ítems de una guía de reconstrucción que pueden responderse **con evidencia contrastable** —no solo de memoria— para un caso de la muestra, junto con el tiempo requerido para obtenerlos.

Es una métrica para comparar la situación actual con la propuesta. La distinción entre *respondido con evidencia* y *respondido de memoria* es constitutiva de la definición: la memoria ayuda a contextualizar, pero no es transferible entre personas ni puede contrastarse de la misma forma que una fuente conservada.

---

## 8. Variantes de ingreso

**Definición adoptada:** posibilidad de que el material vegetal ingrese al proceso en una etapa posterior a Recolección y quede vinculado con el módulo correspondiente sin perder su procedencia.

Esta posibilidad es una consecuencia del modelo de trazabilidad y no un flujo principal, un cuarto módulo ni un entregable independiente. Cuando ocurra, el registro debe conservar como mínimo el origen declarado, la especie, la cantidad, la fecha y la evidencia disponible.

No debe presentarse mediante recorridos de proveedores en el resumen, la introducción, el problema, la evaluación o el cronograma. Los detalles concretos se definirán como reglas del módulo donde se produzca el ingreso.

---

## 9. Regla de consistencia

Antes de cerrar cualquier documento del proyecto de grado, verificar que:

1. *trazabilidad reconstruible* y *evidencia contrastable* se utilicen de forma consistente;
2. no aparezca ningún término de la tabla §2 aplicado al sistema o a su trazabilidad;
3. *verificable* solo aparezca aplicado a proposiciones o invariantes; para registros se use *evidencia contrastable* (§2.1);
4. cada enunciado de conservación de saldos incluya la salvedad de unidad y etapa (§4);
5. blockchain, IPFS y NFT aparezcan únicamente para declarar que están fuera del alcance;
6. los ingresos de material vegetal adquirido o recibido de terceros se mantengan como variantes integradas y subordinadas al recorrido principal Recolección–Vivero–Plantación;
7. “semillas y plantas” se use para introducir el dominio y “material vegetal” como denominación general posterior;
8. los objetivos mantengan correspondencia con el problema, el alcance y la evaluación, y cualquier ajuste sustantivo se revise formalmente con la tutora;
9. transferencia y transformación se mantengan diferenciadas y no se use una equivalencia automática entre unidades distintas;
10. el historial de eventos se trate como capacidad transversal de los tres módulos;
11. la evidencia se describa como respaldo del registro y no como certificación del mundo físico;
12. el Perfil no comprometa mecanismos técnicos que deben definirse en análisis, diseño e implementación.

---

*Documento de trabajo actualizado el 19 de agosto de 2026.*
