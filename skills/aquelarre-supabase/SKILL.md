---
name: aquelarre-supabase
description: Gestiona cambios de auth, RLS, storage y edge functions en Supabase dentro del workflow Aquelarre. Usa este skill cuando el task afecte permisos, seguridad o integraciones Supabase.
---

# Supabase

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (SUPA + reglas G1-SUPA)
- Template Apéndice L (SUPA)
- MCP Supabase (si esta configurado en el IDE del proyecto)

## Objetivo

Disenar y verificar cambios de seguridad e infra Supabase con pasos reproducibles y evidencia para gates.

## Inputs

- Task con `surface=auth` o `db_change` en `rls_policy`, `storage`, `schema` (coordinar con skill database).
- Reglas esperadas de roles y permisos.
- Alcance de edge functions, storage buckets o triggers.

## Outputs

- Documento `docs/supabase/SUPA-<id>-<slug>.md` o seccion equivalente en el task.
- Matriz actor → permiso → resultado esperado.
- Pasos reproducibles de validacion.
- Evidencia de pruebas positivas/negativas para Gate 2.

## Gates que aplica

- **Gate 1 (G1-SUPA-001):** roles/permisos definidos si `rls_policy` o `auth`.
- Coordinacion con **G1-ADR-001** cuando el cambio es estructural o de seguridad.

## Instrucciones

1. Describir alcance: tablas, buckets, functions, entornos (local/stage/prod).
2. Para **RLS / auth**, documentar:
   - actor o rol
   - operacion (SELECT, INSERT, UPDATE, DELETE, storage)
   - permitido vs denegado (casos positivos y negativos)
3. Para **edge functions**: autenticacion, validacion de input, rate limits, secretos.
4. Para **storage**: paths, policies, signed URLs, tamano y tipos MIME si aplica.
5. Orden sugerido: migracion SQL → policies → verificacion → deploy function.
6. Registrar pruebas en TEST plan o seccion 9 del task.
7. Linkear SUPA desde el task antes de avanzar gate.
8. Usar MCP Supabase para consultar estado cuando este disponible; documentar comandos o queries usados.

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Cambio Supabase | `docs/supabase/SUPA-<id>-<slug>.md` |
| Migraciones | `supabase/migrations/` (convencion del proyecto) |
| Template | Apéndice L del `AI_WORKFLOW_SKILLS_SPEC.md` |

## Coordinacion

- Cambios de **schema** puro → coordinar con `aquelarre-database-postgres`.
- Cambios con **impacto arquitectonico** → coordinar con `aquelarre-architecture-adr`.
