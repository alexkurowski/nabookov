defmodule App.Web.WriterController do
  use App.Web, :controller

  plug :require_sign_in
  plug :put_layout, false when action in [:write]

  @doc """
  Writer's dashboard where he can manage his books and prices
  """
  def dashboard(conn, _params) do
    books = App.Books.current_user_books(conn)
    render conn, "dashboard.html", books: books
  end

  def new_book(conn, params) do
    App.Books.create_book(conn, params)
    text conn, "ok"
  end

  def write(conn, params) do
    book = App.Books.current_user_book(conn, params["slug"])
    IO.inspect book
    IO.inspect book.chapters
    render conn, "write.html", book: book
  end

  def edit_book_details(conn, params) do
    App.Books.update_book(conn, params)
    text conn, "ok"
  end
end
