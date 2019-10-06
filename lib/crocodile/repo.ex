defmodule Crocodile.Repo do
  use Ecto.Repo,
    otp_app: :crocodile,
    adapter: Ecto.Adapters.Postgres
end
