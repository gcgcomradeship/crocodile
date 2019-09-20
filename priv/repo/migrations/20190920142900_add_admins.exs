defmodule Crocodile.Repo.Migrations.AddAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :email, :string
      add :password, :string
    end
  end
end
