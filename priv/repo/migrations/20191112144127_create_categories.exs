defmodule Crocodile.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:title, :string)
      add(:path, :string)
      add(:image, :string)
      add(:code, :string)
      add(:msk, :boolean)

      add(:parent_id, references(:categories, on_delete: :nothing))
      timestamps()
    end

    create(index(:categories, [:parent_id]))
  end
end
