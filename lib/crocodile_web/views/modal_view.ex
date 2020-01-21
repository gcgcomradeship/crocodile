defmodule CrocodileWeb.ModalView do
  use CrocodileWeb, :view

  def render("modal_item.json", %{item: item}) do
    %{
      item: render_one(item, __MODULE__, "item.json"),
      status: :success
    }
  end

  def render("item.json", %{modal: item}) do
    %{
      item_id: item.id,
      price: "₽ #{item.price}",
      image: List.first(item.images),
      # title: concatinate(item.title),
      title: item.title,
      description: item.description
    }
  end
end
