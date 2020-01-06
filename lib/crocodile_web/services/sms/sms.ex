defmodule Crocodile.Services.SMS do
  use CrocodileWeb, :services

  alias Crocodile.Services.SMS.Request

  def send(phone, text) do
    params = %{
      number: phone,
      text: text,
      sign: @sign,
      channel: @channel
    }

    Request.call("/sms/send", params)
  end

  def add_sign(sign) do
    params = %{name: sign}
    Request.call("/sign/add", params)
  end

  def sign_list() do
    Request.call("/sign/list")
  end

  defp gate(path, params) do
    "#{@url}#{path}?#{URI.encode_query(params)}"
  end
end
