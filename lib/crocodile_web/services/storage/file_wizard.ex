defmodule CrocodileWeb.Service.Storage.FileWizard do
  use CrocodileWeb, :services

  alias CrocodileWeb.Service.Storage.S3

  def save(%{filename: _filename, path: path}) do
    {:ok, body} = File.read(path)
    name = random_string()
    S3.upload(body, name)
  end

  def delete(url) when is_bitstring(url) do
    url
    |> S3.path_from_url()
    |> S3.delete()
  end

  def delete(_), do: nil
end
