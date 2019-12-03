defmodule Crocodile.Services.Sync.DB do
  use CrocodileWeb, :services

  alias Crocodile.Product
  alias Crocodile.Category
  require Logger

  def insert_or_update(%{"code" => code} = struct) do
    product = Product |> Repo.get_by(code: code)

    (product || %Product{})
    |> Product.changeset(struct)
    |> Repo.insert_or_update()
  end

  def insert_or_update_category(%{path: path} = struct) do
    category = Category |> Repo.get_by(path: path)

    (category || %Category{})
    |> Category.changeset(struct)
    |> Repo.insert_or_update()
    |> case do
      {:ok, %{id: id}} ->
        id

      _error ->
        0
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
