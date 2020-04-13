defmodule CrocodileWeb.Admin.PartnerController do
  use CrocodileWeb, :controller

  alias Crocodile.Partner

  def index(conn, _params) do
    partners =
      Partner
      |> Repo.all()

    render(conn, "index.html", partners: partners)
  end

  def new(conn, _params) do
    changeset = Partner.changeset(%Partner{}, %{})
    render(conn, "new.html", partner: changeset.data, changeset: changeset)
  end

  def create(conn, %{
        "partner" => partner_params
      }) do
    changeset = Partner.changeset(%Partner{}, partner_params)

    case Repo.insert(changeset) do
      {:ok, partner} ->
        conn
        |> put_flash(:info, "Logo created successfully.")
        |> redirect(to: Routes.admin_partner_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          partner: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end

  def edit(conn, %{"id" => id}) do
    partner = Partner |> Repo.get(id)
    changeset = Partner.changeset(partner, %{})
    render(conn, "edit.html", partner: partner, changeset: changeset)
  end

  def update(conn, %{
        "id" => id,
        "partner" => partner_params
      }) do
    partner = Partner |> Repo.get(id)

    changeset = Partner.changeset(partner, partner_params)

    case Repo.update(changeset) do
      {:ok, partner} ->
        conn
        |> put_flash(:info, "Logo updated successfully.")
        |> redirect(to: Routes.admin_partner_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          partner: Map.merge(changeset.data, changeset.changes),
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    partner = Partner |> Repo.get(id)
    {:ok, _partner} = Repo.delete(partner)

    conn
    |> put_flash(:info, "Logo deleted successfully.")
    |> redirect(to: Routes.admin_partner_path(conn, :index))
  end
end
