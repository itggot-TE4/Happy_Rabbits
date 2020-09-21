defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger

  alias Pluggy.SchoolController
  alias Pluggy.IndexController
  alias Pluggy.UserController
  alias Pluggy.User
  alias Pluggy.School


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

  # def logged_in(conn) do

  #   session_user = conn.private.plug_session["user_id"]

  #   current_user =
  #     case session_user do
  #       nil -> nil
  #       _ -> User.get(session_user)
  #     end

  #   if current_user do

  #   else
  #     IndexController.qwe(conn)
  #   end

  # end
  
  def logged_in(conn) do

    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    if !current_user do
      IndexController.qwe(conn, "/")
    end

  end

  def admin?(conn) do

    session_user = conn.private.plug_session["user_id"]
    
    current_user =
    case session_user do
      nil -> nil
      _ -> User.get(session_user)
    end

    if !current_user do
      IndexController.qwe(conn, "/")
    end

    if (current_user.admin != 1) do
      IndexController.qwe(conn, "/")
    end

  end

  def before_do(conn) do

    logged_in(conn)

  end

  get("/") do
    IndexController.index(conn)
  end

  get("/sucess") do
    before_do(conn)
    admin?(conn)
    IndexController.sucess(conn)
  end

  post("user/login") do
    UserController.login(conn, conn.body_params)
  end

  post("user/logout") do
    UserController.logout(conn)
  end

  get("/schools") do
    before_do(conn)
    SchoolController.schools(conn)
  end

  post("/remove_school") do
    before_do(conn)
    SchoolController.delete(conn)
  end

  get("/schools/school") do
    before_do(conn)
    SchoolController.school(conn)
  end

  get("/schools/school/group") do
    before_do(conn)
    SchoolController.group(conn)
  end

  get("/schools/school/class/quiz") do
    before_do(conn)
    SchoolController.quiz(conn)
  end

  get("/quiz") do
    SchoolController.quiz(conn)
  end

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
