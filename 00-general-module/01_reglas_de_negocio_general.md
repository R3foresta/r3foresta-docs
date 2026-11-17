# Reglas de Negocio (RN) - Modulo General

## 1. Proposito

Estas reglas definen el comportamiento base de los catalogos y entidades maestras que usan los demas modulos del sistema.

Buscan garantizar:

* consistencia transversal,
* trazabilidad historica,
* reutilizacion de catalogos,
* y una sola fuente viva para entidades maestras.

---

## 2. Definiciones base

* **Entidad maestra:** registro transversal reutilizable por varios modulos.
* **Fuente viva:** tabla actual desde la que el sistema selecciona un dato hoy.
* **Snapshot:** dato congelado en una entidad operativa para proteger el historial.
* **Inactivacion:** salida de uso futuro sin borrar el historial previo.
* **Territorio:** estructura administrativa o comunitaria asociada a una ubicacion o a un snapshot.

---

## 3. Reglas de usuarios

### RN-GEN-01 - Todo registro operativo tiene actor responsable

Toda accion relevante debe asociarse a un `USUARIO`. Las operaciones privadas obtienen el actor de Bearer JWT verificado y comprueban cuenta activa. Un ID del body, un rol declarado o `x-auth-id` sin verificacion no autentica.

El registro WebAuthn verifica primero la ceremonia y confirma usuario activo `VOLUNTARIO` y primera passkey juntos. Un fallo al guardar la credencial revierte el alta completa. El alta carece de recibo y replay idempotente. Ante respuesta perdida se comprueba el login con la passkey antes de repetir.

CORS y WebAuthn comparten `CORS_ORIGINS` como lista exacta de origenes. Produccion exige lista explicita HTTPS y registro/login requieren `Origin` permitido e igual al de la ceremonia. Los desafios viven en memoria de una instancia y un reinicio invalida ceremonias pendientes.

Contrato tecnico y limites del entorno en la [revision de altas del 16 de noviembre](../../Backend-r3foresta/docs/revision-altas-mvp-2026-11-16.md).

### RN-GEN-02 - El usuario se inactiva, no se borra

Si un usuario deja de operar, debe marcarse como inactivo. No se debe borrar si ya participa en historial, movimientos, validaciones o snapshots.

<a id="rn-gen-03---el-rol-es-controlado-por-catalogo"></a>

### RN-GEN-03 - El rol global y las autoridades por ambito son explicitos

El catalogo global conserva `ADMIN`, `GENERAL`, `VALIDADOR` y `VOLUNTARIO`. Solo ADMIN global activo administra roles y accesos M1/M2. Cambio, revision, historial y recibo se confirman juntos, con proteccion del ultimo ADMIN global activo.

- Captura y mantenimiento propio M1 requieren GENERAL o VALIDADOR con acceso M1 vigente. ADMIN deriva esta autoridad.
- Operacion M2 requiere autoridad vigente sobre el vivero y la accion. ADMIN conserva autoridad global.
- Recepcion de semillas requiere ADMIN global o VALIDADOR con asignacion vigente al vivero de almacenamiento. Se prohibe autorrecepcion tambien a ADMIN. GENERAL con M2 puede hacer INICIO y DESECHO sobre material recibido y no puede recibir-validar.
- PLANTADOR y ADMINISTRADOR_SUBCAMPANIA son permisos contextuales de Participacion aliada. COORDINADOR pertenece al equipo logistico.

La afiliacion, organizacion, equipo o autoria historica no concede por si misma permiso operativo actual. El perfil propio no acepta rol, actividad ni permisos administrativos. Los comandos administrativos conservan revision esperada, motivo, auditoria y recuperacion propia con cuenta activa tras perder autoridad.

Fuentes vigentes en [usuarios y perfil](../../Backend-r3foresta/documentacion/frontend/modulos/usuarios.md), [acceso M1](../../Backend-r3foresta/docs/t1-acceso-recoleccion.md), [acceso por vivero](../../Backend-r3foresta/docs/t2-acceso-viveros.md) y [recepcion unica](../../Backend-r3foresta/docs/t4-recepcion-semillas.md).

### RN-GEN-04 - El nombre humano puede congelarse en snapshots

Cuando un proceso necesite trazabilidad historica fuerte, el nombre del responsable debe congelarse en snapshot y no recalcularse desde `USUARIO`.

---

## 4. Reglas de territorios y ubicaciones

### RN-GEN-05 - GPS es la base minima de verdad geografica

La coordenada es el dato geografico minimo confiable. Los datos administrativos complementan la lectura territorial, pero no reemplazan latitud y longitud.

### RN-GEN-06 - La ubicacion siempre vive en `UBICACION`

En el MVP no se guardan coordenadas directas dentro de eventos operativos. Toda coordenada usada por el sistema debe persistirse en `UBICACION`.

### RN-GEN-07 - La ubicacion operativa debe vincularse a una division valida

Toda ubicacion operativa debe vincularse a una comunidad, localidad o division aprobada dentro de la estructura territorial vigente.

### RN-GEN-08 - La estructura territorial debe ser coherente

Si se registra `pais_id` y `division_id`, ambos deben pertenecer a la misma jerarquia territorial y no contradecirse.

### RN-GEN-09 - La comunidad debe tener una fuente oficial

El sistema no debe tratar comunidad como texto libre dentro de procesos operativos. En el MVP se usa `DIVISION_ADMINISTRATIVA` con `DIVISION_TIPO = Comunidad - Localidad` (`id = 4`) como fuente oficial.

### RN-GEN-10 - Solo administracion crea nuevas comunidades y zonas

En el MVP, solo `ADMIN` puede crear nuevas comunidades o zonas. Los usuarios operativos no las crean desde los flujos funcionales.

### RN-GEN-11 - Los cambios territoriales no reescriben historia

Si cambia el nombre de una comunidad, zona o division, los snapshots historicos no deben alterarse retroactivamente.

---

## 5. Reglas de plantas

### RN-GEN-12 - La planta maestra es fuente de seleccion, no de reescritura historica

`PLANTA` sirve para seleccionar la especie o planta en nuevos registros. No debe usarse para recalcular datos historicos ya congelados en Recoleccion o Vivero.

### RN-GEN-13 - Debe existir naming oficial para uso operativo

La fuente viva oficial de naming operativo en `PLANTA` es `nombre_comun_principal`. Ese campo alimenta el valor que los modulos operativos guardan como `nombre_comercial_snapshot`.

Debe permitir:

* seleccion en formularios,
* visualizacion legible,
* y snapshots coherentes entre modulos.

### RN-GEN-14 - `nombres_comunes` no participa en el MVP

El campo `nombres_comunes` puede existir en la base, pero no se toma en cuenta funcionalmente en el MVP.

### RN-GEN-15 - Inactivar una planta no rompe el historial

Una planta puede quedar inactiva para nuevos registros, pero lotes, recolecciones y snapshots existentes deben seguir siendo legibles.

### RN-GEN-16 - Identidad taxonomica y naming operativo no son lo mismo

El sistema debe distinguir entre:

* identidad cientifica,
* naming operativo,
* y variedad u otras clasificaciones operativas.

No deben mezclarse como si fueran un solo campo.

### RN-GEN-17 - El tipo de material permitido por planta es exclusivo en el MVP

En el MVP, cada planta debe configurarse con un solo `tipo_material_permitido`:

* `SEMILLA`, o
* `ESQUEJE`

No se usa `AMBOS` en esta fase.

---

## 6. Reglas de viveros

### RN-GEN-18 - El vivero es catalogo maestro

El vivero se administra como entidad maestra compartida y se selecciona desde catalogo en Recoleccion y Vivero.

El acceso M2 se concede a una persona para un vivero con vigencia, revision e historial. Almacenamiento M1 y destino M2 conservan campos distintos. El camino ordinario consume en el vivero de custodia del material recibido y ADMIN conserva la excepcion explicita de destino diferente del [contrato M1-M2](../90-contratos-integracion/01_contrato_recoleccion_a_vivero.md).

### RN-GEN-19 - Todo vivero tiene ubicacion asociada

Todo `VIVERO` debe apuntar a una `UBICACION` valida.

### RN-GEN-20 - El vivero puede inactivarse sin perder historia

La inactivacion bloquea nuevo uso, pero no invalida registros historicos ya asociados.

---

## 7. Reglas de evidencia

### RN-GEN-21 - La evidencia se vincula por modelo comun

Toda evidencia trazable debe registrarse mediante `TIPOS_ENTIDAD_EVIDENCIA` + `EVIDENCIAS_TRAZABILIDAD`, evitando modelos paralelos por modulo.

### RN-GEN-22 - La evidencia conserva contexto y audiencia

La evidencia indica entidad, actor y datos disponibles de toma y orden. Las cargas pendientes fijan tambien el contexto de operacion, vivero, solicitud o revision. El servidor vuelve a autorizar al cargar, leer y vincular.

Las fotos de recepcion corresponden a la revision de captura actual. Una foto de otra revision no habilita la decision. Recepcion e incorporacion admiten 1 a 5 fotos por su operacion. La plantacion inicial participante requiere entre 1 y 10 fotos conforme a D09.

Los originales privados se consultan mediante lectura autorizada o URL firmada. T5 usa `vivero_incorporaciones` privado y firmas de 300 segundos. Los buckets legados conservan su configuracion propia y la proyeccion publica solo publica derivados permitidos y sanitizados.

Un fallo de consulta de fotos se declara como error. Un fallo de firma conserva metadatos, URL nula y estado explicito. Storage se confirma fuera de PostgreSQL y ante incertidumbre se conservan archivos y contexto para recuperar o conciliar.

### RN-GEN-23 - El retiro permitido de evidencia conserva trazabilidad

La sustitucion o retiro de fotos de una ficha editable se rige por su operacion y conserva la trazabilidad. Los vinculos confirmados, snapshots, claves y recibos historicos se preservan.

Una subida o una respuesta perdida no acreditan por si mismas confirmacion o rollback. La compensacion se limita a rechazos concluyentes y las referencias inciertas permanecen disponibles para recuperacion o conciliacion.

### RN-GEN-23a - La evidencia auditable conserva el original

Las nuevas evidencias auditables conservan el archivo original intacto y calculan en servidor SHA256, tamano y MIME. El frontend envia `multipart/form-data` y puede preparar vistas previas. Los derivados de visualizacion o publicacion se generan conservando su relacion con el original. Los hashes y metadatos tecnicos ausentes de registros historicos permanecen como ausentes, sin atribuirles un backfill ni cumplimiento verificado.

Se admiten JPG/JPEG/PNG/WEBP/HEIC/HEIF con validacion y limites por recorrido. La politica comun de originales operativos usada en recepcion y T5 admite hasta 15 MiB por archivo y 100 MiB acumulados por carga. Esos dos recorridos admiten entre 1 y 5 fotos por operacion.

La plantacion inicial participante admite entre 1 y 10 fotos de hasta 10 MiB por archivo, conforme a D09 y `MAX_FOTO_BYTES`. Cada carga transporta una foto y valida su decodificacion real. El [contrato de Participacion aliada](../specs/plantacion/participacion-aliada/contrato-identidad-permisos-backend-propuesta.md) conserva su audiencia, privacidad y recuperacion por carga. Las imagenes decorativas o de catalogo siguen su politica propia.

La distribucion de Recoleccion en 1 a 5 fotos de Lugar y 1 a 5 de Total recolectado se conserva en `RN-REC-14`. Su validacion backend por seccion permanece pendiente y se distingue del control total de 2 a 10 fotografias.

## 8. Reglas de integracion con otros modulos

### RN-GEN-24 - Los modulos operativos consumen maestros; no los redefinen

Recoleccion, Vivero y futuros modulos deben usar este modulo como contrato base para usuarios, ubicaciones, viveros, plantas y territorios.

### RN-GEN-25 - Snapshot solo en el momento formal del proceso

Los datos maestros pueden cambiar en el tiempo. Por eso cada modulo operativo define en que hito se congela el snapshot. Antes de ese hito se puede recalcular; despues, no.

### RN-GEN-26 - No se permiten duplicados semanticos por modulo

No debe existir un catalogo de plantas en Recoleccion, otro distinto en Vivero y otro distinto en Plantacion. La entidad maestra es una sola, aunque los modulos proyecten snapshots propios.

---

## 9. Reglas de organizaciones

### RN-GEN-27 - La organizacion es catalogo maestro real

`ORGANIZACION` se administra como entidad maestra al mismo nivel que `USUARIO`, `VIVERO` o `PLANTA`. No debe modelarse como texto libre ni como catalogo embebido dentro de Plantacion u otro modulo operativo.

### RN-GEN-28 - El tipo de organizacion es controlado por catalogo

`tipo` no puede ser texto libre. La lista oficial del MVP es: `ONG`, `EMPRESA_PRIVADA`, `EMPRESA_PUBLICA`, `FUNDACION`, `ETFs`, `ALCALDIA`, `ASOCIACION_CIUDADANA`, `OTRO`.

### RN-GEN-29 - Inactivar una organizacion no rompe el historial

Una organizacion puede quedar inactiva (`activo = false`) para nuevo uso, pero las campañas del Modulo 3 que ya la tengan asociada via `CAMPANIA_ORGANIZACION` siguen mostrando el snapshot de su nombre congelado al activar la subcampaña (`nombres_organizaciones_snapshot`).
