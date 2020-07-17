defmodule CrocodileWeb.Admin.DashboardLive do
  use Phoenix.LiveView

  alias CrocodileWeb.LiveHandlers.EventHandler

  def render(assigns) do
    ~L"""
      <%= Phoenix.View.render(CrocodileWeb.Admin.DashboardView, "index.html", assigns) %>
    """
  end

  def mount(_params, %{"state" => state, "admin_id" => admin_id} = data, socket) do
    if connected?(socket), do: :timer.send_interval(30000, self(), :update)
    {:ok, assign(socket, %{state: state, admin_id: admin_id})}
  end

  def handle_info(:update, socket) do
    # {:noreply, assign(socket, :log, "Reconnect")}
    {:noreply, socket}
  end

  def handle_event(data, value, socket) do
    sock = EventHandler.call(socket, data, value, :admin)
    {:noreply, sock}
  end
end
