---
name: mitaller-supabase
description: Gestiona cambios de auth, RLS, storage y edge functions en Supabase dentro del workflow. Usa este skill cuando el task afecte permisos, seguridad o integraciones Supabase.
---

# Supabase

Fuentes:

- `docs/AI_WORKFLOW_SKILLS_SPEC.md` (SUPA + reglas G1-SUPA)
- `docs/UI_UX_SUPABASE_CODING_PRACTICES.md`
- `supabase/functions/create-workshop-user/README.md`

## Inputs

- Task con `surface=auth` o `db_change=rls_policy|storage`.
- Reglas esperadas de roles/permisos.
- Alcance de edge functions o storage.

## Outputs

- Definicion de politicas/permisos esperados.
- Pasos reproducibles de validacion.
- Evidencia de seguridad funcional para gates.

## Instrucciones

1. Si hay RLS/auth, describir claramente:
   - actor/rol
   - permiso esperado
   - denegaciones esperadas
2. Para edge functions, validar autenticacion y limites de seguridad.
3. Registrar pruebas positivas y negativas (permitido/denegado).
4. Linkear todo en el task antes de avanzar gate.
