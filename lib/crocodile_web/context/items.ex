defmodule Crocodile.Context.Items do
  use CrocodileWeb, :context

  alias Crocodile.Category
  alias Crocodile.Product

  def by_category(params) do
    category = Category |> Repo.get(params["category"] || 0)

    Product
    |> where_main()
    |> by_category_path(category)
    |> order_by([p], asc: p.hit)
    |> limit(24)
    |> Repo.all()
  end

  def croc_choice() do
    Product
    |> where_main()
    |> order_by([p], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  def new() do
    Product
    |> where_main()
    |> where([p], p.new == true)
    |> order_by([p], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  def recommend() do
    Product
    |> where_main()
    |> order_by([p], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  def hit() do
    Product
    |> where_main()
    |> where([p], p.hit == true)
    |> order_by([p], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  defp where_main(query) do
    query
    |> where([p], p.msk == true)
  end

  defp by_category_path(query, nil), do: query

  defp by_category_path(query, %{path: path}),
    do: where(query, [p], ilike(p.category_new_title, ^"#{path}%"))
end
