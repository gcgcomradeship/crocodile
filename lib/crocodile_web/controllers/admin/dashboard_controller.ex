defmodule CrocodileWeb.Admin.DashboardController do
  use CrocodileWeb, :controller

  import Phoenix.LiveView.Controller

  plug Crocodile.Plug.AdminStateLoad

  def index(
        %{assigns: %{state: state, current_admin: current_admin}} = conn,
        _params
      ) do
    session = %{
      "state" => state,
      "admin_id" => current_admin.id
    }

    live_render(conn, CrocodileWeb.Admin.DashboardLive, session: session)
  end
end
