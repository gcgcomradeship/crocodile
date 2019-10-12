defmodule CrocodileWeb.Admin.AdminController do
  use CrocodileWeb, :controller

  alias Crocodile.Admin

  def index(conn, _params) do
    admins =
      Admin
      |> Repo.all()

    render(conn, "index.html", admins: admins)
  end

  def new(conn, _params) do
    changeset = Admin.changeset(%Admin{}, %{password: ""})
    render(conn, "new.html", admin: changeset.data, changeset: changeset)
  end

  def create(%{assigns: %{current_admin: current_admin}} = conn, %{"admin" => admin_params}) do
    changeset = Admin.changeset(%Admin{}, admin_params)

    case Repo.insert(changeset) do
      {:ok, admin} ->
        conn
        |> put_flash(:info, "Admin created successfully.")
        |> redirect(to: Routes.admin_admin_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          admin: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end

  # def show(conn, %{"id" => id}) do
  #   admin = Admin |> Repo.get(id)
  #   render(conn, "show.html", admin: admin)
  # end

  def edit(conn, %{"id" => id}) do
    admin = Admin |> Repo.get(id)
    changeset = Admin.changeset(admin, %{password: ""})
    render(conn, "edit.html", admin: admin, changeset: changeset)
  end

  def update(%{assigns: %{current_admin: current_admin}} = conn, %{
        "id" => id,
        "admin" => admin_params
      }) do
    admin = Admin |> Repo.get(id)

    changeset = Admin.changeset(admin, admin_params)

    case Repo.update(changeset) do
      {:ok, admin} ->
        conn
        |> put_flash(:info, "Admin updated successfully.")
        |> redirect(to: Routes.admin_admin_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          admin: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end

  def delete(%{assigns: %{current_admin: current_admin}} = conn, %{"id" => id}) do
    admin = Admin |> Repo.get(id)
    {:ok, _admin} = Repo.delete(admin)

    conn
    |> put_flash(:info, "Admin deleted successfully.")
    |> redirect(to: Routes.admin_admin_path(conn, :index))
  end
end
