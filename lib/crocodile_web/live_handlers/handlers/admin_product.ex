defmodule CrocodileWeb.LiveHandlers.AdminProduct do
  use CrocodileWeb, :live_handlers

  def call(socket, data, value) do
    socket
  end

  def call(socket, data, value) do
    # new_state = Map.put(state, "page", page)
    # State.set(new_state, user_id)
    # Phoenix.LiveView.assign(socket, :state, new_state)
    require Logger
    Logger.warn("-----------------------")
    Logger.warn(inspect(value))
    Logger.warn(inspect(data))
    Logger.warn(inspect(socket.assigns))
    # Logger.warn(inspect(admin_id))
    Logger.warn("-----------------------")
    # new_state = Map.put(state, "page", page)
    # State.set(new_state, user_id)
    # Phoenix.LiveView.assign(socket, :state, new_state)
    socket
  end
end
