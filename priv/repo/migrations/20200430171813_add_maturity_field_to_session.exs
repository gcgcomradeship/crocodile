defmodule Crocodile.Repo.Migrations.AddMaturityFieldToSession do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      add(:maturity, :boolean, default: false)
    end
  end
end
