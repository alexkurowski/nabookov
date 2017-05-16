defmodule App.Web.PageController do
  use App.Web, :controller

  @doc """
  Try to sign in by a email/token pair if present
  """
  def index(conn, params) do
    if present(params["email"]) or present(params["token"]) do
      conn = maybe_signin(conn, params)
      redirect conn, to: "/"
    else
      render conn, "index.html"
    end
  end

  defp maybe_signin(conn, %{"email" => email, "token" => token}) do
    conn
    |> put_session(:current_user_token, App.Auth.maybe_signin(email, token))
  end
end
