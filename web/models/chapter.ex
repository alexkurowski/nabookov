defmodule App.Chapter do
  use App.Web, :model

  schema "chapters" do
    field :text, :string
    field :visible, :boolean, default: false
    field :locked, :boolean, default: false
    belongs_to :book, App.Book
    has_many :feedback, App.Feedback

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text, :visible, :locked])
    |> validate_required([:text, :visible, :locked])
  end
end
