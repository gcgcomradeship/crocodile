defmodule Crocodile.Repo.Migrations.CreateBanners do
  use Ecto.Migration

  def change do
    create table(:banners) do
      add(:name, :string)
      add(:text1, :string)
      add(:text2, :string)
      add(:text3, :string)
      add(:path, :string)
      add(:link_to, :string, default: "#")

      timestamps()
    end
  end
end
