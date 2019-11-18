defmodule Crocodile.Services.Sync.Category do
  use CrocodileWeb, :services

  alias Crocodile.Category
  alias Crocodile.Product
  alias Crocodile.Services.Sync.DB

  def call(structs) do
    structs
    |> Enum.map(&(&1["category_new_title"] |> String.split("/")))
    |> create_categories()
  end

  def update_codes() do
    list =
      Product
      |> distinct(true)
      |> select([p], {p.category_id, p.category_new_code})
      |> Repo.all()

    for {id, code} <- list do
      DB.update_category_code(id, code)
    end
  end

  defp create_categories(list), do: exec(list, %{})

  defp exec([], id_acc), do: id_acc

  defp exec([head | tail], id_acc) do
    new_acc = exec_one(head, nil, id_acc)
    exec(tail, new_acc)
  end

  defp exec_one([], _, id_acc), do: id_acc

  defp exec_one([h | t], parent_title, id_acc) do
    new_acc =
      case Map.get(id_acc, h) do
        nil -> Map.put(id_acc, h, DB.insert_category(h, Map.get(id_acc, parent_title)))
        _ -> id_acc
      end

    exec_one(t, h, new_acc)
  end
end
