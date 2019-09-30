defmodule CrocodileWeb.SessionController do
  use CrocodileWeb, :controller
  alias Crocodile.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    admin = Accounts.get_by_email(auth_params["email"])

    case Comeonin.Bcrypt.check_pass(admin, auth_params["password"]) do
      {:ok, admin} ->
        conn
        |> put_session(:current_admin_id, admin.id)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "There was a problem with your email/password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_admin_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
