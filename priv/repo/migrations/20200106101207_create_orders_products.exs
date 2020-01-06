defmodule Crocodile.Repo.Migrations.CreateOrdersProducts do
  use Ecto.Migration

  def up do
    create table(:orders_products) do
      add(:quantity, :integer)
      add(:price, :decimal)

      add(:order_id, references(:orders, on_delete: :delete_all))
      add(:product_id, references(:products, on_delete: :delete_all))
    end

    create(index(:orders_products, [:order_id]))
    create(index(:orders_products, [:product_id]))

    create(
      unique_index(:orders_products, [:product_id, :order_id],
        name: :order_id_product_id_unique_index
      )
    )
  end

  def down do
    drop(index(:orders_products, [:order_id]))
    drop(index(:orders_products, [:product_id]))

    drop(
      unique_index(:orders_products, [:product_id, :order_id],
        name: :order_id_product_id_unique_index
      )
    )

    drop(table(:orders_products))
  end
end
