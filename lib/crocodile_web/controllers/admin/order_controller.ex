defmodule CrocodileWeb.Admin.OrderController do
  use CrocodileWeb, :controller

  alias Crocodile.Order
  alias Crocodile.Services

  def index(conn, _params) do
    orders =
      Order
      |> where([o], is_nil(o.deleted_at))
      |> order_by([o], desc: o.id)
      |> Repo.all()

    render(conn, "index.html", orders: orders)
  end

  def show(conn, %{"id" => id}) do
    order =
      Order
      |> preload(items_orders: [:item])
      |> Repo.get(id)

    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id, "type" => type} = params) do
    order =
      Order
      |> Repo.get(id)

    order = Order |> Repo.get(id)
    changeset = Order.changeset(order, %{})

    render(conn, "edit.html", order: order, changeset: changeset, form_type: type)
  end

  def update(conn, %{
        "id" => id,
        "type" => form_type,
        "order" => order_params
      }) do
    order = Order |> Repo.get(id)

    changeset = Order.changeset(order, order_params)

    case Repo.update(changeset) do
      {:ok, order} ->
        Services.Order.recalculate(order)

        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: Routes.admin_order_path(conn, :show, order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          order: Map.merge(changeset.data, changeset.changes),
          changeset: changeset,
          form_type: form_type
        )
    end
  end

  def send_remote(conn, %{"order_id" => id}) do
    order =
      Order
      |> preload(items_orders: [:item])
      |> Repo.get(id)

    case Services.Order.send_to_partner(order) do
      {:ok, partner_id, message} ->
        {:ok, updated_order} =
          order
          |> Order.changeset(%{partner_id: partner_id})
          |> Repo.update()

        conn
        |> put_flash(:info, "Order sended to partner successfully.")
        |> redirect(to: Routes.admin_order_path(conn, :show, updated_order))

      {:test, message} ->
        conn
        |> put_flash(:info, "Order sended to partner successfully (TEST MODE).")
        |> redirect(to: Routes.admin_order_path(conn, :show, order))

      {:error, status, message} ->
        conn
        |> put_flash(:warning, message)
        |> redirect(to: Routes.admin_order_path(conn, :show, order))
    end

    redirect(conn, to: Routes.admin_order_path(conn, :show, order))
  end

  def archive(conn, %{"order_id" => id}) do
    order =
      Order
      |> Repo.get(id)
      |> Order.changeset(%{deleted_at: Timex.now()})
      |> Repo.update()

    redirect(conn, to: Routes.admin_order_path(conn, :index))
  end

  # def new(conn, _params) do
  #   changeset = Partner.changeset(%Partner{}, %{})
  #   render(conn, "new.html", partner: changeset.data, changeset: changeset)
  # end

  # def create(conn, %{
  #       "partner" => partner_params
  #     }) do
  #   changeset = Partner.changeset(%Partner{}, partner_params)

  #   case Repo.insert(changeset) do
  #     {:ok, partner} ->
  #       conn
  #       |> put_flash(:info, "Logo created successfully.")
  #       |> redirect(to: Routes.admin_partner_path(conn, :index))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html",
  #         partner: Map.merge(changeset.data, changeset.changes),
  #         changeset: changeset
  #       )
  #   end
  # end

  # def edit(conn, %{"id" => id}) do
  #   partner = Partner |> Repo.get(id)
  #   changeset = Partner.changeset(partner, %{})
  #   render(conn, "edit.html", partner: partner, changeset: changeset)
  # end

  # def update(conn, %{
  #       "id" => id,
  #       "partner" => partner_params
  #     }) do
  #   partner = Partner |> Repo.get(id)

  #   changeset = Partner.changeset(partner, partner_params)

  #   case Repo.update(changeset) do
  #     {:ok, partner} ->
  #       conn
  #       |> put_flash(:info, "Logo updated successfully.")
  #       |> redirect(to: Routes.admin_partner_path(conn, :index))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html",
  #         partner: Map.merge(changeset.data, changeset.changes),
  #         changeset: changeset
  #       )
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   partner = Partner |> Repo.get(id)
  #   {:ok, _partner} = Repo.delete(partner)

  #   conn
  #   |> put_flash(:info, "Logo deleted successfully.")
  #   |> redirect(to: Routes.admin_partner_path(conn, :index))
  # end
end
