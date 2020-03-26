defmodule Crocodile.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field(:name, :string)
    field(:title, :string)
    field(:body, :string)
    timestamps()
  end

  @required_fields ~w(name)a
  @optional_fields ~w(title body)a

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
