defmodule CrocodileWeb.ProductController do
  use CrocodileWeb, :controller
  alias Crocodile.Category
  alias Crocodile.Product
  alias Crocodile.Context.Categories
  alias Crocodile.Context.Items

  @exclude [
    "Архив",
    "Каталоги",
    "Упаковка",
    "Рекламная продукция",
    "Оборудование",
    "Маркетинговая поддержка",
    "Промотовары"
  ]

  def index(conn, params) do
    parent =
      Category
      |> Repo.get(params["category"] || 0)

    items =
      Category
      |> where_category(params)
      |> where([c], c.msk == true)
      |> where([c], c.title not in ^@exclude)
      |> Repo.all()
      |> Enum.sort(fn x, y -> :ucol.compare(x.title, y.title) != 1 end)

    page = Items.by_category(params)

    render(conn, "index.html",
      breadcrumbs: breadcrumbs(params),
      parent: parent,
      products: Items.by_category(params),
      cat_hierarchy: Categories.hierarchy(),
      cat_names: Categories.names(),
      new_sidebar: Items.new_sidebar(),
      page: page,
      items: page.entries,
      prices_filter: Items.prices_filter(params),
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
  end

  def show(conn, params) do
    product = Product |> Repo.get(params["id"] || 0)
    render(conn, "show.html", product: product)
  end

  defp where_category(query, params) do
    Category
    |> select([c], c.id)
    |> Repo.get(params["category"] || 0)
    |> case do
      nil -> where(query, [c], is_nil(c.parent_id))
      parent_id -> where(query, [c], c.parent_id == ^parent_id)
    end
  end

  defp where_parent(query, parent) do
    case parent do
      %{id: id} -> where(query, [p], p.category_id == ^id)
      _ -> where(query, [p], false)
    end
  end

  defp breadcrumbs(params) do
    case params["category"] do
      category when category in [nil, 0, "0"] ->
        [{"Каталог", 0}]

      id ->
        [{"Каталог", 0} | collect_crumbs(id, [])]
    end
  end

  defp collect_crumbs(nil, acc), do: acc

  defp collect_crumbs(cid, acc) do
    {id, title, parent_id} =
      Category
      |> select([c], {c.id, c.title, c.parent_id})
      |> Repo.get(cid)
      |> case do
        nil -> {0, "Каталог", nil}
        result -> result
      end

    collect_crumbs(parent_id, [{title, id} | acc])
  end
end
