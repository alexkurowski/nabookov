defmodule App.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :description, :string
      add :cover, :string, default: "blue"
      add :slug, :string
      add :price, :integer, default: 0, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :visible, :boolean, default: false, null: false
      add :deleted, :boolean, default: false, null: false
      add :last_chapter_published_at, :naive_datetime

      timestamps()
    end
    create index(:books, [:user_id])
    create unique_index(:books, [:slug])

  end
end
