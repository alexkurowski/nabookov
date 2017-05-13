defmodule App.ReaderController do
  use App.Web, :controller

  @doc """
  Use params['slug'] to find a book or @author
  """
  def find(conn, _params) do
    render conn, "delme.html"
  end
end
