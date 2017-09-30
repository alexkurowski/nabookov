defmodule App.Web.AuthHelper do
  import Plug.Conn

  @doc """
  Try to set a current user token cookie
  Happens only when email and signup token do match
  """
  def maybe_sign_in(conn, %{"email" => email, "token" => token}) do
    # TODO: Secure token by combining it with more user data and encoding it
    token  = App.Auth.maybe_signin(email, token)
    expire = 365*24*60*60 # a year in seconds

    put_resp_cookie(conn, current_user_token, token, max_age: expire)
  end

  @doc """
  Remove current user token from cookies
  """
  def sign_out(conn) do
    put_resp_cookie(conn, current_user_token, "", max_age: 0)
  end

  @doc """
  Check if user is signed in by figuring if current_user_token in their session
  is traced to a user record
  """
  def signed_in?(conn) do
    not is_nil(conn.assigns[:current_user])
  end

  @doc """
  Ensures that conn.assigns[:current_user] contains current_user
  returns `{conn, user}`
  """
  def current_user(conn) do
    conn.assigns[:current_user]
  end

  @doc """
  A controller plug that sets `conn.assigns[:current_user]` to a current user record
  """
  def set_current_user(conn, _) do
    token = conn.cookies[current_user_token]
    if is_nil token do
      conn
    else
      assign(conn, :current_user, App.Auth.find_by_token(token))
    end
  end

  @doc """
  A controller plug to redirect not signed in users to root path
  """
  def require_sign_in(conn, _) do
    if is_nil current_user(conn) do
      Phoenix.Controller.redirect conn, to: "/"
      Plug.Conn.halt conn
    else
      conn
    end
  end

  defp current_user_token, do: "cut"
end
