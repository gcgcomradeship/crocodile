defmodule CrocodileWeb.LiveHandlers.AdminFilter do
  use CrocodileWeb, :live_handlers

  alias Crocodile.Services.Opt
  alias CrocodileWeb.LiveHandlers.State
  alias CrocodileWeb.LiveHandlers.AdminProduct

  def call(%{assigns: %{admin_id: admin_id, state: state}} = socket, "filter_" <> cmd, value) do
    new_state = exec(state, cmd, value)
    State.Admin.set(new_state, admin_id)

    socket
    |> assign(:state, new_state)
    |> AdminProduct.call("product_update_list", "update")
  end

  defp exec(state, cmd, value \\ nil)

  defp exec(%{"filter" => filter} = state, "init", _) do
    new_filter =
      Map.merge(state["filter"], %{
        "old_tree" => Opt.old_tree()
      })

    Map.put(state, "filter", new_filter)
  end

  defp exec(state, "page_size_" <> size, _) do
    filter = Map.merge(state["filter"], %{"page_size" => to_int(size)})
    Map.put(state, "filter", filter)
  end

  defp exec(state, "page_down", _) do
    page =
      case state["filter"]["page"] do
        num when num > 1 -> num - 1
        _ -> 1
      end

    filter = Map.merge(state["filter"], %{"page" => page})
    Map.put(state, "filter", filter)
  end

  defp exec(state, "page_up", _) do
    total = state["products"]["pages_total"]

    page =
      case state["filter"]["page"] do
        num when num < total -> num + 1
        _ -> total
      end

    filter = Map.merge(state["filter"], %{"page" => page})
    Map.put(state, "filter", filter)
  end

  defp exec(state, "select_old_category", %{"old_category_select" => value} = data) do
    filter =
      Map.merge(state["filter"], %{"old_category" => value, "old_subcategory" => "-", "page" => 1})

    Map.put(state, "filter", filter)
  end

  defp exec(state, "select_old_subcategory", %{"old_subcategory_select" => value}) do
    filter = Map.merge(state["filter"], %{"old_subcategory" => value, "page" => 1})

    Map.put(state, "filter", filter)
  end
end
