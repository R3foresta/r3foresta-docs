# Guia operativa - Modulo General

## 1. Objetivo

Este modulo no registra eventos biologicos. Su funcion es preparar y mantener los catalogos que hacen posible que los modulos operativos trabajen con datos consistentes.

En terminos practicos, aqui se administra:

* quien opera,
* donde opera,
* con que plantas opera,
* en que viveros trabaja,
* y bajo que estructura territorial se describe el contexto.

---

## 2. Flujo operativo recomendado

### Paso 1. Crear o depurar usuarios

Antes de abrir operacion, deben existir los usuarios base:

* `ADMIN`,
* `GENERAL`,
* `VALIDADOR`,
* `VOLUNTARIO`.

Campos minimos recomendados:

* nombre,
* apellido,
* correo,
* username,
* rol,
* identificador de autenticacion.

### Paso 2. Cargar estructura territorial

Se recomienda cargar primero:

1. pais,
2. tipos de division,
3. divisiones administrativas,
4. comunidades o localidades operativas.

Para el MVP, la comunidad se resuelve dentro de `DIVISION_ADMINISTRATIVA` usando `DIVISION_TIPO = Comunidad - Localidad` (`id = 4`).

### Paso 3. Crear ubicaciones reutilizables

Una ubicacion debe registrar como minimo:

* latitud,
* longitud,
* pais,
* referencia legible opcional,
* y division administrativa obligatoria para el uso operativo.

Esto permite reutilizar la misma ubicacion en:

* viveros,
* puntos frecuentes de recoleccion,
* y modulos futuros.

### Paso 4. Crear viveros

Cada vivero debe registrarse con:

* codigo unico,
* nombre,
* ubicacion asociada.

Opcionalmente:

* responsable,
* notas,
* estado operativo.

### Paso 5. Cargar catalogo de plantas

El catalogo de plantas debe existir antes de permitir captura productiva en Recoleccion.

Cada planta debe tener como minimo:

* nombre cientifico,
* `nombre_comun_principal` como naming oficial de uso operativo,
* tipo de planta,
* `tipo_material_permitido` con valor exclusivo `SEMILLA` o `ESQUEJE`,
* variedad cuando aplique,
* reglas o notas tecnicas si hacen falta.

### Paso 6. Configurar tipos de evidencia

Antes de exigir fotos o archivos en modulos operativos, deben estar definidos los `TIPOS_ENTIDAD_EVIDENCIA` necesarios.

---

## 3. Orden recomendado de implementacion documental y tecnica

1. Usuarios y roles.
2. Territorios y comunidades.
3. Ubicaciones.
4. Viveros.
5. Plantas.
6. Evidencias.

Ese orden reduce dependencias rotas en formularios y validaciones.

---

## 4. Como interactua con otros modulos

### Recoleccion

Consume:

* `RF-GEN-01` para recolector y validador,
* `RF-GEN-02` para vivero de almacenamiento,
* `RF-GEN-03` para planta,
* `RF-GEN-04` para ubicacion,
* `RF-GEN-05` para comunidad y snapshots territoriales.

### Vivero

Consume:

* `RF-GEN-01` para responsable,
* `RF-GEN-02` para vivero operativo,
* `RF-GEN-03` como origen remoto de identidad maestra de la planta,
* `RF-GEN-06` para evidencia por evento.

---

## 5. Politicas recomendadas para MVP

* Alta de nuevas comunidades y zonas solo por `ADMIN`.
* Inactivacion en lugar de borrado para entidades ya usadas.
* No usar coordenadas directas en eventos operativos; siempre usar `UBICACION`.
* `nombre_comun_principal` es la fuente oficial para poblar snapshots operativos de naming.
* `nombres_comunes` queda fuera de alcance funcional en el MVP.
