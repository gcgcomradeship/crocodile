defmodule CrocodileWeb.Admin.SyncController do
  use CrocodileWeb, :controller

  alias Crocodile.Item

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def sync(conn, %{"file" => %Plug.Upload{path: path}}) do
    {:ok, raw} = File.read(path)

    data =
      raw
      |> String.split("\n")
      |> List.delete_at(0)
      |> List.delete_at(-1)
      |> Enum.map(fn str ->
        [b, n, h] = String.split(str, ";")
        [b, to_bool(n), to_bool(h)]
      end)

    items =
      Item
      |> select([i], [i.barcode, i.new, i.hit])
      |> Repo.all()

    filtered = data -- items

    filtered_barcodes = Enum.map(filtered, fn [b | _] -> b end)
    item_barcodes = Enum.map(items, fn [b | _] -> b end)

    filtred_by_barcode = filtered_barcodes -- item_barcodes

    barcodes = filtered_barcodes -- filtred_by_barcode

    to_update =
      data
      |> Enum.filter(fn [b | _] -> b in barcodes end)
      |> Enum.map(fn [b, n, h] -> {b, %{new: n, hit: h}} end)

    for {barcode, struct} <- to_update do
      Item
      |> Repo.get_by(barcode: barcode)
      |> Item.changeset(struct)
      |> Repo.update()
    end

    conn
    |> render("index.html", text: "Обновлено #{length(to_update)} позиций")
  end

  defp to_bool("0"), do: false
  defp to_bool("1"), do: true
end
