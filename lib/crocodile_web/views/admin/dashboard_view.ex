defmodule CrocodileWeb.Admin.DashboardView do
  use CrocodileWeb, :view

  def color_by_kind(kind) do
    %{
      "Товарная группа" => "tag_color1",
      "Основное свойство товара" => "tag_color2",
      "Питание" => "tag_color3",
      "Товар" => "tag_color4",
      "Эффект" => "tag_color5",
      "Функции" => "tag_color6",
      "Второстепенное свойство товара" => "tag_color7",
      "Форма товара" => "tag_color8",
      "Основа" => "tag_color9",
      "Гендерный признак" => "tag_color10"
    }
    |> Map.get(kind)
  end
end
