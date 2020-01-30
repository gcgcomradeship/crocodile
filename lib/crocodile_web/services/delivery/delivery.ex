defmodule Crocodile.Services.Delivery do
  use CrocodileWeb, :services

  @url Application.get_env(:crocodile, :delivery)[:url] || ""
  @sdl Application.get_env(:crocodile, :delivery)[:sdl] || ""
  @client_id Application.get_env(:crocodile, :delivery)[:client_id] || ""
  @sender_id Application.get_env(:crocodile, :delivery)[:sender_id] || ""

  def call() do
    path = "/searchDeliveryList"
    body = %{}
    header = [{"Content-Type", "application/x-www-form-urlencoded"}]

    case HTTPoison.post(@url <> path, build_params(), header) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Jason.decode!(body)

      error ->
        error
    end
  end

  def build_params() do
    params = %{
      # <идентификатор аккаунта в Яндекс.Доставке>
      "client_id" => @client_id,
      # <идентификатор магазина>
      "sender_id" => @sender_id,
      # <город отправления>
      "city_from" => "Москва",
      # <город назначения>
      "city_to" => "Москва",
      # <способ доставки>
      "delivery_type" => "post",
      # <почтовый индекс получателя>
      "index_city" => "117042",
      # <вес заказа>
      "weight" => "1",
      # <длина заказа>
      "length" => "30",
      # <ширина заказа>
      "width" => "10",
      # <высота заказа>
      "height" => "10"
    }

    {:form, Enum.into(Map.put(params, "secret_key", gen_secret(params)), [])}
  end

  def gen_secret(params) do
    params
    |> Map.keys()
    |> Enum.join()
    |> Kernel.<>(@sdl)
    |> md5()
  end

  defp md5(str), do: :crypto.hash(:md5, str) |> Base.encode16() |> String.downcase()
end
