use Mix.Config

config :core, :currency_finder, CurrencyMock

config :logger, level: :info

config :core, FinancialSystem.Core.Repo, pool: Ecto.Adapters.SQL.Sandbox
