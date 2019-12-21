defmodule Crocodile.Services.Catalog.Brands do
  use CrocodileWeb, :services

  alias Crocodile.Product
  alias Crocodile.Context.Categories

  def call(nil) do
    case Redis.get(key("")) do
      nil -> []
      val -> Jason.decode!(val)
    end
  end

  def call(%{path: path}) do
    case Redis.get(key(path)) do
      nil -> []
      val -> Jason.decode!(val)
    end
  end

  def refresh() do
    products =
      Product
      |> where([p], p.msk == true)
      |> Repo.all()

    categories = Categories.all()

    for category <- [%{path: ""} | categories] do
      update_brands(category, products)
    end

    :ok
  end

  defp update_brands(%{path: path}, products) do
    val =
      products
      |> Enum.filter(
        &(String.starts_with?(&1.category_new_title, path) and not is_nil(&1.brand_title))
      )
      |> Enum.group_by(& &1.brand_title)
      |> Enum.map(fn {k, v} -> {length(v), k} end)
      |> Enum.sort(fn {i1, _}, {i2, _} -> i1 > i2 end)
      |> Enum.take(10)
      |> Enum.map(fn {_, title} -> title end)
      |> Jason.encode!()

    path
    |> key()
    |> Redis.set(val)
  end

  defp key(path) do
    "brand/#{path}"
  end
end
