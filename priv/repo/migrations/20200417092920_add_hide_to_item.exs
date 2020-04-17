defmodule Crocodile.Repo.Migrations.AddHideToItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add(:hide, :boolean, default: false)
    end
  end
end
