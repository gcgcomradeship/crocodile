defmodule Crocodile.OrderProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders_products" do
    field(:quantity, :integer)
    field(:price, :decimal)

    belongs_to(:order, Crocodile.Order)
    belongs_to(:product, Crocodile.Product)
    timestamps()
  end

  @required_fields ~w(order_id product_id quantity price)a
  @optional_fields ~w()a

  @doc false
  def changeset(order_product, attrs) do
    order_product
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
