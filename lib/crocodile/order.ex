defmodule Crocodile.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:name, :string)
    field(:surname, :string)
    field(:email, :string)
    field(:number, :string)
    field(:status, OrderStatus)
    field(:payment_type, PaymentType)
    field(:payment_status, PaymentStatus)
    field(:delivery_type, DeliveryType)
    field(:delivery_status, DeliveryStatus)
    field(:delivery_size, :map)
    field(:phone, :string)
    field(:city, :string)
    field(:address, :string)
    field(:post_index, :string)
    field(:active?, :boolean)
    field(:delivery_date, :naive_datetime)
    field(:delivery_sum, :decimal)
    field(:total_sum, :decimal)

    timestamps()

    belongs_to(:user, Crocodile.User)
    belongs_to(:session, Crocodile.Session, type: :binary_id)
    has_many(:orders_products, Crocodile.OrderProduct, on_delete: :nilify_all)
    has_many(:payments, Crocodile.Payment, on_delete: :nilify_all)

    many_to_many(:products, Crocodile.Product,
      join_through: "orders_products",
      on_replace: :delete
    )
  end

  @required_fields ~w(
    name
    surname
    number
    status
    payment_type
    phone
    city
    session_id
    email
    delivery_type
    delivery_sum
    total_sum
    number
  )a
  @optional_fields ~w(
    payment_status
    delivery_status
    delivery_size
    delivery_date
    address
    user_id
    post_index
    active?
  )a

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields, message: "<Не может быть пустым>")
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[A-Za-z0-9\._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/,
      message: "<Неправильный формат>"
    )
  end
end
