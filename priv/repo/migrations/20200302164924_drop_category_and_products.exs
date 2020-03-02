defmodule Crocodile.Repo.Migrations.DropCategoryAndProducts do
  use Ecto.Migration

  def change do
    drop(index(:products, [:category_id]))
    execute "ALTER TABLE products DROP CONSTRAINT products_category_id_fkey"
    drop(index(:categories, [:parent_id]))
    drop(table(:categories))
    drop(unique_index(:products, [:code]))
    drop(table(:products))
  end
end
