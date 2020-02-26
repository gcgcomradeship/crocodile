defmodule Crocodile.Repo.Migrations.AddImageToBlog do
  use Ecto.Migration

  def change do
    alter table(:blogs) do
      add(:image, :string)
    end
  end
end
