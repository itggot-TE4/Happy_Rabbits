defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger

  alias Pluggy.IndexController
  alias Pluggy.UserController
  alias Pluggy.User


  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  # def before_do(conn) do

  #   session_user = conn.private.plug_session["user_id"]

  #   current_user =
  #     case session_user do
  #       nil -> nil
  #       _ -> User.get(session_user)
  #     end

  #     # IO.inspect(current_user)

  #   if (current_user == nil) do

  #     IO.puts("hej")

  #     put_resp_content_type(conn, "/sucess")
  #   end

  # end

  def logged_in(conn) do

    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    if current_user do

    else
      IndexController.qwe(conn, "/")
    end
    

  end


  get("/") do

    
    IndexController.index(conn)
    
  end
  
  get("/sucess") do 
    logged_in(conn)
    IndexController.sucess(conn)
  end

  post("user/login") do
    UserController.login(conn, conn.body_params)
  end

  post("user/logout") do
    UserController.logout(conn)
  end

  get("/schools") do
    IndexController.index(conn, "schools")
  end

  get("/schools/school") do
    IndexController.index(conn, "school")
  end

  get("/schools/school/class") do
    IndexController.index(conn, "class")
  end

  get("/schools/school/class/quiz") do
    IndexController.index(conn, "quiz")
  end

  # get("/fruits", do: FruitController.index(conn))
  # get("/fruits/new", do: FruitController.new(conn))
  # get("/fruits/:id", do: FruitController.show(conn, id))
  # get("/fruits/:id/edit", do: FruitController.edit(conn, id))

  # post("/fruits", do: FruitController.create(conn, conn.body_params))

  # should be put /fruits/:id, but put/patch/delete are not supported without hidden inputs
  # post("/fruits/:id/edit", do: FruitController.update(conn, id, conn.body_params))

  # should be delete /fruits/:id, but put/patch/delete are not supported without hidden inputs
  # post("/fruits/:id/destroy", do: FruitController.destroy(conn, id))

  # post("/users/login", do: UserController.login(conn, conn.body_params))
  # post("/users/logout", do: UserController.logout(conn))

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
