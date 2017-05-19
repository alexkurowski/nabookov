defmodule App.Web.UserController do
  use App.Web, :controller

  def signin(conn, params) do
    App.Auth.send_signin_email(params["email"])
    text conn, "ok"
  end

  def signout(conn, _params) do
    conn = put_session(conn, :current_user_token, nil)
    text conn, "ok"
  end

  def username(conn, params) do
    conn
    |> current_user
    |> App.Auth.update_name(params["name"])
    text conn, "ok"
  end
end
