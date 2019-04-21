defmodule AccountTest do
  use ExUnit.Case
  doctest FinancialSystem

  test "User should be able to create a account" do
    assert {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 10)
    assert GenServer.call(pid, :get_data)

    assert {:ok, pid2} = FinancialSystem.create("Roberta Santos", "EUR", 20)
    assert GenServer.call(pid2, :get_data)

    assert {:ok, pid3} = FinancialSystem.create("Oliver Tsubasa", "USD", 30)
    assert GenServer.call(pid3, :get_data)
  end

  test "User should be able to show the value in account" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 10)

    assert FinancialSystem.show(pid)
  end

  test "User should be able to deposit a value in account" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 10)

    assert FinancialSystem.deposit(pid, "USD", 1)
    assert GenServer.call(pid, :get_data).value == 13.702199
    assert FinancialSystem.deposit(pid, "EUR", 1.0)
    assert GenServer.call(pid, :get_data).value == 18.071627157338167
  end

  test "User should be able to withdraw a value of a account" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 10)

    assert FinancialSystem.withdraw(pid, 1)
    assert GenServer.call(pid, :get_data).value == 9
    assert FinancialSystem.withdraw(pid, 1.5)
    assert GenServer.call(pid, :get_data).value == 7.5
  end

  test "User should be able to  transfer value between  accounts" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 10)
    {:ok, pid2} = FinancialSystem.create("Oliver Tsubasa", "USD", 30)

    assert FinancialSystem.transfer(10, pid2, pid)
    assert GenServer.call(pid2, :get_data).value == 20
    assert GenServer.call(pid, :get_data).value == 47.021989999999995

    assert FinancialSystem.transfer(5, pid2, pid)
    assert GenServer.call(pid2, :get_data).value == 15
    assert GenServer.call(pid, :get_data).value == 65.532985
  end

  test "User should be able to transfer a value between  multiple accounts" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 20)
    {:ok, pid2} = FinancialSystem.create("Oliver Tsubasa", "USD", 30)
    {:ok, pid3} = FinancialSystem.create("Roberta Santos", "EUR", 20)

    split_list = [
      %FinancialSystem.Split{account: pid2, percent: 80},
      %FinancialSystem.Split{account: pid3, percent: 20}
    ]

    assert FinancialSystem.split(pid, split_list, 10)
    assert GenServer.call(pid, :get_data).value == 10
    assert GenServer.call(pid2, :get_data).value == 32.160877899864374
    assert GenServer.call(pid3, :get_data).value == 20.45772580026087

    assert FinancialSystem.split(pid, split_list, 1)
    assert GenServer.call(pid, :get_data).value == 9
    assert GenServer.call(pid2, :get_data).value == 32.37696568985081
    assert GenServer.call(pid3, :get_data).value == 20.50349838028696
  end
end
