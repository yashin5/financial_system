defmodule FinancialSystemTest do
  use ExUnit.Case, async: true

  import Mox

  alias Ecto.Adapters.SQL.Sandbox

  setup :verify_on_exit!

  doctest FinancialSystem.Account

  describe "create/3" do
    setup do
      :ok = Sandbox.checkout(FinancialSystem.Repo)

      account_struct = %FinancialSystem.Accounts.Account{
        id: "abc",
        name: "Oliver Tsubasa",
        currency: "BRL",
        value: 100
      }

      account_struct2 = %FinancialSystem.Accounts.Account{
        id: "abd",
        name: "Yashin Santos",
        currency: "BRL",
        value: 10
      }

      account_struct3 = %FinancialSystem.Accounts.Account{
        id: "adb",
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
      {_, account_data} = FinancialSystem.AccountOperations.account_exist(account.id)

      account_simulate = %FinancialSystem.Accounts.Account{
        id: "abd",
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
      {_, account_data} = FinancialSystem.AccountOperations.account_exist(account.id)

      account_simulate = %FinancialSystem.Accounts.Account{
        id: "abc",
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

      {_, account_data} = FinancialSystem.AccountOperations.account_exist(account.id)

      account_simulate = %FinancialSystem.Accounts.Account{
        id: "adb",
        name: account_data.name,
        currency: account_data.currency,
        value: account_data.value
      }

      assert account_simulate == account_struct
    end

    test "Not should be able to create a account with a name is not a string" do
      {:error, message} = FinancialSystem.create(1, "brll", "0")

      assert ^message = :invalid_name
    end

    test "Not should be able to create a account with a value less than 0" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brl", "-1")

      assert ^message = :invalid_value_less_than_0
    end

    test "Not should be able to create a account with a value in integer format" do
      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brl", 10)

      assert ^message = :invalid_value_type
    end

    test "Not should be able to create a account without a name" do
      {:error, message} = FinancialSystem.create("", "BRL", 10)

      assert ^message = :invalid_value_type
    end

    test "Not should be able to create a account with a value in float format" do
      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brl", 10.0)

      assert ^message = :invalid_value_type
    end

    test "Not should be able to create a account with a invalid currency" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brll", "0")

      assert ^message = :currency_is_not_valid
    end
  end

  describe "delete/1" do
    setup do
      :ok = Sandbox.checkout(FinancialSystem.Repo)
    end

    test "Should be able to delete an account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Oliver Tsubasa", "brl", "1")

      {:ok, message} = FinancialSystem.delete(account.id)

      assert ^message = :account_deleted
    end

    test "Not should be able to delete if insert id different from type string" do
      {:error, message} = FinancialSystem.delete(1.1)

      assert ^message = :invalid_account_id_type
    end

    test "Not should be able to delete an inexistent account" do
      {:error, message} = FinancialSystem.delete(UUID.uuid4())

      assert ^message = :account_dont_exist
    end
  end
end
