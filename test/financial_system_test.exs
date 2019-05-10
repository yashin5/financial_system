defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  describe "create/3" do
    setup do
      account_struct = %FinancialSystem.Account{
        name: "Oliver Tsubasa",
        currency: "BRL",
        value: 100
      }

      account_struct2 = %FinancialSystem.Account{
        name: "Yashin Santos",
        currency: "BRL",
        value: 10
      }

      account_struct3 = %FinancialSystem.Account{name: "Inu Yasha", currency: "BRL", value: 0}

      {:ok,
       [
         account_struct: account_struct,
         account_struct2: account_struct2,
         account_struct3: account_struct3
       ]}
    end

    test "User should be able to create a account with value number in string type", %{
      account_struct2: account_struct
    } do
      {_, pid2} = FinancialSystem.create("Yashin Santos", "BRL", "0.10")

      assert GenServer.call(pid2, :get_data) == account_struct
    end

    test "User should be able to create a account with low case currency", %{
      account_struct: account_struct
    } do
      {_, pid2} = FinancialSystem.create("Oliver Tsubasa", "brl", "1")

      assert GenServer.call(pid2, :get_data) == account_struct
    end

    test "User should be able to create a account with amount 0", %{
      account_struct3: account_struct
    } do
      {_, pid2} = FinancialSystem.create("Inu Yasha", "brl", "0")
      assert GenServer.call(pid2, :get_data) == account_struct
    end

    test "User dont should be able to create a account with a name is not a string" do
      {:error, message} = FinancialSystem.create(1, "brll", "0")

      assert ^message =
               "First and second args must be a string and third arg must be a number in type string greater than 0."
    end

    test "User dont should be able to create a account with a value less than 0" do
      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brl", "-1")

      assert ^message = "The value must be greater or equal to 0."
    end

    test "User dont should be able to create a account with a value in integer format" do
      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brl", 10)

      assert ^message =
               "First and second args must be a string and third arg must be a number in type string greater than 0."
    end

    test "User dont should be able to create a account without a name" do
      {:error, message} = FinancialSystem.create("", "BRL", 10)

      assert ^message =
               "First and second args must be a string and third arg must be a number in type string greater than 0."
    end

    test "User dont should be able to create a account with a value in float format" do
      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brl", 10.0)

      assert ^message =
               "First and second args must be a string and third arg must be a number in type string greater than 0."
    end

    test "User dont should be able to create a account with a invalid currency" do
      {:error, message} = FinancialSystem.create("Oliver Tsubasa", "brll", "0")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end
  end

  describe "show/1" do
    setup do
      {_, account_pid} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      {:ok, [account_pid: account_pid]}
    end

    test "User should be able to see the value in account", %{account_pid: pid} do
      assert FinancialSystem.show(pid) == "1.00"
    end

    test "User dont should be able to see the value in account if pass a invalid pid" do
      assert_raise ArgumentError, "Please insert a valid PID.", fn ->
        FinancialSystem.show("pid")
      end
    end
  end

  describe "deposit/3" do
    setup do
      {_, account_pid} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      on_exit(fn ->
        nil
      end)

      {:ok, [account_pid: account_pid]}
    end

    test "User should be able to insert a value number in string type", %{account_pid: pid} do
      {:ok, account} = FinancialSystem.deposit(pid, "brl", "1")
      assert account.value == 200
    end

    test "User not should be able to insert a integer value in a account", %{account_pid: pid} do
      {:error, message} = FinancialSystem.deposit(pid, "brl", 1)

      assert ^message =
               "The first arg must be a pid and de second arg must be a number in type string."
    end

    test "User not should be able to insert a float value in a account", %{account_pid: pid} do
      {:error, message} = FinancialSystem.deposit(pid, "brl", 1.0)

      assert ^message =
               "The first arg must be a pid and de second arg must be a number in type string."
    end

    test "User not should be able to make the deposit inserting a invalid pid" do
      {:error, message} = FinancialSystem.deposit("pid", "brl", "1")

      assert ^message =
               "The first arg must be a pid and de second arg must be a number in type string."
    end

    test "User not should be able to make the deposit inserting a invalid currency", %{
      account_pid: pid
    } do
      {:error, message} = FinancialSystem.deposit(pid, "brrl", "1")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end

    test "User not should be able to make the deposit inserting a value equal or less than 0", %{
      account_pid: pid
    } do
      {:error, message} = FinancialSystem.deposit(pid, "brl", "-1")

      assert ^message = "The value must be greater or equal to 0."
    end
  end

  describe "withdraw/2" do
    setup do
      {_, account_pid} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      on_exit(fn ->
        nil
      end)

      {:ok, [account_pid: account_pid]}
    end

    test "User should be able to take a value of an account inserting a value number in string type",
         %{account_pid: pid} do
      {:ok, account} = FinancialSystem.withdraw(pid, "1")

      assert account.value == 0
    end

    test "User not should be able to make the withdraw inserting a invalid pid" do
      {:error, message} = FinancialSystem.withdraw("pid", "1")

      assert ^message =
               "The first arg must be a pid and de second arg must be a number in type string."
    end

    test "User not should be able to make the withdraw inserting a value equal or less than 0", %{
      account_pid: pid
    } do
      {:error, message} = FinancialSystem.withdraw(pid, "-1")

      assert ^message = "The value must be greater or equal to 0."
    end

    test "User not should be able to make the withdraw inserting a integer value", %{
      account_pid: pid
    } do
      {:error, message} = FinancialSystem.withdraw(pid, 1)

      assert ^message =
               "The first arg must be a pid and de second arg must be a number in type string."
    end

    test "User not should be able to make the withdraw inserting a float value", %{
      account_pid: pid
    } do
      {:error, message} = FinancialSystem.withdraw(pid, 1.0)

      assert ^message =
               "The first arg must be a pid and de second arg must be a number in type string."
    end
  end

  describe "transfer/3" do
    setup do
      {_, account_pid} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      {_, account_pid2} = FinancialSystem.create("Oliver Tsubasa", "BRL", "2")

      on_exit(fn ->
        nil
      end)

      {:ok, [account_pid: account_pid, account2_pid: account_pid2]}
    end

    test "User should be able to transfer value between accounts inserting a value number in string type",
         %{
           account_pid: pid_from,
           account2_pid: pid_to
         } do
      FinancialSystem.transfer("1", pid_from, pid_to)
      assert FinancialSystem.show(pid_from) == "0.00"
      assert FinancialSystem.show(pid_to) == "3.00"
    end

    test "User not should be able to make the transfer inserting a invalid pid_from", %{
      account2_pid: pid_to
    } do
      {:error, message} = FinancialSystem.transfer("1", "pid_from", pid_to)

      assert ^message =
               "The first arg must be a number in type string and the second and third args must be a pid."
    end

    test "User not should be able to make the transfer inserting a invalid pid_to", %{
      account_pid: pid_from
    } do
      {:error, message} = FinancialSystem.transfer("1", pid_from, "pid_to")

      assert ^message =
               "The first arg must be a number in type string and the second and third args must be a pid."
    end

    test "User not should be able to make the transfer inserting a number in integer type", %{
      account_pid: pid_from,
      account2_pid: pid_to
    } do
      {:error, message} = FinancialSystem.transfer(1, pid_from, pid_to)

      assert ^message =
               "The first arg must be a number in type string and the second and third args must be a pid."
    end

    test "User not should be able to make the transfer inserting a number in float type", %{
      account_pid: pid_from,
      account2_pid: pid_to
    } do
      {:error, message} = FinancialSystem.transfer(1.0, pid_from, pid_to)

      assert ^message =
               "The first arg must be a number in type string and the second and third args must be a pid."
    end

    test "User not should be able to make the transfer inserting a value equal or less than 0", %{
      account_pid: pid_from,
      account2_pid: pid_to
    } do
      {:error, message} = FinancialSystem.transfer("-1", pid_from, pid_to)

      assert ^message = "The value must be greater or equal to 0."
    end
  end

  describe "split/3" do
    setup do
      {_, account_pid} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      {_, account_pid2} = FinancialSystem.create("Oliver Tsubasa", "BRL", "2")
      {_, account_pid3} = FinancialSystem.create("Inu Yasha", "BRL", "5")

      list_to = [
        %FinancialSystem.Split{account: account_pid, percent: 20},
        %FinancialSystem.Split{account: account_pid3, percent: 80}
      ]

      on_exit(fn ->
        nil
      end)

      {:ok,
       [
         account_pid: account_pid,
         account2_pid: account_pid2,
         account3_pid: account_pid3,
         list: list_to
       ]}
    end

    test "User should be able to transfer a value between multiple accounts inserting a value number in string type",
         %{
           account_pid: pid,
           list: split_list,
           account3_pid: pid3,
           account2_pid: pid2
         } do
      FinancialSystem.split(pid2, split_list, "1")
      assert FinancialSystem.show(pid2) == "1.00"
      assert FinancialSystem.show(pid3) == "5.80"
      assert FinancialSystem.show(pid) == "1.20"
    end

    test "User not should be able to make the transfer to the same account are sending", %{
      account_pid: pid_from,
      list: split_list
    } do
      {:error, message} = FinancialSystem.split(pid_from, split_list, "1")

      assert ^message = "You can not send to the same account as you are sending"
    end

    test "User not should be able to make the transfer value less than 0", %{
      account2_pid: pid_from,
      list: split_list
    } do
      {:error, message} = FinancialSystem.split(pid_from, split_list, "-1")

      assert ^message = "The value must be greater or equal to 0."
    end

    test "User not should be able to make the transfer inserting a invalid pid", %{
      list: split_list
    } do
      {:error, message} = FinancialSystem.split("pid_from", split_list, "1")

      assert ^message =
               "The first arg must be a pid, the second must be a list with %Split{} and the third must be a number in type string."
    end

    test "User not should be able to make the transfer inserting a number in integer type", %{
      account_pid: pid_from,
      list: split_list
    } do
      {:error, message} = FinancialSystem.split(pid_from, split_list, 1)

      assert ^message =
               "The first arg must be a pid, the second must be a list with %Split{} and the third must be a number in type string."
    end

    test "User not should be able to make the transfer inserting a number in float type", %{
      account_pid: pid_from,
      list: split_list
    } do
      {:error, message} = FinancialSystem.split(pid_from, split_list, 1.0)

      assert ^message =
               "The first arg must be a pid, the second must be a list with %Split{} and the third must be a number in type string."
    end
  end
end
