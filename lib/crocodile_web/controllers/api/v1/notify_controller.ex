defmodule CrocodileWeb.Api.V1.NotifyController do
  use CrocodileWeb, :controller

  alias Crocodile.Orders
  alias Crocodile.Payment
  alias Crocodile.Payments

  @account_id Application.get_env(:crocodile, :kassa)[:id]

  def notify(
        conn,
        %{"object" => %{"id" => kassa_id, "status" => status, "refundable" => refundable}} =
          _params
      ) do
    payment =
      Payment
      |> preload(:order)
      |> where([p], p.account_id == ^@account_id and p.kassa_id == ^kassa_id)
      |> Repo.one()

    case payment do
      nil ->
        conn
        |> put_status(403)
        |> render("error.json")

      %Payment{} ->
        Payments.on_order_update(payment, %{status: status, refundable: refundable})
        Orders.on_order_update(payment.order, %{payment_status: get_order_status(status)})
        render(conn, "success.json")
    end
  end

  def notify(conn, _params) do
    conn
    |> put_status(403)
    |> render("error.json")
  end

  defp get_order_status(payment_status) do
    case payment_status do
      status when status in ["pending", :pending] ->
        :created

      status when status in ["waiting_for_capture", :waiting_for_capture] ->
        :created

      status when status in ["succeeded", :succeeded] ->
        :paid

      status when status in ["canceled", :canceled] ->
        :canceled

      _ ->
        :unknown
    end
  end
end
