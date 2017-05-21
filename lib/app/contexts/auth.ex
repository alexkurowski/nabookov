defmodule App.Auth do
  @moduledoc """
  The boundary for the Auth system.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Data.User


  @doc """
  Get user by a matching `signin_token`.
  """
  def find_by_token(token) do
    Repo.get_by(User, signin_token: token)
  end

  @doc """
  Retrieve or create a user record with a given `email`.
  """
  def fetch_by_email(email) do
    email = String.downcase(email)
    Repo.get_by(User, email: email) ||
    Repo.insert(%User{email: email})
    |> elem(1)
  end

  @doc """
  If `email` and `token` are matched with a user record,
  update that user with a new token and return that new token,
  otherwise remove token (for security) and return nil.
  """
  def maybe_signin(nil, _), do: nil
  def maybe_signin(_, nil), do: nil
  def maybe_signin(email, token) do
    user = fetch_by_email(email)
    if user.signup_token == token do
      user
      |> remove_token(:signup_token)
      |> create_token(:signin_token)
      |> Map.fetch(:signin_token)
      |> elem(1)
    else
      user
      |> remove_token(:signup_token)
      nil
    end
  end

  @doc """
  Ensure user record exists, adds a new token, and send
  an email with a token to a given `email`.
  """
  def send_signin_email(email) do
    fetch_by_email(email)
    |> create_token(:signup_token)
    |> App.Web.Email.signin
    |> App.Mailer.deliver_now
  end

  @doc """
  Check if user name is taken
  """
  def name_taken?(name) do
    Repo.one(from u in User,
               select: count("*"),
               where: fragment("? = lower(?)", ^String.downcase(name), u.name)) > 0
  end

  @doc """
  Update user name
  """
  def update_name(user, name) do
    user
    |> User.changeset(%{name: name})
    |> Repo.update
  end


  defp create_token(nil, _), do: %User{}
  defp create_token(user, token) do
    size = if token == :signup_token do 16 else 64 end
    user
    |> User.changeset(%{token => generate_token(size)})
    |> Repo.update
    |> elem(1)
  end

  defp remove_token(user, token) do
    user
    |> User.changeset(%{token => nil})
    |> Repo.update
    |> elem(1)
  end

  def generate_token(size) do
    :crypto.strong_rand_bytes(size)
    |> Base.url_encode64
    |> binary_part(0, size)
  end
end
