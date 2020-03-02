defmodule Crocodile.Repo.Migrations.CreateItemsOrders do
  use Ecto.Migration

  def up do
    create table(:items_orders) do
      add(:quantity, :integer)
      add(:price, :decimal)

      add(:order_id, references(:orders, on_delete: :delete_all))
      add(:item_id, references(:items, on_delete: :delete_all))
    end

    create(index(:items_orders, [:order_id]))
    create(index(:items_orders, [:item_id]))

    create(
      unique_index(:items_orders, [:item_id, :order_id], name: :item_id_order_id_unique_index)
    )

    drop(index(:orders_products, [:order_id]))
    drop(index(:orders_products, [:product_id]))

    drop(
      unique_index(:orders_products, [:product_id, :order_id],
        name: :order_id_product_id_unique_index
      )
    )

    drop(table(:orders_products))
  end

  def down do
    drop(index(:items_orders, [:order_id]))
    drop(index(:items_orders, [:item_id]))

    drop(unique_index(:items_orders, [:item_id, :order_id], name: :item_id_order_id_unique_index))

    drop(table(:items_orders))

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
end
