defmodule Crocodile.Services.Sync.DB do
  use CrocodileWeb, :services

  alias Crocodile.Product

  def insert_or_update(%{"code" => code} = struct) do
    product = Product |> Repo.get_by(code: code)

    (product || %Product{})
    |> Product.changeset(struct)
    |> Repo.insert_or_update()
  end
end
