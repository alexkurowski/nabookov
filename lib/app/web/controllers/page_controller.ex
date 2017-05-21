defmodule App.Web.PageController do
  use App.Web, :controller

  @doc """
  Try to sign in by a email/token pair if present
  """
  def index(conn, params) do
    if present(params["email"]) or present(params["token"]) do
      conn
      |> maybe_sign_in(params)
      |> redirect(to: "/")
    else
      render conn, "index.html"
    end
  end
end
