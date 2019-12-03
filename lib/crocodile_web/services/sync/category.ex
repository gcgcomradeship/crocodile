defmodule Crocodile.Services.Sync.Category do
  use CrocodileWeb, :services

  alias Crocodile.Category
  alias Crocodile.Product
  alias Crocodile.Services.Sync.DB

  def call() do
    create_categories()
    categories_heritage()
    update_products()
    update_codes()
    update_presence()
    update_temp_img()
  end

  def create_categories() do
    paths =
      Product
      |> distinct(true)
      |> select([p], p.category_new_title)
      |> Repo.all()
      |> add_parent_categories()

    for path <- paths do
      %{
        path: path,
        title: path |> String.split("/") |> List.last()
      }
      |> DB.insert_or_update_category()
    end

    :ok
  end

  def categories_heritage() do
    Category
    |> Repo.update_all(set: [parent_id: nil])

    Category
    |> select([c], c.path)
    |> Repo.all()
    |> exec_heritage()
  end

  defp update_products() do
    categories =
      Category
      |> Repo.all()

    for %{id: id, path: path} <- categories do
      Product
      |> where([p], p.category_new_title == ^path)
      |> Repo.update_all(set: [category_id: id])
    end
  end

  defp exec_heritage([]), do: :ok

  defp exec_heritage(other) do
    min_counter = other |> Enum.map(&(&1 |> String.split("/") |> length())) |> Enum.min()

    current =
      other |> Enum.filter(&(&1 |> String.split("/") |> length() |> Kernel.==(min_counter)))

    for path <- current do
      parent_id = Category |> select([c], c.id) |> Repo.get_by(path: path)

      Category
      |> where([c], ilike(c.path, ^"#{path}/%"))
      |> Repo.update_all(set: [parent_id: parent_id])
    end

    exec_heritage(other -- current)
  end

  defp update_codes() do
    list =
      Product
      |> distinct(true)
      |> select([p], {p.category_id, p.category_new_code})
      |> Repo.all()

    for {id, code} <- list do
      DB.update_category_code(id, code)
    end
  end

  defp update_presence() do
    Category
    |> Repo.update_all(set: [msk: false])

    category_paths =
      Product
      |> where([p], p.msk == true)
      |> distinct(true)
      |> select([p], p.category_new_title)
      |> Repo.all()
      |> Enum.uniq()
      |> add_parent_categories()

    Category
    |> where([c], c.path in ^category_paths)
    |> Repo.update_all(set: [msk: true])
  end

  defp add_parent_categories(list) do
    add_parent(list, list)
  end

  defp add_parent([], acc), do: acc

  defp add_parent(list, acc) do
    new_list =
      for path <- list do
        path
        |> String.split("/")
        |> List.delete_at(-1)
        |> Enum.join("/")
      end
      |> Enum.uniq()
      |> Enum.filter(&(length(String.split(&1, "/")) > 1 || &1 not in acc))

    add_parent(new_list, acc ++ new_list)
  end

  def update_temp_img() do
    categories = Category |> Repo.all()

    for category <- categories do
      image = get_image(category.path)

      category
      |> Category.changeset(%{image: image})
      |> Repo.update()
    end
  end

  defp get_image(path), do: get_image(path, 0)
  defp get_image(_path, 10), do: nil

  defp get_image(path, count) do
    Product
    |> where([p], ilike(p.category_new_title, ^"#{path}%"))
    |> select([p], p.images)
    |> Repo.all()
    |> Enum.random()
    |> case do
      [image | _] -> image
      _ -> get_image(path, count + 1)
    end
  end
end
