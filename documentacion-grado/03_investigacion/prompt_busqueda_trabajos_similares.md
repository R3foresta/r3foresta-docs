# Prompt para buscar trabajos/sistemas similares (Antecedentes)

> **Documento histórico — no reutilizar como descripción del alcance vigente.** Este prompt corresponde a una formulación anterior con blockchain, bonos de carbono, cuatro módulos y monitoreo posterior. El perfil actual se concentra en la trazabilidad del material vegetal entre Recolección, Vivero y Plantación, y concluye con el registro de la plantación. La fuente vigente es [`../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md`](../06_entregables/perfil/PERFIL_PROYECTO_GRADO.md).

> Pegar este prompt en una IA con acceso a búsqueda web / repositorios académicos.
> Objetivo: alimentar la sección **Introducción / Antecedentes** del perfil de proyecto de grado (UMSA — Informática, Ing. de Sistemas).

---

## PROMPT

Actúa como investigador académico especializado en revisión de estado del arte para un proyecto de grado de Ingeniería de Sistemas. Necesito que busques y me entregues **trabajos, sistemas, plataformas y publicaciones previas similares** a mi proyecto, para redactar la sección de **Antecedentes**.

### Contexto de mi proyecto (R3Foresta)

R3Foresta es un sistema de **trazabilidad de la cadena de custodia de material biológico para reforestación**, con **certificación/transparencia mediante blockchain** y orientado a **bonos de carbono**. Modela el ciclo completo de una planta desde su origen hasta el campo, en cuatro módulos:

1. **Recolección (origen):** registro del lote origen de semillas/material biológico con evidencia fotográfica obligatoria, coordenadas GPS y flujo de validación.
2. **Vivero (maduración):** seguimiento del lote en vivero con eventos append-only (inicio, embolsado, merma, despacho), saldo vivo de plantas y cierre del lote.
3. **Plantación (campo):** campañas y subcampañas de plantación en terreno, metas por especie, validación geoespacial del polígono (PostGIS/GPS), mantenimiento y monitoreo posterior.
4. **Catálogos maestros transversales:** usuarios/roles, territorios, viveros, especies de plantas.

Características técnicas clave a considerar para encontrar trabajos afines:
- **Trazabilidad extremo a extremo** (chain of custody) de un activo físico/biológico.
- **Blockchain** para inmutabilidad y transparencia; **tokenización/NFT** de lotes o unidades.
- **Almacenamiento descentralizado** de metadata y evidencia (IPFS / Pinata).
- **Persistencia multicapa:** base de datos relacional (PostgreSQL/Supabase) + storage de binarios + IPFS + blockchain.
- **Evidencia georreferenciada** (GPS, geocercas, validación de polígonos con PostGIS).
- **Bonos de carbono / créditos de carbono** y MRV (medición, reporte y verificación).
- Dominio: **reforestación, restauración forestal, agricultura, cadenas de suministro sostenibles**.

### Qué necesito que busques

Encuentra ejemplos en estas categorías (dame varios de cada una):

1. **Trabajos académicos** (tesis, proyectos de grado, papers, artículos de conferencia) sobre:
   - Trazabilidad de cadenas de suministro con blockchain.
   - Blockchain aplicado a reforestación, forestación, agricultura o créditos de carbono.
   - Uso de IPFS + NFT para certificar activos físicos o ambientales.
   - Sistemas de MRV para bonos de carbono.
   - Prioriza trabajos de **Latinoamérica y Bolivia** si existen, y repositorios universitarios (incluido el Repositorio Institucional UMSA).

2. **Plataformas / productos comerciales o de ONG** que hagan algo parecido (ej. plataformas de tokenización de árboles, trazabilidad forestal, mercados de carbono on-chain, "plant-a-tree" con blockchain). Nombra el proyecto, quién lo hace y qué resuelve.

3. **Estándares y marcos de referencia** relevantes (ej. Verra/VCS, Gold Standard, protocolos de MRV, iniciativas de carbono digital).

### Formato de salida esperado

Para **cada** trabajo/sistema encontrado, entrégame:

- **Nombre / título** del trabajo o sistema.
- **Autor(es) / organización** y **año**.
- **Tipo** (tesis / paper / plataforma comercial / estándar).
- **Resumen** de 2–4 líneas de qué hace y qué problema resuelve.
- **Tecnologías** que usa (blockchain concreta, IPFS, tipo de tokens, etc.), si se conoce.
- **Similitudes** con R3Foresta.
- **Diferencias / vacío que R3Foresta podría cubrir** (esto es clave para justificar mi aporte).
- **Enlace / referencia** (URL, DOI o cita en formato APA si es posible).

Al final, agrega:
- Una **tabla comparativa** (trabajo × características: blockchain / IPFS / GPS-geo / bonos de carbono / trazabilidad multi-etapa / enfoque reforestación).
- Un **párrafo de síntesis** que identifique el **vacío o brecha** que ningún trabajo previo cubre completamente y que justifique la relevancia de R3Foresta.

Prioriza fuentes reales y verificables; **no inventes referencias**. Si no encuentras algo en una categoría, dilo explícitamente.
