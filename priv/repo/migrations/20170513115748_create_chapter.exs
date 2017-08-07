defmodule App.Repo.Migrations.CreateChapter do
  use Ecto.Migration

  def change do
    create table(:chapters) do
      add :title, :string
      add :text, :text
      add :draft, :text
      add :order, :integer, default: 0
      add :sync_time, :string
      add :visible, :boolean, default: false, null: false
      add :locked, :boolean, default: false, null: false
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end
    create index(:chapters, [:book_id])

  end
end
