use Mix.Config

config :core, :currency_finder, CurrencyMock

config :api, ApiWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :info

config :core, FinancialSystem.Core.Repo, pool: Ecto.Adapters.SQL.Sandbox
