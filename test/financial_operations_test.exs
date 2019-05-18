defmodule FinancialOperationsTest do
  use ExUnit.Case, async: true

  import Mox
  setup :verify_on_exit!

  doctest FinancialSystem.FinancialOperations

  describe "show/1" do
    test "User should be able to see the value in account" do
      expect(CurrencyRequestMock, :load_from_config, 7, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      {_, account_value} = FinancialSystem.show(account.account_id)

      assert account_value == "1.00"
    end

    test "User dont should be able to see the value in account if pass a invalid pid" do
      {:error, message} = FinancialSystem.show("account")

      assert ^message = "The account account dont exist"
    end
  end

  describe "deposit/3" do
    setup do
      expect(CurrencyRequestMock, :load_from_config, 4, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      on_exit(fn ->
        nil
      end)

      {:ok, [account: account.account_id]}
    end

    test "User should be able to insert a value number in string type", %{account: account} do
      expect(CurrencyRequestMock, :load_from_config, 9, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account_actual_state} = FinancialSystem.deposit(account, "brl", "1")

      account_actual_value = account_actual_state.value

      assert account_actual_value == 200
    end

    test "User not should be able to insert a integer value in a account", %{account: account} do
      {:error, message} = FinancialSystem.deposit(account, "brl", 1)

      assert ^message =
               "The first arg must be a account ID and de second arg must be a number in type string."
    end

    test "User not should be able to insert a float value in a account", %{account: account} do
      {:error, message} = FinancialSystem.deposit(account, "brl", 1.0)

      assert ^message =
               "The first arg must be a account ID and de second arg must be a number in type string."
    end

    test "User not should be able to make the deposit inserting a invalid pid" do
      {:error, message} = FinancialSystem.deposit("pid", "brl", "1")

      assert ^message = "The account pid dont exist"
    end

    test "User not should be able to make the deposit inserting a invalid currency", %{
      account: account
    } do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} = FinancialSystem.deposit(account, "brrl", "1")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end

    test "User not should be able to make the deposit inserting a value equal or less than 0", %{
      account: account
    } do
      expect(CurrencyRequestMock, :load_from_config, 9, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} = FinancialSystem.deposit(account, "brl", "-1")

      assert ^message = "The value must be greater or equal to 0."
    end
  end

  describe "withdraw/2" do
    setup do
      expect(CurrencyRequestMock, :load_from_config, 4, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      on_exit(fn ->
        nil
      end)

      {:ok, [account: account.account_id]}
    end

    test "User should be able to take a value of an account inserting a value number in string type",
         %{account: account} do
      expect(CurrencyRequestMock, :load_from_config, 3, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account_actual_state} = FinancialSystem.withdraw(account, "1")

      account_actual_value = account_actual_state.value

      assert account_actual_value == 0
    end

    test "User not should be able to make the withdraw inserting a invalid pid" do
      {:error, message} = FinancialSystem.withdraw("pid", "1")

      assert ^message = "The account pid dont exist"
    end

    test "User not should be able to make the withdraw inserting a value equal or less than 0", %{
      account: account
    } do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} = FinancialSystem.withdraw(account, "-1")

      assert ^message = "The value must be greater or equal to 0."
    end

    test "User not should be able to make the withdraw inserting a integer value", %{
      account: account
    } do
      {:error, message} = FinancialSystem.withdraw(account, 1)

      assert ^message =
               "The first arg must be a account ID and de second arg must be a number in type string."
    end

    test "User not should be able to make the withdraw inserting a float value", %{
      account: account
    } do
      {:error, message} = FinancialSystem.withdraw(account, 1.0)

      assert ^message =
               "The first arg must be a account ID and de second arg must be a number in type string."
    end
  end

  describe "transfer/3" do
    setup do
      expect(CurrencyRequestMock, :load_from_config, 8, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      {_, account2} = FinancialSystem.create("Oliver Tsubasa", "BRL", "2")

      on_exit(fn ->
        nil
      end)

      {:ok, [account_id: account.account_id, account2_id: account2.account_id]}
    end

    test "User should be able to transfer value between accounts inserting a value number in string type",
         %{
           account_id: account_id_from,
           account2_id: account2_id_to
         } do
      expect(CurrencyRequestMock, :load_from_config, 18, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      FinancialSystem.transfer("1", account_id_from, account2_id_to)

      {_, actual_value_from} = FinancialSystem.show(account_id_from)
      {_, actual_value_to} = FinancialSystem.show(account2_id_to)

      assert actual_value_from == "0.00"
      assert actual_value_to == "3.00"
    end

    test "User not should be able to make the transfer inserting a invalid pid_from", %{
      account2_id: account_id
    } do
      {:error, message} = FinancialSystem.transfer("1", "pid_from", account_id)

      assert ^message = "The account pid_from dont exist"
    end

    test "User not should be able to make the transfer inserting a invalid pid_to", %{
      account2_id: account_id
    } do
      {:error, message} = FinancialSystem.transfer("1", account_id, "pid_to")

      assert ^message = "The account pid_to dont exist"
    end

    test "User not should be able to make the transfer inserting a number in integer type", %{
      account_id: account_id_from,
      account2_id: account2_id_to
    } do
      {:error, message} = FinancialSystem.transfer(1, account_id_from, account2_id_to)

      assert ^message =
               "The first arg must be a number in type string and the second and third args must be a account ID."
    end

    test "User not should be able to make the transfer inserting a number in float type", %{
      account_id: account_id_from,
      account2_id: account2_id_to
    } do
      {:error, message} = FinancialSystem.transfer(1.0, account_id_from, account2_id_to)

      assert ^message =
               "The first arg must be a number in type string and the second and third args must be a account ID."
    end

    test "User not should be able to make the transfer inserting a value equal or less than 0", %{
      account_id: account_id_from,
      account2_id: account2_id_to
    } do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} = FinancialSystem.transfer("-1", account_id_from, account2_id_to)

      assert ^message = "The value must be greater or equal to 0."
    end
  end

  describe "split/3" do
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

      on_exit(fn ->
        nil
      end)

      {:ok,
       [
         account_id: account.account_id,
         account2_id: account2.account_id,
         account3_id: account3.account_id,
         list: list_to
       ]}
    end

    test "User should be able to transfer a value between multiple accounts inserting a value number in string type",
         %{
           account_id: account,
           list: split_list,
           account3_id: account3,
           account2_id: account2
         } do
      expect(CurrencyRequestMock, :load_from_config, 36, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      FinancialSystem.split(account2, split_list, "1")

      {_, actual_value_account} = FinancialSystem.show(account)
      {_, actual_value_account2} = FinancialSystem.show(account2)
      {_, actual_value_account3} = FinancialSystem.show(account3)

      assert actual_value_account2 == "1.00"
      assert actual_value_account3 == "5.80"
      assert actual_value_account == "1.20"
    end

    test "User not should be able to make the transfer to the same account are sending", %{
      account_id: account,
      list: split_list
    } do
      {:error, message} = FinancialSystem.split(account, split_list, "1")

      assert ^message = "You can not send to the same account as you are sending"
    end

    test "User not should be able to make the transfer value less than 0", %{
      account2_id: account,
      list: split_list
    } do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} = FinancialSystem.split(account, split_list, "-1")

      assert ^message = "The value must be greater or equal to 0."
    end

    test "User not should be able to make the transfer inserting a invalid pid", %{
      list: split_list
    } do
      {:error, message} = FinancialSystem.split("pid_from", split_list, "1")

      assert ^message = "The account pid_from dont exist"
    end

    test "User not should be able to make the transfer inserting a number in integer type", %{
      account_id: account,
      list: split_list
    } do
      {:error, message} = FinancialSystem.split(account, split_list, 1)

      assert ^message =
               "The first arg must be a account ID, the second must be a list with %Split{} and the third must be a number in type string."
    end

    test "User not should be able to make the transfer inserting a number in float type", %{
      account_id: account,
      list: split_list
    } do
      {:error, message} = FinancialSystem.split(account, split_list, 1.0)

      assert ^message =
               "The first arg must be a account ID, the second must be a list with %Split{} and the third must be a number in type string."
    end
  end
end
