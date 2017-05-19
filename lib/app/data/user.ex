defmodule App.Data.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :signup_token, :string
    field :signin_token, :string
    has_many :books, App.Data.Book
    has_many :feedback, App.Data.Feedback

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :signup_token, :signin_token])
    |> validate_required([])
    |> downcase_email
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:signup_token)
    |> unique_constraint(:signin_token)
  end

  defp downcase_email(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end
end
