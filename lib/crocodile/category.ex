defmodule Crocodile.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field(:title, :string)
    field(:path, :string)
    field(:code, :string)
    field(:msk, :boolean)
    timestamps()

    belongs_to(:parent, Crocodile.Category)
    has_many(:products, Crocodile.Product, on_delete: :nilify_all)
  end

  @required_fields ~w(title)a
  @optional_fields ~w(parent_id code msk path)a

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title)
  end
end
