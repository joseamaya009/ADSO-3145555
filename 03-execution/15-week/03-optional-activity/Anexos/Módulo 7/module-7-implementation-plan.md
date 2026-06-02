# Módulo 7 – Implementación

## Objetivo
Definir el plan de implementación del módulo 7: Instructores, Aprendices y Directivos, alineado con el MVP y los anexos de idea refinada, KPIs y preguntas abiertas.

> Nota: este módulo asume que los módulos de Ambientes, Horarios y Fichas ya existen en el sistema. El alcance de módulo 7 es actor, autorización y colaboración con esos módulos, no rehacer los catálogos de ambientes o el motor de horarios.

## Épicas principales

### Epic 1: Gestión de actores y permisos
- Historia 1.1: CRUD de Instructores
- Historia 1.2: CRUD de Aprendices
- Historia 1.3: Gestión de Directivos / roles de acceso
- Historia 1.4: Integración con fichas existentes para relacionar aprendices y asignaciones

### Epic 2: Interacción con el módulo de Horarios y Ambientes
- Historia 2.1: Consultar y gestionar asignaciones propias de instructores/aprendices usando horarios existentes
- Historia 2.2: Mostrar conflictos detectados por el motor de horarios (Instructor + Ambiente + Ficha)
- Historia 2.3: Presentar disponibilidad de ambientes y franjas basada en el módulo de Ambientes/Horarios
- Historia 2.4: Visualización básica de conflicto y sugerencias antes de guardar

### Epic 3: Observaciones y seguimiento
- Historia 3.1: Registro de observaciones por instructor
- Historia 3.2: Registro de observaciones por aprendiz/ficha
- Historia 3.3: Registro de observaciones por ambiente
- Historia 3.4: Gestión de estado de observaciones (Abierta / En proceso / Resuelta)

### Epic 4: Reportes y métricas iniciales
- Historia 4.1: Reporte de carga horaria por instructor
- Historia 4.2: Reporte de ocupación de ambientes
- Historia 4.3: Reporte de conflictos bloqueados por el motor

## Tareas por épica

### Epic 1 – Catálogos
1. Diseñar modelo de datos de `Instructor`, `Aprendiz`, `Directivo`, `Ficha` y `Rol`
2. Crear APIs/servicios de CRUD para Instructores
3. Crear APIs/servicios de CRUD para Aprendices
4. Implementar gestión de Directivos/roles y permisos básicos
5. Validar datos de catálogos iniciales y reglas de integridad

### Epic 2 – Motor de horarios
1. Definir estructura de `FranjaHoraria` y reglas de bloque
2. Implementar creación de bloques horarios para fichas
3. Añadir validación de conflictos en backend
4. Crear endpoint de búsqueda de ambientes libres
5. Implementar UI básica de asignación y feedback de conflicto

### Epic 3 – Observaciones
1. Definir modelo `Observacion` con vinculación a Instructor, Ficha, Ambiente
2. Implementar creación y edición de observaciones
3. Implementar cambios de estado y registro de resolución
4. Añadir filtros por actor y tipo de observación

### Epic 4 – Reportes
1. Definir métricas iniciales de carga horaria y ocupación
2. Implementar reporte de carga por instructor
3. Implementar reporte de ocupación de ambientes
4. Documentar cómo alimentar KPIs iniciales con la base de datos

## Priorización MVP
1. CRUD de Instructores, Aprendices y Fichas
2. Motor de horarios con validación de conflicto
3. Consulta de disponibilidad de ambientes
4. Observaciones básicas
5. Reporte simple de carga horaria

## Riesgos de ejecución
- Definir la `FranjaHoraria` precisa antes de modelar la base de datos
- Calidad de datos iniciales del catálogo de ambientes e instructores
- Evitar permitir “forzar guardado con conflicto” en MVP

## Entregables esperados
- `Anexos/module-7-user-stories.md`
- `Anexos/module-7-domain-entity-scheme.md`
- Implementación del módulo 7 en backend y UI mínima web-responsive
