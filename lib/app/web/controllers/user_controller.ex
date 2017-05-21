defmodule App.Web.UserController do
  use App.Web, :controller

  def signin(conn, params) do
    App.Auth.send_signin_email(params["email"])
    text conn, "ok"
  end

  def signout(conn, _params) do
    conn
    |> sign_out
    |> text("ok")
  end

  def username(conn, params) do
    if App.Auth.name_taken?(params["name"]) do
      conn
      |> put_status(406)
      |> text("no")
    else
      conn
      |> current_user
      |> App.Auth.update_name(params["name"])
      text conn, "ok"
    end
  end
end
