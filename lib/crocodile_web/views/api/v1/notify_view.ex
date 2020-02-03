defmodule CrocodileWeb.Api.V1.NotifyView do
  use CrocodileWeb, :view

  def render("success.json", _) do
    %{
      status: :success
    }
  end

  def render("error.json", _) do
    %{
      status: :forbidden
    }
  end
end
