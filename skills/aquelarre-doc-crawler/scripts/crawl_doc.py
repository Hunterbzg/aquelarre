import argparse
import os
import sys
import urllib.error
import urllib.request


def fetch_with_jina(url: str) -> str:
    """Fetch URL via Jina Reader API (LLM-optimized Markdown)."""
    jina_url = f"https://r.jina.ai/{url}"
    print(f"[*] Fetching via Jina Reader: {jina_url}...")
    req = urllib.request.Request(jina_url, headers={"User-Agent": "Mozilla/5.0"})
    try:
        with urllib.request.urlopen(req) as response:
            return response.read().decode("utf-8")
    except urllib.error.HTTPError as e:
        print(f"[!] Jina error: {e.code} - {e.reason}")
        sys.exit(1)
    except urllib.error.URLError as e:
        print(f"[!] Connection error: {e.reason}")
        sys.exit(1)


def fetch_with_crawl4ai(url: str) -> str:
    try:
        from crawl4ai import WebCrawler
    except ImportError:
        print("[!] Install: pip install -r requirements.txt (crawl4ai)")
        sys.exit(1)
    print(f"[*] Fetching via Crawl4AI: {url}...")
    crawler = WebCrawler()
    crawler.warmup()
    result = crawler.run(url=url)
    if not result.markdown:
        print("[!] Crawl4AI returned no markdown")
        sys.exit(1)
    return result.markdown


def main() -> None:
    parser = argparse.ArgumentParser(description="Fetch docs as LLM-optimized Markdown")
    parser.add_argument("url", help="URL to fetch")
    parser.add_argument("-o", "--output", help="Output file path")
    parser.add_argument("--use-crawl4ai", action="store_true", help="Use Crawl4AI instead of Jina")
    args = parser.parse_args()

    content = fetch_with_crawl4ai(args.url) if args.use_crawl4ai else fetch_with_jina(args.url)
    header = f"---\nsource_url: {args.url}\nfetch_method: {'crawl4ai' if args.use_crawl4ai else 'jina_reader'}\n---\n\n"

    if args.output:
        out_dir = os.path.dirname(os.path.abspath(args.output))
        if out_dir:
            os.makedirs(out_dir, exist_ok=True)
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(header + content)
        print(f"[+] Saved: {args.output}")
    else:
        print("\n--- MARKDOWN ---\n")
        print(header + content)


if __name__ == "__main__":
    main()
