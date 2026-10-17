# Local preview only. GitHub Pages builds the live site itself.
FROM ruby:3.3.12-slim-trixie

# Compilers for native gems in github-pages (e.g. eventmachine, commonmarker).
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential \
 && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --uid 1000 jekyll

# Gems live in the image; the site source is mounted read-only at /site.
WORKDIR /app
ENV BUNDLE_GEMFILE=/app/Gemfile
COPY Gemfile ./
RUN bundle install && chown -R jekyll:jekyll /app

USER jekyll
WORKDIR /site
EXPOSE 4000 35729

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--destination", "/tmp/_site", "--livereload", "--force_polling"]
