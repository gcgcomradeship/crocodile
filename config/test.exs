use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :crocodile, CrocodileWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :crocodile, Crocodile.Repo,
  username: "postgres",
  password: "postgres",
  database: "crocodile_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
