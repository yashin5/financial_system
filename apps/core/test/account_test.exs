defmodule FinancialSystem.CoreTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.Accounts.AccountRepository

  setup :verify_on_exit!

  doctest FinancialSystem.Core.Account

  describe "create/3" do
    setup do
      account_struct = %FinancialSystem.Core.Accounts.Account{
        id: "abc",
        currency: "BRL",
        value: 100
      }

      account_struct2 = %FinancialSystem.Core.Accounts.Account{
        id: "abd",
        currency: "BRL",
        value: 10
      }

      account_struct3 = %FinancialSystem.Core.Accounts.Account{
        id: "adb",
        currency: "BRL",
        value: 0
      }

      on_exit(fn ->
        nil
      end)

      {:ok,
       [
         account_struct: account_struct,
         account_struct2: account_struct2,
         account_struct3: account_struct3
       ]}
    end

    test "Should be able to create a account with value number in string type", %{
      account_struct2: account_struct
    } do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create("Yashin Santos", "BRL", "0.10", "test@gmail.com", "f1aA678@")

      {_, account_data} = AccountRepository.find_account(account.id)

      account_simulate = %FinancialSystem.Core.Accounts.Account{
        id: "abd",
        currency: account_data.currency,
        value: account_data.value
      }

      assert account_simulate == account_struct
    end

    test "Should be able to create a account with low case currency", %{
      account_struct: account_struct
    } do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create("Oliver Tsubasa", "brl", "1", "test@gmail.com", "f1aA678@")

      {_, account_data} = AccountRepository.find_account(account.id)

      account_simulate = %FinancialSystem.Core.Accounts.Account{
        id: "abc",
        currency: account_data.currency,
        value: account_data.value
      }

      assert account_simulate == account_struct
    end

    test "Should be able to create a account with amount 0", %{
      account_struct3: account_struct
    } do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create("Inu Yasha", "brl", "0", "test@gmail.com", "f1aA678@")

      {_, account_data} = AccountRepository.find_account(account.id)

      account_simulate = %FinancialSystem.Core.Accounts.Account{
        id: "adb",
        currency: account_data.currency,
        value: account_data.value
      }

      assert account_simulate == account_struct
    end

    test "Not should be able to create a account with a name is not a string" do
      {:error, message} =
        FinancialSystem.Core.create(1, "brll", "0", "test@gmail.com", "f1aA678@")

      assert ^message = :invalid_name
    end

    test "Not should be able to create a account with a value less than 0" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:error, message} =
        FinancialSystem.Core.create("Oliver Tsubasa", "brl", "-1", "test@gmail.com", "f1aA678@")

      assert ^message = :invalid_value_less_than_0
    end

    test "Not should be able to create a account with a value in integer format" do
      {:error, message} =
        FinancialSystem.Core.create("Oliver Tsubasa", "brl", 10, "test@gmail.com", "f1aA678@")

      assert ^message = :invalid_value_type
    end

    test "Not should be able to create a account without a name" do
      {:error, message} = FinancialSystem.Core.create("", "BRL", 10, "test@gmail.com", "f1aA678@")

      assert ^message = :invalid_value_type
    end

    test "Not should be able to create a account with a value in float format" do
      {:error, message} =
        FinancialSystem.Core.create("Oliver Tsubasa", "brl", 10.0, "test@gmail.com", "f1aA678@")

      assert ^message = :invalid_value_type
    end

    test "Not should be able to create a account with a invalid currency" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:error, message} =
        FinancialSystem.Core.create("Oliver Tsubasa", "brll", "0", "test@gmail.com", "f1aA678@")

      assert ^message = :currency_is_not_valid
    end
  end

  describe "delete/1" do
    test "Should be able to delete an account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create("Oliver Tsubasa", "brl", "1", "test@gmail.com", "f1aA678@")

      {:ok, message} = FinancialSystem.Core.delete(account.id)

      assert ^message = :account_deleted
    end

    test "Not should be able to delete if insert id different from type string" do
      {:error, message} = FinancialSystem.Core.delete(1.1)

      assert ^message = :invalid_account_id_type
    end

    test "Not should be able to delete an inexistent account" do
      {:error, message} = FinancialSystem.Core.delete(UUID.uuid4())

      assert ^message = :account_dont_exist
    end
  end
end
