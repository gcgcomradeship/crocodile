defmodule Crocodile.Plug.NavDataLoad do
  use CrocodileWeb, :plug

  alias Crocodile.Context.Items
  alias Crocodile.Context.Categories
  alias Crocodile.Services.Banner
  alias Crocodile.Instagram
  alias Crocodile.Partner
  alias Crocodile.Blog

  def call(%{assigns: %{session: %{id: sid}}} = conn, _opts) do
    conn
    |> assign(:cart, Items.cart_by_sid(sid))
    |> assign(:categories, Categories.all())
    |> assign(:breadcrumbs, [])
    |> assign(:banners, Banner.main())
    |> assign(:banners_cat, Banner.catalog())
    |> assign(:partners, partners())
    |> assign(:instagrams, instagrams())
    |> assign(:blogs, blogs())
  end

  defp partners() do
    Partner
    |> order_by([p], desc: p.inserted_at)
    # |> limit(6)
    |> Repo.all()
  end

  defp instagrams() do
    Instagram
    |> order_by([i], desc: i.inserted_at)
    |> limit(10)
    |> Repo.all()
  end

  defp blogs() do
    Blog
    |> order_by([i], desc: i.inserted_at)
    |> limit(6)
    |> Repo.all()
  end
end
