defmodule Crocodile.Services.Telegram.Request do
  use CrocodileWeb, :services

  @url "https://api.telegram.org"
  @token Application.get_env(:crocodile, :telegram)[:token]
  @proxy_ip Application.get_env(:crocodile, :telegram)[:proxy_ip]
  @proxy_port Application.get_env(:crocodile, :telegram)[:proxy_port]
  @proxy_user Application.get_env(:crocodile, :telegram)[:proxy_user]
  @proxy_pass Application.get_env(:crocodile, :telegram)[:proxy_pass]

  def post(method, params) do
    case HTTPoison.post("#{@url}/bot#{@token}/#{method}", Jason.encode!(params), header(),
           proxy: {:socks5, to_charlist(@proxy_ip), String.to_integer(@proxy_port)},
           socks5_user: @proxy_user,
           socks5_pass: @proxy_pass
         ) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Jason.decode(body)

      error ->
        error
    end
  end

  def get(method) do
    case HTTPoison.get("#{@url}/bot#{@token}/#{method}", header(),
           proxy: {:socks5, to_charlist(@proxy_ip), String.to_integer(@proxy_port)},
           socks5_user: @proxy_user,
           socks5_pass: @proxy_pass
         ) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Jason.decode(body)

      error ->
        error
    end
  end

  defp header() do
    [
      {"Content-Type", "application/json"}
    ]
  end
end
