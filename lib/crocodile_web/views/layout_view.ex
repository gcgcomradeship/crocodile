defmodule CrocodileWeb.LayoutView do
  use CrocodileWeb, :view

  def active(%{request_path: request_path}, "/admin" = path) do
    if request_path == path, do: "active"
  end

  def active(%{request_path: request_path}, path) do
    if String.starts_with?(request_path, path), do: "active"
  end
end
