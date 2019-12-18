defmodule Crocodile.Context.Items do
  use CrocodileWeb, :context

  alias Crocodile.Category
  alias Crocodile.Product

  # Catalog category filtered query
  def by_category(params) do
    category = Category |> Repo.get(params["category"] || 0)

    Product
    |> where_main()
    |> with_price(params)
    |> by_category_path(category)
    |> order_by([p], asc: p.hit)
    |> Repo.paginate(params)
  end

  def prices_filter(params) do
    category = Category |> Repo.get(params["category"] || 0)

    max_price_lim =
      Product
      |> where_main()
      |> by_category_path(category)
      |> select([p], max(p.price))
      |> Repo.one()

    %{
      max_price_lim: max_price_lim || 10000,
      max_price: params["maxprice"] || max_price_lim,
      min_price_lim: 0,
      min_price: params["minprice"] || 0
    }
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

  # Catalog new products sidebar
  def new_sidebar() do
    Product
    |> where_main()
    |> where([p], p.new == true)
    |> order_by([p], desc: p.created)
    |> limit(9)
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

  defp with_price(query, params) do
    updated_query =
      case params["minprice"] do
        nil -> query
        val -> where(query, [p], p.price >= ^String.to_integer(val))
      end

    case params["maxprice"] do
      nil -> updated_query
      val -> where(updated_query, [p], p.price <= ^String.to_integer(val))
    end
  end
end
