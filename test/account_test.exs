defmodule FinancialSystemTest do
  use ExUnit.Case, async: true

  import Mox
  setup :verify_on_exit!

  doctest FinancialSystem.Account

  describe "create/3" do
    setup do
      account_struct = %FinancialSystem.Account{
        account_id: "abc",
        name: "Oliver Tsubasa",
        currency: "BRL",
        value: 100
      }

      account_struct2 = %FinancialSystem.Account{
        account_id: "abd",
        name: "Yashin Santos",
        currency: "BRL",
        value: 10
      }

      account_struct3 = %FinancialSystem.Account{
        account_id: "adb",
        name: "Inu Yasha",
        currency: "BRL",
        value: 0
      }

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

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "0.10")
      account_data = FinancialSystem.AccountState.show(account.account_id)

      account_simulate = %FinancialSystem.Account{
        account_id: "abd",
        name: account_data.name,
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

      {_, account} = FinancialSystem.create("Oliver Tsubasa", "brl", "1")
      account_data = FinancialSystem.AccountState.show(account.account_id)

      account_simulate = %FinancialSystem.Account{
        account_id: "abc",
        name: account_data.name,
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

      {_, account} = FinancialSystem.create("Inu Yasha", "brl", "0")

      account_data = FinancialSystem.AccountState.show(account.account_id)

      account_simulate = %FinancialSystem.Account{
        account_id: "adb",
        name: account_data.name,
        currency: account_data.currency,
        value: account_data.value
      }

      assert account_simulate == account_struct
    end

    test "Not should be able to create a account with a name is not a string" do
      {:error, message} = FinancialSystem.create(1, "brll", "0")

      assert ^message =
               "First and second args must be a string and third arg must be a number in type string greater than 0."
    end

    test "Not should be able to create a account with a value less than 0" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brl", "-1")

      assert ^message = "The value must be greater or equal to 0."
    end

    test "Not should be able to create a account with a value in integer format" do
      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brl", 10)

      assert ^message =
               "First and second args must be a string and third arg must be a number in type string greater than 0."
    end

    test "Not should be able to create a account without a name" do
      {:error, message} = FinancialSystem.create("", "BRL", 10)

      assert ^message =
               "First and second args must be a string and third arg must be a number in type string greater than 0."
    end

    test "Not should be able to create a account with a value in float format" do
      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brl", 10.0)

      assert ^message =
               "First and second args must be a string and third arg must be a number in type string greater than 0."
    end

    test "Not should be able to create a account with a invalid currency" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brll", "0")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end
  end
end
