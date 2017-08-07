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
  Create a new book under current user
  """
  def create_book(conn, %{"title" => title, "description" => description}) do
    user_id = current_user_id(conn)
    slug = App.Auth.generate_token(8) |> String.downcase

    {:ok, book} = %Book{user_id: user_id, title: title, description: description, slug: slug}
                  |> Repo.insert
    create_chapter(conn, book)
  end

  @doc """
  Create a new chapter for a given book
  """
  def create_chapter(conn, book) do
    user_id = current_user_id(conn)
    if book.user_id == user_id do
      order = next_chapter_order(book.id)
      title = "Chapter #{order}"

      %Chapter{book_id: book.id, order: order, title: title}
      |> Repo.insert
    else
      nil
    end
  end

  @doc """
  Remove a chapter from a book and update chapter order
  """
  def remove_chapter(conn, book, chapter_order) do
    user_id = current_user_id(conn)
    if book.user_id == user_id do
      chapter = find_chapter_by_order(book.id, chapter_order)
      |> Repo.delete!

      for chapter <- Repo.all(from c in Chapter,
                                 where: c.order > ^chapter_order) do
        chapter
        |> Chapter.changeset(%{order: chapter.order - 1})
        |> Repo.update!
      end
    end
  end

  @doc """
  Get books created by currently logged in user
  """
  def current_user_books(conn) do
    user_id = current_user_id(conn)
    Repo.all(from b in Book,
               where: b.user_id == ^user_id,
               where: b.deleted == false)
    |> Repo.preload(:chapters)
  end

  @doc """
  Get books created by another user
  """
  def user_books(user_id) do
    Repo.all from b in Book,
               where: b.user_id == ^user_id,
               where: b.public  == true,
               where: b.deleted == false
  end

  @doc """
  Get a book by a slug
  """
  def find_book(slug) do
    Repo.get_by(Book, slug: slug)
  end

  @doc """
  Get all readable chapters of a book
  """
  def read_chapters(book) do
    Repo.all from c in Chapter,
               where: c.book_id == ^book.id,
               where: c.visible == true,
               where: c.locked == false
  end


  @doc """
  Get a book data with its chapters
  """
  def user_book(user_id, slug) do
    user_book_by_slug(user_id, slug)
    |> Repo.preload(:chapters)
  end

  @doc """
  Get a current user's book data with its chapters
  """
  def current_user_book(conn, slug) do
    user_id = current_user_id(conn)
    user_book_by_slug(user_id, slug)
    |> Repo.preload(:chapters)
  end

  @doc """
  Update book details
  """
  def update_book_details(conn, %{"book" => slug, "title" => title, "description" => description}) do
    user_id = current_user_id(conn)

    user_book_by_slug(user_id, slug)
    |> Book.changeset(%{title: title, description: description})
    |> Repo.update
  end

  @doc """
  Update chapter draft
  """
  def update_draft(conn, %{"book" => slug, "chapter" => chapter_id, "title" => title, "draft" => draft, "sync_time" => sync_time}) do
    user_id = current_user_id(conn)
    book = user_book_by_slug(user_id, slug)

    book_chapter(book.id, chapter_id)
    |> Chapter.changeset(%{title: title, draft: draft, sync_time: sync_time})
    |> Repo.update
  end

  @doc """
  Update chapter text and publish it
  """
  def publish(conn, %{"book" => slug, "chapter" => chapter_id, "title" => title, "draft" => draft, "sync_time" => sync_time}) do
    user_id = current_user_id(conn)
    book = user_book_by_slug(user_id, slug)
    chapter = book_chapter(book.id, chapter_id)
    new_publish = chapter.visible == false

    chapter
    |> Chapter.changeset(%{title: title, draft: draft, text: draft, sync_time: sync_time, visible: true})
    |> Repo.update

    if new_publish do
      book
      |> Book.changeset(%{last_chapter_published_at: DateTime.utc_now})
      |> Repo.update
    end
  end

  defp current_user_id(conn) do
    conn.assigns[:current_user].id
  end

  defp user_book_by_slug(user_id, slug) do
    Book
    |> Repo.get_by(user_id: user_id, slug: String.downcase(slug))
  end

  defp book_chapter(book_id, chapter_id) do
    Chapter
    |> Repo.get_by(book_id: book_id, id: chapter_id)
  end

  defp next_chapter_order(book_id) do
    last = Repo.one from c in Chapter,
                      where: c.book_id == ^book_id,
                      order_by: [desc: c.order],
                      limit: 1,
                      select: c.order
    if is_nil(last),
      do: 1,
      else: last + 1
  end

  defp find_chapter_by_order(book_id, order) do
    Chapter
    |> Repo.get_by(book_id: book_id, order: order)
  end
end
