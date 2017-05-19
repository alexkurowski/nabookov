defmodule App.Web.SharedView do
  use App.Web, :view

  def book_class(book) do
    result = "book cover-#{book.cover}"
    if String.length(book.title) > 60 do
      result = result <> " small-title"
    end
    result
  end
end
