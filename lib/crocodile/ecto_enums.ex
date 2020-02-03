import EctoEnum

defenum(
  OrderStatus,
  created: 0,
  paid: 1,
  waiting_for_delivery: 2,
  completed: 3,
  canceled: 4,
  unknown: 5
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
  created: 0
)
