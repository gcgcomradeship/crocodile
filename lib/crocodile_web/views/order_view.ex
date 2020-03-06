defmodule CrocodileWeb.OrderView do
  use CrocodileWeb, :view

  def delivery_by_type(nil), do: ""

  def delivery_by_type(type) do
    %{
      pick_up: "Постамат",
      post: "Почта",
      courier: "Курьер"
    }
    |> Map.get(type)
  end
end
