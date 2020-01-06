defmodule Crocodile.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:number, :string)
      add(:status, :integer)
      timestamps()
    end
  end
end
