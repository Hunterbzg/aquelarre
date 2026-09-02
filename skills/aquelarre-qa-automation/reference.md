# Referencia — QA Automation

## Herramientas por plataforma

| Plataforma | Automatización | MCP / CLI |
|------------|------------------|-----------|
| Flutter mobile | integration_test, Appium | Appium MCP, Mobile MCP, Dart MCP |
| Flutter tablet | Igual + orientaciones | Appium, simulador tablet |
| React web | Playwright, Cypress | Chrome DevTools MCP |
| API | httpx, supertest, Postman | — |

## Estructura evidencia local

```
docs/testing/evidence/
└── TASK-042-login/
    ├── 01-login-screen.png
    ├── 02-error-state.png
    └── notes.md
```

En `notes.md`: pasos, resultado, build/commit probado.

## Plantilla registro en task §9

```markdown
### QA smoke — TASK-042
- Herramienta: Appium MCP / Playwright
- Escenarios: login OK, login error, logout
- Resultado: PASS
- Evidencia: `docs/testing/evidence/TASK-042/` (local, no commitear)
- Build: Bitrise #1234 / commit abc123
```

## Reproducción de bug

1. Pasos del reporte (numerados)
2. Expected vs Actual
3. Entorno (OS, versión app, usuario/rol)
4. Captura o video del fallo
5. Test de regresión si se corrige en el mismo task

## Límites del agente

- No acceder a producción sin autorización explícita
- No commitear credenciales ni capturas con datos sensibles
- Pedir al humano dispositivo/simulador si MCP no está disponible
