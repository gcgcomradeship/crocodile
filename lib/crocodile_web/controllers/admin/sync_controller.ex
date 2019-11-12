defmodule CrocodileWeb.Admin.SyncController do
  use CrocodileWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
