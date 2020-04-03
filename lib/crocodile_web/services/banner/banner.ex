defmodule Crocodile.Services.Banner do
  use CrocodileWeb, :services

  alias Crocodile.Banner

  def main() do
    banners =
      Banner
      |> where([b], not ilike(b.name, "banner_main_cat%"))
      |> Repo.all()

    for banner <- banners do
      {banner.name,
       %{
         text1: banner.text1,
         text2: banner.text2,
         text3: banner.text3,
         path: banner.path,
         link_to: banner.link_to
       }}
    end
    |> Enum.into(%{})
  end

  def catalog() do
    Banner
    |> where([b], ilike(b.name, "banner_main_cat%"))
    |> order_by([b], asc: b.name)
    |> Repo.all()
  end
end
