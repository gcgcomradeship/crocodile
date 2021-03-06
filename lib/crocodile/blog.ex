defmodule Crocodile.Blog do
  use Ecto.Schema
  import Ecto.Changeset

  alias CrocodileWeb.Service.Storage.FileWizard

  schema "blogs" do
    field(:author, :string)
    field(:title, :string)
    field(:description, :string)
    field(:inner_html, :string)
    field(:image, :string)
    timestamps()

    has_many(:likes, Crocodile.Like, on_delete: :nilify_all)
  end

  @required_fields ~w(author title description inner_html)a
  @optional_fields ~w(image)a

  @doc false
  def changeset(blog, attrs) do
    updated_attrs = set_image(blog, attrs)

    blog
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
