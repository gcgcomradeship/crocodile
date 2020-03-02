defmodule Crocodile.Services.Sync do
  use CrocodileWeb, :services

  alias Crocodile.Services.Sync.StructBuilder
  # alias Crocodile.Services.Sync.Category
  alias Crocodile.Services.Sync.DB
  # alias Crocodile.Services.Catalog.Brands

  @db_link "http://stripmag.ru/datafeed/insales_full.csv"
  @db_update_link "http://stripmag.ru/datafeed/insales_quick.csv"

  def call(key \\ :sync) do
    case HTTPoison.get(get_url(key), [], recv_timeout: 25000) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        sync(head(body), parse(body), key)

      error ->
        error
    end
  end

  defp sync(head, body, key) do
    for row <- body do
      head
      |> StructBuilder.call(row, key)
      |> DB.insert_or_update()
    end

    :ok
  end

  defp get_url(:sync), do: @db_link
  defp get_url(:update), do: @db_update_link

  defp head(body) do
    [head | _data] = body |> String.split("\n")

    for title <- String.split(head, ";") do
      cut_quotes(title)
    end
  end

  defp parse(body) do
    [_head | data] = body |> String.split("\n")

    for row <- data do
      for elem <- String.split(row, ";") do
        cut_quotes(elem)
      end
    end
  end

  defp cut_quotes(str) do
    String.replace(str, "\"", "")
  end
end
