defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    standard_users()
    standard_schools()
    standard_groups()
    standard_students()
    standard_user_school()
    # seed_data()
  end

    # hej

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS fruits", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS students", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS groups", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS schools", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS user_school", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS user_group", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")
    Postgrex.query!(DB, "Create TABLE users (id SERIAL, name VARCHAR(255) NOT NULL, pwdhash VARCHAR(255) NOT NULL, img_path VARCHAR(255) NOT NULL, username VARCHAR(255) NOT NULL, admin INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE students (id SERIAL, name VARCHAR(255) NOT NULL, img_path VARCHAR(255) NOT NULL, group_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE groups (id SERIAL, name VARCHAR(255) NOT NULL, school_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE schools (id SERIAL, name VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE user_school (user_id INTEGER NOT NULL, school_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
  end

  defp standard_users() do
    IO.puts("Adding standard users")
    Postgrex.query!(DB, "INSERT INTO users (name, pwdhash, img_path, username, admin) VALUES ('temp', '$2b$12$EkW6ETcfQaiuD4lD9Sdvm.bqcJL6R/z.SHs9/twiUwwpA0kykrYs6', 'standard.png', 'temp', 1)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO users (name, pwdhash, img_path, username, admin) VALUES ('bob', '$2b$12$EkW6ETcfQaiuD4lD9Sdvm.bqcJL6R/z.SHs9/twiUwwpA0kykrYs6', 'standard.png', 'temp', 0)", [], pool: DBConnection.ConnectionPool)
  end

  defp standard_schools() do
    IO.puts("Adding standard schools")
    Postgrex.query!(DB, "INSERT INTO schools (name) VALUES ('ITG-Göteborg')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO schools (name) VALUES ('NTI-Johanneberg')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO schools (name) VALUES ('NTI-Kronhus')", [], pool: DBConnection.ConnectionPool)
  end

  defp standard_groups() do
    IO.puts("Adding standard groups")
    Postgrex.query!(DB, "INSERT INTO groups (name, school_id) VALUES ('spergs - ITG', 1)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups (name, school_id) VALUES ('spergs - NTI (the good one)', 2)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups (name, school_id) VALUES ('spergs - NTI (inferior)', 3)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups (name, school_id) VALUES ('group 1 - 1', 1)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups (name, school_id) VALUES ('group 1 - 2', 2)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups (name, school_id) VALUES ('group 1 - 3', 3)", [], pool: DBConnection.ConnectionPool)
  end

  defp standard_students() do
    IO.puts("Adding standard students")
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('sven1-1', 1, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('sven1-2', 1, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('sven2-1', 2, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('sven2-2', 2, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('sven3-1', 3, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('sven3-2', 3, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('bob1-1', 4, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('bob2-1', 5, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('bob3-1', 6, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('bob1-2', 4, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('bob2-2', 5, 'temp')", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students (name, group_id, img_path) VALUES ('bob3-2', 6, 'temp')", [], pool: DBConnection.ConnectionPool)
  end

  defp standard_user_school() do
    IO.puts("Adding standard user_school")
    Postgrex.query!(DB, "INSERT INTO user_school (school_id, user_id) VALUES (1, 1)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO user_school (school_id, user_id) VALUES (1, 2)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO user_school (school_id, user_id) VALUES (2, 1)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO user_school (school_id, user_id) VALUES (2, 2)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO user_school (school_id, user_id) VALUES (3, 1)", [], pool: DBConnection.ConnectionPool)
  end

  # defp seed_data() do
  #   IO.puts("Seeding data")
  #   Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Apple", 5], pool: DBConnection.ConnectionPool)
  #   Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Pear", 4], pool: DBConnection.ConnectionPool)
  #   Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Banana", 7], pool: DBConnection.ConnectionPool)
  # end

end
