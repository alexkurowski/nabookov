defmodule ControllerHelper do
  def present(val) do
    not is_nil(val) and String.trim(val) != ""
  end

  def is_signed_in?(conn) do
    not is_nil Plug.Conn.get_session conn, :current_user
  end

  def current_user(conn) do
    App.Repo.get_by(App.User, signin_token: (Plug.Conn.get_session(conn, :current_user)))
  end
end
