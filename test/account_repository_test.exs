defmodule FinancialSystem.AccountRepositoryTest do
  use FinancialSystem.DataCase, async: true

  import Mox

  alias FinancialSystem.Accounts.AccountRepository

  setup :verify_on_exit!

  doctest FinancialSystem.Accounts.AccountRepository

  describe "register_account/1" do
    test "Should be able to registry a account into system" do
      {:ok, account} =
        %FinancialSystem.Accounts.Account{
          active: true,
          name: "Yashin Santos",
          currency: "BRL",
          value: 100,
          id: UUID.uuid4()
        }
        |> AccountRepository.register_account()

      {_, account_actual_state} = AccountRepository.find_account(account.id)

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

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      {:ok, message} = AccountRepository.delete_account(account)

      assert ^message = :account_deleted
    end

    test "Not should be able to delete if the id dont be in string type" do
      {:error, message} = AccountRepository.delete_account(1)

      assert ^message = :invalid_account_type
    end
  end

  describe "find_account/1" do
    test "Should be able to verify if an account has deleted" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      {:ok, _} = AccountRepository.delete_account(account)

      {:error, message} = AccountRepository.find_account(account.id)

      assert ^message = :account_dont_exist
    end
  end
end