defmodule Crocodile.Services.Opt.Request do
  use CrocodileWeb, :services

  defp token(), do: Application.get_env(:crocodile, :opt)[:token]
  defp url(), do: Application.get_env(:crocodile, :opt)[:url]
  defp headers(), do: [{"Content-Type", "application/json"}]

  def call(path, params \\ nil) do
    case HTTPoison.post(gate(path), Jason.encode!(tokenize(params)), headers(),
           hackney: [basic_auth: {@email, @token}]
         ) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Jason.decode!(body)

      error ->
        error
    end
  end

  defp gate(path), do: "#{url()}#{path}"
  defp gate(path, params), do: "#{url()}#{path}?#{URI.encode_query(tokenize(params))}"

  defp tokenize(params), do: Map.put(params, :token, token())
end
