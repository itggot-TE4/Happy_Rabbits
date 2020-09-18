defmodule Pluggy.SchoolController do
  require IEx

  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def schools(conn) do
    send_resp(conn, 200, srender("views/schools", user: nil))
  end

  def school(conn) do
    send_resp(conn, 200, srender("views/school", user: nil))
  end

  def group(conn) do
    send_resp(conn, 200, srender("views/group", user: nil))
  end

  def quiz(conn) do
    send_resp(conn, 200, srender("views/quiz", user: nil))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
