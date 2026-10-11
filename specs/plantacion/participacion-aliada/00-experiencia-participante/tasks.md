# Tareas — PA-S00

Revisión humana de producto registrada el 11 de octubre; implementación y pruebas pendientes. Estos IDs no renumeran PA-T01–21 ni PA-T-INT01–08.

| ID | Entrega | Depende de | Criterio de finalización |
|---|---|---|---|
| PA-T-ENT01 | Revisión de producto realizada: PA-S00 favorable; PA-DI08/10 confirmadas y PA-DI09 orientada. US07/CA13–15 explicitan las aclaraciones recibidas. | Confirmación humana del 11 de octubre. | [Acta](../revision-humana-2026-10-11.md) con decisiones y pendientes; no marca boceto, implementación o pruebas como terminados. |
| PA-T-ENT02 | Matriz de identidad/permisos/endpoints y usuarios internos existentes. | ENT01 para alcance. | Cada lectura/escritura clasificada; alta/perfil/rutas legadas incluidas; transición propuesta sin cambios productivos. |
| PA-T-ENT03 | Boceto de entrada con datos simulados: sin permiso, una/múltiples subcampañas, acceso retirado e interno. | Criterios de ENT01; puede prepararse mientras avanza ENT02. | Usuario reconoce qué puede hacer y cómo llegar a registrar; sin pasos de organización obligatorios. |
| PA-T-ENT04-BE | Implementar contrato de sesión/capacidades, alta/perfil seguros y controles de API del recorrido. | ENT02 + plan técnico aprobado; coordinar PA-T-INT02. | CA01/03–09 verificados por HTTP, sin confiar en identidad o rol enviados por cliente. |
| PA-T-ENT04-DB | Preparar migraciones/privilegios y ensayo de transición de personas. | ENT02 + diseño PA-DI01/02/09. | Ensayo repetible, auditoría y regresión de facultades internas; sin cambiar asignaciones físicas. |
| PA-T-ENT05-FE | Integrar landing/layout/menús/rutas y contexto del actor; reutilizar selector y formulario. | Contrato ENT04-BE estable; integración tras BE/DB. | CA02–05/07–12 con pruebas de pantalla, recarga, enlaces y cambio de cuenta. |
| PA-T-ENT06-QA | Verificación integrada de entrada, permisos y regresión interna. | ENT04-BE/DB y ENT05-FE. | Cuenta sin asignación no opera; habilitada opera solo en su ámbito; personal interno conserva facultades; evidencia enlazada a versiones. |

La preparación de documentos no marca como hechas tareas de implementación. Incorporar visitante sin sesión, intento de registrar sin autenticación/permiso, consulta tras expirar sesión y perfil sin wallet/documento (CA13–15) a ENT03/04-BE/05-FE/06-QA. La habilitación del piloto exige también PA-S01–04.

Incorporar CA16/17 a ENT03/05-FE/06-QA: bocetar y comprobar dos experiencias diferenciadas, Impacto compartido entre visitante y plantador, y estructura/entradas/herramientas internas conservadas. ENT04-BE verifica que profundizar o autenticarse no entrega datos internos sin facultades. No crear un tercer portal ni una copia del modelo de Plantación.

Incorporar CA18/19 y las decisiones posteriores de PA-S02 a ENT03/05-FE/06-QA: última campaña habilitada o global sin anterior utilizable, cambio de campaña/global y acciones rápidas de registrar/consultar registros propios. Verificar recuerdo por cuenta y error de capacidades distinto de permiso ausente; ninguna preferencia sustituye autorización. ENT04-BE coordina los contratos de historial personal y afiliación histórica con PA-S02/01; documentos actualizados no equivalen a implementación.
