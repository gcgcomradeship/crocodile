defmodule CrocodileWeb.CartController do
  use CrocodileWeb, :controller
  alias Crocodile.Context.Items
  alias Crocodile.Services.Cart

  plug :breadcrumbs

  def index(%{assigns: %{session: %{id: sid}}} = conn, _params) do
    render(conn, "index.html")
  end

  def add_item(%{assigns: %{session: %{id: sid}}} = conn, %{"item_id" => item_id} = _params) do
    case Cart.add(sid, item_id) do
      res when is_map(res) ->
        render(conn, "success.json", cart: Items.cart_by_sid(sid))

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end

  def del_item(%{assigns: %{session: %{id: sid}}} = conn, %{"item_id" => item_id} = _params) do
    case Cart.remove(sid, item_id) do
      res when is_map(res) ->
        render(conn, "success.json", cart: Items.cart_by_sid(sid))

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end

  def set_count(
        %{assigns: %{session: %{id: sid}}} = conn,
        %{"item_id" => item_id, "count" => count} = _params
      ) do
    cnt = if count == "", do: 1, else: count

    case Cart.set(sid, item_id, cnt) do
      res when is_map(res) ->
        render(conn, "success.json", cart: Items.cart_by_sid(sid))

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end

  defp breadcrumbs(%{assigns: %{breadcrumbs: breadcrumbs}} = conn, _) do
    assign(conn, :breadcrumbs, breadcrumbs ++ [{"Корзина", "#"}])
  end
end
