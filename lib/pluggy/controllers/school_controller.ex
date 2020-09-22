defmodule Pluggy.SchoolController do
  require IEx

  alias Pluggy.School
  alias Pluggy.Group
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def schools(conn, schools, admin) do
    send_resp(conn, 200, srender("views/schools", schools: schools, admin: admin))
  end

  def school(conn, admin) do
    send_resp(conn, 200, srender("views/school", school: conn.params["school"], admin: admin))
  end

  def group(conn) do
    send_resp(conn, 200, srender("views/group", group: conn.params["group"]))
  end

  def quiz(conn) do
    send_resp(conn, 200, srender("views/quiz", school: conn.params["school"] , group: conn.params["group"]))
  end

  def update(conn) do
    School.update(conn.body_params["id"], conn.params)
    redirect(conn, "/schools")
  end

  def delete(conn) do
    School.delete(conn.body_params["id"])
    redirect(conn, "/schools")
  end

  def create(conn) do
    School.create(conn.params)
    redirect(conn, "/schools")
  end
  
  def create_group(conn) do
    school = conn.params["school_name"]
    Group.create(conn.params)
    redirect(conn, "/schools/#{school}")
  end
  
  def remove_group(conn) do
    school = conn.params["school_name"]
    Group.delete(conn.params["id"])
    redirect(conn, "/schools/#{school}")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

end
