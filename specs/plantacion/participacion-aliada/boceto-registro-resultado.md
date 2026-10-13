# Boceto de baja fidelidad — registro y resultado

Datos simulados: Carlos (Scouts), subcampaña Palca Norte. Actualización propuesta del 10 de octubre: reutilizar los tres pasos actuales con fecha/observaciones en el segundo. No es diseño visual final ni contrato aprobado de interfaz. La afiliación da contexto, no permiso. Para la cuenta nueva y navegación previa, revisar [PA-S00](00-experiencia-participante/spec.md).

```text
MI PARTICIPACIÓN / PALCA NORTE               [Registrar plantación]
Contexto: campaña Bosque 2026 · permiso: PLANTADOR

1. EVIDENCIA Y UBICACIÓN
   GPS [capturar ubicación / indicar manualmente]
   Fotos [subir 1–10]
   [Continuar]

2. CANTIDADES, PERSONAS Y FECHA
   Especie             A registrar       Disponibles para plantar
   Queñua                [ 30 ]                      70
   Meta orientativa: 80 · Plantadas antes de este registro: 30
   Si se guarda: 60 plantadas · 40 disponibles (sujeto a validación)
   Responsable: Carlos (tu cuenta)
   Otras personas participantes [Ana] [revisar lista]
   Fecha [10/10/2026]   Observaciones [................]
   [Atrás] [Revisar resumen]

3. REVISAR ANTES DE CONFIRMAR
   Campaña: Bosque 2026 · Subcampaña: Palca Norte
   Responsable: Carlos · Fecha: 10/10/2026 · ubicación · fotos
   Queñua: 30 · Total: 30 · Otras personas participantes: Ana
   [Corregir] [Confirmar y guardar]

   Estado al pulsar: Guardando…
   Si el servidor confirma rechazo: No se guardó. [Revisar datos]
   Si la respuesta es incierta: Estamos verificando si se guardó.
   [Comprobar guardado] consulta/recupera el MISMO intento.
   Sin conexión: conservamos el intento; no enviar uno nuevo a ciegas.

RESULTADO
   ✓ Plantación guardada
   Registro: [código devuelto por servidor] · 30 plantines de Queñua
   Palca Norte · Responsable: Carlos · Otras personas: Ana
   [Ver detalle] [Volver a mi participación]
```

Propuestas a revisar: ubicación del acceso rápido, lenguaje de cantidades, responsable separado de otras personas, navegación de salida y texto exacto de resultado incierto. La consulta por mapa no es paso obligatorio. Las cantidades proyectadas son ayuda; backend confirma disponibilidad real al guardar. Superar la meta no bloquea si hay stock elegible y se cumplen las otras reglas.

La recuperación de intento y el enlace a detalle son comportamientos por implementar/verificar, no capacidades acreditadas por este boceto. Un rechazo por permiso retirado no ofrece reintentar otra escritura sin recuperarlo; permite salir y conservar el borrador según contrato.
