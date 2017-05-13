defmodule App.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :signup_token, :string
      add :signin_token, :string

      timestamps()
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:name])
    create unique_index(:users, [:signup_token])
    create unique_index(:users, [:signin_token])

  end
end
