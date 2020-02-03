defmodule Crocodile.Plug.Whitelist do
  use CrocodileWeb, :plug

  def call(%{remote_ip: ip} = conn, _opts) do
    ip = to_string(:inet_parse.ntoa(conn.remote_ip))
    # require IEx
    # IEx.pry()
    require Logger
    Logger.warn("--------------------")
    Logger.warn(inspect(ip))
    Logger.warn("--------------------")
    conn
  end
end
