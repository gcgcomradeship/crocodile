defmodule Crocodile.ItemOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items_orders" do
    field(:quantity, :integer)
    field(:price, :decimal)

    belongs_to(:order, Crocodile.Order)
    belongs_to(:item, Crocodile.Item)
  end

  @required_fields ~w(order_id item_id quantity price)a
  @optional_fields ~w()a

  @doc false
  def changeset(order_product, attrs) do
    order_product
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
