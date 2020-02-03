defmodule Crocodile.Repo.Migrations.AddFieldsToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add(:name, :string)
      add(:surname, :string)
      add(:email, :string)
      add(:post_index, :string)
      add(:delivery_type, :integer)

      add(:payment_status, :integer, default: 0)
      add(:delivery_status, :integer, default: 0)
      add(:delivery_size, :map, default: %{})
      add(:active?, :boolean, default: true)
      add(:delivery_date, :naive_datetime)
      add(:delivery_sum, :decimal)
      add(:total_sum, :decimal)
    end
  end
end
