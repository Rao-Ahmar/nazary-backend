# Database Migration Standards

To maintain schema integrity and version control, strictly follow these rules regarding database migrations:

### 1. No Manual File Creation
- **NEVER** manually create migration files in `db/migrations`, `migrations/`, or similar directories.
- **NEVER** write code that simulates a migration file unless explicitly asked for a template.

### 2. CLI-First Execution
- Always use the framework's Command Line Interface (CLI) to generate migration files.
- **Rails:** Use `rails generate migration NameOfMigration`
- **Django:** Use `python manage.py makemigrations`
- **Node/Sequelize:** Use `npx sequelize-cli migration:generate --name name`
- **TypeORM:** Use `typeorm migration:generate -n Name`
- **Alembic (Python):** Use `alembic revision --autogenerate`

### 3. Workflow Protocol
1. **Identify Change:** Determine the necessary schema change (e.g., adding a column).
2. **Command Generation:** Provide the exact shell command to generate the migration.
3. **Execution:** Instruct the user to run the command first.
4. **Logic Modification:** Only after the file is generated should you suggest specific logic to be added inside the `up()` or `down()` methods if the CLI didn't capture it automatically.

### 4. Verification
Before providing a solution, verify: "Am I suggesting a manual file creation?" If yes, pivot to a command-based approach.