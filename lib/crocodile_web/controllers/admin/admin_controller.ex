defmodule CrocodileWeb.Admin.AdminController do
  use CrocodileWeb, :controller

  alias Crocodile.Repo
  alias Crocodile.Accounts
  alias Crocodile.Accounts.Admin

  def new(conn, _params) do
    changeset = Accounts.change_admin(%Admin{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"admin" => admin}) do
    case Accounts.create_admin(admin) do
      {:ok, admin} ->
        conn
        |> put_session(:current_admin_id, admin.id)
        |> put_flash(:info, "Signed up successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
