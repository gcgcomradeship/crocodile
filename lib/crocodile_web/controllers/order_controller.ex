defmodule CrocodileWeb.OrderController do
  use CrocodileWeb, :controller

  alias Crocodile.Order

  def new(conn, _params) do
    changeset = Order.changeset(%Order{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order" => params}) do
    changeset = Order.changeset(%Order{}, params)

    case Repo.insert(changeset) do
      {:ok, order} ->
        redirect(conn, to: Routes.order_path(conn, :show, order))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
