# Módulo 7 – Historias de Usuario

## 1. Instructores

### Historia 1
- Como **Instructor**, quiero consultar mi horario asignado, para saber qué ficha, ambiente y hora tengo hoy.
- Criterios de aceptación:
  - Puedo ver fecha, hora, ambiente, ficha y materia del bloque.
  - Puedo ver observaciones asociadas a mi clase.

### Historia 2
- Como **Instructor**, quiero registrar una observación sobre una clase, para notificar problemas técnicos o logísticos.
- Criterios de aceptación:
  - Puedo crear observaciones con título, descripción, categoría y estado.
  - La observación se relaciona a la ficha, ambiente o a mi persona.

### Historia 3
- Como **Instructor**, quiero consultar mi carga horaria semanal, para verificar que no excedo mi contrato.
- Criterios de aceptación:
  - Puedo ver el total de horas asignadas en la semana.
  - Puedo ver horas por ficha y por día.

### Historia 4
- Como **Instructor**, quiero solicitar un cambio de ambiente o horario, para que el coordinador revise mi petición.
- Criterios de aceptación:
  - Puedo crear solicitudes que expliquen el motivo.
  - El coordinador puede ver la solicitud desde su panel.

## 2. Aprendices

### Historia 5
- Como **Aprendiz**, quiero consultar mi horario de ficha, para saber dónde y cuándo debo asistir.
- Criterios de aceptación:
  - Puedo ver la ficha asignada, las clases del día y el ambiente.
  - Puedo ver el estado de la ficha.

### Historia 6
- Como **Aprendiz**, quiero ver las observaciones que afectan a mi ficha, para recibir avisos sobre cambios o incidencias.
- Criterios de aceptación:
  - Puedo ver observaciones filtradas por mi ficha.
  - Puedo ver estado y descripción de cada observación.

### Historia 7
- Como **Aprendiz**, quiero verificar mis datos personales básicos, para confirmar que la información de la ficha está correcta.
- Criterios de aceptación:
  - Puedo ver documento, nombre, ficha y estado.
  - Puedo ver el programa o jornada asignada si aplica.

## 3. Directivos / Coordinadores

### Historia 8
- Como **Directivo**, quiero gestionar instructores y asignarles especialidades, para controlar la disponibilidad de docentes.
- Criterios de aceptación:
  - Puedo crear, editar y desactivar instructores.
  - Puedo asignar especialidades y máximos de horas.

### Historia 9
- Como **Directivo**, quiero consultar y vincular aprendices a fichas existentes, para asegurar que el módulo de actores funcione con el catálogo de formación.
- Criterios de aceptación:
  - Puedo ver fichas existentes y el listado de aprendices vinculados.
  - Puedo relacionar un aprendiz con una ficha sin recrear el catálogo de fichas.

### Historia 10
- Como **Directivo**, quiero ver las asignaciones de bloques horarios y los conflictos detectados por el módulo de horarios, para evitar cruces de instructor, ambiente o ficha.
- Criterios de aceptación:
  - El sistema bloquea la asignación si existe conflicto.
  - Puedo ver cuál es el conflicto (instructor/ambiente/ficha).

### Historia 11
- Como **Directivo**, quiero ver reportes de carga horaria y ocupación de ambientes, para tomar decisiones de planificación.
- Criterios de aceptación:
  - Puedo descargar o consultar un reporte de horas por instructor.
  - Puedo ver la ocupación histórica de ambientes.

### Historia 12
- Como **Directivo**, quiero gestionar observaciones y cambiar su estado, para dar seguimiento a incidentes y solicitudes.
- Criterios de aceptación:
  - Puedo filtrar observaciones por ficha, ambiente o instructor.
  - Puedo actualizar estado a `Resuelta`.

## Priorización para MVP
1. Historias 1, 5, 8, 9, 10
2. Historias 2, 6, 11, 12
3. Historias 3, 4, 7
