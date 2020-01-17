defmodule Crocodile.Services.Cart do
  use CrocodileWeb, :services

  def add(session_id, product_id, count \\ 1) when count >= 0 do
    cart = get(session_id)
    product = Map.get(cart, "#{product_id}") || product_struct()
    new_product = Map.put(product, "cnt", product["cnt"] + count)
    new_cart = Map.put(cart, "#{product_id}", new_product)

    case Redis.set("cart/#{session_id}", Jason.encode!(new_cart)) do
      "OK" -> new_cart
      _ -> {:error, "Something was wrong"}
    end
  end

  def set(session_id, product_id, count) when count > 0 do
    cart = get(session_id)
    product = Map.get(cart, "#{product_id}") || product_struct()
    new_product = Map.put(product, "cnt", count)
    new_cart = Map.put(cart, "#{product_id}", new_product)

    case Redis.set("cart/#{session_id}", Jason.encode!(new_cart)) do
      "OK" -> new_cart
      _ -> {:error, "Something was wrong"}
    end
  end

  def remove(session_id, product_id) do
    cart = get(session_id)
    new_cart = Map.delete(cart, "#{product_id}")

    case Redis.set("cart/#{session_id}", Jason.encode!(new_cart)) do
      "OK" -> new_cart
      _ -> {:error, "Something was wrong"}
    end
  end

  def remove(session_id, product_id, count) do
    cart = get(session_id)
    product = Map.get(cart, "#{product_id}") || product_struct()

    case product["cnt"] - count do
      res when res > 0 ->
        new_product = Map.put(product, "cnt", res)
        new_cart = Map.put(cart, "#{product_id}", new_product)

        Redis.set("cart/#{session_id}", Jason.encode!(new_cart))
        new_cart

      0 ->
        new_cart = Map.delete(cart, "#{product_id}")

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

  defp product_struct(map \\ %{}) when is_map(map) do
    %{
      "cnt" => 0
    }
    |> Map.merge(map)
  end
end
