defmodule Crocodile.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add(:session_id, references(:sessions, on_delete: :nothing, type: :uuid))
      add(:blog_id, references(:blogs, on_delete: :nothing))
      timestamps()
    end

    create(index(:likes, [:session_id]))
    create(index(:likes, [:blog_id]))
  end
end
