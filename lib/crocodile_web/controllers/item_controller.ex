defmodule CrocodileWeb.ItemController do
  use CrocodileWeb, :controller
  alias Crocodile.Item
  alias Crocodile.Context.Items
  alias Crocodile.Services.Catalog.Brands

  # @exclude [
  #   "Архив",
  #   "Каталоги",
  #   "Упаковка",
  #   "Рекламная продукция",
  #   "Оборудование",
  #   "Маркетинговая поддержка",
  #   "Промотовары"
  # ]

  def index(conn, params) do
    page = Items.by_category(params)

    render(conn, "index.html",
      brands: Brands.call(),
      breadcrumbs: breadcrumbs(conn, params),
      items: Items.by_category(params),
      new_sidebar: Items.new_sidebar(),
      page: page
    )
  end

  def show(conn, params) do
    item =
      Item
      |> where([i], i.hide == false)
      |> where([i], not is_nil(i.approve))
      |> Repo.get(params["id"] || 0)

    render(conn, "show.html",
      item: item,
      breadcrumbs: breadcrumbs(conn, params),
      related_items: Items.related_items(item)
    )
  end

  defp breadcrumbs(%{assigns: %{breadcrumbs: breadcrumbs}} = conn, %{"id" => id} = params) do
    item = Item |> Repo.get(params["id"] || 0)

    breadcrumbs
    |> Kernel.++([{"Каталог", Routes.item_path(conn, :index)}])
    |> Kernel.++([
      {item.category, Routes.item_path(conn, :index, category: item.category)},
      {item.subcategory,
       Routes.item_path(conn, :index, category: item.category, subcategory: item.subcategory)},
      {item.name, "#"}
    ])
  end

  defp breadcrumbs(%{assigns: %{breadcrumbs: breadcrumbs}} = conn, params) do
    breadcrumbs
    |> Kernel.++([{"Каталог", Routes.item_path(conn, :index)}])
    |> bread_by_cat(params, conn)
  end

  defp bread_by_cat(breads, %{"category" => category, "subcategory" => subcategory}, conn) do
    breads ++
      [
        {category, Routes.item_path(conn, :index, category: category)},
        {subcategory,
         Routes.item_path(conn, :index, category: category, subcategory: subcategory)}
      ]
  end

  defp bread_by_cat(breads, %{"category" => category}, conn) do
    breads ++ [{category, Routes.item_path(conn, :index, category: category)}]
  end

  defp bread_by_cat(breads, _, _conn), do: breads
end
