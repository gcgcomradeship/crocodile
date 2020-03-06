defmodule Crocodile.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add(:name, :string)
      add(:data, :map, default: %{})
      timestamps()
    end
  end
end
