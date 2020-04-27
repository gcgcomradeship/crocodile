defmodule Crocodile.Repo.Migrations.AddAddressFieldsToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      remove(:address)
      add(:area, :string)
      add(:street, :string)
      add(:house, :string)
      add(:flat, :string)
    end
  end
end
