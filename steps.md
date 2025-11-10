### Chronological setup steps

#### 1) Database setup (PostgreSQL)
- Ensured Postgres is running locally.
- Prepared development and test databases:

```bash
cd /Users/shafia/Documents/application_tracker
bin/rails db:prepare
```

Optional explicit sequence:
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

#### 2) Add Bootstrap (Rails 8 + Propshaft, no Node)
- Edited layout `app/views/layouts/application.html.erb`:
  - Added Bootstrap CSS CDN in `<head>`:
    - `<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">`
  - Switched to load our asset stylesheet:
    - `<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>`
  - Added Bootstrap JS bundle before `</body>`:
    - `<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>`
  - Wrapped page content:
    - `<div class="container py-3"> ... </div>`
- CSP note: `config/initializers/content_security_policy.rb` remains commented (no changes required for CDN use).

#### 3) Create landing page
- Controller: `app/controllers/pages_controller.rb` with `home` action.
- Route: set root in `config/routes.rb` → `root "pages#home"`.
- View: `app/views/pages/home.html.erb` using Bootstrap classes:
  - Headline: “Welcome to Application Tracker”
  - Buttons and an info alert to verify Bootstrap styling/JS.

#### 4) Add Devise authentication
- Gem:
  - Updated `Gemfile`: `gem "devise"`
  - Installed:
    ```bash
    bundle install
    ```
- Generators:
  ```bash
  bin/rails generate devise:install
  bin/rails generate devise User
  ```
- Migration:
  - Run locally:
    ```bash
    bin/rails db:migrate
    ```
- Mailer host (development):
  - Already set in `config/environments/development.rb`:
    - `config.action_mailer.default_url_options = { host: "localhost", port: 3000 }`
- Turbo/Hotwire integration:
  - In `config/initializers/devise.rb`:
    - `config.navigational_formats = ['*/*', :html, :turbo_stream]`
- Navbar and flash (Bootstrap):
  - Partial `app/views/shared/_navbar.html.erb`
    - Shows “Sign in” / “Sign up” when logged out
    - Shows email + “Sign out” when logged in (uses `data: { turbo_method: :delete }`)
  - Partial `app/views/shared/_flash.html.erb` with Bootstrap alerts
  - Layout updated to render both partials above main content
- Redirects after auth:
  - In `app/controllers/application_controller.rb`:
    - `after_sign_in_path_for` → `root_path`
    - `after_sign_out_path_for` → `root_path`

#### 5) Seed users
- Updated `db/seeds.rb` to create idempotent users:
  - `admin@example.com` / `Password!123`
  - `user@example.com` / `Password!123`
- Run locally:
```bash
bin/rails db:seed
```

#### 6) Verify
- Start server:
```bash
bin/rails s
```
- Visit:
  - Landing page: `http://localhost:3000/`
  - Auth: `http://localhost:3000/users/sign_in`
- Sign in with seeded users and confirm:
  - Navbar shows “Sign out” when authenticated
  - Flash messages styled as Bootstrap alerts

