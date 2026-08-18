# Glosario de términos comprometidos — Proyecto de Grado R3Foresta

> **Versión 3 — 18 de agosto de 2026**
> Este glosario no define todo el vocabulario del dominio. Define únicamente los términos que **comprometen una afirmación** ante el tribunal: los que, mal usados, prometen más de lo que el trabajo puede demostrar.
> Para cada término: qué significa aquí, qué obliga a sostener y qué **no** obliga a sostener.
> Fuente estratégica: [`../01_lineamientos/base_perfil_proyecto_grado.md`](../01_lineamientos/base_perfil_proyecto_grado.md) · Diseño de evaluación: [`../02_planificacion/estructura_perfil.md`](../02_planificacion/estructura_perfil.md)

---

## Criterio terminológico general

La primera explicación del dominio utiliza **semillas y plantas** para que el lector comprenda qué elementos atraviesan los procesos de Recolección, Vivero y Plantación. Una vez presentado ese recorrido, se adopta **material vegetal** como denominación general y delimitada para las semillas, plantas y demás unidades de propagación comprendidas en el proyecto.

**Material biológico** no debe utilizarse como término general fuera de los objetivos vigentes, que se conservan sin cambios hasta su revisión formal. **Árbol** se reserva para el contexto de una plantación o para la comunicación con patrocinadores; no sustituye a semilla, planta o material vegetal durante las etapas anteriores.

## 1. Trazabilidad reconstruible

**Definición adoptada**

> Capacidad de recomponer, a partir de registros relacionados, la procedencia, los movimientos, las cantidades, los responsables, las fechas, las ubicaciones y el destino del material vegetal.

La reconstrucción puede comenzar en el origen o en el punto donde el material vegetal ingresa al proceso. Describe lo que el sistema permite recuperar; no equivale a una certificación independiente de la verdad física declarada.

**Qué compromete**

| Compromiso | Cómo se sostiene |
|---|---|
| El dato se captura en el hecho, no se reconstruye después | Evidencia fotográfica, GPS, marca temporal y responsable registrados en el momento de la operación (M1) |
| El registro sirve a las decisiones de la propia operación | `saldo_vivo_actual`, `saldo_asignado_disponible` y estados de lote existen para operar, no solo para reportar |
| Existe un responsable identificable por cada hecho | Historial *append-only* con usuario en `recoleccion_historial` y `evento_lote_vivero` |

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
| **Event sourcing** (a secas) | El modelo mantiene simultáneamente eventos y saldos materializados; no es *event sourcing* estricto. | Modelo transaccional híbrido basado en eventos y saldos materializados |
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

## 5. Contrato de integración atómico

**Definición adoptada:** especificación de una transferencia entre módulos cuyos efectos —creación de la entidad destino, descuento en el origen, registro del evento y actualización de saldos— se agrupan en una sola transacción, de modo que si una parte falla se revierte la operación completa.

**Qué compromete:** ausencia de estados parciales tras fallo inducido, demostrada con pruebas y con el contrafactual de atomicidad.

**Qué NO compromete:** disponibilidad del servicio, ni corrección del dato ingresado por el usuario.

---

## 6. Modelo transaccional híbrido basado en eventos

**Definición adoptada:** modelo que conserva un historial *append-only* de eventos de negocio y, simultáneamente, mantiene saldos y acumulados materializados para operación y consulta.

**Por qué esta denominación:** evita la confusión con *event sourcing* estricto, donde el estado se deriva íntegramente de la reproducción de eventos y no se persiste. Aquí sí se persiste, por razones operativas y de rendimiento de consulta.

**Qué compromete:** que los eventos no se editen ni se borren, y que los saldos materializados sean consistentes con el historial.

**Qué NO compromete:** capacidad de reconstruir cualquier estado histórico arbitrario por reproducción pura de eventos.

---

## 7. Recuperabilidad de trazas

**Definición adoptada:** proporción de ítems de una guía de reconstrucción que pueden responderse **con evidencia contrastable** —no solo de memoria— para un caso de la muestra, junto con el tiempo requerido para obtenerlos.

Es la métrica comparable AS-IS / TO-BE del plano operativo. La distinción entre *respondido con evidencia* y *respondido de memoria* es constitutiva de la definición: la memoria ayuda a contextualizar, pero no es transferible entre personas ni puede contrastarse de la misma forma que una fuente conservada.

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
6. las variantes de ingreso se mantengan implícitas y subordinadas al recorrido principal Recolección–Vivero–Plantación;
7. “semillas y plantas” se use para introducir el dominio y “material vegetal” como denominación general posterior;
8. los objetivos vigentes permanezcan sin cambios hasta su revisión formal.

---

*Documento de trabajo actualizado el 18 de agosto de 2026.*
