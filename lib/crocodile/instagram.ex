defmodule Crocodile.Instagram do
  use Ecto.Schema
  import Ecto.Changeset

  alias CrocodileWeb.Service.Storage.FileWizard

  schema "instagrams" do
    field(:image, :string)
    field(:link_to, :string)

    timestamps()
  end

  @required_fields ~w(link_to)a
  @optional_fields ~w(image)a

  @doc false
  def changeset(instagram, attrs) do
    updated_attrs = set_image(instagram, attrs)

    instagram
    |> cast(updated_attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  defp set_image(%{image: image}, %{"image" => %Plug.Upload{} = upload_image} = attrs) do
    new_path = FileWizard.save(upload_image)
    FileWizard.delete(image)
    Map.merge(attrs, %{"image" => new_path})
  end

  defp set_image(_, attrs), do: attrs
end
