defmodule FinHelperTest do
  use ExUnit.Case
  doctest FinancialSystem.FinHelper

  test "User should be able transform the value in decimal, rounding it based on currency" do
    {:ok, pid2} = FinancialSystem.create("Roberta Santos", "EUR", 20.0)

    assert FinancialSystem.FinHelper.to_decimal(10.0, "BRL")

    assert GenServer.call(pid2, :get_data).value |> Decimal.from_float() |> Decimal.round(2) ==
             FinancialSystem.FinHelper.to_decimal(GenServer.call(pid2, :get_data).value, "BRL")

    {:ok, pid} = FinancialSystem.create("Yashin Santos", "EUR", 10.0)

    assert FinancialSystem.FinHelper.to_decimal(10, "BRL")

    assert GenServer.call(pid, :get_data).value |> Decimal.from_float() |> Decimal.round(2) ==
             FinancialSystem.FinHelper.to_decimal(GenServer.call(pid, :get_data).value, "BRL")
  end

  test "User should be able to verify if the account have de funds necessary for the transaction" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "EUR", 10.0)
    assert FinancialSystem.FinHelper.funds(pid, 10)

    {:ok, pid} = FinancialSystem.create("Yashin Santos", "EUR", 10)
    assert FinancialSystem.FinHelper.funds(pid, 10.0)
  end

  test "User should be able to verify if in split list have the same account is sending the value" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 20)
    {:ok, pid2} = FinancialSystem.create("Oliver Tsubasa", "USD", 30)
    {:ok, pid3} = FinancialSystem.create("Roberta Santos", "EUR", 20)

    split_list = [
      %FinancialSystem.Split{account: pid2, percent: 80},
      %FinancialSystem.Split{account: pid3, percent: 20}
    ]

    assert FinancialSystem.FinHelper.split_list_have_account_from(pid, split_list) == false
  end

  test "User should be able to verify if in split list the total percent is 100" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 20)
    {:ok, pid2} = FinancialSystem.create("Oliver Tsubasa", "USD", 30)

    split_list = [
      %FinancialSystem.Split{account: pid, percent: 80},
      %FinancialSystem.Split{account: pid2, percent: 20}
    ]

    assert true = FinancialSystem.FinHelper.percent_ok?(split_list)
  end

  test "User should be able to verify if have a duplicated account in split list and unity it." do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 20)

    split_list = [
      %FinancialSystem.Split{account: pid, percent: 80},
      %FinancialSystem.Split{account: pid, percent: 20}
    ]

    assert [%FinancialSystem.Split{account: pid, percent: 100}] =
             FinancialSystem.FinHelper.unite_equal_account_split(split_list)
  end
end
