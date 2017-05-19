defmodule App.Data.Feedback do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feedback" do
    field :status, FeedbackStatus
    field :comment, :string
    belongs_to :user, App.Data.User
    belongs_to :book, App.Data.Book
    belongs_to :chapter, App.Data.Chapter

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :comment])
    |> validate_required([])
  end
end
