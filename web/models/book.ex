defmodule App.Book do
  use App.Web, :model

  schema "novels" do
    field :title, :string
    field :price, :integer
    belongs_to :user, App.User

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
end
