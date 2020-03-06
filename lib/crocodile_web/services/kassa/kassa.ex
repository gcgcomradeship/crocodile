defmodule Crocodile.Services.Kassa do
  use CrocodileWeb, :services

  alias Crocodile.Context.Payments
  alias Crocodile.Services.Kassa.Request

  def create(conn, order) do
    with {:ok, body} <- Request.post("/payments", build_payment_params(conn, order)),
         {:ok, %{confirmation_url: confirmation_url} = payment} <- Payments.create(body, order) do
      payment
    else
      error ->
        error
    end
  end

  defp build_payment_params(
         conn,
         %{total_sum: total_sum, number: number} = order
       ) do
    %{
      amount: %{
        value: total_sum,
        currency: "RUB"
      },
      capture: true,
      confirmation: %{
        type: "redirect",
        return_url: redirect_url(conn, order)
      },
      description: "Заказ № #{number}"
    }
  end

  defp redirect_url(conn, order) do
    case Mix.env() do
      :prod -> "https://crocodildo.ru"
      _ -> "http://localhost:4000"
    end
    |> Kernel.<>(Routes.order_path(conn, :show, order, f: 1))
  end
end
