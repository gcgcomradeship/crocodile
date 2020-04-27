import EctoEnum

defenum(
  OrderStatus,
  unknown: 0,
  # - Принят;
  accept: 1,
  # - Обработка на складе;
  warehouse_processing: 2,
  # - Ожидает подтверждения;
  waiting_for_accept: 3,
  # - Товар забронирован;
  booked: 4,
  # - Готов к отгрузке;
  ready_to_shipment: 5,
  # - Выслан на почту;
  sent_by_mail: 6,
  # - Оплачен и доставлен;
  paid_and_delivered: 7,
  # - Отказ;
  canceled: 8,
  # - Комплектация товара на складе;
  picking_goods_in_stock: 9,
  # - Злонамеренный отказ;
  malicious_failure: 10,
  # - Отправлен с курьером;
  deliver_with_courier: 11,
  # - Отгружен. Ожидаем оплату;
  shipped_awaiting_payment: 12,
  # - Удален.
  deleted: 13
)

defenum(
  PaymentType,
  online: 0,
  on_delivery: 1
)

defenum(
  DeliveryType,
  pick_up: 0,
  post: 1,
  courier: 2
)

defenum(
  PaymentStatus,
  pending: 0,
  waiting_for_capture: 1,
  succeeded: 2,
  canceled: 3,
  refund: 4
)

defenum(
  DeliveryStatus,
  created: 0,
  in_progress: 1,
  complete: 5
)
