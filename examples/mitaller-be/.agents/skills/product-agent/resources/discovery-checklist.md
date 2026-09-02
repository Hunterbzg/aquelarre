# Discovery Checklist — AI SDLC Factory

> **Propósito**: Guiar la sesión de discovery para asegurar cobertura completa del dominio del problema antes de generar el PRD.

---

## 1. Contexto de Negocio

- [ ] **Problema**: ¿Cuál es el problema específico que se quiere resolver?
- [ ] **Impacto**: ¿Qué pasa si NO se resuelve? (costo, tiempo, experiencia)
- [ ] **Solución actual**: ¿Cómo se resuelve hoy? ¿Por qué es insuficiente?
- [ ] **Valor esperado**: ¿Qué beneficio concreto se espera al resolver esto?
- [ ] **Métricas de éxito**: ¿Cómo se va a medir el éxito?

---

## 2. Usuarios y Stakeholders

- [ ] **Usuarios primarios**: ¿Quién va a usar el sistema directamente?
- [ ] **Usuarios secundarios**: ¿Quién se beneficia indirectamente?
- [ ] **Stakeholders**: ¿Quién toma las decisiones? ¿Quién aprueba?
- [ ] **Roles y permisos**: ¿Hay diferentes niveles de acceso?

---

## 3. Dominio y Entidades

- [ ] **Entidades principales**: ¿Cuáles son los conceptos clave del dominio?
- [ ] **Relaciones**: ¿Cómo se relacionan las entidades entre sí?
- [ ] **Estados y transiciones**: ¿Qué estados puede tener cada entidad?
- [ ] **Reglas de negocio**: ¿Qué reglas rigen el comportamiento del dominio?
- [ ] **Terminología**: ¿Hay términos específicos del dominio? (ubiquitous language)

---

## 4. Flujos y Procesos

- [ ] **Flujo principal (happy path)**: ¿Cuál es el flujo normal de trabajo?
- [ ] **Flujos alternativos**: ¿Qué variaciones del flujo existen?
- [ ] **Flujos de error**: ¿Qué puede salir mal? ¿Cómo se maneja?
- [ ] **Triggers**: ¿Qué inicia cada flujo? (usuario, sistema, evento externo)
- [ ] **Outputs**: ¿Qué produce cada flujo?

---

## 5. Integraciones Externas

- [ ] **APIs externas**: ¿Con qué servicios se necesita integrar?
- [ ] **Documentación de APIs**: ¿Hay documentación disponible?
- [ ] **Autenticación**: ¿Cómo se autentican las llamadas externas?
- [ ] **Formatos de datos**: ¿Qué formato usan (JSON, XML, etc.)?
- [ ] **Rate limits**: ¿Hay límites de llamadas?
- [ ] **SLAs**: ¿Qué tiempos de respuesta se esperan?

---

## 6. Datos y Persistencia

- [ ] **Datos a almacenar**: ¿Qué datos se necesitan persistir?
- [ ] **Volumen esperado**: ¿Cuántos registros/transacciones por día/mes?
- [ ] **Retención**: ¿Cuánto tiempo se guardan los datos?
- [ ] **Privacidad**: ¿Hay datos sensibles? ¿GDPR/regulaciones?
- [ ] **Multitenencia**: ¿Hay separación de datos por tenant/organización?

---

## 7. Seguridad y Autenticación

- [ ] **Autenticación**: ¿Cómo se autentican los usuarios? (JWT, OAuth, etc.)
- [ ] **Autorización**: ¿Qué puede hacer cada rol?
- [ ] **Row Level Security**: ¿Se necesita aislamiento de datos por tenant?
- [ ] **Encriptación**: ¿Se necesita encriptar datos en reposo o en tránsito?
- [ ] **Compliance**: ¿Hay regulaciones específicas a cumplir?

---

## 8. Requisitos No-Funcionales

- [ ] **Performance**: ¿Qué latencia es aceptable?
- [ ] **Disponibilidad**: ¿Qué uptime se requiere?
- [ ] **Escalabilidad**: ¿Cuántos usuarios concurrentes?
- [ ] **Monitoreo**: ¿Se necesitan logs, alertas, dashboards?

---

## 9. Restricciones

- [ ] **Tecnológicas**: ¿Hay restricciones de stack o infraestructura?
- [ ] **Presupuesto**: ¿Hay límite de costos de servicios?
- [ ] **Timeline**: ¿Hay fecha límite?
- [ ] **Regulatorias**: ¿Hay normas legales que cumplir?

---

## 10. Edge Cases y Escenarios Especiales

- [ ] _[Documentar cada edge case identificado durante la sesión]_

---

## Resultado de la Sesión

### Preguntas Resueltas
_[Lista de preguntas que fueron respondidas durante la sesión]_

### Preguntas Pendientes
_[Lista de preguntas que quedaron sin respuesta y requieren seguimiento]_

### Decisiones Tomadas
_[Lista de decisiones tomadas durante la sesión]_

---

> **Gate 0 — Criterio de Salida**: Todas las secciones relevantes deben estar completadas y no deben quedar preguntas ambiguas del negocio ni de las integraciones externas.
