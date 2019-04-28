defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  describe "create/3" do
    setup do
      struct = %FinancialSystem.Account{name: "Oliver Tsubasa", currency: "BRL", value: 100}
      struct2 = %FinancialSystem.Account{name: "Yashin Santos", currency: "BRL", value: 10}
      struct3 = %FinancialSystem.Account{name: "Inu Yasha", currency: "BRL", value: 0}

      {:ok, [struct: struct, struct2: struct2, struct3: struct3]}
    end

    test "User should be able to create a account with float value", %{struct2: struct} do
      {_, pid2} = FinancialSystem.create("Yashin Santos", "BRL", 0.10)
      assert GenServer.call(pid2, :get_data) == struct
    end

    test "User should be able to create a account with integer value", %{struct: struct} do
      {_, pid2} = FinancialSystem.create("Oliver Tsubasa", "BRL", 1)
      assert GenServer.call(pid2, :get_data) == struct
    end

    test "User should be able to create a account with low case currency", %{struct: struct} do
      {_, pid2} = FinancialSystem.create("Oliver Tsubasa", "brl", 1)
      assert GenServer.call(pid2, :get_data) == struct
    end

    test "User should be able to create a account with amount 0", %{struct3: struct} do
      {_, pid2} = FinancialSystem.create("Inu Yasha", "brl", 0)
      assert GenServer.call(pid2, :get_data) == struct
    end

    test "User dont should be able to create a account with a name is not a string" do
      assert_raise ArgumentError, "First and second args must be a string and third arg must be a number greater than 0.", fn ->
        FinancialSystem.create(1, "brll", 0)
      end
    end

    test "User dont should be able to create a account with a value less than 0" do
      assert_raise ArgumentError, "First and second args must be a string and third arg must be a number greater than 0.", fn ->
        FinancialSystem.create("Oliver Tsubasa", "brl", -1)
      end
    end

    test "User dont should be able to create a account with a value in string format" do
      assert_raise ArgumentError, "First and second args must be a string and third arg must be a number greater than 0.", fn ->
        FinancialSystem.create("Oliver Tsubasa", "brll", "0")
      end
    end

    test "User dont should be able to create a account with a invalid currency" do
      assert_raise ArgumentError, "The currency is not valid. Please, check it and try again.", fn ->
        FinancialSystem.create("Oliver Tsubasa", "brll", 0)
      end
    end
  end

  describe "show/1" do
    setup do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)

      {:ok, [account: pid]}
    end

    test "User should be able to see the value in account", %{account: pid} do
      assert FinancialSystem.show(pid) == Decimal.new(1) |> Decimal.round(2)
    end

    test "User dont should be able to see the value in account if pass a invalid pid" do
      assert_raise ArgumentError, "Please insert a valid PID", fn ->
        FinancialSystem.show("pid")
      end
    end
  end

  describe "deposit/3" do
    setup do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)

      on_exit(fn ->
        nil
      end)

      {:ok, [account: pid]}
    end

    test "User should be able to insert a integer value in a account", %{account: pid} do
      assert FinancialSystem.deposit(pid, "brl", 1).value == 200
    end

    test "User should be able to insert a float value in a account", %{account: pid} do
      assert FinancialSystem.deposit(pid, "brl", 1.0).value == 200
    end

    test "User not should be able to insert a string value in a account", %{account: pid} do
      assert_raise ArgumentError, "The first arg must be a pid and de second arg must be a number", fn ->
        FinancialSystem.deposit(pid, "brl", "1")
      end
    end

    test "User not should be able to make the deposit inserting a invalid pid" do
      assert_raise ArgumentError, "The first arg must be a pid and de second arg must be a number", fn ->
        FinancialSystem.deposit("pid", "brl", 1)
      end
    end

    test "User not should be able to make the deposit inserting a invalid currency", %{account: pid} do
      assert_raise ArgumentError, "The currency is not valid. Please, check it and try again.", fn ->
        FinancialSystem.deposit(pid, "brrl", 1)
      end
    end

    test "User not should be able to make the deposit inserting a value equal or less than 0", %{account: pid} do
      assert_raise ArgumentError, "The first arg must be a pid and de second arg must be a number", fn ->
        FinancialSystem.deposit(pid, "brl", -1)
      end
    end
  end

  describe "withdraw/2" do
    setup do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)

      on_exit(fn ->
        nil
      end)

      {:ok, [account: pid]}
    end

    test "User should be able to take a value of an account", %{account: pid} do
      assert FinancialSystem.withdraw(pid, 1).value == 0
    end

    test "User not should be able to make the withdraw inserting a invalid pid" do
      assert_raise ArgumentError, "The first arg must be a pid and de second arg must be a number", fn ->
        FinancialSystem.withdraw("pid", 1)
      end
    end

    test "User not should be able to make the withdraw inserting a value equal or less than 0", %{account: pid} do
      assert_raise ArgumentError, "The first arg must be a pid and de second arg must be a number", fn ->
        FinancialSystem.withdraw(pid, -1)
      end
    end

    test "User not should be able to make the withdraw inserting a string value", %{account: pid} do
      assert_raise ArgumentError, "The first arg must be a pid and de second arg must be a number", fn ->
        FinancialSystem.withdraw(pid, "1")
      end
    end
  end

  describe "transfer/3" do
    setup do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)
      {_, pid2} = FinancialSystem.create("Oliver Tsubasa", "BRL", 2)

      on_exit(fn ->
        nil
      end)

      {:ok, [account: pid, account2: pid2]}
    end

    test "User should be able to transfer value between accounts", %{account: pid_from, account2: pid_to} do
      FinancialSystem.transfer(1, pid_from, pid_to)
      assert FinancialSystem.show(pid_from) == Decimal.new(0) |> Decimal.round(2)
      assert FinancialSystem.show(pid_to) == Decimal.new(3) |> Decimal.round(2)
    end


    test "User not should be able to make the transfer inserting a invalid pid_from", %{account2: pid_to} do
      assert_raise ArgumentError, "The second and third args must be a pid and de first arg must be a number", fn ->
        FinancialSystem.transfer(1, "pid_from", pid_to)
      end
    end

    test "User not should be able to make the transfer inserting a invalid pid_to", %{account: pid_from} do
      assert_raise ArgumentError, "The second and third args must be a pid and de first arg must be a number", fn ->
        FinancialSystem.transfer(1, pid_from, "pid_to")
      end
    end

    test "User not should be able to make the transfer inserting a value equal or less than 0", %{account: pid_from, account2: pid_to} do
      assert_raise ArgumentError, "The second and third args must be a pid and de first arg must be a number", fn ->
        FinancialSystem.transfer(-1, pid_from, pid_to)
      end
    end
  end

  describe "split/3" do
    setup do
      {_, pid} = FinancialSystem.create("Yashin Santos", "BRL", 1)
      {_, pid2} = FinancialSystem.create("Oliver Tsubasa", "BRL", 2)
      {_, pid3} = FinancialSystem.create("Inu Yasha", "BRL", 5)

      list_to = [
        %FinancialSystem.Split{account: pid, percent: 20},
        %FinancialSystem.Split{account: pid3, percent: 80},
      ]

      on_exit(fn ->
        nil
      end)

      {:ok, [account: pid, account2: pid2, account3: pid3, list: list_to]}
    end

    test "User should be able to transfer a value between multiple accounts", %{account: pid, list: split_list, account3: pid3, account2: pid2} do
    FinancialSystem.split(pid2, split_list, 1)
    assert FinancialSystem.show(pid2) == Decimal.new(1) |> Decimal.round(2)
    assert FinancialSystem.show(pid3) == Decimal.from_float(5.80) |> Decimal.round(2)
    assert FinancialSystem.show(pid) == Decimal.from_float(1.20) |> Decimal.round(2)
    end

    test "User not should be able to make the transfer to the same account are sending", %{account: pid_from, list: split_list} do
      assert_raise ArgumentError, "You can not send to the same account as you are sending", fn ->
        FinancialSystem.split(pid_from,  split_list, 1)
      end
    end

    test "User not should be able to make the transfer value less than 0", %{account: pid_from, list: split_list} do
      assert_raise ArgumentError, "The first arg must be a pid, the second must be a list with %SplitDefinition{} and the third must be a value.", fn ->
        FinancialSystem.split(pid_from,  split_list, -1)
      end
    end

    test "User not should be able to make the transfer value 0 or less than 0", %{account: pid_from, list: split_list} do
      assert_raise ArgumentError, "The first arg must be a pid, the second must be a list with %SplitDefinition{} and the third must be a value.", fn ->
        FinancialSystem.split(pid_from,  split_list, -1)
      end
    end

    test "User not should be able to make the transfer inserting a invalid pid", %{list: split_list} do
      assert_raise ArgumentError, "The first arg must be a pid, the second must be a list with %SplitDefinition{} and the third must be a value.", fn ->
        FinancialSystem.split("pid_from",  split_list, 1)
      end
    end
  end
end
