defmodule CrocodileWeb.PageController do
  use CrocodileWeb, :controller

  alias Crocodile.Accounts

  plug :check_auth when action in [:new, :create, :edit, :update, :delete]

  defp check_auth(conn, _args) do
    if admin_id = get_session(conn, :current_admin_id) do
      current_admin = Accounts.get_admin!(admin_id)

      conn
      |> assign(:current_admin, current_admin)
    else
      conn
      |> put_flash(:error, "You need to be signed in to access that page.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
