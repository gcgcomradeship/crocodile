defmodule Crocodile.Repo.Migrations.AddPartnerIdToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add(:partner_id, :string)
    end
  end
end
