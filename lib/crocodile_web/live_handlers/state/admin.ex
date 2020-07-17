defmodule CrocodileWeb.LiveHandlers.State.Admin do
  use CrocodileWeb, :live_handlers

  def get(admin_id) do
    case Redis.get("state/admin/#{admin_id}") do
      nil -> init(admin_id)
      json_state -> Jason.decode!(json_state)
    end
  end

  def set(state, admin_id) do
    Redis.set("state/admin/#{admin_id}", Jason.encode!(state))
  end

  def init(admin_id) do
    new_state = %{
      menu_product: "enable",
      menu_debug: "enable"
    }

    Redis.set("state/admin/#{admin_id}", Jason.encode!(new_state))
    get("state/admin/#{admin_id}")
  end
end
