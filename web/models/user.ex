defmodule App.User do
  use App.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :signup_token, :string
    field :signin_token, :string
    has_many :books, App.Book

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :signup_token, :signin_token])
    |> validate_required([])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:name)
    |> unique_constraint(:signup_token)
    |> unique_constraint(:signin_token)
  end

  @doc """
  If `email` and `token` are matched with a user record,
  update that user with a new token and return that new token,
  otherwise remove token (for security) and return nil.
  """
  def maybe_signin(%{"email" => email, "token" => token}) do
    user = App.Repo.get_by(App.User, email: email, signup_token: token)
    if is_nil(user) do
      App.Repo.get_by(App.User, email: email)
      |> remove_token(:signup_token)
      nil
    else
      user
      |> remove_token(:signup_token)
      |> create_token(:signin_token)
      |> Map.fetch(:signin_token)
      |> elem(1)
    end
  end

  @doc """
  Retrieve or create a user record with a given `email`.
  """
  def fetch_by_email(email) do
    App.Repo.get_by(App.User, email: email) ||
    App.Repo.insert(%App.User{email: email})
    |> elem(1)
  end

  @doc """
  Ensure user record exists, adds a new token, and send
  an email with a token to a given `email`.
  """
  def send_signin_email(email) do
    fetch_by_email(email)
    |> create_token(:signup_token)
    |> App.Email.signin
    |> App.Mailer.deliver_now
  end

  defp create_token(nil, _), do: %App.User{}
  defp create_token(user, token) do
    size = if token == :signup_token do 32 else 64 end
    user
    |> changeset(%{token => generate_token(size)})
    |> App.Repo.update
    |> elem(1)
  end

  defp remove_token(user, token) do
    user
    |> changeset(%{token => nil})
    |> App.Repo.update
    |> elem(1)
  end

  defp generate_token(size) do
    :crypto.strong_rand_bytes(size)
    |> Base.url_encode64
    |> binary_part(0, size)
  end
end
