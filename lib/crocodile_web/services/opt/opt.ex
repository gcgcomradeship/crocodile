defmodule Crocodile.Services.Opt do
  use CrocodileWeb, :services

  alias Crocodile.Services.Opt.Request

  def products(params) do
    Request.call("/products", params)
  end
end
