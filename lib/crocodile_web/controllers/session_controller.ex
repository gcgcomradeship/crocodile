defmodule CrocodileWeb.SessionController do
  use CrocodileWeb, :controller
  alias Crocodile.User
  alias Crocodile.Session
  alias Crocodile.Context.Categories
  alias Crocodile.Context.Items

  def new(conn, _params) do
    render(conn, "new.html",
      cat_hierarchy: Categories.hierarchy(),
      cat_names: Categories.names()
    )
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

    render(conn, "sign_up.html",
      cat_hierarchy: Categories.hierarchy(),
      cat_names: Categories.names(),
      changeset: changeset
    )
  end

  def sign_up_create(conn, params) do
    changeset = User.sign_up_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        session_update(conn, user)
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "sign_up.html",
          cat_hierarchy: Categories.hierarchy(),
          cat_names: Categories.names(),
          changeset: changeset
        )
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

  #   def forgot_password(conn, %{"email" => email} = _params) do
  #     Admin
  #     |> where([a], a.email == ^email)
  #     |> Repo.one()
  #     |> case do
  #       admin when not is_nil(admin) ->
  #         PasswordReset.send_email(admin)

  #         conn
  #         |> render("success.json", %{forgot_password: true})

  #       n when is_nil(n) ->
  #         conn
  #         |> put_status(401)
  #         |> render(OpmWeb.ErrorView, "error.json")
  #     end
  #   end

  #   def new_password(conn, %{"password_reset_token" => token}) do
  #     render(conn, "new_password.html", token: get_csrf_token(), reset_token: token)
  #   end

  #   def new_password(conn, _params) do
  #     conn
  #     |> redirect(to: Routes.session_path(conn, :new))
  #   end

  #   def change_password(conn, %{"reset_token" => reset_token, "password" => password}) do
  #     Admin
  #     |> where([a], a.password_reset_token == ^reset_token)
  #     |> Repo.one()
  #     |> case do
  #       admin when not is_nil(admin) ->
  #         Admin.changeset(admin, %{password: password, password_reset_token: nil}, %{
  #           reset_password: true
  #         })
  #         |> Repo.update()

  #         conn
  #         |> render("success.json", url: Routes.session_path(conn, :new))

  #       n when is_nil(n) ->
  #         conn
  #         |> put_status(401)
  #         |> render(OpmWeb.ErrorView, "error.json")
  #     end
  #   end
end
