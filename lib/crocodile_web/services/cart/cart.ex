defmodule Crocodile.Services.Cart do
  use CrocodileWeb, :services

  def add(session_id, item_id, count \\ 1) when count >= 0 do
    cart = get(session_id)
    item = Map.get(cart, "#{item_id}") || item_struct()
    new_item = Map.put(item, "cnt", item["cnt"] + count)
    new_cart = Map.put(cart, "#{item_id}", new_item)

    case Redis.set("cart/#{session_id}", Jason.encode!(new_cart)) do
      "OK" -> new_cart
      _ -> {:error, "Something was wrong"}
    end
  end

  def set(session_id, item_id, count) when count > 0 do
    cart = get(session_id)
    item = Map.get(cart, "#{item_id}") || item_struct()
    new_item = Map.put(item, "cnt", count)
    new_cart = Map.put(cart, "#{item_id}", new_item)

    case Redis.set("cart/#{session_id}", Jason.encode!(new_cart)) do
      "OK" -> new_cart
      _ -> {:error, "Something was wrong"}
    end
  end

  def remove(session_id, item_id) do
    cart = get(session_id)
    new_cart = Map.delete(cart, "#{item_id}")

    case Redis.set("cart/#{session_id}", Jason.encode!(new_cart)) do
      "OK" -> new_cart
      _ -> {:error, "Something was wrong"}
    end
  end

  def remove(session_id, item_id, count) do
    cart = get(session_id)
    item = Map.get(cart, "#{item_id}") || item_struct()

    case item["cnt"] - count do
      res when res > 0 ->
        new_item = Map.put(item, "cnt", res)
        new_cart = Map.put(cart, "#{item_id}", new_item)

        Redis.set("cart/#{session_id}", Jason.encode!(new_cart))
        new_cart

      0 ->
        new_cart = Map.delete(cart, "#{item_id}")

        Redis.set("cart/#{session_id}", Jason.encode!(new_cart))
        new_cart

      _ ->
        {:error, "Сannot get a negative value"}
    end
  end

  def get(session_id) do
    (Redis.get("cart/#{session_id}") || "{}")
    |> Jason.decode!()
  end

  def clear(session_id) do
    Redis.del("cart/#{session_id}")
  end

  defp item_struct(map \\ %{}) when is_map(map) do
    %{
      "cnt" => 0
    }
    |> Map.merge(map)
  end
end
