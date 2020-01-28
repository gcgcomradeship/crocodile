defmodule Crocodile.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id

  schema "orders" do
    field(:name, :string)
    field(:email, :string)
    field(:number, :string)
    field(:status, OrderStatus)
    field(:payment_type, PaymentType)
    field(:delivery_type, DeliveryType)
    field(:phone, :string)
    field(:city, :string)
    field(:address, :string)
    field(:post_index, :string)
    timestamps()

    belongs_to(:user, Crocodile.User)
    belongs_to(:session, Crocodile.Session)

    many_to_many(:products, Crocodile.Products,
      join_through: "orders_products",
      on_replace: :delete
    )
  end

  @required_fields ~w(name number status payment_type phone city session_id email delivery_type)a
  @optional_fields ~w(address user_id post_index)a

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields, message: "<Не может быть пустым>")
  end
end
