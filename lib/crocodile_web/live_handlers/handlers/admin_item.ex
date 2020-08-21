defmodule CrocodileWeb.LiveHandlers.AdminItem do
  use CrocodileWeb, :live_handlers

  alias Crocodile.Services.Opt
  alias CrocodileWeb.LiveHandlers.State

  def call(%{assigns: %{admin_id: admin_id, state: state}} = socket, "item_" <> cmd, value) do
    new_state = exec(state, cmd, admin_id)
    State.Admin.set(new_state, admin_id)

    assign(socket, :state, new_state)
  end

  defp exec(
         %{
           "filter" => %{
             "page" => page,
             "page_size" => page_size
           },
           "products" => %{
             "items_total" => items_total,
             "list" => list
           }
         } = state,
         "set_" <> id,
         admin_id
       ) do
    item = Opt.item(id)
    item_tags = Opt.tags_show(id)

    position =
      list
      |> Enum.find_index(fn %{"id" => id} -> id == item["id"] end)
      |> Kernel.+(page_size * (page - 1))

    item_data = %{
      "position" => position + 1,
      "items_total" => items_total
    }

    new_state =
      state
      |> Map.put("item", item)
      |> Map.put("item_data", item_data)
      |> Map.put("tags", item_tags)

    State.Admin.item_data_set(new_state, admin_id)
    new_state
  end

  defp exec(state, cmd, admin_id) when cmd in ["prev", "next"] do
    %{
      "filter" => %{"page_size" => page_size} = filter,
      "item_data" => %{"position" => position, "items_total" => items_total} = item_data
    } = State.Admin.item_data_get(admin_id)

    new_position = get_position(cmd, position, items_total)

    page = get_page(new_position, items_total, page_size)

    new_filter = Map.put(filter, "page", page)
    products = Opt.products(new_filter)
    list_position = new_position - 1 - (page - 1) * page_size

    item_id =
      products["list"]
      |> Enum.at(list_position)
      |> Map.get("id")

    state
    |> Map.put("filter", new_filter)
    |> Map.put("products", products)
    |> exec("set_#{item_id}", admin_id)
  end

  defp get_position("prev", pos, _tot) when pos > 1, do: pos - 1
  defp get_position("prev", _pos, _tot), do: 1
  defp get_position("next", pos, tot) when pos >= tot, do: tot
  defp get_position("next", pos, _tot), do: pos + 1

  defp get_page(pos, tot, psize) when pos > 0 and pos <= tot, do: div(pos - 1, psize) + 1
  defp get_page(pos, tot, psize) when pos > tot, do: div(tot - 1, psize) + 1
  defp get_page(pos, tot, psize), do: 1
end
