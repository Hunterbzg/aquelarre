import argparse
import sys
import os
import urllib.request
import urllib.error


def fetch_with_jina(url: str) -> str:
    """
    Fetches a URL using Jina Reader API (r.jina.ai).
    This is extremely fast, free, and returns LLM-optimized Markdown.
    """
    jina_url = f"https://r.jina.ai/{url}"
    print(f"[*] Fetching via Jina Reader API: {jina_url}...")

    req = urllib.request.Request(jina_url, headers={"User-Agent": "Mozilla/5.0"})
    try:
        with urllib.request.urlopen(req) as response:
            return response.read().decode("utf-8")
    except urllib.error.HTTPError as e:
        print(f"[!] Jina Reader API error: {e.code} - {e.reason}")
        sys.exit(1)
    except urllib.error.URLError as e:
        print(f"[!] Connection error: {e.reason}")
        sys.exit(1)


def fetch_with_crawl4ai(url: str) -> str:
    """
    Fetches a URL using Crawl4AI. Requires local installation.
    Use this for heavy JS sites that Jina might miss.
    """
    try:
        from crawl4ai import WebCrawler
    except ImportError:
        print("[!] Error: 'crawl4ai' is not installed.")
        print("[*] Please run: pip install crawl4ai")
        print("[*] Or use the default Jina Reader mode without --use-crawl4ai")
        sys.exit(1)

    print(f"[*] Fetching via Crawl4AI (Local Playwright): {url}...")
    crawler = WebCrawler()
    crawler.warmup()

    # crawl4ai intelligently strips navbars, footers, etc.
    result = crawler.run(url=url)

    if not result.markdown:
        print("[!] Crawl4AI did not return any markdown content.")
        sys.exit(1)

    return result.markdown


def main():
    parser = argparse.ArgumentParser(
        description="Fetch web documentation and convert to LLM-optimized Markdown."
    )
    parser.add_argument("url", help="The URL to crawl (e.g. https://docs.example.com/api)")
    parser.add_argument("-o", "--output", help="Output file path (e.g. docs/external/api.md)")
    parser.add_argument(
        "--use-crawl4ai", action="store_true", help="Use local Crawl4AI instead of Jina Reader API"
    )

    args = parser.parse_args()

    # Extract markdown
    if args.use_crawl4ai:
        markdown_content = fetch_with_crawl4ai(args.url)
    else:
        markdown_content = fetch_with_jina(args.url)

    if args.output:
        # Create directory if it doesn't exist
        os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)

        with open(args.output, "w", encoding="utf-8") as f:
            # Add a metadata header
            f.write(f"""---
source_url: {args.url}
fetch_method: {'crawl4ai' if args.use_crawl4ai else 'jina_reader'}
---

""")
            f.write(markdown_content)
        print(f"[+] Successfully saved optimized markdown to: {args.output}")
    else:
        print("\n--- BEGIN MARKDOWN ---\n")
        print(markdown_content)
        print("\n--- END MARKDOWN ---\n")


if __name__ == "__main__":
    main()
