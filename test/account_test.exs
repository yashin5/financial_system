defmodule AccountTest do
  use ExUnit.Case
  doctest FinancialSystem.Account

  test "create a struct for user account" do
    assert %FinancialSystem.Account{
      name: "This",
      email: "is",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }
  end
end
