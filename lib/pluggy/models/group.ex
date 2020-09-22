defmodule Pluggy.Group do
    defstruct(id: nil, name: "", school_id: nil)

    alias Pluggy.Group

    def all do
      Postgrex.query!(DB, "SELECT * FROM groups", [], pool: DBConnection.ConnectionPool).rows
      |> to_struct_list
    end

    def get(id) do
      Postgrex.query!(DB, "SELECT * FROM groups WHERE id = $1 LIMIT 1", [String.to_integer(id)],
        pool: DBConnection.ConnectionPool
      ).rows
      |> to_struct
    end

    def get_for_school(school_name) do
      Postgrex.query!(DB, "SELECT (groups.id, groups.name, schools.id) FROM groups JOIN schools ON school_id = schools.id WHERE schools.name = $1", [school_name],
        pool: DBConnection.ConnectionPool
      ).rows
      |> IO.inspect()
      |> to_struct_list_for_join()
    end

    def update(id, params) do
      name = params["name"]
      id = String.to_integer(id)

      Postgrex.query!(
        DB,
        "UPDATE groups SET name = $1 WHERE id = $2",
        [name, id],
        pool: DBConnection.ConnectionPool
      )
    end

    def create(params) do
      name = params["name"]

      Postgrex.query!(DB, "INSERT INTO groups (name) VALUES ($1)", [name],
        pool: DBConnection.ConnectionPool
      )
    end

    def delete(id) do
      Postgrex.query!(DB, "DELETE FROM groups WHERE id = $1", [String.to_integer(id)],
        pool: DBConnection.ConnectionPool
      )
    end

    def to_struct([[id, name, school_id]]) do
      %Group{id: id, name: name, school_id: school_id}
    end

    def to_struct_list(rows) do
      for row <- rows do
        IO.inspect(row)
      end
      IO.inspect(for [id, name, school_id] <- rows, do: %Group{id: id, name: name, school_id: school_id})
    end

    defp to_struct_list_for_join(joined_list) do

      # IO.inspect(joined_list)
      for li_raw <- joined_list do

        # IO.inspect(li_raw)
        [li|_] = li_raw

        # IO.inspect(li)
        to_struct([[elem(li,0), elem(li,1), elem(li,2)]])
        |> IO.inspect()

      end
    end

  end
