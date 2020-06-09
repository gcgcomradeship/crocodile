defmodule Crocodile.Services.Telegram do
  use CrocodileWeb, :services

  alias Crocodile.Services.Telegram.Request

  def call() do
    Request.get("getMe")
  end
end
