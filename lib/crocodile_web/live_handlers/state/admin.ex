defmodule CrocodileWeb.LiveHandlers.State.Admin do
  use CrocodileWeb, :live_handlers

  def init(admin_id) do
    new_state = %{
      "menu_filter" => "enable",
      "menu_product" => "enable",
      "menu_tag" => "enable",
      "menu_debug" => "enable",
      "filter" => %{
        "page_size" => 20,
        "page" => 1,
        "old_tree" => %{},
        "old_category" => "-",
        "old_subcategory" => "-"
      }
    }

    Redis.set("state/admin/#{admin_id}", Jason.encode!(new_state))
    new_state
  end

  def get(admin_id) do
    case Redis.get("state/admin/#{admin_id}") do
      nil -> init(admin_id)
      json_state -> Jason.decode!(json_state)
    end
  end

  def set(state, admin_id) do
    Redis.set("state/admin/#{admin_id}", Jason.encode!(state))
  end

  def item_data_set(
        %{
          "filter" => filter,
          "item_data" => item_data
        } = _state,
        admin_id
      ) do
    item_state = %{
      "filter" => filter,
      "item_data" => item_data
    }

    Redis.set("item_state/admin/#{admin_id}", Jason.encode!(item_state))
  end

  def item_data_get(admin_id) do
    "item_state/admin/#{admin_id}"
    |> Redis.get()
    |> Jason.decode!()
  end
end
