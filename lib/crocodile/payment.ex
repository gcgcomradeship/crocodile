defmodule Crocodile.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "payments" do
    field(:amount, :decimal)
    field(:confirmation_url, :string)
    field(:description, :string)
    field(:account_id, :string)
    field(:gateway_id, :string)
    field(:refundable, :boolean)
    field(:status, PaymentStatus)
    field(:kassa_id, :string)

    timestamps()

    belongs_to(:order, Crocodile.Order)
  end

  @doc false
  @required_fields ~w(amount confirmation_url description account_id gateway_id refundable status kassa_id order_id)a
  @optional_fields ~w()a

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> unique_constraint(:kassa_id)
    |> validate_required(@required_fields)
  end
end
