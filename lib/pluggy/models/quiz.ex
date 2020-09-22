defmodule Pluggy.Quiz do
    defstruct(id: nil,name: "",img_path: "")

    alias Pluggy.Quiz

    def get_students(group) do
        group_id = Postgrex.query!(DB, "SELECT id FROM groups WHERE name = $1", [group], pool: DBConnection.ConnectionPool).rows
        [head | _tail] = group_id
        [head | _tail] = head
        Postgrex.query!(DB, "SELECT id, name, img_path FROM students WHERE group_id = $1", [head], pool: DBConnection.ConnectionPool).rows
        |> IO.inspect
        |> to_struct_list
    end

    def to_struct([[id, name, img_path]]) do
        %Quiz{id: id, name: name, img_path: img_path}
    end

    def to_struct_list(rows) do
        for row <- rows, do: IO.inspect(row)
        for [id, name, img_path] <- rows, do: %Quiz{id: id, name: name, img_path: img_path}
    end

end
