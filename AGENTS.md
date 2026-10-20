# Marketplace

Rails 8.1 app. Ruby is `3.4.7` (`.ruby-version`; keep the Dockerfile `RUBY_VERSION` in sync). PostgreSQL. Yarn, not npm.

## Commands

- Setup without a server: `bin/setup --skip-server` (devcontainer `postCreateCommand`). Plain `bin/setup` also execs `bin/dev`.
- App processes: `bin/dev` (Foreman, `Procfile.dev`: Rails on `PORT` default 3000, `yarn build --watch`, `yarn build:css --watch`, Sidekiq). It passes `--env /dev/null`, so Foreman does not load `.env`. `dotenv-rails` still loads `.env` inside Rails.
- Lint: `bin/rubocop` (rubocop-rails-omakase only).
- Security, same as CI: `bin/brakeman --no-pager`, `bin/bundler-audit`.
- New tests are RSpec. Generators use `:rspec` and FactoryBot. `.rspec` requires `rails_helper`, spec type is inferred from the file path, and FactoryBot syntax methods load from `spec/support`. One file: `bundle exec rspec spec/models/foo_spec.rb`.
- CI runs RSpec: `bin/rails db:test:prepare && bundle exec rspec`. `config/ci.rb` runs `bundle exec rspec`. The `minitest` gem stays because Rails depends on it.

## Environment

- This workspace uses `.devcontainer/compose.yaml` (service `rails-app`, plus `postgres`, Valkey as `redis`, `selenium`). It is not the root `docker-compose.yml`.
- Root `docker-compose.yml` is a separate stack (Memcached, Valkey, Postgres) and uses the same Compose project name, `marketplace`.
- Devcontainer env: `DB_HOST=postgres`, `REDIS_URL=redis://redis:6379/1`, `SELENIUM_HOST=selenium`, `CAPYBARA_SERVER_PORT=45678`. No `MEMCACHED_URL`.
- `CORS_ORIGIN` is one full browser origin. Blank or unset allows none. It is not a host allowlist and does not share the session cookie.
- Production error pages are the static files in `public/`. They must not include exception text. Operators find the failure from the request id in STDOUT. Development still shows the debug page.
- `config/database.yml` sets host, user, and password only when `DB_HOST` is set (`postgres` / `postgres`). Otherwise Rails uses a local socket and the OS user. Databases: `marketplace_development`, `marketplace_test`. The Postgres image does not create those; `bin/rails db:prepare` does.
- Development cache store defaults to `memcached:11211`. That hostname exists only on the root Compose network. Caching stays off unless `tmp/caching-dev.txt` exists.
- Sidekiq is started by `bin/dev` and reads `REDIS_URL` (code default `redis://localhost:6379/0`). `config.active_job.queue_adapter` is never set to `:sidekiq`, so Active Job does not reach that process. Development Action Cable is `async`. Production Cable uses `REDIS_URL`, or `redis://localhost:6379/1` if unset.
- System tests: with `CAPYBARA_SERVER_PORT` set, Capybara is served as host `rails-app` against remote Selenium. Without it, local headless Chrome. CI does not set those vars. CI sets `DATABASE_URL=postgres://postgres:postgres@localhost:5432`.

## App

- Auth is the Rails generator, not Devise. Column is `email_address` (strip + downcase), `has_secure_password`. Session is a signed `session_id` cookie. `ApplicationController` requires authentication unless `allow_unauthenticated_access`. It also sets `allow_browser versions: :modern`.
- There is no `root` route. `after_authentication_url` falls back to `root_url`.
- `Product` slugs use FriendlyId (`friendly_id :title, use: :slugged`). Global finders are off: `Product.friendly.find`, not `Product.find`. Thumbnail is Active Storage (`has_one_attached :thumbnail`). `product_images` is timestamps only.
- Money columns are `decimal` precision 10 scale 2, not integer cents.
- Hashes are `jsonb` (`products.metadata`, `product_variants.options`). String lists are Postgres arrays and need `array: true` (`product_options.values`, fulfillment tracking columns). `t.string ..., default: []` without `array: true` is invalid.
- Database foreign keys exist only for `sessions.user_id` and `shipping_options.shipping_option_type_id`. Other `belongs_to` columns are indexes only.
- Table name is `shipping_option_types` (two p's). The type id lives on `shipping_options`. The models do not match that: `ShippingOption` declares `has_one :type`, and `ShippingOptionType` belongs to a `shipping_option_id` column that is not in the schema.
- `Cart` `has_many :line_items` (`LineItem`). There is no `CartLineItem`. Lines and totals are maintained through `Cart`.
- Pundit is installed. `ApplicationPolicy` denies by default and is not included in `ApplicationController`.
- Schema source is `db/schema.rb`. Change migrations, then let Rails dump the schema. Deploy with Kamal (`bin/kamal`, `config/deploy.yml`); the production image is the root `Dockerfile`, not Compose.
- Kubernetes: chart at `helm/marketplace`. Thruster listens on `HTTP_PORT` 8080. `helm upgrade --install marketplace ./helm/marketplace --set rails.masterKey=$RAILS_MASTER_KEY --set image.repository=<registry>/marketplace --set image.tag=<tag>`.

## Agent skills

### Issue tracker

GitHub Issues on dambar08/marketplace. See `docs/agents/issue-tracker.md`.

### Triage labels

Default roles: needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: root `GLOSSARY.md` and `docs/adr/`. See `docs/agents/domain.md`.
