defmodule CrocodileWeb.Admin.AdminController do
  use CrocodileWeb, :controller

  alias Crocodile.Repo
  alias CrocodileWeb.Admin

  def index(conn, _params) do
    admins = Repo.all(Admin)
    render(conn, "index.html", admins: admins)
  end

  def new(conn, _params) do
    changeset = Admin.changeset(%Admin{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"admin" => admin}) do
    changeset = Admin.changeset(%Admin{}, admin)

    case Repo.insert(changeset) do
      {:ok, _admin} ->
        conn
        |> put_flash(:info, "Admin created")
        |> redirect(to: Routes.admin_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => admin_id}) do
    Repo.get!(Admin, admin_id)
    |> Repo.delete!()

    conn
    |> put_flash(:info, "Admin Deleted")
    |> redirect(to: Routes.admin_path(conn, :index))
  end

  def edit(conn, %{"id" => admin_id}) do
    admin = Repo.get(Admin, admin_id)
    changeset = Admin.changeset(admin)

    render(conn, "edit.html", changeset: changeset, admin: admin)
  end

  def update(conn, %{"id" => admin_id, "admin" => admin}) do
    old_admin = Repo.get(Admin, admin_id)

    changeset =
      Repo.get(Admin, admin_id)
      |> Admin.changeset(admin)

    case Repo.update(changeset) do
      {:ok, _admin} ->
        conn
        |> put_flash(:info, "Admin Updated")
        |> redirect(to: Routes.admin_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, admin: old_admin)
    end
  end
end
