defmodule CrocodileWeb.SessionController do
  use CrocodileWeb, :controller
  alias Crocodile.User
  alias Crocodile.Session
  alias Crocodile.Context.Items

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => pass}) do
    User
    |> where([u], u.email == ^email)
    |> Repo.one()
    |> Comeonin.Bcrypt.check_pass(pass)
    |> case do
      {:ok, user} ->
        session_update(conn, user)
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, _} ->
        redirect(conn, to: Routes.session_path(conn, :new))
    end
  end

  def sign_up(conn, params) do
    changeset = User.changeset(%User{}, params)

    render(conn, "sign_up.html", changeset: changeset)
  end

  def sign_up_create(conn, params) do
    changeset = User.sign_up_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        session_update(conn, user)
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "sign_up.html", changeset: changeset)
    end
  end

  defp session_update(%{assigns: %{session: session}} = _conn, %{id: user_id} = _user) do
    session
    |> Session.changeset(%{user_id: user_id})
    |> Repo.update()
  end

  def delete(%{assigns: %{session: session}} = conn, _params) do
    session
    |> Session.changeset(%{user_id: nil})
    |> Repo.update()

    conn
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
