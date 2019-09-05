defmodule AccountOperationsTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.AccountOperations
  alias FinancialSystem.Core.Accounts.AccountRepository

  setup :verify_on_exit!

  doctest FinancialSystem.Core.AccountOperations

  describe "subtract_value_in_balance/3" do
    test "Should be able to subtract a value from account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmail.com",
          "password" => "f1aA678@"
        })

      AccountOperations.subtract_value_in_balance(account, 1, "withdraw")

      {_, account_state} = AccountRepository.find_account(account.id)
      value = account_state.value

      assert value == 99
    end
  end

  describe "sum_value_in_balance/3" do
    test "Should be able to subtract a value from account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmail.com",
          "password" => "f1aA678@"
        })

      AccountOperations.sum_value_in_balance(account, 1, "deposit")

      {_, account_state} = AccountRepository.find_account(account.id)
      value = account_state.value

      assert value == 101
    end
  end
end
