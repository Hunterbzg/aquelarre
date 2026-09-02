---
name: aquelarre-bitrise
description: Gestiona CI/CD Flutter en Bitrise. Usa este skill cuando platform sea mobile o tablet, ci=bitrise, o haga falta configurar workflows, builds, tests en pipeline, signing o evidencia Gate 2 desde Bitrise.
---

# Bitrise (CI/CD móvil / tablet)

Fuentes:

- `docs/VISION.md` — sección 3.4 (Bitrise en el stack)
- `reference.md` — workflows, MCP, evidencia
- MCP Bitrise en el entorno del agente (cuando esté disponible)

## Objetivo

Asegurar que proyectos Flutter tengan pipeline Bitrise funcional y evidencia verificable para Gate 2.

## Inputs

- Task con `platform: mobile|tablet` o `ci: bitrise`.
- Repo con app Flutter (`pubspec.yaml`, `android/`, `ios/`).
- Cuenta Bitrise del proyecto (app conectada).

## Outputs

- `bitrise.yml` (o actualización) con workflow mínimo: analyze + test + build.
- Evidencia en task: build PASS, número de build, link, artefacto si aplica.
- Notas de signing/distribución cuando `risk=high` o release.

## Gates que aplica

- **Gate 1 (proyecto nuevo):** `bitrise.yml` con workflow mínimo.
- **Gate 2:** build Bitrise PASS linkeado en task (o override justificado).

## Instrucciones

1. Verificar que la app esté registrada en Bitrise o documentar pasos para el humano.
2. Workflow mínimo recomendado:
   - `flutter pub get`
   - `dart analyze` / `flutter analyze`
   - `flutter test`
   - `flutter build apk` o `appbundle` / `ios` según plataforma
3. Usar stacks oficiales Flutter/Android/iOS según targets del proyecto.
4. Para Gate 2: consultar build vía MCP Bitrise o link manual; registrar PASS/FAIL en task §9.
5. Code signing y distribución (TestFlight, Play internal): solo con credenciales del humano; documentar, no inventar secretos.
6. Si el build falla: extraer logs, proponer fix acotado al task, re-ejecutar pipeline.

## Cuándo usar MCP Bitrise

| Acción | MCP |
|--------|-----|
| Listar builds recientes | Sí |
| Obtener logs de build fallido | Sí |
| Disparar rebuild | Con aprobación humana |
| Modificar secrets/certificados | No — delegar al humano |

## Coordinación

| Necesidad | Skill |
|-----------|-------|
| Tests locales antes de CI | `aquelarre-testing` |
| Implementación Flutter | `aquelarre-dev-flutter` |
| PR / merge | `aquelarre-github` |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Config CI | `bitrise.yml` (raíz del proyecto) |
| Evidencia | Task §9 + link build Bitrise |
