# neartrace-web

Marketing site + landing page + privacy policy for **NearTrace**, served at https://neartrace.app via GitHub Pages.

NearTrace is an Android BLE network-discovery tool developed at HARTLE.TECH. The Android app source lives at https://github.com/code-hartle-tech/neartrace-android-mvp; the public documentation lives at https://docs.neartrace.app (source: https://github.com/code-hartle-tech/neartrace-docs).

## What's in this repo

| File | Role |
|---|---|
| `index.html` | Landing page served at `neartrace.app` |
| `style.css` | Page styles |
| `logo.svg` | Brand mark |
| `install.sh` | Bootstrap installer fetched via `curl -fsSL https://neartrace.app/install.sh \| bash` |
| `privacy/` | Privacy-policy HTML (linked from Play Store listing) |
| `CNAME` | Tells GitHub Pages which custom domain to bind |

## How it deploys

GitHub Pages, source = `main` branch root. Pushing to `main` triggers Pages to build + deploy within ~1 minute. The custom domain (`neartrace.app`) is enforced by the `CNAME` file at repo root + 4 CF DNS A records pointing at GH Pages' anycast IPs (managed in `hartle.tech-terraform/neartrace_dns.tf`).

## Local preview

Pure static — open `index.html` in a browser, or run any static server (`python3 -m http.server 8000`) and visit `http://localhost:8000`.

## License + funding

Apache 2.0 (see `LICENSE`) + NOTICE preservation requirement (`NOTICE`). Donation channels (when active) listed at `.github/FUNDING.yml`.

## Contact

contact@hartle.tech
