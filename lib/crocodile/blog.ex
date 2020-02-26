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
  @optional_fields ~w()a

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> upload_image(attrs, blog)
  end

  defp upload_image(
         %{valid?: true} = changeset,
         %{"image" => image},
         _blog
       )
       when image in [nil, ""] do
    put_change(changeset, :image, nil)
  end

  defp upload_image(
         %{valid?: true} = changeset,
         %{"image" => file_data},
         %{image: image} = _blog
       )
       when not is_nil(file_data) do
    image_url = FileWizard.save(file_data)
    FileWizard.delete(image)

    put_change(changeset, :image, image_url)
  end

  defp upload_image(changeset, _attrs, _blog), do: changeset
end
