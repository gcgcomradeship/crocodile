defmodule Crocodile.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:name, :string)
    field(:surname, :string)
    field(:email, :string)
    field(:number, :string)
    field(:partner_id, :string)
    field(:status, OrderStatus)
    field(:payment_type, PaymentType)
    field(:payment_status, PaymentStatus)
    field(:delivery_type, DeliveryType)
    field(:delivery_status, DeliveryStatus)
    field(:delivery_size, :map)
    field(:phone, :string)
    field(:city, :string)
    field(:area, :string)
    field(:street, :string)
    field(:house, :string)
    field(:flat, :string)
    field(:post_index, :string)
    field(:active?, :boolean)
    field(:delivery_date, :naive_datetime)
    field(:items_sum, :decimal)
    field(:delivery_sum, :decimal)
    field(:total_sum, :decimal)
    field(:data, :map)

    field(:deleted_at, :naive_datetime)
    timestamps()

    belongs_to(:user, Crocodile.User)
    belongs_to(:session, Crocodile.Session, type: :binary_id)
    has_many(:items_orders, Crocodile.ItemOrder, on_delete: :nilify_all)
    has_many(:payments, Crocodile.Payment, on_delete: :nilify_all)

    many_to_many(:items, Crocodile.Item,
      join_through: "items_orders",
      on_replace: :delete
    )
  end

  @required_fields ~w(
    name
    number
    status
    payment_type
    phone
    city
    session_id
    email
    delivery_type
    items_sum
    delivery_sum
    total_sum
    number
  )a
  @optional_fields ~w(
    surname
    payment_status
    delivery_status
    delivery_size
    delivery_date
    user_id
    post_index
    active?
    data
    deleted_at
    partner_id
    area
    street
    house
    flat
  )a

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields, message: "*Не может быть пустым")
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[A-Za-z0-9\._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/,
      message: "*Неправильный формат"
    )
    |> check_data()
  end

  defp check_data(%{changes: changes} = changeset) do
    case changes[:data] do
      data when data == %{"terminal_id" => ""} ->
        delete_change(changeset, :data)

      _ ->
        changeset
    end
  end
end
