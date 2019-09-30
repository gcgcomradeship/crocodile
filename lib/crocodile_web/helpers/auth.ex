defmodule CrocodileWeb.Helpers.Auth do
  def signed_in?(conn) do
    admin_id = Plug.Conn.get_session(conn, :current_admin_id)
    if admin_id, do: !!Crocodile.Repo.get(Crocodile.Accounts.Admin, admin_id)
  end
end
