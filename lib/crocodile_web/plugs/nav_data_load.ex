defmodule Crocodile.Plug.NavDataLoad do
  use CrocodileWeb, :plug

  alias Crocodile.Context.Items
  alias Crocodile.Context.Categories

  def call(%{assigns: %{session: %{id: sid}}} = conn, _opts) do
    conn
    |> assign(:cart, Items.cart_by_sid(sid))
    |> assign(:cat_hierarchy, Categories.hierarchy())
    |> assign(:cat_names, Categories.names())
  end
end
