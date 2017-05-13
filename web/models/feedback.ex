defmodule App.Feedback do
  use App.Web, :model

  schema "feedback" do
    field :status, FeedbackStatus
    field :comment, :string
    belongs_to :user, App.User
    belongs_to :book, App.Book
    belongs_to :chapter, App.Chapter

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :comment])
    |> validate_required([:status, :comment])
  end
end
