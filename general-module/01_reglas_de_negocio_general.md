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

Toda accion relevante del sistema debe poder asociarse a un `USUARIO`.

### RN-GEN-02 - El usuario se inactiva, no se borra

Si un usuario deja de operar, debe marcarse como inactivo. No se debe borrar si ya participa en historial, movimientos, validaciones o snapshots.

### RN-GEN-03 - El rol es controlado por catalogo

El rol de usuario no puede ser texto libre. La lista oficial del MVP es:

* `ADMIN`
* `GENERAL`
* `VALIDADOR`
* `VOLUNTARIO`

Los permisos operativos se asignan a partir de este catalogo.

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

El vivero se administra como entidad maestra compartida. No debe nacer como texto libre dentro de Recoleccion o Vivero.

### RN-GEN-19 - Todo vivero tiene ubicacion asociada

Todo `VIVERO` debe apuntar a una `UBICACION` valida.

### RN-GEN-20 - El vivero puede inactivarse sin perder historia

La inactivacion bloquea nuevo uso, pero no invalida registros historicos ya asociados.

---

## 7. Reglas de evidencia

### RN-GEN-21 - La evidencia se vincula por modelo comun

Toda evidencia trazable debe registrarse mediante `TIPOS_ENTIDAD_EVIDENCIA` + `EVIDENCIAS_TRAZABILIDAD`, evitando modelos paralelos por modulo.

### RN-GEN-22 - El archivo no basta sin contexto de negocio

La evidencia debe indicar a que entidad pertenece y, cuando aplique, quien la subio, cuando fue tomada y si es principal.

### RN-GEN-23 - `eliminado_en` no participa en el MVP

Aunque `EVIDENCIAS_TRAZABILIDAD` tenga campos para eliminacion logica, esa capacidad queda reservada para fases futuras y no forma parte del flujo funcional del MVP.

### RN-GEN-23a - Evidencia auditable no se comprime en frontend

Aplica a evidencia operativa/auditable de M1 Recoleccion, M2 Vivero (eventos `INICIO`, `EMBOLSADO`, `ADAPTABILIDAD` con evidencia, `MERMA`, `DESPACHO`) y M3 Plantacion, y en general a cualquier evidencia de trazabilidad asociada a procesos, estados, movimientos o validaciones. Imagenes decorativas o de catalogo si pueden comprimirse; la evidencia auditable, no.

Backend no debe reemplazar el archivo original con una version comprimida como unica copia. El flujo correcto es: guardar el archivo original intacto, calcular hash del original, guardar metadata tecnica y, si hace falta, generar una copia optimizada/thumbnail solo para visualizacion.

**Pendiente para M3 Plantacion:** cuando se implemente, toda evidencia de plantacion debe subir el archivo original (sin compresion frontend, sin `nonEvidenceImageCompression`, usando frontend solo para validacion/previews); backend debe guardar original + hash + metadata y puede generar thumbnails/derivados para visualizacion; el frontend debe enviar los archivos por `multipart/form-data` en un campo acordado, idealmente `fotos`.

---

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
