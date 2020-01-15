defmodule Crocodile.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      timestamps()

      add(:user_id, references(:users, on_delete: :nothing))
    end

    create(index(:sessions, [:user_id]))
  end
end
