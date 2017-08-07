defmodule App.Web.ReaderView do
  use App.Web, :view

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
      "title":     "#{js chapter.title}",
      "text":      "#{js chapter.text}",
      "order":      #{chapter.order}
    }
    """
  end

  defp js(str), do: escape_javascript(str || "")
end
