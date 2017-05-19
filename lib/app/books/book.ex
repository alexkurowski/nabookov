defmodule App.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    field :description, :string
    field :cover, :string
    field :slug, :string
    field :price, :integer
    field :visible, :boolean, default: false
    field :deleted, :boolean, default: false
    belongs_to :user, App.Auth.User
    has_many :chapters, App.Books.Chapter
    has_many :feedback, App.Books.Feedback

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :cover, :slug, :price, :visible, :deleted])
    |> validate_required([])
    |> downcase_slug
    |> unique_constraint(:slug)
  end

  defp downcase_slug(changeset) do
    update_change(changeset, :slug, &String.downcase/1)
  end
end
