defmodule Crocodile.Services.Kassa.Helper do
  use CrocodileWeb, :services

  def receipt(order) do
    items =
      order
      |> Repo.preload(items_orders: [:item])
      |> Map.get(:items_orders)

    items_data =
      for item <- items do
        %{
          description: item.item.name,
          quantity: item.quantity,
          amount: %{value: item.price, currency: "RUB"},
          vat_code: 1
        }
      end
      |> Kernel.++([
        %{
          description: "Доставка",
          quantity: 1,
          amount: %{value: order.delivery_sum, currency: "RUB"},
          vat_code: 1
        }
      ])

    %{
      customer: %{phone: Regex.replace(~r/[^\d]/, order.phone, "")},
      items: items_data
    }
  end
end
