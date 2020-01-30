defmodule Crocodile.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "payments" do
    # field(:account_id, :string)
    # field(:amount, :decimal)
    # field(:currency, Currency)
    # field(:psp_amount, :decimal)
    # field(:psp_currency, Currency)
    # field(:user_amount, :decimal)
    # field(:user_currency, Currency)
    # field(:owallet_transaction_id, :string)
    # field(:psp_transaction_id, :id)
    # field(:action, Operation)
    # field(:status, PaymentStatus)
    # field(:params, :map)
    # field(:user_data, :map)
    # field(:error_data, :map)
    # field(:payload_data, :map)
    # field(:user_ip, :string)
    # field(:description, :string)

    timestamps()

    # belongs_to(:provider, Opm.Provider)
    # belongs_to(:origin, Opm.Origin)
  end

  @doc false
  @required_fields ~w()a
  @optional_fields ~w()a

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
