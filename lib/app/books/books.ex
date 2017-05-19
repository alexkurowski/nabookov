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
  def create_book(conn, %{"title" => title, "description" => description}) do
    user_id = current_user_id(conn)
    %Book{user_id: user_id, title: title, description: description, slug: App.Auth.generate_token(8)}
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
    Repo.get_by(Book, user_id: user_id, slug: slug)
  end

  @doc """
  Get a current user's book data with its chapters
  """
  def current_user_book(conn, slug) do
    user_id = current_user_id(conn)
    Repo.get_by(Book, user_id: user_id, slug: slug)
  end

  @doc """
  TODO: Update book details
  """
  def update_book(conn, %{"book" => slug, "title" => title, "description" => description}) do
    user_id = current_user_id(conn)
    book = Repo.get_by(Book, user_id: user_id, slug: slug)
  end

  defp current_user_id(conn) do
    conn.assigns[:current_user].id
  end
end
