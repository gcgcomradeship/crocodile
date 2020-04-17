defmodule Crocodile.Services.Catalog.Brands do
  use CrocodileWeb, :services

  alias Crocodile.Item

  def call() do
    Item
    |> where([i], i.insale > 0)
    |> where([i], i.hide == false)
    |> distinct(true)
    |> order_by([i], asc: i.vendor)
    |> select([i], i.vendor)
    |> Repo.all()
  end
end
