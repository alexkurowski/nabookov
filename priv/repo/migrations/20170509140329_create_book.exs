defmodule App.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :description, :string
      add :slug, :string
      add :price, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:books, [:user_id])
    create unique_index(:books, [:slug])

  end
end
