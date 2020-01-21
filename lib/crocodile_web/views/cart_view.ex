defmodule CrocodileWeb.CartView do
  use CrocodileWeb, :view

  def render("success.json", %{cart: cart}) do
    %{
      cart: render_many(cart, __MODULE__, "cart_item.json"),
      status: :success
    }
  end

  def render("cart_item.json", %{cart: item}) do
    %{
      count: item.count,
      item_id: item.id,
      price: item.price,
      image: List.first(item.images),
      title: concatinate(item.title)
    }
  end

  def render("success.json", _data) do
    %{
      status: :success
    }
  end

  def render("error.json", _data) do
    %{
      status: :error
    }
  end
end
