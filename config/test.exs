use Mix.Config

config :financial_system, :currency_finder, CurrencyMock

config :logger, level: :info

config :financial_system, FinancialSystem.Repo, pool: Ecto.Adapters.SQL.Sandbox
