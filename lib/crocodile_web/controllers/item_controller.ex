defmodule CrocodileWeb.ItemController do
  use CrocodileWeb, :controller
  alias Crocodile.Category
  alias Crocodile.Product

  @exclude [
    "Архив",
    "Каталоги",
    "Упаковка",
    "Рекламная продукция",
    "Оборудование",
    "Маркетинговая поддержка"
  ]

  def index(conn, params) do
    parent =
      Category
      |> where([c], c.title == ^(params["category"] || ""))
      |> Repo.one()

    items =
      Category
      |> where_category(params)
      |> where([c], c.msk == true)
      |> where([c], c.title not in ^@exclude)
      |> Repo.all()
      |> Enum.sort(fn x, y -> :ucol.compare(x.title, y.title) != 1 end)

    render(conn, "index.html", items: items, breadcrumbs: breadcrumbs(params), parent: parent)
  end

  defp where_category(query, params) do
    Category
    |> select([c], c.id)
    |> Repo.get_by(title: params["category"] || "")
    |> case do
      nil -> where(query, [c], is_nil(c.parent_id))
      parent_id -> where(query, [c], c.parent_id == ^parent_id)
    end
  end

  defp breadcrumbs(params) do
    case params["category"] do
      category when category in [nil, "Каталог"] ->
        ["Каталог"]

      title ->
        path =
          Category
          |> Repo.get_by(title: title)
          |> Map.get(:path)

        ["Каталог" | String.split(path, "/")]
    end
  end
end
