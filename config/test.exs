use Mix.Config

config :financial_system, :currency_finder, CurrencyMock

config :financial_system, FinancialSystem.Repo,
  database: "account_repository",
  username: "ysantos",
  password: "@dmin123",
  hostname: "localhost"
