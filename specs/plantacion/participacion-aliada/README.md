# PA-F01 — Participación aliada en Plantación

**Actualización:** 10 de octubre de 2026. **Estado:** cinco specs en borrador para revisión; LCO cerrado, Elaboración autorizada. No acredita implementación ni salida a campo.

## Propósito

Una persona se registra, encuentra una experiencia enfocada de impacto y, cuando está autorizada en una subcampaña, registra una plantación real y reconoce el resultado guardado. No necesita conocer Recolección, Vivero o administración interna. Afiliación y organización no conceden permiso.

La propuesta conserva un único modelo de Plantación, una experiencia participante y las herramientas internas de quienes tienen facultades para usarlas. El usuario pidió desarrollar y organizar las specs; las decisiones técnicas y cada comportamiento detallado siguen su revisión propia.

## Empieza aquí: orden de revisión

| Orden | Spec | Pregunta que vas a resolver | Estado |
|---|---|---|---|
| 1 | [PA-S00 — Entrada y experiencia del participante](00-experiencia-participante/spec.md) | ¿Qué encuentra alguien recién registrado, sin permisos o involucrado en una sola campaña? | Borrador nuevo; prioridad P0. |
| 2 | [PA-S02 — Consulta de impacto y registros](02-consulta-impacto-y-registros/spec.md) | ¿Qué información ve cada audiencia y hasta qué detalle? | Borrador; visibilidad por cerrar. |
| 3 | [PA-S03 — Gestión de acceso por subcampaña](03-gestion-acceso-subcampania/spec.md) | ¿Quién habilita a quién, dónde y qué ocurre al retirar acceso? | Borrador; adaptación técnica pendiente. |
| 4 | [PA-S01 — Registro inicial](01-registro-plantacion-inicial/spec.md) | ¿Cómo registra una vez, revisa y confirma que quedó guardado? | Borrador apoyado en formulario existente. |
| 5 | [PA-S04 — Corrección excepcional](04-correccion-excepcional/spec.md) | ¿Cómo se resuelve un error real después de guardar? | Borrador; mecanismo y verificación antes de campo. |

Los números de carpeta existentes se conservan para no romper IDs o referencias; no son un orden obligatorio de implementación. El backend de permisos es una dependencia temprana del registro aunque la pantalla de gestión llegue después.

## Qué revisar en cada carpeta

- **`spec.md`:** historias de usuario, reglas, estados y ejemplos de aceptación. Primero revisamos si describen lo que debe pasar.
- **`plan.md`:** cómo se reparte entre UX, frontend, backend y base de datos, qué reutilizar y qué decisión falta antes del código afectado.
- **`tasks.md`:** entregas pequeñas con dependencias y evidencia de terminación. No se marcan implementadas por haber escrito el documento.

Al revisar una spec, registrar nombre del revisor, fecha, criterios aceptados, cambios solicitados y decisiones pendientes. Aprobar el comportamiento permite preparar su implementación cuando el plan técnico correspondiente esté resuelto. No hace falta aprobar todas las specs de una vez; tampoco iniciar código con una dependencia crítica indefinida.

| Spec | Revisión humana de esta versión | Decisiones principales pendientes |
|---|---|---|
| PA-S00 | Pendiente | PA-DI08: consulta común o asignada; PA-DI09: alta/roles; PA-DI10: perfil mínimo. |
| PA-S02 | Pendiente | PA-DI05/08: audiencias, campos y lectura propia. |
| PA-S03 | Pendiente | PA-DI01/02/03: permisos, transición legada y autoridad central técnica. |
| PA-S01 | Pendiente | PA-DI04/06: GPS/participantes y guardado recuperable. |
| PA-S04 | Pendiente | PA-DI07: casos, mecanismo y efectos de corrección. |

## Documentos compartidos

- [Plan inicial y siguiente entrega](plan-inicial.md): orden, razones, dependencias y condiciones de campo.
- [Diseño compartido de frontend, backend y datos](diseno-tecnico-compartido.md): distribución de trabajo, contratos, tablas reutilizadas/candidatas y cómo preparar migraciones.
- [Plan de reutilización e integración](plan-reutilizacion-integracion.md): evidencia del código existente, archivos concretos, PA-DI01–07 y tareas de integración.
- [Boceto de registro y resultado](boceto-registro-resultado.md): propuesta de tres pasos con datos simulados; no diseño visual final.
- [Diagramas](diagramas/README.md): contexto, casos de uso, actividades, modelo conceptual y dependencias. La incorporación de PA-S00 requiere una siguiente alineación de vistas, indicada en su índice.

No se abren carpetas por cada botón ni se duplican specs en «frontend» y «backend». Cada capacidad conserva su resultado completo y su plan explica la división técnica.

## Fuentes y trazabilidad

- [Ficha LCO](../../../03-plantacion-module/06-LCO_registro_plantacion_organizacion.md)
- [ADR-PLA-03](../../../decisiones/02_decisiones_plantacion.md#adr-pla-03--autorizacion-operativa-por-persona-y-subcampana-para-participacion-aliada)
- [Handoff vigente](../../../03-plantacion-module/05_handoff_registro_plantacion_inicial.md)
- [Reglas de Plantación](../../../03-plantacion-module/01_reglas_de_negocio_plantacion.md)
- [Contrato Vivero → Plantación](../../../90-contratos-integracion/02_contrato_vivero_a_plantacion.md)
- [Migración local 053, antecedente](../../../database/migrations/053_m3_registrar_plantacion_sin_despacho.sql); la definición local posterior de registro es 061 en backend, con metas orientativas y cierre explícito según ADR-PLA-04. Plan/meta: ADR-PLA-05 y 062/063.
- [Diagramas y dependencias de implementación](diagramas/README.md)

La revisión de fuentes locales es contraste documental; no prueba producción ni resuelve los permisos nuevos.
