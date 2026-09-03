# Maestro — patrones

## Flow mínimo

```yaml
# maestro/login-happy.yaml
appId: com.example.app
---
- launchApp
- tapOn: { id: "login.email" }
- inputText: "user@example.com"
- tapOn: { id: "login.password" }
- inputText: "password-test"
- tapOn: { id: "login.submit" }
- assertVisible: { id: "home.screen" }
```

## Caso borde (explore)

```yaml
# maestro/login-empty.yaml
appId: com.example.app
---
- launchApp
- tapOn: { id: "login.submit" }
- assertVisible: "El correo es obligatorio"
```

## Debug (un solo archivo)

Reproducir el ticket; `takeScreenshot` en el paso que falla:

```yaml
- tapOn: { id: "profile.save" }
- takeScreenshot: profile-save-empty
- assertVisible: "Nombre requerido"
```

Copiar PNG a `docs/testing/evidence/<id>/` (no versionar).

## Suite

```yaml
# maestro/config.yaml
flows:
  - login-*.yaml
  - orders-*.yaml
```

```bash
maestro test maestro/
maestro test maestro/login-empty.yaml
```

## Reglas

- Un flujo de usuario por archivo.
- IDs, no coordenadas.
- No `waitForAnimationToEnd` eterno ni sleeps largos; Maestro espera visibilidad.
- Datos de test en env (`${EMAIL}`) — no secrets en el YAML commiteado.
