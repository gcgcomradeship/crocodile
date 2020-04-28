defmodule Crocodile.Repo.Migrations.AddProdIdToItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add(:group_id, :string)
    end
  end
end
