# KPI Baseline y Riesgos

## Paso 3: KPIs con Baseline y Meta

### KPI 1: Tasa de Conflictos de Horarios (Prevención de Errores)
*   **Nombre:** Reducción de cruces detectados post-asignación.
*   **Fórmula:** `(Total de cruces físicos reportados en operación / Total de franjas horarias programadas activas) * 100`
*   **Baseline actual:** N/A para el MVP (Estimado empírico actual: 5-10% por errores manuales).
*   **Meta a 30 días:** < 2% de error.
*   **Meta a 90 días:** 0% (El sistema debe garantizar la imposibilidad técnica de guardar un cruce temporal/físico para la triple restricción estricta).
*   **Fuente de datos:** Tabla de `Observaciones` (tipo=cruce o queja de horario) vs Total de registros en tabla `Horarios`.

### KPI 2: Tasa de Ocupación de Ambientes
*   **Nombre:** Optimización de Ocupación Física.
*   **Fórmula:** `(Horas totales programadas en todos los ambientes / Horas disponibles totales sumadas de los ambientes) * 100`
*   **Baseline actual:** N/A primer lanzamiento.
*   **Meta a 30 días:** 60% (Refleja adopción inicial).
*   **Meta a 90 días:** >= 75% (Refleja mejora en la eficiencia de programación de los coordinadores usando el buscador de disponibilidad).
*   **Fuente de datos:** Consulta SQL sobre tabla `Horarios` agrupado por `Ambientes`.

### KPI 3: Tiempo Promedio de Planificación de Franjas
*   **Nombre:** Eficiencia del Coordinador Académico.
*   **Fórmula:** `Tiempo total transcurrido en sesión UI creando horarios / Cantidad de bloques de horario creados`
*   **Baseline actual:** N/A (Estimado manual: Varios minutos por cruce de información y revisiones).
*   **Meta a 30 días:** < 30 segundos por bloque programado exitosamente.
*   **Meta a 90 días:** < 15 segundos por bloque (gracias a buscadores y selectores con autocompletado en el sistema).
*   **Fuente de datos:** Logs de eventos web de creación de bloques horarios (telemetría/analytics web simple).

---

## Paso 4: Riesgos y Preguntas Abiertas

### Top 5 Riesgos de Producto o Negocio
1.  **Resistencia al Cambio:** Los coordinadores podrían rechazar el uso del sistema si la UI es más compleja de usar que sus hojas de cálculo actuales.
2.  **Calidad de Datos Base:** Si la información inicial (capacidad de ambientes, disponibilidad de instructores) se ingresa incorrectamente, el sistema reportará validaciones fallidas que causarán fricción.
3.  **Variabilidad de Patrones de Franjas:** Si el modelo de datos de "franjas horarias" es demasiado rígido, no podrá representar horarios atípicos o excepciones comunes en instituciones grandes.
4.  **Sobrecarga de Observaciones:** Si el módulo de observaciones no cuenta con un sistema rápido para clasificar y delegar, podría convertirse en un basurero inmanejable de texto libre.
5.  **Excepción por Defecto:** Que se insista a nivel gerencial en añadir una función para "forzar guardado ignorando advertencia de conflicto", lo que derrotaría el valor principal del sistema y arruinaría la integridad de la BD.

### Preguntas Abiertas (Open Questions)
*   *¿Cuál es el modelo exacto de definición de una "franja horaria"?* (Ej. bloques fijos de 1 hora, de 2 horas, o libres de inicio a fin por minuto). **(Bloqueante para Arquitectura/Datos)**.
*   *¿Existe una dependencia jerárquica en los ambientes?* (Ej. "Sala de Informática A" está dentro del "Edificio Principal" y eso influye en los traslados de instructores). *(Diferible a Fase 2)*.
*   *¿Los contratistas tienen un máximo de horas semanales legal distinto a los de planta (ej. 40h vs 48h)?* ¿Debe el motor validar este máximo? *(Diferible a MVP v1.1 pero importante modelar).*