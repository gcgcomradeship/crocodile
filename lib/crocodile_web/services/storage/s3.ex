defmodule CrocodileWeb.Service.Storage.S3 do
  use CrocodileWeb, :services

  @host System.get_env("MINIO_HOST")
  @bucket "test"

  def upload(body, path) do
    ExAws.S3.put_object(bucket(), path, body) |> ExAws.request(host: @host)
    link(path)
  end

  def delete(path) do
    bucket()
    |> ExAws.S3.delete_object(path)
    |> ExAws.request(host: @host)
  end

  def link(path) do
    "https://#{@host}/#{bucket()}/#{path}"
  end

  def list() do
    bucket()
    |> ExAws.S3.list_objects()
    |> ExAws.request(host: @host)
    |> case do
      {:ok, %{body: %{contents: data}}} -> Enum.map(data, & &1.key)
      _ -> :error
    end
  end

  def path_from_url(url) do
    String.replace(url, "https://#{@host}/#{bucket()}/", "")
  end

  defp bucket() do
    case Mix.env() do
      :prod -> "public"
      _ -> "test"
    end
  end
end
