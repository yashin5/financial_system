defmodule FinancialOperationsTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  setup :verify_on_exit!

  doctest FinancialSystem.Core.FinancialOperations

  describe "show/1" do
    test "Should be able to see the value in account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmaxxil.com",
          "password" => "f1aA678@"
        })

      {_, account_value} = FinancialSystem.Core.show(account.id)

      assert account_value == "1.00"
    end

    test "User dont should be able to see the value in account if pass a invalid account id" do
      {:error, message} = FinancialSystem.Core.show("account")

      assert ^message = :invalid_account_id_type
    end
  end

  describe "deposit/3" do
    setup do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmqweail.com",
          "password" => "f1aA678@"
        })

      on_exit(fn ->
        nil
      end)

      {:ok, [account: account.id]}
    end

    test "Should be able to insert a value number in string type", %{account: account} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account_actual_state} =
        FinancialSystem.Core.deposit(%{
          "account_id" => account,
          "currency" => "brl",
          "value" => "1"
        })

      account_actual_value = account_actual_state.value

      assert account_actual_value == 200
    end

    test "Not should be able to insert a integer value in a account", %{account: account} do
      {:error, message} =
        FinancialSystem.Core.deposit(%{
          "account_id" => account,
          "currency" => "brl",
          "value" => 1
        })

      assert ^message = :invalid_value_type
    end

    test "Not should be able to insert a float value in a account", %{account: account} do
      {:error, message} =
        FinancialSystem.Core.deposit(%{
          "account_id" => account,
          "currency" => "brl",
          "value" => 1.0
        })

      assert ^message = :invalid_value_type
    end

    test "Not should be able to make the deposit inserting a invalid account id" do
      {:error, message} =
        FinancialSystem.Core.deposit(%{
          "account_id" => "account",
          "currency" => "brl",
          "value" => "1"
        })

      assert ^message = :invalid_account_id_type
    end

    test "Not should be able to make the deposit inserting a invalid currency", %{
      account: account
    } do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:error, message} =
        FinancialSystem.Core.deposit(%{
          "account_id" => account,
          "currency" => "brrl",
          "value" => "1"
        })

      assert ^message = :currency_is_not_valid
    end

    test "Not should be able to make the deposit inserting a value equal or less than 0", %{
      account: account
    } do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:error, message} =
        FinancialSystem.Core.deposit(%{
          "account_id" => account,
          "currency" => "brl",
          "value" => "-1"
        })

      assert ^message = :invalid_value_less_than_0
    end
  end

  describe "withdraw/2" do
    setup do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmssail.com",
          "password" => "f1aA678@"
        })

      on_exit(fn ->
        nil
      end)

      {:ok, [account: account.id]}
    end

    test "Should be able to take a value of an account inserting a value number in string type",
         %{account: account} do
      {_, account_actual_state} =
        FinancialSystem.Core.withdraw(%{
          "account_id" => account,
          "value" => "1"
        })

      account_actual_value = account_actual_state.value

      assert account_actual_value == 0
    end

    test "Not should be able to make the withdraw inserting a invalid account id" do
      {:error, message} =
        FinancialSystem.Core.withdraw(%{
          "account_id" => "account",
          "value" => "1"
        })

      assert ^message = :invalid_account_id_type
    end

    test "Not should be able to make the withdraw inserting a value equal or less than 0", %{
      account: account
    } do
      {:error, message} =
        FinancialSystem.Core.withdraw(%{
          "account_id" => account,
          "value" => "-1"
        })

      assert ^message = :invalid_value_less_than_0
    end

    test "Not should be able to make the withdraw inserting a integer value", %{
      account: account
    } do
      {:error, message} =
        FinancialSystem.Core.withdraw(%{
          "account_id" => account,
          "value" => 1
        })

      assert ^message = :invalid_value_type
    end

    test "Not should be able to make the withdraw inserting a float value", %{
      account: account
    } do
      {:error, message} =
        FinancialSystem.Core.withdraw(%{
          "account_id" => account,
          "value" => 1.0
        })

      assert ^message = :invalid_value_type
    end
  end

  describe "transfer/3" do
    setup do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmaddil.com",
          "password" => "f1aA678@"
        })

      {_, account2} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Oliver Tsubasa",
          "currency" => "BRL",
          "value" => "2",
          "email" => "test@oufftlook.com",
          "password" => "f1aA678@"
        })

      on_exit(fn ->
        nil
      end)

      {:ok, [account_id: account.id, account2_id: account2.id]}
    end

    test "Should be able to transfer value between accounts inserting a value number in string type",
         %{
           account_id: account_id_from,
           account2_id: account2_id_to
         } do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      FinancialSystem.Core.transfer(%{
        "value" => "1",
        "account_from" => account_id_from,
        "account_to" => account2_id_to
      })

      {_, actual_value_from} = FinancialSystem.Core.show(account_id_from)
      {_, actual_value_to} = FinancialSystem.Core.show(account2_id_to)

      assert actual_value_from == "0.00"
      assert actual_value_to == "3.00"
    end

    test "Not should be able to make the transfer inserting a invalid account_id_from", %{
      account2_id: account_id
    } do
      {:error, message} =
        FinancialSystem.Core.transfer(%{
          "value" => "1",
          "account_from" => "account_id_from",
          "account_to" => account_id
        })

      assert ^message = :invalid_account_id_type
    end

    test "Not should be able to make the transfer inserting a invalid account_id_to", %{
      account2_id: account_id
    } do
      {:error, message} =
        FinancialSystem.Core.transfer(%{
          "value" => "1",
          "account_from" => account_id,
          "account_to" => "account2_id_to"
        })

      assert ^message = :invalid_account_id_type
    end

    test "Not should be able to make the transfer inserting a number in integer type", %{
      account_id: account_id_from,
      account2_id: account2_id_to
    } do
      {:error, message} =
        FinancialSystem.Core.transfer(%{
          "value" => 1,
          "account_from" => account_id_from,
          "account_to" => account2_id_to
        })

      assert ^message = :invalid_value_type
    end

    test "Not should be able to make the transfer inserting a number in float type", %{
      account_id: account_id_from,
      account2_id: account2_id_to
    } do
      {:error, message} =
        FinancialSystem.Core.transfer(%{
          "value" => 1.0,
          "account_from" => account_id_from,
          "account_to" => account2_id_to
        })

      assert ^message = :invalid_value_type
    end

    test "Not should be able to make the transfer inserting a value equal or less than 0", %{
      account_id: account_id_from,
      account2_id: account2_id_to
    } do
      {:error, message} =
        FinancialSystem.Core.transfer(%{
          "value" => "-1",
          "account_from" => account_id_from,
          "account_to" => account2_id_to
        })

      assert ^message = :invalid_value_less_than_0
    end
  end

  describe "split/3" do
    setup do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "testx@outlqqook.com",
          "password" => "f1aA678@"
        })

      {_, account2} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Oliver Tsubasa",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@wwgmail.com",
          "password" => "f1aA678@"
        })

      {_, account3} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Inu Yasha",
          "currency" => "BRL",
          "value" => "5",
          "email" => "test@yaheeoo.com",
          "password" => "f1aA678@"
        })

      list_to = [
        %{"account" => account.id, "percent" => 20},
        %{"account" => account3.id, "percent" => 80}
      ]

      on_exit(fn ->
        nil
      end)

      {:ok,
       [
         account_id: account.id,
         account2_id: account2.id,
         account3_id: account3.id,
         list: list_to
       ]}
    end

    test "Should be able to transfer a value between multiple accounts inserting a value number in string type",
         %{
           account_id: account,
           list: split_list,
           account3_id: account3,
           account2_id: account2
         } do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      FinancialSystem.Core.split(%{
        "account_from" => account2,
        "split_list" => split_list,
        "value" => "1"
      })

      {_, actual_value_account} = FinancialSystem.Core.show(account)
      {_, actual_value_account2} = FinancialSystem.Core.show(account2)
      {_, actual_value_account3} = FinancialSystem.Core.show(account3)

      assert actual_value_account2 == "0.00"
      assert actual_value_account3 == "5.80"
      assert actual_value_account == "1.20"
    end

    test "Not should be able to make the transfer to the same account are sending", %{
      account_id: account,
      list: split_list
    } do
      {:error, message} =
        FinancialSystem.Core.split(%{
          "account_from" => account,
          "split_list" => split_list,
          "value" => "1"
        })

      assert ^message = :cannot_send_to_the_same
    end

    test "Not should be able to make the transfer value less than 0", %{
      account2_id: account,
      list: split_list
    } do
      {:error, message} =
        FinancialSystem.Core.split(%{
          "account_from" => account,
          "split_list" => split_list,
          "value" => "-1"
        })

      assert ^message = :invalid_value_less_than_0
    end

    test "Not should be able to make the transfer inserting a invalid account id", %{
      list: split_list
    } do
      {:error, message} =
        FinancialSystem.Core.split(%{
          "account_from" => "account2",
          "split_list" => split_list,
          "value" => "1"
        })

      assert ^message = :invalid_account_id_type
    end

    test "Not should be able to make the transfer inserting a number in integer type", %{
      account_id: account,
      list: split_list
    } do
      {:error, message} =
        FinancialSystem.Core.split(%{
          "account_from" => account,
          "split_list" => split_list,
          "value" => 1
        })

      assert ^message = :invalid_value_type
    end

    test "Not should be able to make the transfer inserting a number in float type", %{
      account_id: account,
      list: split_list
    } do
      {:error, message} =
        FinancialSystem.Core.split(%{
          "account_from" => account,
          "split_list" => split_list,
          "value" => 1.0
        })

      assert ^message = :invalid_value_type
    end
  end

  describe "financial_statement/1" do
    test "Should be able to see the transactioned values" do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@asd.com",
          "password" => "f1aA678@"
        })

      FinancialSystem.Core.deposit(%{
        "account_id" => account.id,
        "currency" => "brl",
        "value" => "1"
      })

      {_, statement_struct} = FinancialSystem.Core.financial_statement(%{"id" => account.id})

      statement = statement_struct |> List.first()

      assert %{operation: "deposit", value: 100} = statement
    end

    test "Should not be able inserting a invalid account id type" do
      {_, message} = FinancialSystem.Core.financial_statement(%{"id" => 1})

      assert ^message = :invalid_account_id_type
    end

    test "Should not be able inserting a invalid account id" do
      {_, message} = FinancialSystem.Core.financial_statement(%{"id" => UUID.uuid4()})

      assert ^message = :account_dont_exist
    end
  end
end
