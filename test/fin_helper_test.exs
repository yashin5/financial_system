defmodule FinHelperTest do
  use ExUnit.Case

  import Mox
  setup :verify_on_exit!

  doctest FinancialSystem.FinHelper

  describe "funds/2" do
    setup do
      expect(CurrencyRequestMock, :load_from_config, 4, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Roberta Santos", "BRL", "20.0")

      {:ok, [account_id: account.account_id]}
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
      {:error, message} = FinancialSystem.FinHelper.funds(account, "10")

      assert ^message = "Check the account ID and de value."
    end

    test "Not should be able to verify when inserting a invalid pid" do
      {:error, message} = FinancialSystem.FinHelper.funds("pid", 10)

      assert ^message = "The account pid dont exist"
    end
  end

  describe "transfer_have_account_from/2" do
    setup do
      expect(CurrencyRequestMock, :load_from_config, 12, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      {_, account2} = FinancialSystem.create("Oliver Tsubasa", "BRL", "2")
      {_, account3} = FinancialSystem.create("Inu Yasha", "BRL", "5")

      list_to = [
        %FinancialSystem.Split{account: account.account_id, percent: 20},
        %FinancialSystem.Split{account: account3.account_id, percent: 80}
      ]

      {:ok,
       [
         account_id: account.account_id,
         account2_id: account2.account_id,
         account3_id: account3.account_id,
         list: list_to
       ]}
    end

    test "Should be able to verify if in split list not have the same account is sending the value",
         %{account2_id: account, list: split_list} do
      assert {:ok, true} =
               FinancialSystem.FinHelper.transfer_have_account_from(account, split_list)
    end

    test "Should be able to verify if in transfer not have the same account is sending the value",
         %{account2_id: account2, account_id: account} do
      assert {:ok, true} = FinancialSystem.FinHelper.transfer_have_account_from(account, account2)
    end

    test "Should be able to verify if in transfer have the same account is sending the value",
         %{account_id: account} do
      {:error, message} = FinancialSystem.FinHelper.transfer_have_account_from(account, account)

      assert ^message = "You can not send to the same account as you are sending"
    end

    test "Should be able to verify if in split list have the same account is sending the value",
         %{account_id: account, list: split_list} do
      {:error, message} =
        FinancialSystem.FinHelper.transfer_have_account_from(account, split_list)

      assert ^message = "You can not send to the same account as you are sending"
    end

    test "Not should be able to verify if insert a invalid pid", %{list: split_list} do
      {:error, message} = FinancialSystem.FinHelper.transfer_have_account_from("pid", split_list)

      assert ^message = "The account pid dont exist"
    end

    test "Not should be able to verify if insert a invalid pid_to", %{account_id: account} do
      {:error, message} =
        FinancialSystem.FinHelper.transfer_have_account_from(account, "split_list")

      assert ^message = "The account split_list dont exist"
    end
  end

  describe "percent_ok/1" do
    setup do
      expect(CurrencyRequestMock, :load_from_config, 8, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      {_, account3} = FinancialSystem.create("Inu Yasha", "BRL", "5")

      list_to = [
        %FinancialSystem.Split{account: account.account_id, percent: 20},
        %FinancialSystem.Split{account: account3.account_id, percent: 80}
      ]

      list_to_false = [
        %FinancialSystem.Split{account: account.account_id, percent: 30},
        %FinancialSystem.Split{account: account3.account_id, percent: 80}
      ]

      {:ok, [list: list_to, list_false: list_to_false]}
    end

    test "Should be able to verify if in split list the total percent is 100", %{
      list: split_list
    } do
      assert {:ok, true} = FinancialSystem.FinHelper.percent_ok(split_list)
    end

    test "Not should be able to do a split if the total percent is less than 100", %{
      list_false: split_list
    } do
      {:error, message} = FinancialSystem.FinHelper.percent_ok(split_list)

      assert ^message = "The total percent must be 100."
    end

    test "Not should be able to verify if insert a invalid list" do
      {:error, message} = FinancialSystem.FinHelper.percent_ok("split_list")

      assert ^message = "Check if the split list is valid."
    end
  end

  describe "unite_equal_account_split/1" do
    setup do
      expect(CurrencyRequestMock, :load_from_config, 4, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account_pid} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      list_to = [
        %FinancialSystem.Split{account: account_pid, percent: 20},
        %FinancialSystem.Split{account: account_pid, percent: 80}
      ]

      {:ok, [account_pid: account_pid, list: list_to]}
    end

    test "Should be able to verify if have a duplicated account in split list and unity it.",
         %{account_pid: pid, list: split_list} do
      {_, list_return} = FinancialSystem.FinHelper.unite_equal_account_split(split_list)
      list_return_simulate = [%FinancialSystem.Split{account: pid, percent: 100}]

      assert list_return_simulate == list_return
    end

    test "Not should be able to verify if inserting a invalid pid" do
      {:error, message} = FinancialSystem.FinHelper.unite_equal_account_split("split_list")

      assert ^message = "Check if the split list is valid."
    end
  end
end
