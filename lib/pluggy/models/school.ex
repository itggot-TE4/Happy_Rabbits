defmodule Pluggy.School do
    defstruct(id: nil, name: "")

    alias Pluggy.School

    def all do
      Postgrex.query!(DB, "SELECT * FROM schools", [], pool: DBConnection.ConnectionPool).rows
      |> to_struct_list
    end

    def get(id) do
      Postgrex.query!(DB, "SELECT * FROM schools WHERE id = $1 LIMIT 1", [String.to_integer(id)],
        pool: DBConnection.ConnectionPool
      ).rows
      |> to_struct
    end

    def update(id, params) do
      name = params["name"]
      id = String.to_integer(id)

      Postgrex.query!(
        DB,
        "UPDATE schools SET name = $1 WHERE id = $2",
        [name, id],
        pool: DBConnection.ConnectionPool
      )
    end

    def create(params) do
      name = params["name"]

      Postgrex.query!(DB, "INSERT INTO schools (name) VALUES ($1)", [name],
        pool: DBConnection.ConnectionPool
      )
    end

    def delete(id) do
      Postgrex.query!(DB, "DELETE FROM schools WHERE id = $1", [String.to_integer(id)], pool: DBConnection.ConnectionPool)
    end

    def join(user_id) do
      Postgrex.query!(DB,
      "SELECT (schools.id, schools.name) FROM schools JOIN user_school ON schools.id = user_school.school_id JOIN users ON user_school.user_id = users.id WHERE users.id = $1",
      [String.to_integer(user_id)], pool: DBConnection.ConnectionPool).rows
      |>
      to_struct_list_for_join()
    end

    def to_struct([[id, name]]) do
      %School{id: id, name: name}
    end

    def to_struct_list(rows) do
      IO.inspect(rows)
      for [id, name] <- rows, do: %School{id: id, name: name}
    end


    defp to_struct_list_for_join(joined_list) do

      # IO.inspect(joined_list)
      for li_raw <- joined_list do

        # IO.inspect(li_raw)
        [li|_] = li_raw

        # IO.inspect(li)
        to_struct([[elem(li,0),elem(li,1)]])

      end
    end
  end

  end
