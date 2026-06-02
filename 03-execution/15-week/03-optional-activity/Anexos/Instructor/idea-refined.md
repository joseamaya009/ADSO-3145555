# Idea Refinada: Sistema de Gestión de Horarios Académicos

## Paso 1: Refinamiento de la Idea

**Problema:**
En los centros de formación, la programación académica suele realizarse de manera manual o en sistemas desconectados. Esto genera frecuentes conflictos operativos (cruces donde un mismo instructor, ambiente o grupo es asignado a dos lugares simultáneamente), provoca sobrecarga administrativa en los coordinadores y resulta en un uso ineficiente de los espacios físicos y del personal docente.

**Usuarios y Jobs-to-be-done (JTBD):**
*   **Coordinador Académico:**
    *   *JTBD:* Programar la carga académica de las fichas (grupos) asignando instructores y ambientes físicos sin generar cruces de horarios.
*   **Instructor (Docente):**
    *   *JTBD:* Consultar su horario asignado, conocer su carga horaria semanal y registrar observaciones.
*   **Administrador de Ambientes / Infraestructura:**
    *   *JTBD:* Mantener actualizado el inventario de salones, laboratorios, su capacidad y los recursos tecnológicos que poseen para garantizar asignaciones aptas.

**Propuesta de Valor:**
Una plataforma centralizada basada en validaciones algorítmicas en tiempo real que previene proactivamente los conflictos de asignación (triple restricción: instructor, ambiente, ficha). Ofrece reportes visuales instantáneos que reducen el tiempo de planificación de horas a minutos, asegurando que cada asignación es físicamente y temporalmente posible antes de guardarse en la base de datos.

**Alternativas Actuales:**
Uso extensivo de múltiples hojas de cálculo (Excel) compartidas por correo electrónico, reuniones de coordinación interminables, comprobación visual humana propensa a errores y tableros físicos en paredes.

## Paso 2: Definición de MVP

**Alcance del primer release (MVP):**
1.  **Módulos de Catálogo (CRUD):** Gestión de Ambientes, Fichas (Grupos) e Instructores.
2.  **Motor de Horarios (Core):** Asignación de franjas horarias con validación estricta y automática contra conflictos de cruce (mismo instructor, mismo ambiente, misma ficha a la misma hora).
3.  **Consulta de Disponibilidad:** Buscador en tiempo real de ambientes libres por fecha y franja horaria.
4.  **Reporte Básico:** Reporte de carga horaria acumulada por instructor.
5.  **Módulo de Observaciones:** Sistema simple para registrar problemas u observaciones vinculadas a instructores, fichas o ambientes, con seguimiento de estado (abierta/resuelta).

**Fuera de Alcance Explícito:**
*   Integración automática con sistemas ERP externos institucionales (sistemas de nómina o matrículas).
*   Notificaciones Push / SMS / WhatsApp automáticas a instructores sobre cambios (se manejará consulta manual en esta fase).
*   Aplicación móvil nativa (Android/iOS). El sistema será web-responsive.
*   Módulo de inasistencias o calificaciones de aprendices.

**Supuestos Críticos:**
*   Los coordinadores adoptarán el sistema como fuente única de verdad, abandonando el uso de sus "Excels paralelos".
*   Las reglas de franjas horarias y jornadas (mañana, tarde, noche, fin de semana) son estandarizables y no varían caóticamente semana a semana para una misma ficha.
*   La lógica de validación de conflictos (Instructor + Ambiente + Hora) cubre el 95%+ de los errores reales operativos actuales.
