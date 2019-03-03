defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  test "get value from account" do
    account1 = %FinancialSystem.Account{
      name: "This",
      email: "is",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }

    show_value = FinancialSystem.get_value_in_account(account1)

    assert show_value == account1.value
  end

  test "make deposit" do
    account1 = %FinancialSystem.Account{
      name: "This",
      email: "is",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }

    deposit = FinancialSystem.deposit(account1, "USD", 10)
    new_value = Decimal.add(account1.value, 10) |> Decimal.round(2)

    account1 = %FinancialSystem.Account{
      name: "This",
      email: "is",
      currency: "usd",
      value: new_value
    }

    assert deposit.value == account1.value
  end

  test "make normal transfer" do
    account1 = %FinancialSystem.Account{
      name: "This",
      email: "is",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }

    account2 = %FinancialSystem.Account{
      name: "Is",
      email: "this",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }

    new_value = Decimal.add(account2.value, 50) |> Decimal.round(2)
    make_transfer = FinancialSystem.transfer(account1, account2, 50)

    account2 = %FinancialSystem.Account{
      name: "Is",
      email: "this",
      currency: "usd",
      value: new_value
    }

    assert make_transfer.value == account2.value
  end

  test "make split transfer" do
    account1 = %FinancialSystem.Account{
      name: "This",
      email: "is",
      currency: "usd",
      value: FinancialSystem.FinHelpers.to_decimal(100)
    }

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

    list_to = [
      %FinancialSystem.SplitList{account: account2, percent: 10},
      %FinancialSystem.SplitList{account: account2, percent: 10},
      %FinancialSystem.SplitList{account: account3, percent: 30},
      %FinancialSystem.SplitList{account: account4, percent: 40},
      %FinancialSystem.SplitList{account: account5, percent: 10}
    ]

    split_transfer = FinancialSystem.split(account1, list_to, 100)

    assert is_list(split_transfer)
  end

  test "treat the error in split transfer" do
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

    list_to = [
      %FinancialSystem.SplitList{account: account2, percent: 10},
      %FinancialSystem.SplitList{account: account2, percent: 10},
      %FinancialSystem.SplitList{account: account3, percent: 80}
    ]

    map_split = FinancialSystem.map_split(list_to, 100, "usd")
    assert is_list(map_split)
  end

  test "make the division of value" do
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

    list_to = [
      %FinancialSystem.SplitList{account: account2, percent: 10},
      %FinancialSystem.SplitList{account: account2, percent: 10},
      %FinancialSystem.SplitList{account: account3, percent: 80}
    ]

    do_split = FinancialSystem.do_split(list_to, 100, "usd")
    assert is_list(do_split)
  end

  test "check if have a same account in from and to list" do
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

    list_to = [
      %FinancialSystem.SplitList{account: account2, percent: 10},
      %FinancialSystem.SplitList{account: account3, percent: 90}
    ]
    list_to_ok = FinancialSystem.list_to_ok?("lotta", list_to)

    assert list_to_ok == true
  end
end
