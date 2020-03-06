defmodule Crocodile.Context.Orders do
  use CrocodileWeb, :context

  alias Crocodile.Order
  alias Crocodile.ItemOrder
  alias Crocodile.Context.Items

  def create(params, %{id: sid} = session) do
    items = Items.cart_by_sid(sid)
    delivery_sum = get_delivery_sum(params)
    items_sum = items_sum(items)
    total_sum = Decimal.add(items_sum, delivery_sum)

    changeset =
      Order.changeset(
        %Order{},
        build_order_params(params, session, %{
          delivery_sum: delivery_sum,
          total_sum: total_sum
        })
      )

    case Repo.insert(changeset) do
      {:ok, order} ->
        create_item_links(items, order)
        {:ok, order}

      error ->
        error
    end
  end

  defp build_order_params(params, %{id: session_id, user_id: user_id}, %{
         delivery_sum: delivery_sum,
         total_sum: total_sum
       }) do
    params
    |> Map.merge(%{
      "session_id" => session_id,
      "user_id" => user_id,
      "status" => "created",
      "number" => generate_order_number(),
      # "delivery_size" => "",
      # "delivery_date" => "",
      "delivery_sum" => delivery_sum,
      "total_sum" => total_sum
    })
  end

  defp generate_order_number() do
    number = "#{Enum.random(100..999)}-#{Enum.random(100..999)}-#{Enum.random(100..999)}"

    case Repo.get_by(Order, number: number) do
      nil -> number
      _ -> generate_order_number()
    end
  end

  defp create_item_links(items, order) do
    items_orders =
      for item <- items do
        %{
          order_id: order.id,
          price: item.retail_price,
          item_id: item.id,
          quantity: to_int(item.count)
        }
      end

    Repo.insert_all(ItemOrder, items_orders)
  end

  def on_order_update(order, params) do
    order
    |> Order.changeset(params)
    |> Repo.update()
  end

  defp get_delivery_sum(%{"delivery_type" => delivery_type} = params) do
    Setting
    |> select([s], s.data)
    |> Repo.get_by(name: "delivery_prices")
    |> Map.get(delivery_type)
  end
end
