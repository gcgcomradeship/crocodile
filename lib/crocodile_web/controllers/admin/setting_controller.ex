defmodule CrocodileWeb.Admin.SettingController do
  use CrocodileWeb, :controller

  alias Crocodile.Setting

  def index(conn, _params) do
    settings =
      Setting
      |> Repo.all()

    delivery_prices = Enum.find(settings, &(&1.name == "delivery_prices"))

    render(conn, "index.html", delivery_prices: delivery_prices)
  end

  def update(conn, %{"id" => id, "setting" => setting_params}) do
    setting = Setting |> Repo.get(id)

    changeset = Setting.changeset(setting, setting_params)

    case Repo.update(changeset) do
      {:ok, setting} ->
        conn
        |> put_flash(:info, "Setting updated successfully.")
        |> redirect(to: Routes.admin_setting_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:warning, "Setting update error")
        |> redirect(to: Routes.admin_setting_path(conn, :index))
    end
  end
end
