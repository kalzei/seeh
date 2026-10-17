# AGENTS.md

Guidance for AI coding agents working on this repo. For humans: see [README.md](README.md). Roadmap: [PLAN.md](PLAN.md).

## What this is
A static, bilingual (Greek `el` / English `en`) Jekyll site on **GitHub Pages**. A secondary school teacher uses it to publish course material (PDF, DOCX, PPTX…) and announcements for students. Classes S2–S7 each have the subjects BIO, ISC, STS and GEO.

## Hard constraints
- **GitHub Pages default build:** Jekyll 3.10 via the `github-pages` gem. Use only [whitelisted plugins](https://pages.github.com/versions/) and no custom Ruby plugins. Liquid features must work on Jekyll 3.10.
- **Everything is public.** Never add student personal data, grades, private answer keys, secrets or credentials.
- **File limits:** under 100 MB per file (ideally under 25 MB so it can be uploaded in the browser); the repo should stay under 1 GB.
- **No JavaScript frameworks or build tools.** Plain HTML, Liquid, SCSS and vanilla JS only.
- All URLs in templates go through `| relative_url`, because `baseurl` (`/SEEH`) is not `/`.

## Layout
| Path | Purpose |
|---|---|
| `_config.yml` | `baseurl`, `default_lang`, `languages`, the `announcements` collection, excludes, per-folder `lang` defaults |
| `_data/i18n.yml` | UI strings. **Every key must exist in both `el` and `en`.** |
| `_data/subjects.yml` | Subjects: `slug`, `code`, localized `name` |
| `_data/classes.yml` | Classes: `slug`, localized `name`, `subjects` (list of subject slugs) |
| `_data/materials.yml` | One entry per downloadable file; single source of truth |
| `_announcements/` | Collection with `output: false`. File name `YYYY-MM-DD-name.md` sets the date; front matter has `title: {el, en}`, `el:`, `en:` (Markdown) |
| `materials/<class>/<subject>/` | The files; path must match `file:` in `materials.yml` |
| `el/`, `en/` | Pages per language. Twin pages share `ref:`, which drives the language switch and `hreflang` |
| `_layouts/` | `default` (shell), `home`, `class`, `announcements` |
| `_includes/` | `header`, `footer`, `lang-switch`, `material-card`, `announcement` (falls back to `default_lang` if a translation is missing) |
| `assets/css/style.scss` | Mobile-first CSS; colors are tokens on `:root`. The full-page background is `body::before` (fixed), with content on a semi-opaque `main` panel |
| `assets/images/banner.jpeg` | Full-page background image. No logo is used, by owner's choice |
| `index.html` | Redirects to `/<default_lang>/` |

## Conventions
- Localized fields are maps: `title: { el: "...", en: "..." }`, read with `item.title[page.lang]`.
- Slugs are lowercase (`s4`, `bio`) and are used in URLs, `materials.yml` and folder names.
- A new class needs: an entry in `classes.yml`, plus `el/<slug>.md` and `en/<slug>.md` with `layout: class`, `class`, `ref`, `permalink: /<lang>/<slug>/`.
- A new UI string goes in both languages in `i18n.yml`.
- Accessibility: semantic HTML, visible focus, `lang` attributes, and download links that include the item title for screen readers.
- Non-site files (docs, Docker) must be listed in `exclude:` in `_config.yml` so they aren't published.

## Test locally
```sh
docker compose up --build        # http://localhost:4000/SEEH/ (live reload)
docker compose down
```
`jekyll serve` does not reload `_config.yml`; after changing it, run `docker compose up -d --force-recreate`. The container mounts the source read-only and builds into `/tmp/_site` inside the container, so it never writes to the repo. A one-off build to check for errors:
```sh
docker compose run --rm site bundle exec jekyll build --destination /tmp/_site
```
After changes, check both `/el/` and `/en/`, a class page, a download, and the language switch.

## Agent rules
- Do not run git commands that change the working tree or history (commit, checkout, pull, fetch…). The owner handles git.
- Never read `.env` files or other secrets.
- Keep `README.md`, `AGENTS.md` and `PLAN.md` in sync with structural changes.
