defmodule CrocodileWeb.LiveHandlers.EventHandler do
  use CrocodileWeb, :live_handlers

  def call(socket, data, value) do
    socket
  end

  def call(socket, data, value, :admin) do
    keyword =
      data
      |> String.split("_")
      |> List.first()
      |> String.capitalize()

    module_name =
      "Elixir.CrocodileWeb.LiveHandlers.Admin#{keyword}"
      |> String.to_existing_atom()

    apply(module_name, :call, [socket, data, value])
  end
end
