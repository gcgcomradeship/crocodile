defmodule CrocodileWeb.Admin.PageController do
  use CrocodileWeb, :controller

  alias Crocodile.Page

  def dashboard(conn, _params) do
    render(conn, "dashboard.html")
  end

  def index(conn, _params) do
    pages =
      Page
      |> order_by([p], asc: p.name)
      |> Repo.all()

    render(conn, "index.html", pages: pages)
  end

  def edit(conn, %{"id" => id}) do
    page = Page |> Repo.get(id)
    changeset = Page.changeset(page, %{})
    render(conn, "edit.html", page: page, changeset: changeset)
  end

  def update(conn, %{
        "id" => id,
        "page" => page_params
      }) do
    page = Page |> Repo.get(id)

    changeset = Page.changeset(page, page_params)

    case Repo.update(changeset) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "Page updated successfully.")
        |> redirect(to: Routes.admin_page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          page: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end
end
