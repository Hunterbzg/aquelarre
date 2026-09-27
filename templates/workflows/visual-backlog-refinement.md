# Workflow: Visual Backlog Refinement

**Descripción:** Bucle interactivo pantalla por pantalla para transformar diseños (High Fidelity) en un backlog ejecutable (Epics, Stories, Tasks) y decisiones de arquitectura (ADRs), asegurando validación humana antes de generar artefactos.

## Cuándo usar

- Cuando el usuario proporciona pantallas, mockups o diseños visuales y pide organizarlos, desglosarlos o analizarlos para empezar el desarrollo.

## Objetivo

Evitar el procesamiento "en batch" o masivo. Procesar de a UNA pantalla por vez, entrevistando al usuario para cubrir vacíos de negocio o técnicos, proponer el desglose de trabajo en el chat, y generar los archivos físicos SOLO después de recibir la aprobación.

---

## Bucle de Refinamiento (Por cada pantalla)

Ejecuta estas fases estrictamente en orden para la pantalla en contexto. No pases a la siguiente fase hasta resolver la actual con el usuario.

### Fase 1: UI Teardown & Edge Cases (Rol: Product Owner)
**Skill:** `aquelarre-po-product`
1. Analiza visualmente la pantalla subida.
2. Identifica el propósito principal y los elementos que implican reglas de negocio (botones, formularios, estados vacíos).
3. **ACCIÓN OBLIGATORIA:** Haz 2 a 3 preguntas directas al usuario sobre flujos no visibles, casos de error, o reglas de negocio ambiguas (ej. "¿Qué pasa si el pago falla?", "¿Es un soft delete?").
4. Espera la respuesta del usuario antes de pasar a la Fase 2.

### Fase 2: Technical Feasibility Check (Rol: Arquitecto)
**Skill:** `aquelarre-architecture-adr`
1. Con las respuestas de la Fase 1, evalúa las implicaciones técnicas de la pantalla (ej. requerimiento de WebSockets, proveedores de pago, base de datos).
2. **ACCIÓN OBLIGATORIA:** Pregunta al usuario por las decisiones técnicas clave asociadas a los retos identificados (ej. "¿Usaremos Stripe o un proveedor local?", "¿Necesitaremos almacenar esto en caché?").
3. Espera la respuesta del usuario para definir qué ADRs serán necesarios.

### Fase 3: Scrum Slicing (Rol: Scrum Master)
**Skill:** `aquelarre-scrum-master`
1. Con todo el contexto claro, propón en el chat un desglose de trabajo jerárquico.
2. Muestra un borrador claro:
   - **Epic:** [Nombre]
   - **Story:** [Nombre]
   - **Tasks:** Lista de tareas técnicas (separando UI, Backend, DB si aplica).
3. Pregunta al usuario: *"¿Apruebas este desglose o deseas unificar/dividir algún task?"*
4. Espera la respuesta y ajuste del usuario.

### Fase 4: Commit & Next
1. Una vez aprobado el desglose, crea o actualiza los archivos físicos (`docs/workflow/tasks/...`, `docs/workflow/stories/...`, `docs/adr/...`, `docs/product/briefs/...`) según lo acordado.
2. Linkea todos los archivos creados.
3. Informa al usuario que la pantalla actual está procesada y guardada.
4. Solicita al usuario: *"Por favor, sube la siguiente pantalla."*

---

## Reglas Críticas

1. **NO ASUMIR:** Si algo no se ve o no es claro, usa el set de herramientas de tu rol actual para preguntar. NUNCA inventes flujos o decisiones arquitectónicas.
2. **NO EN BATCH:** Si el usuario sube varias pantallas a la vez, adviértele y analiza solo la primera. Pide que suban el resto una a una.
3. **NO GUARDAR SIN APROBACIÓN:** Los archivos `.md` de Tasks o ADRs solo se escriben en la Fase 4, nunca antes.
