defmodule Crocodile.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [])
    |> validate_required([])
  end
end
