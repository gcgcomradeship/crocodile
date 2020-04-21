defmodule CrocodileWeb.Admin.ItemOrderController do
  use CrocodileWeb, :controller

  alias Crocodile.Item
  alias Crocodile.Order
  alias Crocodile.ItemOrder
  alias Crocodile.Services

  def create(conn, %{"partner_id" => partner_id, "order_id" => order_id}) do
    item = Item |> Repo.get_by(partner_id: partner_id)

    item_order_check =
      ItemOrder
      |> where([io], io.order_id == ^order_id and io.item_id == ^item.id)
      |> Repo.one()

    case item_order_check do
      nil ->
        create(conn, item, order_id)

      _ ->
        conn
        |> put_flash(:warning, "Item already exist.")
        |> redirect(to: Routes.admin_order_path(conn, :show, order_id))
    end
  end

  def create(conn, nil, order_id) do
    conn
    |> put_flash(:warning, "Item not found.")
    |> redirect(to: Routes.admin_order_path(conn, :show, order_id))
  end

  def create(conn, item, order_id) do
    item_order_data = %{
      quantity: 1,
      price: item.retail_price,
      order_id: order_id,
      item_id: item.id
    }

    changeset = ItemOrder.changeset(%ItemOrder{}, item_order_data)

    case Repo.insert(changeset) do
      {:ok, item_order} ->
        Services.Order.recalculate(order_id)

        conn
        |> put_flash(:info, "Item added successfully.")
        |> redirect(to: Routes.admin_order_path(conn, :show, order_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, "Item add error")
        |> redirect(to: Routes.admin_order_path(conn, :show, order_id))
    end
  end

  def update(conn, %{
        "id" => id,
        "item_order" => item_order_params
      }) do
    item_order =
      ItemOrder
      |> preload(:order)
      |> Repo.get(id)

    changeset = ItemOrder.changeset(item_order, item_order_params)

    case Repo.update(changeset) do
      {:ok, item_order} ->
        Services.Order.recalculate(item_order.order)

        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: Routes.admin_order_path(conn, :show, item_order.order))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:danger, "Order update error.")
        |> redirect(to: Routes.admin_order_path(conn, :show, item_order.order))
    end
  end

  def delete(conn, %{"id" => id}) do
    item_order = ItemOrder |> preload(:order) |> Repo.get(id)
    order = item_order.order
    {:ok, _item_order} = Repo.delete(item_order)
    Services.Order.recalculate(order)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.admin_order_path(conn, :show, order))
  end
end
