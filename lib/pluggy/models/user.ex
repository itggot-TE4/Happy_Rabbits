defmodule Pluggy.User do
  defstruct(id: nil, name: "", username: "", pwdhash: "", img_path: "", admin: nil)

  alias Pluggy.User

  def all do
    Postgrex.query!(DB, "SELECT * FROM users", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM users WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def update(id, params) do
    name = params["name"]
    username = params["username"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE users SET name = $1, username = $2,WHERE id = $3",
      [name, id],
      pool: DBConnection.ConnectionPool
    )
  end

  def create(params) do
      name = params["name"]
      username = params["username"]
      pwdhash = params["pwdhash"]
      img_path = params["img_path"]
      admin = params["admin"]

    Postgrex.query!(DB, "INSERT INTO users (name, username, pwdhash, img_path, admin) VALUES ($1, $2, $3, $4 $5)", 
      [name, username, pwdhash, img_path, admin],
      pool: DBConnection.ConnectionPool
    )
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM users WHERE id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    )
  end

  def to_struct([[id, name, pwdhash, img_path, username, admin]]) do
    .User{id: id, name: name, img_path: img_path, username: username, pwdhash: pwdhash, admin: admin}
  end

  def to_struct_list(rows) do
    for [id, name, pwdhash, img_path, username, admin] <- rows, do: .User{id: id, name: name, img_path: img_path, username: username, pwdhash: pwdhash, admin: admin}
  end
end
