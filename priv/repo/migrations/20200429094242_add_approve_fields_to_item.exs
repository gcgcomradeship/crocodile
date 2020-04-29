defmodule Crocodile.Repo.Migrations.AddApproveFieldsToItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add(:approve, :naive_datetime)
    end
  end
end
