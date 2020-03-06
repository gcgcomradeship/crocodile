defmodule Crocodile.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "settings" do
    field(:name, :string)
    field(:data, :map)
    timestamps()
  end

  @doc false
  @required_fields ~w(name data)a
  @optional_fields ~w()a

  def changeset(setting, attrs) do
    setting
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
