defmodule Pluggy.UserController do
  # import Pluggy.Template, only: [render: 2] #det här exemplet renderar inga templates
  import Plug.Conn, only: [send_resp: 3]

  def login(conn, params) do
    username = params["username"]
    password = params["password"]

    # IO.inspect(Bcrypt.hash_pwd_salt(params["password"]))

     #Bör antagligen flytta SQL-anropet till user-model (t.ex User.find)
    result =
      Postgrex.query!(DB, "SELECT id, pwdhash, admin FROM users WHERE username = $1", [username],
        pool: DBConnection.ConnectionPool
      )
      case result.num_rows do
          # no user with that username
          0 ->
              redirect(conn, "/")
            # user with that username exists
            _ ->
                # IO.inspect(result.rows)
                [[id, pwdhash, admin]] = result.rows

                # make sure password is correct
        if Bcrypt.verify_pass(password, pwdhash) do
          Plug.Conn.put_session(conn, :user_id, id)
          |> redirect("/schools") #skicka vidare modifierad conn
        else
          redirect(conn, "/")
        end
    end
  end

  def logout(conn) do
    Plug.Conn.configure_session(conn, drop: true) #tömmer sessionen
    |> redirect("/")
  end

  def create(conn, params) do
  	#pseudocode
  	# in db table users with password_hash CHAR(60)
  	# hashed_password = Bcrypt.hash_pwd_salt(params["password"])
   	# Postgrex.query!(DB, "INSERT INTO users (username, password_hash) VALUES ($1, $2)", [params["username"], hashed_password], [pool: DBConnection.ConnectionPool])
   	# redirect(conn, "/fruits")
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end