defmodule CrocodileWeb.Admin.BannerController do
  use CrocodileWeb, :controller

  alias Crocodile.Banner

  def index(conn, _params) do
    banners =
      Banner
      |> order_by([b], asc: b.name)
      |> Repo.all()

    render(conn, "index.html", banners: banners)
  end

  def edit(conn, %{"id" => id}) do
    banner = Banner |> Repo.get(id)
    changeset = Banner.changeset(banner, %{})
    render(conn, "edit.html", banner: banner, changeset: changeset)
  end

  def update(conn, %{
        "id" => id,
        "banner" => banner_params
      }) do
    banner = Banner |> Repo.get(id)

    changeset = Banner.changeset(banner, banner_params)

    case Repo.update(changeset) do
      {:ok, banner} ->
        conn
        |> put_flash(:info, "Banner updated successfully.")
        |> redirect(to: Routes.admin_banner_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          banner: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end
end
