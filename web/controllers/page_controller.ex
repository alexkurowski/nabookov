defmodule App.PageController do
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

  defp maybe_signin(conn, params) do
    token = App.User.maybe_signin(params)
    unless is_nil(token),
      do: put_session(conn, :current_user, token),
      else: conn
  end
end
