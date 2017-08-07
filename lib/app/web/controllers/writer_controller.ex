defmodule App.Web.WriterController do
  use App.Web, :controller

  plug :require_sign_in
  plug :put_layout, {App.Web.WriterView, "layout.html"} when action in [:write]

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
  Add a new chapter for current user's given book
  """
  def new_chapter(conn, params) do
    book = App.Books.current_user_book(conn, params["slug"])
    response = App.Books.create_chapter(conn, book)
               |> elem(1)
               |> App.Web.WriterView.chapter_data
    text conn, response
  end

  @doc """
  Remove a chapter with a given 'order' from current user's book
  """
  def remove_chapter(conn, params) do
    book = App.Books.current_user_book(conn, params["slug"])
    App.Books.remove_chapter(conn, book, params["order"])
    text conn, "ok"
  end

  @doc """
  Update current user's book's details
  """
  def edit_book_details(conn, params) do
    App.Books.update_book_details(conn, params)
    text conn, "ok"
  end

  @doc """
  Update draft
  """
  def update_draft(conn, params) do
    App.Books.update_draft(conn, params)
    text conn, "ok"
  end

  @doc """
  Update text
  """
  def update_text(conn, params) do
    App.Books.publish(conn, params)
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
