# Wedding Event Management API

Rails 8 API-only application for wedding planning.

## Stack

- Ruby on Rails 8 (API mode)
- PostgreSQL
- JWT authentication with refresh tokens
- Active Storage + AWS S3
- Blueprinter serializers
- Pagy pagination
- RSpec + FactoryBot
- RSwag (Swagger)

## Setup

```bash
bundle install
cp .env.example .env
rails db:create db:migrate db:seed
rails server
```

API runs at `http://localhost:3000`.

## Test credentials

- Admin: `admin@wedding.com` / `password123`
- Family: `family@wedding.com` / `password123`

## Tests

```bash
bundle exec rspec
```

## Swagger

Visit `http://localhost:3000/api-docs`

## Project structure

```
app/
├── controllers/api/v1/   # Versioned API controllers
├── models/               # ActiveRecord models
├── serializers/          # Blueprinter JSON serializers
└── services/             # Service objects (auth, dashboard, etc.)
```
