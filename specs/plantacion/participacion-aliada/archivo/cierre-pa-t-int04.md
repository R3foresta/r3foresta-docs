# Cierre técnico local de PA-T-INT04

**Registro:** 17 de octubre de 2026. **Alcance:** FE01–FE08 implementadas y verificadas localmente después de INT02-D. **Commit de código PWA:** `94f62a91831fd35cc7b89f62d05f31ad1762caca`. **Backend integrado:** entrega D `75a57eb05e57b3048908cccc04aa14fc24ae8629`. Ambos commits son locales; push, aplicación SQL y despliegue son hechos separados.

El [encargo y sus ocho tareas completadas](pa-t-int04.md#tareas-para-frontend) se conservan completos, con el corte previo a los commits. La [entrada compatible](../implementacion/pa-t-int04.md) apunta a este cierre. El [informe PWA](../../../../../pwa-r3foresta/docs/QA_REGISTRO_PARTICIPANTE_INT04.md) y sus [versiones/huellas](../../../../../pwa-r3foresta/docs/qa/pa-int04/versiones.json) conservan las revisiones originales de prueba y los commits de entrega posteriores; no se atribuyen pruebas nuevas a cambios documentales.

## Resultado y evidencia

Entrada contextual por cuenta, formulario de tres pasos, GPS/manual, fotos recuperables, confirmación con payload inmutable, comprobante y detalle propio entregados sobre v1. La identidad se persiste antes de preparación/PUT; timeout mantiene comando/contenido y no crea otro consumo. Aislamiento entre cuentas y exclusión entre pestañas reutilizan las primitivas de INT06. Se retiró contexto/FIFO legado y se adaptó el cliente interno de reposición.

| Capa | Resultado acreditado |
|---|---|
| Unitarios/componentes | 39 suites / 553 pruebas aprobadas, incluidas regresiones de INT06. |
| Estático/producción | Lint y build aprobados, incluidos TypeScript/Vite/SW. |
| Navegador → API → datos | 60 comprobaciones: 30 registro/recuperación, 18 reposición y 12 fotos adversarias. Chromium, PostgreSQL/PostGIS y objetos privados sintéticos. |
| Persistencia | Tres confirmaciones con un registro, consumo y vínculo por intención; dos rechazos sin efectos parciales. Respuesta perdida recupera el mismo resultado. |
| Revisión de cierre | Fuentes y artefactos cotejados; persistencia antes de red, preparación terminal, descarte incierto, cuentas/pestañas y permisos revisados sin hallazgos bloqueantes. |

Se usó perfil sintético de arranque ligado al mismo Bearer que la API verifica; no se acredita una ceremonia WebAuthn real. Las pruebas con servicios simulados no sustituyen el recorrido integrado identificado.

## Pendientes y continuación

**Siguiente implementación: [INT05 — Impacto público y Mis registros](../implementacion/pa-t-int05.md)**, primero contratos/proyecciones backend y después frontend. INT04 entrega detalle propio y registro; no completa la consulta pública, lista histórica ni sus enlaces compartidos.

La revisión humana de UX de INT04/INT06 puede avanzar en paralelo. Continúan pendientes WebAuthn del recorrido nuevo, cotejo/aplicación remotos 077–080, Storage/URLs/CDN históricos, transición real B/C, corte/drenaje/habilitación de escritura, entorno externo, publicación/despliegue y piloto. 074–076 se mantienen aplicadas en desarrollo `vyrjlehkhabydkhjxagx` según confirmación de Pablo, sin repetirlas por falta de cotejo posterior.

INT06 conserva FE06 parcial; cerrar INT04 no cierra todo el hilo frontend ni PA-S00/01/03, las tareas padre de QA, INT02 o PA-F01. INT07 mantiene sus casos propios de PA-S04 e INT08 su QA/corte/piloto.
