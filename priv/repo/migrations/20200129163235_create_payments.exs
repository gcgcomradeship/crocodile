defmodule Crocodile.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:amount, :decimal)
      add(:confirmation_url, :string)
      add(:description, :string)
      add(:account_id, :string)
      add(:gateway_id, :string)
      add(:refundable, :boolean)
      add(:status, :integer)
      add(:kassa_id, :string)

      add(:order_id, references(:orders, on_delete: :nothing))

      timestamps()
    end

    create(index(:payments, [:order_id]))
  end
end
