defmodule Crocodile.Context.Categories do
  use CrocodileWeb, :context

  alias Crocodile.Category
  alias Crocodile.Item

  # @exclude [
  #   "Архив",
  #   "Каталоги",
  #   "Упаковка",
  #   "Рекламная продукция",
  #   "Оборудование",
  #   "Маркетинговая поддержка",
  #   "Промотовары"
  # ]

  def all() do
    Item
    |> where([i], i.insale > 0)
    # |> where([c], c.title not in ^@exclude)
    |> distinct(true)
    |> group_by([i], i.category)
    |> select([i], {i.category, fragment("array_agg(DISTINCT(?))", i.subcategory)})
    |> Repo.all()
    |> Enum.into(%{})
  end
end
