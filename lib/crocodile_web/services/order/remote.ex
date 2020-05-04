defmodule Crocodile.Services.Order.Remote do
  use CrocodileWeb, :services

  alias Crocodile.Order

  @api_key Application.get_env(:crocodile, :remote)[:ps_api_key]
  @api_url "http://api.ds-platforma.ru/ds_order.php"

  def call(data) do
    body =
      case Mix.env() do
        :prod ->
          Map.merge(data, %{"ApiKey" => @api_key})

        _ ->
          Map.merge(data, %{"ApiKey" => @api_key, "TestMode" => 1})
      end

    case HTTPoison.get(@api_url <> "?" <> URI.encode_query(body), []) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        body
        |> parse_response()
        |> Map.get("Result")

      error ->
        error
    end
  end

  defp parse_response(body) do
    XmlToMap.naive_map(body)
  end
end
