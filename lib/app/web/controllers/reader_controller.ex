defmodule App.Web.ReaderController do
  use App.Web, :controller

  plug :require_sign_in
  plug :put_layout, {App.Web.ReaderView, "layout.html"} when action in [:read]

  @doc """
  Use params['slug'] to find a book or @author
  """
  def read(conn, params) do
    book = App.Books.find_book(params["slug"])
    chapters = App.Books.read_chapters(book)
    render conn, "read.html", book: book, chapters: chapters
  end
end
