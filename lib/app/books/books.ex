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

  @doc """
  Get books created by currently logged in user
  """
  def current_user_books(conn) do
    id = conn.assigns[:current_user].id
    Repo.all from b in Book,
               where: b.user_id == ^id
  end

  @doc """
  Get books created by user
  """
  def user_books(id) do
    Repo.all from b in Book,
               where: b.user_id == ^id,
               where: b.visible == true
  end
end
