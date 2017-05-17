defmodule App.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :description, :string
      add :slug, :string
      add :author, :string
      add :price, :integer, default: 0, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :visible, :boolean, default: false, null: false
      add :deleted, :boolean, default: false, null: false

      timestamps()
    end
    create index(:books, [:user_id])
    create unique_index(:books, [:slug])

  end
end
