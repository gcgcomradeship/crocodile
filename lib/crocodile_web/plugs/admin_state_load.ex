defmodule Crocodile.Plug.AdminStateLoad do
  use CrocodileWeb, :plug

  alias CrocodileWeb.LiveHandlers.State

  def call(%{assigns: %{current_admin: current_admin}} = conn, _opts),
    do: assign(conn, :state, State.Admin.get(current_admin.id))
end
