defmodule Pluggy.Student do
    defstruct(id: nil, name: "", school_id: nil, group_id: nil, img_path: "")
  
    alias Pluggy.Student
  
    def all do
      Postgrex.query!(DB, "SELECT * FROM students", [], pool: DBConnection.ConnectionPool).rows
      |> to_struct_list
    end
  
    def get(id) do
      Postgrex.query!(DB, "SELECT * FROM students WHERE id = $1 LIMIT 1", [String.to_integer(id)],
        pool: DBConnection.ConnectionPool
      ).rows
      |> to_struct
    end
  
    def update(id, params) do
      name = params["name"]
      school_id = String.to_integer(params["school_id"])
      group_id = String.to_integer(params["group_id"])
      img_path = params["img_path"]
      id = String.to_integer(id)
  
      Postgrex.query!(
        DB,
        "UPDATE students SET name = $1, school_id = $2, group_id = $3,  WHERE id = $4",
        [name, school_id, group_id, id],
        pool: DBConnection.ConnectionPool
      )
    end
  
    def create(params) do
        name = params["name"]
        school_id = String.to_integer(params["school_id"])
        group_id = String.to_integer(params["group_id"])
        img_path = params["img_path"]
  
      Postgrex.query!(DB, "INSERT INTO students (name, school_id, group_id, img_path) VALUES ($1, $2, $3, $4)", 
        [name, school_id, group_id, img_path],
        pool: DBConnection.ConnectionPool
      )
    end
  
    def delete(id) do
      Postgrex.query!(DB, "DELETE FROM students WHERE id = $1", [String.to_integer(id)],
        pool: DBConnection.ConnectionPool
      )
    end
  
    def to_struct([[id, name, img_path, school_id, group_id]]) do
      %Student{id: id, name: name, img_path: img_path, school_id: school_id, group_id: group_id}
    end
  
    def to_struct_list(rows) do
      for [id, name, img_path, school_id, group_id] <- rows, do: %Student{id: id, name: name, img_path: img_path, school_id: school_id, group_id: group_id}
    end
  end
  