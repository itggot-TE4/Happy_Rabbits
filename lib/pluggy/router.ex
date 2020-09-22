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
      redirect(conn, "/")
    end

    if (current_user.admin != 1) do
      redirect(conn, "/")
    end

  end

  def is_admin?(conn) do

    session_user = conn.private.plug_session["user_id"]

    current_user =
    case session_user do
      nil -> nil
      _ -> User.get(session_user)
    end

    admin = 
    case current_user.admin do
      1 -> true
      _ -> nil
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
    IO.inspect(is_admin?(conn))
    # IO.inspect(is_boolean(is_admin?(conn)))
    SchoolController.schools(conn, School.join(conn.private.plug_session["user_id"]), is_admin?(conn))
  end

  post("/remove_school") do
    before_do(conn)
    SchoolController.delete(conn)
  end

  get("/schools/:school") do
    before_do(conn)
    IO.inspect(conn.params)
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

  post("/test") do

    School.join("1")
    # for school <- School.join("1") do
    # IO.inspect(school)
    # end
    IndexController.qwe(conn, "/")

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

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
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
