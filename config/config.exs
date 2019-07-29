# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :core, file: "/currency_rate.json"

config :core, :currency_finder, FinancialSystem.Core.Currency.CurrencyImpl

config :core, FinancialSystem.Core.Repo,
  database: System.get_env("DB_NAME") || "account_repository_dev",
  username: System.get_env("DB_USER") || "ysantos",
  password: System.get_env("DB_PASSWORD") || "@dmin123",
  hostname: System.get_env("DB_HOST") || "localhost"

config :core, ecto_repos: [FinancialSystem.Core.Repo]

config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aPUV/iswxDaO5NRbuHdywNgWqz1cJM7GlovB1fc6QO6PQIS/nWYHZZ4w4WMQjs1k",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Api.PubSub, adapter: Phoenix.PubSub.PG2]

  # Configures Elixir's Logger
config :logger, :console,
format: "$time $metadata[$level] $message\n",
metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :financial_system, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:financial_system, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).

import_config "#{Mix.env()}.exs"
