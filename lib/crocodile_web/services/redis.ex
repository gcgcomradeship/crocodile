defmodule Crocodile.Service.Redis do
  defp url(), do: Application.get_env(:crocodile, :redis)[:url]

  def get(key) when is_bitstring(key) do
    {:ok, conn} = connect()
    {:ok, result} = Redix.command(conn, ["GET", key])
    close(conn)
    result
  end

  def pipe(cmd_list) do
    {:ok, conn} = connect()
    {:ok, result} = Redix.pipeline(conn, cmd_list)
    close(conn)
    result
  end

  def set(key, value) when is_bitstring(key) do
    {:ok, conn} = connect()
    {:ok, result} = Redix.command(conn, ["SET", key, value])
    close(conn)
    result
  end

  def del(key) do
    {:ok, conn} = connect()
    {:ok, result} = Redix.command(conn, ["DEL", key])
    close(conn)
    result
  end

  def setex(key, value, seconds)
      when is_bitstring(key) and is_bitstring(value) and is_integer(seconds) do
    {:ok, conn} = connect()
    {:ok, result} = Redix.command(conn, ["SETEX", key, seconds, value])
    close(conn)
    result
  end

  def flush() do
    {:ok, conn} = connect()
    {:ok, result} = Redix.command(conn, ["FLUSHALL"])
    close(conn)
    result
  end

  def keys(pattern \\ "*") do
    {:ok, conn} = connect()
    {:ok, result} = Redix.command(conn, ["KEYS", pattern])
    close(conn)
    result
  end

  def health() do
    case set("health check", "OK") do
      "OK" -> "OK"
      _ -> "Failed"
    end
  end

  defp connect(), do: Redix.start_link(url())

  defp close(conn), do: Redix.stop(conn)
end
