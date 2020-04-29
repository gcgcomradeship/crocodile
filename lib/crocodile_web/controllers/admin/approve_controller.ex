defmodule CrocodileWeb.Admin.ApproveController do
  use CrocodileWeb, :controller

  alias Crocodile.Item

  def index(conn, _params) do
    items_count =
      Item
      |> where([i], i.insale > 0)
      |> where([i], i.hide == false)
      |> where([i], is_nil(i.approve))
      |> select([i], count(i.id))
      |> Repo.one()

    item =
      Item
      |> where([i], i.insale > 0)
      |> where([i], i.hide == false)
      |> where([i], is_nil(i.approve))
      |> limit(1)
      |> Repo.one()

    render(conn, "index.html", item: item, items_count: items_count)
  end

  def approve(conn, %{"approve_id" => item_id}) do
    Item
    |> Repo.get(item_id)
    |> Item.changeset(%{approve: Timex.now()})
    |> Repo.update()
    |> case do
      {:ok, _item} -> render(conn, "success.json")
      _ -> render(conn, "error.json")
    end
  end

  def hide(conn, %{"approve_id" => item_id}) do
    Item
    |> Repo.get(item_id)
    |> Item.changeset(%{hide: true})
    |> Repo.update()
    |> case do
      {:ok, _item} -> render(conn, "success.json")
      _ -> render(conn, "error.json")
    end
  end

  def refresh(conn, _) do
    items_count =
      Item
      |> where([i], i.insale > 0)
      |> where([i], i.hide == false)
      |> where([i], is_nil(i.approve))
      |> select([i], count(i.id))
      |> Repo.one()

    Item
    |> where([i], i.insale > 0)
    |> where([i], i.hide == false)
    |> where([i], is_nil(i.approve))
    |> limit(1)
    |> Repo.one()
    |> case do
      nil ->
        render(conn, "empty.json")

      item ->
        render(conn, "refresh.json",
          item_id: item.id,
          item_title: item.name,
          item_images: item.images,
          items_count: items_count
        )
    end
  end
end
