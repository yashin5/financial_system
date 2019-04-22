defmodule CurrencyTest do
  use ExUnit.Case
  doctest FinancialSystem.Currency

  test "User should be able to verify if the currency exist." do
    assert FinancialSystem.Currency.currency_is_valid("brl")
    assert {:ok, "BRL"} = FinancialSystem.Currency.currency_is_valid("brl")
  end

  test "User should be able to convert the values based on currency." do
    assert FinancialSystem.Currency.convert("USD", "BRL", 1)
    assert FinancialSystem.Currency.convert("USD", "BRL", 1) == 3.702199
    assert FinancialSystem.Currency.convert("EUR", "USD", 1) == 1.1802250925296471
  end
end
