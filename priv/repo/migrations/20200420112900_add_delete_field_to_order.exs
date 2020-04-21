defmodule Crocodile.Repo.Migrations.AddDeleteFieldToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add(:deleted_at, :naive_datetime)
    end
  end
end
