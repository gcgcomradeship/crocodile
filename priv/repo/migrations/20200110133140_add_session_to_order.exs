defmodule Crocodile.Repo.Migrations.AddSessionToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add(:session_id, references(:sessions, on_delete: :nothing, type: :uuid))
      remove(:sid)
    end

    create(index(:orders, [:session_id]))
  end
end
