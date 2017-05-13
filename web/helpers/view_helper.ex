defmodule ViewHelper do
  def is_signed_in?(conn) do
    not is_nil Plug.Conn.get_session conn, :current_user
  end

  def current_user(conn) do
    App.Repo.get_by(App.User, signin_token: (Plug.Conn.get_session(conn, :current_user)))
  end

  def username(user) do
    user.name
  end

  def username_or_email(user) do
    if no_username(user) do
      user.email
    else
      "@" <> user.name
    end
  end

  def no_username(user) do
    is_nil(user.name) or String.trim(user.name) == ""
  end
end
