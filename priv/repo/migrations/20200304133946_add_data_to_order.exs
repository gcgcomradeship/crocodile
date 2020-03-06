defmodule Crocodile.Repo.Migrations.AddDataToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add(:data, :map, default: %{})
    end
  end
end
