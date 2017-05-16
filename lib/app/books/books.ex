defmodule App.Books do
  @moduledoc """
  The boundary for the Books system.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Books.Book
  alias App.Books.Chapter
  alias App.Books.Feedback


  @doc """
  Create a new book
  """
  def create_book(user, title, description) do
    %Book{user_id: user.id, title: title, description: description}
    |> Repo.insert
  end
end
