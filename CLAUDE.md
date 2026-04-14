# Nazary Backend — Claude Rules

## Project Overview
Rails 8 API backend for Nazary, a travel platform connecting travelers with verified trip planners across Pakistan. PostgreSQL, JWT auth, Active Storage (S3), Active Model Serializers.

## Migrations

- **ALWAYS generate migrations via `bin/rails generate`** — never write migration files by hand.
  ```bash
  bin/rails generate model ModelName field:type field:type
  bin/rails generate migration AddFieldToTable field:type
  ```
- After generating, edit the migration file to add constraints (`null: false`, `default:`, indexes) before running `bin/rails db:migrate`.
- Run `bin/rails db:migrate` after every migration to verify it applies cleanly.
- Never modify a migration that has already been committed — generate a new one instead.

## Reserved Keywords & Naming

- **Never use Ruby/Rails/SQL reserved words** as column names, model names, method names, or scope names.
  - Forbidden column names include: `type`, `class`, `method`, `hash`, `send`, `object`, `id` (custom), `format`, `display`, `freeze`, `system`, `test`, `open`, `close`, `read`, `write`, `select`, `group`, `order`, `limit`, `offset`, `lock`, `key`, `value`, `data`, `date`, `time`, `new`, `action`, `attributes`.
  - Forbidden model names include: `Type`, `Class`, `Method`, `Record`, `Session`, `Thread`.
  - If a column must describe a "type", use a descriptive name like `trip_type`, `request_kind`, `category`.
  - If a method name conflicts, prefix it: `calculate_status` not `status` (when `status` is already an enum).
- **Enum columns** — always use `integer` type with explicit mapping:
  ```ruby
  enum :status, { pending: 0, reviewed: 1, resolved: 2 }
  ```

## Rails Best Practices

### Models
- Always add `dependent: :destroy` (or `:nullify`) on `has_many` associations.
- Validate presence on required fields at the model level, not just DB constraints.
- Keep models thin — move complex logic to service objects under `app/services/`.
- Use scopes for reusable queries; name them clearly (`active`, `upcoming`, `by_host`).

### Controllers
- All API controllers inherit from `Api::V1::BaseController` (authenticated by default).
- Use strong params — never pass `params` directly to create/update.
- Return consistent JSON responses:
  - Success: `render json: object, serializer: ..., status: :ok/:created`
  - Error: `render json: { error: "message" }, status: :unprocessable_entity`
- Use `before_action :require_traveler!` or `require_planner!` for role-gated actions.

### Serializers
- One serializer per model under `app/serializers/`.
- Always convert `id` to string: `def id; object.id.to_s; end`
- Format timestamps as ISO8601: `def created_at; object.created_at.iso8601; end`
- Derive data from associations rather than duplicating columns (e.g., get user name via `object.user.name`).

### Routes
- All routes live inside `namespace :api { namespace :v1 { ... } }`.
- Use `resources` with `only:` to expose minimal endpoints.
- Group related routes with comments.

### General
- Don't skip `--no-verify` or bypass hooks.
- Don't use `rails console` commands in production.
- Prefer `find_by` over `find` when a 404 should return nil.
- Use `SecureRandom.urlsafe_base64` for tokens, never predictable values.

## Tech Stack Reference
- **Auth**: bcrypt + JWT (custom, see `Authenticatable` concern)
- **Serialization**: ActiveModelSerializers
- **Pagination**: Kaminari (via `Paginatable` concern)
- **Search**: PgSearch
- **Storage**: ActiveStorage with S3
- **Push**: FCM via service objects
