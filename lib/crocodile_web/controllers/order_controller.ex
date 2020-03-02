defmodule CrocodileWeb.OrderController do
  use CrocodileWeb, :controller

  alias Crocodile.Order
  alias Crocodile.Context.Orders
  alias Crocodile.Services.Kassa
  alias Crocodile.Utils.Helper

  def new(%{assigns: %{session: session}} = conn, _params) do
    changeset = Order.changeset(%Order{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{session: session}} = conn, %{"order" => params}) do
    case Orders.create(params, session) do
      {:ok, %{payment_type: :online} = order} ->
        %{confirmation_url: confirmation_url} = Kassa.create(conn, order)
        redirect(conn, external: confirmation_url)

      {:ok, %{payment_type: :on_delivery} = order} ->
        redirect(conn, to: Routes.order_path(conn, :show, order, f: 1))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%{assigns: %{session: %{id: session_id}}} = conn, %{"id" => id} = params) do
    order =
      Order
      |> preload(items_orders: [:item])
      |> Repo.get(id)

    items =
      for item_order <- order.items_orders do
        %{
          image: List.first(item_order.item.images),
          name: Helper.name(item_order.item),
          quantity: item_order.quantity,
          price: item_order.price
        }
      end

    case order do
      %{session_id: sid} when sid == session_id ->
        render(conn, "show.html",
          order: order,
          items: items,
          result: params["result"],
          f: params["f"]
        )

      _ ->
        redirect(conn, to: Routes.item_path(conn, :index))
    end
  end
end
