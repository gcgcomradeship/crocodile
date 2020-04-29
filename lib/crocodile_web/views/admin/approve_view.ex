defmodule CrocodileWeb.Admin.ApproveView do
  use CrocodileWeb, :view

  def render("refresh.json", %{
        item_id: item_id,
        item_title: item_name,
        item_images: item_images,
        items_count: items_count
      }) do
    %{
      count: items_count,
      item_id: item_id,
      item_title: item_name,
      item_images: item_images,
      status: :refresh
    }
  end

  def render("success.json", %{}) do
    %{
      status: :success
    }
  end

  def render("error.json", _data) do
    %{
      status: :error
    }
  end

  def render("empty.json", _data) do
    %{
      status: :empty
    }
  end
end
