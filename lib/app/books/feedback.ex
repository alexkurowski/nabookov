defmodule App.Books.Feedback do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feedback" do
    field :status, FeedbackStatus
    field :comment, :string
    belongs_to :user, App.Auth.User
    belongs_to :book, App.Books.Book
    belongs_to :chapter, App.Books.Chapter

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :comment])
    |> validate_required([:status, :comment])
  end
end
