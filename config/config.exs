# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :finder,
  ecto_repos: [Finder.Repo]

# Configures the endpoint
config :finder, FinderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kk/27dJ4i+CVhghtipWOppxGg3G/JR9bUNSwABB0cWP3rmMn4TDvDVQRHlLcNNAL",
  render_errors: [view: FinderWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Finder.PubSub,
  live_view: [signing_salt: "6NrJc2Hr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :finder, Finder.Guardian,
  issuer: "finder",
  secret_key: "mrZTowKXaSvY6QgWHkFxeXXNWnF4ptzQex8COj4zqWnA0dogSR98oCX8/3u/wDj+"
