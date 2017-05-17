defmodule App.Books.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chapters" do
    field :text, :string
    field :visible, :boolean, default: false, null: false
    field :locked, :boolean, default: false, null: false
    belongs_to :book, App.Books.Book
    has_many :feedback, App.Books.Feedback

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text, :visible, :locked])
    |> validate_required([])
  end
end
