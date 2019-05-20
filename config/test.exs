use Mix.Config

config :financial_system, :currency_request, CurrencyRequestMock

config :financial_system, FinancialSystem.FinancialOperations,


  currency_finder: FinancialSystem.Currency.CurrencyImpl
