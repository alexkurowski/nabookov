defmodule App.Data.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    field :description, :string
    field :cover, :string
    field :slug, :string
    field :price, :integer
    field :public, :boolean, default: true
    field :deleted, :boolean, default: false
    field :last_chapter_published_at, :naive_datetime
    belongs_to :user, App.Data.User
    has_many :chapters, App.Data.Chapter
    has_many :feedback, App.Data.Feedback

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :cover, :slug, :price, :public, :deleted, :last_chapter_published_at])
    |> validate_required([])
    |> downcase_slug
    |> unique_constraint(:slug)
  end

  defp downcase_slug(changeset) do
    update_change(changeset, :slug, &String.downcase/1)
  end
end
