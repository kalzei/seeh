# PLAN: Teacher course-material website on GitHub Pages

Stack: **Jekyll** (built natively by GitHub Pages). Files are **stored in the repo**. The site is **bilingual (Greek + English)** and **publicly accessible**.

## 1. Goal
A static, mobile-friendly, bilingual (EL/EN) website on GitHub Pages where students:
- browse by **class/grade → subject → unit**
- download material (PDF, DOCX, PPTX, ZIP, images)
- see what's new (latest uploads) and read announcements

The teacher adds material with **no coding**: drop the file into a folder and add a few lines of YAML, either through the GitHub web UI or locally.

## 2. Constraints (GitHub Pages)
- Everything is public. Never upload student personal data, grades, or answer keys meant to stay private.
- Files must be under 100 MB each (and ideally under 25 MB so they can be uploaded in the browser). Keep the repo under 1 GB and the published site under 1 GB. Soft bandwidth limit: 100 GB/month.
- Only whitelisted Jekyll plugins can run in the default build. If a custom plugin is ever needed, switch to a GitHub Actions build.

## 3. Repository structure
```
/
├── _config.yml            # site title, languages, baseurl, defaults
├── _data/
│   ├── i18n.yml           # UI strings: el / en
│   ├── subjects.yml       # subjects BIO, ISC, STS, GEO (code + el/en names)
│   ├── classes.yml        # classes S2–S7 → subject slugs
│   └── materials.yml      # list of downloadable items (single source of truth)
├── _layouts/              # default, home, class, announcements
├── _includes/             # header, footer, lang-switch, material-card, announcement
├── _announcements/        # YYYY-MM-DD-name.md, el + en text in one file (collection, output: false)
├── assets/css/style.scss  # minimal custom CSS (or theme overrides)
├── assets/js/filter.js    # optional client-side search/filter (vanilla JS)
├── materials/<class>/<subject>/<file>   # the actual files
├── el/index.md, en/index.md            # localized home pages
├── el/<class>.md, en/<class>.md        # per-class pages (layout: class)
├── index.html             # redirects to /el/ (default language)
├── 404.html
├── Gemfile                # github-pages gem, for local preview
├── Dockerfile, compose.yaml  # local preview container
├── AGENTS.md              # guidance for AI agents
├── README.md              # how to run locally
└── TEACHER_GUIDE.md       # step-by-step "how to add material" (Greek)
```

## 4. Data model (`_data/materials.yml`)
```yaml
- id: alg-a-ch1-notes
  class: a-lykeiou
  subject: algebra
  unit: 1
  title: { el: "Σημειώσεις Κεφ. 1", en: "Chapter 1 notes" }
  description: { el: "...", en: "..." }
  file: /materials/a-lykeiou/algebra/ch1-notes.pdf
  type: pdf            # drives the icon
  date: 2026-10-17
```
- `classes.yml` defines class slugs, localized names, and their subjects.
- Class pages use Liquid `where`/`group_by` to list materials grouped by subject → unit, sorted by date.
- The home page shows the latest N items and the latest announcements.

## 5. Bilingual approach (no plugin)
- Use `/el/...` and `/en/...` page trees with `lang` set in front matter (via `defaults` in `_config.yml`).
- UI strings come from `site.data.i18n[page.lang]`. Material titles come from `item.title[page.lang]`.
- The language switch links to the same page in the other tree (via a `ref` front-matter key shared by both versions).
- Set `<html lang="{{ page.lang }}">` and add `hreflang` alternate links.

## 6. UI and UX
- Use a light theme (Minima, or `just-the-docs` via `remote_theme` for built-in sidebar and search) with school colors and a logo.
- Material card: file-type icon, title, description, size, date, and a **Download** button (`<a href download>`).
- Optional `filter.js`: a text filter over items on the class page.
- Accessibility: semantic HTML, sufficient contrast, keyboard navigation, alt text.
- Mobile first, since students will mostly use phones.

## 7. Teacher workflow (documented in TEACHER_GUIDE.md)
1. On github.com, open `materials/<class>/<subject>/` → *Add file → Upload files*.
2. Edit `_data/materials.yml` → copy an existing entry, change the fields, commit.
3. Wait about 1 minute for Pages to rebuild, then check the site.
4. Announcements: add a file under `_announcements/` (copy an existing one).

## 8. Deployment
1. Create the GitHub repo (e.g. `<username>.github.io` for a root URL, or `teacher-site` → `/teacher-site/`, in which case set `baseurl`).
2. Settings → Pages → Source: *Deploy from branch* `main` / root.
3. Optional custom domain: add a `CNAME` file and a DNS CNAME record, and enable *Enforce HTTPS*.
4. Local preview: `bundle install && bundle exec jekyll serve`.

## 9. Quality checks
- GitHub Action (optional): run `htmlproofer` on the built site to catch broken download links.
- A small script/Action that checks every `file:` in `materials.yml` exists and that every file in `materials/` is listed.
- Manual check: both languages, the mobile view, and downloads of each file type.

## 10. Milestones
1. ✅ Scaffold: config, layouts, i18n, sample PDFs (deploy pending: owner pushes).
2. ✅ All classes/subjects (S2–S7 × BIO/ISC/STS/GEO), home page "latest", announcements.
3. Styling and accessibility pass, then the 404 page.
4. TEACHER_GUIDE.md, link checker Action.
5. Optional: search/filter, custom domain, analytics (privacy-friendly, e.g. GoatCounter, no cookies).

## 11. Open questions for the teacher
- List of classes and subjects, school name and logo, and the preferred default language.
- Whether a custom domain is wanted.
