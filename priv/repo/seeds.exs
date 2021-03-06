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
alias Crocodile.Page
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
  "banner_catalog_left" => %{},
  "banner_main_cat_1_1" => %{
    text1: "Вибраторы",
    link_to: "/catalog?category=Вибраторы"
  },
  "banner_main_cat_1_2" => %{
    text1: "Анальные игрушки",
    link_to: "/catalog?category=Анальные+игрушки"
  },
  "banner_main_cat_1_3" => %{
    text1: "Фаллоимитаторы",
    link_to: "/catalog?category=Фаллоимитаторы"
  },
  "banner_main_cat_1_4" => %{
    text1: "Смазки, лубриканты",
    link_to: "/catalog?category=Смазки%2C+лубриканты"
  },
  "banner_main_cat_2_1" => %{
    text1: "Секс-товары для женщин",
    link_to: "/catalog?category=Смазки%2C+лубриканты"
  },
  "banner_main_cat_2_2" => %{
    text1: "Секс-товары для мужчин",
    link_to: "/catalog?category=Секс-товары+для+мужчин"
  },
  "banner_main_cat_2_3" => %{
    text1: "BDSM, садо-мазо товары",
    link_to: "/catalog?category=BDSM%2C+садо-мазо+товары"
  },
  "banner_main_cat_2_4" => %{
    text1: "Косметика с феромонами",
    link_to: "/catalog?category=Косметика+с+феромонами"
  },
  "banner_main_cat_3_1" => %{
    text1: "Эротическая одежда",
    link_to: "/catalog?category=Эротическая+одежда"
  },
  "banner_main_cat_3_2" => %{
    text1: "Страпоны, фаллопротезы",
    link_to: "/catalog?category=Страпоны%2C+фаллопротезы"
  },
  "banner_main_cat_3_3" => %{
    text1: "Секс-мебель и качели",
    link_to: "/catalog?category=Секс-мебель+и+качели"
  },
  "banner_main_cat_3_4" => %{
    text1: "Приятные мелочи",
    link_to: "/catalog?category=Приятные+мелочи"
  }
}

static_pages = [
  "page_terms_of_use",
  "page_privacy_policy",
  "page_contacts",
  "page_delivery",
  "page_warranty",
  "page_about",
  "page_requisites",
  "page_feedback",
  "page_payment"
]

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

for name <- static_pages do
  case Repo.get_by(Page, name: name) do
    nil ->
      %Page{}
      |> Page.changeset(%{name: name})
      |> Repo.insert()

    _ ->
      nil
  end
end
