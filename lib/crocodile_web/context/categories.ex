defmodule Crocodile.Context.Categories do
  use CrocodileWeb, :context

  alias Crocodile.Category

  @exclude [
    "Архив",
    "Каталоги",
    "Упаковка",
    "Рекламная продукция",
    "Оборудование",
    "Маркетинговая поддержка",
    "Промотовары"
  ]

  def hierarchy() do
    Category
    |> where_main()
    |> group_by([c], c.parent_id)
    |> select([c], {c.parent_id, fragment("array_agg(?)", c.id)})
    |> Repo.all()
    |> Enum.into(%{})
  end

  def names() do
    Category
    |> where_main()
    |> select([c], {c.id, c.title})
    |> Repo.all()
    |> Enum.into(%{})
  end

  defp where_main(query) do
    query
    |> where([c], c.msk == true)
    |> where([c], c.title not in ^@exclude)
  end
end
