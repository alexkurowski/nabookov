defmodule App.Repo.Migrations.CreateFeedback do
  use Ecto.Migration

  def change do
    create table(:feedback) do
      add :status, :integer
      add :comment, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :book_id, references(:books, on_delete: :nothing)
      add :chapter_id, references(:chapters, on_delete: :nothing)

      timestamps()
    end
    create index(:feedback, [:user_id])
    create index(:feedback, [:book_id])
    create index(:feedback, [:chapter_id])

  end
end
