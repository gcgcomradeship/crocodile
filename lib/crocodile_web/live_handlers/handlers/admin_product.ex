defmodule CrocodileWeb.LiveHandlers.AdminProduct do
  use CrocodileWeb, :live_handlers

  alias Crocodile.Services.Opt
  alias CrocodileWeb.LiveHandlers.State

  # def call(socket, data, value) do
  #   socket
  # end

  def call(%{assigns: %{admin_id: admin_id, state: state}} = socket, "product_" <> cmd, value) do
    new_state = exec(state, cmd)
    State.Admin.set(new_state, admin_id)

    assign(socket, :state, new_state)
  end

  defp exec(state, "update_list") do
    products = Crocodile.Services.Opt.products(state["filter"])

    Map.put(state, "products", products)
  end
end
