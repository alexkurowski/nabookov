defmodule App.Web.WriterController do
  use App.Web, :controller

  plug :require_sign_in
  plug :put_layout, {App.Web.LayoutView, "write.html"} when action in [:write]

  @doc """
  Writer's dashboard where he can manage his books and prices
  """
  def dashboard(conn, _params) do
    books = App.Books.current_user_books(conn)
    render conn, "dashboard.html", books: books
  end

  @doc """
  Add a new book for current user
  """
  def new_book(conn, params) do
    App.Books.create_book(conn, params)
    text conn, "ok"
  end

  @doc """
  Update current user's book's details
  """
  def edit_book_details(conn, params) do
    App.Books.update_book(conn, params)
    text conn, "ok"
  end

  @doc """
  Writing page
  """
  def write(conn, params) do
    book = App.Books.current_user_book(conn, params["slug"])
    render conn, "write.html", book: book
  end
end
