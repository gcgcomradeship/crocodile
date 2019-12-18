defmodule Crocodile.Repo do
  use Ecto.Repo,
    otp_app: :crocodile,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 24
end
