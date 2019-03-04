defmodule FinHelpersTest do
  use ExUnit.Case
  doctest FinancialSystem.FinHelpers

  test "make a withdrawal from account" do
    account1 = FinancialSystem.CreateAccount.create_user("This", "is", "BRL", 100)
    subtract_value = FinancialSystem.FinHelpers.subtracts_value(account1, account1.value, 50)

    assert subtract_value.value < account1.value
  end

  test "make value add to account" do
    account1 = FinancialSystem.CreateAccount.create_user("This", "is", "BRL", 100)

    add_value =
      FinancialSystem.FinHelpers.add_value(account1, account1.value, "USD", account1.currency, 50)

    assert add_value.value > account1.value
  end

  test "transform number integer or float to decimal" do
    to_decimal_integer = FinancialSystem.FinHelpers.to_decimal(10)
    to_decimal_float = FinancialSystem.FinHelpers.to_decimal(10.0)
    decimal_test = Decimal.add(10, 0) |> Decimal.round(1)

    assert to_decimal_integer == decimal_test and to_decimal_float == decimal_test
  end
end
