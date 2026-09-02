# Referencia — Doc Crawler

## Script

Ubicación tras instalar Aquelarre:

- Cursor: `.cursor/skills/aquelarre-doc-crawler/scripts/crawl_doc.py`
- Antigravity: `.agents/skills/aquelarre-doc-crawler/scripts/crawl_doc.py`

## Uso

```bash
# Jina Reader (default, sin deps extra)
python <ruta-skill>/scripts/crawl_doc.py "https://docs.example.com" \
  -o docs/discovery/external-apis/example.md

# Crawl4AI (SPAs pesadas)
pip install -r <ruta-skill>/requirements.txt
python <ruta-skill>/scripts/crawl_doc.py "https://..." --use-crawl4ai -o docs/...
```

## Salida

El script añade frontmatter:

```yaml
---
source_url: https://...
fetch_method: jina_reader | crawl4ai
---
```

## Buenas prácticas

- Una URL o sección por archivo; nombre descriptivo (`stripe-payments.md`)
- Carpeta `docs/discovery/external-apis/` en `.gitignore` solo si el contenido es enorme y regenerable (por defecto **versionar**)
- Resumir en DISCOVERY/ADR; no duplicar todo el markdown en el task
- Limitar profundidad: quickstart + auth + endpoints relevantes al scope

## Modo avanzado (resumen manual)

Si el archivo supera ~8k líneas, crear `example-api-summary.md` con:

- Base URL, auth, endpoints usados por el proyecto
- Link al archivo completo archivado

## Dependencias opcionales

`requirements.txt` del skill: `crawl4ai` (solo para `--use-crawl4ai`).
