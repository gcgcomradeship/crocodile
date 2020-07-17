defmodule CrocodileWeb.LiveHandlers.AdminMenu do
  use CrocodileWeb, :live_handlers

  alias CrocodileWeb.LiveHandlers.State

  def call(%{assigns: %{admin_id: admin_id, state: state}} = socket, "menu_" <> cmd, value) do
    new_state = exec(state, cmd)
    State.Admin.set(new_state, admin_id)

    assign(socket, :state, new_state)
  end

  defp exec(state, "click_" <> direction) do
    new_val =
      state
      |> Map.get("menu_#{direction}")
      |> case do
        "enable" -> "disable"
        _ -> "enable"
      end

    Map.put(state, "menu_#{direction}", new_val)
  end
end
