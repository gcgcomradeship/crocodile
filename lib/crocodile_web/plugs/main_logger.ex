defmodule Crocodile.Plug.MainLogger do
  require Logger
  alias Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    start = System.monotonic_time()

    Conn.register_before_send(conn, fn conn ->
      Logger.log(:info, fn ->
        stop = System.monotonic_time()
        diff = System.convert_time_unit(stop - start, :native, :microsecond)

        [
          conn.method |> colored_message(51),
          conn.request_path |> colored_message(11),
          conn |> colored_params,
          colored_status(conn.status),
          formatted_diff(diff) |> colored_message(7),
          conn.private[:phoenix_format] |> colored_message(7),
          conn.private[:phoenix_controller] |> colored_message(7),
          conn.private[:phoenix_action] |> colored_message(7),
          "\n"
        ]
      end)

      conn
    end)
  end

  defp colored_params(conn) do
    conn
    |> get_params
    |> Jason.encode!()
    |> String.replace(~r/(,|:)/, "\\g{1} ")
    |> colored_message(46)
  end

  defp colored_status(status) do
    cond do
      Enum.member?(200..299, status) ->
        colored_message(status, 46)

      Enum.member?(300..399, status) ->
        colored_message(status, 220)

      true ->
        colored_message(status, 196)
    end
  end

  defp colored_message(message, ansi_code) do
    if Application.get_env(:opm, :environment) == :dev do
      "\e[38;5;#{ansi_code}m#{message} "
    else
      "#{message} "
    end
  end

  defp formatted_diff(diff) when diff > 1000, do: [diff |> div(1000) |> Integer.to_string(), "ms"]
  defp formatted_diff(diff), do: [Integer.to_string(diff), "µs"]

  defp get_params(%{params: _params = %Plug.Conn.Unfetched{}}), do: %{}

  defp get_params(%{params: params}) do
    params
    |> filter(
      ~w(password secret token jwt card_number expiry_month expiry_year cvv source_wallet_pwd user_id user_secure_id)
    )
    |> do_format_values
  end

  def filter(%{} = params, params_to_filter) do
    Enum.into(params, %{}, fn {k, v} ->
      case(is_binary(k) && String.contains?(k, params_to_filter)) do
        true -> {k, "FILTERED"}
        _ -> {k, v}
      end
    end)
  end

  def filter(other, _params_to_filter), do: other

  def do_format_values(%_{} = params), do: params |> Map.from_struct() |> do_format_values()

  def do_format_values(%{} = params), do: params |> Enum.into(%{}, &do_format_value/1)

  def do_format_value({key, value}) when is_binary(value) do
    if String.valid?(value) do
      {key, value}
    else
      {key, URI.encode(value)}
    end
  end

  def do_format_value(val), do: val
end
