defmodule CrocodileWeb.OrderController do
  use CrocodileWeb, :controller

  alias Crocodile.Order
  alias Crocodile.Context.Orders
  alias Crocodile.Services.Kassa

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
      |> preload(orders_products: [:product])
      |> Repo.get(id)

    items =
      for item <- order.orders_products do
        %{
          image: List.first(item.product.images),
          title: item.product.title,
          quantity: item.quantity,
          price: item.price
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
        redirect(conn, to: Routes.product_path(conn, :index))
    end
  end
end
