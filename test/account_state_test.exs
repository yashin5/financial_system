defmodule AccountStateTest do
  use ExUnit.Case, async: true

  import Mox
  setup :verify_on_exit!

  doctest FinancialSystem.AccountState

  describe "show/1" do
    test "Should be able to see the account state" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      actual_state = FinancialSystem.AccountState.show(account.id)

      account_id_when_created = account.id
      actual_id = actual_state.id

      assert actual_id == account_id_when_created
    end
  end

  describe "withdraw/2" do
    test "Should be able to subtract a value from account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      FinancialSystem.AccountState.withdraw(account.id, 1)

      value = FinancialSystem.AccountState.show(account.id).value

      assert value == 99
    end
  end

  describe "deposit/2" do
    test "Should be able to subtract a value from account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      FinancialSystem.AccountState.deposit(account.id, 1)

      value = FinancialSystem.AccountState.show(account.id).value

      assert value == 101
    end
  end
end
