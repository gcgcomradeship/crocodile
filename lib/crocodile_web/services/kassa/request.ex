defmodule Crocodile.Services.Kassa.Request do
  use CrocodileWeb, :services

  @url Application.get_env(:crocodile, :kassa)[:url]
  @shop_id Application.get_env(:crocodile, :kassa)[:id]
  @secret Application.get_env(:crocodile, :kassa)[:secret]

  def post(path, params) do
    case HTTPoison.post(@url <> path, Jason.encode!(params), header(),
           hackney: [basic_auth: {@shop_id, @secret}]
         ) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Jason.decode(body)

      error ->
        error
    end
  end

  defp header() do
    [
      {"Content-Type", "application/json"},
      {"Idempotence-Key", Ecto.UUID.generate()}
    ]
  end
end
