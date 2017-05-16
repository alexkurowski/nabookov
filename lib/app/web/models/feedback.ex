defmodule App.Web.Feedback do
  use App.Web, :model

  schema "feedback" do
    field :status, FeedbackStatus
    field :comment, :string
    belongs_to :user, App.Web.User
    belongs_to :book, App.Web.Book
    belongs_to :chapter, App.Web.Chapter

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
