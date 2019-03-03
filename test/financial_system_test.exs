defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  test "get value from account" do
    account1 = %FinancialSystem.Account{name: "This", email: "is", currency: "usd", value: FinancialSystem.FinHelpers.to_decimal(100)}
    show_value = FinancialSystem.get_value_in_account(account1)
    
    assert  show_value == account1.value
  end

  test "make deposit" do
    account1 = %FinancialSystem.Account{name: "This", email: "is", currency: "usd", value: FinancialSystem.FinHelpers.to_decimal(100)}

    deposit = FinancialSystem.deposit(account1, "USD", 10)
    new_value = Decimal.add(account1.value, 10) |> Decimal.round(2)

    account1 = %FinancialSystem.Account{name: "This", email: "is", currency: "usd", value: new_value}

    assert deposit.value == account1.value
  end

  test "make normal transfer" do
    account1 = %FinancialSystem.Account{name: "This", email: "is", currency: "usd", value: FinancialSystem.FinHelpers.to_decimal(100)}
    account2 = %FinancialSystem.Account{name: "Is", email: "this", currency: "usd", value: FinancialSystem.FinHelpers.to_decimal(100)}

    new_value = Decimal.add(account2.value, 50) |> Decimal.round(2)
    make_transfer = FinancialSystem.transfer(account1, account2, 50)

    account2 = %FinancialSystem.Account{name: "Is", email: "this", currency: "usd", value: new_value}

    assert make_transfer.value == account2.value
  end

end
