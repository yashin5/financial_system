defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  test "make deposit" do
    account1 = %FinancialSystem.Account{name: "This", email: "is", currency: "usd", value: FinancialSystem.FinHelpers.to_decimal(100)}
    deposit = FinancialSystem.deposit(account1, "USD", 10)
    new_value = Decimal.add(account1.value, 10) |> Decimal.round(2)
    account1 = %FinancialSystem.Account{name: "This", email: "is", currency: "usd", value: new_value}

    assert deposit.value == account1.value
  end
end
