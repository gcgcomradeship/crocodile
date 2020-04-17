defmodule Crocodile.Context.Items do
  use CrocodileWeb, :context

  alias Crocodile.Category
  alias Crocodile.Product
  alias Crocodile.Services.Cart

  alias Crocodile.Item

  def by_category(%{"search" => search} = params) do
    Item
    |> where_main()
    |> where_search(search)
    |> sort_filter(params)
    |> Repo.paginate(params)
  end

  def by_category(params) do
    Item
    |> where_main()
    |> where_category(params)
    |> where_brand(params)
    |> with_price(params)
    |> sort_filter(params)
    |> Repo.paginate(params)
  end

  def croc_choice() do
    Item
    |> where_main()
    |> order_by([i], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  def new() do
    Item
    |> where_main()
    |> order_by([i], desc: i.inserted_at)
    |> limit(8)
    |> Repo.all()
  end

  def recommend() do
    Item
    |> where_main()
    |> order_by([i], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  def hit() do
    Item
    |> where_main()
    # |> where([p], p.hit == true)
    |> order_by([p], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  def new_sidebar() do
    Item
    |> where_main()
    |> order_by([i], desc: i.inserted_at)
    # |> order_by([p], desc: p.created)
    |> limit(9)
    |> Repo.all()
  end

  def related_items(%{id: id, subcategory: subcategory}) do
    Item
    |> where_main()
    |> where([p], p.subcategory == ^subcategory)
    |> where([p], p.id != ^id)
    |> order_by([p], fragment("RANDOM()"))
    |> limit(6)
    |> Repo.all()
  end

  def cart_by_sid(sid) do
    cart = Cart.get(sid)

    items =
      Item
      |> where_main()
      |> where([i], i.id in ^Map.keys(cart))
      |> Repo.all()

    for item <- items do
      Map.put(item, :count, Map.get(cart, "#{item.id}")["cnt"])
    end
  end

  defp where_main(query) do
    query
    |> where([i], i.insale > 0)
    |> where([i], i.hide == false)
  end

  defp where_category(query, %{"category" => category, "subcategory" => subcategory}),
    do: where(query, [i], i.subcategory == ^subcategory and i.category == ^category)

  defp where_category(query, %{"category" => category}),
    do: where(query, [i], i.category == ^category)

  defp where_category(query, _params),
    do: query

  defp with_price(query, params) do
    updated_query =
      case params["min_price"] do
        res when res in [nil, ""] -> query
        val -> where(query, [i], i.retail_price >= ^String.to_integer(val))
      end

    case params["max_price"] do
      res when res in [nil, ""] -> updated_query
      val -> where(updated_query, [i], i.retail_price <= ^String.to_integer(val))
    end
  end

  defp sort_filter(query, params) do
    case params["sort"] do
      "htl" -> order_by(query, [i], desc: i.retail_price)
      "lth" -> order_by(query, [i], asc: i.retail_price)
      _ -> query
    end
  end

  defp where_brand(query, params) do
    case params["brand"] do
      val when val in [nil, "", "Все"] -> query
      val -> where(query, [i], i.vendor == ^val)
    end
  end

  defp where_search(query, search_string) do
    arr = String.split(search_string, " ")
    search_expr(query, arr)
  end

  defp search_expr(query, []), do: query

  defp search_expr(query, [h | t]) do
    like_str = "%#{h}%"
    where(query, [i], ilike(i.name, ^like_str) or ilike(i.partner_id, ^like_str))
  end
end
