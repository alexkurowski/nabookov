# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :app,
  ecto_repos: [App.Repo]

# Configures the endpoint
config :app, App.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "d+3w2526kb/X9D/XlAN0SBjqwJt0b72C0FomFDTDwAzQWJO/aOOTEvYamqrymKae",
  render_errors: [view: App.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: App.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Use haml template engine
config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine

# Mailer configurations
config :app, App.Web.Mailer,
  adapter: Bamboo.LocalAdapter
  # server: "smtp.domain",
  # port: 1025,
  # username: SYSTEM.get_env("SMTP_USERNAME"),
  # password: SYSTEM.get_env("SMTP_PASSWORD"),
  # tls: :if_available, # can be `:always` or `:never`
  # ssl: false, # can be `true`
  # retries: 1
