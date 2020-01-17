defmodule CrocodileWeb.CartController do
  use CrocodileWeb, :controller
  alias Crocodile.Context.Categories
  alias Crocodile.Context.Items
  alias Crocodile.Services.Cart

  def index(%{assigns: %{session: %{id: sid}}} = conn, _params) do
    render(conn, "index.html")
  end

  def del_item(%{assigns: %{session: %{id: sid}}} = conn, %{"item_id" => item_id} = _params) do
    case Cart.remove(sid, item_id) do
      res when is_map(res) ->
        render(conn, "success.json")

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
        render(conn, "success.json")

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end
end
