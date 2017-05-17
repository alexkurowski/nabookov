defmodule App.Web.AuthHelper do
  import Plug.Conn

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
    token = get_session(conn, :current_user_token)
    if is_nil token do
      conn
    else
      assign(conn, :current_user, App.Auth.find_by_token(token))
    end
  end

  @doc """
  Redirect to root path non-signed in users
  """
  def require_sign_in(conn, _) do
    if is_nil conn.assigns[:current_user] do
      Phoenix.Controller.redirect(conn, to: "/")
      Plug.Conn.halt
    else
      conn
    end
  end
end
