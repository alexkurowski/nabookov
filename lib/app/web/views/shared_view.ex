defmodule App.Web.SharedView do
  use App.Web, :view

  def book_class(book) do
    if String.length(book.title) > 60 do
      "book cover-#{book.cover} small-title"
    else
      "book cover-#{book.cover}"
    end
  end

  def book_chapters(book) do
    count = book.chapters |> Enum.count
    if count == 1,
      do: "#{count} chapter",
      else: "#{count} chapters"
  end
end
