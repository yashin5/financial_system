defmodule AccountOperationsTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.AccountOperations

  setup :verify_on_exit!

  doctest FinancialSystem.Core.AccountOperations

  describe "register_account/1" do
    test "Should be able to registry a account into system" do
      {:ok, account} =
        %FinancialSystem.Core.Accounts.Account{
          name: "Yashin Santos",
          currency: "BRL",
          value: 100,
          id: UUID.uuid4()
        }
        |> AccountRepository.register_account()

      {_, account_actual_state} = AccountOperations.find_account(account.id)

      assert account_actual_state == account
    end

    test "Not should be able to registry if the arg not be a %Account struct" do
      {:error, message} = AccountRepository.register_account("error")

      assert ^message = :invalid_arguments_type
    end
  end

  describe "delete/1" do
    test "Should be able to delete an account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.Core.create("Yashin Santos", "BRL", "1")

      {:ok, message} = AccountRepository.delete_account(account)

      assert ^message = :account_deleted
    end

    test "Not should be able to delete if the id dont be in string type" do
      {:error, message} = AccountRepository.delete_account(1)

      assert ^message = :invalid_account_type
    end
  end

  describe "subtract_value_in_balance/3" do
    test "Should be able to subtract a value from account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.Core.create("Yashin Santos", "BRL", "1")

      AccountOperations.subtract_value_in_balance(account, 1, "withdraw")

      {_, account_state} = AccountOperations.find_account(account.id)
      value = account_state.value

      assert value == 99
    end
  end

  describe "sum_value_in_balance/3" do
    test "Should be able to subtract a value from account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.Core.create("Yashin Santos", "BRL", "1")

      AccountOperations.sum_value_in_balance(account, 1, "deposit")

      {_, account_state} = AccountOperations.find_account(account.id)
      value = account_state.value

      assert value == 101
    end
  end
end
