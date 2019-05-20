# FIXME: Remove CurrencyRequest behaviour
Mox.defmock(CurrencyRequestMock,
  for: FinancialSystem.Currency.CurrencyRequest
)
|> IO.puts()

Mox.defmock(CurrencyMock,
  for: FinancialSystem.Currency.CurrencyBehaviour
)
|> IO.puts()
