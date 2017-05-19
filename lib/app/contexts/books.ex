defmodule App.Books do
  @moduledoc """
  The boundary for the Books system.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Data.Book
  alias App.Data.Chapter
  alias App.Data.Feedback


  @doc """
  Create a new book
  """
  def create_book(conn, %{"title" => title, "description" => description}) do
    user_id = current_user_id(conn)
    slug = App.Auth.generate_token(8) |> String.downcase
    {:ok, book} = %Book{user_id: user_id, title: title, description: description, slug: slug}
                  |> Repo.insert
    %Chapter{book_id: book.id}
    |> Repo.insert
  end

  @doc """
  Get books created by currently logged in user
  """
  def current_user_books(conn) do
    user_id = current_user_id(conn)
    Repo.all from b in Book,
               where: b.user_id == ^user_id,
               where: b.deleted == false
  end

  @doc """
  Get books created by another user
  """
  def user_books(user_id) do
    Repo.all from b in Book,
               where: b.user_id == ^user_id,
               where: b.visible == true,
               where: b.deleted == false
  end

  @doc """
  Get a book data with its chapters
  """
  def user_book(user_id, slug) do
    book = user_book_by_slug(user_id, slug) |> Repo.preload(:chapters)
  end

  @doc """
  Get a current user's book data with its chapters
  """
  def current_user_book(conn, slug) do
    user_id = current_user_id(conn)
    book = user_book_by_slug(user_id, slug) |> Repo.preload(:chapters)
  end

  @doc """
  TODO: Update book details
  """
  def update_book(conn, %{"book" => slug, "title" => title, "description" => description}) do
    user_id = current_user_id(conn)
    book = user_book_by_slug(user_id, slug)
  end

  defp current_user_id(conn) do
    conn.assigns[:current_user].id
  end

  defp user_book_by_slug(user_id, slug) do
    Book
    |> Repo.get_by(user_id: user_id, slug: String.downcase(slug))
  end
end
