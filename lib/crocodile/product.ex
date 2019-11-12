defmodule Crocodile.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field(:code, :string)
    field(:article, :string)
    field(:title, :string)
    field(:description, :string)

    field(:group_code, :string)
    field(:group_title, :string)
    field(:category_code, :string)
    field(:category_title, :string)
    field(:manufacturer, :string)
    field(:barcode, :string)
    field(:collection, :string)
    field(:brand_code, :string)
    field(:brand_title, :string)
    field(:modification_code, :string)
    field(:category_new_code, :string)
    field(:category_new_title, :string)

    field(:size, :string)
    field(:length, :string)
    field(:width, :string)
    field(:width_packed, :string)
    field(:height_packed, :string)
    field(:length_packed, :string)
    field(:weight_packed, :string)
    field(:color, :string)
    field(:weight, :string)
    field(:battery, :string)
    field(:waterproof, :boolean)
    field(:material, :string)

    field(:pieces, :string)
    field(:country, :string)
    field(:url, :string)

    # Prices
    field(:start_price, :decimal)
    field(:price, :decimal)
    field(:retail_price, :decimal)
    field(:discount, :decimal)
    field(:fixed_price, :boolean)

    # Mark
    field(:new, :boolean)
    field(:hit, :boolean)

    # City storehouse presence
    field(:msk, :boolean)
    field(:spb, :boolean)
    field(:nsk, :boolean)
    field(:tmn, :boolean)
    field(:kdr, :boolean)
    field(:rst, :boolean)

    # Images
    # !(:image, :string)
    # !(:image1, :string)
    # !(:image2, :string)
    # !(:images, :text)
    field(:images, {:array, :string})

    # Media
    field(:video, :string)
    field(:"3d", :string)

    # Timestamp
    field(:created, :naive_datetime)
    timestamps()
  end

  @required_fields ~w(code)a
  @optional_fields ~w(article title description group_code group_title category_code category_title manufacturer barcode collection brand_code brand_title modification_code category_new_code category_new_title size length width width_packed height_packed length_packed weight_packed color weight battery waterproof material pieces country url start_price price retail_price discount fixed_price new hit msk spb nsk tmn kdr rst images video 3d created)a

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:code)
  end
end
