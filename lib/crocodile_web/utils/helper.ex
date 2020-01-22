defmodule Crocodile.Utils.Helper do
  def concatinate(str, len \\ 20) when is_bitstring(str) do
    case String.length(str) do
      l when l > len -> "#{String.slice(str, 0..len)}..."
      _ -> str
    end
  end

  def image(images, type)
  def image(nil, _type), do: "/images/pro3/1.jpg"

  def image(images, type \\ :first) when is_list(images) do
    case type do
      :first -> List.first(images)
      _ -> List.last(images)
    end
  end

  def items_sum(items) do
    for item <- items do
      item.price |> Decimal.mult(item.count)
    end
    |> sum_all()
  end

  def total(%{price: price, count: count}) do
    price |> Decimal.mult(count) |> Decimal.to_string()
  end

  defp sum_all(list), do: sum_all(list, Decimal.new(0))
  defp sum_all([], res), do: res
  defp sum_all([h | t], res), do: sum_all(t, Decimal.add(h, res))
end
