defmodule App.Web.Book do
  use App.Web, :model

  schema "books" do
    field :title, :string
    field :description, :string
    field :slug, :string
    field :author, :string
    field :price, :integer
    field :deleted, :boolean, default: false
    belongs_to :user, App.Web.User
    has_many :chapters, App.Web.Chapter
    has_many :feedback, App.Web.Feedback

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :price])
    |> validate_required([:title, :price])
  end

  def create(user, title, description) do
    %App.Web.Book{user_id: user.id, title: title, description: description}
    |> App.Repo.insert
  end
end
