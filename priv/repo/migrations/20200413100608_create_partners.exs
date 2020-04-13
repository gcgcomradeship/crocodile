defmodule Crocodile.Repo.Migrations.CreatePartners do
  use Ecto.Migration

  def change do
    create table(:partners) do
      add(:title, :string)
      add(:image, :string)
      add(:link_to, :string)

      timestamps()
    end
  end
end
