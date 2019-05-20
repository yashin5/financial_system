# FIXME: Remove CurrencyRequest behaviour
Mox.defmock(CurrencyRequestMock,
  for: FinancialSystem.Currency.CurrencyRequest
)

Mox.defmock(CurrencyMock,
  for: FinancialSystem.Currency.CurrencyBehaviour
)
