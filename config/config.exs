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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
