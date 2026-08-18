# Glosario de términos comprometidos — Proyecto de Grado R3Foresta

> **Versión 2 — 17 de agosto de 2026**
> Este glosario no define todo el vocabulario del dominio. Define únicamente los términos que **comprometen una afirmación** ante el tribunal: los que, mal usados, prometen más de lo que el trabajo puede demostrar.
> Para cada término: qué significa aquí, qué obliga a sostener y qué **no** obliga a sostener.
> Fuente estratégica: [`../01_lineamientos/base_perfil_proyecto_grado.md`](../01_lineamientos/base_perfil_proyecto_grado.md) · Diseño de evaluación: [`../02_planificacion/estructura_perfil.md`](../02_planificacion/estructura_perfil.md)

---

## 1. Trazabilidad reconstruible

**Definición adoptada**

> Capacidad de recomponer, a partir de registros relacionados, la procedencia, los movimientos, las cantidades, los responsables, las fechas, las ubicaciones y el destino del material biológico.

La reconstrucción puede comenzar en una recolección propia o en una recepción externa. Describe lo que el sistema permite recuperar; no equivale a una certificación independiente de la verdad física declarada.

**Qué compromete**

| Compromiso | Cómo se sostiene |
|---|---|
| El dato se captura en el hecho, no se reconstruye después | Evidencia fotográfica, GPS, marca temporal y responsable registrados en el momento de la operación (M1) |
| El registro sirve a las decisiones de la propia operación | `saldo_vivo_actual`, `saldo_asignado_disponible` y estados de lote existen para operar, no solo para reportar |
| Existe un responsable identificable por cada hecho | Historial *append-only* con usuario en `recoleccion_historial` y `evento_lote_vivero` |

**Qué NO compromete**

- verificación por un tercero independiente;
- validez probatoria de la verdad física del material;
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
| **Demostrar que la semilla se convirtió en árbol vivo** | Afirma verdad física y supervivencia. El sistema registra lo declarado y evidenciado; no prueba la realidad ni el monitoreo posterior. | Reconstruir el recorrido registrado del material |
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

**Definición adoptada:** secuencia de responsables, ubicaciones y transformaciones por las que atraviesa el material biológico desde su recolección propia o recepción externa hasta su plantación, junto con el registro que permite reconstruir esa secuencia.

**Qué compromete:** que cada cambio de etapa, responsable o ubicación quede registrado con origen, destino, cantidad, responsable y evidencia asociada.

**Qué NO compromete:** control físico continuo del material, ni imposibilidad de pérdida o sustitución fuera de los flujos registrados.

---

## 4. Conservación de saldos

**Definición adoptada:** propiedad por la cual, en cada transferencia entre etapas, la cantidad que sale de un origen y la que ingresa a un destino guardan correspondencia registrada, sin desapariciones ni duplicaciones no explicadas por un evento con causa y responsable.

**Precisión obligatoria:** no existe una igualdad homogénea única desde gramos de semilla hasta árboles plantados. La conservación se verifica **dentro de cada unidad y etapa**, y el paso de material de propagación a plantas vivas es una **transformación biológica observada**, no una conversión aritmética de unidades. Esta salvedad debe aparecer cada vez que se enuncie la propiedad.

**Qué compromete:** ausencia de saldos negativos, de doble consumo y de estados parciales tras fallo, verificada experimentalmente.

**Qué NO compromete:** que el material físico no se pierda en el mundo real, ni que las cantidades declaradas por un operador sean ciertas.

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

## 8. Recepción externa

**Definición adoptada:** flujo de ingreso de plantines adquiridos a un proveedor y registrados desde el momento en que R3Foresta asume su custodia. No constituye un cuarto módulo.

**Datos mínimos preliminares:** proveedor u origen declarado, especie, cantidad, fecha y fotografía. Un recibo o factura se adjunta cuando exista, pero es opcional.

**Recorridos previstos:** ingreso a Vivero para adaptación o ingreso directo a Plantación.

---

## 9. Regla de consistencia

Antes de cerrar cualquier documento del proyecto de grado, verificar que:

1. *trazabilidad reconstruible* y *evidencia contrastable* se utilicen de forma consistente;
2. no aparezca ningún término de la tabla §2 aplicado al sistema o a su trazabilidad;
3. *verificable* solo aparezca aplicado a proposiciones o invariantes; para registros se use *evidencia contrastable* (§2.1);
4. cada enunciado de conservación de saldos incluya la salvedad de unidad y etapa (§4);
5. blockchain, IPFS y NFT aparezcan únicamente para declarar que están fuera del alcance;
6. la recepción externa se trate como flujo de ingreso hacia Vivero o Plantación y no como cuarto módulo.

---

*Documento de trabajo actualizado el 17 de agosto de 2026.*
