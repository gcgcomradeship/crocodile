defmodule Crocodile.Services.Sync.StructBuilder do
  use CrocodileWeb, :services

  def call(head, body), do: to_map(head, body)

  defp to_map(head, body), do: to_map(head, body, [])

  defp to_map(["images" | ht], [bh | bt], acc) when bh != "" do
    val = String.split(bh, ",")
    to_map(ht, bt, acc ++ [{"images", val}])
  end

  defp to_map([hh | ht], [bh | bt], acc), do: to_map(ht, bt, acc ++ [{hh, bh}])
  defp to_map([], _body, acc), do: Enum.into(acc, %{})
end
