defmodule FinHelperTest do
  use ExUnit.Case, async: true

  import Mox

  alias Ecto.Adapters.SQL.Sandbox
  alias FinancialSystem.FinHelper

  setup :verify_on_exit!

  doctest FinancialSystem.FinHelper

  describe "funds/2" do
    setup do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      :ok = Sandbox.checkout(FinancialSystem.Repo)

      {_, account} = FinancialSystem.create("Roberta Santos", "BRL", "20.0")

      {:ok, [account_id: account]}
    end

    test "Should be able to verify if the account have de funds necessary for the transaction inserting a integer value",
         %{account_id: account} do
      assert {:ok, true} = FinancialSystem.FinHelper.funds(account, 10)
    end

    test "Should be able to verify if the account have de funds necessary for the transaction inserting a float value",
         %{account_id: account} do
      assert {:ok, true} = FinancialSystem.FinHelper.funds(account, 20.0)
    end

    test "Not should be able to verify when inserting a string in value", %{account_id: account} do
      {:error, message} = FinHelper.funds(account, "10")

<<<<<<< HEAD
      assert ^message = :invalid_account_id_type
=======
      assert ^message = :invalid_value_type
>>>>>>> api/updates
    end

    test "Not should be able to verify when inserting a invalid account id" do
      {:error, message} = FinHelper.funds("account id", 10)

<<<<<<< HEAD
      assert ^message = :invalid_value_type
=======
      assert ^message = :invalid_account_type
>>>>>>> api/updates
    end
  end

  describe "transfer_have_account_from/2" do
    setup do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      :ok = Sandbox.checkout(FinancialSystem.Repo)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      {_, account2} = FinancialSystem.create("Oliver Tsubasa", "BRL", "2")
      {_, account3} = FinancialSystem.create("Inu Yasha", "BRL", "5")

      list_to = [
        %FinancialSystem.Split{account: account.id, percent: 20},
        %FinancialSystem.Split{account: account3.id, percent: 80}
      ]

      {:ok,
       [
         account_id: account.id,
         account2_id: account2.id,
         account3_id: account3.id,
         list: list_to
       ]}
    end

    test "Should be able to verify if in split list not have the same account is sending the value",
         %{account2_id: account, list: split_list} do
      assert {:ok, true} = FinHelper.transfer_have_account_from(account, split_list)
    end

    test "Should be able to verify if in transfer not have the same account is sending the value",
         %{account2_id: account2, account_id: account} do
      assert {:ok, true} = FinHelper.transfer_have_account_from(account, account2)
    end

    test "Should be able to verify if in transfer have the same account is sending the value",
         %{account_id: account} do
      {:error, message} = FinHelper.transfer_have_account_from(account, account)

      assert ^message = :cannot_send_to_the_same
    end

    test "Should be able to verify if in split list have the same account is sending the value",
         %{account_id: account, list: split_list} do
      {:error, message} = FinHelper.transfer_have_account_from(account, split_list)

      assert ^message = :cannot_send_to_the_same
    end

    test "Not should be able to verify if insert a invalid account id", %{list: split_list} do
      {:error, message} = FinHelper.transfer_have_account_from("account id", split_list)

      assert ^message = :invalid_account_id_type
    end

    test "Not should be able to verify if insert a invalid account id_to", %{account_id: account} do
      {:error, message} = FinHelper.transfer_have_account_from(account, "split_list")

      assert ^message = :invalid_account_id_type
    end
  end

  describe "percent_ok/1" do
    setup do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      :ok = Sandbox.checkout(FinancialSystem.Repo)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      {_, account3} = FinancialSystem.create("Inu Yasha", "BRL", "5")

      list_to = [
        %FinancialSystem.Split{account: account.id, percent: 20},
        %FinancialSystem.Split{account: account3.id, percent: 80}
      ]

      list_to_false = [
        %FinancialSystem.Split{account: account.id, percent: 30},
        %FinancialSystem.Split{account: account3.id, percent: 80}
      ]

      {:ok, [list: list_to, list_false: list_to_false]}
    end

    test "Should be able to verify if in split list the total percent is 100", %{
      list: split_list
    } do
      assert {:ok, true} = FinHelper.percent_ok(split_list)
    end

    test "Not should be able to do a split if the total percent is less than 100", %{
      list_false: split_list
    } do
      {:error, message} = FinHelper.percent_ok(split_list)

      assert ^message = :invalid_total_percent
    end

    test "Not should be able to verify if insert a invalid list" do
      {:error, message} = FinHelper.percent_ok("split_list")

      assert ^message = :invalid_split_list_type
    end
  end

  describe "unite_equal_account_split/1" do
    setup do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      :ok = Sandbox.checkout(FinancialSystem.Repo)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      list_to = [
        %FinancialSystem.Split{account: account.id, percent: 20},
        %FinancialSystem.Split{account: account.id, percent: 80}
      ]

      {:ok, [account_id: account.id, list: list_to]}
    end

    test "Should be able to verify if have a duplicated account in split list and unity it.",
         %{account_id: account, list: split_list} do
      {_, list_return} = FinHelper.unite_equal_account_split(split_list)
      list_return_simulate = [%FinancialSystem.Split{account: account, percent: 100}]

      assert list_return_simulate == list_return
    end

    test "Not should be able to verify if inserting a invalid account id" do
      {:error, message} = FinHelper.unite_equal_account_split("split_list")

      assert ^message = :invalid_split_list_type
    end
  end
end
