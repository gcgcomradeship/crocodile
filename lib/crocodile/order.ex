defmodule Crocodile.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:number, :string)
    field(:status, OrderStatus)
    timestamps()

    many_to_many(:products, Crocodile.Products,
      join_through: "orders_products",
      on_replace: :delete
    )
  end

  @required_fields ~w(number)a
  @optional_fields ~w()a

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
