# Patrones de Extracción de Documentación

> **Propósito**: Esta guía indica al agente cómo limpiar y extraer valor del Markdown generado por el script de crawling.

---

## 1. Filtrado de Ruido Residual

Aunque `Jina Reader` o `Crawl4AI` hacen un excelente trabajo limpiando HTML, a veces quedan remanentes que consumen tokens innecesarios. Al leer el Markdown descargado, omite internamente:
- Enlaces a redes sociales, legal, privacy policy.
- Índices de navegación redundantes (ej. listas gigantescas de "Table of Contents" que no aportan a la comprensión técnica).
- Comentarios promocionales de la herramienta (ej. "Sign up today!").

---

## 2. Extracción para API Contracts

Si estás documentando una API externa para que el Coding Agent la integre, extrae SOLO esto en tu resumen final (`docs/discovery/external-apis/...`):

### Autenticación
- Tipo (Bearer, API Key, Basic, OAuth).
- Headers requeridos (`Authorization: Bearer <token>`).

### Endpoints Clave
- **URL y Método** (`POST /api/v1/resource`).
- **Parámetros Requeridos** (Body, Query params).
- **Ejemplo de Payload de Éxito** (JSON).
- **Respuestas de Error Clave** (Qué devuelve si falla).

### Límites / Rate Limits
- Máximo de requests por minuto/segundo.

---

## 3. Extracción para SDKs / Librerías (Python, JS, etc.)

Si estás leyendo documentación de una librería, enfócate en:
- Comando de instalación (`pip install X`).
- Código de Inicialización / Configuración básica.
- Snippets de código de los 2-3 casos de uso principales.

**Ignora:**
- Changelogs antiguos.
- Instrucciones de contribución (Contributing).
- Detalles internos del código fuente de la librería.
