defmodule Crocodile.Banner do
  use Ecto.Schema
  import Ecto.Changeset

  alias CrocodileWeb.Service.Storage.FileWizard

  schema "banners" do
    field(:name, :string)
    field(:text1, :string)
    field(:text2, :string)
    field(:text3, :string)
    field(:path, :string)
    field(:link_to, :string)
    timestamps()
  end

  @required_fields ~w(name)a
  @optional_fields ~w(link_to text1 text2 text3 path)a

  @doc false
  def changeset(banner, attrs) do
    updated_attrs = set_image(banner, attrs)

    banner
    |> cast(updated_attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  defp set_image(%{path: path}, %{"path" => %Plug.Upload{} = image} = attrs) do
    new_path = FileWizard.save(image)
    FileWizard.delete(path)
    Map.merge(attrs, %{"path" => new_path})
  end

  defp set_image(_, attrs), do: attrs
end
