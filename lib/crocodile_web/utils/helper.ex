defmodule Crocodile.Utils.Helper do
  def t(str) when is_bitstring(str), do: Gettext.gettext(CrocodileWeb.Gettext, str)
  def t(str) when is_atom(str), do: Gettext.gettext(CrocodileWeb.Gettext, to_string(str))

  def l(nil), do: "-"
  def l(date), do: Timex.format!(date, "%d.%m.%Y", :strftime)
  def l(date, :day), do: Timex.format!(date, "%d", :strftime)
  def l(date, :month), do: Timex.format!(date, "%m", :strftime)
  def l(date, :year), do: Timex.format!(date, "%Y", :strftime)
  def l(date, :day_month), do: Timex.format!(date, "%d.%m", :strftime)
  def price(dec), do: "₽ #{Decimal.to_string(dec)}"

  def to_int(data) when is_bitstring(data), do: String.to_integer(data)
  def to_int(data) when is_integer(data), do: data

  def concatinate(str, len \\ 20) when is_bitstring(str) do
    case String.length(str) do
      l when l > len -> "#{String.slice(str, 0..len)}..."
      _ -> str
    end
  end

  def random_string(length \\ 10) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
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

  defp month_name(day) do
    map =
      %{
        "01" => "Январь",
        "02" => "Февраль",
        "03" => "Март",
        "04" => "Апрель",
        "05" => "Май",
        "06" => "Июнь",
        "07" => "Июль",
        "08" => "Август",
        "09" => "Сентябрь",
        "10" => "Октябрь",
        "11" => "Ноябрь",
        "12" => "Декабрь"
      }
      |> Map.get(day)
      |> case do
        nil -> day
        res -> res
      end
  end
end
