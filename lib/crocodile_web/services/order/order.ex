defmodule Crocodile.Services.Order do
  use CrocodileWeb, :services

  alias Crocodile.Order
  alias Crocodile.Services.Order.Remote

  def send_to_partner(order) do
    %{
      "order" => order_items(order),
      "ExtOrderID" => order.number,
      "ExtOrderPaid" => payment_status(order),
      "ExtDeliveryCost" => Decimal.round(order.delivery_sum, 0),
      "dsDelivery" => delivery_type(order),
      "dsFio" => "#{order.surname} #{order.name}",
      "dsMobPhone" => order.phone,
      "dsEmail" => order.email,
      "dsCity" => order.city,
      "dsPickUpId" => Map.get(order.data, "terminal_id") || "",
      # "ExtDateOfAdded" => "",
      "dsPostcode" => order.post_index,
      "dsArea" => order.area,
      "dsStreet" => order.street,
      "dsHouse" => order.house,
      "dsFlat" => order.flat,
      # "dsDeliveryDate" => "",
      # "dsComments" => "",
      "packType" => "1"
    }
    |> Remote.call()
    |> parse_response()
  end

  def recalculate(%Order{id: id}) do
    Order
    |> Repo.get(id)
    |> case do
      nil -> nil
      order -> calc(order)
    end
  end

  def recalculate(order_id) do
    Order
    |> Repo.get(order_id)
    |> case do
      nil -> nil
      order -> calc(order)
    end
  end

  defp parse_response(%{
         "ResultStatus" => "1",
         "ResultStatusMsg" => message,
         "orderID" => partner_id
       }),
       do: {:ok, partner_id, message}

  defp parse_response(%{"ResultStatus" => "5", "ResultStatusMsg" => message}),
    do: {:test, message}

  defp parse_response(%{"ResultStatus" => status, "ResultStatusMsg" => message}),
    do: {:error, status, message}

  defp calc(order) do
    order = order |> Repo.preload(:items_orders)
    items_sum = items_sum(order.items_orders)

    changeset =
      Order.changeset(
        order,
        %{
          items_sum: items_sum,
          total_sum: Decimal.add(items_sum, order.delivery_sum)
        }
      )

    Repo.update(changeset)
  end

  defp order_items(%{items_orders: items_orders}) do
    for item_order <- items_orders do
      "#{item_order.item.partner_id}-#{item_order.quantity}-#{Decimal.round(item_order.price, 0)}"
    end
    |> Enum.join(",")
  end

  defp payment_status(%{payment_status: :succeeded}), do: 1
  defp payment_status(_), do: 0

  defp delivery_type(%{delivery_type: :pick_up}), do: 5
  defp delivery_type(%{delivery_type: :post}), do: 2
  defp delivery_type(%{delivery_type: :courier}), do: 1
end
