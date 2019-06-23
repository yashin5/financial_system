defmodule FinancialSystem.AccountOperations do
  @moduledoc """
  This module is responsable for keep and managing the accounts state.
  """
  import Ecto.Query, only: [from: 2]

  alias FinancialSystem.{Accounts.Account, Accounts.Transaction, Repo}

  @doc """
    Register the account in system.

  ## Examples
    account_struct = %FinancialSystem.Accounts.Account{name: "Oliver Tsubasa", currency: "BRL", value: 100 }

    FinancialSystem.AccountRepository.register_account(account_struct)
  """
  def register_account(%Account{} = account) do
    account
    |> Account.changeset()
    |> Repo.insert()
    |> do_register_account()
  end

  def register_account(_), do: {:error, :invalid_arguments_type}

  defp do_register_account({:ok, result}), do: {:ok, result}

  @doc """
    Delete an account from system.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountRepository.delete_account(account)
  """
  def delete_account(%Account{} = account) do
    account
    |> Repo.delete()
    |> do_delete_account()
  end

  def delete_account(_), do: {:error, :invalid_account_type}

  defp do_delete_account({:ok, _}), do: {:ok, :account_deleted}

  @doc """
    Checks if the account exists.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountOperations.find_account(account.id)
  """
  @spec find_account(String.t()) :: {:ok, Account.t()} | {:error, atom()}
  def find_account(account_id) when is_binary(account_id) do
    Account
    |> Repo.get(account_id)
    |> do_find_account()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_account_id_type}
  end

  defp do_find_account(nil), do: {:error, :account_dont_exist}

  defp do_find_account(account), do: {:ok, account}

  @doc """
    Subtracts value in  operations.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountOperations.subtract_value_in_balance(account, 100, "withdraw")
  """
  @spec subtract_value_in_balance(Account.t(), pos_integer(), String.t()) ::
          Account.t() | no_return()
  def subtract_value_in_balance(%Account{id: id} = account, value, operation)
      when is_integer(value) and value > 0 do
    save_transaction(account, value, operation)

    id
    |> calculate_balance(value * -1)
    |> make_operation(account)
  end

  @doc """
    Sum value in operations.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountOperations.sum_value_in_balance(account, 100, "deposit")
  """
  @spec sum_value_in_balance(Account.t(), integer(), String.t()) :: Account.t() | no_return()
  def sum_value_in_balance(%Account{id: id} = account, value, operation)
      when is_integer(value) and value > 0 do
    save_transaction(account, value, operation)

    id
    |> calculate_balance(value)
    |> make_operation(account)
  end

  defp make_operation(value, account) do
    Repo.transaction(fn ->
      account
      |> Account.changeset(%{value: value})
      |> Repo.update()
    end)

    {_, account_actual_state} = find_account(account.id)

    account_actual_state
  end

  defp save_transaction(account, value, operation) do
    query = Ecto.build_assoc(account, :transactions, %{value: value, operation: operation})

    query
    |> Transaction.changeset()
    |> Repo.insert()
  end

  defp calculate_balance(account_id, value) do
    query =
      from(u in Account,
        where: u.id == type(^account_id, :binary_id),
        select: u.value + type(^value, :integer),
        limit: 1
      )

    Repo.one(query)
  end

  @doc """
    Show the transactions from account.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.deposit(account.id, "brl", "1")

    FinancialSystem.AccountOperations.show_financial_statement(account.id)
  """
  @spec show_financial_statement(String.t()) :: Transaction.t() | no_return()
  def show_financial_statement(id, order \\ :desc) when is_binary(id) do
    query =
      from(u in "transactions",
        where: u.account_id == type(^id, :binary_id),
        select: [:operation, :value, :inserted_at],
        order_by: [{^order, :inserted_at}]
      )

    FinancialSystem.Repo.all(query)
  end
end
