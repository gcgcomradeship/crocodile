defmodule Crocodile.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      # ID парнтера;
      add(:partner_id, :string)
      # Barcode - штрихкод;
      add(:barcode, :string)
      # Vendor - производитель;
      add(:vendor, :string)
      # VendorCode - артикул производителя;
      add(:vendor_code, :string)
      # Name – название модели;
      add(:name, :string)

      # RetailPrice – рекомендованная розничная цена c учетом скидки;
      add(:retail_price, :decimal)

      # BaseRetailPrice - базовая рекомендованная розничная цена;
      add(:base_retail_price, :decimal)
      # WholePrice – оптовая цена c учетом скидки;
      add(:whole_price, :decimal)
      # BaseWholePrice – базовая оптовая цена;
      add(:base_whole_price, :decimal)
      # Discount - размер скидки;
      add(:discount, :decimal)
      # InSale – свободный остаток. Если 0, - то нет в наличии;
      add(:insale, :integer)

      # ShippingDate - дата и время возможной отгрузки с нашего склада;
      add(:shipping_date, :naive_datetime)
      # Description - описание;
      add(:description, :text)
      # Brutto - вес в килограммах;
      add(:brutto, :decimal)
      # Batteries - тип и количество батареек;
      add(:batteries, :string)
      # Pack - тип упаковки;
      add(:pack, :string)
      # Material - материал;
      add(:material, :string)
      # Lenght - длина в сантиметрах;
      add(:length, :decimal)
      # Diameter - диаметр в сантиметрах;
      add(:diameter, :decimal)
      # Collection - коллекция;
      add(:collection, :string)
      # Image – ссылки на фотографии разделенные пробелом;
      add(:images, {:array, :string})
      # Category – корневая категория;
      add(:category, :string)
      # SubCategory – подкатегория;
      add(:subcategory, :string)
      # Color - цвет;
      add(:color, :string)
      # Size - размер;
      add(:size, :string)
      timestamps()
    end

    create(unique_index(:items, [:barcode]))
  end
end
