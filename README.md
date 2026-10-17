# Course Materials site

Bilingual (Greek / English) Jekyll site on GitHub Pages where students download course material. See [PLAN.md](PLAN.md) for the full plan.

## Structure
- `_data/classes.yml`: classes S2–S7 and the subjects taught in each
- `_data/subjects.yml`: subjects BIO, ISC, STS, GEO with their Greek and English names
- `_data/materials.yml`: one entry per downloadable file
- `_announcements/`: one file per announcement, with both languages inside
- `_data/i18n.yml`: UI strings for `el` and `en`
- `materials/<class>/<subject>/`: the files themselves
- `el/`, `en/`: one page per class per language; pages share a `ref` so the language switch can find each other
- `index.html`: redirects to the default language (`default_lang` in `_config.yml`)

## Adding material
1. Upload the file to `materials/<class>/<subject>/`.
2. Copy an entry in `_data/materials.yml` and change its fields.

## Adding an announcement
Copy `_announcements/2026-10-17-welcome.md` to `_announcements/YYYY-MM-DD-short-name.md` (the date comes from the file name), then edit the `title` and the `el` / `en` text. The 3 newest appear on the home page, and all of them appear at `/<lang>/announcements/`.

## Adding a subject
Add it to `_data/subjects.yml`, then add its slug to `subjects:` for each class that has it in `_data/classes.yml`.

## Adding a class
1. Add it to `_data/classes.yml`.
2. Copy `el/s4.md` and `en/s4.md`, then change `title`, `class`, `ref` and `permalink`.

## Configuration
In `_config.yml`, set `baseurl` to `"/<repo-name>"` for a project repo, or `""` for a user site or custom domain.

## Run locally
With Docker (recommended; no Ruby needed):
```sh
docker compose up --build    # open http://localhost:4000/SEEH/ — reloads on save
docker compose down          # stop
```
The source is mounted read-only and the site is built inside the container, so nothing is written to the repo. Rebuild the image (`--build`) only after changing the `Gemfile`. After editing `_config.yml`, restart with `docker compose up -d --force-recreate`, because Jekyll doesn't reload it.

With Ruby:
```sh
bundle install
bundle exec jekyll serve   # http://localhost:4000/<baseurl>/
```

## Deploy
Push to GitHub, then go to Settings → Pages → *Deploy from branch* `main` / root.
