defmodule Crocodile.Repo.Migrations.AddFieldsToItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add(:hit, :boolean, default: false)
      add(:new, :boolean, default: false)
    end
  end
end
