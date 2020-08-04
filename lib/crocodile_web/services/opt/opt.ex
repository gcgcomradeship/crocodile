defmodule Crocodile.Services.Opt do
  use CrocodileWeb, :services

  alias Crocodile.Services.Opt.Request

  @params_filter ~w(page page_size old_category old_subcategory)

  def item(id) do
    Request.call("/product/#{id}", %{})
  end

  def products(filter) do
    params =
      filter
      |> Map.take(@params_filter)
      |> Enum.filter(fn {k, v} -> v != "-" end)
      |> Enum.into(%{})

    Request.call("/products", params)
  end

  def old_tree() do
    Request.call("/old_tree", %{})
  end
end
