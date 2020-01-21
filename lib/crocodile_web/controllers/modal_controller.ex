defmodule CrocodileWeb.ModalController do
  use CrocodileWeb, :controller
  alias Crocodile.Context.Items

  def item(conn, %{"item_id" => item_id} = params) do
    render(conn, "modal_item.json", item: Items.get(item_id))
  end
end
