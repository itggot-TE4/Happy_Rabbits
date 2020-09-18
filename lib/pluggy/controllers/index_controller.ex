defmodule Pluggy.IndexController do
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn, file) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    #srender använder slime
    send_resp(conn, 200, srender("views/index", user: current_user))
  end
  
  def sucess(conn) do
    
    send_resp(conn, 200, srender("views/itworks", user: nil))

  end

  def qwe(conn, destination) do

    redirect(conn, destination)

  end

  #render använder eex
  # def new(conn), do: send_resp(conn, 200, srender("views/new", []))
  # def show(conn, id), do: send_resp(conn, 200, srender("views/show", fruit: Fruit.get(id)))
  # def edit(conn, id), do: send_resp(conn, 200, srender("views/edit", fruit: Fruit.get(id)))

  def create(conn, params) do
    Fruit.create(params)
    case params["file"] do
      nil -> IO.puts("No file uploaded")  #do nothing
        # move uploaded file from tmp-folder
      _  -> File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
    end
    redirect(conn, "/fruits")
  end

  def update(conn, id, params) do
    Fruit.update(id, params)
    redirect(conn, "/fruits")
  end

  def destroy(conn, id) do
    Fruit.delete(id)
    redirect(conn, "/fruits")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

  def schoolrenderer([]) do end

  def schoolrenderer([head|tail] = yeah) do
    schoolrenderer(tail)
    IO.inspect(head)
    p="1"
  end
end
