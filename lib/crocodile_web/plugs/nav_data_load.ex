defmodule Crocodile.Plug.NavDataLoad do
  use CrocodileWeb, :plug

  alias Crocodile.Context.Items
  alias Crocodile.Context.Categories
  alias Crocodile.Services.Banner

  def call(%{assigns: %{session: %{id: sid}}} = conn, _opts) do
    conn
    |> assign(:cart, Items.cart_by_sid(sid))
    |> assign(:categories, Categories.all())
    |> assign(:breadcrumbs, [])
    |> assign(:banners, Banner.main())
  end
end
