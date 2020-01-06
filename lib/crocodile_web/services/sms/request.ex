defmodule Crocodile.Services.SMS.Request do
  use CrocodileWeb, :services

  @email "test"
  @token "test"
  @url "https://gate.smsaero.ru/v2"

  def call(path, params \\ nil) do
    url = gate(path, params)

    case HTTPoison.get(url, [], hackney: [basic_auth: {@email, @token}]) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Jason.decode!(body)

      error ->
        error
    end
  end

  defp gate(path, nil), do: "#{@url}#{path}"
  defp gate(path, params), do: "#{@url}#{path}?#{URI.encode_query(params)}"
end
