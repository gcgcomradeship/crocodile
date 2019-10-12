defmodule Crocodile.Plug.AdminAuth do
  use CrocodileWeb, :plug
  alias Crocodile.Admin

  def call(conn, _opts) do
    case find_admin(conn) do
      %Admin{} = admin ->
        conn
        |> assign(:current_admin, admin)

      _ ->
        conn
        |> redirect(to: CrocodileWeb.Router.Helpers.admin_session_path(conn, :new))
        |> halt()
    end
  end

  defp find_admin(conn) do
    admin_id = Plug.Conn.get_session(conn, :current_admin_id)
    if admin_id, do: Crocodile.Repo.get(Admin, admin_id)
  end
end
