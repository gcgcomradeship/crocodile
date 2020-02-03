defmodule CrocodileWeb.Api.V1.NotifyController do
  use CrocodileWeb, :controller

  def notify(
        conn,
        %{"object" => %{"id" => id, "status" => status}} = _params
      ) do
    require Logger
    Logger.warn(inspect(_params))
    render(conn, "success.json")
  end
end
