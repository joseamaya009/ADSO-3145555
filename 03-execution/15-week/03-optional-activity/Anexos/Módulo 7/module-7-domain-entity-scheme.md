# Módulo 7 – Modelo de Dominio y Esquema de Entidades

## Entidades clave

### Instructor

- Atributos principales:
  - `id`
  - `nombre`
  - `documento`
  - `email`
  - `especialidad`
  - `maxHorasSemanales`
  - `estado`
- Relaciones:
  - `disponibilidades`
  - `horarios`
  - `observaciones`
  - `solicitudes`

### Aprendiz

- Atributos principales:
  - `id`
  - `nombre`
  - `documento`
  - `email`
  - `estado`
  - `fichaId`
- Relaciones:
  - `ficha` (exactamente una ficha)
  - `horarios` (indirecto vía ficha)
  - `observaciones`

### Directivo

- Atributos principales:
  - `id`
  - `nombre`
  - `rol` (Coordinador, Administrador)
  - `email`
  - `permisos`
- Relaciones:
  - `gestionados` (acciones administrativas)

### Ficha	

- Atributos principales:
  - `id`
  - `codigo`
  - `programaFormativo`
  - `jornada`
  - `estado`
  - `fechaInicio`
  - `fechaFin`
- Relaciones:
  - `aprendices`
  - `horarios`
  - `observaciones`

### Ambiente

- Atributos principales:
  - `id`
  - `nombre`
  - `tipo`
  - `capacidad`
  - `recursos`
  - `estado`
- Relaciones:
  - `horarios`
  - `observaciones`

> Nota: `Ambiente` es una entidad gestionada por el módulo de Infraestructura / Ambientes. Módulo 7 la consume para mostrar contexto y observaciones.

### Horario

- Atributos principales:
  - `id`
  - `fecha`
  - `horaInicio`
  - `horaFin`
  - `instructorId`
  - `fichaId`
  - `ambienteId`
  - `estado`
- Reglas de integridad:
  - Un mismo `instructorId` no puede tener otro horario activo que cruce la misma franja.
  - Un mismo `ambienteId` no puede tener otro horario activo que cruce la misma franja.
  - Una misma `fichaId` no puede tener otro horario activo que cruce la misma franja.

> Nota: `Horario` es entidad central del módulo de Horarios. Módulo 7 consume y presenta estos datos, y agrega el contexto de personas y observaciones.

- Reglas de integridad:
  - Un mismo `instructorId` no puede tener otro horario activo que cruce la misma franja.
  - Un mismo `ambienteId` no puede tener otro horario activo que cruce la misma franja.
  - Una misma `fichaId` no puede tener otro horario activo que cruce la misma franja.

### Observación

- Atributos principales:
  - `id`
  - `tipo` (Incidencia, Cambio de ambiente, Falta de recursos, Cruce)
  - `descripcion`
  - `actorOrigen` (Instructor, Aprendiz, Directivo)
  - `entidadVinculada` (Instructor, Ficha, Ambiente)
  - `estado` (Abierta, En proceso, Resuelta)
  - `fechaCreacion`
  - `fechaCierre`
- Relaciones:
  - `instructorId?`
  - `aprendizId?`
  - `fichaId?`
  - `ambienteId?`

### Solicitud

- Atributos principales:
  - `id`
  - `tipo` (Cambio de horario, Cambio de ambiente)
  - `solicitanteId`
  - `motivo`
  - `estado` (Pendiente, Aprobado, Rechazado)
  - `fechaSolicitud`
- Relaciones:
  - `instructorId`
  - `horarioId?`

## Relaciones principales

- `Instructor 1..* -> Horario`
- `Instructor 1..* -> Ficha` (indirecto, a través de horarios)
- `Aprendiz 1..1 -> Ficha`
- `Ficha 1..* -> Horario`
- `Ambiente 1..* -> Horario`
- `Ficha 1..* -> Aprendiz`
- `Horario 1..* -> Observacion`
- `Instructor 1..* -> Observacion`
- `Ficha 1..* -> Observacion`
- `Ambiente 1..* -> Observacion`
- `Directivo 1..* -> Solicitud`

## Reglas de negocio críticas

- Validar conflictos en tiempo real antes de persistir un `Horario`.
- Un `Instructor` no puede exceder su `maxHorasSemanales` en el MVP para evitar sobrecarga.
- Las `Observaciones` deben poder consultarse por actor, ficha o ambiente.
- Las `Solicitudes` de cambio deben ser visibles desde el panel del `Directivo`.
- No se debe permitir forzar guarda en conflicto en MVP.

## Iteración técnica recomendada

1. Diseñar esquema de datos relacional para `Instructor`, `Aprendiz`, `Ficha`, `Ambiente`, `Horario`, `Observacion`, `Solicitud`.
2. Implementar servicios backend y API REST/GraphQL para CRUD.
3. Añadir capa de validación de conflictos en el dominio de `Horario`.
4. Construir UI de consulta y gestión para Instructores, Aprendices y Directivos.
5. Exponer métricas básicas para alimentar los KPIs del anexo.
