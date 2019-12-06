defmodule Crocodile.Context.Items do
  use CrocodileWeb, :context

  alias Crocodile.Category
  alias Crocodile.Product

  def croc_choice() do
    Product
    |> where_main()
    |> order_by([p], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  def new() do
    Product
    |> where_main()
    |> where([p], p.new == true)
    |> order_by([p], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  def recommend() do
    Product
    |> where_main()
    |> order_by([p], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  def hit() do
    Product
    |> where_main()
    |> where([p], p.hit == true)
    |> order_by([p], fragment("RANDOM()"))
    |> limit(8)
    |> Repo.all()
  end

  defp where_main(query) do
    query
    |> where([p], p.msk == true)
  end
end
