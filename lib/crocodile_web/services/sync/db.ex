defmodule Crocodile.Services.Sync.DB do
  use CrocodileWeb, :services

  alias Crocodile.Product
  alias Crocodile.Category

  def insert_or_update(%{"code" => code} = struct) do
    product = Product |> Repo.get_by(code: code)

    (product || %Product{})
    |> Product.changeset(struct)
    |> Repo.insert_or_update()
  end

  def insert_category(title, parent_id, path) do
    Category
    |> Repo.get_by(title: title)
    |> case do
      %{id: id} = record ->
        record
        |> Category.changeset(%{parent_id: parent_id, title: title, path: path})
        |> Repo.update()

        id

      nil ->
        {:ok, %{id: id}} =
          %Category{}
          |> Category.changeset(%{parent_id: parent_id, title: title, path: path})
          |> Repo.insert()

        id
    end
  end

  def update_category_code(id, code) do
    Category
    |> Repo.get(id)
    |> case do
      nil ->
        nil

      record ->
        record
        |> Category.changeset(%{code: code})
        |> Repo.update()
    end
  end
end
