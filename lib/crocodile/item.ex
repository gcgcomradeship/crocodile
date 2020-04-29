defmodule Crocodile.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    # ID партнера;
    field(:partner_id, :string)
    # ID товара включая все цвета и размеры;
    field(:group_id, :string)
    # Barcode - штрихкод;
    field(:barcode, :string)
    # Vendor - производитель;
    field(:vendor, :string)
    # VendorCode - артикул производителя;
    field(:vendor_code, :string)
    # Name – название модели;
    field(:name, :string)

    # RetailPrice – рекомендованная розничная цена c учетом скидки;
    field(:retail_price, :decimal)
    # BaseRetailPrice - базовая рекомендованная розничная цена;
    field(:base_retail_price, :decimal)
    # WholePrice – оптовая цена c учетом скидки;
    field(:whole_price, :decimal)
    # BaseWholePrice – базовая оптовая цена;
    field(:base_whole_price, :decimal)
    # Discount - размер скидки;
    field(:discount, :decimal)
    # InSale – свободный остаток. Если 0, - то нет в наличии;
    field(:insale, :integer)

    # ShippingDate - дата и время возможной отгрузки с нашего склада;
    field(:shipping_date, :naive_datetime)
    # Description - описание;
    field(:description, :string)
    # Brutto - вес в килограммах;
    field(:brutto, :decimal)
    # Batteries - тип и количество батареек;
    field(:batteries, :string)
    # Pack - тип упаковки;
    field(:pack, :string)
    # Material - материал;
    field(:material, :string)
    # Lenght - длина в сантиметрах;
    field(:length, :decimal)
    # Diameter - диаметр в сантиметрах;
    field(:diameter, :decimal)
    # Collection - коллекция;
    field(:collection, :string)
    # Image – ссылки на фотографии разделенные пробелом;
    field(:images, {:array, :string})
    # Category – корневая категория;
    field(:category, :string)
    # SubCategory – подкатегория;
    field(:subcategory, :string)
    # Color - цвет;
    field(:color, :string)
    # Size - размер;
    field(:size, :string)
    # Лидер продаж;
    field(:hit, :boolean)
    # Новинка;
    field(:new, :boolean)

    field(:hide, :boolean)
    field(:approve, :naive_datetime)
    timestamps()
  end

  @required_fields ~w(barcode)a
  @optional_fields ~w(partner_id vendor vendor_code name retail_price base_retail_price whole_price base_whole_price discount insale shipping_date description brutto batteries pack material length diameter collection images category subcategory color size hit new hide group_id approve)a

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:barcode)
  end
end
