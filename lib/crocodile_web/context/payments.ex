defmodule Crocodile.Context.Payments do
  use CrocodileWeb, :context

  alias Crocodile.Payment

  def create(
        %{
          "amount" => %{"currency" => "RUB", "value" => amount},
          "confirmation" => %{
            "confirmation_url" => confirmation_url
          },
          "description" => description,
          "id" => kassa_id,
          "recipient" => %{"account_id" => account_id, "gateway_id" => gateway_id},
          "refundable" => refundable,
          "status" => status
        } = params,
        %{id: order_id} = order
      ) do
    attrs = %{
      amount: amount,
      confirmation_url: confirmation_url,
      description: description,
      account_id: account_id,
      gateway_id: gateway_id,
      refundable: refundable,
      status: status,
      kassa_id: kassa_id,
      order_id: order_id
    }

    changeset = Payment.changeset(%Payment{}, attrs)

    case Repo.insert(changeset) do
      {:ok, payment} = result -> result
      error -> error
    end
  end

  def on_order_update(payment, params) do
    payment
    |> Payment.changeset(params)
    |> Repo.update()
  end
end
