# Tareas — PA-S00

Todas pendientes de revisión/ejecución. Estos IDs no renumeran PA-T01–21 ni PA-T-INT01–08.

| ID | Entrega | Depende de | Criterio de finalización |
|---|---|---|---|
| PA-T-ENT01 | Revisar US01–06, navegación y decisiones PA-DI08/09/10. | Spec y responsables humanos. | Decisiones, revisor y fecha registrados; pendientes técnicos explícitos. |
| PA-T-ENT02 | Matriz de identidad/permisos/endpoints y usuarios internos existentes. | ENT01 para alcance. | Cada lectura/escritura clasificada; alta/perfil/rutas legadas incluidas; transición propuesta sin cambios productivos. |
| PA-T-ENT03 | Boceto de entrada con datos simulados: sin permiso, una/múltiples subcampañas, acceso retirado e interno. | Criterios de ENT01; puede prepararse mientras avanza ENT02. | Usuario reconoce qué puede hacer y cómo llegar a registrar; sin pasos de organización obligatorios. |
| PA-T-ENT04-BE | Implementar contrato de sesión/capacidades, alta/perfil seguros y controles de API del recorrido. | ENT02 + plan técnico aprobado; coordinar PA-T-INT02. | CA01/03–09 verificados por HTTP, sin confiar en identidad o rol enviados por cliente. |
| PA-T-ENT04-DB | Preparar migraciones/privilegios y ensayo de transición de personas. | ENT02 + diseño PA-DI01/02/09. | Ensayo repetible, auditoría y regresión de facultades internas; sin cambiar asignaciones físicas. |
| PA-T-ENT05-FE | Integrar landing/layout/menús/rutas y contexto del actor; reutilizar selector y formulario. | Contrato ENT04-BE estable; integración tras BE/DB. | CA02–05/07–12 con pruebas de pantalla, recarga, enlaces y cambio de cuenta. |
| PA-T-ENT06-QA | Verificación integrada de entrada, permisos y regresión interna. | ENT04-BE/DB y ENT05-FE. | Cuenta sin asignación no opera; habilitada opera solo en su ámbito; personal interno conserva facultades; evidencia enlazada a versiones. |

La preparación de documentos no marca como hechas las tareas de implementación. La aceptación humana de PA-S00 se registra al revisar el comportamiento; la habilitación del piloto exige también PA-S01–04.
