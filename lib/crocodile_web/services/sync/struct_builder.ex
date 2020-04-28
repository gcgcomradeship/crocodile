defmodule Crocodile.Services.Sync.StructBuilder do
  use CrocodileWeb, :services

  def call(head, body, key) do
    raw = to_map(head, body)

    case key do
      :sync ->
        to_struct(raw)

      :update ->
        to_struct_for_update(raw)
    end
  end

  defp to_map(head, body), do: to_map(head, body, [])

  defp to_map(["Image" | ht], [bh | bt], acc) when bh != "" do
    val = String.split(bh, " ")
    to_map(ht, bt, acc ++ [{"Image", val}])
  end

  defp to_map([hh | ht], [bh | bt], acc), do: to_map(ht, bt, acc ++ [{hh, bh}])
  defp to_map([], _body, acc), do: Enum.into(acc, %{})
  defp to_map([_hh | _ht], [], _acc), do: nil

  defp to_struct(%{
         "Barcode" => barcode,
         "BaseRetailPrice" => base_retail_price,
         "BaseWholePrice" => base_whole_price,
         "Batteries" => batteries,
         "Brutto" => brutto,
         "Category" => category,
         "Collection" => collection,
         "Color" => color,
         "Description" => description,
         "Diameter" => diameter,
         "Discount" => discount,
         "Image" => images,
         "InSale" => insale,
         "Lenght" => length,
         "Material" => material,
         "Name" => name,
         "Pack" => pack,
         "RetailPrice" => retail_price,
         "ShippingDate" => shipping_date,
         "Size" => size,
         "SubCategory" => subcategory,
         "Vendor" => vendor,
         "VendorCode" => vendor_code,
         "WholePrice" => whole_price,
         "aID" => partner_id,
         "prodID" => prod_id
       }) do
    %{
      partner_id: "#{partner_id}",
      barcode: barcode,
      vendor: vendor,
      vendor_code: vendor_code,
      name: name,
      retail_price: retail_price,
      base_retail_price: base_retail_price,
      whole_price: whole_price,
      base_whole_price: base_whole_price,
      discount: discount,
      insale: insale,
      shipping_date: to_naive(shipping_date),
      description: description,
      brutto: brutto,
      batteries: batteries,
      pack: pack,
      material: material,
      length: length,
      diameter: diameter,
      collection: collection,
      images: images,
      category: category,
      subcategory: subcategory,
      color: color,
      size: size,
      group_id: prod_id
    }
  end

  defp to_struct(_), do: nil

  defp to_struct_for_update(%{
         "BaseRetailPrice" => base_retail_price,
         "BaseWholePrice" => base_whole_price,
         "Discount" => discount,
         "InSale" => insale,
         "Name" => name,
         "RetailPrice" => retail_price,
         "ShippingDate" => shipping_date,
         "WholePrice" => whole_price,
         "aID" => partner_id
       }) do
    %{
      base_retail_price: base_retail_price,
      base_whole_price: base_whole_price,
      discount: discount,
      insale: insale,
      name: name,
      retail_price: retail_price,
      whole_price: whole_price,
      shipping_date: to_naive(shipping_date),
      partner_id: "#{partner_id}"
    }
  end

  defp to_struct_for_update(_), do: nil

  defp to_naive(datetime) when datetime in ["", nil], do: nil
  defp to_naive(datetime), do: Timex.parse!(datetime, "%d.%m.%Y %H:%M:%S", :strftime)
end
