defmodule Crocodile.Utils.Helper do
  def t(str) when is_bitstring(str), do: Gettext.gettext(CrocodileWeb.Gettext, str)
  def t(str) when is_atom(str), do: Gettext.gettext(CrocodileWeb.Gettext, to_string(str))

  def l(nil), do: "-"
  def l(date), do: Timex.format!(date, "%d.%m.%Y", :strftime)
  def l(date, :day), do: Timex.format!(date, "%d", :strftime)
  def l(date, :month), do: Timex.format!(date, "%m", :strftime)
  def l(date, :year), do: Timex.format!(date, "%Y", :strftime)
  def l(date, :day_month), do: Timex.format!(date, "%d.%m", :strftime)

  def l(date, :date_time),
    do:
      date
      |> Timex.Timezone.convert("Europe/Moscow")
      |> Timex.format!("%d.%m.%Y %H:%M", :strftime)

  def price(dec), do: "₽ #{dec |> Decimal.round(0) |> Decimal.to_string()}"

  def name(%Crocodile.Item{name: name, size: nil, color: nil}), do: name

  def name(%Crocodile.Item{name: name, size: size, color: nil}) when not is_nil(size),
    do: "#{name} (#{size})"

  def name(%Crocodile.Item{name: name, size: nil, color: color}) when not is_nil(color),
    do: "#{name} (#{color})"

  def name(%Crocodile.Item{name: name, size: size, color: color}),
    do: "#{name} (#{size} / #{color})"

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
    |> String.replace("http", "https")
  end

  def items_sum(items) do
    for item <- items do
      case item do
        %{retail_price: retail_price, count: count} -> Decimal.mult(retail_price, count)
        %{price: retail_price, quantity: count} -> Decimal.mult(retail_price, count)
      end
    end
    |> sum_all()
  end

  def total(%{retail_price: retail_price, count: count}) do
    retail_price |> Decimal.mult(count) |> Decimal.to_string()
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
