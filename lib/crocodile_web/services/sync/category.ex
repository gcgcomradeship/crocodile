defmodule Crocodile.Services.Sync.Category do
  use CrocodileWeb, :services

  alias Crocodile.Category
  alias Crocodile.Product
  alias Crocodile.Services.Sync.DB

  def call(structs) do
    structs
    |> Enum.map(& &1["category_new_title"])
    |> Enum.uniq()
    |> Enum.map(&String.split(&1, "/"))
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

  def update_presence() do
    category_titles =
      Product
      |> where([p], p.msk == true)
      |> distinct(true)
      |> select([p], p.category_new_title)
      |> Repo.all()
      |> Enum.map(&String.split(&1, "/"))
      |> Enum.flat_map(fn x -> x end)
      |> Enum.uniq()

    Category
    |> where([c], c.title in ^category_titles)
    |> Repo.update_all(set: [msk: true])
  end

  defp create_categories(list), do: exec(list, %{})

  defp exec([], id_acc), do: id_acc

  defp exec([head | tail], id_acc) do
    new_acc = exec_one(head, nil, nil, id_acc)
    exec(tail, new_acc)
  end

  defp exec_one([], _, _path, id_acc), do: id_acc

  defp exec_one([h | t], parent_title, path, id_acc) do
    new_path = set_path(path, h)

    new_acc =
      case Map.get(id_acc, h) do
        nil ->
          parent_id = Map.get(id_acc, parent_title)
          id = DB.insert_category(h, parent_id, new_path)
          Map.put(id_acc, h, id)

        _ ->
          id_acc
      end

    exec_one(t, h, new_path, new_acc)
  end

  defp set_path(nil, title), do: title
  defp set_path(path, title), do: "#{path}/#{title}"
end
