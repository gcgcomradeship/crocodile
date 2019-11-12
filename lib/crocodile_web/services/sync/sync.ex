defmodule Crocodile.Services.Sync do
  use CrocodileWeb, :services

  alias Crocodile.Services.Sync.StructBuilder
  alias Crocodile.Services.Sync.DB

  @db_link "https://sex-opt.ru/catalogue/db_export?type=csv&columns_separator=%26%26%26&text_separator=%40%40%40"

  def call() do
    case HTTPoison.get(@db_link, [], recv_timeout: 25000) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        sync(head(body), parse(body))

      error ->
        error
    end
  end

  defp sync(head, body) do
    for row <- body do
      head
      |> StructBuilder.call(row)
      |> DB.insert_or_update()
    end

    :ok
  end

  defp head(body) do
    [head | _data] = body |> String.split("\n")

    for title <- String.split(head, "&&&") do
      cut_quotes(title)
    end
  end

  defp parse(body) do
    [_head | data] = body |> String.split("\n")

    for row <- data do
      for elem <- String.split(row, "&&&") do
        cut_quotes(elem)
      end
    end
  end

  defp cut_quotes(str) do
    String.replace(str, "@@@", "")
  end
end
