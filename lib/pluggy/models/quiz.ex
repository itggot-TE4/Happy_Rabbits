defmodule Pluggy.Quiz do
    defstruct(id: nil, name: "")

    def get_students(group) do
        group_id = Postgrex.query!(DB, "SELECT id FROM groups WHERE name = $1", [group], pool: DBConnection.ConnectionPool).rows
        [head | _tail] = group_id
        [head | _tail] = head
        Postgrex.query!(DB, "SELECT id, name FROM students WHERE group_id = $1", [head], pool: DBConnection.ConnectionPool).rows
        |> to_struct_list
    end

    # fungerar inte hahahahahhaahahahahahhahac hjagfg äslakrt elsiuxjkdawera
    def to_struct_list(rows) do
        for [id, name] <- rows, do: %Quiz{id: id, name: name}
    end

end