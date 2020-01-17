defmodule CrocodileWeb.CartView do
  use CrocodileWeb, :view

  def render("success.json", _data) do
    %{
      status: :success
    }
  end

  def render("error.json", _data) do
    %{
      status: :error
    }
  end
end
