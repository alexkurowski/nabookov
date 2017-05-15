defmodule App.WriterController do
  use App.Web, :controller

  @doc """
  Writer's dashboard where he can manage his books and prices
  """
  def dashboard(conn, _params) do
    books = Repo.all from b in App.Book,
                       join: u in assoc(b, :user),
                       where: b.user_id == u.id
    render conn, "dashboard.html", books: books
  end

  def new_book(conn, params) do
    App.Book.create(current_user(conn), params["title"], params["description"])
    text conn, "ok"
  end
end
