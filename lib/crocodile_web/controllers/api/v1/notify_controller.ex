defmodule CrocodileWeb.Api.V1.NotifyController do
  use CrocodileWeb, :controller

  alias Crocodile.Order
  alias Crocodile.Payment

  @account_id Application.get_env(:crocodile, :kassa)[:id]

  def notify(
        conn,
        %{"object" => %{"id" => kassa_id, "status" => status}} = _params
      ) do
    payment =
      Payment
      |> where([p], p.account_id == ^@account_id and p.kassa_id == ^kassa_id)
      |> Repo.one()

    case payment do
      nil ->
        conn
        |> put_status(403)
        |> render("error.json")

      %Payment{} ->
        render(conn, "success.json")
    end
  end

  def notify(conn, _params) do
    conn
    |> put_status(403)
    |> render("error.json")
  end
end
