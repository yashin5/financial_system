defmodule AccountStateTest do
  use ExUnit.Case

  import Mox
  setup :verify_on_exit!

  doctest FinancialSystem.AccountState

  describe "handle_call/1" do
    test "Should be able to show a actual state" do
      expect(CurrencyRequestMock, :load_from_config, 4, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      actual_state = GenServer.call(:register_account, :get_data)[account.account_id]

      account_struct = %FinancialSystem.Account{
        account_id: account.account_id,
        name: "Yashin Santos",
        currency: "BRL",
        value: 100
      }

      assert account_struct == actual_state
    end
  end

  describe "handle_cast/2" do
    setup do
      expect(CurrencyRequestMock, :load_from_config, 4, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      on_exit(fn ->
        nil
      end)

      {:ok, [account_id: account.account_id]}
    end

    test "Should be able to add a integer value to an account", %{account_id: account} do
      GenServer.cast(:register_account, {:deposit, account, 1})
      value = GenServer.call(:register_account, :get_data)[account].value

      assert value == 101
    end

    test "Should be able to subtract a value to an account", %{account_id: account} do
      GenServer.cast(:register_account, {:withdraw, account, 1})
      value = GenServer.call(:register_account, :get_data)[account].value

      assert value == 99
    end
  end

  describe "show/1" do
    test "Should be able to see the account state" do
      expect(CurrencyRequestMock, :load_from_config, 4, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      actual_state = FinancialSystem.AccountState.show(account.account_id)

      account_struct = %FinancialSystem.Account{
        account_id: account.account_id,
        name: account.name,
        currency: account.currency,
        value: account.value
      }

      assert actual_state == account_struct
    end
  end

  describe "withdraw/2" do
    test "Should be able to subtract a value from account" do
      expect(CurrencyRequestMock, :load_from_config, 4, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      FinancialSystem.AccountState.withdraw(account.account_id, 1)

      value = FinancialSystem.AccountState.show(account.account_id).value

      assert value == 99
    end
  end

  describe "deposit/2" do
    test "Should be able to subtract a value from account" do
      expect(CurrencyRequestMock, :load_from_config, 4, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      FinancialSystem.AccountState.deposit(account.account_id, 1)

      value = FinancialSystem.AccountState.show(account.account_id).value

      assert value == 101
    end
  end
end
