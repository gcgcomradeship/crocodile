defmodule Crocodile.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:title, :string)
      add(:code, :string)

      add(:parent_id, references(:categories, on_delete: :nothing))
      timestamps()
    end

    create(index(:categories, [:parent_id]))
    create(unique_index(:categories, [:title]))
  end
end
