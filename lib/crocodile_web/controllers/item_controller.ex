defmodule CrocodileWeb.ItemController do
  use CrocodileWeb, :controller
  alias Crocodile.Category
  alias Crocodile.Item
  alias Crocodile.Context.Items
  alias Crocodile.Services.Catalog.Brands

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
    page = Items.by_category(params)

    render(conn, "index.html",
      brands: Brands.call(),
      # breadcrumbs: breadcrumbs(params),
      items: Items.by_category(params),
      new_sidebar: Items.new_sidebar(),
      page: page
    )
  end

  def show(conn, params) do
    item = Item |> Repo.get(params["id"] || 0)

    render(conn, "show.html",
      item: item,
      # breadcrumbs: breadcrumbs(%{"category" => product.category_id}),
      related_items: Items.related_items(item)
    )
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
