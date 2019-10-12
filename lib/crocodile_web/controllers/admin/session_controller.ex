defmodule CrocodileWeb.Admin.SessionController do
  use CrocodileWeb, :controller
  alias Crocodile.Admin

  plug(:put_layout, false)

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => pass}) do
    Admin
    |> where([a], a.email == ^email)
    |> Repo.one()
    |> Comeonin.Bcrypt.check_pass(pass)
    |> case do
      {:ok, admin} ->
        conn
        |> put_session(:current_admin_id, admin.id)
        |> redirect(to: Routes.admin_admin_path(conn, :index))

      {:error, _} ->
        conn
        |> redirect(to: Routes.admin_session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_admin_id)
    |> redirect(to: Routes.admin_session_path(conn, :new))
  end
end
