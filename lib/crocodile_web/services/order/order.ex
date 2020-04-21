defmodule Crocodile.Services.Order do
  use CrocodileWeb, :services

  alias Crocodile.Order

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
end
