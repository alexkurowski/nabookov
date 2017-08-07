defmodule App.Web.WriterView do
  use App.Web, :view

  @doc """
  Add 'small-title' class if book's title is lengthy
  """
  def book_class(book) do
    if String.length(book.title) > 60 do
      "book cover-#{book.cover} small-title"
    else
      "book cover-#{book.cover}"
    end
  end

  @doc """
  Chapter counter
  """
  def book_chapters(book) do
    count = book.chapters |> Enum.count
    if count == 1,
      do: "#{count} chapter",
      else: "#{count} chapters"
  end


  @doc """
  Convert book data to javascript
  """
  def book_data(book) do
    """
    {
      slug: "#{js book.slug}",
      title: "#{js book.title}",
      description: "#{js book.description}"
    }
    """
  end

  @doc """
  Convert chapter data to javascript
  """
  def chapter_data(chapter) do
    """
    {
      "id":         #{chapter.id},
      "title":     "#{js chapter.title}",
      "draft":     "#{js chapter.draft}",
      "order":      #{chapter.order},
      "sync_time":  #{chapter.sync_time || 0},
      "visible":    #{chapter.visible},
      "locked":     #{chapter.locked}
    }
    """
  end

  defp js(str), do: escape_javascript(str || "")
end
