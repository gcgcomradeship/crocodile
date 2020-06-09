# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :crocodile,
  ecto_repos: [Crocodile.Repo]

# Configures the endpoint
config :crocodile, CrocodileWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  secret_key_base: "KBIgbqIMwM5i2upavQR7pFVhBKevVPnc6sJtBURjSRZsxQ9UHK+2ikTHwM5oLsZK",
  render_errors: [view: CrocodileWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Crocodile.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine

config :scrivener_html,
  routes_helper: CrocodileWeb.Router.Helpers

config :crocodile, :redis, url: System.get_env("REDIS_URL")

config :crocodile, :telegram,
  token: System.get_env("TELEGRAM_TOKEN"),
  proxy_ip: System.get_env("PROXY_IP"),
  proxy_port: System.get_env("PROXY_PORT"),
  proxy_user: System.get_env("PROXY_USER"),
  proxy_pass: System.get_env("PROXY_PASS"),
  webhook_token: System.get_env("WEBHOOK_TOKEN"),
  tgpass: System.get_env("TGPASS")

config :crocodile, :kassa,
  url: System.get_env("KASSA_URL"),
  id: System.get_env("KASSA_ID"),
  secret: System.get_env("KASSA_KEY")

config :crocodile, :delivery,
  url: System.get_env("DELIVERY_URL"),
  sdl: System.get_env("DELIVERY_SDL"),
  client_id: System.get_env("DELIVERY_CLIENT_ID"),
  sender_id: System.get_env("DELIVERY_SENDER_ID")

config :ex_aws,
  access_key_id: [System.get_env("MINIO_ACCESS") || "", :instance_role],
  secret_access_key: [System.get_env("MINIO_SECRET") || "", :instance_role],
  region: "us-east-1"

config :crocodile, Crocodile.Scheduler,
  jobs: [
    {"0 */2 * * *", {Crocodile.Services.Sync, :call, [:update]}},
    {"@daily", {Crocodile.Services.Sync, :call, []}}
  ]

config :crocodile, :remote, ps_api_key: System.get_env("PS_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
