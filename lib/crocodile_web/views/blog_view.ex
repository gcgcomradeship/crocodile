defmodule CrocodileWeb.BlogView do
  use CrocodileWeb, :view

  def render("success.json", %{count: count}) do
    %{
      status: :success,
      count: count
    }
  end

  def render("error.json", _data) do
    %{
      status: :error
    }
  end
end
