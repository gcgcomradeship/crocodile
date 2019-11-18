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

  def index(conn, _params) do
    items =
      Category
      |> where([c], is_nil(c.parent_id))
      |> where([c], c.title not in ^@exclude)
      |> distinct(true)
      # |> order_by([c], asc: c.title)
      |> select([c], c.title)
      |> Repo.all()

    render(conn, "index.html", items: items)
  end
end
