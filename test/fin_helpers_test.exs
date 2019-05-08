defmodule FinHelperTest do
  use ExUnit.Case
  doctest FinancialSystem.FinHelper

  describe "funds/2" do
    setup do
      {_, account_pid} = FinancialSystem.create("Roberta Santos", "EUR", "20.0")

      {:ok, [account_pid: account_pid]}
    end

    test "User should be able to verify if the account have de funds necessary for the transaction inserting a integer value",
         %{account_pid: pid} do
      assert {:ok, true} = FinancialSystem.FinHelper.funds(pid, 10)
    end

    test "User should be able to verify if the account have de funds necessary for the transaction inserting a float value",
         %{account_pid: pid} do
      assert {:ok, true} = FinancialSystem.FinHelper.funds(pid, 20.0)
    end

    test "User not should be able to verify when inserting a string in value", %{account_pid: pid} do
      {:error, message} = FinancialSystem.FinHelper.funds(pid, "10")

      assert ^message = "Check the pid and de value."
    end

    test "User not should be able to verify when inserting a invalid pid" do
      {:error, message} = FinancialSystem.FinHelper.funds("pid", 10)

      assert ^message = "Check the pid and de value."
    end
  end

  describe "transfer_have_account_from/2" do
    setup do
      {_, account_pid} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      {_, account_pid2} = FinancialSystem.create("Oliver Tsubasa", "BRL", "2")
      {_, account_pid3} = FinancialSystem.create("Inu Yasha", "BRL", "5")

      list_to = [
        %FinancialSystem.Split{account: account_pid, percent: 20},
        %FinancialSystem.Split{account: account_pid3, percent: 80}
      ]

      {:ok,
       [
         account_pid: account_pid,
         account2_pid: account_pid2,
         account3_pid: account_pid3,
         list: list_to
       ]}
    end

    test "User should be able to verify if in split list not have the same account is sending the value",
         %{account2_pid: pid, list: split_list} do
      assert {:ok, true} = FinancialSystem.FinHelper.transfer_have_account_from(pid, split_list)
    end

    test "User should be able to verify if in transfer not have the same account is sending the value",
         %{account2_pid: pid2, account_pid: pid} do
      assert {:ok, true} = FinancialSystem.FinHelper.transfer_have_account_from(pid, pid2)
    end

    test "User should be able to verify if in transfer have the same account is sending the value",
         %{account_pid: pid} do
      assert_raise ArgumentError, "You can not send to the same account as you are sending", fn ->
        FinancialSystem.FinHelper.transfer_have_account_from(pid, pid)
      end
    end

    test "User should be able to verify if in split list have the same account is sending the value",
         %{account_pid: pid, list: split_list} do
      assert_raise ArgumentError, "You can not send to the same account as you are sending", fn ->
        FinancialSystem.FinHelper.transfer_have_account_from(pid, split_list)
      end
    end

    test "User not should be able to verify if insert a invalid pid", %{list: split_list} do
      assert_raise ArgumentError,
                   "First arg must be a pid and second arg must be a pid or a Split struct",
                   fn ->
                     FinancialSystem.FinHelper.transfer_have_account_from("pid", split_list)
                   end
    end

    test "User not should be able to verify if insert a invalid pid_to", %{account_pid: pid} do
      assert_raise ArgumentError,
                   "First arg must be a pid and second arg must be a pid or a Split struct",
                   fn ->
                     FinancialSystem.FinHelper.transfer_have_account_from(pid, "split_list")
                   end
    end
  end

  describe "percent_ok/1" do
    setup do
      {_, account_pid} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      {_, account_pid3} = FinancialSystem.create("Inu Yasha", "BRL", "5")

      list_to = [
        %FinancialSystem.Split{account: account_pid, percent: 20},
        %FinancialSystem.Split{account: account_pid3, percent: 80}
      ]

      list_to_false = [
        %FinancialSystem.Split{account: account_pid, percent: 30},
        %FinancialSystem.Split{account: account_pid3, percent: 80}
      ]

      {:ok, [list: list_to, list_false: list_to_false]}
    end

    test "User should be able to verify if in split list the total percent is 100", %{
      list: split_list
    } do
      assert {:ok, true} = FinancialSystem.FinHelper.percent_ok(split_list)
    end

    test "User not should be able to do a split if the total percent is less than 100", %{
      list_false: split_list
    } do
      assert_raise ArgumentError, "The total percent must be 100.", fn ->
        FinancialSystem.FinHelper.percent_ok(split_list)
      end
    end

    test "User not should be able to verify if insert a invalid list" do
      assert_raise ArgumentError, "Check if the split list is valid.", fn ->
        FinancialSystem.FinHelper.percent_ok("split_list")
      end
    end
  end

  describe "unite_equal_account_split/1" do
    setup do
      {_, account_pid} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      list_to = [
        %FinancialSystem.Split{account: account_pid, percent: 20},
        %FinancialSystem.Split{account: account_pid, percent: 80}
      ]

      {:ok, [account_pid: account_pid, list: list_to]}
    end

    test "User should be able to verify if have a duplicated account in split list and unity it.",
         %{account_pid: pid, list: split_list} do
      assert [%FinancialSystem.Split{account: pid, percent: 100}] ==
               FinancialSystem.FinHelper.unite_equal_account_split(split_list)
    end

    test "User not should be able to verify if inserting a invalid pid" do
      assert_raise ArgumentError, "Check if the split list is valid.", fn ->
        FinancialSystem.FinHelper.unite_equal_account_split("split_list")
      end
    end
  end
end
