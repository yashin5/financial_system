defmodule AccountStateTest do
  use ExUnit.Case
  doctest FinancialSystem.AccountState

  describe "handle_call/1" do
    setup do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)
      struct = %FinancialSystem.Account{name: "Yashin Santo", currency: "BRL", value: 100}

      on_exit(fn ->
        nil
      end)

      {:ok, [account: pid, struct: struct]}
    end

    test "User should be able to show a actual state", %{account: pid} do
      assert struct = GenServer.call(pid, :get_data)
    end
  end

  describe "handle_cast/2" do
    setup do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)
      struct = %FinancialSystem.Account{name: "Yashin Santo", currency: "BRL", value: 100}

      on_exit(fn ->
        nil
      end)

      {:ok, [account: pid, struct: struct]}
    end

    test "User should be able to add a integer value to an account", %{account: pid} do
      GenServer.cast(pid, {:deposit, 1})
      assert GenServer.call(pid, :get_data).value == 101
    end

    test "User should be able to subtract a value to an account", %{account: pid} do
      GenServer.cast(pid, {:withdraw, 1})
      assert GenServer.call(pid, :get_data).value == 99
    end
  end

  describe "show/1" do
    test "User should be able to see the account state" do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)
      struct = %FinancialSystem.Account{name: "Yashin Santos", currency: "BRL", value: 100}

      assert FinancialSystem.AccountState.show(pid) == struct
    end
  end

  describe "withdraw/2" do
    test "User should be able to subtract a value from account" do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)

      FinancialSystem.AccountState.withdraw(pid, 1)
      assert FinancialSystem.AccountState.show(pid).value == 99
    end
  end

  describe "deposit/2" do
    test "User should be able to subtract a value from account" do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)

      FinancialSystem.AccountState.deposit(pid, 1)
      assert FinancialSystem.AccountState.show(pid).value == 101
    end
  end
end
