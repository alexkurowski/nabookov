defmodule App.Data.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chapters" do
    field :title, :string
    field :text, :string
    field :draft, :string
    field :order, :integer
    field :visible, :boolean, default: false, null: false
    field :locked, :boolean, default: false, null: false
    belongs_to :book, App.Data.Book
    has_many :feedback, App.Data.Feedback

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :text, :draft, :order, :visible, :locked])
    |> validate_required([])
  end
end