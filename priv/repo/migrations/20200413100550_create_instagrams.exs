defmodule Crocodile.Repo.Migrations.CreateInstagrams do
  use Ecto.Migration

  def change do
    create table(:instagrams) do
      add(:image, :string)
      add(:link_to, :string)

      timestamps()
    end
  end
end
