defmodule App.Web.WriterController do
  use App.Web, :controller

  plug :require_sign_in

  @doc """
  Writer's dashboard where he can manage his books and prices
  """
  def dashboard(conn, _params) do
    books = App.Books.current_user_books(conn)
    render conn, "dashboard.html", books: books
  end

  def new_book(conn, params) do
    App.Books.create_book(current_user(conn), params["title"], params["description"])
    text conn, "ok"
  end

  def edit_book_details(conn, params) do
    App.Books.update_book(current_user(conn), params)
    text conn, "ok"
  end
end
