# PRD Template — AI SDLC Factory

> **Instrucciones**: Rellenar todas las secciones. Eliminar placeholders y notas de instrucción antes de finalizar.

---

# Product Requirements Document (PRD)

**Proyecto**: [Nombre del Proyecto]
**Versión**: v1
**Fecha**: [YYYY-MM-DD]
**Autor**: Product Agent
**Estado**: Draft / In Review / Approved

---

## 1. Resumen Ejecutivo

_Descripción breve del producto/feature y el problema que resuelve. 2-3 oraciones._

---

## 2. Problema

### 2.1 Contexto del Problema
_¿Qué problema existe actualmente? ¿Quién lo sufre? ¿Cuánto cuesta (tiempo, dinero, experiencia)?_

### 2.2 Solución Actual (As-Is)
_¿Cómo se resuelve actualmente? ¿Por qué es insuficiente?_

---

## 3. Visión y Objetivos

### 3.1 Visión del Producto
_Una oración que describe el estado futuro deseado._

### 3.2 Objetivos Medibles

| # | Objetivo | Métrica de Éxito | Target |
|:---|:---|:---|:---|
| O1 | _[Objetivo]_ | _[Cómo se mide]_ | _[Valor target]_ |
| O2 | | | |

---

## 4. Usuarios y Personas

| Persona | Rol | Necesidades Principales | Pain Points |
|:---|:---|:---|:---|
| _[Nombre]_ | _[Rol]_ | _[Qué necesita]_ | _[Qué le frustra]_ |

---

## 5. Features y Requisitos Funcionales

### Priorización MoSCoW

#### Must Have (P0) — Esenciales para MVP
| ID | Feature | Descripción | Criterio de Aceptación |
|:---|:---|:---|:---|
| F-001 | _[Feature]_ | _[Descripción]_ | _[Cómo se verifica]_ |

#### Should Have (P1) — Importantes pero no bloqueantes
| ID | Feature | Descripción | Criterio de Aceptación |
|:---|:---|:---|:---|
| F-NNN | | | |

#### Could Have (P2) — Deseables si hay capacidad
| ID | Feature | Descripción | Criterio de Aceptación |
|:---|:---|:---|:---|
| F-NNN | | | |

#### Won't Have (P3) — Fuera de alcance para este ciclo
| ID | Feature | Razón de Exclusión |
|:---|:---|:---|
| F-NNN | | |

---

## 6. Requisitos No-Funcionales

| Categoría | Requisito | Target |
|:---|:---|:---|
| **Performance** | _[ej. Latencia de respuesta]_ | _[ej. < 500ms p95]_ |
| **Seguridad** | _[ej. Autenticación]_ | _[ej. JWT + RLS]_ |
| **Disponibilidad** | _[ej. Uptime]_ | _[ej. 99.9%]_ |
| **Escalabilidad** | _[ej. Usuarios concurrentes]_ | _[ej. 1000]_ |
| **Mantenibilidad** | _[ej. Cobertura de tests]_ | _[ej. ≥ 85%]_ |

---

## 7. Dependencias Externas

| Dependencia | Tipo | Descripción | Riesgo |
|:---|:---|:---|:---|
| _[Servicio/API]_ | _[API/Library/Service]_ | _[Qué hace]_ | _[Alto/Medio/Bajo]_ |

---

## 8. Restricciones y Supuestos

### Restricciones
- _[Restricciones técnicas, de negocio o regulatorias]_

### Supuestos
- _[Supuestos que se asumen como verdaderos]_

---

## 9. Fuera de Alcance

- _[Items explícitamente excluidos de este ciclo]_

---

## 10. Aprobación

| Rol | Nombre | Fecha | Estado |
|:---|:---|:---|:---|
| Product Owner | _[Usuario]_ | _[Fecha]_ | ⬜ Pending / ✅ Approved |

---

> **Quality Gate 1a**: Este documento debe ser aprobado antes de proceder con la fase de Arquitectura.
