# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Crocodile.Repo.insert!(%Crocodile.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Crocodile.Banner
alias Crocodile.Setting
alias Crocodile.Repo

settings = %{
  "delivery_prices" => %{
    "pick_up" => 300,
    "courier" => 400,
    "post" => 500
  }
}

banners = %{
  "banner_main_1" => %{
    text1: "crocodildo",
    text2: "женские игрушки",
    text3: "каталог",
    link_to: "/catalog"
  },
  "banner_main_2" => %{
    text1: "crocodildo",
    text2: "мужские игрушки",
    text3: "каталог",
    link_to: "/catalog"
  },
  "banner_main_sub_left" => %{
    text1: "скидки до 60%",
    text2: "мужчины",
    link_to: "/catalog"
  },
  "banner_main_sub_right" => %{
    text1: "скидки до 30%",
    text2: "женщины",
    text3: "",
    link_to: "/catalog"
  },
  "banner_main_parallax" => %{
    text1: "2020",
    text2: "тренд года",
    text3: "специальное предложение"
  },
  "banner_catalog_left" => %{}
}

for {name, data} <- settings do
  case Repo.get_by(Setting, name: name) do
    nil ->
      %Setting{}
      |> Setting.changeset(%{name: name, data: data})
      |> Repo.insert()

    _ ->
      nil
  end
end

for {name, data} <- banners do
  case Repo.get_by(Banner, name: name) do
    nil ->
      %Banner{}
      |> Banner.changeset(Map.merge(%{name: name}, data))
      |> Repo.insert()

    _ ->
      nil
  end
end
