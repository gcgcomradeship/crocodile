defmodule Crocodile.Services.Banner do
  use CrocodileWeb, :services

  alias Crocodile.Banner

  def main() do
    for banner <- Repo.all(Banner) do
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
end
