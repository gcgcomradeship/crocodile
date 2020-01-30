defmodule Crocodile.Services.Kassa do
  use CrocodileWeb, :services

  @url Application.get_env(:crocodile, :kassa)[:url]
  @shop_id Application.get_env(:crocodile, :kassa)[:id]
  @secret Application.get_env(:crocodile, :kassa)[:secret]

  def call() do
    path = "/payments"

    header = [
      {"Content-Type", "application/json"},
      {"Idempotence-Key", Ecto.UUID.generate()}
    ]

    body = %{
      amount: %{
        value: "100.00",
        currency: "RUB"
      },
      capture: true,
      confirmation: %{
        type: "redirect",
        return_url: "https://www.merchant-website.com/return_url"
      },
      description: "Заказ №1"
    }

    case HTTPoison.post(@url <> path, Jason.encode!(body), header,
           hackney: [basic_auth: {@shop_id, @secret}]
         ) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Jason.decode!(body)

      error ->
        error
    end
  end
end
