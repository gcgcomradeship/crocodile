defmodule CrocodileWeb.ModalController do
  use CrocodileWeb, :controller
  alias Crocodile.Context.Items
  alias Crocodile.Session

  def item(conn, %{"item_id" => item_id} = params) do
    render(conn, "modal_item.json", item: Items.get(item_id))
  end

  def maturity_approve(%{assigns: %{session: session}} = conn, _params) do
    session
    |> Session.changeset(%{maturity: true})
    |> Repo.update()
    |> case do
      {:ok, %{maturity: true}} ->
        render(conn, "maturity_approve.json")

      _ ->
        render(conn, "error.json")
    end
  end
end
