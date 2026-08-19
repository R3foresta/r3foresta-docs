# Criterios editoriales para la documentación del Proyecto de Grado

> **Versión 1 — 19 de agosto de 2026.**
> Este lineamiento se aplica a las secciones y documentos que se redacten después del Perfil. Registra criterios editoriales y metodológicos; no modifica el contenido aprobado del Perfil de Proyecto de Grado.

## 1. Principio rector

La documentación debe priorizar la precisión conceptual y la claridad. Ser técnicamente preciso no significa utilizar el lenguaje más especializado posible, sino emplear únicamente el nivel de especialización necesario para expresar una idea sin ambigüedad.

El texto se dirige principalmente a lectores de la carrera de Informática, pero debe poder comprenderse sin obligarlos a interpretar jerga innecesaria de ingeniería, investigación o gestión.

Antes de introducir una expresión especializada se preguntará:

> ¿Este término mejora realmente la precisión o solamente hace que el texto parezca más técnico?

Si no mejora la precisión, se escribirá la idea directamente en lenguaje académico sencillo.

## 2. Uso de términos técnicos

Se conservarán los términos que representen conceptos necesarios y que se utilicen de forma consistente en varias partes del proyecto. Entre ellos pueden encontrarse:

- trazabilidad;
- cadena de custodia;
- evento;
- integridad;
- invariante de consistencia;
- transferencia;
- transformación;
- saldo;
- procedencia.

Un término que aparezca una sola vez y necesite una explicación extensa deberá sustituirse, cuando sea posible, por una formulación directa de la idea que representa.

No se introducirán expresiones en inglés cuando exista una alternativa clara en español. Se preferirán las siguientes formulaciones:

| Evitar en la redacción habitual | Preferir |
|---|---|
| AS-IS | situación o práctica actual de R3Foresta |
| TO-BE | solución propuesta |
| baseline | referencia inicial o situación de comparación |
| workflow | flujo |
| tracking | seguimiento |
| audit trail | historial de registros o eventos |

Los términos en inglés reconocidos por la literatura podrán aparecer en el marco teórico cuando sean necesarios, estén sustentados por una fuente y se expliquen en su contexto. No se trasladarán como jerga al resto de la documentación.

## 3. Separación entre propiedad, mecanismo y prueba

Cada decisión deberá distinguir tres capas:

| Capa | Pregunta que responde | Ejemplo |
|---|---|---|
| Propiedad deseada | ¿Qué debe permitir o preservar el sistema? | Impedir que se asigne una cantidad superior al saldo disponible. |
| Mecanismo de implementación | ¿Cómo se consigue técnicamente? | Aplicar una restricción, función de base de datos, transacción o control de concurrencia seleccionado durante el diseño. |
| Forma de evaluación | ¿Cómo se comprobará? | Intentar una asignación superior al saldo y comprobar que sea rechazada sin alterar la información existente. |

Las propiedades deberán declararse antes que los mecanismos. Una solución técnica concreta solo se incorporará cuando exista análisis suficiente para justificarla. Las pruebas deberán comprobar la propiedad comprometida y no limitarse a confirmar que se utilizó un mecanismo determinado.

## 4. Nivel de detalle según el documento

| Documento o etapa | Contenido que corresponde |
|---|---|
| Perfil | Problema, objetivos, alcance, propiedades esperadas, criterios de evaluación, límites y conceptos necesarios para comprender la propuesta. |
| Requerimientos | Comportamientos, reglas, invariantes, entradas, salidas y excepciones. |
| Análisis y diseño | Entidades, relaciones, eventos, flujos, arquitectura y mecanismos de consistencia justificados. |
| Implementación | Tecnologías, algoritmos, estructuras, transacciones y decisiones técnicas concretas. |
| Pruebas | Casos, escenarios, datos, resultados esperados y técnicas utilizadas. |
| Evaluación y resultados | Evidencia observada, comparación, resultados positivos, negativos o mixtos y limitaciones. |

No se trasladará automáticamente el nivel de detalle de un documento técnico hacia una sección académica temprana.

## 5. Ubicación y repetición de las explicaciones

Una idea importante deberá conservarse, pero ubicarse en la sección que cumpla la función adecuada. Por ejemplo, la diferencia detallada entre transferencia y transformación puede desarrollarse en el marco teórico, el análisis del dominio, los requerimientos o el modelo de eventos, sin sobrecargar el alcance.

Cuando una propiedad ya esté establecida, las secciones posteriores deberán aportar su perspectiva específica en lugar de repetir la explicación completa. Por ejemplo:

- el alcance puede declarar que se asociará evidencia con los eventos;
- las limitaciones pueden aclarar que esa evidencia no certifica por sí sola el hecho físico;
- las pruebas pueden indicar cómo se comprobará que la asociación sea recuperable.

## 6. Afirmaciones observables y resultados abiertos

Los objetivos, requerimientos y criterios de evaluación utilizarán verbos que puedan relacionarse con evidencia, como analizar, diseñar, implementar, verificar, evaluar, reconstruir, comparar, registrar y relacionar.

Se evitarán compromisos como “optimizar”, “garantizar completamente”, “mejorar significativamente” o “asegurar totalmente” cuando todavía no exista una medida y una forma de demostrarlos.

La metodología no anticipará resultados favorables. La evaluación deberá admitir resultados positivos, negativos o mixtos. Por ejemplo, podrá encontrarse que el registro estructurado exige más esfuerzo inicial y, al mismo tiempo, reduce el esfuerzo de reconstrucción posterior. Ambos resultados deberán informarse si la evidencia los respalda.

## 7. Representación informática y realidad física

El sistema conserva una representación informática de hechos declarados u observados en el mundo real. Puede:

- relacionar eventos;
- conservar evidencia asociada;
- controlar cantidades y saldos;
- impedir inconsistencias lógicas;
- reconstruir la información registrada.

No puede afirmar automáticamente que una declaración corresponde exactamente con la realidad física. Por ello, no se utilizarán expresiones como certificación, prueba absoluta, verdad o garantía física cuando el resultado disponible sea consistencia, procedencia, evidencia asociada o reconstrucción de registros.

## 8. Revisión antes de cerrar una sección

Antes de aprobar una nueva sección o documento se comprobará:

1. ¿Puede entenderse sin conocer jerga específica de gestión o metodología?
2. ¿Cada término técnico utilizado aporta precisión?
3. ¿Se distingue la propiedad deseada del mecanismo y de la prueba?
4. ¿La explicación se encuentra en la sección que le corresponde?
5. ¿Puede decirse lo mismo de forma más sencilla sin perder rigor?
6. ¿La redacción evita prometer resultados todavía no demostrados?
7. ¿Los términos coinciden con los lineamientos y documentos anteriores?
8. ¿Cada afirmación relevante puede relacionarse con el problema, un objetivo o una forma de evaluación?
9. ¿Se evitó repetir explicaciones completas ya establecidas?
10. ¿Se mantiene la diferencia entre el registro informático y la realidad física?

Si una respuesta es negativa, la sección deberá corregirse o justificar explícitamente la excepción antes de cerrarse.

## 9. Regla resumida

> La complejidad debe encontrarse en el problema y en la solución informática, no en una forma innecesariamente complicada de explicarlos.

---

*Criterio editorial registrado el 19 de agosto de 2026 para la documentación posterior al Perfil.*
