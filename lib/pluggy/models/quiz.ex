defmodule Pluggy.Quiz do
    defstruct(id: nil, group_name: "")

    alias Pluggy.Quiz

    def get_students(group) do
        group_id = Postgrex.query!(DB, "SELECT id FROM groups WHERE name = $1", [group], pool: DBConnection.ConnectionPool).rows
        [head | _tail] = group_id
        [head | _tail] = head
        Postgrex.query!(DB, "SELECT id, name FROM students WHERE group_id = $1", [head], pool: DBConnection.ConnectionPool).rows
        |> IO.inspect
        |> to_struct_list
        # |> IO.inspect
    end

    def to_struct([[id, name]]) do
        %Quiz{id: id, group_name: name}
    end

    # fungerar inte hahahahahhaahahahahahhahac hjagfg äslakrt elsiuxjkdawera
    def to_struct_list(rows) do
        for row <- rows, do: IO.inspect(row)
        for [id, name] <- rows, do: %Quiz{id: id, group_name: name}
    end

end
