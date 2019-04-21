defmodule AccountStateTest do
  use ExUnit.Case
  doctest FinancialSystem.AccountState

  test "User should be able add a value to an account" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 20)
    assert GenServer.cast(pid, {:deposit, 1})

    assert GenServer.call(pid, :get_data).value == 21

    {:ok, pid2} = FinancialSystem.create("Oliver Tsubasa", "USD", 30)
    assert GenServer.cast(pid2, {:deposit, 1})

    assert GenServer.call(pid2, :get_data).value == 31
  end

  test "User should be able subtracts a value to an account" do
    {:ok, pid} = FinancialSystem.create("Yashin Santos", "BRL", 20)
    assert GenServer.cast(pid, {:withdraw, 1})

    assert GenServer.call(pid, :get_data).value == 19

    {:ok, pid2} = FinancialSystem.create("Oliver Tsubasa", "USD", 30)

    assert GenServer.cast(pid2, {:withdraw, 1})

    assert GenServer.call(pid2, :get_data).value == 29
  end
end
