defmodule AccountOperationsTest do
  use ExUnit.Case, async: true

  import Mox
  setup :verify_on_exit!

  doctest FinancialSystem.AccountOperations

  describe "register_account/1" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(FinancialSystem.Repo)
    end

    test "Should be able to registry a account into system" do
      {:ok, account} =
        %FinancialSystem.Accounts.AccountsRepo{
          name: "Yashin Santos",
          currency: "BRL",
          value: 100,
          id: UUID.uuid4()
        }
        |> FinancialSystem.AccountOperations.register_account()

      account_actual_state = FinancialSystem.AccountOperations.show(account.id)

      assert account_actual_state == account
    end

    test "Not should be able to registry if the arg not be a %Account struct" do
      {:error, message} = FinancialSystem.AccountOperations.register_account("error")

      assert ^message = :invalid_arguments_type
    end
  end

  describe "delete/1" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(FinancialSystem.Repo)
    end

    test "Should be able to delete an account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      {:ok, message} = FinancialSystem.AccountOperations.delete_account(account.id)

      assert ^message = :account_deleted
    end

    test "Not should be able to delete if the id dont be in string type" do
      {:error, message} = FinancialSystem.AccountOperations.delete_account(1)

      assert ^message = :invalid_account_id_type
    end
  end

  describe "show/1" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(FinancialSystem.Repo)
    end

    test "Should be able to see the account state" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")
      actual_state = FinancialSystem.AccountOperations.show(account.id)

      account_id_when_created = account.id
      actual_id = actual_state.id

      assert actual_id == account_id_when_created
    end
  end

  describe "withdraw/2" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(FinancialSystem.Repo)
    end

    test "Should be able to subtract a value from account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      FinancialSystem.AccountOperations.withdraw(account.id, 1)

      value = FinancialSystem.AccountOperations.show(account.id).value

      assert value == 99
    end
  end

  describe "deposit/2" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(FinancialSystem.Repo)
    end

    test "Should be able to subtract a value from account" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "1")

      FinancialSystem.AccountOperations.deposit(account.id, 1)

      value = FinancialSystem.AccountOperations.show(account.id).value

      assert value == 101
    end
  end
end
