# Referencia — Bitrise

## Workflow mínimo (orientativo)

```yaml
# bitrise.yml — esqueleto; ajustar según app y stacks del proyecto
format_version: '13'
default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
workflows:
  primary:
    steps:
    - activate-ssh-key@4: {}
    - git-clone@8: {}
    - flutter-installer@0:
        inputs:
        - version: stable
    - flutter-analyze@0: {}
    - flutter-test@1: {}
    - flutter-build@0:
        inputs:
        - project_location: .
        - platform: android
        - build_type: apk
```

## Evidencia Gate 2 en el task

```markdown
## 9) Evidencia
- Bitrise build #1234 → PASS
- URL: https://app.bitrise.io/build/...
- Artefacto: app-debug.apk (si aplica)
- `flutter test` local → PASS (pre-push)
```

## Áreas del skill

| Área | Responsabilidad |
|------|-----------------|
| Workflows | Steps, triggers, stacks |
| Tests en CI | Unit, widget (integration si configurado) |
| Builds | Debug, release, flavors |
| Artefactos | APK, AAB, IPA |
| Signing | Documentar; humano provee credenciales |
| Distribución | TestFlight, Play internal, Build Distribution |

## Debugging CI fallido

1. Obtener log del step que falló (MCP o UI).
2. Reproducir comando localmente si es posible.
3. Fix acotado al task; no mezclar refactors.
4. Re-trigger build; actualizar evidencia.

## Proyecto sin Bitrise aún

Checklist para Gate 1 en proyecto nuevo mobile/tablet:

- [ ] App conectada en Bitrise
- [ ] `bitrise.yml` en repo
- [ ] Al menos un workflow `primary` con test + build
- [ ] Primer build verde documentado
