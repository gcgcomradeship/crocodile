defmodule Crocodile.Repo.Migrations.AddItemsSumToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add(:items_sum, :decimal)
    end
  end
end
