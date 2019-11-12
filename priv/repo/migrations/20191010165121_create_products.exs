defmodule Crocodile.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      # DONE
      add(:code, :string)
      add(:article, :string)
      add(:title, :string)
      add(:description, :text)

      add(:group_code, :string)
      add(:group_title, :string)
      add(:category_code, :string)
      add(:category_title, :string)
      add(:manufacturer, :string)
      add(:barcode, :string)
      add(:collection, :string)
      add(:brand_code, :string)
      add(:brand_title, :string)
      add(:modification_code, :string)
      add(:category_new_code, :string)
      add(:category_new_title, :string)

      add(:size, :string)
      add(:length, :string)
      add(:width, :string)
      add(:width_packed, :string)
      add(:height_packed, :string)
      add(:length_packed, :string)
      add(:weight_packed, :string)
      add(:color, :string)
      add(:weight, :string)
      add(:battery, :string)
      add(:waterproof, :boolean, default: false)
      add(:material, :string)

      add(:pieces, :string)
      add(:country, :string)
      add(:url, :string)

      # Prices
      add(:start_price, :decimal)
      add(:price, :decimal)
      add(:retail_price, :decimal)
      add(:discount, :decimal)
      add(:fixed_price, :boolean, default: false)

      # Mark
      add(:new, :boolean, default: false)
      add(:hit, :boolean, default: false)

      # City storehouse presence
      add(:msk, :boolean, default: false)
      add(:spb, :boolean, default: false)
      add(:nsk, :boolean, default: false)
      add(:tmn, :boolean, default: false)
      add(:kdr, :boolean, default: false)
      add(:rst, :boolean, default: false)

      # Images
      # add(:image, :string)
      # add(:image1, :string)
      # add(:image2, :string)
      # add(:images, :text)
      add(:images, {:array, :string})

      add(:video, :text)
      add(:"3d", :text)

      add(:created, :naive_datetime)
      timestamps()
    end

    create(unique_index(:products, [:code]))
  end
end
