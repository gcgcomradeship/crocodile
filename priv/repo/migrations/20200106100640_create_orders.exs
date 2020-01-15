defmodule Crocodile.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:number, :string)
      add(:status, :integer)
      add(:payment_type, :integer)
      add(:phone, :string)
      add(:city, :string)
      add(:address, :string)
      add(:sid, :string)
      timestamps()
    end
  end
end
