defmodule Crocodile.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:phone, :string)
      add(:mailing, :boolean, default: false)
      add(:encrypted_password, :string)

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end
