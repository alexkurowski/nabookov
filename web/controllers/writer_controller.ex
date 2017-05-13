defmodule App.WriterController do
  use App.Web, :controller

  @doc """
  Writer's dashboard where he can manage his books and prices
  """
  def dashboard(conn, _params) do
    render conn, "dashboard.html"
  end
end
