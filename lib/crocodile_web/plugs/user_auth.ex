defmodule Crocodile.Plug.UserAuth do
  use CrocodileWeb, :plug
  alias Crocodile.User
  alias Crocodile.Session

  def call(conn, _opts) do
    conn
    |> find_session()
    |> find_user()
  end

  defp find_session(conn) do
    session =
      with sid when not is_nil(sid) <- Plug.Conn.get_session(conn, :sid),
           %Session{id: id} = session when not is_nil(id) <- Repo.get(Session, sid) do
        session
      else
        _ -> new_session()
      end

    conn
    |> put_session(:sid, session.id)
    |> assign(:session, session)
  end

  defp new_session() do
    %Session{}
    |> Session.changeset(%{})
    |> Repo.insert!()
  end

  defp find_user(%{assigns: %{session: %{user_id: user_id}}} = conn) when not is_nil(user_id) do
    case Repo.get(User, user_id) do
      nil -> conn
      user -> assign(conn, :current_user, user)
    end
  end

  defp find_user(conn), do: conn
end
