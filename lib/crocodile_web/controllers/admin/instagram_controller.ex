defmodule CrocodileWeb.Admin.InstagramController do
  use CrocodileWeb, :controller

  alias Crocodile.Instagram

  def index(conn, _params) do
    instagrams =
      Instagram
      |> Repo.all()

    render(conn, "index.html", instagrams: instagrams)
  end

  def new(conn, _params) do
    changeset = Instagram.changeset(%Instagram{}, %{})
    render(conn, "new.html", instagram: changeset.data, changeset: changeset)
  end

  def create(conn, %{
        "instagram" => instagram_params
      }) do
    changeset = Instagram.changeset(%Instagram{}, instagram_params)

    case Repo.insert(changeset) do
      {:ok, instagram} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.admin_instagram_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          instagram: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end

  def edit(conn, %{"id" => id}) do
    instagram = Instagram |> Repo.get(id)
    changeset = Instagram.changeset(instagram, %{})
    render(conn, "edit.html", instagram: instagram, changeset: changeset)
  end

  def update(conn, %{
        "id" => id,
        "instagram" => instagram_params
      }) do
    instagram = Instagram |> Repo.get(id)

    changeset = Instagram.changeset(instagram, instagram_params)

    case Repo.update(changeset) do
      {:ok, instagram} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.admin_instagram_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          instagram: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    instagram = Instagram |> Repo.get(id)
    {:ok, _instagram} = Repo.delete(instagram)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.admin_instagram_path(conn, :index))
  end
end
