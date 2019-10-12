defmodule Crocodile.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do

      timestamps()
    end

  end
end
