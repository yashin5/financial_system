defmodule SplitListTest do
  use ExUnit.Case
  doctest FinancialSystem.SplitList

  test "create a struct for make split transfer" do
    account2 = %FinancialSystem.Account{
      name: "Is",
      email: "this",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }

    account3 = %FinancialSystem.Account{
      name: "Whole",
      email: "lotta",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }

    account4 = %FinancialSystem.Account{
      name: "Welcome",
      email: "to",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }

    account5 = %FinancialSystem.Account{
      name: "Dakishimeta",
      email: "kokoro",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }

    assert [
      %FinancialSystem.SplitList{account: account2, percent: 10},
      %FinancialSystem.SplitList{account: account2, percent: 10},
      %FinancialSystem.SplitList{account: account3, percent: 30},
      %FinancialSystem.SplitList{account: account4, percent: 40},
      %FinancialSystem.SplitList{account: account5, percent: 10}
    ]
  end
end
