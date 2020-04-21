defmodule CrocodileWeb.Admin.OrderView do
  use CrocodileWeb, :view

  def get_statuses() do
    OrderStatus.__enum_map__() |> Enum.map(fn {k, _} -> {t("#{k}"), "#{k}"} end)
  end

  def get_payment_types() do
    PaymentType.__enum_map__() |> Enum.map(fn {k, _} -> {t("#{k}"), "#{k}"} end)
  end

  def get_payment_statuses() do
    PaymentStatus.__enum_map__() |> Enum.map(fn {k, _} -> {t("#{k}"), "#{k}"} end)
  end

  def get_delivery_types() do
    DeliveryType.__enum_map__() |> Enum.map(fn {k, _} -> {t("#{k}"), "#{k}"} end)
  end

  def get_delivery_statuses() do
    DeliveryStatus.__enum_map__() |> Enum.map(fn {k, _} -> {t("#{k}"), "#{k}"} end)
  end
end
