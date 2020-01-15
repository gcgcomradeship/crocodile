defmodule Crocodile.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id

  schema "orders" do
    field(:number, :string)
    field(:status, OrderStatus)
    field(:payment_type, PaymentType)
    field(:phone, :string)
    field(:city, :string)
    field(:address, :string)
    timestamps()

    belongs_to(:user, Crocodile.User)
    belongs_to(:session, Crocodile.Session)

    many_to_many(:products, Crocodile.Products,
      join_through: "orders_products",
      on_replace: :delete
    )
  end

  @required_fields ~w(number status payment_type phone city session_id)a
  @optional_fields ~w(address user_id)a

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
