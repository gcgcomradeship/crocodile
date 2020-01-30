defmodule Crocodile.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      # add(:account_id, :integer)
      # add(:amount, :decimal)
      # add(:psp_amount, :decimal)
      # add(:currency, :integer)
      # add(:psp_currency, :integer)
      # add(:user_amount, :decimal)
      # add(:user_currency, :integer)
      # add(:owallet_transaction_id, :integer)
      # add(:psp_transaction_id, :integer)
      # add(:action, :integer)
      # add(:uuid, :string)
      # add(:status, :integer)

      # add(:provider_id, references(:providers, on_delete: :nothing))
      # add(:origin_id, references(:origins, on_delete: :nothing))

      timestamps()
    end

    # create(index(:payments, [:provider_id]))
    # create(index(:payments, [:origin_id]))
  end
end
