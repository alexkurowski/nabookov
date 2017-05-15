defmodule App.UserController do
  use App.Web, :controller

  def signin(conn, params) do
    App.User.send_signin_email(params["email"])
    text conn, "ok"
  end

  def signout(conn, _params) do
    conn = put_session(conn, :current_user, nil)
    text conn, "ok"
  end

  def username(conn, params) do
    conn
    |> current_user
    |> App.User.changeset(%{name: params["name"]})
    |> App.Repo.update
    text conn, "ok"
  end
end
