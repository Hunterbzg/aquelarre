---
name: aquelarre-doc-crawler
description: Extrae documentacion de APIs o sitios web externos a Markdown optimizado para LLM. Usa este skill al integrar APIs de terceros, durante discovery, o cuando el usuario provea una URL de documentacion para archivar en el proyecto.
---

# Doc Crawler

Fuentes:

- `scripts/crawl_doc.py` — extracción (Jina Reader por defecto)
- `reference.md` — uso, salidas, limites

## Objetivo

Descargar documentación externa, limpiarla y guardarla en el repo para que otros skills (discovery, dev-fastapi, supabase) la consuman sin repetir HTTP ni saturar contexto.

## Inputs

- URL(s) de documentación proporcionadas por el humano
- Contexto: qué API o proveedor se integra (opcional)

## Outputs

- Markdown en `docs/discovery/external-apis/<nombre>-<slug>.md`
- Frontmatter con `source_url` y método de fetch
- Referencia linkeada desde DISCOVERY, ADR o TASK

## Cuándo invocar

| Situación | Acción |
|-----------|--------|
| Integrar API de terceros | Crawl quickstart / auth / endpoints |
| Discovery con dependencia externa | Archivar docs antes de ADR |
| Usuario: "lee esta URL de docs" | Crawl + resumen si es muy largo |

## Instrucciones

1. Confirmar URL y alcance (una página vs sección; evitar crawl infinito del sitio).
2. Ejecutar desde la raíz del proyecto consumidor:

```bash
python .cursor/skills/aquelarre-doc-crawler/scripts/crawl_doc.py "https://docs.example.com/api" \
  -o docs/discovery/external-apis/example-api.md
```

(Antigravity: `.agents/skills/aquelarre-doc-crawler/...`)

3. Si Jina falla en SPA pesada, opción `--use-crawl4ai` (requiere `pip install -r requirements.txt` del skill).
4. Revisar output: eliminar ruido residual si hace falta (ver `reference.md`).
5. Linkear desde discovery, ADR o TASK; **no** pegar HTML crudo en el chat.
6. No commitear credenciales ni tokens que aparezcan en docs públicas.

## Coordinación

| Skill | Rol |
|-------|-----|
| `aquelarre-discovery` | Consume docs archivadas |
| `aquelarre-architecture-adr` | Decisiones de integración |
| `aquelarre-dev-fastapi` | Implementar cliente HTTP |

## Artefactos

| Artefacto | Ruta |
|-----------|------|
| Doc externa | `docs/discovery/external-apis/<nombre>.md` |
| Script | `scripts/crawl_doc.py` (en carpeta del skill instalado) |
